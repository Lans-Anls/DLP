library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity esteira_controlador is
    generic (
        CAPACIDADE : integer := 30;      -- Capacidade C da bandeja
        LIMIAR     : integer := 20;      -- Limiar L de alerta
        H_MAX      : integer := 5000000  -- Ciclos para semiciclo de 5 Hz (50MHz / 10Hz = 5.000.000)
    );
    port (
        clk_50       : in  std_logic;
        rst          : in  std_logic;                            -- Reset assíncrono (ativo em 1)
        sentido      : in  std_logic;                            -- 0: colocar peças, 1: retirar peças
        pausa        : in  std_logic;                            -- 1: congela N, P, erro e reseta o divisor
        modo         : in  std_logic_vector(1 downto 0);         -- 00: N, 01: C-N, 10: P, 11: C
        sinal_div    : out std_logic;                            -- Onda quadrada de 5 Hz (50% duty cycle)
        pulso_avanco : out std_logic;                            -- Pulso de 1 ciclo de clk_50 na subida
        cheio        : out std_logic;                            -- N = C
        vazio        : out std_logic;                            -- N = 0
        alerta       : out std_logic;                            -- N >= L
        erro         : out std_logic;                            -- Registrador de erro travado em 1
        hex0         : out std_logic_vector(6 downto 0);         -- Display 7 seg Unidade (Ativo em 0)
        hex1         : out std_logic_vector(6 downto 0)          -- Display 7 seg Dezena (Ativo em 0)
    );
end entity esteira_controlador;

architecture Behavioral of esteira_controlador is
    signal N_reg            : integer range 0 to CAPACIDADE := 0;
    signal P_reg            : integer range 0 to CAPACIDADE := 0;
    signal pulso_avanco_int : std_logic;
begin
    divisor_inst : entity work.freq_div
        generic map (
            H_MAX => H_MAX
        )
        port map (
            clk_50       => clk_50,
            rst          => rst,
            pausa        => pausa,
            sinal_div    => sinal_div,
            pulso_avanco => pulso_avanco_int
            );

    nucleo_inst : entity work.nucleo_esteira
        generic map (
            CAPACIDADE => CAPACIDADE,
            LIMIAR     => LIMIAR
        )
        port map (
            clk_50       => clk_50,
            rst          => rst,
            sentido      => sentido,
            pausa        => pausa,
            pulso_avanco => pulso_avanco_int,
            N_atual      => N_reg,
            pico         => P_reg,
            cheio        => cheio,
            vazio        => vazio,
            alerta       => alerta,
            erro         => erro
        );

    display_inst : entity work.display_esteira
        generic map (
            CAPACIDADE => CAPACIDADE
        )
        port map (
            N_atual => N_reg,
            pico    => P_reg,
            modo    => modo,
            hex0    => hex0,
            hex1    => hex1
        );

    pulso_avanco <= pulso_avanco_int;

end architecture Behavioral;
