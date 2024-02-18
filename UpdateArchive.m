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




function [Archive_X_updated, Archive_F_updated, Archive_member_no]=UpdateArchive(Archive_X, Archive_F, Particles_X, Particles_F, Archive_member_no)
Archive_X_temp=[Archive_X ; Particles_X'];
Archive_F_temp=[Archive_F ; Particles_F];

o=zeros(1,size(Archive_F_temp,1));

for i=1:size(Archive_F_temp,1)
    o(i)=0;
    for j=1:i-1
        if any(Archive_F_temp(i,:) ~= Archive_F_temp(j,:))
            if dominates(Archive_F_temp(i,:),Archive_F_temp(j,:))
                o(j)=1;
            elseif dominates(Archive_F_temp(j,:),Archive_F_temp(i,:))
                o(i)=1;
                break;
            end
        else
            o(j)=1;
            o(i)=1;
        end
    end
end


Archive_member_no=0;
index=0;
for i=1:size(Archive_X_temp,1)
    if o(i)==0
        Archive_member_no=Archive_member_no+1;
        Archive_X_updated(Archive_member_no,:)=Archive_X_temp(i,:);
        Archive_F_updated(Archive_member_no,:)=Archive_F_temp(i,:);
    else
        index=index+1;
        %         dominated_X(index,:)=Archive_X_temp(i,:);
        %         dominated_F(index,:)=Archive_F_temp(i,:);
    end
end
end