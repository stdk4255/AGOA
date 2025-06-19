log using agoawhatif.log, replace

set linesize 80
set scheme sj

* Load your dataset
use D:\Workstation\Desktop\FinalTCFA-main\SouthAfrica.dta, clear
xtset country year

* Create a subset excluding specific countries
keep if country != 1 & country != 9 & country != 18 & country != 20 & country != 26

******************************************************************************  
* Replicate results in Abadie, Diamond, and Hainmueller (2010)
synth2 garexports lngdp gdppc exc ihsfdi lnpop garexports(2000) garexports(1992), trunit(24) trperiod(2001) xperiod(1989(1)2000) nested allopt

* Implement in-space placebo test using fake treatment units
synth2 garexports lngdp gdppc exc ihsfdi lnpop garexports(2000) garexports(1992), /// 
    trunit(24) trperiod(2001) xperiod(1989(1)2000) nested allopt placebo(unit cut(2)) sigf(6)

* Leave-one-out robustness test
* Create a Stata frame "california" storing generated variables
* Save all produced graphs to the current path
synth2 garexports lngdp gdppc exc ihsfdi lnpop garexports(2000) garexports(1992), /// 
    trunit(24) trperiod(2001) xperiod(1989(1)2000) nested allopt loo frame(South_Africa) savegraph(South_Africa, replace)

* Combine all produced graphs
graph combine `e(graph)', cols(2) altshrink

* Switch to the generated Stata frame "california"
frame change South_Africa
* Switch back to the default Stata frame
frame change default

******************************************************************************

