/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

import { useErrorNotification } from '@/contexts/ErrorNotificationContext';
import { useCallback } from 'react';
import { ApiError } from '@/lib/types';

/**
 * Custom hook for handling errors consistently across the application
 * Provides standardized error handling and notification methods
 */
export function useErrorHandler() {
  const notification = useErrorNotification();

  const handleError = useCallback((
    error: ApiError | Error | string | unknown,
    context?: string
  ) => {
    let message: string;
    
    if (typeof error === 'string') {
      message = error;
    } else if (error instanceof Error) {
      message = error.message;
    } else if (error && typeof error === 'object' && 'message' in error) {
      message = (error as ApiError).message;
    } else {
      message = 'An unexpected error occurred';
    }

    // Add context if provided
    if (context) {
      message = `${context}: ${message}`;
    }

    // Show error notification
    notification.showError(message);

    // Log error in development
    if (import.meta.env.DEV) {
      console.error('Error handled by useErrorHandler:', error);
      if (context) {
        console.error('Error context:', context);
      }
    }
  }, [notification]);

  const handleApiError = useCallback((
    error: ApiError | Error,
    context?: string
  ) => {
    handleError(error, context);
  }, [handleError]);

  const showSuccess = useCallback((message: string) => {
    notification.showSuccess(message);
  }, [notification]);

  const showWarning = useCallback((message: string) => {
    notification.showWarning(message);
  }, [notification]);

  const showInfo = useCallback((message: string) => {
    notification.showInfo(message);
  }, [notification]);

  return {
    handleError,
    handleApiError,
    showSuccess,
    showWarning,
    showInfo,
    clearAll: notification.clearAll,
  };
}
