library verilog;
use verilog.vl_types.all;
entity bit2_FA is
    port(
        y               : out    vl_logic_vector(1 downto 0);
        cout            : out    vl_logic;
        a               : in     vl_logic_vector(1 downto 0);
        b               : in     vl_logic_vector(1 downto 0);
        c               : in     vl_logic
    );
end bit2_FA;
