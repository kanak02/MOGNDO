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


function [fronts, maxFront] = NonDominatedSorting(F)
    % Initialize
    [S, n, frontNumbers] = deal(cell(size(F, 1), 1));
    [rank, distances] = deal(zeros(size(F, 1), 1));
    front = 1;
    maxFront = 0;

    % Calculate domination
    for i = 1:size(F, 1)
        S{i} = [];
        n{i} = 0;
        for j = 1:size(F, 1)
            if dominates(F(i, :), F(j, :))
                S{i} = [S{i}, j];
            elseif dominates(F(j, :), F(i, :))
                n{i} = n{i} + 1;
            end
        end
        if n{i} == 0
            rank(i) = 1;
            if isempty(frontNumbers{front})
                frontNumbers{front} = i;
            else
                frontNumbers{front} = [frontNumbers{front}, i];
            end
        end
    end

    % Assign fronts
    while ~isempty(frontNumbers{front})
        Q = [];
        for i = frontNumbers{front}
            for j = S{i}
                n{j} = n{j} - 1;
                if n{j} == 0
                    rank(j) = front + 1;
                    Q = [Q, j];
                end
            end
        end
        front = front + 1;
        frontNumbers{front} = Q;
    end
    maxFront = front - 1;

    % Organize fronts
    fronts = cell(maxFront, 1);
    for i = 1:maxFront
        fronts{i} = frontNumbers{i};
    end
end
