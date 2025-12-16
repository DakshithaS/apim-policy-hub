/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

import { useState, useEffect } from 'react';
import { TIMING } from '@/lib/constants';

interface UseDebouncedValueReturn<T> {
  value: T;
}

/**
 * Hook for debouncing a value
 */
export function useDebouncedValue<T>(
  value: T,
  delay: number = TIMING.DEBOUNCE_DELAY
): UseDebouncedValueReturn<T> {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);

  return { value: debouncedValue };
}
