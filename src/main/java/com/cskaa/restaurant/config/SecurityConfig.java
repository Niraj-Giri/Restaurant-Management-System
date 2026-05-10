package com.cskaa.restaurant.config;

import com.cskaa.restaurant.config.JwtAuthFilter;
import com.cskaa.restaurant.service.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    @Autowired
    private JwtAuthFilter jwtFilter;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.csrf().disable()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()

                .antMatchers("/order-websocket/**").permitAll()
                .antMatchers("/js/**", "/css/**").permitAll()
                .antMatchers("/api/auth/**").permitAll()
                .antMatchers("/api/cart/**").permitAll()
                .antMatchers(HttpMethod.GET, "/api/restaurants/**").permitAll()
                .antMatchers("/api/restaurants/register-owner/**").permitAll()
                .antMatchers("/owner/login", "/owner/register").permitAll()
                .antMatchers("/admin/**").hasRole("ADMIN")
                .antMatchers("/owner/**").hasAnyRole("RESTAURANT_OWNER", "ADMIN")
                .antMatchers("/api/staff/**").hasRole("RESTAURANT_STAFF")
                .antMatchers("/api/orders/**").hasAnyRole("CUSTOMER", "RESTAURANT_OWNER", "RESTAURANT_STAFF")
                // jsp pages
                .antMatchers("/", "/home", "/about", "/contact", "/cart", "/menu", "/orders", "/orderDetails", "/login", "/register")
                .permitAll()

                .anyRequest().authenticated()
                .and()

                .userDetailsService(userDetailsService)
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
