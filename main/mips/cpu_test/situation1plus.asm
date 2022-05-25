.data 
	buf: .word 0x0000
.text 
ini:
	sw $3, 0x62($20)
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
	lw $1, 0x70($20)
	sw $1, 0x60($20) # 警惕2个led灯管互相刷新
	add $4, $zero, $1 # 存一下这个内容
	addi $6, $zero, 0
loop:
	beq $4,$zero,exit #全变0退出,4这个变量没用
	andi $11,$4,1
	sll $6,$6,1
	add $6,$6,$11
	srl $4,$4,1
	j loop
exit:
	beq $1, $6,led16light
	bne $1, $6,led16notlight
	j master
led16light:
	addi $10, $zero, 1 
	sw $10, 0x62($20)
	j master# 存储读取的数字存储在￥3和￥5中
led16notlight:
	addi $10, $zero, 0
	sw $10, 0x62($20)
	j master
case1:
	lw $4, 0x72($20) 
	srl $4, $4, 2 # SW18是1代表我的值被锁定了,顺序输入第一个数，拨sw16，拨sw18.输入第二个数 拨sw17.#但凡想要取消，再SW18是0就可以取消
	andi $4, $4, 0x0001  
	bne $4, $zero,master
	lw $3, 0x70($20)
	sw $3, 0x60($20)
	sw $zero, 0x62($20)
	lw $4, 0x72($20) 
	andi $4, $4, 0x0001  #SW16代表第一个读取完毕
	beq $4, $zero, case1 # 你需要反复读取
case1read2:
	lw $5, 0x70($20)
	sw $5, 0x60($20)
	lw $4, 0x72($20) 
	srl $4, $4, 1 # SW17代表第二个数读取完毕
	andi $4, $4, 0x0001
	beq $4, $zero, case1read2
	j master
	
case2:                                                                                                                                                   
	and $6, $3, $5
	sw $6, 0x60($20)
	j master
case3:
	or $6, $3, $5
	sw $6, 0x60($20)
	j master
case4:
	xor $6, $3, $5
	sw $6, 0x60($20)
	j master
case5:
	sllv $6, $3, $5
	sw $6, 0x60($20)
	j master
case6:
	srlv $6, $3, $5
	sw $6, 0x60($20)
	j master
case7:
	srav $6, $3, $5
	sw $6, 0x60($20)
	j master
