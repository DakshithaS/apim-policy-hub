/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

import { useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { routes } from '@/lib/utils';

interface UsePolicyNavigationReturn {
  handleVersionChange: (version: string) => void;
}

/**
 * Hook for handling policy version navigation
 * Extracts shared navigation logic from PolicyDetailPage and PolicyVersionPage
 */
export function usePolicyNavigation(
  policyName: string,
  latestVersion: string | undefined
): UsePolicyNavigationReturn {
  const navigate = useNavigate();

  const handleVersionChange = useCallback(
    (version: string) => {
      if (version === latestVersion) {
        navigate(routes.policyDetail(policyName));
      } else {
        navigate(routes.policyVersion(policyName, version));
      }
    },
    [latestVersion, policyName, navigate]
  );

  return {
    handleVersionChange,
  };
}
