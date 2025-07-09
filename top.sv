//`include "interface.sv"
`include "package.sv"
  import apb_pkg::*;
module top;

  reg pclk,prst_n;
  //Interface instantiation
  apb_interface inf(pclk,prst_n);
 
  //DUT instatiation
  apb_slave dut(inf);
  

//    //write_test instantiation
//   write_read_test wrt;
//   write_test wt;
//   read_test rt;
//   random_write_read_test rwrt;
//   check_pslverr slv;
  full_test test;
  
 // coverage cov;
  // Clock generation
  always #5 pclk=~pclk;
  
  initial begin
    $display("Hello");
   
    pclk=0;
     #3 prst_n=0;
     #10 prst_n=1;
    //Deassert reset after 10 time units
  	#500; prst_n=0;
    #150; prst_n=1;
  end
  
  initial begin
    
//     wrt=new(inf);
//     $display("Write_read_test");
//     wrt.write();
//     #400;
//     wrt.read();
//     #2000;
//      $finish;
    
//     rwrt = new(inf);
//     $display("Random_write_read_test");
//     rwrt.run();
//     #2500;
//     $finish;
    
//     wt = new(inf);
//     $display("Write Test");
//     wt.run();
//     #2500; $finish;
    
//     rt = new(inf);
//     $display("Read Test");
//     rt.run();
//     #2500; $finish;

  
    
//     slv = new(inf);
//     $display("Checking for slave error");
//     slv.run();
//     #2500; 
//     $finish;
    
    test = new(inf);
    test.run();
//   #5000 $finish;
    $finish;
  end
  
    
    
 
  
  initial begin
    $dumpfile("apb.vcd");
    $dumpvars();
  end
endmodule
