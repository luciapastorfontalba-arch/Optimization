function print_canonical_problem(Op, f, A, b, sign_c, sign_f)


if isequal(Op, [1, 0])
        opt_type = 'MAX';
        opt_label = 'Max';
elseif isequal(Op, [0, 1])
        opt_type = 'MIN';
        opt_label = 'Min';
elseif isequal(Op, [0, 0])
    opt_type = 'OPT';
        opt_label = 'Opt';
else
    error('Not valid input')
    end

    % 1. Construir la Función Objetivo
    obj_terms = {};
    for i = 1:length(f)
        coeff = f(i);
        if coeff == 0
            continue;
        end
        
        abs_coeff = abs(coeff);
        if abs_coeff == 1
            coeff_str = '';
        else
            coeff_str = sprintf('%g*', abs_coeff);
        end

        if isempty(obj_terms)
            if coeff < 0
                term = sprintf('-%sx%d', coeff_str, i);
            else
                term = sprintf('%sx%d', coeff_str, i);
            end
        else
            if coeff > 0
                term = sprintf('+ %sx%d', coeff_str, i);
            else
                term = sprintf('- %sx%d', coeff_str, i);
            end
        end
        obj_terms{end+1} = term;
    end
    obj_str = strjoin(obj_terms, ' ');

    fprintf('=======================================================\n');
    fprintf('  PROBLEM FORMULATION (%s)\n', opt_type);
    fprintf('=======================================================\n');
    fprintf('  %s Z = %s\n', opt_label, obj_str);
    fprintf('  s.t.\n');

    % 2. Construir las Restricciones
    for row_idx = 1:size(A, 1)
        row_terms = {};
        for col_idx = 1:size(A, 2)
            coeff = A(row_idx, col_idx);
            if coeff == 0
                continue;
            end

            abs_coeff = abs(coeff);
            if abs_coeff == 1
                coeff_str = '';
            else
                coeff_str = sprintf('%g*', abs_coeff);
            end

            if isempty(row_terms)
                if coeff < 0
                    term = sprintf('-%sx%d', coeff_str, col_idx);
                else
                    term = sprintf('%sx%d', coeff_str, col_idx);
                end
            else
                if coeff > 0
                    term = sprintf('+ %sx%d', coeff_str, col_idx);
                else
                    term = sprintf('- %sx%d', coeff_str, col_idx);
                end
            end
            row_terms{end+1} = term;
        end

        % Obtener el signo de la restricción desde sign_c
        sc = sign_c(row_idx, :);
        if isequal(sc, [1, 0])
            rel_str = '<=';
        elseif isequal(sc, [0, 1])
            rel_str = '>=';
        else
            rel_str = '=';
        end

        lhs = strjoin(row_terms, ' ');
        fprintf('    %s %s %g\n', lhs, rel_str, b(row_idx));
    end

    % 3. No negatividad
    var_names = arrayfun(@(i) sprintf('x%d', i), 1:length(f), 'UniformOutput', false);
    fprintf('    %s >= 0\n', strjoin(var_names, ', '));
    fprintf('=======================================================\n\n');
end
