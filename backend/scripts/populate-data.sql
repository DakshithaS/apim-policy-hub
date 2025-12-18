/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

-- Policy Hub Sample Data Population Script
-- This script populates the database with sample policies for testing
-- Updated for single table architecture

-- Clear existing data
DELETE FROM policy_docs;
DELETE FROM policy_version;

-- Reset sequences
ALTER SEQUENCE policy_version_id_seq RESTART WITH 1;
ALTER SEQUENCE policy_docs_id_seq RESTART WITH 1;

-- Insert policy versions with all metadata (single table architecture)
INSERT INTO policy_version (
    policy_name, version, is_latest, display_name, provider, description, 
    categories, tags, logo_path, banner_path, supported_platforms,
    release_date, definition_yaml, source_type, download_url, checksum
) VALUES
-- Rate Limiting Policy Versions
('rate-limiting', '1.0.0', false, 'Rate Limiting Policy', 'WSO2', 'Controls the number of requests per time window to prevent API abuse and ensure fair usage', '["security", "traffic-control"]', '["rate-limit", "throttling", "quota"]', 'rate-limiting/1.0.0/assets/icon.svg', 'rate-limiting/1.0.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-01-15',
'name: rate-limiting
version: 1.0.0
description: Basic rate limiting policy
configuration:
  properties:
    requestCount:
      type: integer
      description: Maximum requests per time window
      default: 100
      minimum: 1
      maximum: 10000
    timeUnit:
      type: string
      description: Time unit for the window
      enum: ["second", "minute", "hour", "day"]
      default: "minute"
    keyType:
      type: string
      description: Key type for rate limiting
      enum: ["ip", "user", "api", "application"]
      default: "ip"
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/rate-limiting/1.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-rate-limiting-1.0.0"}'),

('rate-limiting', '1.1.0', false, 'Rate Limiting Policy', 'WSO2', 'Controls the number of requests per time window with enhanced burst capacity', '["security", "traffic-control"]', '["rate-limit", "throttling", "quota", "burst"]', 'rate-limiting/1.1.0/assets/icon.svg', 'rate-limiting/1.1.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-03-20',
'name: rate-limiting
version: 1.1.0
description: Enhanced rate limiting with burst capacity
configuration:
  properties:
    requestCount:
      type: integer
      description: Maximum requests per time window
      default: 100
      minimum: 1
      maximum: 10000
    timeUnit:
      type: string
      description: Time unit for the window
      enum: ["second", "minute", "hour", "day"]
      default: "minute"
    burstCapacity:
      type: integer
      description: Burst capacity above normal limit
      default: 20
      minimum: 0
    keyType:
      type: string
      description: Key type for rate limiting
      enum: ["ip", "user", "api", "application"]
      default: "ip"
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/rate-limiting/1.1.0', '{"algorithm": "sha256", "value": "dummy-checksum-rate-limiting-1.1.0"}'),

('rate-limiting', '1.2.0', false, 'Rate Limiting Policy', 'WSO2', 'Rate limiting with improved performance and additional key types', '["security", "traffic-control"]', '["rate-limit", "throttling", "quota", "performance"]', 'rate-limiting/1.2.0/assets/icon.svg', 'rate-limiting/1.2.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-05-10',
'name: rate-limiting
version: 1.2.0
description: Rate limiting with performance improvements
configuration:
  properties:
    requestCount:
      type: integer
      description: Maximum requests per time window
      default: 100
      minimum: 1
      maximum: 10000
    timeUnit:
      type: string
      description: Time unit for the window
      enum: ["second", "minute", "hour", "day"]
      default: "minute"
    burstCapacity:
      type: integer
      description: Burst capacity above normal limit
      default: 20
      minimum: 0
    keyType:
      type: string
      description: Key type for rate limiting
      enum: ["ip", "user", "api", "application", "custom"]
      default: "ip"
    customKeyExpression:
      type: string
      description: Custom key expression
      default: ""
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/rate-limiting/1.2.0', '{"algorithm": "sha256", "value": "dummy-checksum-rate-limiting-1.2.0"}'),

('rate-limiting', '1.3.0', false, 'Rate Limiting Policy', 'WSO2', 'Rate limiting with distributed caching support', '["security", "traffic-control"]', '["rate-limit", "throttling", "quota", "distributed"]', 'rate-limiting/1.3.0/assets/icon.svg', 'rate-limiting/1.3.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-07-15',
'name: rate-limiting
version: 1.3.0
description: Rate limiting with distributed caching
configuration:
  properties:
    requestCount:
      type: integer
      description: Maximum requests per time window
      default: 100
      minimum: 1
      maximum: 10000
    timeUnit:
      type: string
      description: Time unit for the window
      enum: ["second", "minute", "hour", "day"]
      default: "minute"
    burstCapacity:
      type: integer
      description: Burst capacity above normal limit
      default: 20
      minimum: 0
    keyType:
      type: string
      description: Key type for rate limiting
      enum: ["ip", "user", "api", "application", "custom"]
      default: "ip"
    customKeyExpression:
      type: string
      description: Custom key expression
      default: ""
    distributedCache:
      type: boolean
      description: Enable distributed caching
      default: false
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/rate-limiting/1.3.0', '{"algorithm": "sha256", "value": "dummy-checksum-rate-limiting-1.3.0"}'),

('rate-limiting', '2.0.0', false, 'Rate Limiting Policy', 'WSO2', 'Major update with advanced algorithms and analytics', '["security", "traffic-control"]', '["rate-limit", "throttling", "quota", "analytics"]', 'rate-limiting/2.0.0/assets/icon.svg', 'rate-limiting/2.0.0/assets/banner.png', '["apim-4.5+"]', '2024-10-01',
'name: rate-limiting
version: 2.0.0
description: Advanced rate limiting with analytics
configuration:
  properties:
    requestCount:
      type: integer
      description: Maximum requests per time window
      default: 100
      minimum: 1
      maximum: 10000
    timeUnit:
      type: string
      description: Time unit for the window
      enum: ["second", "minute", "hour", "day"]
      default: "minute"
    burstCapacity:
      type: integer
      description: Burst capacity above normal limit
      default: 20
      minimum: 0
    keyType:
      type: string
      description: Key type for rate limiting
      enum: ["ip", "user", "api", "application", "custom"]
      default: "ip"
    customKeyExpression:
      type: string
      description: Custom key expression
      default: ""
    distributedCache:
      type: boolean
      description: Enable distributed caching
      default: false
    analytics:
      type: boolean
      description: Enable rate limiting analytics
      default: true
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/rate-limiting/2.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-rate-limiting-2.0.0"}'),

('rate-limiting', '2.1.0', false, 'Rate Limiting Policy', 'WSO2', 'Enhanced analytics and reporting features', '["security", "traffic-control"]', '["rate-limit", "throttling", "quota", "analytics", "reporting"]', 'rate-limiting/2.1.0/assets/icon.svg', 'rate-limiting/2.1.0/assets/banner.png', '["apim-4.5+"]', '2024-12-15',
'name: rate-limiting
version: 2.1.0
description: Rate limiting with enhanced analytics
configuration:
  properties:
    requestCount:
      type: integer
      description: Maximum requests per time window
      default: 100
      minimum: 1
      maximum: 10000
    timeUnit:
      type: string
      description: Time unit for the window
      enum: ["second", "minute", "hour", "day"]
      default: "minute"
    burstCapacity:
      type: integer
      description: Burst capacity above normal limit
      default: 20
      minimum: 0
    keyType:
      type: string
      description: Key type for rate limiting
      enum: ["ip", "user", "api", "application", "custom"]
      default: "ip"
    customKeyExpression:
      type: string
      description: Custom key expression
      default: ""
    distributedCache:
      type: boolean
      description: Enable distributed caching
      default: false
    analytics:
      type: boolean
      description: Enable rate limiting analytics
      default: true
    reporting:
      type: object
      description: Reporting configuration
      properties:
        enabled:
          type: boolean
          default: false
        interval:
          type: string
          enum: ["hourly", "daily", "weekly"]
          default: "daily"
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/rate-limiting/2.1.0', '{"algorithm": "sha256", "value": "dummy-checksum-rate-limiting-2.1.0"}'),

('rate-limiting', '3.0.0', true, 'Rate Limiting Policy', 'WSO2', 'Next generation rate limiting with AI-powered predictions', '["security", "traffic-control", "ai"]', '["rate-limit", "throttling", "quota", "ai", "predictive"]', 'rate-limiting/3.0.0/assets/icon.svg', 'rate-limiting/3.0.0/assets/banner.png', '["apim-4.5+"]', '2025-03-01',
'name: rate-limiting
version: 3.0.0
description: AI-powered predictive rate limiting
configuration:
  properties:
    requestCount:
      type: integer
      description: Maximum requests per time window
      default: 100
      minimum: 1
      maximum: 10000
    timeUnit:
      type: string
      description: Time unit for the window
      enum: ["second", "minute", "hour", "day"]
      default: "minute"
    burstCapacity:
      type: integer
      description: Burst capacity above normal limit
      default: 20
      minimum: 0
    keyType:
      type: string
      description: Key type for rate limiting
      enum: ["ip", "user", "api", "application", "custom"]
      default: "ip"
    customKeyExpression:
      type: string
      description: Custom key expression
      default: ""
    distributedCache:
      type: boolean
      description: Enable distributed caching
      default: false
    analytics:
      type: boolean
      description: Enable rate limiting analytics
      default: true
    reporting:
      type: object
      description: Reporting configuration
      properties:
        enabled:
          type: boolean
          default: false
        interval:
          type: string
          enum: ["hourly", "daily", "weekly"]
          default: "daily"
    aiPrediction:
      type: boolean
      description: Enable AI-powered predictions
      default: true
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/rate-limiting/3.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-rate-limiting-3.0.0"}'),

-- JWT Authentication Policy Versions  
('jwt-authentication', '1.0.0', false, 'JWT Authentication Policy', 'WSO2', 'Validates JSON Web Tokens (JWT) for API authentication and authorization', '["security", "authentication"]', '["jwt", "token", "auth"]', 'jwt-authentication/1.0.0/assets/icon.svg', 'jwt-authentication/1.0.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-02-10',
'name: jwt-authentication
version: 1.0.0
description: JWT token validation policy
configuration:
  properties:
    jwtHeader:
      type: string
      description: Header name containing JWT token
      default: "Authorization"
    tokenPrefix:
      type: string
      description: Token prefix (e.g., Bearer)
      default: "Bearer "
    issuer:
      type: string
      description: Token issuer
      required: true
    audience:
      type: string
      description: Token audience
      required: true
    algorithm:
      type: string
      description: Signing algorithm
      enum: ["RS256", "HS256", "ES256"]
      default: "RS256"
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/jwt-authentication/1.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-jwt-auth-1.0.0"}'),

('jwt-authentication', '2.0.0', false, 'JWT Authentication Policy', 'WSO2', 'Advanced JWT validation with multi-issuer support and enhanced security', '["security", "authentication"]', '["jwt", "token", "auth", "multi-issuer"]', 'jwt-authentication/2.0.0/assets/icon.svg', 'jwt-authentication/2.0.0/assets/banner.png', '["apim-4.5+"]', '2024-06-15',
'name: jwt-authentication
version: 2.0.0
description: Advanced JWT validation with multi-issuer support
configuration:
  properties:
    jwtHeader:
      type: string
      description: Header name containing JWT token
      default: "Authorization"
    tokenPrefix:
      type: string
      description: Token prefix (e.g., Bearer)
      default: "Bearer "
    issuers:
      type: array
      description: List of trusted issuers
      items:
        type: object
        properties:
          issuer:
            type: string
          audience:
            type: string
          algorithm:
            type: string
    validateExpiry:
      type: boolean
      description: Validate token expiry
      default: true
    clockSkew:
      type: integer
      description: Clock skew tolerance in seconds
      default: 300
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/jwt-authentication/2.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-jwt-auth-2.0.0"}'),

('jwt-authentication', '2.1.0', false, 'JWT Authentication Policy', 'WSO2', 'Latest JWT validation with caching and performance improvements', '["security", "authentication"]', '["jwt", "token", "auth", "multi-issuer", "cache"]', 'jwt-authentication/2.1.0/assets/icon.svg', 'jwt-authentication/2.1.0/assets/banner.png', '["apim-4.5+"]', '2024-09-10',
'name: jwt-authentication
version: 2.1.0
description: JWT validation with caching and performance improvements
configuration:
  properties:
    jwtHeader:
      type: string
      description: Header name containing JWT token
      default: "Authorization"
    tokenPrefix:
      type: string
      description: Token prefix (e.g., Bearer)
      default: "Bearer "
    issuers:
      type: array
      description: List of trusted issuers
      items:
        type: object
        properties:
          issuer:
            type: string
          audience:
            type: string
          algorithm:
            type: string
    validateExpiry:
      type: boolean
      description: Validate token expiry
      default: true
    clockSkew:
      type: integer
      description: Clock skew tolerance in seconds
      default: 300
    enableCaching:
      type: boolean
      description: Enable JWT validation caching
      default: true
    cacheSize:
      type: integer
      description: Maximum cache size
      default: 1000
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/jwt-authentication/2.1.0', '{"algorithm": "sha256", "value": "dummy-checksum-jwt-auth-2.1.0"}'),

('jwt-authentication', '2.2.0', false, 'JWT Authentication Policy', 'WSO2', 'Enhanced JWT validation with advanced security features', '["security", "authentication"]', '["jwt", "token", "auth", "multi-issuer", "cache", "security"]', 'jwt-authentication/2.2.0/assets/icon.svg', 'jwt-authentication/2.2.0/assets/banner.png', '["apim-4.5+"]', '2024-12-01',
'name: jwt-authentication
version: 2.2.0
description: JWT validation with advanced security
configuration:
  properties:
    jwtHeader:
      type: string
      description: Header name containing JWT token
      default: "Authorization"
    tokenPrefix:
      type: string
      description: Token prefix (e.g., Bearer)
      default: "Bearer "
    issuers:
      type: array
      description: List of trusted issuers
      items:
        type: object
        properties:
          issuer:
            type: string
          audience:
            type: string
          algorithm:
            type: string
    validateExpiry:
      type: boolean
      description: Validate token expiry
      default: true
    clockSkew:
      type: integer
      description: Clock skew tolerance in seconds
      default: 300
    enableCaching:
      type: boolean
      description: Enable JWT validation caching
      default: true
    cacheSize:
      type: integer
      description: Maximum cache size
      default: 1000
    securityFeatures:
      type: object
      description: Advanced security features
      properties:
        replayAttackProtection:
          type: boolean
          default: true
        tokenBlacklist:
          type: boolean
          default: false
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/jwt-authentication/2.2.0', '{"algorithm": "sha256", "value": "dummy-checksum-jwt-auth-2.2.0"}'),

('jwt-authentication', '3.0.0', true, 'JWT Authentication Policy', 'WSO2', 'Next-generation JWT validation with AI-powered threat detection', '["security", "authentication", "ai"]', '["jwt", "token", "auth", "ai", "threat-detection"]', 'jwt-authentication/3.0.0/assets/icon.svg', 'jwt-authentication/3.0.0/assets/banner.png', '["apim-4.5+"]', '2025-04-15',
'name: jwt-authentication
version: 3.0.0
description: AI-powered JWT validation
configuration:
  properties:
    jwtHeader:
      type: string
      description: Header name containing JWT token
      default: "Authorization"
    tokenPrefix:
      type: string
      description: Token prefix (e.g., Bearer)
      default: "Bearer "
    issuers:
      type: array
      description: List of trusted issuers
      items:
        type: object
        properties:
          issuer:
            type: string
          audience:
            type: string
          algorithm:
            type: string
    validateExpiry:
      type: boolean
      description: Validate token expiry
      default: true
    clockSkew:
      type: integer
      description: Clock skew tolerance in seconds
      default: 300
    enableCaching:
      type: boolean
      description: Enable JWT validation caching
      default: true
    cacheSize:
      type: integer
      description: Maximum cache size
      default: 1000
    securityFeatures:
      type: object
      description: Advanced security features
      properties:
        replayAttackProtection:
          type: boolean
          default: true
        tokenBlacklist:
          type: boolean
          default: false
    aiThreatDetection:
      type: boolean
      description: Enable AI-based threat detection
      default: true
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/jwt-authentication/3.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-jwt-auth-3.0.0"}'),

-- CORS Policy Versions
('cors-policy', '1.0.0', false, 'CORS Policy', 'Community', 'Manages Cross-Origin Resource Sharing (CORS) headers for web API security', '["security", "web"]', '["cors", "cross-origin", "headers"]', 'cors-policy/1.0.0/assets/icon.svg', 'cors-policy/1.0.0/assets/banner.png', '["apim-4.5+", "apim-4.4+", "apim-4.3+"]', '2024-01-25',
'name: cors-policy
version: 1.0.0
description: Basic CORS policy
configuration:
  properties:
    allowedOrigins:
      type: array
      description: List of allowed origins
      items:
        type: string
      default: ["*"]
    allowedMethods:
      type: array
      description: List of allowed HTTP methods
      items:
        type: string
      default: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allowedHeaders:
      type: array
      description: List of allowed headers
      items:
        type: string
      default: ["Content-Type", "Authorization"]
    maxAge:
      type: integer
      description: Preflight response cache time
      default: 3600
enforcement:
  type: "response"
  stage: "post"', 'github', 'https://github.com/community/policy-hub/tree/main/storage/cors-policy/1.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-cors-1.0.0"}'),

('cors-policy', '1.1.0', false, 'CORS Policy', 'Community', 'Enhanced CORS policy with credentials support', '["security", "web"]', '["cors", "cross-origin", "headers", "credentials"]', 'cors-policy/1.1.0/assets/icon.svg', 'cors-policy/1.1.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-04-15',
'name: cors-policy
version: 1.1.0
description: Enhanced CORS policy with credentials support
configuration:
  properties:
    allowedOrigins:
      type: array
      description: List of allowed origins
      items:
        type: string
      default: ["*"]
    allowedMethods:
      type: array
      description: List of allowed HTTP methods
      items:
        type: string
      default: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allowedHeaders:
      type: array
      description: List of allowed headers
      items:
        type: string
      default: ["Content-Type", "Authorization"]
    allowCredentials:
      type: boolean
      description: Allow credentials in CORS requests
      default: false
    exposedHeaders:
      type: array
      description: Headers exposed to the client
      items:
        type: string
      default: []
    maxAge:
      type: integer
      description: Preflight response cache time
      default: 3600
enforcement:
  type: "response"
  stage: "post"', 'github', 'https://github.com/community/policy-hub/tree/main/storage/cors-policy/1.1.0', '{"algorithm": "sha256", "value": "dummy-checksum-cors-1.1.0"}'),

('cors-policy', '1.2.0', true, 'CORS Policy', 'Community', 'Latest CORS policy with dynamic origin validation', '["security", "web"]', '["cors", "cross-origin", "headers", "dynamic"]', 'cors-policy/1.2.0/assets/icon.svg', 'cors-policy/1.2.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-08-20',
'name: cors-policy
version: 1.2.0
description: CORS policy with dynamic origin validation
configuration:
  properties:
    allowedOrigins:
      type: array
      description: List of allowed origins (supports wildcards)
      items:
        type: string
      default: ["*"]
    allowedMethods:
      type: array
      description: List of allowed HTTP methods
      items:
        type: string
      default: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allowedHeaders:
      type: array
      description: List of allowed headers
      items:
        type: string
      default: ["Content-Type", "Authorization"]
    allowCredentials:
      type: boolean
      description: Allow credentials in CORS requests
      default: false
    exposedHeaders:
      type: array
      description: Headers exposed to the client
      items:
        type: string
      default: []
    maxAge:
      type: integer
      description: Preflight response cache time
      default: 3600
    dynamicValidation:
      type: boolean
      description: Enable dynamic origin validation
      default: false
    originPattern:
      type: string
      description: Regex pattern for origin validation
      default: ".*"
enforcement:
  type: "response"
  stage: "post"', 'github', 'https://github.com/community/policy-hub/tree/main/storage/cors-policy/1.2.0', '{"algorithm": "sha256", "value": "dummy-checksum-cors-1.2.0"}'),

-- API Throttling Policy Versions
('api-throttling', '1.0.0', false, 'API Throttling Policy', 'WSO2', 'Advanced throttling with burst capacity and dynamic rate limiting', '["traffic-control", "performance"]', '["throttling", "burst", "dynamic"]', 'api-throttling/1.0.0/assets/icon.svg', 'api-throttling/1.0.0/assets/banner.png', '["apim-4.5+"]', '2024-03-01',
'name: api-throttling
version: 1.0.0
description: Advanced API throttling policy
configuration:
  properties:
    requestsPerSecond:
      type: integer
      description: Requests per second limit
      default: 10
      minimum: 1
      maximum: 1000
    burstSize:
      type: integer
      description: Burst capacity
      default: 20
      minimum: 0
    throttleType:
      type: string
      description: Type of throttling
      enum: ["fixed", "sliding", "adaptive"]
      default: "sliding"
    keyExtractor:
      type: string
      description: Key extraction method
      enum: ["ip", "header", "jwt-claim", "custom"]
      default: "ip"
    customKey:
      type: string
      description: Custom key for throttling
      default: ""
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/api-throttling/1.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-throttling-1.0.0"}'),

('api-throttling', '2.0.0', true, 'API Throttling Policy', 'WSO2', 'Next-generation throttling with machine learning capabilities', '["traffic-control", "performance", "ml"]', '["throttling", "burst", "dynamic", "ml", "adaptive"]', 'api-throttling/2.0.0/assets/icon.svg', 'api-throttling/2.0.0/assets/banner.png', '["apim-4.5+"]', '2024-07-10',
'name: api-throttling
version: 2.0.0
description: Advanced throttling with ML-based adaptive limits
configuration:
  properties:
    requestsPerSecond:
      type: integer
      description: Base requests per second limit
      default: 10
      minimum: 1
      maximum: 1000
    burstSize:
      type: integer
      description: Burst capacity
      default: 20
      minimum: 0
    throttleType:
      type: string
      description: Type of throttling
      enum: ["fixed", "sliding", "adaptive", "ml-adaptive"]
      default: "ml-adaptive"
    keyExtractor:
      type: string
      description: Key extraction method
      enum: ["ip", "header", "jwt-claim", "custom"]
      default: "ip"
    customKey:
      type: string
      description: Custom key for throttling
      default: ""
    adaptiveSettings:
      type: object
      description: ML-based adaptive throttling settings
      properties:
        enabled:
          type: boolean
          default: true
        learningPeriod:
          type: integer
          default: 3600
        adjustmentFactor:
          type: number
          default: 0.1
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/api-throttling/2.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-throttling-2.0.0"}'),

-- Request Transformation Policy Versions
('request-transformation', '1.0.0', false, 'Request Transformation Policy', 'Community', 'Transforms incoming API requests including headers, query parameters, and request body', '["transformation", "mediation"]', '["transform", "headers", "body"]', 'request-transformation/1.0.0/assets/icon.svg', 'request-transformation/1.0.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-02-20',
'name: request-transformation
version: 1.0.0
description: Basic request transformation policy
configuration:
  properties:
    headerTransforms:
      type: array
      description: Header transformation rules
      items:
        type: object
        properties:
          action:
            type: string
            enum: ["add", "remove", "replace"]
          name:
            type: string
          value:
            type: string
      default: []
    queryTransforms:
      type: array
      description: Query parameter transformation rules
      items:
        type: object
        properties:
          action:
            type: string
            enum: ["add", "remove", "replace"]
          name:
            type: string
          value:
            type: string
      default: []
    bodyTransform:
      type: object
      description: Body transformation settings
      properties:
        enabled:
          type: boolean
          default: false
        type:
          type: string
          enum: ["json", "xml", "text"]
          default: "json"
        template:
          type: string
          default: ""
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/community/policy-hub/tree/main/storage/request-transformation/1.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-request-transform-1.0.0"}'),

('request-transformation', '1.5.0', true, 'Request Transformation Policy', 'Community', 'Enhanced request transformation with conditional logic and templating', '["transformation", "mediation"]', '["transform", "headers", "body", "conditional", "template"]', 'request-transformation/1.5.0/assets/icon.svg', 'request-transformation/1.5.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-05-30',
'name: request-transformation
version: 1.5.0
description: Enhanced transformation with conditional logic
configuration:
  properties:
    headerTransforms:
      type: array
      description: Header transformation rules
      items:
        type: object
        properties:
          action:
            type: string
            enum: ["add", "remove", "replace"]
          name:
            type: string
          value:
            type: string
          condition:
            type: string
            description: Condition for applying transformation
      default: []
    queryTransforms:
      type: array
      description: Query parameter transformation rules
      items:
        type: object
        properties:
          action:
            type: string
            enum: ["add", "remove", "replace"]
          name:
            type: string
          value:
            type: string
          condition:
            type: string
      default: []
    bodyTransform:
      type: object
      description: Body transformation settings
      properties:
        enabled:
          type: boolean
          default: false
        type:
          type: string
          enum: ["json", "xml", "text", "template"]
          default: "json"
        template:
          type: string
          default: ""
        templateEngine:
          type: string
          enum: ["handlebars", "mustache", "velocity"]
          default: "handlebars"
    conditionalLogic:
      type: object
      description: Conditional transformation settings
      properties:
        enabled:
          type: boolean
          default: false
        rules:
          type: array
          items:
            type: object
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/community/policy-hub/tree/main/storage/request-transformation/1.5.0', '{"algorithm": "sha256", "value": "dummy-checksum-request-transform-1.5.0"}'),

-- OAuth2 Validation Policy Versions
('oauth2-validation', '1.0.0', true, 'OAuth2 Validation Policy', 'WSO2', 'Validates OAuth2 access tokens with introspection support', '["security", "authentication"]', '["oauth2", "token", "introspection"]', 'oauth2-validation/1.0.0/assets/icon.svg', 'oauth2-validation/1.0.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-04-05',
'name: oauth2-validation
version: 1.0.0
description: OAuth2 token validation policy
configuration:
  properties:
    tokenHeader:
      type: string
      description: Header containing the access token
      default: "Authorization"
    tokenPrefix:
      type: string
      description: Token prefix (e.g., Bearer)
      default: "Bearer "
    introspectionEndpoint:
      type: string
      description: Token introspection endpoint URL
      required: true
    clientId:
      type: string
      description: Client ID for introspection
      required: true
    clientSecret:
      type: string
      description: Client secret for introspection
      required: true
    cacheTokens:
      type: boolean
      description: Enable token caching
      default: true
    cacheTimeout:
      type: integer
      description: Cache timeout in seconds
      default: 300
    requiredScopes:
      type: array
      description: Required OAuth2 scopes
      items:
        type: string
      default: []
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/oauth2-validation/1.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-oauth2-1.0.0"}'),

-- Response Caching Policy Versions
('response-caching', '1.0.0', false, 'Response Caching Policy', 'Community', 'Caches API responses to improve performance and reduce backend load', '["performance", "caching"]', '["cache", "response", "performance"]', 'response-caching/1.0.0/assets/icon.svg', 'response-caching/1.0.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-03-10',
'name: response-caching
version: 1.0.0
description: Basic response caching policy
configuration:
  properties:
    cacheTimeout:
      type: integer
      description: Cache timeout in seconds
      default: 300
      minimum: 60
      maximum: 3600
    cacheKey:
      type: string
      description: Cache key pattern
      default: "{method}:{path}:{query}"
    cacheMethods:
      type: array
      description: HTTP methods to cache
      items:
        type: string
      default: ["GET"]
    cacheStatusCodes:
      type: array
      description: Status codes to cache
      items:
        type: integer
      default: [200, 201, 203, 300, 301]
    ignoreHeaders:
      type: array
      description: Headers to ignore in cache key
      items:
        type: string
      default: ["User-Agent", "Accept-Encoding"]
enforcement:
  type: "response"
  stage: "post"', 'github', 'https://github.com/community/policy-hub/tree/main/storage/response-caching/1.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-response-cache-1.0.0"}'),

('response-caching', '1.1.0', true, 'Response Caching Policy', 'Community', 'Enhanced response caching with conditional caching and cache invalidation', '["performance", "caching"]', '["cache", "response", "performance", "invalidation"]', 'response-caching/1.1.0/assets/icon.svg', 'response-caching/1.1.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-06-25',
'name: response-caching
version: 1.1.0
description: Enhanced caching with invalidation support
configuration:
  properties:
    cacheTimeout:
      type: integer
      description: Cache timeout in seconds
      default: 300
      minimum: 60
      maximum: 3600
    cacheKey:
      type: string
      description: Cache key pattern
      default: "{method}:{path}:{query}"
    cacheMethods:
      type: array
      description: HTTP methods to cache
      items:
        type: string
      default: ["GET"]
    cacheStatusCodes:
      type: array
      description: Status codes to cache
      items:
        type: integer
      default: [200, 201, 203, 300, 301]
    ignoreHeaders:
      type: array
      description: Headers to ignore in cache key
      items:
        type: string
      default: ["User-Agent", "Accept-Encoding"]
    conditionalCaching:
      type: object
      description: Conditional caching settings
      properties:
        enabled:
          type: boolean
          default: false
        conditions:
          type: array
          items:
            type: string
    invalidationRules:
      type: array
      description: Cache invalidation rules
      items:
        type: object
        properties:
          method:
            type: string
          pattern:
            type: string
      default: []
enforcement:
  type: "response"
  stage: "post"', 'github', 'https://github.com/community/policy-hub/tree/main/storage/response-caching/1.1.0', '{"algorithm": "sha256", "value": "dummy-checksum-response-cache-1.1.0"}'),

-- IP Filtering Policy Versions  
('ip-filtering', '1.0.0', true, 'IP Filtering Policy', 'WSO2', 'Allows or blocks requests based on client IP addresses with support for CIDR notation', '["security", "access-control"]', '["ip", "filter", "whitelist", "blacklist", "cidr"]', 'ip-filtering/1.0.0/assets/icon.svg', 'ip-filtering/1.0.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-02-28',
'name: ip-filtering
version: 1.0.0
description: IP-based access control policy
configuration:
  properties:
    filterType:
      type: string
      description: Type of IP filtering
      enum: ["allow", "deny"]
      default: "allow"
    ipList:
      type: array
      description: List of IP addresses or CIDR blocks
      items:
        type: string
      default: []
    allowPrivateIPs:
      type: boolean
      description: Allow private IP ranges
      default: true
    trustProxy:
      type: boolean
      description: Trust X-Forwarded-For header
      default: false
    proxyHeaders:
      type: array
      description: Headers to check for real IP
      items:
        type: string
      default: ["X-Forwarded-For", "X-Real-IP"]
    defaultAction:
      type: string
      description: Default action for unmatched IPs
      enum: ["allow", "deny"]
      default: "deny"
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/ip-filtering/1.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-ip-filter-1.0.0"}'),

-- API Key Authentication Policy Versions
('api-key-auth', '1.0.0', false, 'API Key Authentication Policy', 'WSO2', 'Validates API keys for simple authentication mechanism', '["security", "authentication"]', '["api-key", "auth", "simple"]', 'api-key-auth/1.0.0/assets/icon.svg', 'api-key-auth/1.0.0/assets/banner.png', '["apim-4.5+", "apim-4.4+", "apim-4.3+"]', '2024-01-10',
'name: api-key-auth
version: 1.0.0
description: Basic API key authentication
configuration:
  properties:
    keyLocation:
      type: string
      description: Location of API key
      enum: ["header", "query", "cookie"]
      default: "header"
    keyName:
      type: string
      description: Name of the key parameter
      default: "X-API-Key"
    validKeys:
      type: array
      description: List of valid API keys
      items:
        type: string
      default: []
    keyPrefix:
      type: string
      description: Expected key prefix
      default: ""
    caseSensitive:
      type: boolean
      description: Case sensitive key matching
      default: true
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/api-key-auth/1.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-api-key-1.0.0"}'),

('api-key-auth', '2.0.0', true, 'API Key Authentication Policy', 'WSO2', 'Advanced API key authentication with key management and rotation support', '["security", "authentication"]', '["api-key", "auth", "rotation", "management"]', 'api-key-auth/2.0.0/assets/icon.svg', 'api-key-auth/2.0.0/assets/banner.png', '["apim-4.5+"]', '2024-05-15',
'name: api-key-auth
version: 2.0.0
description: Advanced API key authentication with key management
configuration:
  properties:
    keyLocation:
      type: string
      description: Location of API key
      enum: ["header", "query", "cookie"]
      default: "header"
    keyName:
      type: string
      description: Name of the key parameter
      default: "X-API-Key"
    keySource:
      type: string
      description: Source of valid keys
      enum: ["static", "database", "external"]
      default: "static"
    validKeys:
      type: array
      description: List of valid API keys (for static source)
      items:
        type: string
      default: []
    keyPrefix:
      type: string
      description: Expected key prefix
      default: ""
    caseSensitive:
      type: boolean
      description: Case sensitive key matching
      default: true
    keyRotation:
      type: object
      description: Key rotation settings
      properties:
        enabled:
          type: boolean
          default: false
        rotationPeriod:
          type: integer
          default: 86400
    rateLimitPerKey:
      type: object
      description: Per-key rate limiting
      properties:
        enabled:
          type: boolean
          default: false
        requestsPerMinute:
          type: integer
          default: 100
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/api-key-auth/2.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-api-key-2.0.0"}'),

-- Header Validation Policy Versions
('header-validation', '1.0.0', false, 'Header Validation Policy', 'WSO2', 'Validates HTTP headers in API requests for security and compliance', '["security", "validation"]', '["headers", "validation", "security"]', 'header-validation/1.0.0/assets/icon.svg', 'header-validation/1.0.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-01-20',
'name: header-validation
version: 1.0.0
description: Basic header validation policy
configuration:
  properties:
    requiredHeaders:
      type: array
      description: List of required headers
      items:
        type: string
      default: []
    forbiddenHeaders:
      type: array
      description: List of forbidden headers
      items:
        type: string
      default: []
    headerValidations:
      type: array
      description: Custom header validation rules
      items:
        type: object
        properties:
          name:
            type: string
          pattern:
            type: string
          required:
            type: boolean
      default: []
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/header-validation/1.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-header-validation-1.0.0"}'),

('header-validation', '1.1.0', false, 'Header Validation Policy', 'WSO2', 'Enhanced header validation with regex patterns and case sensitivity', '["security", "validation"]', '["headers", "validation", "security", "regex"]', 'header-validation/1.1.0/assets/icon.svg', 'header-validation/1.1.0/assets/banner.png', '["apim-4.5+", "apim-4.4+"]', '2024-04-10',
'name: header-validation
version: 1.1.0
description: Enhanced header validation with regex
configuration:
  properties:
    requiredHeaders:
      type: array
      description: List of required headers
      items:
        type: string
      default: []
    forbiddenHeaders:
      type: array
      description: List of forbidden headers
      items:
        type: string
      default: []
    headerValidations:
      type: array
      description: Custom header validation rules
      items:
        type: object
        properties:
          name:
            type: string
          pattern:
            type: string
          required:
            type: boolean
          caseSensitive:
            type: boolean
            default: true
      default: []
    allowEmptyValues:
      type: boolean
      description: Allow empty header values
      default: false
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/header-validation/1.1.0', '{"algorithm": "sha256", "value": "dummy-checksum-header-validation-1.1.0"}'),

('header-validation', '2.0.0', false, 'Header Validation Policy', 'WSO2', 'Advanced header validation with custom scripts and transformations', '["security", "validation", "transformation"]', '["headers", "validation", "security", "script", "transform"]', 'header-validation/2.0.0/assets/icon.svg', 'header-validation/2.0.0/assets/banner.png', '["apim-4.5+"]', '2024-08-15',
'name: header-validation
version: 2.0.0
description: Advanced header validation with scripts
configuration:
  properties:
    requiredHeaders:
      type: array
      description: List of required headers
      items:
        type: string
      default: []
    forbiddenHeaders:
      type: array
      description: List of forbidden headers
      items:
        type: string
      default: []
    headerValidations:
      type: array
      description: Custom header validation rules
      items:
        type: object
        properties:
          name:
            type: string
          pattern:
            type: string
          required:
            type: boolean
          caseSensitive:
            type: boolean
            default: true
          script:
            type: string
            description: Custom validation script
      default: []
    allowEmptyValues:
      type: boolean
      description: Allow empty header values
      default: false
    transformations:
      type: array
      description: Header transformation rules
      items:
        type: object
        properties:
          name:
            type: string
          action:
            type: string
            enum: ["add", "remove", "modify"]
          value:
            type: string
      default: []
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/header-validation/2.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-header-validation-2.0.0"}'),

('header-validation', '2.1.0', false, 'Header Validation Policy', 'WSO2', 'Header validation with performance optimizations and caching', '["security", "validation", "performance"]', '["headers", "validation", "security", "cache", "performance"]', 'header-validation/2.1.0/assets/icon.svg', 'header-validation/2.1.0/assets/banner.png', '["apim-4.5+"]', '2024-11-20',
'name: header-validation
version: 2.1.0
description: Header validation with caching
configuration:
  properties:
    requiredHeaders:
      type: array
      description: List of required headers
      items:
        type: string
      default: []
    forbiddenHeaders:
      type: array
      description: List of forbidden headers
      items:
        type: string
      default: []
    headerValidations:
      type: array
      description: Custom header validation rules
      items:
        type: object
        properties:
          name:
            type: string
          pattern:
            type: string
          required:
            type: boolean
          caseSensitive:
            type: boolean
            default: true
          script:
            type: string
            description: Custom validation script
      default: []
    allowEmptyValues:
      type: boolean
      description: Allow empty header values
      default: false
    transformations:
      type: array
      description: Header transformation rules
      items:
        type: object
        properties:
          name:
            type: string
          action:
            type: string
            enum: ["add", "remove", "modify"]
          value:
            type: string
      default: []
    caching:
      type: boolean
      description: Enable validation result caching
      default: true
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/header-validation/2.1.0', '{"algorithm": "sha256", "value": "dummy-checksum-header-validation-2.1.0"}'),

('header-validation', '3.0.0', true, 'Header Validation Policy', 'WSO2', 'AI-powered header validation with anomaly detection', '["security", "validation", "ai"]', '["headers", "validation", "security", "ai", "anomaly"]', 'header-validation/3.0.0/assets/icon.svg', 'header-validation/3.0.0/assets/banner.png', '["apim-4.5+"]', '2025-02-10',
'name: header-validation
version: 3.0.0
description: AI-powered header validation
configuration:
  properties:
    requiredHeaders:
      type: array
      description: List of required headers
      items:
        type: string
      default: []
    forbiddenHeaders:
      type: array
      description: List of forbidden headers
      items:
        type: string
      default: []
    headerValidations:
      type: array
      description: Custom header validation rules
      items:
        type: object
        properties:
          name:
            type: string
          pattern:
            type: string
          required:
            type: boolean
          caseSensitive:
            type: boolean
            default: true
          script:
            type: string
            description: Custom validation script
      default: []
    allowEmptyValues:
      type: boolean
      description: Allow empty header values
      default: false
    transformations:
      type: array
      description: Header transformation rules
      items:
        type: object
        properties:
          name:
            type: string
          action:
            type: string
            enum: ["add", "remove", "modify"]
          value:
            type: string
      default: []
    caching:
      type: boolean
      description: Enable validation result caching
      default: true
    aiAnomalyDetection:
      type: boolean
      description: Enable AI-based anomaly detection
      default: true
enforcement:
  type: "request"
  stage: "pre"', 'github', 'https://github.com/wso2/policy-hub/tree/main/storage/header-validation/3.0.0', '{"algorithm": "sha256", "value": "dummy-checksum-header-validation-3.0.0"}');

-- Insert policy documentation
INSERT INTO policy_docs (policy_version_id, page, content_md) VALUES
-- Rate Limiting 1.0.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'rate-limiting' AND version = '1.0.0'), 'overview',
'# Rate Limiting Policy 1.0.0

## Overview
The Rate Limiting Policy controls the number of requests that can be made to an API within a specified time window. This helps prevent API abuse and ensures fair usage among consumers.

## Key Features
- Configurable request limits per time window
- Multiple time units (second, minute, hour, day)
- Different key types for rate limiting (IP, user, API, application)
- Real-time request counting

## Use Cases
- Protecting APIs from abuse
- Ensuring fair usage among API consumers
- Managing traffic during peak loads'),

((SELECT id FROM policy_version WHERE policy_name = 'rate-limiting' AND version = '1.0.0'), 'configuration',
'# Configuration Guide

## Basic Configuration
```yaml
requestCount: 100
timeUnit: "minute"
keyType: "ip"
```

## Advanced Examples
### Per-User Rate Limiting
```yaml
requestCount: 1000
timeUnit: "hour"
keyType: "user"
```

### API-Level Rate Limiting
```yaml
requestCount: 50
timeUnit: "second"
keyType: "api"
```'),

-- Rate Limiting 1.1.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'rate-limiting' AND version = '1.1.0'), 'overview',
'# Rate Limiting Policy 1.1.0

## Overview
Enhanced version of the Rate Limiting Policy with burst capacity support and improved error handling.

## New Features in 1.1.0
- **Burst Capacity**: Allow temporary spikes above the normal limit
- **Improved Error Handling**: Better error messages and status codes
- **Enhanced Metrics**: More detailed monitoring capabilities

## Key Features
- All features from 1.0.0
- Configurable burst capacity
- Better error responses
- Enhanced monitoring and metrics

## Migration from 1.0.0
The 1.1.0 version is backward compatible with 1.0.0 configurations. Simply add the `burstCapacity` parameter to enable burst handling.'),

-- Rate Limiting 1.2.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'rate-limiting' AND version = '1.2.0'), 'overview',
'# Rate Limiting Policy 1.2.0

## Overview
Performance-optimized version with additional key types and custom expressions.

## New Features in 1.2.0
- **Custom Key Expressions**: Support for custom key extraction logic
- **Performance Improvements**: Optimized rate limiting algorithms
- **Additional Key Types**: Support for custom keys

## Key Features
- All features from 1.1.0
- Custom key expressions
- Better performance
- Enhanced flexibility

## Migration from 1.1.0
Add `customKeyExpression` for advanced key extraction.'),

-- Rate Limiting 1.3.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'rate-limiting' AND version = '1.3.0'), 'overview',
'# Rate Limiting Policy 1.3.0

## Overview
Distributed caching support for high-availability deployments.

## New Features in 1.3.0
- **Distributed Caching**: Support for distributed rate limiting state
- **High Availability**: Better support for clustered deployments
- **Scalability Improvements**: Enhanced performance in large-scale environments

## Key Features
- All features from 1.2.0
- Distributed caching
- High availability
- Scalability

## Migration from 1.2.0
Enable `distributedCache` for clustered deployments.'),

-- Rate Limiting 2.0.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'rate-limiting' AND version = '2.0.0'), 'overview',
'# Rate Limiting Policy 2.0.0

## Overview
Major update with advanced algorithms and built-in analytics.

## New Features in 2.0.0
- **Advanced Algorithms**: New rate limiting algorithms
- **Built-in Analytics**: Real-time analytics and monitoring
- **Enhanced Configuration**: More flexible configuration options

## Key Features
- Advanced rate limiting algorithms
- Real-time analytics
- Enhanced monitoring
- Flexible configuration

## Migration from 1.3.0
Review configuration for new analytics settings.'),

-- Rate Limiting 2.1.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'rate-limiting' AND version = '2.1.0'), 'overview',
'# Rate Limiting Policy 2.1.0

## Overview
Enhanced analytics with reporting capabilities.

## New Features in 2.1.0
- **Reporting**: Configurable reporting intervals
- **Enhanced Analytics**: More detailed analytics data
- **Dashboard Integration**: Better integration with monitoring dashboards

## Key Features
- All features from 2.0.0
- Configurable reporting
- Enhanced analytics
- Dashboard integration

## Migration from 2.0.0
Configure reporting settings as needed.'),

-- Rate Limiting 3.0.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'rate-limiting' AND version = '3.0.0'), 'overview',
'# Rate Limiting Policy 3.0.0

## Overview
Next-generation rate limiting with AI-powered predictions.

## New Features in 3.0.0
- **AI Predictions**: Machine learning-based rate limit predictions
- **Predictive Scaling**: Automatic adjustment based on patterns
- **Smart Throttling**: Intelligent throttling decisions

## Key Features
- AI-powered predictions
- Predictive scaling
- Smart throttling
- Advanced analytics

## Migration from 2.1.0
Enable `aiPrediction` for AI features.'),

-- JWT Authentication 1.0.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'jwt-authentication' AND version = '1.0.0'), 'overview',
'# JWT Authentication Policy 1.0.0

## Overview
The JWT Authentication Policy validates JSON Web Tokens (JWT) to authenticate API requests. It supports various signing algorithms and configurable validation parameters.

## Key Features
- JWT token validation
- Configurable signing algorithms (RS256, HS256, ES256)
- Issuer and audience validation
- Flexible header configuration

## Security Considerations
- Always use HTTPS in production
- Regularly rotate signing keys
- Set appropriate token expiration times
- Validate issuer and audience claims'),

-- JWT Authentication 2.2.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'jwt-authentication' AND version = '2.2.0'), 'overview',
'# JWT Authentication Policy 2.2.0

## Overview
Enhanced JWT validation with advanced security features including replay attack protection.

## New Features in 2.2.0
- **Replay Attack Protection**: Prevent token replay attacks
- **Token Blacklisting**: Support for token blacklists
- **Enhanced Security**: Additional security measures

## Key Features
- All features from 2.1.0
- Replay attack protection
- Token blacklisting
- Advanced security features

## Migration from 2.1.0
Enable security features for enhanced protection.'),

-- JWT Authentication 3.0.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'jwt-authentication' AND version = '3.0.0'), 'overview',
'# JWT Authentication Policy 3.0.0

## Overview
Next-generation JWT validation with AI-powered threat detection.

## New Features in 3.0.0
- **AI Threat Detection**: Machine learning-based threat detection
- **Predictive Security**: Predict and prevent JWT-based attacks
- **Adaptive Validation**: Self-learning validation rules

## Key Features
- All features from 2.2.0
- AI-based threat detection
- Predictive security
- Adaptive validation

## Migration from 2.2.0
Enable AI features for advanced threat protection.'),

-- CORS Policy 1.2.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'cors-policy' AND version = '1.2.0'), 'overview',
'# CORS Policy 1.2.0

## Overview
The CORS Policy manages Cross-Origin Resource Sharing headers to enable secure cross-origin requests to your APIs.

## New Features in 1.2.0
- **Dynamic Origin Validation**: Use regex patterns for origin validation
- **Wildcard Support**: Enhanced wildcard matching for origins
- **Performance Improvements**: Optimized header processing

## Key Features
- Configurable allowed origins, methods, and headers
- Credentials support
- Preflight request handling
- Dynamic origin validation with regex patterns

## Best Practices
- Avoid using "*" for origins in production
- Be specific about allowed methods and headers
- Test CORS configuration thoroughly'),

-- API Throttling 2.0.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'api-throttling' AND version = '2.0.0'), 'overview',
'# API Throttling Policy 2.0.0

## Overview
Next-generation throttling policy with machine learning capabilities for adaptive rate limiting.

## Key Features
- ML-based adaptive throttling
- Multiple throttling algorithms
- Custom key extraction
- Burst capacity management
- Real-time adjustment based on traffic patterns

## ML-Adaptive Throttling
The ML-adaptive mode automatically adjusts rate limits based on:
- Historical traffic patterns
- Current system load
- Error rates and response times
- User behavior analysis'),

-- Header Validation 1.0.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'header-validation' AND version = '1.0.0'), 'overview',
'# Header Validation Policy 1.0.0

## Overview
The Header Validation Policy validates HTTP headers in API requests to ensure security and compliance.

## Key Features
- Required header validation
- Forbidden header blocking
- Custom validation rules
- Pattern-based validation

## Use Cases
- Enforce API security standards
- Validate required headers
- Block malicious headers
- Ensure compliance with regulations'),

-- Header Validation 1.1.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'header-validation' AND version = '1.1.0'), 'overview',
'# Header Validation Policy 1.1.0

## Overview
Enhanced header validation with regex patterns and case sensitivity options.

## New Features in 1.1.0
- **Regex Patterns**: Support for regular expression validation
- **Case Sensitivity**: Configurable case sensitivity
- **Empty Value Handling**: Options for empty header values

## Key Features
- All features from 1.0.0
- Regex pattern validation
- Case sensitivity control
- Empty value policies

## Migration from 1.0.0
Add regex patterns to existing validations for enhanced security.'),

-- Header Validation 2.0.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'header-validation' AND version = '2.0.0'), 'overview',
'# Header Validation Policy 2.0.0

## Overview
Advanced header validation with custom scripts and transformation capabilities.

## New Features in 2.0.0
- **Custom Scripts**: JavaScript-based validation logic
- **Header Transformations**: Modify headers during validation
- **Advanced Rules**: Complex validation scenarios

## Key Features
- All features from 1.1.0
- Custom validation scripts
- Header transformation
- Advanced validation rules

## Migration from 1.1.0
Migrate simple patterns to scripts for complex validations.'),

-- Header Validation 2.1.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'header-validation' AND version = '2.1.0'), 'overview',
'# Header Validation Policy 2.1.0

## Overview
Performance-optimized header validation with caching support.

## New Features in 2.1.0
- **Validation Caching**: Cache validation results for performance
- **Optimized Processing**: Faster header processing
- **Memory Efficiency**: Reduced memory usage

## Key Features
- All features from 2.0.0
- Validation result caching
- Performance optimizations
- Memory efficiency

## Migration from 2.0.0
Enable caching for better performance in high-traffic scenarios.'),

-- Header Validation 3.0.0 docs
((SELECT id FROM policy_version WHERE policy_name = 'header-validation' AND version = '3.0.0'), 'overview',
'# Header Validation Policy 3.0.0

## Overview
AI-powered header validation with anomaly detection capabilities.

## New Features in 3.0.0
- **AI Anomaly Detection**: Machine learning-based anomaly detection
- **Predictive Validation**: Predict and prevent malicious headers
- **Adaptive Rules**: Self-learning validation rules

## Key Features
- All features from 2.1.0
- AI-based anomaly detection
- Predictive validation
- Adaptive rule learning

## Migration from 2.1.0
Enable AI features for advanced threat detection.');

COMMIT;
