library verilog;
use verilog.vl_types.all;
entity CLA_4bit is
    port(
        Sum             : out    vl_logic_vector(3 downto 0);
        C_out           : out    vl_logic_vector(3 downto 0);
        P               : in     vl_logic_vector(3 downto 0);
        G               : in     vl_logic_vector(3 downto 0);
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        C_In            : in     vl_logic
    );
end CLA_4bit;
