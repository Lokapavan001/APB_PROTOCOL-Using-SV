`ifndef APB_TRANSACTION
`define APB_TRANSACTION

class apb_transaction;
  
  bit psel;
  bit penable;
  rand bit [31:0]paddr;
  rand bit [31:0]pwdata;
  rand bit pwrite;
  bit [31:0]prdata;
  bit pready;
  bit pslverr;
  
  constraint c_pwrite{soft pwrite dist {1:=1,0:=1};}
  constraint c_paddr {soft paddr inside{[0:127]};!(paddr inside {0,4,8,12});}
  constraint c1_pwdata{soft pwdata inside{[1:255]};}
  
  function void display(input string tag);
    $display($time,"[%s] psel =%0d penable=%0d pwrite=%0d paddr=%0d pwdata=%0d prdata=%0d pready=%0d pslverr=%0d",tag,psel,penable,pwrite,paddr,pwdata,prdata,pready,pslverr);
  endfunction
    
  
  
endclass


`endif