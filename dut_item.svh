class dut_tr extends uvm_sequence_item;
 
  rand bit [127:0] cipher_key, plain_text;
  rand bit valid_out;  
  rand bit [127:0] cipher_text;
  `uvm_object_utils_begin(dut_tr)
  `uvm_field_int(cipher_key, UVM_DEFAULT)
  `uvm_field_int(plain_text, UVM_DEFAULT)
  `uvm_field_int(valid_out, UVM_DEFAULT)
  `uvm_field_int(cipher_text, UVM_DEFAULT)
  `uvm_object_utils_end
  
  constraint c1{cipher_key == 128'h000102030405060708090a0b0c0d0e0f;};
  function new (string name = "dut_tr");
      super.new(name);
   endfunction
  virtual task displayAll();
    `uvm_info(get_full_name(), $sformatf("Got Transaction cipher_key=%32h, plain_text=%32h", cipher_key, plain_text), UVM_LOW);
  endtask
   

endclass: dut_tr
