library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;


entity one_pulse_tb is
end entity one_pulse_tb;

architecture one_pulse_tb_arch of one_pulse_tb is	

	component one_pulse is 
	   port (
		clk : in std_ulogic;
		rst : in std_ulogic;
		input : in std_ulogic;
		pulse : out std_ulogic
		);
	end component one_pulse;

	signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '0';
	signal input_tb : std_logic := '0';
	signal pulse_tb : std_logic := '0';
	signal pulse_tb_expected : std_logic;

	begin

		dut : component one_pulse
		    port map (
		      clk   => clk_tb,
		      rst => rst_tb,
		      input  => input_tb,
		      pulse => pulse_tb
		 );
	
		clk_gen : process is
		  begin
		    clk_tb <= not clk_tb;
		    wait for CLK_PERIOD / 2;
		end process clk_gen;

		-- Create the input signal
		input_stim : process is
		begin
		
		  input_tb <= '0';
		  wait for CLK_PERIOD;
		
		  input_tb <= '1';
		  wait for 4 * CLK_PERIOD;
		
		  input_tb <= '0';
		  wait for 3 * CLK_PERIOD;
		
		  input_tb <= '1';
		  wait for 1 * CLK_PERIOD;

		  input_tb <= '0';
		
		  wait;
		
		end process input_stim;

		-- Create the expected pulse output waveform
		expected_pulse : process is
		begin
		
		  pulse_tb_expected <= '0';
		  wait for 2 * CLK_PERIOD;
		
		  pulse_tb_expected <= '1';
		  wait for CLK_PERIOD;
		
		  pulse_tb_expected <= '0';
		  wait for 7 * CLK_PERIOD;
		
		  pulse_tb_expected <= '1';
		  wait for  CLK_PERIOD;
		
		  pulse_tb_expected <= '0';
		
		  wait for 2 * CLK_PERIOD;
		
		  wait;
		
		end process expected_pulse;

		
		check_output : process is
		
		  variable failed : boolean := false;
		
		begin
		
		  for i in 0 to 9 loop
		
		    assert pulse_tb_expected = pulse_tb
		      report "Error for clock cycle " & to_string(i) & ":" & LF & "pulse = " & to_string(pulse_tb) & " expected pulse  = " & to_string(pulse_tb_expected)
		      severity warning;
		
		    if pulse_tb_expected /= pulse_tb then
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