`ifndef CHECK_PSLVERR
`define CHECK_PSLVERR

class check_pslverr;
  apb_environment env_h;
  virtual apb_interface vif;

  function new(virtual apb_interface vif);
    this.vif = vif;
  endfunction
  
  task run;
    $display("Running inside check plsverr test");
      env_h = new(vif);
      env_h.build();
      env_h.gen_h.count = 20;
      env_h.gen_h.mode  = 0;
      env_h.gen_h.error = 1;
      env_h.run();
    $display("End of read test");
  endtask
endclass : check_pslverr

`endif