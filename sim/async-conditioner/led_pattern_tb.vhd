library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;


entity led_pattern_tb is
end entity led_pattern_tb;

architecture led_pattern_tb_arch of led_pattern_tb is	

	component led_pattern is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk : in std_ulogic;
		rst : in std_ulogic;
		push_button : in std_ulogic;
		switches : in std_ulogic_vector(3 downto 0);
		hps_led_control : in boolean;
		base_period : in unsigned(7 downto 0);
		led_reg : in std_ulogic_vector(7 downto 0);
		led : out std_ulogic_vector(7 downto 0)
	);
	end component led_pattern;

	signal clk_tb : std_ulogic := '0';
	signal rst_tb : std_ulogic := '0';
	signal push_button_tb : std_ulogic := '0';
	signal switches_tb : std_ulogic_vector(3 downto 0);
	signal hps_led_control_tb : boolean;
	signal base_period_tb : unsigned(7 downto 0);
	signal led_reg_tb : std_ulogic_vector(7 downto 0);
	signal led_tb : std_ulogic_vector(7 downto 0);

	begin

		dut : component led_pattern
		    port map (
		      clk   => clk_tb,
		      rst => rst_tb,
		      push_button  => push_button_tb,
		      switches => switches_tb,
		      hps_led_control => hps_led_control_tb,
		      base_period => base_period_tb,
		      led_reg => led_reg_tb,
		      led => led_tb
		 );

		base_period_tb <= "00111100";
		hps_led_control_tb <= true;
		led_reg_tb <= "00000000";
	
		clk_gen : process is
		  begin
		    clk_tb <= not clk_tb;
		    wait for CLK_PERIOD / 2;
		end process clk_gen;

		-- Create the input signal
		input_stim : process is
		begin
		
		  push_button_tb <= '0';
		  switches_tb <= "0001";
		  wait for CLK_PERIOD;
		
		  push_button_tb <= '1';
		  wait for CLK_PERIOD;
		
		  push_button_tb <= '0';
		  wait for 30 * CLK_PERIOD;
		
		  push_button_tb <= '0';
		  switches_tb <= "0010";
		  wait for 1 * CLK_PERIOD;

		  push_button_tb <= '1';
		  wait for CLK_PERIOD;

		  push_button_tb <= '0';
		  wait for 30 * CLK_PERIOD;

		  push_button_tb <= '0';
		  switches_tb <= "1000";
		  wait for 1 * CLK_PERIOD;

		  push_button_tb <= '1';
		  wait for CLK_PERIOD;

		  push_button_tb <= '0';
		  wait for 30 * CLK_PERIOD;

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


end architecture led_pattern_tb_arch;