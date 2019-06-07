class dut_cov extends uvm_subscriber#(dut_tr);
  dut_tr tr;
  int count;
 
  `uvm_component_utils(dut_cov)
  covergroup cg;
    coverpoint tr.cipher_key;
    coverpoint tr.plain_text;
    coverpoint tr.valid_out;
    coverpoint tr.cipher_text;
  endgroup
  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg = new();
    endfunction
  function void build_phase(uvm_phase phase);
    tr = dut_tr::type_id::create("tr", this);
    `uvm_info(get_full_name(), $sformatf("Completed Subscriber Build"), UVM_LOW)
  endfunction
  function void write(dut_tr t);
    tr = t;
    count++;
    cg.sample();
  endfunction
  virtual function void extract_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Number of coverage transactions collected = %d", count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Current coverage = %f", cg.get_coverage()), UVM_LOW)
  endfunction
endclass
