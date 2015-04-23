library verilog;
use verilog.vl_types.all;
entity fulladder_2bit_parcase is
    port(
        s               : out    vl_logic_vector(1 downto 0);
        cout            : out    vl_logic;
        a               : in     vl_logic_vector(1 downto 0);
        b               : in     vl_logic_vector(1 downto 0);
        cin             : in     vl_logic
    );
end fulladder_2bit_parcase;
