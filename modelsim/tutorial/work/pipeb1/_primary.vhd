library verilog;
use verilog.vl_types.all;
entity pipeb1 is
    port(
        q3              : out    vl_logic_vector(7 downto 0);
        d               : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic
    );
end pipeb1;
