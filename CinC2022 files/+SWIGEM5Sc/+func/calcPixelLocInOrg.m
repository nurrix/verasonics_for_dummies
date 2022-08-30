function [polThetaIdx, polRhoIdx] = calcPixelLocInOrg(cartY, cartX, dX, dY, lX, tY, dTheta, dRho, cTheta, AngWidth, r1, szPol)
    %% Get pixel location idx in raw data 
    
    [theta, rho] = cart2pol((cartY - 1) * dY + tY, (cartX - 1) * dX + lX );
    
    % Clear false gods
    
    % Nearest Neighbour!
    polThetaIdx = round((theta - cTheta + AngWidth/2 ) ./ dTheta)+1;
    polRhoIdx = round((rho - r1) ./ dRho)+1;
end