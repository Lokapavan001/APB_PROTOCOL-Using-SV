`ifndef RANDOM_WRITE_READ_TEST
`define RANDOM_WRITE_READ_TEST

class random_write_read_test;
  apb_environment env_h;
  virtual apb_interface vif;

  function new(virtual apb_interface vif);
    this.vif = vif;
  endfunction
  
  task run;
    $display("Running Random Write read test");
      env_h = new(vif);
      env_h.build();
      env_h.gen_h.count = 25;
      env_h.gen_h.mode  = 0;
      env_h.gen_h.error = 1;
      env_h.run();
    $display("End of Random Write read test");
  endtask
endclass : random_write_read_test

`endif