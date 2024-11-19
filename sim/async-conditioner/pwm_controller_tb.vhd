library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;


entity pwm_controller_tb is
end entity pwm_controller_tb;

architecture pwm_controller_tb_arch of pwm_controller_tb is	

	component pwm_controller is
	generic (
		CLK_PERIOD : time := 20 ns
	);
	port (
		clk          : in  std_logic;                    
        	rst          : in  std_logic;                    
        	period       : in  unsigned(24 - 1 downto 0);  
        	duty_cycle   : in  std_logic_vector(18 - 1 downto 0);  
        	output       : out std_logic
	);
	end component pwm_controller;

	signal clk_tb : std_ulogic := '0';
	signal rst_tb : std_ulogic := '0';
	signal period_tb : unsigned(24 - 1 downto 0); 
	signal duty_cycle_tb : std_logic_vector(18 - 1 downto 0);  
	signal output_tb : std_logic;

	begin

		dut : component pwm_controller
		    port map (
		      clk   => clk_tb,
		      rst => rst_tb,
		      period  => period_tb,
		      duty_cycle => duty_cycle_tb,
		      output => output_tb
		 );

		period_tb <= to_unsigned(50000, 24);
		duty_cycle_tb <= std_logic_vector(to_unsigned(65536, 18));
	
		clk_gen : process is
		  begin
		    clk_tb <= not clk_tb;
		    wait for CLK_PERIOD / 2;
		end process clk_gen;

		-- Create the input signal
		input_stim : process is
		begin
		
--		  push_button_tb <= '0';
--		  switches_tb <= "0001";
--		  wait for CLK_PERIOD;
--		
--		  push_button_tb <= '1';
--		  wait for CLK_PERIOD;
--		
--		  push_button_tb <= '0';
--		  wait for 30 * CLK_PERIOD;
--		
--		  push_button_tb <= '0';
--		  switches_tb <= "0010";
--		  wait for 1 * CLK_PERIOD;
--
--		  push_button_tb <= '1';
--		  wait for CLK_PERIOD;
--
--		  push_button_tb <= '0';
--		  wait for 30 * CLK_PERIOD;
--
--		  push_button_tb <= '0';
--		  switches_tb <= "1000";
--		  wait for 1 * CLK_PERIOD;
--
--		  push_button_tb <= '1';
--		  wait for CLK_PERIOD;
--
--		  push_button_tb <= '0';
--		  wait for 30 * CLK_PERIOD;

--		  input_tb <= '0';
		
		  wait;
		
		end process input_stim;

--		-- Create the expected pulse output waveform
--		expected_pulse : process is
--		begin
--		
--		  pulse_tb_expected <= '0';
--		  wait for 2 * CLK_PERIOD;
--		
--		  pulse_tb_expected <= '1';
--		  wait for CLK_PERIOD;
--		
--		  pulse_tb_expected <= '0';
--		  wait for 7 * CLK_PERIOD;
--		
--		  pulse_tb_expected <= '1';
--		  wait for  CLK_PERIOD;
--		
--		  pulse_tb_expected <= '0';
--		
--		  wait for 2 * CLK_PERIOD;
--		
--		  wait;
--		
--		end process expected_pulse;

--		check_output : process is
--		
--		  variable failed : boolean := false;
--		
--		begin
--		
--		  for i in 0 to 9 loop
--		
--		    assert pulse_tb_expected = pulse_tb
--		      report "Error for clock cycle " & to_string(i) & ":" & LF & "pulse = " & to_string(pulse_tb) & " expected pulse  = " & to_string(pulse_tb_expected)
--		      severity warning;
--		
--		    if pulse_tb_expected /= pulse_tb then
--		      failed := true;
--		    end if;
--		
--		    wait for CLK_PERIOD;
--		
--		  end loop;
--	
--		  if failed then
--		    report "tests failed!"
--		      severity failure;
--		  else
--		    report "all tests passed!";
--		  end if;
--		
--		  std.env.finish;
--		
--		end process check_output;


end architecture pwm_controller_tb_arch;