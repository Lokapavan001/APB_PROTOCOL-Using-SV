// `ifndef APB_SCOREBOARD
// //`ifndef APB_SCOREBOARD
// `define APB_SCOREBOARD

// class apb_scoreboard;
  
//   apb_transaction pspkt_h,tr_h;
//   mailbox #(apb_transaction) mon2sco,pre2sco;
  
   

//   function new(mailbox #(apb_transaction)mon2sco,pre2sco);
//     this.mon2sco   = mon2sco;
//     this.pre2sco = pre2sco;
   
//   endfunction

// task run();
//     forever begin
//     //  tr_h=new();
//       //pspkt_h=new();
//       mon2sco.get(tr_h);
//       pre2sco.get(pspkt_h);
      
//       if(pspkt_h.pwrite == 0) begin
//         if(tr_h.prdata == pspkt_h.prdata) begin
//           $display("PASS : MON_rdata = %0d PRE_rdata = %0d", tr_h.prdata, pspkt_h.prdata);
//           tr_h.display("Scoreboard");
//           $display("------------------------------------------------------------------------------------------------");
//         end
//         else begin
//           $display("FAIL : MON_rdata = %0d PRE_rdata = %0d", tr_h.prdata, pspkt_h.prdata);
//           pspkt_h.display("Scoreboard");
          
//           $display("-----------------------------------------------------------------------");
//         end
//       end
//       else begin
//         pspkt_h.display("Scoreboard");
//         $display("Time =[%0t] Write Transaction Completed",$time);
//         $display("--------------------------------------------------------------------------------------");
//       end
//     end
//   endtask
// endclass

// `endif

`ifndef APB_SCOREBOARD
`define APB_SCOREBOARD

class apb_scoreboard;

  apb_transaction pspkt_h, tr_h;
  mailbox #(apb_transaction) mon2sco, pre2sco;
  virtual apb_interface vif;

  //  Embedded Coverage Group
  covergroup cg_cover @(posedge vif.pclk);
    option.per_instance = 1;

    cp1 : coverpoint vif.paddr {
      bins b1 = {[0:127]};
      bins b2 = {32'hffff_ffff};
    }

    cp2 : coverpoint vif.pwdata {
      bins b3 = {[0:255]};
    }

    cp3 : coverpoint vif.prdata {
      bins b4 = {[0:255]};
    }

    cp4 : coverpoint vif.psel {
      bins b5 = {1};
      bins b6 = {0};
    }

    cp5 : coverpoint vif.pwrite {
      bins b7 = {1};
      bins b8 = {0};
    }

    cp2_x_cp5 : cross cp2, cp5;
    cp3_x_cp5 : cross cp3, cp5;
  endgroup

  //  Constructor
  function new(mailbox #(apb_transaction) mon2sco,
               mailbox #(apb_transaction) pre2sco,
               virtual apb_interface vif);
    this.mon2sco = mon2sco;
    this.pre2sco = pre2sco;
    this.vif     = vif;

    // Initialize coverage group
    cg_cover = new();
  endfunction

  // Main scoreboard + coverage logic
  task run();
    forever begin
      tr_h = new();
      pspkt_h = new();

      mon2sco.get(tr_h);
      pre2sco.get(pspkt_h);

      //  Sample coverage on valid APB access
//       if (vif.psel && vif.penable && vif.pready) begin
//       cg_cover.sample();
//       end
      //end

      
      if (pspkt_h.pwrite == 0) begin
        if (tr_h.prdata == pspkt_h.prdata) begin
          tr_h.display("Scoreboard");
          $display("PASS : MON_rdata = %0d, PRE_rdata = %0d", tr_h.prdata, pspkt_h.prdata);
          
        end else begin
           pspkt_h.display("Scoreboard");
          $display(" FAIL : MON_rdata = %0d, PRE_rdata = %0d", tr_h.prdata, pspkt_h.prdata);
         
        end
        $display("------------------------------------------------------------");
      end else begin
        pspkt_h.display("Scoreboard");
        $display("WRITE Transaction at time [%0t]", $time);
        $display("------------------------------------------------------------");
      end
    end
  endtask

endclass

`endif

