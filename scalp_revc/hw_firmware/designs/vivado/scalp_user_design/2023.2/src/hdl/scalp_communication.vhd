library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;



entity scalp_communication is

	port (
		reset: in std_logic;
		clk: in std_logic;

		gtp_p_in: in std_logic; 
		gtp_n_in: in std_logic;
		gtp_p_out: out std_logic;
		gtp_n_out: out std_logic;
		gtp_ref_clk_p: in std_logic;
		gtp_ref_clk_n: in std_logic
	);

end entity;


architecture arch of scalp_communication is
	component signal_delay is
		generic (
			delay : natural
		);
		port (
			clk        : in  std_logic;
			signal_in  : in  std_logic;
			signal_out : out std_logic
		);
	end component;

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

	type aurora_clk_t is record
		init_clk_i : std_logic;
		usr_clk_out : std_logic;
	end record;

	signal axis_tx: axis_tx_t;
	signal axis_rx: axis_rx_t;

	signal axis_nfc_tx: axis_nfc_tx_t;
	signal axis_nfc_rx: axis_nfc_rx_t;

	signal aurora_clk: aurora_clk_t;
	signal aurora_error: aurora_error_t;
	signal aurora_reset: aurora_reset_t;

	signal tx_lock : std_logic;
	signal tx_resetdone_out : std_logic; 
	signal rx_resetdone_out : std_logic; 
	signal link_reset_out : std_logic; 
	signal pll_not_locked_out: std_logic; 

	-- Delayed versions of the master reset
	signal reset_delayed_256  : std_logic;

	attribute mark_debug       : string;
	attribute keep             : string;

	attribute mark_debug of axis_tx  : signal is "true";
	attribute keep of axis_tx        : signal is "true";

	attribute mark_debug of axis_rx  : signal is "true";
	attribute keep of axis_rx        : signal is "true";

	attribute mark_debug of aurora_error  : signal is "true";
	attribute keep of aurora_error        : signal is "true";

	attribute mark_debug of aurora_reset  : signal is "true";
	attribute keep of aurora_reset        : signal is "true";


begin
    -- 32bit mode
    axis_tx.tkeep <= (others => '1');
    axis_rx.tkeep <= (others => '1');
    aurora_clk.init_clk_i <= clk;

    reset_delay : signal_delay
    generic map (
		delay => 256
    )
    port map (
		clk        => clk,
		signal_in  => reset,
		signal_out => reset_delayed_256
	);


    -- debug
    axis_tx.tready <= '1';
    axis_tx.tlast <= '1';

    aurora_reset.usr_reset <= reset_delayed_256;
    aurora_reset.gt_reset <= reset;

    Aurora : block is
    begin
	    aurora_support: entity work.aurora_8b10b_0_support
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

	    		rxp(0)                  => gtp_p_in,
	    		rxn(0)                  => gtp_n_in,
	    		txp(0)                  => gtp_p_out,
	    		txn(0)                  => gtp_n_out,
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
	    		reset                => aurora_reset.usr_reset, 
	    		gt_reset             => aurora_reset.gt_reset, 
	    		sys_reset_out        => aurora_reset.reset_out, 

	    		loopback             => (others => '0'),
	    		tx_lock              => tx_lock,
			power_down           => '0',

			user_clk_out         => aurora_clk.usr_clk_out, 
			init_clk_i	     => aurora_clk.init_clk_i,
			init_clk_out         => open,

	    		tx_resetdone_out     => tx_resetdone_out,
	    		rx_resetdone_out     => rx_resetdone_out,  
	    		link_reset_out       => link_reset_out, 
	    		pll_not_locked_out   => pll_not_locked_out,

    			drpclk_in              => '0',
    			drpaddr_in             => (others =>'0'),
    			drpdi_in               => (others =>'0'),
    			drpdo_out              => open,
    			drpen_in               => '0',
    			drprdy_out             => open,
    			drpwe_in               => '0'
		);
    end block Aurora;

end arch;
