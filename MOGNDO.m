%_________________________________________________________________________________
%  Multi-Objective Generalized Normal Distribution Optimization (MOGNDO) source codes version 1.0
%  Author and programmer: Pradeep Jangir and Kanak Kalita
% Sundaram B. Pandya, Pradeep Jangir, Miroslav Mahdal, Kanak Kalita, Jasgurpreet Singh Chohan, Laith Abualigah,
% Optimizing brushless direct current motor design: An application of the multi-objective generalized normal distribution optimization,
% Heliyon,
% Volume 10, Issue 4,
% 2024,
% e26369,
% ISSN 2405-8440,
% https://doi.org/10.1016/j.heliyon.2024.e26369.
% (https://www.sciencedirect.com/science/article/pii/S2405844024024009)
% Abstract: In this study, we tackle the challenge of optimizing the design of a Brushless Direct Current (BLDC) motor. Utilizing an established analytical model, we introduced the Multi-Objective Generalized Normal Distribution Optimization (MOGNDO) method, a biomimetic approach based on Pareto optimality, dominance, and external archiving. We initially tested MOGNDO on standard multi-objective benchmark functions, where it showed strong performance. When applied to the BLDC motor design with the objectives of either maximizing operational efficiency or minimizing motor mass, the MOGNDO algorithm consistently outperformed other techniques like Ant Lion Optimizer (ALO), Ion Motion Optimization (IMO), and Sine Cosine Algorithm (SCA). Specifically, MOGNDO yielded the most optimal values across efficiency and mass metrics, providing practical solutions for real-world BLDC motor design. The MOGNDO source code is available at: https://github.com/kanak02/MOGNDO.
% Keywords: BLDC motor; Electromagnetics; Metaheuristic; Non-dominated sorting generalized normal distribution optimization
%____________________________________________________________________________________


clc;
clear;
close all;
% Problem Configuration
fobj = @ZDT1; % Objective function handle
dim = 2; % Number of dimensions
ub = ones(1, dim); % Upper bounds (assuming 1 for all dimensions)
lb = zeros(1, dim); % Lower bounds (assuming 0 for all dimensions)
obj_no = 2; % Number of objectives
% Algorithm Parameters
Max_iter = 200; % Maximum number of iterations
SearchAgents_no = 500; % Maximum size of the archive
Archive_X = zeros(SearchAgents_no, dim); % Initialize archive solutions
Archive_F = ones(SearchAgents_no, obj_no) * inf; % Initialize archive fitnesses
Archive_member_no = 0; % Number of members in the archive
Best_score = inf * ones(1, obj_no); % Best rate (fitness) initialization
Best_P = zeros(dim, 1); % Best solution initialization
Positions = initialization(SearchAgents_no, dim, ub, lb); % Population initialization
% Main loop for MOGNDO algorithm
for iter = 1:Max_iter
    for i = 1:SearchAgents_no
        fitness(i, :) = fobj(Positions(i, :));
        if fitness(i) < Best_score
            Best_P = Positions(i,:);
        end
    end
     mo= mean(Positions);
    for i=1:SearchAgents_no
        a=randperm(SearchAgents_no,1);
        b=randperm(SearchAgents_no,1);
        c=randperm(SearchAgents_no,1);
        while a==i | a==b | c==b | c==a |c==i |b==i
            a=randperm(SearchAgents_no,1);
            b=randperm(SearchAgents_no,1);
            c=randperm(SearchAgents_no,1);
        end
        if fitness(a)<fitness(i)  
            v1=Positions(a,:)-Positions(i,:);  
        else
            v1=Positions(i,:)-Positions(a,:);
        end
        if fitness(b)<fitness(c) 
            v2=Positions(b,:)-Positions(c,:);
        else
            v2=Positions(c,:)-Positions(b,:);
        end
        if rand<=rand
            u=1/3*(Positions(i,:)+Best_P+mo); 
            deta=sqrt(1/3*((Positions(i,:)-u).^2+(Best_P-u).^2+(mo-u).^2));
            vc1=rand(1,dim);
            vc2=rand(1,dim);
            Z1=sqrt(-1*log(vc2)).*cos(2*pi.*vc1);
            Z2=sqrt(-1*log(vc2)).*cos((2*pi.*vc1)+pi);
            a = rand;
            b = rand;
            if a<=b
                eta = (u+deta.*Z1);
            else
                eta = (u+deta.*Z2);
            end
            newsol = eta;
        else
            beta=rand;
            newsol = Positions(i,:) +beta*abs(randn).*v1+(1-beta)*abs(randn).*v2;                 
        end
        newsol = max(newsol, lb);
        newsol = min(newsol, ub);
        newfitness =  fobj(newsol);
        if newfitness<fitness(i)  %Eq. 27
            Positions(i,:) = newsol;
            if fitness(i) < Best_score
                Best_P = Positions(i,:);
                Best_score = fitness(i);
            end
        end
     end

    % Calculate Fitness for each individual in Rimepop
    fitness = zeros(SearchAgents_no, obj_no);
    for i = 1:SearchAgents_no
        fitness(i, :) = fobj(Positions(i, :));
    end

    % Non-dominated Sorting and Crowding Distance Calculation
    Combined_X = [Positions; Archive_X(1:Archive_member_no, :)];
    Combined_F = [fitness; Archive_F(1:Archive_member_no, :)];
    [fronts, ~] = NonDominatedSorting(Combined_F);
    crowdingDistances = CrowdingDistance(Combined_F, fronts);

    % Update Archive using NSGA-II strategies
    [Archive_X, Archive_F, Archive_member_no] = UpdateArchiveUsingNSGAII(fronts, crowdingDistances, Combined_X, Combined_F, SearchAgents_no);


    % Display iteration information
    disp(['At iteration ', num2str(iter), ', MOGNDO has ', num2str(Archive_member_no), ' non-dominated solutions in the archive']);
end

% Plotting the results
figure;
Draw_ZDT1(); % Function to draw the true Pareto Front (assuming it is defined)
hold on;
plot(Archive_F(:, 1), Archive_F(:, 2), 'ro', 'MarkerSize', 8, 'markerfacecolor', 'k');
legend('True PF', 'Obtained PF');
title('MOGNDO');
set(gcf, 'pos', [403 466 230 200]); % Setting the figure position and size
