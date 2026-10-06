library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity freq_div is
    generic (
        H_MAX : integer := 5000000
    );
    port (
        clk_50       : in  std_logic;
        rst          : in  std_logic;
        pausa        : in  std_logic;
        sinal_div    : out std_logic;
        pulso_avanco : out std_logic
    );
end entity freq_div;

architecture Behavioral of freq_div is
    signal cnt_div       : integer range 0 to H_MAX - 1 := 0;
    signal sinal_div_reg : std_logic := '0';
    signal pulso_reg     : std_logic := '0';


    ----------------------------------------------------------------------------
    -- 1. DIVISOR DE FREQUÊNCIA E GERADOR DE PULSO DE AVANÇO
    ----------------------------------------------------------------------------
process(clk_50, rst)
    begin
        if rst = '1' then
            cnt_div       <= 0;
            sinal_div_reg <= '0';
            pulso_reg     <= '0';
        elsif rising_edge(clk_50) then
            if pausa = '1' then
                -- Pausa reinicia a fase do divisor e descarta avanços pendentes
                cnt_div       <= 0;
                sinal_div_reg <= '0';
                pulso_reg     <= '0';
            else
                if cnt_div = H_MAX - 1 then
                    cnt_div       <= 0;
                    sinal_div_reg <= not sinal_div_reg;

                    -- Gera o pulso de 1 ciclo apenas na borda de SUBIDA do sinal_div
                    if sinal_div_reg = '0' then
                        pulso_reg <= '1';
                    else
                        pulso_reg <= '0';
                    end if;
                else
                    cnt_div   <= cnt_div + 1;
                    pulso_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    sinal_div    <= sinal_div_reg;
    pulso_avanco <= pulso_reg;

    end architecture Behavioral;