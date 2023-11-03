function fixed = bin2fi(bin, signed, WL, WF)

    if(signed && bin(1) == '1')
        dec = ( bin2dec(bin) - (2^(WL)) ) * 2^-WF;
    else
        dec = bin2dec(bin) * 2^-WF;
    end

    fixed = fi(dec, signed, WL, WF);

end