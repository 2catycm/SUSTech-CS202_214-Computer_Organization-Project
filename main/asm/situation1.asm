.data 0x0000
.text 0x0000
ini:
	addi $v1, $zero, 1
	addi $21, $zero, 1
	addi $22, $zero, 2
	addi $23, $zero, 3
	addi $24,$zero, 4
	addi $25,$zero, 5
	addi $26, $zero, 6
	addi $27, $zero, 7
	lui  $20, 0xFFFF
	ori $20, $20, 0xFC00 # 20 is the basic address
	lui $19, 0x8FFF
	ori $19, $19, 0xFFFF #the submask
	
master:	lw $2, 0x72($20) # read the sw23,22,21
	srl $2, $2, 5 # 移动到我的指令的位数
	beq $2, $zero, case0
	beq $2, $21, case1
	beq $2, $22, case2
	beq $2, $23, case3
	beq $2, $24, case4
	beq $2, $25, case5
	beq $2, $26, case6
	beq $2, $27, case7

case0:
	lw $3, 0x70($20)
	sw $3, 0x60($20) # 警惕2个led灯管互相刷新
	add $4, $zero, $3
	sll $4, $4, 16
	addi $5, $zero, 0 # the control varible
	addi $8, $zero, 1 # the signal 
shiftl: # make the leftmost1 in the highest 先把第一个1移到最左边
	sll $4, $4, 1
	slti $10, $4, 0  #  0 > $4 then jump 
	bne $10, $zero, panduan 
	addi $5, $5, 1
	slti $10, $5, 16
	beq $10, $zero, shiftl
	
#########################
panduan:
	andi $6, $3, 0xfff8
	srl $7, $4, 31
	sll $4, $4, 1 # 这个记得不断左移
	srl $3, $3, 1
	bne $6, $7, outcase0
	addi $5, $5, 1
	slti $10, $5, 16
	beq $10, $zero, panduan #如果是还没到16就继续判断
led16light:
	addi $10, $zero, 1 
	sw $10, 0x62($20)
outcase0:
	j master
############################################################
# 存储读取的数字存储在￥3和￥5中
case1:
	lw $3, 0x70($20)
	sw $3, 0x60($20)
	lw $4, 0x72($20) 
	andi $4, $4, 0xfff8
	beq $4, $zero, case1 # 你需要反复读取
case1read2:
	lw $5, 0x70($20)
	sw $5, 0x60($20)
	lw $4, 0x72($20) 
	srl $4, $4, 1 # SW17代表第二个数读取完毕
	andi $4, $4, 0xfff8
	beq $4, $zero, case1read2
	j master
	
case2:
	and $6, $3, $5
	sw $5, 0x60($20)
	j master
case3:
	or $6, $3, $5
	sw $5, 0x60($20)
	j master
case4:
	xor $6, $3, $5
	sw $5, 0x60($20)
	j master
case5:
	sllv $6, $3, $5
	sw $5, 0x60($20)
	j master
case6:
	srlv $6, $3, $5
	sw $5, 0x60($20)
	j master
case7:
	srav $6, $3, $5
	sw $5, 0x60($20)
	j master
