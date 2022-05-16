# 开关绑定
# 是板子下面的24个开关。
# 分为高（RLD）、中（YLD）、低（GLD）各8个。高中低表示作为二进制数，左边是高比特位(significant bit)。
set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_High[7]}]
set_property -dict {PACKAGE_PIN W9 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_High[6]}]
set_property -dict {PACKAGE_PIN Y7 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_High[5]}]
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_High[4]}]
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_High[3]}]
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_High[2]}]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_High[1]}]
set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_High[0]}]

set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Middle[7]}]
set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Middle[6]}]
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Middle[5]}]
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Middle[4]}]
set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Middle[3]}]
set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Middle[2]}]
set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Middle[1]}]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Middle[0]}]

set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Low[7]}]
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Low[6]}]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Low[5]}]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Low[4]}]
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Low[3]}]
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Low[2]}]
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Low[1]}]
set_property -dict {PACKAGE_PIN W4 IOSTANDARD LVCMOS33} [get_ports {Minisys_Switches_Low[0]}]