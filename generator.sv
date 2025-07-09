`ifndef APB_GENERATOR
`define APB_GENERATOR
// `include "transaction.sv"
class apb_generator;
  apb_transaction tr_h;
  bit[4:0]count;
  bit mode;
  bit error;
  
  mailbox #(apb_transaction) gen2drv;
	 
  function new(mailbox #(apb_transaction) gen2drv);
    this.gen2drv = gen2drv;
    
  endfunction

  task run();
     
    repeat (count) begin
      tr_h = new();
      if(mode==1 && error==0)begin
        if(tr_h.randomize() with {pwrite==1;})begin
          
           gen2drv.put(tr_h);
           tr_h.display("GEN");end
        else
          $error("write Randomizzation failed");
        
      end
      
      else begin
        if(mode==0 && error==0)begin
          if(tr_h.randomize(paddr) with{tr_h.pwrite == 0;})begin

          gen2drv.put(tr_h);
          tr_h.display("GEN");end
          else
            $error("read Randomizzation failed");end
        
        else if( mode == 0 && error==1)begin
          if(tr_h.randomize() with {paddr==32'hFFFF_FFFF;})begin
      			gen2drv.put(tr_h);
      			tr_h.display("GEN");end
          else
            $error("Randomization failed");
          
        end
        else begin
          if(tr_h.randomize())begin
     	  	gen2drv.put(tr_h);
          	tr_h.display("GEN");end
          else
            $error("Randomization failed");
          
        end
        
      end 
      @(e1);
      #6;
    end
  endtask
endclass

`endif



// `ifndef APB_GENERATOR
// `define APB_GENERATOR
// // `include "transaction.sv"
// class apb_generator;
//   apb_transaction tr_h;
//   bit[4:0]count;
//   bit mode;
//   bit error;
//   bit [31:0] write_addr_list[$];  
  
//   mailbox #(apb_transaction) gen2drv;
	 
//   function new(mailbox #(apb_transaction) gen2drv);
//     this.gen2drv = gen2drv;
    
//   endfunction

//   task run();
     
//     repeat (count) begin
//       tr_h = new();
//       if(mode==1 && error==0)begin
//         if(tr_h.randomize() with {pwrite==1;})begin
//           write_addr_list.push_back(tr_h.paddr); 
//            gen2drv.put(tr_h);
//            tr_h.display("GEN");end
//         else
//           $error("write Randomizzation failed");
        
//       end
      
//       else if(mode==0 && error==0)begin
//           foreach (write_addr_list[i]) begin
//     		tr_h = new();
//     		tr_h.paddr  = write_addr_list[i];  // Use stored address
//     		tr_h.pwrite = 0;
//         	gen2drv.put(tr_h);
//           tr_h.display("GEN");end
//         end
// //           else
// //             $error("read Randomizzation failed");end
        
//         else if(mode==0 && error==1)begin
//           if(tr_h.randomize() with {paddr==32'hFFFF_FFFF;})begin
//       			gen2drv.put(tr_h);
//       			tr_h.display("GEN");end
//           else
//             $error("Randomization failed");
          
//         end
//         else begin
//           if(tr_h.randomize())begin
//      	  	gen2drv.put(tr_h);
//           	tr_h.display("GEN");end
//           else
//             $error("Randomization failed");
          
//         end
        
       
//       @(e1);
//       #6;
//     end
//   endtask
// endclass

// `endif
