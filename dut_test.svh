

class dut_base_test extends uvm_test;

  environment  env;
 
  `uvm_component_utils(dut_base_test);
  
  
  virtual dut_if vif;
  uvm_table_printer printer;
  function new(string name = "dut_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

 
  function void build_phase(uvm_phase phase);
    env = environment::type_id::create("env", this);
    printer = new();
    printer.knobs.depth = 5;
    
  endfunction
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Printing Test Topology: \n%s", this.sprint(printer)), UVM_LOW)
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    dut_base_seq dut_seq;
    dut_seq = dut_base_seq::type_id::create("dut_seq");
    phase.raise_objection( this, "Starting vespa_base_seqin main phase" );
    dut_seq.start(env.in_env.agt.sqr);
    phase.drop_objection( this , "Finished vespa_seq in main phase" );
  endtask: run_phase
  
  
endclass


