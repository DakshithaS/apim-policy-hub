/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

// API configuration
export const API_CONFIG = {
  BASE_URL: import.meta.env.VITE_API_URL || 'http://localhost:8080',
} as const;

// Route constants
export const ROUTES = {
  HOME: '/',
  POLICIES: '/policies',
  POLICY_DETAIL: '/policies/:name',
  POLICY_VERSION: '/policies/:name/versions/:version',
  CUSTOM_POLICY_GUIDE: '/custom-policy-guide',
  ABOUT: '/about',
} as const;
