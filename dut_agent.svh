import "DPI-C" function void reference_model(input byte plain_text[16], output byte cipher_text[16]);

class dut_agent extends uvm_agent;

  protected uvm_active_passive_enum is_active;
   dut_sequencer sqr;
   dut_master_drv drv;
 	dut_mon mon;

   virtual dut_if  vif;

  `uvm_component_utils_begin(dut_agent)
      `uvm_field_object(sqr, UVM_ALL_ON)
      `uvm_field_object(drv, UVM_ALL_ON)
  `uvm_field_object(mon, UVM_ALL_ON)
   `uvm_component_utils_end
   
   function new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction

  
   virtual function void build_phase(uvm_phase phase);
     uvm_config_db#(int)::get(this, "", "is_active", is_active);
     if(is_active == UVM_ACTIVE) begin
      sqr = dut_sequencer::type_id::create("sqr", this);
      drv = dut_master_drv::type_id::create("drv", this);
     end
     else if(is_active == UVM_PASSIVE) begin
     mon = dut_mon::type_id::create("mon", this);
     end
     `uvm_info(get_full_name(), "Agent Build Stage Complete", UVM_LOW)
     
   endfunction: build_phase

 
   virtual function void connect_phase(uvm_phase phase);
     if(is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
     uvm_report_info(get_full_name(), "connect_phase, Connected driver to sequencer");
     end
   endfunction
endclass: dut_agent


class dut_sb extends uvm_scoreboard;
  dut_tr input_packet;
  dut_tr input_packet_check;
  uvm_tlm_analysis_fifo #(dut_tr) input_packets_collected;
  uvm_tlm_analysis_fifo #(dut_tr) input_packets_collected_check;
  virtual dut_if vif;
  logic [127:0] cipher_key, plain_text;
  logic valid_out;
  logic [127:0] cipher_text;
  byte check[0:15] ;
  byte compare_text[0:15] ;

  string plain_text_string_127;
  string plain_text_string_95;
  string plain_text_string_63;
  string plain_text_string_31;
  string plain_text_string;
  string cipher_key_string;
  byte plain_text_ref[0:15];

  `uvm_component_utils(dut_sb)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    input_packets_collected = new("input_packets_collected", this);
    input_packets_collected_check = new("input_packets_collected_check", this);
    input_packet = dut_tr::type_id::create("input_packet", this);
    input_packet_check = dut_tr::type_id::create("input_packet_check", this);
    `uvm_info(get_full_name(), "Scoreboard Build Stage Complete", UVM_LOW)
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    compare();
  endtask
  virtual task compare();
    forever begin
    input_packets_collected.get(input_packet);
      cipher_key = input_packet.cipher_key;
      plain_text = input_packet.plain_text;
      valid_out = input_packet.valid_out;
      cipher_text = input_packet.cipher_text;
      
      	 compare_text[0] = cipher_text[127:120];
	 compare_text[1] = cipher_text[119:112];
	 compare_text[2] = cipher_text[111:104];
	 compare_text[3] = cipher_text[103:96];
	 compare_text[4] = cipher_text[95:88];
	 compare_text[5] = cipher_text[87:80];
	 compare_text[6] = cipher_text[79:72];
	 compare_text[7] = cipher_text[71:64];
	 compare_text[8] = cipher_text[63:56];
	 compare_text[9] = cipher_text[55:48];
	 compare_text[10] = cipher_text[47:40];
	 compare_text[11] = cipher_text[39:32];
	 compare_text[12] = cipher_text[31:24];
	 compare_text[13] = cipher_text[23:16];
	 compare_text[14] = cipher_text[15:8];
	 compare_text[15] = cipher_text[7:0];
         
      if(valid_out) begin
	
	input_packets_collected_check.get(input_packet_check);
      	cipher_key = input_packet_check.cipher_key;
        plain_text = input_packet_check.plain_text;
        valid_out = input_packet_check.valid_out;
        cipher_text = input_packet_check.cipher_text;
	
	plain_text_ref[0] = plain_text[127:120];
	 plain_text_ref[1] = plain_text[119:112];
	 plain_text_ref[2] = plain_text[111:104];
	 plain_text_ref[3] = plain_text[103:96];
	 plain_text_ref[4] = plain_text[95:88];
	 plain_text_ref[5] = plain_text[87:80];
	 plain_text_ref[6] = plain_text[79:72];
	 plain_text_ref[7] = plain_text[71:64];
	 plain_text_ref[8] = plain_text[63:56];
	 plain_text_ref[9] = plain_text[55:48];
	 plain_text_ref[10] = plain_text[47:40];
	 plain_text_ref[11] = plain_text[39:32];
	 plain_text_ref[12] = plain_text[31:24];
	 plain_text_ref[13] = plain_text[23:16];
	 plain_text_ref[14] = plain_text[15:8];
	 plain_text_ref[15] = plain_text[7:0];
	
	reference_model(plain_text_ref, check);

	      if(compare_text[0] == check[0] && compare_text[1] == check[1] && compare_text[2] == check[2] && compare_text[3] == check[3] && compare_text[4] == check[4] && compare_text[5] == check[5] && compare_text[6] == check[6] && compare_text[7] == check[7] && compare_text[8] == check[8] && compare_text[9] == check[9] && compare_text[10] == check[10] && compare_text[11] == check[11] && compare_text[12] == check[12] && compare_text[13] == check[13] && compare_text[14] == check[14] && compare_text[15] == check[15]) begin
		`uvm_info(get_full_name(), $sformatf("Test Passed, Expected %0p, Got %0p", compare_text, check), UVM_LOW)
	      end
	      else begin
		 `uvm_error(get_full_name(), $sformatf("Test Failed, Got %0p, Expected %0p", compare_text, check));
	      end
	end
    end
  endtask
  
endclass: dut_sb

class dut_env  extends uvm_env;
 
  `uvm_component_utils(dut_env);

  
   dut_agent  agt;
  

   function new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction

  
   function void build_phase(uvm_phase phase);
     agt = dut_agent::type_id::create("agt", this);
    
   endfunction: build_phase
  
endclass : dut_env  
  
