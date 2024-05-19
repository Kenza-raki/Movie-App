--------------------------------------------------------------------------------
-- Copyright (c) 1995-2003 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 8.1i
--  \   \         Application : ISE
--  /   /         Filename : commp.vhw
-- /___/   /\     Timestamp : Sat May 18 12:39:20 2024
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: commp
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY commp IS
END commp;

ARCHITECTURE testbench_arch OF commp IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT comp
        PORT (
            A : In std_logic;
            B : In std_logic;
            equal : Out std_logic;
            greater : Out std_logic;
            less : Out std_logic
        );
    END COMPONENT;

    SIGNAL A : std_logic := '0';
    SIGNAL B : std_logic := '0';
    SIGNAL equal : std_logic := '0';
    SIGNAL greater : std_logic := '0';
    SIGNAL less : std_logic := '0';

    SHARED VARIABLE TX_ERROR : INTEGER := 0;
    SHARED VARIABLE TX_OUT : LINE;

    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 0 ns;

    BEGIN
        UUT : comp
        PORT MAP (
            A => A,
            B => B,
            equal => equal,
            greater => greater,
            less => less
        );

        PROCESS    -- clock process for A
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                A <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                A <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

        PROCESS
            PROCEDURE CHECK_equal(
                next_equal : std_logic;
                TX_TIME : INTEGER
            ) IS
                VARIABLE TX_STR : String(1 to 4096);
                VARIABLE TX_LOC : LINE;
                BEGIN
                IF (equal /= next_equal) THEN
                    STD.TEXTIO.write(TX_LOC, string'("Error at time="));
                    STD.TEXTIO.write(TX_LOC, TX_TIME);
                    STD.TEXTIO.write(TX_LOC, string'("ns equal="));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, equal);
                    STD.TEXTIO.write(TX_LOC, string'(", Expected = "));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, next_equal);
                    STD.TEXTIO.write(TX_LOC, string'(" "));
                    TX_STR(TX_LOC.all'range) := TX_LOC.all;
                    STD.TEXTIO.writeline(RESULTS, TX_LOC);
                    STD.TEXTIO.Deallocate(TX_LOC);
                    ASSERT (FALSE) REPORT TX_STR SEVERITY ERROR;
                    TX_ERROR := TX_ERROR + 1;
                END IF;
            END;
            PROCEDURE CHECK_greater(
                next_greater : std_logic;
                TX_TIME : INTEGER
            ) IS
                VARIABLE TX_STR : String(1 to 4096);
                VARIABLE TX_LOC : LINE;
                BEGIN
                IF (greater /= next_greater) THEN
                    STD.TEXTIO.write(TX_LOC, string'("Error at time="));
                    STD.TEXTIO.write(TX_LOC, TX_TIME);
                    STD.TEXTIO.write(TX_LOC, string'("ns greater="));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, greater);
                    STD.TEXTIO.write(TX_LOC, string'(", Expected = "));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, next_greater);
                    STD.TEXTIO.write(TX_LOC, string'(" "));
                    TX_STR(TX_LOC.all'range) := TX_LOC.all;
                    STD.TEXTIO.writeline(RESULTS, TX_LOC);
                    STD.TEXTIO.Deallocate(TX_LOC);
                    ASSERT (FALSE) REPORT TX_STR SEVERITY ERROR;
                    TX_ERROR := TX_ERROR + 1;
                END IF;
            END;
            PROCEDURE CHECK_less(
                next_less : std_logic;
                TX_TIME : INTEGER
            ) IS
                VARIABLE TX_STR : String(1 to 4096);
                VARIABLE TX_LOC : LINE;
                BEGIN
                IF (less /= next_less) THEN
                    STD.TEXTIO.write(TX_LOC, string'("Error at time="));
                    STD.TEXTIO.write(TX_LOC, TX_TIME);
                    STD.TEXTIO.write(TX_LOC, string'("ns less="));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, less);
                    STD.TEXTIO.write(TX_LOC, string'(", Expected = "));
                    IEEE.STD_LOGIC_TEXTIO.write(TX_LOC, next_less);
                    STD.TEXTIO.write(TX_LOC, string'(" "));
                    TX_STR(TX_LOC.all'range) := TX_LOC.all;
                    STD.TEXTIO.writeline(RESULTS, TX_LOC);
                    STD.TEXTIO.Deallocate(TX_LOC);
                    ASSERT (FALSE) REPORT TX_STR SEVERITY ERROR;
                    TX_ERROR := TX_ERROR + 1;
                END IF;
            END;
            BEGIN
                -- -------------  Current Time:  85ns
                WAIT FOR 85 ns;
                B <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  115ns
                WAIT FOR 30 ns;
                CHECK_greater('1', 115);
                CHECK_less('1', 115);
                -- -------------------------------------
                -- -------------  Current Time:  285ns
                WAIT FOR 170 ns;
                B <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  315ns
                WAIT FOR 30 ns;
                CHECK_equal('1', 315);
                CHECK_greater('0', 315);
                CHECK_less('0', 315);
                -- -------------------------------------
                -- -------------  Current Time:  485ns
                WAIT FOR 170 ns;
                B <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  515ns
                WAIT FOR 30 ns;
                CHECK_equal('0', 515);
                CHECK_greater('1', 515);
                -- -------------------------------------
                -- -------------  Current Time:  685ns
                WAIT FOR 170 ns;
                B <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  715ns
                WAIT FOR 30 ns;
                CHECK_greater('0', 715);
                -- -------------------------------------
                WAIT FOR 485 ns;

                IF (TX_ERROR = 0) THEN
                    STD.TEXTIO.write(TX_OUT, string'("No errors or warnings"));
                    STD.TEXTIO.writeline(RESULTS, TX_OUT);
                    ASSERT (FALSE) REPORT
                      "Simulation successful (not a failure).  No problems detected."
                      SEVERITY FAILURE;
                ELSE
                    STD.TEXTIO.write(TX_OUT, TX_ERROR);
                    STD.TEXTIO.write(TX_OUT,
                        string'(" errors found in simulation"));
                    STD.TEXTIO.writeline(RESULTS, TX_OUT);
                    ASSERT (FALSE) REPORT "Errors found during simulation"
                         SEVERITY FAILURE;
                END IF;
            END PROCESS;

    END testbench_arch;

