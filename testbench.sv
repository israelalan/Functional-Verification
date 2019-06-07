`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

 
`include "dut_if.svh"
`include "dut_item.svh"
`include "dut_drv_seq_mon.svh"
`include "dut_agent.svh"
`include "dut_sequences.svh"
`include "dut_subs.svh"
`include "env.svh"
`include "dut_test.svh"

module test;

 bit clk;
 bit reset; 
 bit data_valid_in;
 bit cipherkey_valid_in;

   initial begin
      clk=0;
      reset=1;
      data_valid_in=1;
      cipherkey_valid_in=1;
   end

   
   always begin
      #5 clk = ~clk;
   end
   dut_if  in_dif(.clk(clk), .reset(reset), .data_valid_in(data_valid_in), .cipherkey_valid_in(cipherkey_valid_in));
  Top_PipelinedCipher aes_1(.cipher_key(in_dif.cipher_key), .plain_text(in_dif.plain_text), .valid_out(in_dif.valid_out), .cipher_text(in_dif.cipher_text), .reset(reset), .data_valid_in(data_valid_in), .cipherkey_valid_in(cipherkey_valid_in), .clk(clk)); 
  initial begin
    uvm_config_db#(virtual dut_if)::set(uvm_root::get(), "*.agt.*", "in_intf", in_dif);
    
    run_test("dut_base_test");
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, test);
  end
  
  
endmodule

