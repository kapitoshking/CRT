library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.R_code_64_bit_CRT_pkg.ALL;

entity rns_crt is
    Generic (constant proj : natural);
    Port (input_rns : in set_mod_type;
          output_crt : out unsigned(k*mod_bc-1 downto 0));
end rns_crt;

architecture Behavioral of rns_crt is

    signal b_mul_mod : basis_type;
    
    Component const_mul_mod
        Generic (proj : natural;
                 num_mod : natural);
        Port (X : in unsigned(mod_bc-1 downto 0);
              X_mod_p : out unsigned(k*mod_bc-1 downto 0));
    end component;
    
    Component add_mod_tree
        Generic (proj : natural);
        Port (input : in basis_type;
              output : out unsigned(k*mod_bc-1 downto 0));
    end component;
       
begin

    b_mul : for i in 0 to k-1 generate
    begin
        b_mul_const_mod : const_mul_mod 
            Generic map (proj => proj,
                         num_mod => i)
            Port map (X => input_rns(i),
                      X_mod_p => b_mul_mod(i));
    end generate b_mul;
    
    tree : add_mod_tree
        Generic map (proj => proj)
        Port map (input => b_mul_mod,
                  output => output_crt);

end Behavioral;