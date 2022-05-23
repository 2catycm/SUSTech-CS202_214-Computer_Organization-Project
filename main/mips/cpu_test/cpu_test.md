## mips/cpu_test 文件夹

本文件夹放置mips汇编文件，这些汇编文件可以在经过MARS_GUI 可以导出为uart格式文件
从而运行到本项目实现的基于Minisys开发板的CPU上。

### 测试项目

- demo_read_swtich_write_led.mips
  - 期望行为：这是最简单的测试场景，当导入到我们的CPU上后，用户按什么按键就会亮什么灯。
  - 验证的硬件功能：lw, sw, j的支持；MemOrIOn模块。
- jal_test.mips
  - 期望行为：右边的16盏灯全亮起来
  - 验证的硬件功能：jal, jr, j, sw的支持；
- demo_flow.mips
  - 期望行为：左边的八个灯每隔1s轮流亮起来，形成流水灯。
  - 验证的硬件功能：jal, jr, j, sw, lw的支持；
  - 验证的软件功能：commons/stdio_minisys.mips 的 sleep, write_control函数。
- situation1.mips
  - 如project文档所述。
- situation2.mips
  - 如project文档所述。

### 测试状态

- demo_read_swtich_write_led.mips
  - 通过
- jal_test.mips
  - 通过
- demo_flow.mips
  - 通过
- situation1.mips
  - 通过。需要review。
- situation2.mips
  - 编写中。