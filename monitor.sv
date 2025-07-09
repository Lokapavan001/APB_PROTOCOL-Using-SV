`ifndef APB_MONITOR
`define APB_MONITOR

// `include "transaction.sv"
class apb_monitor;
  apb_transaction tr_h;
  virtual apb_interface vif;
  mailbox #(apb_transaction) mon2sco,mon2pre;
 
  
  function new(virtual apb_interface vif, mailbox #(apb_transaction) mon2sco,mon2pre);
    this.vif = vif;
    this.mon2sco = mon2sco;
    this.mon2pre =mon2pre;
  endfunction
  
  task run;
    tr_h = new();
    forever begin
     
      @(vif.cb_monitor) 
        if(vif.cb_monitor.psel && !vif.cb_monitor.penable) begin
          @(vif.cb_monitor);
          if(vif.cb_monitor.psel && vif.cb_monitor.penable) begin
            wait(vif.cb_monitor.pready);

            tr_h.psel 	 = vif.psel;
        	tr_h.penable = vif.penable;
        	tr_h.pwrite  = vif.pwrite;
        	tr_h.pwdata  = vif.pwdata;
        	tr_h.paddr   = vif.paddr;
        	tr_h.prdata  = vif.prdata;
        	tr_h.pready  = vif.pready;
        	tr_h.pslverr = vif.pslverr;
          
              
        tr_h.display("Monitor");
			
          end

          mon2pre.put(tr_h);

          mon2sco.put(tr_h); 
          
     ->e1;
           
        end
    end
    //->e1;
  endtask
endclass : apb_monitor

`endif