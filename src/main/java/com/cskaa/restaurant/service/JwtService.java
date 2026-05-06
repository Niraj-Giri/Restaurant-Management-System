package com.cskaa.restaurant.service;

import com.cskaa.restaurant.config.CustomUserDetails;
import com.cskaa.restaurant.exception.JwtExpiredException;
import com.cskaa.restaurant.exception.JwtInvalidException;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class JwtService {

    // Read from environment/config (never hardcoded)
  /*  @Value("${app.jwt.secret}")
    private String secret;

    @Value("${app.jwt.expiration}")
    private long expiration; // milliseconds (e.g., 3600000 = 1 hour)
    */
	
    private final String secret = "my-secret-key-my-secret-key-my-secret-key"; // ≥32 chars
    private final long expiration = 1000 * 60 * 60 * 10; // 10h

    private SecretKey getSignKey() {
        return Keys.hmacShaKeyFor(secret.getBytes());
    }

    public String generateToken(CustomUserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("roles", userDetails.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList()));
        claims.put("userId", userDetails.getUsername()); // Optional: include user ID

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(getSignKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Validates token AND extracts claims in one operation
     * @throws JwtExpiredException when token is expired
     * @throws JwtInvalidException when token is malformed/invalid signature/etc.
     */
    public Claims validateAndExtractClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(getSignKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
                    
        } catch (ExpiredJwtException e) {
            throw new JwtExpiredException("Your session has expired. Please log in again.");
        } catch (UnsupportedJwtException e) {
            throw new JwtInvalidException("Unsupported token format. Please log in again.");
        } catch (MalformedJwtException e) {
            throw new JwtInvalidException("Invalid token structure. Please log in again.");
        } catch (SignatureException e) {
            throw new JwtInvalidException("Invalid token signature. Token may have been tampered with.");
        } catch (IllegalArgumentException e) {
            throw new JwtInvalidException("Token claims are empty or invalid.");
        } catch (Exception e) {
            // Catch-all for unexpected JWT errors (security best practice: don't leak details)
            throw new JwtInvalidException("Authentication failed. Please log in again.");
        }
    }

    // Convenience methods (now safe to use after validation)
    public String extractUsername(String token) {
        return validateAndExtractClaims(token).getSubject();
    }

    @SuppressWarnings("unchecked")
	public List<String> extractRoles(String token) {
        return validateAndExtractClaims(token).get("roles", List.class);
    }

    public boolean isTokenExpired(String token) {
        try {
            return validateAndExtractClaims(token).getExpiration().before(new Date());
        } catch (JwtExpiredException e) {
            return true;
        } catch (JwtInvalidException e) {
            return true; // Treat invalid tokens as expired for security
        }
    }

    // For debugging only - never expose in production responses
    public Date getExpirationDate(String token) {
        return validateAndExtractClaims(token).getExpiration();
    }
}