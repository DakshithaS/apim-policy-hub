import {
  Box,
  Typography,
  Checkbox,
  Button,
  Chip,
  Stack,
  Accordion,
  AccordionSummary,
  AccordionDetails,
  useMediaQuery,
} from '@mui/material';
import { ExpandMore } from '@mui/icons-material';
import { FilterState } from '@/lib/types';
import { useTheme } from '@mui/material/styles';
import { capitalize } from '@/lib/utils';
import { useState, useCallback } from 'react';
import { UI_LIMITS } from '@/lib/constants';

interface FilterPanelProps {
  filters: FilterState;
  availableCategories?: string[];
  availableProviders?: string[];
  availablePlatforms?: string[];
  onChange: (filters: Partial<FilterState>) => void;
  isLoading?: boolean;
}

function FilterPanel({
  filters,
  availableCategories = [],
  availableProviders = [],
  availablePlatforms = [],
  onChange,
  isLoading = false,
}: FilterPanelProps) {
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('md'));

  // State for collapsible sections
  const [isShowAllCategories, setIsShowAllCategories] = useState(false);
  const [isShowAllProviders, setIsShowAllProviders] = useState(false);
  const [isShowAllPlatforms, setIsShowAllPlatforms] = useState(false);

  const activeFiltersCount =
    filters.categories.length +
    filters.providers.length +
    filters.platforms.length;

  const handleCheckboxChange = useCallback(
    (
      filterType: 'categories' | 'providers' | 'platforms',
      value: string,
      checked: boolean
    ) => {
      const currentValues = filters[filterType];
      const newValues = checked
        ? [...currentValues, value]
        : currentValues.filter(item => item !== value);

      onChange({ [filterType]: newValues });
    },
    [filters, onChange]
  );

  const handleClearFilterType = useCallback(
    (filterType: 'categories' | 'providers' | 'platforms') => {
      onChange({ [filterType]: [] });
    },
    [onChange]
  );

  const renderCheckboxGroup = (
    title: string,
    items: string[],
    selectedItems: string[],
    filterType: 'categories' | 'providers' | 'platforms',
    maxVisible: number,
    showAll: boolean,
    setShowAll: (show: boolean) => void
  ) => {
    const visibleItems = showAll ? items : items.slice(0, maxVisible);
    const hasMore = items.length > maxVisible;
    const hasSelected = selectedItems.length > 0;
    return (
      <Box sx={{ width: '100%' }}>
        <Box
          sx={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            mb: 1,
          }}
        >
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Typography
              sx={{ fontWeight: 700, fontSize: 14, color: '#f77005' }}
            >
              {title}
            </Typography>

            {hasSelected && (
              <Chip
                label={`${selectedItems.length} selected`}
                size="small"
                sx={{
                  height: 18,
                  fontSize: 11,
                  fontWeight: 600,
                  bgcolor: '#f8ceacff',
                  color: 'text.primary',
                  borderRadius: 1,
                }}
              />
            )}
          </Box>

          {hasSelected && (
            <Button
              variant="text"
              size="small"
              onClick={() => handleClearFilterType(filterType)}
              disabled={isLoading}
              sx={{
                minWidth: 'auto',
                p: 0,
                fontSize: 12,
                textTransform: 'none',
                color: 'text.secondary',
                '&:hover': {
                  backgroundColor: 'transparent',
                  textDecoration: 'underline',
                },
              }}
            >
              Clear
            </Button>
          )}
        </Box>

        {/* Items list (like your image) */}
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.25 }}>
          {visibleItems.map(item => {
            const checked = selectedItems.includes(item);

            return (
              <Box
                key={item}
                sx={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  py: 0.25,
                }}
              >
                <Typography
                  sx={{
                    fontSize: 13,
                    fontWeight: 600,
                    color: 'text.secondary',
                  }}
                >
                  {capitalize(item)}
                </Typography>

                <Checkbox
                  size="small"
                  checked={checked}
                  disabled={isLoading}
                  onChange={e =>
                    handleCheckboxChange(filterType, item, e.target.checked)
                  }
                  sx={{
                    p: 0.25,
                    '&.Mui-checked': {
                      color: theme.palette.warning.main,
                    },
                  }}
                />
              </Box>
            );
          })}
        </Box>

        {/* Show more (optional) */}
        {hasMore && (
          <Button
            size="small"
            variant="text"
            onClick={() => setShowAll(!showAll)}
            disabled={isLoading}
            sx={{
              mt: 0.5,
              minWidth: 'auto',
              p: 0,
              fontSize: 12,
              textTransform: 'none',
              color: 'text.secondary',
              '&:hover': {
                backgroundColor: 'transparent',
                textDecoration: 'underline',
              },
            }}
          >
            {showAll ? 'Show fewer' : `Show ${items.length - maxVisible} more`}
          </Button>
        )}
      </Box>
    );
  };

  const filterContent = (
    <Box sx={{ width: '100%' }}>
      {!isMobile && (
        <Box
          sx={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            mb: { xs: 2, sm: 3 },
            pb: { xs: 1, sm: 1.5 },
            borderBottom: '1px solid',
            borderColor: 'divider',
          }}
        >
          <Typography
            variant="h6"
            sx={{
              fontWeight: 600,
              color: 'text.primary',
            }}
          >
            Filters
          </Typography>
        </Box>
      )}
      <Stack spacing={{ xs: 2.5, sm: 3 }}>
        {availableCategories.length > 0 &&
          renderCheckboxGroup(
            'Categories',
            availableCategories,
            filters.categories,
            'categories',
            UI_LIMITS.MAX_CATEGORIES_VISIBLE,
            isShowAllCategories,
            setIsShowAllCategories
          )}
        {availableProviders.length > 0 &&
          renderCheckboxGroup(
            'Providers',
            availableProviders,
            filters.providers,
            'providers',
            UI_LIMITS.MAX_PROVIDERS_VISIBLE,
            isShowAllProviders,
            setIsShowAllProviders
          )}
        {availablePlatforms.length > 0 &&
          renderCheckboxGroup(
            'Platforms',
            availablePlatforms,
            filters.platforms,
            'platforms',
            UI_LIMITS.MAX_PLATFORMS_VISIBLE,
            isShowAllPlatforms,
            setIsShowAllPlatforms
          )}{' '}
        {availablePlatforms.length === 0 && (
          <Box
            sx={{
              p: 2,
              backgroundColor: 'background.default',
              borderRadius: 2,
              border: '1px solid',
              borderColor: 'divider',
              textAlign: 'center',
            }}
          >
            <Typography
              variant="subtitle1"
              sx={{
                fontWeight: 600,
                color: 'text.secondary',
                mb: 1,
              }}
            >
              Platforms
            </Typography>
            <Typography
              variant="body2"
              sx={{
                color: 'text.secondary',
                fontStyle: 'italic',
              }}
            >
              Platform filter coming soon
            </Typography>
          </Box>
        )}
      </Stack>
    </Box>
  );

  if (isMobile) {
    return (
      <Accordion
        sx={{
          mb: { xs: 1, sm: 2 },
          borderRadius: 2,
          boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
          border: '1px solid',
          borderColor: 'divider',
          '&:before': {
            display: 'none',
          },
          '&.Mui-expanded': {
            margin: 0,
            mb: { xs: 2, sm: 3 },
          },
        }}
      >
        <AccordionSummary
          expandIcon={<ExpandMore />}
          sx={{
            '& .MuiAccordionSummary-content': {
              alignItems: 'center',
            },
            '& .MuiAccordionSummary-expandIconWrapper': {
              color: 'primary.main',
            },
          }}
        >
          <Typography
            variant="h6"
            sx={{
              display: 'flex',
              alignItems: 'center',
              gap: 1,
              color: 'text.primary',
            }}
          >
            Filters
            {activeFiltersCount > 0 && (
              <Chip
                label={activeFiltersCount}
                size="small"
                color="primary"
                sx={{
                  height: 20,
                  fontSize: '0.7rem',
                  fontWeight: 600,
                }}
              />
            )}
          </Typography>
        </AccordionSummary>
        <AccordionDetails sx={{ p: { xs: 2, sm: 3 }, pt: 0 }}>
          {filterContent}
        </AccordionDetails>
      </Accordion>
    );
  }

  return (
    <Box
      sx={{
        height: 'fit-content',
        borderColor: 'divider',
        p: { xs: 2, sm: 3 },
      }}
    >
      {filterContent}
    </Box>
  );
}

export { FilterPanel };
