class environment extends uvm_env;
  dut_env in_env;
  dut_env out_env;
  dut_sb sb;
  dut_cov my_cov;
  `uvm_component_utils(environment)
  function new(string name="environment", uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_env = dut_env::type_id::create("in_env", this);
    out_env = dut_env::type_id::create("out_env", this);
    sb = dut_sb::type_id::create("sb", this);
    my_cov = dut_cov::type_id::create("my_cov", this);
    uvm_config_db#(int)::set(this, "in_env.agt", "is_active", UVM_ACTIVE);
    uvm_config_db#(int)::set(this, "out_env.agt", "is_active", UVM_PASSIVE);
    
    
    `uvm_info(get_full_name(), $sformatf("Environment Build Complete"), UVM_LOW)
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
out_env.agt.mon.item_collected_port.connect(sb.input_packets_collected.analysis_export);
out_env.agt.mon.item_collected_port.connect(sb.input_packets_collected_check.analysis_export);
    out_env.agt.mon.cov_port.connect(my_cov.analysis_export);
       `uvm_info(get_full_name(), $sformatf("Environment connect phase complete"), UVM_LOW)
  endfunction
  
endclass
