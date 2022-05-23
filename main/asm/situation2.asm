.data
.text
jal static_initialization
begin:
	jal decode
	beq $a0 $zero case0
	beq $a0 $s1 case1
	beq $a0 $s2 case2
	beq $a0 $s3 case3
	beq $a0 $s4 case4
	beq $a0 $s5 case5
	beq $a0 $s6 case6
	beq $a0 $s7 case7
case0:
	li $v0 0
	jal write_control_negate
	li $v0 1000
	jal sleep
	j begin
case1:
	li $a0 2
	jal write_control
	
	j begin
case2:
	li $a0 4
	jal write_control
	j begin
case3:
	li $a0 8
	jal write_control
	j begin
case4:
	li $a0 16
	jal write_control
	j begin
case5:
	li $a0 32
	jal write_control
	j begin
case6:
	li $a0 64
	jal write_control
	j begin
case7:
	li $a0 128
	jal write_control
	j begin
j begin
.include "stdio_minisys.mips"