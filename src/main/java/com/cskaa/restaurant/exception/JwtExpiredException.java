package com.cskaa.restaurant.exception;

public class JwtExpiredException extends RuntimeException {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public JwtExpiredException(String message) {
        super(message);
    }
}

