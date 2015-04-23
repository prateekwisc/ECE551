library verilog;
use verilog.vl_types.all;
entity CLU_4bit is
    port(
        C_out           : out    vl_logic_vector(3 downto 0);
        G               : in     vl_logic_vector(3 downto 0);
        P               : in     vl_logic_vector(3 downto 0);
        C_In            : in     vl_logic
    );
end CLU_4bit;
