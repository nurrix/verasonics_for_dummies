% function generateVerasonicsSetupScript()

    close all;

    my_gui = SetupGenerator.GUI_SETUP();

    fprintf('[%s] Initializing Setup GUI\n', datetime('now'))

figure_main = uifigure('Name', 'Setup Settings for Verasonics Vantage' ...
        , 'Visible', true ...
		, "Position",[100,100,800,800] ...
        , 'Tag', 'Setup Settings for Verasonics Vantage' );
json_prop = jsondecode(fileread("+SetupGenerator/gen.json"));


my_gui.Initialize(250, figure_main, json_prop);

% end