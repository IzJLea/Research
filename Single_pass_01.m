%% Initial single pass k calculation- 
% pressure differences in each pass section
%
[~, ~, raw] = xlsread('C:\Users\Izaak\Documents\Research\Generic C9 HTS Data.xlsx','FLOW-DP','I13:I17');


DP = reshape([raw{:}],size(raw));

%%calculate values for k for each section

% normal mass flowrate

M=25.8; % kg/s

Rho=780.6; %kg/m^3


keff=DP/(M^2);

reff=keff*Rho;

display(reff);

Minput=input('Flowrate');

Rhoin=input('Density of fluid');

DPm=keff*Minput^2;

DPd=DPm*Rho/Rhoin;

DPt=sum(DPd);

display(DPd, 'Pressure drop per section');

display(DPt, 'Total Pressure drop:');


