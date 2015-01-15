# P. mackerel stock assessment (1983-10)
# P. R. Crone (June 2011)
# Stock Synthesis 3 (v. 3.20b) - R. Methot
# Model XA: number of fisheries = 2 / surveys = 2 / time-step = annual / biological distributions = age, length, and mean length-at-age / selectivity = age-based
#
# NOTES: ** ... ** = Pending questions and/or comments
#
# STARTER FILE
#
XA.dat # Data file
XA.ctl # Control file
0 # Read initial values from 'par' file: 0 = no, 1 = yes
1 # DOS display detail: 0, 1, 2
2 # Report file detail: 0, 1, 2
0 # Detailed checkup.sso file: 0 = no, 1 = yes 
3 # Write parm values to ParmTrace.sso: 0=no, 1=good,active; 2=good,all; 3=every_iteration,all_parms; 4=every,active
2 # Write cumulative report: 0 = skip, 1 = short, 2 = full
0 # Include prior likelihood for non-estimated parameters 
1 # Use soft boundaries to aid convergence: 0 = no, 1 = yes (recommended)
1 # Number of bootstrap data files to produce    ** New parameterization **
20 # Last phase for estimation
10 # MCMC burn-in interval
2 # MCMC thinning interval
0 # Jitter initial parameter values by this fraction
-1 # Minimum year for SSB sd_report: (-1 = styr-2, i.e., virgin population)
-2 # Maximum year for SSB sd_report: (-1 = endyr, -2 = endyr+N_forecastyrs)
0 # N individual SD years 
0.0001 # final convergence criteria (e.g., 1.0e-04) 
0 # Retrospective year relative to end year (e.g., -4)
1 # Minimum age for 'summary' biomass
1 # Depletion basis (denominator is: 0 = skip, 1 = relative X*B0, 2 = relative X*Bmsy, 3 = relative X*B_styr
0.6 # Fraction for depletion denominator (e.g., 0.4)
1 # (1-SPR) report basis: 0 = skip, 1 = (1-SPR)/(1-SPR_tgt), 2 = (1-SPR)/(1-SPR_MSY), 3 = (1-SPR)/(1-SPR_Btarget), 4 = raw_SPR ** If no Forecast, then option = 4 **
1 # F SD report basis: 0 = skip, 1 = exploitation(Bio), 2 = exploitation(Num), 3 = sum(F_rates) ** If no Forecast, then option = 0 **
1 # F report basis: 0 = raw, 1 = F/Fspr, 2 = F/Fmsy, 3 = F/Fbtgt  ** New parameterization **
999 # End of file
