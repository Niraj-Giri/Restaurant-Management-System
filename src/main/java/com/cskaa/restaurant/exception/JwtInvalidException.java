package com.cskaa.restaurant.exception;

public class JwtInvalidException extends RuntimeException {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public JwtInvalidException(String message) {
        super(message);
    }
    
    public JwtInvalidException(String message, Throwable cause) {
        super(message, cause);
    }
}
