//import the UVM ibrary

  import uvm_pkg::*
  `include "uvm_machos.svh"

//AXI Interface
    interface axi_if (a_clk, a_rstn);
      
      //Read address channel
      logic [3:0] arid;     
      logic [31:0] araddr;
      logic arvalid;
      logic arready;
      logic [1:0] arburst;    //FIXED, INCR, WRAP, 2'b11 -> RESERVED
      logic [2:0] arsize;     //0 -> 1B; 1 -> 2B, 111 -> 128B (MUST NOT EXCEED DATA WIDTH)
      logic [7:0] arlen;      // No of transfers per transactions

      //Read data channel
      logic [63:0] rdata;
      logic rvalid;
      logic [3:0] rid;
      logic [1:0] rresp;  // OKAY, EXOKAY, SLVERR, DECERR
      logic rlast;
      logic rrdeady;

      //Write address channel
      logic [31:0] awaddr;
      logic awvalid;
      logic awready;
      logic [2:0] awsize;
      logic [7:0] awlen;
      logic [1:0] awburst;
      logic [3:0] awid;

      //write data channel
      logic [63:0] wdata;
      logic wvalid;
      logic wlast;
      logic wready;
      
      //Write response channel
      logic [1:0] bresp;
      logic bvalid;
      logic bid;
      logic bready;

      //Modports

      //Constraints - Maybe in individual transaction class


    endinterface : axi_if

      
  
