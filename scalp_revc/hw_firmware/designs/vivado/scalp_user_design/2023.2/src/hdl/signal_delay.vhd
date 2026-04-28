library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity signal_delay is

	generic (
		delay: natural
	);
	port (
		clk: in std_logic;
		signal_in : in std_logic;
		signal_out : out std_logic
	);

end entity;

architecture shift_reg_arch of signal_delay is
    signal pipe : std_logic_vector(delay - 1 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Shift the input into the first bit, and shift everything else down
            pipe <= pipe(pipe'high - 1 downto 0) & signal_in;
        end if;
    end process;

    -- The output is the very last bit of the pipe
    signal_out <= pipe(delay - 1);
end architecture;
