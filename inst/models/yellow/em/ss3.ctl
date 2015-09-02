#V3.24j-64bit
#_data_and_control_files: ss3.dat // em.ctl
#_SS-V3.24j-64bit-safe;_11/14/2012;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.0
1  #_N_Growth_Patterns
1 #_N_Morphs_Within_GrowthPattern
#_Cond 1 #_Morph_between/within_stdev_ratio (no read if N_morphs=1)
#_Cond  1 #vector_Morphdist_(-1_in_first_val_gives_normal_approx)
#
#_Cond 0  #  N recruitment designs goes here if N_GP*nseas*area>1
#_Cond 0  #  placeholder for recruitment interaction request
#_Cond 1 1 1  # example recruitment design element for GP=1, seas=1, area=1
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
0 #_Nblock_Patterns
#_Cond 0 #_blocks_per_pattern
# begin and end years of blocks
#
0.5 #_fracfemale
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
  #_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_speciific_K; 4=not implemented
1 #_Growth_Age_for_L1
999 #_Growth_Age_for_L2 (999 to use as Linf)
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=read fec and wt from wtatage.ss
#_placeholder for empirical age-maturity by growth pattern
0 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
1 #_env/block/dev_adjust_method (1=standard; 2=logistic transform keeps in base parm bounds; 3=standard w/ no bound check)
#
#_growth_parms
#_LO HI INIT PRIOR PR_type SD PHASE env-var use_dev dev_minyr dev_maxyr dev_stddev Block Block_Fxn
0.01 0.15 0.08 0.05 -1 0.0226 -6 0 0 0 0 0 0 0 # NatM_p_1_Fem_GP_1
 0.9 90 18 30 -1 99 6 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 3.1 310 62 66 -1 99 6 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.00235 0.235 0.047 0.05 -1 99 6 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.01 0.5 0.13 0.19 -1 99 7 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.01 0.5 0.13 0.1 -1 99 7 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
 -3 3 9.77e-006 2.09e-005 -1 99 -50 0 0 0 0 0 0 0 # Wtlen_1_Fem
 -3 4 3.17125 2.96956 -1 99 -50 0 0 0 0 0 0 0 # Wtlen_2_Fem
 38 39 38.78 40 -1 99 -50 0 0 0 0 0 0 0 # Mat50%_Fem
 -3 3 -0.437 -0.4 -1 99 -50 0 0 0 0 0 0 0 # Mat_slope_Fem
 -3 300000 137900 137900 -1 1 -6 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem
 -3 39000 36500 36500 -1 1 -6 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem
 0 2 1 1 -1 99 -50 0 0 0 0 0 0 0 # RecrDist_GP_1
 0 2 1 1 -1 99 -50 0 0 0 0 0 0 0 # RecrDist_Area_1
 0 2 1 1 -1 99 -50 0 0 0 0 0 0 0 # RecrDist_Seas_1
 0 2 1 1 -1 99 -50 0 0 0 0 0 0 0 # CohortGrowDev
#
#_Cond 0  #custom_MG-env_setup (0/1)
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no MG-environ parameters
#
#_Cond 0  #custom_MG-block_setup (0/1)
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no MG-block parameters
#_Cond No MG parm trends
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
#_Cond -4 #_MGparm_Dev_Phase
#
#_Spawner-Recruitment
3 #_SR_function: 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm
#_LO HI INIT PRIOR PR_type SD PHASE
 4 20 5.6 5 -1 99 1 # SR_LN(R0)
 0.2 1 0.44 0.44 -1 0.1 -7 # SR_BH_steep
 0 5 0.5 1 -1 99 -50 # SR_sigmaR
 -5 5 0 0 -1 99 -50 # SR_envlink
 -5 5 0 0 -1 99 -50 # SR_R1_offset
 -1 2 0 1 -1 99 -50 # SR_autocorr
0 #_SR_env_link
0 #_SR_env_target_0=none;1=devs;_2=R0;_3=steepness
1 #do_recdev:  0=none; 1=devvector; 2=simple deviations
1 # first year of main recr_devs; early devs can preceed this era
200 # last year of main recr_devs; forecast devs start in following year
2 #_recdev phase
1 # (0/1) to read 13 advanced options
 0 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
 -4 #_recdev_early_phase
 0 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 #_lambda for Fcast_recr_like occurring before endyr+1
-10 #_last_early_yr_nobias_adj_in_MPD
1 #_first_yr_fullbias_adj_in_MPD
200 #_last_yr_fullbias_adj_in_MPD
201 #_first_recent_yr_nobias_adj_in_MPD
 0.9 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
 0 #_period of cycles in recruitment (N parms read below)
 -5 #min rec_dev
 5 #max rec_dev
 0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
# all recruitment deviations
#DisplayOnly 0.326626 # Main_RecrDev_1
#DisplayOnly 0.425331 # Main_RecrDev_2
#DisplayOnly -0.169958 # Main_RecrDev_3
#DisplayOnly -1.33819 # Main_RecrDev_4
#DisplayOnly 0.125723 # Main_RecrDev_5
#DisplayOnly -0.785836 # Main_RecrDev_6
#DisplayOnly -0.788504 # Main_RecrDev_7
#DisplayOnly -0.137222 # Main_RecrDev_8
#DisplayOnly 0.0043923 # Main_RecrDev_9
#DisplayOnly 0.332406 # Main_RecrDev_10
#DisplayOnly -0.446003 # Main_RecrDev_11
#DisplayOnly -1.01738 # Main_RecrDev_12
#DisplayOnly -0.367266 # Main_RecrDev_13
#DisplayOnly -0.390897 # Main_RecrDev_14
#DisplayOnly -1.12582 # Main_RecrDev_15
#DisplayOnly -0.339713 # Main_RecrDev_16
#DisplayOnly -0.518818 # Main_RecrDev_17
#DisplayOnly -0.137772 # Main_RecrDev_18
#DisplayOnly 0.103774 # Main_RecrDev_19
#DisplayOnly -0.245748 # Main_RecrDev_20
#DisplayOnly 0.644167 # Main_RecrDev_21
#DisplayOnly 0.481129 # Main_RecrDev_22
#DisplayOnly 0.476308 # Main_RecrDev_23
#DisplayOnly 0.910358 # Main_RecrDev_24
#DisplayOnly 0.386253 # Main_RecrDev_25
#DisplayOnly -0.651963 # Main_RecrDev_26
#DisplayOnly 0.310362 # Main_RecrDev_27
#DisplayOnly 0.533203 # Main_RecrDev_28
#DisplayOnly 0.217308 # Main_RecrDev_29
#DisplayOnly 0.00130655 # Main_RecrDev_30
#DisplayOnly -0.264506 # Main_RecrDev_31
#DisplayOnly 0.647386 # Main_RecrDev_32
#DisplayOnly 0.355826 # Main_RecrDev_33
#DisplayOnly -0.382836 # Main_RecrDev_34
#DisplayOnly -0.0726014 # Main_RecrDev_35
#DisplayOnly 0.125992 # Main_RecrDev_36
#DisplayOnly -0.397528 # Main_RecrDev_37
#DisplayOnly -0.0040283 # Main_RecrDev_38
#DisplayOnly -0.0534463 # Main_RecrDev_39
#DisplayOnly -0.12291 # Main_RecrDev_40
#DisplayOnly -0.382 # Main_RecrDev_41
#DisplayOnly -0.198253 # Main_RecrDev_42
#DisplayOnly -0.240554 # Main_RecrDev_43
#DisplayOnly 0.364382 # Main_RecrDev_44
#DisplayOnly -0.00448665 # Main_RecrDev_45
#DisplayOnly -0.399959 # Main_RecrDev_46
#DisplayOnly 1.01469 # Main_RecrDev_47
#DisplayOnly -0.375766 # Main_RecrDev_48
#DisplayOnly 0.325486 # Main_RecrDev_49
#DisplayOnly -0.115729 # Main_RecrDev_50
#DisplayOnly 0.362471 # Main_RecrDev_51
#DisplayOnly -0.10695 # Main_RecrDev_52
#DisplayOnly -0.040422 # Main_RecrDev_53
#DisplayOnly 0.00676097 # Main_RecrDev_54
#DisplayOnly 0.0370439 # Main_RecrDev_55
#DisplayOnly 0.0545259 # Main_RecrDev_56
#DisplayOnly 0.0635175 # Main_RecrDev_57
#DisplayOnly 0.0675441 # Main_RecrDev_58
#DisplayOnly 0.0690436 # Main_RecrDev_59
#DisplayOnly 0.0695059 # Main_RecrDev_60
#DisplayOnly 0.0695059 # Main_RecrDev_61
#DisplayOnly 0.0695059 # Main_RecrDev_62
#DisplayOnly 0.0695059 # Main_RecrDev_63
#DisplayOnly 0.0695059 # Main_RecrDev_64
#DisplayOnly 0.0695059 # Main_RecrDev_65
#DisplayOnly 0.0695059 # Main_RecrDev_66
#DisplayOnly 0.0695059 # Main_RecrDev_67
#DisplayOnly 0.0695059 # Main_RecrDev_68
#DisplayOnly 0.0695059 # Main_RecrDev_69
#DisplayOnly 0.0695059 # Main_RecrDev_70
#DisplayOnly 0.0695059 # Main_RecrDev_71
#DisplayOnly 0.0695059 # Main_RecrDev_72
#DisplayOnly 0.0695059 # Main_RecrDev_73
#DisplayOnly 0.0695059 # Main_RecrDev_74
#DisplayOnly 0.0695059 # Main_RecrDev_75
#DisplayOnly 0.0695059 # Main_RecrDev_76
#DisplayOnly 0.0695059 # Main_RecrDev_77
#DisplayOnly 0.0695059 # Main_RecrDev_78
#DisplayOnly 0.0695059 # Main_RecrDev_79
#DisplayOnly 0.0695059 # Main_RecrDev_80
#DisplayOnly 0.0695059 # Main_RecrDev_81
#DisplayOnly 0.0695059 # Main_RecrDev_82
#DisplayOnly 0.0695059 # Main_RecrDev_83
#DisplayOnly 0.0695059 # Main_RecrDev_84
#DisplayOnly 0.0695059 # Main_RecrDev_85
#DisplayOnly 0.0695059 # Main_RecrDev_86
#DisplayOnly 0.0695059 # Main_RecrDev_87
#DisplayOnly 0.0695059 # Main_RecrDev_88
#DisplayOnly 0.0695059 # Main_RecrDev_89
#DisplayOnly 0.0695059 # Main_RecrDev_90
#DisplayOnly 0.0695059 # Main_RecrDev_91
#DisplayOnly 0.0695059 # Main_RecrDev_92
#DisplayOnly 0.0695059 # Main_RecrDev_93
#DisplayOnly 0.0695059 # Main_RecrDev_94
#DisplayOnly 0.0695059 # Main_RecrDev_95
#DisplayOnly 0.0695059 # Main_RecrDev_96
#DisplayOnly 0.0695059 # Main_RecrDev_97
#DisplayOnly 0.0695059 # Main_RecrDev_98
#DisplayOnly 0.0695059 # Main_RecrDev_99
#DisplayOnly 0.0695059 # Main_RecrDev_100
#
#Fishing Mortality info
0.1 # F ballpark for tuning early phases
-1 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
3 # max F or harvest rate, depends on F_Method
# no additional F input needed for Fmethod 1
# if Fmethod=2; read overall start F value; overall phase; N detailed inputs to read
# if Fmethod=3; read N iterations for tuning for Fmethod 3
7  # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms
#_LO HI INIT PRIOR PR_type SD PHASE
 0 1 0 0.01 -1 99 -1 # InitF_1Fishery
#
#_Q_setup
 # Q_type options:  <0=mirror, 0=float_nobiasadj, 1=float_biasadj, 2=parm_nobiasadj, 3=parm_w_random_dev, 4=parm_w_randwalk, 5=mean_unbiased_float_assign_to_parm
#_for_env-var:_enter_index_of_the_env-var_to_be_linked
#_Den-dep  env-var  extra_se  Q_type
 0 0 0 2 # 1 Fishery
 0 0 0 2 # 2 Survey
 0 0 0 2 # 3 CPUE
#
#_Cond 0 #_If q has random component, then 0=read one parm for each fleet with random q; 1=read a parm for each year of index
#_Q_parms(if_any);Qunits_are_ln(q)
# LO HI INIT PRIOR PR_type SD PHASE
 -20 20 0 0 -1 99 -5 # LnQ_base_1_Fishery
 -20 20 0 0 -1 99 3 # LnQ_base_2_Survey
 -20 20 0 0 -1 99 -1 # LnQ_base_3_CPUE
#
#_size_selex_types
#discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead
#_Pattern Discard Male Special
 24 0 0 0 # 1 Fishery
 24 0 0 0 # 2 Survey
 15 0 0 1 # 3 CPUE
#
#_age_selex_types
#_Pattern ___ Male Special
 11 0 0 0 # 1 Fishery
 11 0 0 0 # 2 Survey
 11 0 0 0 # 3 CPUE
#_LO HI INIT PRIOR PR_type SD PHASE env-var use_dev dev_minyr dev_maxyr dev_stddev Block Block_Fxn
 4.643 92.86 46.43 57 -1 99 4 0 0 0 0 0 0 0 # SizeSel_1P_1_Fishery
 -5 0 -1 -5 -1 5 -3 0 0 0 0 0 0 0 # SizeSel_1P_2_Fishery
 0 21.2 4.24 5 -1 99 5 0 0 0 0 0 0 0 # SizeSel_1P_3_Fishery
 0 30 15 10 -1 10 -3 0 0 0 0 0 0 0 # SizeSel_1P_4_Fishery
 -999 0 -999 -10 -1 99 -3 0 0 0 0 0 0 0 # SizeSel_1P_5_Fishery
 -999 10000 999 -1 -1 99 -3 0 0 0 0 0 0 0 # SizeSel_1P_6_Fishery
 3.868 77.36 38.68 57 -1 99 4 0 0 0 0 0 0 0 # SizeSel_2P_1_Survey
 -5 0 -1 -5 -1 5 -3 0 0 0 0 0 0 0 # SizeSel_2P_2_Survey
 0 21.2 4.24 5 -1 99 5 0 0 0 0 0 0 0 # SizeSel_2P_3_Survey
 0 30 15 10 -1 10 -3 0 0 0 0 0 0 0 # SizeSel_2P_4_Survey
 -999 0 -999 -10 -1 99 -3 0 0 0 0 0 0 0 # SizeSel_2P_5_Survey
 -999 10000 999 0 -1 99 -3 0 0 0 0 0 0 0 # SizeSel_2P_6_Survey
 0 1 0.1 0.1 -1 99 -3 0 0 0 0 0.5 0 0 # AgeSel_1P_1_Fishery
 0 101 100 100 -1 99 -3 0 0 0 0 0.5 0 0 # AgeSel_1P_2_Fishery
 0 1 0.1 0.1 -1 99 -3 0 0 0 0 0.5 0 0 # AgeSel_2P_1_Survey
 0 101 100 100 -1 99 -3 0 0 0 0 0.5 0 0 # AgeSel_2P_2_Survey
 0 1 0.1 0.1 -1 99 -3 0 0 0 0 0.5 0 0 # AgeSel_3P_1_CPUE
 0 101 100 100 -1 99 -3 0 0 0 0 0.5 0 0 # AgeSel_3P_2_CPUE 
#_Cond 0 #_custom_sel-env_setup (0/1)
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no enviro fxns
#_Cond 0 #_custom_sel-blk_setup (0/1)
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no block usage
#_Cond No selex parm trends
#_Cond -4 # placeholder for selparm_Dev_Phase
#_Cond 0 #_env/block/dev_adjust_method (1=standard; 2=logistic trans to keep in base parm bounds; 3=standard w/ no bound check)
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
0 #_Variance_adjustments_to_input_values
#_fleet: 1 2 3
#_Cond  0 0 0 #_add_to_survey_CV
#_Cond  0 0 0 #_add_to_discard_stddev
#_Cond  0 0 0 #_add_to_bodywt_CV
#_Cond  1 1 1 #_mult_by_lencomp_N
#_Cond  1 1 1 #_mult_by_agecomp_N
#_Cond  1 1 1 #_mult_by_size-at-age_N
#
5 #_maxlambdaphase
1 #_sd_offset
#
0 # number of changes to make to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch;
# 9=init_equ_catch; 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin
#like_comp fleet/survey  phase  value  sizefreq_method
#
# lambdas (for info only; columns are phases)
#  0 0 0 0 0 #_CPUE/survey:_1
#  1 1 1 1 1 #_CPUE/survey:_2
#  0 0 0 0 0 #_CPUE/survey:_3
#  1 1 1 1 1 #_agecomp:_1
#  1 1 1 1 1 #_agecomp:_2
#  0 0 0 0 0 #_agecomp:_3
#  1 1 1 1 1 #_init_equ_catch
#  1 1 1 1 1 #_recruitments
#  1 1 1 1 1 #_parameter-priors
#  1 1 1 1 1 #_parameter-dev-vectors
#  1 1 1 1 1 #_crashPenLambda
0 # (0/1) read specs for more stddev reporting
 # 0 1 -1 5 1 5 1 -1 5 # placeholder for selex type, len/age, year, N selex bins, Growth pattern, N growth ages, NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999

