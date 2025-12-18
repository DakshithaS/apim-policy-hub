import { useMemo, useCallback, useEffect } from 'react';
import { Box, Container, Grid, useMediaQuery } from '@mui/material';
import { useTheme } from '@mui/material/styles';
import { useQueryParams } from '@/hooks/state/useQueryParams';
import { useAsyncData } from '@/hooks/data/useAsyncData';
import { useAppData } from '@/contexts/AppDataContext';

import { apiClient } from '@/lib/apiClient';
import { filterStateToParams } from '@/lib/utils';

import { SearchInput } from '@/components/common/SearchInput';
import { PolicyList } from '@/components/policies/PolicyList';
import { FilterPanel } from '@/components/policies/FilterPanel';

type Props = {
  /** If you want the search input to appear inside this section (useful for HomePage). */
  showSearchBar?: boolean;
};

export function PolicyCatalogSection({ showSearchBar = false }: Props) {
  const { filters, updateFilters, resetFilters } = useQueryParams();
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('md'));
  const { categories, providers, platforms, ensureLoaded } = useAppData();

  useEffect(() => {
    ensureLoaded();
  }, [ensureLoaded]);

  const {
    data: policiesResponse,
    loading: policiesLoading,
    error: policiesError,
  } = useAsyncData(
    () => {
      const params = filterStateToParams(filters);
      return apiClient.listPolicies(params);
    },
    [filters],
    { immediate: true }
  );

  const policies = policiesResponse?.data ?? [];
  const pagination = policiesResponse?.meta?.pagination;

  const filterOptions = useMemo(
    () => ({
      categories,
      providers,
      platforms,
    }),
    [categories, providers, platforms]
  );

  const handlePageChange = useCallback(
    (page: number) => updateFilters({ page }),
    [updateFilters]
  );

  const handlePageSizeChange = useCallback(
    (pageSize: number) => updateFilters({ pageSize, page: 1 }),
    [updateFilters]
  );

  const handleSearchChange = useCallback(
    (search: string) => updateFilters({ search, page: 1 }),
    [updateFilters]
  );

  const handleFilterChange = useCallback(
    (newFilters: Partial<typeof filters>) => updateFilters(newFilters),
    [updateFilters]
  );

  return (
    <Box sx={{ flex: 1, py: 4 }}>
      {/* Main Content Grid */}
      <Container
        maxWidth={false}
        sx={{ maxWidth: '1600px', mx: 'auto', px: { xs: 2, sm: 3, md: 4 } }}
      >
        <Grid
          container
          spacing={{ xs: 3, md: 4 }}
          columns={{ xs: 1, lg: 12 }}
          sx={{ minHeight: '60vh' }}
        >
          {/* Filter Sidebar */}
          <Grid size={{ xs: 1, lg: 3 }}>
            <Box
              sx={{
                position: { lg: 'sticky' },
                top: '2rem',
                maxHeight: { lg: 'calc(100vh - 200px)' },
                overflowY: { lg: 'auto' },
                borderRight: { lg: '0.5px solid rgba(255, 152, 0, 0.35)' },
              }}
            >
              <FilterPanel
                filters={filters}
                availableCategories={filterOptions.categories.filter(
                  (cat): cat is string => cat !== undefined
                )}
                availableProviders={filterOptions.providers}
                availablePlatforms={
                  filterOptions.platforms.filter(Boolean) as string[]
                }
                onChange={handleFilterChange}
                isLoading={policiesLoading}
              />
            </Box>
          </Grid>

          {/* Policy List */}
          <Grid size={{ xs: 1, lg: 9 }}>
            {showSearchBar && (
              <SearchInput
                value={filters.search}
                onChange={handleSearchChange}
                placeholder={
                  isMobile
                    ? 'Search policies'
                    : 'Search policies by name, description, or category...'
                }
                size="medium"
              />
            )}
            <PolicyList
              policies={policies}
              isLoading={policiesLoading}
              error={policiesError}
              pagination={pagination}
              onPageChange={handlePageChange}
              onPageSizeChange={handlePageSizeChange}
              onClearFilters={resetFilters}
            />
          </Grid>
        </Grid>
      </Container>
    </Box>
  );
}
