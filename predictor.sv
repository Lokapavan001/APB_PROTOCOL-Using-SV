`ifndef APB_PREDICTOR
`define APB_PREDICTOR

class apb_predictor;
  
  apb_transaction mppkt_h,pspkt_h;
 
  virtual apb_interface vif;
  mailbox #(apb_transaction)mon2pre,pre2sco;
  // simple model memory
  bit [31:0] mem [0:255];
  
  function new(virtual apb_interface vif,mailbox #(apb_transaction) mon2pre,pre2sco);
    this.vif =vif;
    this.mon2pre = mon2pre;
    this.pre2sco = pre2sco;
    
  endfunction
 task run();
    
   
   forever begin  
      mon2pre.get(mppkt_h);
     $display($time,"[PREDICTOR] Got txn PAddr=%0d pwrite=%0b pwdata=%0d", mppkt_h.paddr, mppkt_h.pwrite,mppkt_h.pwdata);

       pspkt_h = new;
      @(posedge vif.pclk);
      if (!vif.rst_n) begin
        foreach (mem[i]) mem[i] = i;

      	pspkt_h.prdata  = 0;
      	pspkt_h.pready  = 1;
      	pspkt_h.pslverr = 0;
        pspkt_h.display("PREDICT-RESET");
        pre2sco.put(pspkt_h);
      //  @(posedge vif.pclk);
      end
     else begin
      if(mppkt_h.pwrite) begin
            mem[mppkt_h.paddr] = mppkt_h.pwdata; 
            pspkt_h.psel    = mppkt_h.psel;
            pspkt_h.penable = mppkt_h.penable;
            pspkt_h.pwrite  = mppkt_h.pwrite;
            pspkt_h.paddr   = mppkt_h.paddr;
            pspkt_h.pwdata  = mppkt_h.pwdata;
            pspkt_h.pready  = mppkt_h.pready;
            pspkt_h.prdata  = mppkt_h.prdata;
          end
          else begin
            pspkt_h.pwdata = mem[mppkt_h.paddr];
            pspkt_h.psel    = mppkt_h.psel;
            pspkt_h.penable = mppkt_h.penable;
            pspkt_h.pwrite  = mppkt_h.pwrite;
            pspkt_h.paddr   = mppkt_h.paddr;
            pspkt_h.prdata  = mppkt_h.prdata;
//             pspkt_h.pready  = mppkt_h.pready;
            pspkt_h.pwdata  = 0;
          end
       pspkt_h.display("Predictor");
        end
      

//       pspkt_h.display("Predictor");
     pre2sco.put(pspkt_h);
     
      
    end
  endtask

 
endclass

`endif
