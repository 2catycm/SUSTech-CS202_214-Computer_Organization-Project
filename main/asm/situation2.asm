.data
.text
static_initialization:
#MARS模式下这三个指针不要赋值（注释掉）
	la $gp 0xFFFFFC00 # io relative address
	la $sp 256 # 栈指针
	la $fp 512 #base 数据的基础地址
# 数据集间隔
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
	li $a0 1
	jal write_control
	#jal read # 读入到a0
	# for0:
	# jal write_data #输出a0
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
# 本asm的控制输入（左开关）定义：左开关前三位为case，第四位为enter。enter为1状态时等待变为0，为0时等待输入的确定。
# decode: 输入a0(左)。解析为a0=case， a1=enter
decode:
	lw $a0 0x72($gp)
	 # 7,6,...,0.  
	 srl $a0 $a0 4
	 andi $a1 $a0 1
	 srl $a0 $a0 1
	 jr $ra
# 根据a1的enter信号控制，等待输入一个整数（通过右开关），结果保存到a0。
# a1和a0都会改变。
read:
	jal decode
	li $v0 4
	li $v1 1
	jal write_control #提示用户等待enter信号
	bne $a1 $zero read # 如果enter不是0，就继续等待enter是0
	li $v0 4
	li $v1 0
	jal write_control #取消
wait_for_enter:
	jal decode
	li $v0 3
	li $v1 1
	jal write_control #提示用户等待enter信号
	beq $a1 $zero wait_for_enter # 等到enter是1。 
	li $v0 3
	li $v1 0
	jal write_control #提示用户等待enter信号
	lw $a0 0x70($gp)
	jr $ra

# 输出控制灯（左灯），根据v0的值(7,6,5,4,3,2,1,0)决定输出修改左边的哪个灯；根据v1的值的最后一位是否是1来修改
write_control_add:
	lw $t1 0x62($gp) # t1为左灯的值。
	# 操作v1
	andi $v1 $v1 1 # 取最后一位
	sllv $v1 $v1 $v0 # 左移 v0位
	# 让a0的对应位写在t1上。
	srlv $t0 $t1 $v0
	andi $t0 $t0 1 # 取相应位。
	beq $t0 $zero if0
		and $t1 $t1 $v1
		j endif0
	if0:
	    or $t1 $t1 $v1
	endif0:
	sw $t1 0x62($gp) # 把t1的计算结果送回灯上。
	jr $ra
# 输出控制灯（左灯），根据v0的值(7,6,5,4,3,2,1,0)决定输出修改左边的哪个灯；对该灯的值取反。
write_control_negate:
	lw $t1 0x62($gp) # t1为左灯的值。
	li $t0 1 
	sllv $v1 $t0 $v0 # 左移 v0位
	xori  $t1  $t1 $v1
	sw $t1 0x62($gp) # 把t1的计算结果送回灯上。
	jr $ra
#输出控制灯（左灯）; 直接输出a0的值。
write_control:
	sw $a0 0x62($gp)
	jr $ra
#输出数据灯（右灯）; 直接输出a0的值。
write_data:
	sw $a0 0x60($gp)
	jr $ra
	
