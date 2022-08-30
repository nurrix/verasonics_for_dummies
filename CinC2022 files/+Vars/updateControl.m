function updateControl(Command, Parameters)
%% Update Control structure for the verasonics system
% - if Command is empty, it is set to 'update&Run'

if isempty(Command)
	Command = 'update&Run';
end

Control = Vars.get(SWIGEM5Sc.VarNames.Control);
n = length(Control) + ~isempty(Control(end).Command);
Control(n).Command = Command;
Control(n).Parameters = Parameters;
Vars.update(SWIGEM5Sc.VarNames.Control, Control)

end

