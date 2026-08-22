

clc
clear all

Op = [0, 1];

f = [2.0, -3.0];

A = [ 1.0,  1.0;
      2.0, -1.0];

b = [5.0; 
     4.0];

sign_c = [0, 0;
          0, 1];

sign_f = [1, 0;
          0, 0];

 PhaseII(Op, f, A, b, sign_c, sign_f);