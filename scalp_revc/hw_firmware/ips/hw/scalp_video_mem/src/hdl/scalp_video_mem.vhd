----------------------------------------------------------------------------------
--                                 _             _
--                                | |_  ___ _ __(_)__ _
--                                | ' \/ -_) '_ \ / _` |
--                                |_||_\___| .__/_\__,_|
--                                         |_|
--
----------------------------------------------------------------------------------
--
-- Company: hepia
-- Author: Joachim Schmidt <joachim.schmidt@hesge.ch>
--
-- Module Name: scalp_video_mem - arch
-- Target Device: hepia-cores.ch:scalp_node:part0:0.2 xc7z015clg485-2
-- Tool version: 2023.2
-- Description: Video memory (frame buffer) for the Swiss flag display.
--              Stores a 1-bit-per-pixel image (0 = background, 1 = cross) and
--              is pre-initialised at synthesis time with the Swiss flag pattern
--              for a 720x720 pixel resolution.
--              The write port allows run-time updates (e.g. from the processor)
--              while the read port is used by the HDMI pixel pipeline.
--
-- Last update: 2024-03-28
--
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library scalp_lib;
use scalp_lib.scalp_hdmi_pkg.all;

entity scalp_video_mem is

    generic (
        C_VGA_CONFIG : t_vga_config := C_VGA_DEFAULT_CONFIG);

    port (
        -- Write port (Swiss flag generator / processor)
        WrClkxCI  : in std_logic;
        WrEnxSI   : in std_logic;
        WrAddrxDI : in std_logic_vector(18 downto 0);
        WrDataxDI : in std_logic;
        -- Read port (HDMI pixel pipeline, VGA clock domain)
        RdClkxCI  : in std_logic;
        RdEnxSI   : in std_logic;
        RdAddrxDI : in std_logic_vector(18 downto 0);
        RdDataxDO : out std_logic);

end scalp_video_mem;

architecture arch of scalp_video_mem is

    ---------------------------------------------------------------------------
    -- Frame buffer dimensions (720 x 720 = 518 400 pixels)
    ---------------------------------------------------------------------------
    constant C_H_ACTIVE  : integer := C_VGA_720X720_60HZ_H_ACTIVE;
    constant C_V_ACTIVE  : integer := C_VGA_720X720_60HZ_V_ACTIVE;
    constant C_FRAME_SIZE : integer := C_H_ACTIVE * C_V_ACTIVE;

    ---------------------------------------------------------------------------
    -- Swiss-flag cross geometry (in pixels, relative to 720x720 canvas)
    --   Vertical bar  : columns [288, 432)  rows [144, 576)
    --   Horizontal bar: columns [144, 576)  rows [288, 432)
    ---------------------------------------------------------------------------
    constant C_V_BAR_H_START : integer := 288;
    constant C_V_BAR_H_END   : integer := 432;
    constant C_V_BAR_V_START : integer := 144;
    constant C_V_BAR_V_END   : integer := 576;
    constant C_H_BAR_H_START : integer := 144;
    constant C_H_BAR_H_END   : integer := 576;
    constant C_H_BAR_V_START : integer := 288;
    constant C_H_BAR_V_END   : integer := 432;

    ---------------------------------------------------------------------------
    -- Frame buffer type and pre-initialisation function
    ---------------------------------------------------------------------------
    type t_frame_buffer is array(0 to C_FRAME_SIZE - 1) of std_logic_vector(0 downto 0);

    -- Compute the Swiss flag bit-mask at elaboration time so that Vivado can
    -- embed the pattern as BRAM INIT data (no run-time initialisation needed).
    function init_swiss_flag_buffer return t_frame_buffer is
        variable buf : t_frame_buffer := (others => "0");
    begin
        for v in 0 to C_V_ACTIVE - 1 loop
            for h in 0 to C_H_ACTIVE - 1 loop
                if ((h >= C_V_BAR_H_START and h < C_V_BAR_H_END) and
                    (v >= C_V_BAR_V_START and v < C_V_BAR_V_END)) or
                   ((h >= C_H_BAR_H_START and h < C_H_BAR_H_END) and
                    (v >= C_H_BAR_V_START and v < C_H_BAR_V_END)) then
                    buf(v * C_H_ACTIVE + h) := "1";  -- pixel belongs to the cross
                end if;
            end loop;
        end loop;
        return buf;
    end function init_swiss_flag_buffer;

    ---------------------------------------------------------------------------
    -- Frame buffer signal – initial content is the Swiss flag pattern.
    -- Vivado infers this as a collection of Block RAMs.
    ---------------------------------------------------------------------------
    signal FrameBufferxD : t_frame_buffer := init_swiss_flag_buffer;

    -- Registered read data (1 VGA-clock cycle of BRAM read latency)
    signal RdDataxD : std_logic_vector(0 downto 0) := "0";

begin

    ---------------------------------------------------------------------------
    -- Write port (synchronous, write-clock domain)
    ---------------------------------------------------------------------------
    WritePortxP : process (WrClkxCI) is
    begin
        if rising_edge(WrClkxCI) then
            if WrEnxSI = '1' then
                FrameBufferxD(to_integer(unsigned(WrAddrxDI))) <= (0 => WrDataxDI);
            end if;
        end if;
    end process WritePortxP;

    ---------------------------------------------------------------------------
    -- Read port (synchronous, VGA-clock domain)
    -- The registered output provides 1 clock cycle of read latency, which
    -- matches the latency of the SwissFlagxP process it replaces.
    ---------------------------------------------------------------------------
    ReadPortxP : process (RdClkxCI) is
    begin
        if rising_edge(RdClkxCI) then
            if RdEnxSI = '1' then
                RdDataxD <= FrameBufferxD(to_integer(unsigned(RdAddrxDI)));
            end if;
        end if;
    end process ReadPortxP;

    RdDataxDO <= RdDataxD(0);

end arch;
