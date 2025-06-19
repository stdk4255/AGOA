* Start a log file
log using agoawha232tif.log, replace

* Set graph schemes and line size
set scheme plotplainblind  // Colorblind-friendly scheme
set linesize 80
set scheme sj              // Switch to Stata Journal scheme

* Load your dataset and declare panel structure
use SouthAfrica, clear
xtset country year

* Create a subset excluding specific countries
keep if country != 1 & country != 9 & country != 18 & country != 20 & country != 26

******************************************************************************  
* Replicate results in Abadie, Diamond, and Hainmueller (2010)
synth_runner garexports lngdp gdppc exc ihsfdi lnpop garexports(2000) garexports(1992), ///
    trunit(24) trperiod(2001) xperiod(1989(1)2000) nested allopt gen_vars

* Generate effect graphs
effect_graphs, trlinediff(-1) effect_gname(garexports_effect) ///
    tc_gname(garexports_tc) effect_options(scheme(blindschemes)) ///
    tc_options(scheme(blindschemes))

* Generate single treatment graphs
single_treatment_graphs, trlinediff(-1) raw_gname(garexports_raw) ///
    effects_gname(garexports_effects) effects_ylabels(-30(10)30) ///
    effects_ymax(35) effects_ymin(-35) effects_options(scheme(blindschemes))

******************************************************************************

* Close the log file
log close
