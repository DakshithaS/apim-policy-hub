/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

import { useMemo } from 'react';
import { useAsyncData } from './useAsyncData';
import { useAppData } from '@/contexts/AppDataContext';
import { apiClient } from '@/lib/apiClient';
import { Policy } from '@/lib/types';
import { PAGINATION_DEFAULTS } from '@/lib/constants';

interface UsePolicyVersionsReturn {
  versions: Policy[];
  latestVersion: string | undefined;
  versionsLoading: boolean;
  versionsError: Error | null;
}

interface PolicyVersionsResponse {
  success: boolean;
  data: Policy[] | null;
}

/**
 * Hook for fetching and managing policy versions with caching
 * Extracts shared logic from PolicyDetailPage and PolicyVersionPage
 */
export function usePolicyVersions(policyName: string): UsePolicyVersionsReturn {
  const { getVersionsCache, setVersionsCache } = useAppData();

  // Fetch policy versions with caching
  const {
    data: versionsResponse,
    loading: versionsLoading,
    error: versionsError,
  } = useAsyncData<PolicyVersionsResponse>(
    async () => {
      // Check cache first
      const cached = getVersionsCache(policyName);
      if (cached) {
        return { success: true, data: cached };
      }

      // Fetch from API
      const response = await apiClient.listPolicyVersions(policyName, {
        pageSize: PAGINATION_DEFAULTS.MAX_PAGE_SIZE
      });

      // Cache the versions
      if (response.success && response.data) {
        setVersionsCache(policyName, response.data);
      }

      return response;
    },
    [policyName, getVersionsCache, setVersionsCache],
    { immediate: true, cacheKey: `versions-${policyName}` }
  );

  // Derive versions array
  const versions = useMemo(
    () => (versionsResponse?.success ? versionsResponse.data || [] : []),
    [versionsResponse]
  );

  // Find latest version
  const latestVersion = useMemo(
    () => versions.find((v: Policy) => v.isLatest)?.version || versions[0]?.version,
    [versions]
  );

  return {
    versions,
    latestVersion,
    versionsLoading,
    versionsError: versionsError || null,
  };
}
