.data
.text
static_initialization:
#MARS模式下这三个指针不要赋值（注释掉）
	la $gp 0xFFFFFC00 # io relative address
	la $sp 0 # 栈指针
	la $fp 128 #base 数据的基础地址
	
	li $s0 11 #space
	# 常数七子
	li $s1 1
	li $s2 2
	li $s3 3
	li $s4 4
	li $s5 5
	li $s6 6
	li $s7 7
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
	jal read
	for0:
	
	j begin
case1:
	j begin
case2:
	j begin
case3:
	j begin
case4:
	j begin
case5:
	j begin
case6:
	j begin
case7:
	j begin
j begin
# 本asm的控制输入（左开关）定义：左开关前三位为case，第四位为enter。enter为1状态时等待变为0，为0时等待输入的确定。
# decode: 输入a0(左)。解析为a0=case， a1=enter
decode:
	lw $a0 0x72($gp)
	 # 7,6,...,0.  
	 srl $a0 $a0 4
	 addi $a1 $a0 1
	 srl $a0 $a0 1
	 jr $ra
# 根据a1的enter信号控制，等待输入一个整数（通过右开关），结果保存到a0。
read:
	jal decode
	bne $a1 $zero read # 如果enter不是0，就继续等待enter是0
wait_for_enter:
	jal decode
	beq $a1 $zero wait_for_enter # 等到enter是1。 
	lw $a0 0x70($gp)
	jr $ra

# 输出控制灯（左灯），根据v0的值(7,6,5,4,3,2,1,0)决定输出修改左边的哪个灯；根据a0的值来输出
write_control:
	lw $a1 0x62($gp)
	addi $a0 $a0 1
	sllv $a0 $a0 $v0 # 左移 
	sw $a1 0x62($gp)
	jr $ra
#输出数据灯（右灯）; 直接输出a0的值。
write_data:
	sw $a0 0x60($gp)
	jr $ra
	