# Phase II Simplex Method Algorithm (MATLAB / Octave)

This repository contains a MATLAB implementation of **Phase II of the Simplex Algorithm** to solve Linear Programming (LP) problems in standard and canonical forms.

## Features

- **Canonical and Standard Transformations:** Automatically handles inequalities (`<=`, `>=`), equality constraints (`=`), and variable bounds (`>= 0`, `<= 0`, free variables).
- **Maximization and Minimization:** Supports both objective function orientations.
- **Multiple Optimal Solutions Detection:** Identifies non-basic variables with a reduced cost of zero and computes alternative extreme points / vertices.
- **Cycling Prevention:** Implements **Bland's Rule** to prevent infinite loops and cycling when degeneracy occurs.
- **Feasibility & Unboundedness Checks:** Detects infeasible initial states and unbounded constraints.

## Input Structure

The function expects the following inputs:
- `Op`: Optimization type (`[1, 0]` for Max, `[0, 1]` for Min).
- `f`: Objective function coefficient vector.
- `A`: Constraint matrix.
- `b`: Right-hand side constraint values.
- `sign_c`: Array representing constraint signs (`<=`, `>=`, `=`).
- `sign_f`: Array representing variable sign constraints.

## Usage

Matlab
% Example call
PhaseII(Op, f, A, b, sign_c, sign_f);
