


class dut_base_seq extends uvm_sequence#(dut_tr);
  `uvm_object_utils(dut_base_seq)
  function new(string name= "dut_base_seq");
    super.new(name);
  endfunction
task body();
  
  dut_tr tr;
  repeat(5000) begin
      tr = dut_tr::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      finish_item(tr);
    end
    
  endtask
  
endclass


