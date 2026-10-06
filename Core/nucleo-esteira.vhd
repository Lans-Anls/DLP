library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nucleo_esteira is
    generic (
        CAPACIDADE : integer := 30;
        LIMIAR     : integer := 20
    );
    port (
        clk_50       : in  std_logic;
        rst          : in  std_logic;
        sentido      : in  std_logic;
        pausa        : in  std_logic;
        pulso_avanco : in  std_logic;
        N_atual      : out integer range 0 to CAPACIDADE;
        pico         : out integer range 0 to CAPACIDADE;
        cheio        : out std_logic;
        vazio        : out std_logic;
        alerta       : out std_logic;
        erro         : out std_logic
    );
end entity nucleo_esteira;

architecture Behavioral of nucleo_esteira is
    signal N_reg    : integer range 0 to CAPACIDADE := 0;
    signal P_reg    : integer range 0 to CAPACIDADE := 0;
    signal erro_reg : std_logic := '0';
begin
    process(clk_50, rst)
    begin
        if rst = '1' then
            N_reg    <= 0;
            P_reg    <= 0;
            erro_reg <= '0';
        elsif rising_edge(clk_50) then
            if pausa = '0' and pulso_avanco = '1' then
                if sentido = '0' then
                    if N_reg < CAPACIDADE then
                        N_reg <= N_reg + 1;
                        if (N_reg + 1) > P_reg then
                            P_reg <= N_reg + 1;
                        end if;
                    else
                        erro_reg <= '1';
                    end if;
                elsif N_reg > 0 then
                    N_reg <= N_reg - 1;
                else
                    erro_reg <= '1';
                end if;
            end if;
        end if;
    end process;

    N_atual <= N_reg;
    pico    <= P_reg;
    cheio   <= '1' when N_reg = CAPACIDADE else '0';
    vazio   <= '1' when N_reg = 0 else '0';
    alerta  <= '1' when N_reg >= LIMIAR else '0';
    erro    <= erro_reg;
end architecture Behavioral;