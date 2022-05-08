`timescale 1 ns/10 ps

module riscv_tb;

reg clk, rstn;
wire [31:0] inst;

integer i;

initial begin
  clk  = 1'b0;
  rstn = 1'b0;
  $display($time, " ** Start Simulation **");
  $display($time, " Instruction Memory ");
  $monitor($time, " [PC] pc : %d, flush: %d, stall: %d, MEM_taken: %d, x1:%d, x2:%d, x8:%d, x9:%d, 10: %d, x14:%d, x15:%d", my_cpu.PC, my_cpu.flush, my_cpu.stall, my_cpu.MEM_taken, my_cpu.m_register_file.reg_array[1], my_cpu.m_register_file.reg_array[2], my_cpu.m_register_file.reg_array[8], my_cpu.m_register_file.reg_array[9], my_cpu.m_register_file.reg_array[10], my_cpu.m_register_file.reg_array[14],  my_cpu.m_register_file.reg_array[15]);
  #60 rstn = 1'b1;
  #4000; 
  rstn = 1'b0;
  $display($time, " ** End Simulation **");
  
  ////////////////////////////////////////////////////////
  // [WARNING] : DO NOT ERASE when using "test.py"
  ////////////////////////////////////////////////////////
  $display($time, " REGISTER FILE");
  for (i=0;i<32;i=i+1) $display($time, " Reg[%d]: %d (%b)", i, $signed(my_cpu.m_register_file.reg_array[i]), my_cpu.m_register_file.reg_array[i]);
  $display($time, " DATA MEMORY");
  for (i=0;i<128;i=i+1) $display($time, " Mem[%d]: %d (%b)", i, $signed(my_cpu.m_data_memory.mem_array[i]), my_cpu.m_data_memory.mem_array[i]);
  ////////////////////////////////////////////////////////

  $finish;
end

always begin
  // remember that the cycle time was 20 in the single cycle implementation?
  // pipelining increases clock frequency!!
  #5 clk = ~clk;
end

// dump the state of the design
// VCD (Value Change Dump) is a standard dump format defined in Verilog.
initial begin
  $dumpfile("sim.vcd");
  $dumpvars(0, riscv_tb);
end

simple_cpu my_cpu(.clk(clk), .rstn(rstn));

endmodule
