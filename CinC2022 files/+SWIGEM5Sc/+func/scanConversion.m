function [cartXLim, cartYLim, cartImg] = scanConversion(polImg)
%% Convert image to Cartesian Image

    P = Vars.get('P');
    z = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterZ');
    h = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROIHeight');

    cTheta = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterX');
    AngWidth = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROIWidth');
    ratio = Vars.ratioFromWls;
    r1 = (z - h/2) * ratio;
    r2 = (z + h/2) * ratio;

    dTheta = P.dTheta;
    dRho = P.dR * ratio;

    dX = P.mwPDelta;
    dY = P.mwPDelta;

    szPol = size(polImg);
    
    if length(szPol) == 3
        npages = szPol(end);
    else
        npages = 1;
    end

    lX = floor(sin(cTheta - AngWidth / 2) * r2 / dX / 2) * 2 * dX;
    rX = ceil(sin(cTheta + AngWidth / 2) * r2 / dY / 2) * 2 * dY;
    tY = floor(cos( abs(cTheta) + AngWidth / 2 ) * r1);
    
    cartXLim = [lX, rX];
    cartYLim = [tY, ceil(r2/dY)*dY];


    szCart = round([diff(cartYLim) / dY...
        , diff(cartXLim) / dX ...
        , npages]);


    % Cart Image
    cartImg = zeros(szCart);
    
    [indPol, indCart] = getPixelIntensity(1 : prod(szCart), szCart ...
        , szPol, dX, dY, lX, tY, dTheta, dRho, cTheta, AngWidth, r1);
    cartImg( indCart ) = polImg( indPol );



    if nargin == 0
        fprintf('Scan Conversion took %.1f ms.\n', median(tt) * 1000)

        figure('Position',[100, 100, 1300, 500]);
        ax(1) = subplot(1, 3, 1);
        imagesc([cTheta - AngWidth / 2, cTheta + AngWidth / 2], [r1, r2], polImg(:,:,1))
        xlabel('Angle [deg]')
        ylabel('Depth [mm]')
        colormap(SWIGEM5Sc.ui.fireice)
        ylim(ax(1), [r1, r2])

        ax(2) = subplot(1, 3, 2 : 3);
        imagesc(cartXLim, cartYLim, cartImg(:,:,1))
        colormap(SWIGEM5Sc.ui.fireice)
        xlabel('Width [mm]')
        ylabel('Depth [mm]')
        axis equal
        ylim(ax(2), cartYLim)
    end

        function [indPol, indCart] = getPixelIntensity(indCart, szCart, szPol ...
                , dX, dY, lX, tY, dTheta, dRho, cTheta, AngWidth, r1)

            [cartY, cartX, cartPages] = ind2sub(szCart, indCart);

            [polThetaIdx, polRhoIdx] ...
                = SWIGEM5Sc.func.calcPixelLocInOrg(cartY, cartX, dX, dY, lX, tY ...
                , dTheta, dRho, cTheta, AngWidth, r1, szPol);

            keep = polRhoIdx>1 ...
                & polRhoIdx<szPol(1) ...
                & polThetaIdx>1 ...
                & polThetaIdx<szPol(2);

            polThetaIdx = polThetaIdx(keep);
            polRhoIdx = polRhoIdx(keep);
            indCart = indCart(keep);
            cartPages  = cartPages(keep);
            indPol = sub2ind(szPol, polRhoIdx, polThetaIdx, cartPages);
        end
end