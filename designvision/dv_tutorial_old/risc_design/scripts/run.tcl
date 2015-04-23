analyze -f vhdl RISCTYPES.vhd
analyze -f vhdl -lib WORK {ALU.vhd PRGRM_CNT.vhd REG_FILE.vhd STACK_MEM.vhd CONTROL.vhd  PRGRM_CNT_TOP.vhd STACK_TOP.vhd DATA_PATH.vhd PRGRM_DECODE.vhd RISC_CORE.vhd INSTRN_LAT.vhd PRGRM_FSM.vhd STACK_FSM.vhd}
elaborate RISC_CORE -arch "STRUCT" -lib WORK -update
uniquify
source scripts/top-level.tcl
check_design
write -format db -hierarchy -output "./db/RISC_CORE_GTECH.db"
compile
write -format db -hierarchy -output "./db/RISC_CORE_MAPPED.db"
redirect  rsc_dsn_timing.rpt {report_timing -max_paths 20 -path end}
set current_design ALU
ungroup -all -flatten
set current_design RISC_CORE
compile -map_effort high -incremental
report_constraints
