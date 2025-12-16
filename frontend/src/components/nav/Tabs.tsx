/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

import {
  Tabs as MuiTabs,
  Tab,
  Box,
} from '@mui/material';
import { ReactNode } from 'react';

export interface TabItem {
  label: string;
  value: string;
  disabled?: boolean;
  icon?: ReactNode;
}

interface TabsProps {
  value: string;
  onChange: (value: string) => void;
  items: TabItem[];
  variant?: 'standard' | 'scrollable' | 'fullWidth';
  orientation?: 'horizontal' | 'vertical';
}

export function Tabs({
  value,
  onChange,
  items,
  variant = 'standard',
  orientation = 'horizontal',
}: TabsProps) {
  const handleChange = (_: React.SyntheticEvent, newValue: string) => {
    onChange(newValue);
  };

  return (
    <Box
      sx={{
        borderBottom: orientation === 'horizontal' ? 1 : 0,
        borderColor: 'divider',
        mb: 2,
      }}
    >
      <MuiTabs
        value={value}
        onChange={handleChange}
        variant={variant}
        orientation={orientation}
        scrollButtons="auto"
        allowScrollButtonsMobile
      >
        {items.map((item) => (
          <Tab
            key={item.value}
            label={item.label}
            value={item.value}
            disabled={item.disabled}
            icon={item.icon as any}
            iconPosition={item.icon ? 'start' : undefined}
          />
        ))}
      </MuiTabs>
    </Box>
  );
}
