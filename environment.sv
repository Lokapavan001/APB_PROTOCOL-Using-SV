`ifndef APB_ENVIRONMENT
`define APB_ENVIRONMENT

class apb_environment;
  apb_generator gen_h;
  apb_driver    drv_h;
  apb_monitor   mon_h;
  apb_predictor  pre_h;
  apb_scoreboard sco_h;
  
  mailbox #(apb_transaction) gen2drv;
  mailbox #(apb_transaction) mon2sco;
  mailbox #(apb_transaction) mon2pre;
  
  //mailbox #(apb_transaction) mon2sco;
  //mailbox #(apb_transaction) mon2pre;
  mailbox #(apb_transaction) pre2sco;
  
  virtual apb_interface vif;
  
  function new( virtual apb_interface vif);  // Constructor to initialize handle
    
    this.vif = vif;
     
    gen2drv = new;
	mon2sco = new;
    mon2pre = new;
    
// 	 mon2sco = new;
// 	 mon2pre = new;
 	 pre2sco = new;
  endfunction
  
  task build;
   // ag_h  = new(vif);
     gen_h = new(gen2drv);
      drv_h = new(vif, gen2drv);
      mon_h = new(vif,mon2sco,mon2pre);
    pre_h = new(vif,mon2pre,pre2sco);
    sco_h = new(mon2sco,pre2sco,vif);
  endtask
  
  task run;
    fork
     gen_h.run;
     drv_h.run;
     mon_h.run;
     pre_h.run;
     sco_h.run;
    join_any
  endtask
endclass : apb_environment

`endif