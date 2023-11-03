% Fixed Point FIR Filter
function [signal_out] = Fixed_Point_FIR(signal_in, coeff, WI_IN, WF_IN, WI_COEFF, WF_COEFF, WI_OUT, WF_OUT)

    % initialize output signal
    signal_out = zeros(1,length(signal_in));
    
    % iterate through input signal samples
    for i = 1:length(signal_in)
        
        % initialize output signal sample to 0
        signal_out(i) = fi(0, 1, WI_OUT+WF_OUT, WF_OUT);
        
        % iterate through coefficients
        for j = 1:length(coeff)

            % if index out of range, use 0 as sample
            if (i-j+1) < 1
                signal_out(i) = fi(signal_out(i) + 0*coeff(j), 1, WI_OUT+WF_OUT, WF_OUT);
            else
                signal_out(i) = fi(signal_out(i) + signal_in(i-j+1)*coeff(j), 1, WI_OUT+WF_OUT, WF_OUT);
            end
        end
    end

end