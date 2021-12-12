# Odometry-Two-Axis
 Odometry two axis FPGA design with VHDL  
 Rotary encoder : https://github.com/nakbaral21/rotary-encoder  
 Odometry : https://github.com/nakbaral21/Odometry
## Problem
1. Buatlah rangkaian digital dengan kode vhdl untuk menggabungkan pembacaan 2 incremental rotary encoder seperti pada gambar 1, menjadi nilai posisi koordinat (x,y) dalam satuan mili meter (mm). Adapun spesifikasi dari komponen yang dipakai adalah:
	- Board DE10 Lite
	- Rotary encoder 200 pulse per revolution (PPR) 
	- Roda omni-directional yang terpasang pada rotary encoder sesuai gambar 2. 
	- Nilai x dan y masing-masing ditampilkan ke 3 buah 7-segment dengan format unsigned decimal (000 – 999)
2. Buatlah kode testbech vhdl untuk kebutuhan pengujian point 1. 
	- Robot bergerak ke kanan searah sumbu x
	- Robot bergerak ke depan searah sumbu y 
	- Robot bergerak ke sudut 45 derajat terhadap sumbu x. 
![Skema Fondasi Robot 3 roda omni-directional dengan 2 odometry rotary encoder.
Sudut α adalah 90 derajat](https://i.ibb.co/5s67f7J/image.png)
## FPGA Instruction
1. Project file di https://github.com/nakbaral21/Odometry-Two-Axis/blob/main/odometry_2_axis/odometry_2_axis.qpf
2. VHDL file di https://github.com/nakbaral21/Odometry-Two-Axis/blob/main/odometry_2_axis/odometry_2_axis.vhd
3. do testbench file :
   - Ke kanan searah sumbu-x di https://github.com/nakbaral21/Odometry/blob/main/odometry/simulation/modelsim/tb_odometry1.do
   - Ke atas searah sumbu-y di https://github.com/nakbaral21/Odometry-Two-Axis/blob/main/odometry_2_axis/simulation/modelsim/tb_sumbuy.do
   - Menuju 45 derajat dari sumbu-x di  https://github.com/nakbaral21/Odometry-Two-Axis/blob/main/odometry_2_axis/simulation/modelsim/tb_45derajat.do
4. Laporan di  https://github.com/nakbaral21/Odometry-Two-Axis/blob/main/Laporan.pdf
 