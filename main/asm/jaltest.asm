.data
.text
la $gp 0xFFFFFC00
begin:
    la $t1 0xFFFF00FF
    jal func
    addiu $t1 $t1 0xF000
    j exit
func:
    addiu $t1 $t1 0xF00
    jr $ra
exit: 
    sw $t1,0x60($gp) ## 右边显示右边8个是1
j begin
