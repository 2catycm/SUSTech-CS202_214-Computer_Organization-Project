# 灯光绑定
# 是板子下面的24个小led灯。
# 分为高（RLD）、中（YLD）、低（GLD）各8个。高中低表示作为二进制数，左边是高比特位(significant bit)。
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_High[7]}]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_High[6]}]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_High[5]}]
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_High[4]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_High[3]}]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_High[2]}]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_High[1]}]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_High[0]}]

set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Middle[7]}]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Middle[6]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Middle[5]}]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Middle[4]}]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Middle[3]}]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Middle[2]}]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Middle[1]}]
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Middle[0]}]

set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Low[7]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Low[6]}]
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Low[5]}]
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Low[4]}]
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Low[3]}]
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Low[2]}]
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Low[1]}]
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports {Minisys_Lights_Low[0]}]