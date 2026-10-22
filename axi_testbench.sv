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


        //add TB signals here
      endclocking

      //Modports - assuming AXI SLAVE DUT
      modport DUT (input 
                   a_clk, a_rstn,
                   //read addr channel
                   arvalid, araddr, arid, arsize, arlen, arburst,
                   //read-response channel
                   rready,
                   //write-addr channel
                   awid, awaddr, awvalid, awsize, awlen, awbusrt,
                   //write-data channel
                   wdata, wvalid, wlast,
                   //write-resp channel
                   bready,
                   
                   output
                   //read addr channel
                   arready,
                   read response channel
                   rid, rdata, rlast, rvalid, rresp,
                   //write addr channel
                   awready,
                   //write data channel
                   wready,
                   //write-resp channel
                   breasp, bvalid, bid  
                  );

      //clocking block
      clocking cb @(posedge clk);
           output  //read addr channel
                   arvalid, araddr, arid, arsize, arlen, arburst,
                   //read-response channel
                   rready,
                   //write-addr channel
                   awid, awaddr, awvalid, awsize, awlen, awbusrt,
                   //write-data channel
                   wdata, wvalid, wlast,
                   //write-resp channel
                   bready;
                
            input  //read addr channel
                   arready,
                   read response channel
                   rid, rdata, rlast, rvalid, rresp,
                   //write addr channel
                   awready,
                   //write data channel
                   wready,
                   //write-resp channel
                   breasp, bvalid, bid;
      endclocking

      modport TB ( clocking cb, 
        input a_rstn);
                   
      //Constraints - Maybe in individual transaction class

    endinterface : axi_if

    /////////////////////////////// TESTBENCH TOP /////////////////////////////////

    module tb_top();

      bit a_clk, a_rstn;

      initial begin
        a_clk = 1'b0;
        forever clk = #5 !clk;
      end

      initial begin
        a_rstn = 1'b1;
        #5;
        a_rstn = 1'b0;
        #5;
        a_rstn = 1'b1;
      end

      //interface
      axi_if axi_intf(a_clk, a_rstn);

      //DUT
      axi_slave_dut (axi_intf.DUT);

      initial begin
        $dumpfile("waves.shm");
        $dumpvars();
      end

      initial begin
        //setting the virtual interface for all the components who want to access this interface.
        uvm_config_db(#virtual interface axi_if)::set(null, "*", "vif", axi_intf);
        run_test();
      end 
    endmodule

///////////////////////// TRANSACTION CLASS /////////////////////////////
