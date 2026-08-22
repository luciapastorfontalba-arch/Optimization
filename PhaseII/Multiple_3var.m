
clc
clear all

Op = [1, 0];  % Maximize

f = [2.0, 2.0, 0.0];

A = [1.0, 1.0, 1.0;
     1.0, 0.0, 0.0;
     0.0, 1.0, 0.0];

b = [4.0; 2.0; 2.0];

sign_c = [0, 1;
          0, 1;
          0, 1];

sign_f = [1, 0;
          1, 0;
          1, 0];

PhaseII(Op, f, A, b, sign_c, sign_f);