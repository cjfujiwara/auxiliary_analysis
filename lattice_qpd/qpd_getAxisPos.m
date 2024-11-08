function P = qpd_getAxisPos(nV,nH,nInd,parent,margins)
    W = parent.Position(3);
    H = parent.Position(4);

    nTot = nV*nH;

    column_index = mod(nInd-1,nH)+1;
    row_index = floor((nInd-1)/nH)+1;

    if nargin == 3
        margins =struct;
        margins.yTop = 25;
        margins.yBots=40;        % y bottom margin
        margins.xLeft=50;       % x left margin
        margins.xRight=50;      % y right margin    
        margins.ySpace=40;      % y space between objects
        margins.xSpace=50;      % x space between objects
    end


    yTop=margins.yTop;        % y top margin
    yBot=margins.yBot;        % y bottom margin
    xLeft=margins.xLeft;       % x left margin
    xRight=margins.xRight;      % y right margin    
    ySpace=margins.ySpace;      % y space between objects
    xSpace=margins.xSpace;      % x space between objects

    
    axH=(H-yTop-yBot-ySpace*(nV-1))/nV;
    axW=(W-xLeft-xRight-xSpace*(nH-1))/nH;

    X0 = xLeft;
    Y0 = H-yTop-axH;
    
    axX = X0 + (column_index-1)*(axW+xSpace);
    axY=  Y0 - (row_index-1)*(axH+ySpace);

    P = [axX,axY,axW,axH];
end
