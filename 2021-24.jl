# Easier done by hand
# What the ALU boils down to:
# If the 14-digit input is ABCDEFGHIJKLMN, imagine z as a base-26 number (or array, stack, etc.)
# 1. push A+5
# 2. push B+5
# 3. push C+1
# 4. push D+15
# 4. push E+2
# 5. pop, then push F+2 unless F+1 = popped
# 6. push G+5
# 7. pop, then push H+8 unless H+8 = popped
# 8. pop, then push I+14 unless I+7 = popped
# 9. pop, then push J+12 unless J+8 = popped
# 10. push K+7
# 11. pop, then push L+14 unless L+2 = popped
# 12. pop, then push M+13 unless M+2 = popped
# 13. pop, then push N+6 unless N+13 = popped
# For z to be empty, any pops cannot be accompanied by pushes, which means that valid numbers must fulfil all of:
# A+5=N+13, B+5=M+2, C+1=J+8, D+15=I+7, E+2=F+1, G+5=H+8, K+7=L=2