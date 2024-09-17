library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;


entity async_conditioner_tb is
end entity async_conditioner_tb;

architecture async_conditioner_tb_arch of async_conditioner_tb is

	component async_conditioner is 
	port (
		clk : in std_ulogic;
		rst : in std_ulogic;
		async : in std_ulogic;
		sync : out std_ulogic
	);
	end component async_conditioner;

	signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '0';
	signal aysnc_tb : std_logic := '0';
	signal sync_tb : std_logic := '0';
	signal sync_expected : std_logic;

	begin

		dut : component async_conditioner
		    port map (
		      clk   => clk_tb,
		      rst => rst_tb,
		      async  => aysnc_tb,
		      sync => sync_tb
		 );
	
		clk_gen : process is
		  begin
		    clk_tb <= not clk_tb;
		    wait for CLK_PERIOD / 2;
		end process clk_gen;

		-- Create the async signal
		async_stim : process is
		begin
		
		  aysnc_tb <= '0';
		  wait for CLK_PERIOD;
		
		  aysnc_tb <= '1';
		  wait for 2 * CLK_PERIOD;
		
		  aysnc_tb <= '0';
		  wait for 10 * CLK_PERIOD;

		  aysnc_tb <= '1';
		  wait for 40 * CLK_PERIOD;

		  aysnc_tb <= '0';
		  wait for 10 * CLK_PERIOD;

		  aysnc_tb <= '0';
		
		  wait;
		
		end process async_stim;

		-- Create the expected sync output waveform
		expected_sync : process is
		begin
		
		  sync_expected <= '0';
		  wait for 4 * CLK_PERIOD;
		
		  sync_expected <= '1';
		  wait for CLK_PERIOD;
		
		  sync_expected <= '0';

		  wait;
		
		end process expected_sync;

		check_output : process is
		
		  variable failed : boolean := false;
		
		begin
		
		  for i in 0 to 9 loop
		
		    assert sync_expected = sync_tb
		      report "Error for clock cycle " & to_string(i) & ":" & LF & "sync = " & to_string(sync_tb) & " expected sync  = " & to_string(sync_expected)
		      severity warning;
		
		    if sync_expected /= sync_tb then
		      failed := true;
		    end if;
		
		    wait for CLK_PERIOD;
		
		  end loop;
	
		  if failed then
		    report "tests failed!"
		      severity failure;
		  else
		    report "all tests passed!";
		  end if;
		
		  std.env.finish;
		
		end process check_output;

		
end architecture;