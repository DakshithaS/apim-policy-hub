import {
  Box,
  Container,
  Typography,
  Button,
  Stack,
  Grid,
  useMediaQuery,
} from '@mui/material';
import { ArrowForward } from '@mui/icons-material';
import { useTheme } from '@mui/material/styles';
import { Link as RouterLink } from 'react-router-dom';
import { ROUTES } from '@/lib/constants';
import policyHubSvg from '../images/policyhub.svg';
import Contribute from '../images/Contribute.svg';
import { PolicyCatalogSection } from '@/components/common/PolicyCatalogSection';

export function HomePage() {
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('sm'));
  return (
    <Box>
      <Box
        sx={{
          position: 'relative',
          overflow: 'hidden',
          py: { xs: 2, md: 4 },
          color: 'common.white',
          bgcolor: '#0B0F14',
          '&::before': {
            content: '""',
            position: 'absolute',
            inset: 0,
            background: `
        radial-gradient(
          700px 350px at 50% 20%,
          rgba(255, 140, 0, 0.35),
          transparent 60%
        ),
        radial-gradient(
          600px 300px at 70% 50%,
          rgba(255, 94, 0, 0.25),
          transparent 55%
        )
      `,
            pointerEvents: 'none',
          },
        }}
      >
        <Container maxWidth="lg" sx={{ position: 'relative' }}>
          <Grid container spacing={{ xs: 4, md: 6 }} alignItems="center">
            {/* LEFT: Text */}
            <Grid size={{ xs: 12, md: 7 }}>
              <Box sx={{ textAlign: { xs: 'center', md: 'left' } }}>
                <Typography
                  variant= "h2"
                  component="h1"
                  sx={{
                    fontWeight: 700,
                    mb: 1,
                    fontSize: { xs: '2rem', sm: '2.8rem', md: '3.4rem' },
                    lineHeight: 1.15,
                  }}
                >
                  <Box component="span" sx={{ color: '#ffffffff' }}>
                    API Platform
                  </Box>{' '}
                  <Box component="span" sx={{ color: '#FF8C00' }}>
                    Policy Hub
                  </Box>
                </Typography>

                <Typography
                  variant={isMobile ? "body2" : "h6"}
                  sx={{
                    mb: 2,
                    color: 'rgba(255,255,255,0.75)',
                    maxWidth: { xs: '100%', md: 640 },
                    mx: { xs: 'auto', md: 0 },
                    lineHeight: 1.6,
                  }}
                >
                  Discover, explore, and implement production-ready API
                  management policies to secure, govern, and scale your WSO2 API
                  Platform.
                </Typography>
                <Stack
                  direction="row"
                  spacing={2}
                  justifyContent={{ xs: 'center', md: 'flex-start' }}
                >
                  <Button
                    component={RouterLink}
                    to={ROUTES.CUSTOM_POLICY_GUIDE}
                    size="large"
                    variant="contained"
                    endIcon={<ArrowForward />}
                    sx={{
                      borderRadius: 3,
                      color: '#eeedecff',
                      px: 3.5,
                      fontWeight: 600,
                    }}
                  >
                    Contribute to Custom Policies
                  </Button>
                </Stack>
              </Box>
            </Grid>

            <Grid size={{ xs: 12, md: 5 }}>
              <Box
                sx={{
                  display: 'flex',
                  justifyContent: { xs: 'center', md: 'flex-end' },
                }}
              >
                <Box
                  component="img"
                  src={policyHubSvg}
                  alt="Policy Hub"
                  sx={{
                    width: isMobile ? 220 : { sm: 280, md: 300 },
                    maxWidth: '100%',
                    height: 'auto',
                  }}
                />
              </Box>
            </Grid>
          </Grid>
        </Container>
      </Box>

      <Box sx={{ bgcolor: 'background.default' }}>
        <PolicyCatalogSection showSearchBar />
      </Box>
      {/* Custom Policies Banner */}
      <Box
        sx={{
          position: 'relative',
          overflow: 'hidden',
          py: { xs: 4, md: 6 },
          bgcolor: '#0B0F14',
          color: 'common.white',
          '&::before': {
            content: '""',
            position: 'absolute',
            inset: 0,
            background: `
        radial-gradient(700px 320px at 20% 30%, rgba(255,140,0,0.22), transparent 60%),
        radial-gradient(600px 300px at 80% 60%, rgba(255,94,0,0.14), transparent 65%)
      `,
            pointerEvents: 'none',
          },
        }}
      >
        <Container maxWidth="lg" sx={{ position: 'relative' }}>
          {/* Left content */}
          <Grid container spacing={4} alignItems="center">
            {/* LEFT: Vector */}
            <Grid size={{ xs: 12, md: 5 }}>
              <Box
                sx={{
                  display: 'flex',
                  justifyContent: { xs: 'center', md: 'flex-start' },
                  alignItems: 'center',
                }}
              >
                <Box
                  component="img"
                  src={Contribute}
                  alt="Custom policies"
                  sx={{
                    width: { xs: '100%', md: 340 },
                    maxWidth: '100%',
                    height: 'auto',
                    opacity: 0.95,
                  }}
                />
              </Box>
            </Grid>

            {/* RIGHT: Content */}
            <Grid size={{ xs: 12, md: 7 }}>
              <Typography
                variant="h4"
                component="h2"
                sx={{ fontWeight: 800, mb: 1.5, lineHeight: 1.2 }}
              >
                Want to Contribute a Custom Policy?
              </Typography>

              <Typography
                variant="h6"
                sx={{
                  color: 'rgba(255,255,255,0.75)',
                  lineHeight: 1.7,
                  maxWidth: 680,
                  mb: 3,
                }}
              >
                Follow our step-by-step guide to create, validate, and publish
                your own policy for the WSO2 API Platform. Share reusable
                governance and security controls with your teams.
              </Typography>

              <Button
                component={RouterLink}
                to={ROUTES.CUSTOM_POLICY_GUIDE}
                variant="contained"
                size="large"
                endIcon={<ArrowForward />}
                sx={{
                  borderRadius: 3,
                  px: 3.5,
                  fontWeight: 700,
                }}
              >
                Go to Custom Policy Guide
              </Button>
            </Grid>
          </Grid>
        </Container>
      </Box>
    </Box>
  );
}
