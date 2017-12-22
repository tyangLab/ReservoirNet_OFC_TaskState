function [type] = trial_type(actionA_P, actionB_P, reward)


if actionA_P(1)
    if actionB_P(1)
        if reward 
           type=1;%A1 B1 R
        else
           type=2;%A1 B1 NR
        end
    else
        if reward
            type=3;%A1 B2 R
        else
            type=4;%A1 B2 NR
        end
    end
else
	if actionB_P(1)
        if reward 
            type=5;%A2 B1 R
        else
            type=6;%A2 B1 NR
        end
    else
        if reward 
            type=7;%A2 B2 R
        else
            type=8;%A2 B2 NR
        end
    end
end