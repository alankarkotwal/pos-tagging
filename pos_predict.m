function statesOut = pos_predict(x, myTrans, myEmis, myWordMap, mySymInvMap)

    seq = zeros(1, size(x, 2));
    
    for i=1:size(x, 2)
        
        try
            seq(i) = myWordMap(lower(x{i}));
        catch
            seq(i) = myWordMap('__UNK__');
        end
        
    end

    states = hmmviterbi(seq, myTrans, myEmis);
    statesOut = cell(1, size(x, 2));
    
    for i=1:size(statesOut, 2)
        
        statesOut{i} = upper(mySymInvMap{states(i)});
        
    end
    
end