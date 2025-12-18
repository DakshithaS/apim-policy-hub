import { useState, useEffect, useCallback } from 'react';
import { Box, TextField, InputAdornment, IconButton } from '@mui/material';
import { Search, Clear } from '@mui/icons-material';
import { useDebouncedValue } from '@/hooks/ui/useDebouncedValue';

interface SearchInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  debounceMs?: number;
  fullWidth?: boolean;
  size?: 'small' | 'medium';
}

export function SearchInput({
  value,
  onChange,
  placeholder = 'Search policies...',
  debounceMs = 300,
  fullWidth = true,
}: SearchInputProps) {
  const [internalValue, setInternalValue] = useState(value);
  const debouncedValue = useDebouncedValue(internalValue, debounceMs);

  useEffect(() => {
    setInternalValue(value);
  }, [value]);

  useEffect(() => {
    if (debouncedValue.value !== value) {
      onChange(debouncedValue.value);
    }
  }, [debouncedValue, value, onChange]);

  const handleClear = useCallback(() => {
    setInternalValue('');
    onChange('');
  }, [onChange]);

  return (
    <Box>
      <TextField
        value={internalValue}
        onChange={e => setInternalValue(e.target.value)}
        placeholder={placeholder}
        fullWidth={fullWidth}
        variant="outlined"
        InputProps={{
          startAdornment: (
            <InputAdornment position="start">
              <Search sx={{ fontSize: 20, color: 'text.secondary' }} />
            </InputAdornment>
          ),
          endAdornment: internalValue && (
            <InputAdornment position="end">
              <IconButton
                size="small"
                onClick={handleClear}
                aria-label="Clear search"
                sx={{
                  color: 'text.secondary',
                  '&:hover': { color: 'text.primary' },
                }}
              >
                <Clear fontSize="small" />
              </IconButton>
            </InputAdornment>
          ),
        }}
        sx={{
          '& .MuiOutlinedInput-root': {
            height: 42, 
            borderRadius: 1,
            backgroundColor: 'background.paper',
            boxShadow: '0 1px 4px rgba(0,0,0,0.06)',
            transition: 'all 0.2s ease',

            '& fieldset': {
              borderColor: 'divider',
            },

            '&:hover fieldset': {
              borderColor: 'text.secondary',
            },

            '&.Mui-focused': {
              boxShadow: theme => `0 0 0 2px ${theme.palette.primary.main}22`,
              '& fieldset': {
                borderColor: 'primary.main',
                borderWidth: 1,
              },
            },
          },

          '& input': {
            fontSize: 14,
            padding: '10px 0',
          },
        }}
      />
    </Box>
  );
}
