library verilog;
use verilog.vl_types.all;
entity multiply is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        c               : in     vl_logic_vector(15 downto 0);
        d               : in     vl_logic_vector(15 downto 0);
        e               : out    vl_logic_vector(15 downto 0);
        f               : out    vl_logic_vector(15 downto 0);
        prod            : out    vl_logic_vector(15 downto 0)
    );
end multiply;
