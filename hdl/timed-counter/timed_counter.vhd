library ieee;
use ieee.std_logic_1164.all;


entity timed_counter is
	generic (
		clk_period : time;
		count_time : time
	);
	port (
		clk : in std_ulogic;
		enable : in boolean;
		done : out boolean
	);
end entity timed_counter;


architecture timed_counter_arch of timed_counter is

	constant COUNTER_LIMIT : integer := count_time/clk_period;
	signal counter : integer range 0 to 65535 := 0;

	begin

		counter_proc : process (clk, enable) is
	
		   begin

		      if(rising_edge(clk)) then

			      if (counter = COUNTER_LIMIT) then
				counter <= 0;
				done <= true;

			      else

				done <= false;

				if (enable = true) then
				   counter <= counter + 1;
				else
				   counter <= 0;
			        end if;

			      end if;
		      end if;

		end process counter_proc;
	   

end architecture;