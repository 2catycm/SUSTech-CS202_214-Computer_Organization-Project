# 南方科技大学CS202/214计算机组成原理课程大作业

[![](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-English-green.svg)](README_en.md)[![](https://img.shields.io/badge/License-MulanPSL%202.0-green.svg)](LICENSE)[![](https://img.shields.io/badge/Q群-讨论-green.svg?logo=tencentqq)](https://jq.qq.com/?_wv=1027&k=d02UjNgH)

这是南方科技大学CS202/214计算机组成原理课程的大作业——实现一个CPU。
本项目的基本功能为，实现了基于FPGA和Verilog语言的支持MIPS指令集的单周期中央处理器。

## 编译说明

## 如何参与开发

1. 克隆项目到本地

   ```bash
   git clone https://gitee.com/yecanming/SUSTech-CS202_214-Computer_Organization-Project.git
   ```

   切换到develop分支

   ```bash
   cd SUSTech-CS202_214-Computer_Organization-Project
   git checkout develop

2. 用喜欢的编辑器修改项目

   - 方法1：用vivado本地工程引用项目，见`编译说明`
   - 方法2：用vscode修改文件

3. 使用喜欢的git管理工具提交更改

   - 方法1：git命令行

     ```bash
     git add . # .表示工作文件夹都被加入（除了gitignore）
     git status # 确认add命令加入的是你想要提交的文件，如果不是，用git reset --soft HEAD^取消git add
     ```

     ```bash
     git commit -m "提交的名字" # 尽量遵守 Commitizen 规范
     ```

   - 方法2：VS Code

   - 方法3：Jetbrains IDE

4. 使用喜欢的git管理工具推送到云端

   - 方法1：git命令行

     ```bash
     git push -u origin develop # 不是master。
     ```

   - 方法2：VS Code

   - 方法3：Jetbrains IDE
