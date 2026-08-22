function [f, z] =PhaseII(Op,f, A,b, sign_c, sign_f)
%Primero hay que ver si está en Standard Form
b=b(:);
print_canonical_problem(Op, f, A, b, sign_c, sign_f)
%Maximizar, optimizar o minimizar
if isequal(Op, [1,0])
        sense = 'max';
    elseif isequal(Op, [0,1])
        sense = 'min';
        f = -f; % Convertir a max para simplex
    elseif isequal(Op, [0,0])
        sense = 'opt';
    else
        error('Código de operación no válido');

end

%Canonicla

for i=1:size(sign_c,1)%constrains
    if ~isequal (sign_c(i,:),[0, 1])%<=
        if isequal(sign_c(i,:),[1, 0])%>=
            A(i,:)=-A(i,:); b(i)=-b(i)
        elseif isequal(sign_c(i,:),[0,0])
            A(end+1,:)=-A(i,:); b(end+1)=-b(i)     
        else
            error('Not valid inpunt')
        end
    end
    
end

%Get the estandar form
for i=size(sign_f,1): -1:1%signo variable
    if ~isequal(sign_f(i,:), [1 0])%x>= 0
        if isequal (sign_f(i,:),[0 1])% <=
        A(:,i)=-A(:,i)
        f(i)=-f(i)
        elseif isequal(sign_f(i,:), [0 0])% =
        
        W=-A(:,i);
 
        A=[A(:, 1:i),W,A(:,i+1:end)];
        f=[f(1:i),-f(i),f(i+1:end)];

        end

    end

end

num_var=size(f,2);

SI= eye(size(A,1));
A=[A,SI];
f= [f,zeros(1,size(A, 1))];
z=0;

%Phase II
iteration=0;

m=size(A,1);
basis=[m+1:size(A,2)];
no_basis= [1:m];

names_inc = arrayfun(@(i) sprintf('x%d', i), 1:num_var, 'UniformOutput', false);
num_slack = size(A, 2) - m;
names_slack = arrayfun(@(i) sprintf('s%d', i), 1:num_slack, 'UniformOutput', false);
var_names = [names_inc, names_slack];

mul= false; % in case we get multiple solution with 2 variables

 if any(b<0)

        fprintf("The problem is unfeasible so we  have to implement PhaseI \n")


 else

     fprintf("The problem is feasible\n")

    y= false;

    
    zs=0       ;% to keep trak of the number of z that repeats and avoid looping
    z1= Inf; % to compare the previus z
    bland = false;
    
    
    iteration=0;
    
    while y==false
        iteration=iteration+1;
        
        % chek if we continue iterating
        
        if not( any(f>0)) && not(mul)
            fprintf("It is already an optimal solution\n")
            y= true ;
            break
        end

        % Step 1: greatest positive indicator
        if bland
            ind= find(f>0);
            col_p=ind(1);
        else

            [ind, col_p] = max(f);
        end

        if not( any(A(:, col_p)>0))
            fprintf("Unbounded solution\n")
            y=true;
            break
        end
    
      
    
    
    %Step 2: we choose the pivot
        col_pivot = A(:, col_p);
        non_row= col_pivot <= 0;
            col_pivot(non_row) = 1;
            div= b./col_pivot;
            div(non_row)= Inf;
            min_div= min(div);
            indx= find(div==min_div);
            b_indx=basis(indx);
            [b_min, b_row]= min(b_indx);
            row_p=indx(b_row);
            
            pivot= A(row_p, col_p);
    
    
    
    %Step 3
        b(row_p) = b(row_p)/ pivot;
        A(row_p,:)= A(row_p,:)/pivot;
     
    
        for i=1:size(A,1)
            if ~isequal(i,row_p)
                 b(i) = b(i) - A(i,col_p) * b(row_p);
                A(i,:) = A(i,:) - A(i,col_p) * A(row_p,:);
               
        
            end
        
        end
        z=z-f(col_p)*b(row_p);
        f= f-f(col_p)*A(row_p,:);
        
        
        %Step 4: Change the basic variable
        idx=find(no_basis==col_p);
        new_var=no_basis(idx);
        
        no_basis(idx)=basis(row_p);
        
        basis(row_p)=new_var;
        
        
        %Step 5: Analyze the results
        
        if z==z1
            zs=1+zs;
        else
            zs=0;
        end
        z1=z;
       
        if max(f)<=0
            if any(f(no_basis)==0)
               fprintf("We have multiple optimal solutions\n")
                    if num_var>=3 || mul
                        y=true;
                        break
                    else
                        fprintf("We need an iteration to get the vertex\n")
                        sol1_f= f;
                        sol1_b=b;
                        sol1_no_basis=no_basis;
                        sol1_basis=basis;
                        sol1_A=A;
                        sol1_z=z;
                        mul=true;
                    end
            end
            if not(any (f(no_basis)==0))
                fprintf("We have reached an optimal solution\n")
                y=true;
            end
        
        end

        % To avoid looping we implemnt Bland's rule
        if zs>= 6
            bland = true;
            fprintf(" We implement Bland to get out od the looping\n")
        end
    
    end
 end
  

 if mul
    v1 = zeros(1, size(sol1_A, 2));
    v1(sol1_basis) = sol1_b;

    v2 = zeros(1, size(A, 2));
    v2(basis) = b;

    fprintf('\n[Extreme Vertex 1]\n');
    for i = 1:m
        fprintf('  %s = %.4f\n', var_names{i}, v1(i));
    end
    fprintf('  Z = %.4f\n', sol1_z);

    
    fprintf('\n[Extreme Vertex 2]\n');
    for i = 1:m
        fprintf('  %s = %.4f\n', var_names{i}, v2(i));
    end
    fprintf('  Z = %.4f\n', z);

    fprintf('\n[Infinitely Many Optimal Solutions Segment]\n');
    fprintf('Any point along the convex combination segment:\n');
    fprintf('  (x1, x2) = λ*(%.2f, %.2f) + (1-λ)*(%.2f, %.2f)\n', v1(1), v1(2), v2(1), v2(2));
    fprintf('  for all λ ∈ [0, 1]\n');

else
    
    fprintf('Variables in basis: ');
    for i = 1:length(basis)
        fprintf('%s ', var_names{basis(i)});
    end
    fprintf('\n\n--- Final solution ---\n');

    for i = 1:length(basis)
    idx = basis(i);
    if idx <= length(var_names)
        fprintf('  %s = %.4f\n', var_names{idx}, b(i));
    else
        fprintf('  x%d = %.4f\n', idx, b(i)); 
    end
end

    fprintf('  Z = %.4f\n', z);
end





