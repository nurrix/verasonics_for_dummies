classdef VarNames
    %% Variable names for specific verasonics script
    
    properties (Constant)
        %% Verasonics Objects
        Control = 'Control'
        Event = 'Event'
        Process = 'Process'
        PData = 'PData'
        Receive = 'Receive'
        Recon = 'Recon'
        Resource = 'Resource'
        SeqControl = 'SeqControl'
        SWIInfo = 'SWIInfo'
        TGC = 'TGC'
        Trans = 'Trans'
        TX = 'TX'
        TXRX_mode = 'TXRX_mode'
        UI = 'UI'
    end

    
    properties (Constant)
    %% Information variable Names
        freeze = 'freeze'
        vsExit = 'vsExit'

        firstVideoReplay = 'firstVideoReplay'
        gui_loopfps = 'gui_loopfps'
        gui_velocity_max = 'gui_velocity_max'


        MoviePower = 'MoviePower'
        MovieVelocity = 'MovieVelocity'

        VidFramesPower = 'VidFramesPower'
        VidFramesVelocity = 'VidFramesVelocity'

        P = 'P'

        Variables = 'Variables'
    end

    properties (Constant)
    %% gObject Handles
        figPowerHandle = 'figPowerHandle'
        figSWIHandle = 'figSWIHandle'
        figTemporalSWIHandle = 'figTemporalSWIHandle'
        figVelHandle = 'figVelHandle'

        handleQuiverPrim = 'handleQuiverPrim'
        handleQuiverPwr = 'handleQuiverPwr'
        handleQuiverVel = 'handleQuiverVel'

        imgPowerHandle = 'imgPowerHandle'
        imgVelHandle = 'imgVelHandle'

        primMarkHandle = 'primMarkHandle'
        primROICenterHandle = 'primROICenterHandle'
        primROIHandle = 'primROIHandle'
        primTransHandle = 'primTransHandle'
        
    end


end

