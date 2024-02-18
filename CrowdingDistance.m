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


function distances = CrowdingDistance(F, fronts)
    % Initialize the distances array
    distances = zeros(size(F, 1), 1);

    % Calculate crowding distance for each front
    for f = 1:length(fronts)
        front = fronts{f};
        frontSize = length(front);

        % Set the boundary points' distances to infinity
        if frontSize > 2
            distances(front) = 0;
            for m = 1:size(F, 2) % Iterate over each objective
                [sortedValues, sortOrder] = sort(F(front, m));
                sortedFront = front(sortOrder);

                % Distance for boundary points
                distances(sortedFront(1)) = inf;
                distances(sortedFront(end)) = inf;

                % Distance for intermediate points
                for i = 2:(frontSize - 1)
                    distances(sortedFront(i)) = distances(sortedFront(i)) + ...
                        (F(sortedFront(i + 1), m) - F(sortedFront(i - 1), m)) / ...
                        (max(F(:, m)) - min(F(:, m)));
                end
            end
        else
            distances(front) = inf;
        end
    end
end
