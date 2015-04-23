# Create user defined variables 
set CLK_PORT [get_ports Clk]
set CLK_PERIOD 4.00 
set CLK_SKEW 0.14

set WC_OP_CONDS typ_0_1.98
set WIRELOAD_MODEL 10KGATES

set DRIVE_CELL buf1a6

set DRIVE_PIN {Y}

set MAX_OUTPUT_LOAD [load_of ssc_core/buf1a2/A]

set INPUT_DELAY 2.0

set OUTPUT_DELAY 0.5

set MAX_AREA 380000


# Time Budget 
create_clock -period $CLK_PERIOD -name my_clock $CLK_PORT
set_dont_touch_network my_clock
set_clock_uncertainty $CLK_SKEW [get_clocks my_clock]

set_input_delay $INPUT_DELAY -max -clock my_clock [remove_from_collection [all_inputs] $CLK_PORT]
set_output_delay $OUTPUT_DELAY -max -clock my_clock [all_outputs]

#  Area Constraint
set_max_area $MAX_AREA

# Operating Environment 
set_operating_conditions -max $WC_OP_CONDS
set_wire_load_model -name $WIRELOAD_MODEL 


set_driving_cell -cell $DRIVE_CELL -pin $DRIVE_PIN [remove_from_collection [all_inputs] $CLK_PORT]


set_load  $MAX_OUTPUT_LOAD [all_outputs]
