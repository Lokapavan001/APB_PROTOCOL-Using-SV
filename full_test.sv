`ifndef FULL_TEST
`define FULL_TEST

class full_test;
  apb_environment env_h;
  virtual apb_interface vif;

  function new(virtual apb_interface vif);
    this.vif = vif;
  endfunction
  
  task run_write;
    $display("Running WRITE test");
    env_h = new(vif);
    env_h.build();
    env_h.gen_h.count = 20;
    env_h.gen_h.mode  = 1; // Mode 1 = write
    env_h.gen_h.error = 0;
    env_h.run();
    $display("End of WRITE test");
  endtask
  
  task run_read;
    $display("Running READ test");
    env_h = new(vif);
    env_h.build();
    env_h.gen_h.count = 20;
    env_h.gen_h.mode  = 0; // Mode 0 = read
    env_h.gen_h.error = 0;
    env_h.run();
    $display("End of READ test");
  endtask
  
  task run_write_read;
    $display("Running WRITE-READ test");
    run_write();
//     wait(env_h.gen_h.done == 1);
    run_read();
//     wait(env_h.gen_h.done == 1);
    $display("End of WRITE-READ test");
  endtask
  
  task run_random;
    $display("Running Random Write/Read test");
    env_h = new(vif);
    env_h.build();
    env_h.gen_h.count = 20;
    env_h.gen_h.mode  = 1;  // Random mode?
    env_h.gen_h.error = 1;
    env_h.run();
    $display("End of Random Write/Read test");
  endtask
  
  task run_pslverr;
    $display("Running PSLVERR test");
    env_h = new(vif);
    env_h.build();
    env_h.gen_h.count = 20;
    env_h.gen_h.mode  = 0;  // Write mode
    env_h.gen_h.error = 1;
    env_h.run();
    $display("End of PSLVERR test");
  endtask
  
  task run;
    run_write();
    run_read();
    run_random();
//     run_write_read();
    run_pslverr();
     
  endtask
endclass : full_test

`endif