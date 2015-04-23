library verilog;
use verilog.vl_types.all;
entity MAC is
    port(
        x0              : in     vl_logic_vector(15 downto 0);
        x1              : in     vl_logic_vector(15 downto 0);
        x2              : in     vl_logic_vector(15 downto 0);
        out_awaited     : in     vl_logic;
        out_ready       : out    vl_logic;
        calc_Y          : out    vl_logic_vector(15 downto 0);
        Clk1            : in     vl_logic;
        b0              : in     vl_logic_vector(15 downto 0);
        b1              : in     vl_logic_vector(15 downto 0);
        b2              : in     vl_logic_vector(15 downto 0);
        a1              : in     vl_logic_vector(15 downto 0);
        a2              : in     vl_logic_vector(15 downto 0);
        y1              : in     vl_logic_vector(15 downto 0);
        y2              : in     vl_logic_vector(15 downto 0)
    );
end MAC;
