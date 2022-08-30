# Shear Wave acquision README

## How to run the SWI program in MATLAB

1) Ensure that the MATLAB work folder is the vantage matlab folder, i.e.: C:\Users\<USER>\Documents\Vantage-4.7.6
1) run the command from 'command window': 
    > activate()
1) run the following commands from 'command window', and wait for system to fully start: 
    > RunARFIShearWaves_GEM5Sc
    

    - To rerun the script run one of the following commands from 'command window': 
    - REMEMBER! When VSX is running (is called in fx. RunARFIShearWaves_GEM5Sc),
          MATLAB is locked, and you have to close the Ultrasound Interface to do anything else in MATLAB!
        > VSX GE11LD_rectangular_ARFI

    1) Correct where we display Shear Waves:
        - Use the Flash TX/RX Mode setthing when aiming for an artery. Use move 'Focus/ROI', to select to either move the ROI
        - User inputs enabled when using 'move Focus': 
            > left mouse click: move ARFI focus point (only works with ARFI)

            > right mouse click: Change angle of the arrow (where we create our temporal SWI)
        - User inputs enabled when using 'move ROI:
            > drag the ROI (Purple square) to the location of interest. Remember, Shear Waves are only calculated/identified within the ROI 
        - Correct the ROI Width and Height using the sliders. Values are in milimeters

    1) To show Shear Waves Select ARFI/SWI
        - Wait for SWI to initialize (can take a few seconds).
        - If SWI signal is low, increase Power using High Voltage P1 (P5 for ARFI/SWI)
        - You can correct the visual signal of the Temporal Shear Wave Velocity image, using the 'Velocity Max'-slider
    
    1) To Save SWI:
        1) Press 'Freeze'
            This Freezes the system.
            - Verify that the frozen image is good.
            - Verify that you recorded from the correct point in the Cardiac Cycle
            - Verify that you have a good PulseOxy signal
        1) Press 'Save RAW SWI'
        1) In the save dialog, define the filename (It provides a default name. But you can, and should, change this),
             and you can define the save location (by default C:\Users\<USER>\Desktop\savefiles)... the file extension does not matter.
        1) This saves 4 files to the the defined location. Where one of them is the Temporal Shear Wave Image as a jpeg.
        