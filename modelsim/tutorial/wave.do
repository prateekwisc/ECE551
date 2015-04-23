onerror {resume}
quietly virtual function -install /t_receive/DUT -env /t_receive/DUT { &{/t_receive/DUT/RBufShiftReg[3], /t_receive/DUT/RBufShiftReg[2], /t_receive/DUT/RBufShiftReg[1], /t_receive/DUT/RBufShiftReg[0] }} RBufDhiftReg_Is4
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Orange /t_receive/Clk
add wave -noupdate -color Orange /t_receive/DUT/Clk
add wave -noupdate -color Orange /t_receive/DUT/Reset
add wave -noupdate -divider -height 30 {DUT Signals}
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix hexadecimal /t_receive/ExpectedDataOut
add wave -noupdate -radix hexadecimal /t_receive/DataOut
add wave -noupdate /t_receive/SerData
add wave -noupdate /t_receive/DUT/StartOp
add wave -noupdate /t_receive/DUT/SerData
add wave -noupdate /t_receive/DUT/DataValid
add wave -noupdate /t_receive/DUT/DataOut
add wave -noupdate -radix unsigned /t_receive/DUT/State
add wave -noupdate -radix unsigned /t_receive/DUT/NextState
add wave -noupdate /t_receive/DUT/RBufDhiftReg_Is4
add wave -noupdate -radix hexadecimal -expand /t_receive/DUT/RBufShiftReg
add wave -noupdate /t_receive/DUT/RBufLoad
add wave -noupdate /t_receive/DUT/RBufShift
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {StartOp {315 ns} 1} {{Cursor 2} {54 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {2 us}
