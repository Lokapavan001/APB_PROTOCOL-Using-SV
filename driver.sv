`ifndef APB_DRIVER
`define APB_DRIVER

class apb_driver;
  apb_transaction tr_h;
  
  virtual apb_interface vif;
  mailbox #(apb_transaction) gdmbx;
//   int wait_cycle = 0;
  int wait_cycle;

  
  function new(virtual apb_interface vif, mailbox #(apb_transaction) gdmbx);
    this.vif = vif;
    this.gdmbx = gdmbx;
  endfunction
  
   task reset_logic;
    while (!vif.rst_n) begin
      $display("Time = [%0t] [APB_DRIVER] Reset active", $time);
      vif.cb_driver.psel    <= 0;
      vif.cb_driver.penable <= 0;
      vif.cb_driver.pwrite  <= 0;
      vif.cb_driver.paddr   <= 0;
      vif.cb_driver.pwdata  <= 0;
//       #1;
      @(vif.cb_driver);
    end
     $display("Time = [%0t] [APB_DRIVER] Reset complete", $time);
  endtask
  
  task run;
    reset_logic();
    // Wait until reset is deasserted
    wait (vif.rst_n);
    forever begin
    	tr_h = new;
    	gdmbx.get(tr_h);
        $display("Time = [%0d] Driver has recevied the packet",$time);

//     IDLE
    	@(vif.cb_driver);
      	if (!vif.rst_n) begin
      		reset_logic();
    	end
      	else begin
          vif.cb_driver.psel    <= 0;
          vif.cb_driver.penable <= 0;
        end

//     SETUP
    	@(vif.cb_driver);
      	if (!vif.rst_n) begin
      		reset_logic();
    	end
      	else begin
        	vif.cb_driver.psel    <= 1;
      		vif.cb_driver.penable <= 0;
      		vif.cb_driver.pwrite  <= tr_h.pwrite;
      		vif.cb_driver.paddr   <= tr_h.paddr;
      		vif.cb_driver.pwdata  <= tr_h.pwdata;
      end

//     ACCESS
    	@(vif.cb_driver);
      	if (!vif.rst_n) begin
    		reset_logic();
    	end
      	else begin
        	vif.cb_driver.penable <= 1;
      	end
      
      	tr_h.display("Driver");

//      Wait for pready
//       wait (vif.cb_driver.pready && vif.rst_n);
//       wait (vif.cb_driver.pready);
      
//       while ((vif.cb_driver.pready != 1) && (wait_cycle < 5)) begin
//         @(vif.cb_driver);
//         wait_cycle++;
//       end
      for (wait_cycle = 0; wait_cycle < 5; wait_cycle++) begin
        @(posedge vif.pclk);
        if (vif.cb_driver.pready == 1)
          break;
      end
      if (vif.cb_driver.pready != 1) begin
        $warning("Time = [%0t] [APB_DRIVER] Warning: pready not high within 5 cycles", $time);
      end
//       repeat(5) begin
//         if(vif.pready && vif.psel && vif.penable) begin
//           @(vif.cb_driver);
//           vif.cb_driver.psel    <= 0;
//           vif.cb_driver.penable <= 0;
//           @(vif.cb_driver);
//           break;
//         end
//         else
//           @(vif.cb_driver);
//       end
  	end
  endtask  
endclass : apb_driver

`endif