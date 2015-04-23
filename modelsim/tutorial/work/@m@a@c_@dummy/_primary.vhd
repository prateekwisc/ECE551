library verilog;
use verilog.vl_types.all;
entity MAC_Dummy is
    port(
        X_0             : in     vl_logic_vector(15 downto 0);
        X_1             : in     vl_logic_vector(15 downto 0);
        X_2             : in     vl_logic_vector(15 downto 0);
        out_awaited     : in     vl_logic;
        out_ready       : out    vl_logic;
        Y               : out    vl_logic_vector(15 downto 0);
        Clk1            : in     vl_logic;
        b0              : in     vl_logic_vector(15 downto 0);
        b1              : in     vl_logic_vector(15 downto 0);
        b2              : in     vl_logic_vector(15 downto 0);
        a1              : in     vl_logic_vector(15 downto 0);
        a2              : in     vl_logic_vector(15 downto 0);
        Y_1             : in     vl_logic_vector(15 downto 0);
        Y_2             : in     vl_logic_vector(15 downto 0)
    );
end MAC_Dummy;
