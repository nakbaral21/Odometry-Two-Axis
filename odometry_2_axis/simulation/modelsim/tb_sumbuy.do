add wave rot0_a rot0_b rot1_a rot1_b loutx2 loutx1 loutx0 louty2 louty1 louty0
force rot0_a 0 0, 1 5ns, 0 15ns -repeat 20ns
force rot0_b 0 0, 1 10ns -repeat 20ns
force rot1_a 1 1, 0 5ns, 1 15ns -repeat 20ns
force rot1_b 0 0, 1 10ns -repeat 20ns
run 15510ns