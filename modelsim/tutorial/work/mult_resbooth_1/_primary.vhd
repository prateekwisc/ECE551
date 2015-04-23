library verilog;
use verilog.vl_types.all;
entity mult_resbooth_1 is
    port(
        Y               : out    vl_logic_vector(19 downto 0);
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(15 downto 0)
    );
end mult_resbooth_1;
