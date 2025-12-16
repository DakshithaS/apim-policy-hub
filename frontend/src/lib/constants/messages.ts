/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

// Loading and error messages
export const MESSAGES = {
  LOADING: 'Loading...',
  NO_POLICIES_FOUND: 'No policies found',
  NO_POLICIES_FOUND_DESCRIPTION: 'Try adjusting your search or filters to find what you\'re looking for.',
  POLICY_NOT_FOUND: 'Policy not found',
  VERSION_NOT_FOUND: 'Version not found',
  DOCS_NOT_AVAILABLE: 'Documentation not available',
  ERROR_LOADING_POLICIES: 'Error loading policies',
  ERROR_LOADING_POLICY: 'Error loading policy',
  ERROR_LOADING_VERSIONS: 'Error loading versions',
  ERROR_LOADING_DOCS: 'Error loading documentation',
  ERROR_NETWORK: 'Network error occurred',
  ERROR_TIMEOUT: 'Request timed out',
  ERROR_UNKNOWN: 'An unexpected error occurred',
  SUCCESS_COPIED: 'Copied to clipboard',
  SUCCESS_SAVED: 'Successfully saved',
} as const;
