library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;



entity scalp_communication is

	port (
		reset: in std_logic;

		gtp_p_in: in std_logic_vector(0 downto 0); 
		gtp_n_in: in std_logic_vector(0 downto 0); 
		gtp_p_out: out std_logic_vector(0 downto 0); 
		gtp_n_out: out std_logic_vector(0 downto 0); 
		gtp_ref_clk_p: in std_logic;
		gtp_ref_clk_n: in std_logic
	);

end entity;


architecture arch of scalp_communication is

	-- Standard AXI4-Stream TX (master to Aurora)
	type axis_tx_t is record
		tdata  : std_logic_vector(0 to 31);  -- note: big-endian 0 to N
		tkeep  : std_logic_vector(0 to 3);
		tvalid : std_logic;
		tready  : std_logic;
		tlast  : std_logic;
	end record;
	
	-- Standard AXI4-Stream RX (Aurora to master)
	type axis_rx_t is record
		tdata  : std_logic_vector(0 to 31);
		tkeep  : std_logic_vector(0 to 3);
		tvalid : std_logic;
		tlast  : std_logic;
	end record;
	
	-- NFC interface (separate from data path)
	type axis_nfc_tx_t is record
		tvalid : std_logic;          
		tdata  : std_logic_vector(0 to 3);  
		tready : std_logic;  
	end record;
	
	type axis_nfc_rx_t is record
		tvalid  : std_logic;
		tdata : std_logic_vector(0 to 3);
	end record;

	type aurora_error_t is record
		frame_err  : std_logic;
		hard_err   : std_logic;
		soft_err   : std_logic;
		channel_up : std_logic;
		lane_up    : std_logic_vector(0 downto 0);
	end record;

	type aurora_reset_t is record
		usr_reset : std_logic;
		gt_reset  : std_logic;
		reset_out : std_logic;
	end record;

	signal axis_tx: axis_tx_t;
	signal axis_rx: axis_rx_t;

	signal axis_nfc_tx: axis_nfc_tx_t;
	signal axis_nfc_rx: axis_nfc_rx_t;

	signal aurora_error: aurora_error_t;
	signal aurora_reset: aurora_reset_t;

begin

    Aurora : block is
    begin
	    entity work.aurora_8b10b_0_support
		port map (
	    		-- AXI TX Interface
	    		s_axi_tx_tdata       => axis_tx.tdata, 
	    		s_axi_tx_tkeep       => axis_tx.tkeep, 
	    		s_axi_tx_tvalid      => axis_tx.tvalid, 
	    		s_axi_tx_tready      => axis_tx.tready, 
	    		s_axi_tx_tlast       => axis_tx.tlast, 
	    		-- AXI RX Interface
	    		m_axi_rx_tdata       => axis_rx.tdata, 
	    		m_axi_rx_tkeep       => axis_rx.tkeep, 
	    		m_axi_rx_tvalid      => axis_rx.tvalid, 
	    		m_axi_rx_tlast       => axis_rx.tlast, 


	    		-- Native Flow Control
			s_axi_nfc_tx_tvalid  => axis_nfc_tx.tvalid,
			s_axi_nfc_tx_tdata   => axis_nfc_tx.tdata,
			s_axi_nfc_tx_tready  => axis_nfc_tx.tready,

			m_axi_nfc_rx_tvalid  => axis_nfc_rx.tvalid,
			m_axi_nfc_rx_tdata   => axis_nfc_rx.tdata,

	    		rxp                  => gtp_p_in, 
	    		rxn                  => gtp_n_in, 
	    		txp                  => gtp_p_out, 
	    		txn                  => gtp_n_out, 
	    		-- GT Reference Clock
	    		gt_refclk1_p         => gtp_ref_clk_p, 
	    		gt_refclk1_n         => gtp_ref_clk_n, 
	    		-- Error Detection In
	    		frame_err            => aurora_error.frame_err,
	    		hard_err             => aurora_error.hard_err,
	    		soft_err             => aurora_error.soft_err,
	    		channel_up           => aurora_error.channel_up,
	    		lane_up              => aurora_error.lane_up,
	    		-- System Interface
	    		user_clk_out         => , 
	    		reset                => aurora_reset.usr_reset, 
	    		gt_reset             => aurora_reset.gt_reset, 
	    		sys_reset_out        => aurora_reset.reset_out, 
	    		power_down           => , 
	    		loopback             => , 
	    		tx_lock              => , 
	    		init_clk_i	     => , 
	    		init_clk_out         => , 
	    		tx_resetdone_out     => , 
	    		rx_resetdone_out     => , 
	    		link_reset_out       => , 
	    		--DRP Ports
	    		--drpclk_in            => , 
	    		--drpaddr_in           => , 
	    		--drpdi_in             => , 
	    		--drpdo_out            => , 
	    		--drpen_in             => , 
	    		--drprdy_out           => , 
	    		--drpwe_in             => , 
	    		pll_not_locked_out   =>
		);
    end block Aurora;

end arch;
