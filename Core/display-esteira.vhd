library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_esteira is
    generic (
        CAPACIDADE : integer := 30
    );
    port (
        N_atual : in  integer range 0 to CAPACIDADE;
        pico    : in  integer range 0 to CAPACIDADE;
        modo    : in  std_logic_vector(1 downto 0);
        hex0    : out std_logic_vector(6 downto 0);
        hex1    : out std_logic_vector(6 downto 0)
    );
end entity display_esteira;

architecture Behavioral of display_esteira is
    signal valor_exibido : integer range 0 to 99;
    signal dezena        : integer range 0 to 9;
    signal unidade       : integer range 0 to 9;

    function decod_7seg(digito : integer) return std_logic_vector is
    begin
        case digito is
            when 0 => return "1000000";
            when 1 => return "1111001";
            when 2 => return "0100100";
            when 3 => return "0110000";
            when 4 => return "0011001";
            when 5 => return "0010010";
            when 6 => return "0000010";
            when 7 => return "1111000";
            when 8 => return "0000000";
            when 9 => return "0010000";
            when others => return "1111111";
        end case;
    end function;
begin
    valor_exibido <= N_atual                when modo = "00" else
                     (CAPACIDADE - N_atual) when modo = "01" else
                     pico                    when modo = "10" else
                     CAPACIDADE;

    dezena  <= valor_exibido / 10;
    unidade <= valor_exibido rem 10;
    hex1    <= decod_7seg(dezena);
    hex0    <= decod_7seg(unidade);
end architecture Behavioral;