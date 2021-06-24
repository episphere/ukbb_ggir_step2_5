# ukbb_ggir_step2_5

\#\#Running GGIR on the UKBB data

Running the GGIR pipeline on biowulf + testing on my mac...

in the stage directory:

### Input files:

meta/basic/meta\_<cwa_filename>.RData

### Output files:

meta/csv/<cwa_filename>.RData meta/ms2.out/<cwa_filename>.RData
meta/ms3.out/<cwa_filename>.RData 
meta/ms4.out/<cwa_filename>.RData
meta/ms5.out/<cwa_filename>.RData
meta/ms5.outraw/30_100_400/<cwa_filename>.RData.csv
meta/ms5.outraw/30_125_400/<cwa_filename>.RData.csv
meta/ms5.outraw/40_100_400/<cwa_filename>.RData.csv
meta/ms5.outraw/40_125_400/<cwa_filename>.RData.csv
meta/ms5.outraw/behavioralcodes<date>.csv
meta/sleep.qc/graphperday_id\_<cwa_filename>.pdf

results:
part2_daysummary.csv
part2_summary.csv
part4_nightsummary_sleep_cleaned.csv
part4_summary_sleep_cleaned.csv
part5_daysummary_MM_L30M100V400_T5A5.csv
part5_daysummary_MM_L30M125V400_T5A5.csv
part5_daysummary_MM_L40M100V400_T5A5.csv
part5_daysummary_MM_L40M125V400_T5A5.csv
part5_daysummary_WW_L30M100V400_T5A5.csv
part5_daysummary_WW_L30M125V400_T5A5.csv
part5_daysummary_WW_L40M100V400_T5A5.csv
part5_daysummary_WW_L40M125V400_T5A5.csv
part5_personsummary_MM_L30M100V400_T5A5.csv
part5_personsummary_MM_L30M125V400_T5A5.csv
part5_personsummary_MM_L40M100V400_T5A5.csv
part5_personsummary_MM_L40M125V400_T5A5.csv
part5_personsummary_WW_L30M100V400_T5A5.csv
part5_personsummary_WW_L30M125V400_T5A5.csv
part5_personsummary_WW_L40M100V400_T5A5.csv
part5_personsummary_WW_L40M125V400_T5A5.csv
visualisation_sleep.pdf

results/file summary reports/Report\<cwa_filename\>.pdf

results/QC/
data_quality_report.csv part4_nightsummary_sleep_full.csv part4_summary_sleep_full.csv
part5_daysummary_full_MM_L30M100V400_T5A5.csv
part5_daysummary_full_MM_L30M125V400_T5A5.csv
part5_daysummary_full_MM_L40M100V400_T5A5.csv
part5_daysummary_full_MM_L40M125V400_T5A5.csv
part5_daysummary_full_WW_L30M100V400_T5A5.csv
part5_daysummary_full_WW_L30M125V400_T5A5.csv
part5_daysummary_full_WW_L40M100V400_T5A5.csv
part5_daysummary_full_WW_L40M125V400_T5A5.csv
plots_to_check_data_quality_1.pdf

Return: 
meta/ms5.outraw/30_100_400/<cwa_filename>.RData.csv
meta/ms5.outraw/30_125_400/<cwa_filename>.RData.csv
meta/ms5.outraw/40_100_400/<cwa_filename>.RData.csv
meta/ms5.outraw/40_125_400/<cwa_filename>.RData.csv