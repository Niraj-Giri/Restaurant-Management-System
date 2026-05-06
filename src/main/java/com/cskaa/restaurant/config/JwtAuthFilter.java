package com.cskaa.restaurant.config;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.cskaa.restaurant.exception.JwtExpiredException;
import com.cskaa.restaurant.exception.JwtInvalidException;
import com.cskaa.restaurant.service.JwtService;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.FilterChain;
import javax.servlet.GenericFilter;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component
public class JwtAuthFilter extends GenericFilter {


	
	private static final long serialVersionUID = 1L;
	
	 @Autowired
	private JwtService jwtService;
	 

    
    @Autowired
    private ObjectMapper objectMapper; // Spring Boot auto-configures this


    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain) throws ServletException,IOException{
     	try {
     
    	HttpServletRequest req = (HttpServletRequest) request;

        String authHeader = req.getHeader("Authorization");

        if (authHeader != null && authHeader.startsWith("Bearer ")) {

            String token = authHeader.substring(7);

            String username = jwtService.extractUsername(token);
            List<String> roles = jwtService.extractRoles(token);

            var authorities = roles.stream()
                    .map(SimpleGrantedAuthority::new)
                    .toList();

            var auth = new UsernamePasswordAuthenticationToken(
                    username,
                    null,
                    authorities
            );

            SecurityContextHolder.getContext().setAuthentication(auth);
        }
    	}catch (JwtExpiredException e) {
            //Clear expired token cookie for better UX
           
            sendJsonError((HttpServletResponse)response, HttpServletResponse.SC_UNAUTHORIZED, e.getMessage());
            
        } catch (JwtInvalidException e) {
            //Clear invalid token cookie (security best practice)
           
            sendJsonError((HttpServletResponse)response, HttpServletResponse.SC_UNAUTHORIZED, e.getMessage());
            
        } catch (Exception e) {
            //Generic auth failure (don't leak stack traces)
          
            sendJsonError((HttpServletResponse)response, HttpServletResponse.SC_UNAUTHORIZED, 
                "Authentication failed. Please log in again.");
        }
        
        chain.doFilter(request, response);
    }
    

    private void sendJsonError(HttpServletResponse response, int status, String message) 
            throws IOException {
        
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Structured error response matching your API format
        Map<String, Object> errorResponse = new LinkedHashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("error", message);
        errorResponse.put("timestamp", LocalDateTime.now().toString());
        errorResponse.put("status", status);
       // errorResponse.put("path", ((HttpServletRequest) response).getRequestURI());
        
        response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
    }
}

