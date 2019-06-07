


class dut_master_drv extends uvm_driver#(dut_tr);
  
  `uvm_component_utils(dut_master_drv)
   
   virtual dut_if vif;
  

   function new(string name,uvm_component parent = null);
      super.new(name,parent);
   endfunction

  
   function void build_phase(uvm_phase phase);
     
     super.build_phase(phase);
    
     if (!uvm_config_db#(virtual dut_if)::get(this, "", "in_intf", vif)) begin
         `uvm_fatal("MUL/DRV/NOVIF", "No virtual interface specified for this driver instance")
         end
       `uvm_info(get_full_name(), "Driver Build Stage Complete", UVM_LOW)

   endfunction

  
   virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
   

     forever begin
       dut_tr tr;
       @ (posedge vif.clk);
         seq_item_port.get_next_item(tr);
         tr.displayAll();
       	 vif.plain_text = tr.plain_text;
       	 vif.cipher_key = tr.cipher_key;
         seq_item_port.item_done();
     end
   endtask: run_phase


endclass: dut_master_drv


class dut_sequencer extends uvm_sequencer #(dut_tr);

  `uvm_component_utils(dut_sequencer)
 
   function new(input string name, uvm_component parent=null);
      super.new(name, parent);
   endfunction : new
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), $sformatf("Sequencer Build Stage Complete"), UVM_LOW)
  endfunction

endclass : dut_sequencer




class dut_mon extends uvm_monitor;
  dut_tr data_collected;
  dut_tr data_clone;
  int num_data;
  uvm_analysis_port #(dut_tr) item_collected_port;
  uvm_analysis_port #(dut_tr) cov_port;
  `uvm_component_utils(dut_mon);
  function new(string name="dut_mon", uvm_component parent);
    super.new(name, parent);
  endfunction
  virtual dut_if vif;
  string mon_if;
  function void build_phase(uvm_phase phase);
     
    super.build_phase(phase);
   
    if(!uvm_config_db#(virtual dut_if)::get(this, "", "in_intf", vif)) begin
      `uvm_fatal("MUL/MON/NOVIF", "No virtual interface specified for this monitor instance");
      end
    item_collected_port = new("item_collected_port", this);
    cov_port = new("cov_port", this);
    data_collected = dut_tr::type_id::create("data_collected", this);
    data_clone = dut_tr::type_id::create("data_clone", this);
    `uvm_info(get_full_name(), "Monitor Build Stage Complete", UVM_LOW)
  endfunction
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge vif.clk)
      data_collected.cipher_key = vif.cipher_key;
      data_collected.plain_text = vif.plain_text;
      data_collected.valid_out = vif.valid_out;
      data_collected.cipher_text = vif.cipher_text;
      $cast(data_clone, data_collected.clone());
      item_collected_port.write(data_clone);
      cov_port.write(data_clone);
      num_data++;
    end
  endtask
  virtual function void report_phase(uvm_phase phase); 
    `uvm_info(get_type_name(), $sformatf("Report: Collected packets %0d", num_data), UVM_LOW)
  endfunction
endclass : dut_mon
