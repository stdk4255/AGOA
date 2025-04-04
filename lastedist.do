log using agoascm.log, replace

set linesize 80
set scheme sj

* Load your dataset
use "C:\Users\DataSpell\reducted\reducted.dta", clear
xtset country year

******************************************************************************
* Replicate results in Abadie, Diamond, and Hainmueller (2010)
synth2 garexports lngdp gdppc exc ihsfdi lnpop garexports(1998) garexports(1991), trunit(24) trperiod(2001) xperiod(1989(1)2000) nested allopt

* Implement in-space placebo test using fake treatment units
* Pre-treatment MSPE 2 times smaller or equal to that of treated unit
* Dropped "allopt" for faster execution, though it's recommended for precision
synth2 garexports lngdp gdppc exc ihsfdi lnpop garexports(1998) garexports(1991), ///
    trunit(24) trperiod(2001) xperiod(1989(1)2000) nested allopt placebo(unit cut(2)) sigf(6)

* Leave-one-out robustness test
* Create a Stata frame "california" storing generated variables
* Save all produced graphs to the current path
synth2 garexports lngdp gdppc exc ihsfdi lnpop garexports(1998) garexports(1991), ///
    trunit(24) trperiod(2001) xperiod(1989(1)2000) nested loo frame(South_Africa) savegraph(South_Africa, replace)

* Combine all produced graphs
graph combine `e(graph)', cols(2) altshrink

* Switch to the generated Stata frame "california"
frame change South_Africa
* Switch back to the default Stata frame
frame change default

******************************************************************************

log close
