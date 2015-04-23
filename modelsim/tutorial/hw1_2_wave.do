onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /t_FAGP_1bit/C_in
add wave -noupdate /t_FAGP_1bit/InA
add wave -noupdate /t_FAGP_1bit/InB
add wave -noupdate /t_FAGP_1bit/C_out
add wave -noupdate /t_FAGP_1bit/S
add wave -noupdate /t_FAGP_1bit/G
add wave -noupdate /t_FAGP_1bit/P
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
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
WaveRestoreZoom {0 ns} {47 ns}
