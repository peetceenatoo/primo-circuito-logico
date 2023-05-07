----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2023 09:21:39
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2023 22:40:17
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project_reti_logiche is
         port (
             i_clk   : in std_logic;
             i_rst   : in std_logic;
             i_start : in std_logic;
             i_w     : in std_logic;
             o_z0    : out std_logic_vector(7 downto 0);
             o_z1    : out std_logic_vector(7 downto 0);
             o_z2    : out std_logic_vector(7 downto 0);
             o_z3    : out std_logic_vector(7 downto 0);
             o_done  : out std_logic;
             o_mem_addr : out std_logic_vector(15 downto 0);
             i_mem_data : in std_logic_vector(7 downto 0);
             o_mem_we   : out std_logic;
             o_mem_en   : out std_logic
         );
     end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

component DATAPATH is
--  Port ( );
    port (
         i_clk   : in std_logic;
         i_rst   : in std_logic;
         i_w     : in std_logic;
         o_z0    : out std_logic_vector(7 downto 0);
         o_z1    : out std_logic_vector(7 downto 0);
         o_z2    : out std_logic_vector(7 downto 0);
         o_z3    : out std_logic_vector(7 downto 0);
         o_done  : out std_logic;
         o_mem_addr : out std_logic_vector(15 downto 0);
         i_mem_data : in std_logic_vector(7 downto 0);
         en_in_0    : in std_logic;
         en_in_1    : in std_logic;
         mem_addr_rst : in std_logic;
         done_signal : in std_logic
    );
end component DATAPATH; 

type S is (S0,S1,S2,S3);--,S4,S5);
signal cur_state, next_state : S;

signal en_in_0 : STD_LOGIC;
signal en_in_1 : STD_LOGIC;
signal mem_en : STD_LOGIC;
signal mem_addr_Rst : std_logic;

signal pre_done : std_logic;

begin

    
    DATAPATH0 : DATAPATH port map(
        i_clk,
        i_rst,
        i_w,
        o_z0,
        o_z1,
        o_z2,
        o_z3,
        o_done,
        o_mem_addr,
        i_mem_data,
        en_in_0,
        en_in_1,
        mem_addr_rst,
        pre_done
    );
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= S0;
        elsif i_clk'event and i_clk = '1' then
            cur_state <= next_state;
        end if;
    end process;
    
    process(cur_state, i_start) --contorlla lista di sensitivit  con clk e basta??
    begin
        next_state <= cur_state;
        case cur_state is
            when S0 =>
                if i_start = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 =>
                if i_start = '0' then
                    next_state <= S3;
                end if;
            when S3 =>
                    next_state <= S0;
        end case;
    end process;
    
    process(cur_state)
    begin
        en_in_0 <= '0';
        en_in_1 <= '0';
        o_mem_en <= '0';
        mem_en <= '0';
        o_mem_we <= '0';
        mem_addr_rst <= '0';
        pre_done <= '0';
        
        
        case cur_state is
            when S0 =>
                en_in_0 <= '1';
                mem_addr_rst <= '1';
                
            when S1 =>
                en_in_0 <= '1';
            when S2 =>
                en_in_1 <= '1';
                o_mem_en <= '1';
                mem_en <= '1';
            when S3 =>
                pre_done <= '1';
        end case;
    end process;
    
end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2023 22:35:19
-- Design Name: 
-- Module Name: DATAPATH - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity DATAPATH is
--  Port ( );
    port (
         i_clk   : in std_logic;
         i_rst   : in std_logic;
         i_w     : in std_logic;
         o_z0    : out std_logic_vector(7 downto 0);
         o_z1    : out std_logic_vector(7 downto 0);
         o_z2    : out std_logic_vector(7 downto 0);
         o_z3    : out std_logic_vector(7 downto 0);
         o_done  : out std_logic;
         o_mem_addr : out std_logic_vector(15 downto 0);
         i_mem_data : in std_logic_vector(7 downto 0);
         en_in_0 : in STD_LOGIC;
         en_in_1 : in STD_LOGIC;
         mem_addr_rst : in std_logic;
         done_signal : in std_logic
    );
end DATAPATH;

architecture Behavioral of DATAPATH is

component register_2bit is
    port(
        clk    : in  std_logic;
        reset  : in  std_logic;
        enable : in  std_logic;
        input  : in  std_logic;
        q      : out std_logic_vector(1 downto 0)
    );
end component register_2bit;

component parallel_register_8bit is
port (
    clk: in std_logic;
    reset: in std_logic;
    num_in: in std_logic_vector(7 downto 0);
    num_out: out std_logic_vector(7 downto 0);
    enable: in std_logic
);
end component parallel_register_8bit;

component register_16bit is
    port(
        clk    : in  std_logic;
        reset  : in  std_logic;
        enable : in  std_logic;
        input  : in  std_logic;
        forced_rst: in std_logic;
        q      : out std_logic_vector(15 downto 0)        
    );
end component register_16bit;

component register_1bit is
--  Port ( );
    port (
        clk: in std_logic;
        reset: in std_logic;
        bit_in: in std_logic;
        bit_out: out std_logic
    );
end component register_1bit;

signal output_address : std_logic_vector(1 downto 0);
signal memory_address : std_logic_vector(15 downto 0);

signal out_reg_ritardo1 : std_logic := '0';

signal output0 : std_logic_vector(7 downto 0);
signal output1 : std_logic_vector(7 downto 0);
signal output2 : std_logic_vector(7 downto 0);
signal output3 : std_logic_vector(7 downto 0);

signal en_out_0 : std_logic;
signal en_out_1 : std_logic;
signal en_out_2 : std_logic;
signal en_out_3 : std_logic;


begin

    o_done <= out_reg_ritardo1;
    
    en_out_0 <= not(output_address(1)) and  not(output_address(0)) and done_signal;
    en_out_1 <= not(output_address(1)) and  output_address(0) and done_signal;
    en_out_2 <= output_address(1) and  not(output_address(0)) and done_signal;
    en_out_3 <= output_address(1) and  output_address(0) and done_signal;

     
    o_z0 <= output0 when out_reg_ritardo1 = '1' else "00000000";
    o_z1 <= output1 when out_reg_ritardo1 = '1' else "00000000";
    o_z2 <= output2 when out_reg_ritardo1 = '1' else "00000000";
    o_z3 <= output3 when out_reg_ritardo1 = '1' else "00000000";
    o_mem_addr <= memory_address;
    
    
     reg_output_address: register_2bit port map(
        i_clk,
        i_rst,
        en_in_0,
        i_w,
        output_address
    );
    
    reg_memory_address: register_16bit port map(
        i_clk,
        i_rst,
        en_in_1,
        i_w,
        mem_addr_rst,
        memory_address
    );
    
    reg_output_0 : parallel_register_8bit port map(
        i_clk,
        i_rst,
        i_mem_data,
        output0,
        en_out_0
    );
    
    reg_output_1 : parallel_register_8bit port map(
        i_clk,
        i_rst,
        i_mem_data,
        output1,
        en_out_1
    );
    
    reg_output_2 : parallel_register_8bit port map(
        i_clk,
        i_rst,
        i_mem_data,
        output2,
        en_out_2
    );
    
    reg_output_3 : parallel_register_8bit port map(
        i_clk,
        i_rst,
        i_mem_data,
        output3,
        en_out_3
    );
    
    reg_ritardo_1 : register_1bit port map(
        i_clk,
        i_rst,
        done_signal,
        out_reg_ritardo1
    );
    
    
    
    
    
end Behavioral;

library ieee;
use ieee.std_logic_1164.all;

entity register_2bit is
    port(
        clk    : in  std_logic;
        reset  : in  std_logic;
        enable : in  std_logic;
        input  : in  std_logic;
        q      : out std_logic_vector(1 downto 0)
    );
end register_2bit;

architecture behavioral of register_2bit is
    signal d1, d2 : std_logic;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            d1 <= '0';
            d2 <= '0';
            
        elsif rising_edge(clk) then
            if enable = '1' then
                d1 <= input;
                d2 <= d1;
                
            end if;
        end if;
    end process;
    q <= d2 & d1;
   
end behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_16bit is
    port(
        clk    : in  std_logic;
        reset  : in  std_logic;
        enable : in  std_logic;
        input  : in  std_logic;
        forced_rst: in std_logic;
        q      : out std_logic_vector(15 downto 0)
    );
end register_16bit;

architecture behavioral of register_16bit is
    signal data : std_logic_vector(15 downto 0);
    
begin


    process(clk, reset, forced_rst)
    begin

        if reset = '1' or forced_rst='1' then
            data <= (others => '0');
            
        elsif rising_edge(clk) then
            if enable = '1' then
                data <= data(14 downto 0) & input;
            end if;
        end if;
    end process;
    q <= data;
   
end behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity parallel_register_8bit is
--  Port ( );
port (
    clk: in std_logic;
    reset: in std_logic;
    num_in: in std_logic_vector(7 downto 0);
    num_out: out std_logic_vector(7 downto 0);
    enable: in std_logic
  );

end parallel_register_8bit;

architecture Behavioral of parallel_register_8bit is

signal data_reg: std_logic_vector(7 downto 0);

begin
        process(clk, reset)
            begin
                if reset = '1' then
                    data_reg <= (others => '0');
                elsif rising_edge(clk) then
                    if enable = '1' then
                        data_reg <= num_in;
                    end if;
                end if;
        end process;
        
        num_out <= data_reg;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_1bit is
--  Port ( );
    port (
        clk: in std_logic;
        reset: in std_logic;
        bit_in: in std_logic;
        bit_out: out std_logic
    );
end register_1bit;

architecture Behavioral of register_1bit is

signal reg : std_logic := '0';

begin
    process(clk, reset)
    begin
        if reset = '1' then
            reg <= '0';
        elsif rising_edge(clk) then
            reg <= bit_in;
        end if;
    end process;
    
    bit_out <= reg;


end Behavioral;
