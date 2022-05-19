# Button（按键开关）有5个。
# 在板子上的标识是 S1(R1), S2, ..., S5(P2) 按照东西北中南的顺序。
set_property -dict {PACKAGE_PIN R1  IOSTANDARD LVCMOS33} [get_ports {Minisys_Button[4]}]
set_property -dict {PACKAGE_PIN P1  IOSTANDARD LVCMOS33} [get_ports {Minisys_Button[3]}]
set_property -dict {PACKAGE_PIN P5 IOSTANDARD LVCMOS33} [get_ports {Minisys_Button[2]}]
set_property -dict {PACKAGE_PIN P4 IOSTANDARD LVCMOS33} [get_ports {Minisys_Button[1]}]
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {Minisys_Button[0]}]