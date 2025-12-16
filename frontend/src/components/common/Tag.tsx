/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

import { Chip, ChipProps } from '@mui/material';
import { capitalize } from '@/lib/utils';

interface TagProps extends Omit<ChipProps, 'label'> {
  label: string;
  variant?: 'filled' | 'outlined';
}

export function Tag({ label, variant = 'filled', ...props }: TagProps) {
  return (
    <Chip
      label={capitalize(label)}
      variant={variant}
      size="small"
      {...props}
      sx={{
        fontSize: '0.7rem',
        height: 26,
        fontWeight: 600,
        letterSpacing: '0.02em',
        transition: 'all 0.2s ease-in-out',
        '&:hover': {
          transform: 'translateY(-1px)',
          ...(variant === 'filled' && {
            boxShadow: '0 2px 6px rgba(0,0,0,0.15)',
          }),
        },
        '& .MuiChip-label': {
          px: 1.25,
        },
        ...props.sx,
      }}
    />
  );
}
