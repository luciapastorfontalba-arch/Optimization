

clc
clear all

Op = [1, 0];  % Maximize

f = [2.0, 4.0];

A = [1.0, 2.0;
     1.0, 1.0];

b = [8.0; 6.0];

sign_c = [0, 1;
          0, 1];

sign_f = [1, 0;
          1, 0];

PhaseII(Op, f, A, b, sign_c, sign_f);