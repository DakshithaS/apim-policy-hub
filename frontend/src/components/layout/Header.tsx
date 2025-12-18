import { useState } from 'react';
import {
  AppBar,
  Toolbar,
  Typography,
  Button,
  Box,
  Container,
  IconButton,
  Menu,
  MenuItem,
  useMediaQuery,
} from '@mui/material';
import { useTheme } from '@mui/material/styles';
import { Menu as MenuIcon } from '@mui/icons-material';
import { Link, useLocation } from 'react-router-dom';
import { ThemeToggle } from '@/components/common/ThemeToggle';
import { ROUTES } from '@/lib/constants';

const navigationItems = [
  { label: 'Policies', path: ROUTES.POLICIES },
  { label: 'Custom Policy Guide', path: ROUTES.CUSTOM_POLICY_GUIDE },
  { label: 'About', path: ROUTES.ABOUT },
];

export function Header() {
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('md'));
  const location = useLocation();
  const [mobileMenuAnchor, setMobileMenuAnchor] = useState<null | HTMLElement>(
    null
  );

  const handleMobileMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
    setMobileMenuAnchor(event.currentTarget);
  };

  const handleMobileMenuClose = () => {
    setMobileMenuAnchor(null);
  };

  const isActivePath = (path: string) => {
    if (path === ROUTES.POLICIES) {
      return (
        location.pathname === path || location.pathname.startsWith('/policies')
      );
    }
    return location.pathname === path;
  };

  const renderDesktopNav = () => (
    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
      {navigationItems.map(item => {
        const active = isActivePath(item.path);
        return (
          <Button
            key={item.path}
            component={Link}
            to={item.path}
            sx={{
              color: active ? '#FFFFFF' : 'rgba(255,255,255,0.8)',
              fontWeight: active ? 700 : 500,
              textTransform: 'none',
              px: 2.5,
              py: 1,
              borderRadius: 2,
              backgroundColor: active ? 'rgba(255,140,0,0.14)' : 'transparent',
              border: active
                ? '1px solid rgba(255,140,0,0.35)'
                : '1px solid transparent',
              '&:hover': {
                backgroundColor: 'rgba(255,140,0,0.12)',
                borderColor: 'rgba(255,140,0,0.3)',
              },
            }}
          >
            {item.label}
          </Button>
        );
      })}

      <Box sx={{ ml: 1 }}>
        <ThemeToggle />
      </Box>
    </Box>
  );

  const renderMobileNav = () => (
    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
      <ThemeToggle />
      <IconButton onClick={handleMobileMenuOpen} sx={{ color: '#FFFFFF' }}>
        <MenuIcon />
      </IconButton>

      <Menu
        anchorEl={mobileMenuAnchor}
        open={Boolean(mobileMenuAnchor)}
        onClose={handleMobileMenuClose}
        PaperProps={{
          sx: {
            mt: 1,
            bgcolor: '#0B0F14',
            color: '#FFFFFF',
            border: '1px solid rgba(255,140,0,0.25)',
            borderRadius: 2,
          },
        }}
      >
        {navigationItems.map(item => {
          const active = isActivePath(item.path);
          return (
            <MenuItem
              key={item.path}
              component={Link}
              to={item.path}
              onClick={handleMobileMenuClose}
              selected={active}
              sx={{
                '&.Mui-selected': {
                  bgcolor: 'rgba(255,140,0,0.18)',
                },
                '&:hover': {
                  bgcolor: 'rgba(255,140,0,0.12)',
                },
              }}
            >
              {item.label}
            </MenuItem>
          );
        })}
      </Menu>
    </Box>
  );

  return (
    <AppBar
      position="sticky"
      elevation={0}
      sx={{
        bgcolor: '#0B0F14',
        boxShadow: 'none',
        overflow: 'hidden',
        '&::after': {
          content: '""',
          position: 'absolute',
          inset: 0,
          background: `
        radial-gradient(
          900px 450px at 50% 30%,
          rgba(255, 140, 0, 0.18),
          transparent 70%
        ),
        radial-gradient(
          800px 400px at 70% 60%,
          rgba(255, 94, 0, 0.12),
          transparent 75%
        )
      `,
          pointerEvents: 'none',
        },
      }}
    >
      <Container maxWidth="xl" sx={{ position: 'relative' }}>
        <Toolbar sx={{ justifyContent: 'space-between', py: 1 }}>
          {/* Logo */}
          <Box
            component={Link}
            to={ROUTES.HOME}
            sx={{
              display: 'flex',
              alignItems: 'center',
              textDecoration: 'none',
              color: 'inherit',
            }}
          >
            <Box
              sx={{
                width: 40,
                height: 40,
                mr: 2,
                borderRadius: 2,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontWeight: 800,
                fontSize: '1.1rem',
                color: '#FFFFFF',
                border: '1px solid rgba(255,140,0,0.45)',
              }}
            >
              W
            </Box>

            <Typography
              variant="h6"
              sx={{
                fontWeight: 700,
                color: '#FFFFFF',
                fontSize: '1.15rem',
              }}
            >
              Policy Hub
            </Typography>
          </Box>

          {isMobile ? renderMobileNav() : renderDesktopNav()}
        </Toolbar>
      </Container>
    </AppBar>
  );
}
