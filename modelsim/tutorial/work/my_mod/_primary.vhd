library verilog;
use verilog.vl_types.all;
entity my_mod is
    port(
        count           : out    vl_logic_vector(7 downto 0);
        enable          : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end my_mod;
