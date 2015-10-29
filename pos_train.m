clear; clc;

filename = 'pos.train.subs.txt';

fid = fopen(filename);

tline = '';

lineCount = 1;

myWordMap = containers.Map;
mySymMap = containers.Map;
myWordInvMap = {};
mySymInvMap = {};
wordCount = 1;
symCount = 1;

myWordMap('START') = wordCount;
mySymMap('START') = symCount;
myWordInvMap{wordCount} = 'START';
mySymInvMap{symCount} = 'START';

wordCount = wordCount + 1;
symCount = symCount + 1;

while ischar(tline)
    
    disp([1 lineCount]);
    
    tline = fgetl(fid);
    
    while ~strcmp(tline, '') && ischar(tline)
        
        c = strsplit(tline);
        
        try
            myWordMap(lower(c{1}));
        catch
            myWordMap(lower(c{1})) = wordCount;
            myWordInvMap{wordCount} = lower(c{1});
            wordCount = wordCount + 1;
        end
        
        try
            mySymMap(lower(c{2}));
        catch
            mySymMap(lower(c{2})) = symCount;
            mySymInvMap{symCount} = lower(c{2});
            symCount = symCount + 1;
        end
        
        tline = fgetl(fid);

    end
    
    lineCount = lineCount + 1;
    
end

fclose(fid);

myTrans = zeros(symCount-1, symCount-1);
myEmis = zeros(symCount - 1, wordCount - 1);

fid = fopen(filename);
tline = '';

lineCount = 1;

while ischar(tline)
    
    disp([2 lineCount]);
    
    tline = fgetl(fid);
    oldSym = 'START';
    
    while ~strcmp(tline, '') && ischar(tline)
        
        c = strsplit(tline);
        
        myTrans(mySymMap(oldSym), mySymMap(lower(c{2}))) = myTrans(mySymMap(oldSym), mySymMap(lower(c{2}))) + 1; %#ok<*SAGROW>
        myEmis(mySymMap(lower(c{2})), myWordMap(lower(c{1}))) = myEmis(mySymMap(lower(c{2})), myWordMap(lower(c{1}))) + 1;
        
        oldSym = lower(c{2});
        
        tline = fgetl(fid);

    end
    
    lineCount = lineCount + 1;
    
end

myTrans = myTrans + 0.01;
myTrans = myTrans ./ repmat(sum(myTrans, 2), 1, size(myTrans, 2));

myEmis = myEmis ./ repmat(sum(myEmis, 2), 1, size(myEmis, 2));

fclose(fid);