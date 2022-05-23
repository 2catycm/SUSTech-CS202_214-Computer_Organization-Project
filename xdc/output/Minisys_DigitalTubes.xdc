# 七段数码管的绑定
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTubes_NotEnable[7]}]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTubes_NotEnable[6]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTubes_NotEnable[5]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTubes_NotEnable[4]}]
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTubes_NotEnable[3]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTubes_NotEnable[2]}]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTubes_NotEnable[1]}]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTubes_NotEnable[0]}]

# 从0到7，表示标准七段数码管的 A,B,C,D,E,F,G,DP 段。
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTube_Shape[7]}]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTube_Shape[6]}]
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTube_Shape[5]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTube_Shape[4]}]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTube_Shape[3]}]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTube_Shape[2]}]
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTube_Shape[1]}]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports {Minisys_DigitalTube_Shape[0]}]



































