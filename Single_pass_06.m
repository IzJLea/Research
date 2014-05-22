%% system input

Pin=11.380; % MPa 

hin=1500; %enthalpy entering channel. kJ/kg

Minput=25.8; % kg/s

Tbulk=267.2;    %Celsius

%% Retrieving H2O physical data (for interpolation)

% Temperature Data
[~, ~, raw] = xlsread('C:\Users\Izaak\Documents\Research\H2O_TempSat.xls','Sheet1','A32:A52');

WaterSaturationPropertiesTemperatureTable2 = reshape([raw{:}],size(raw));

clearvars raw;

Th2o=WaterSaturationPropertiesTemperatureTable2;

%Saturation Pressure

[~, ~, raw] = xlsread('C:\Users\Izaak\Documents\Research\H2O_TempSat.xls','Sheet1','B32:B52');

WaterSaturationPropertiesTemperatureTable8 = reshape([raw{:}],size(raw));

clearvars raw;

Ph2o=WaterSaturationPropertiesTemperatureTable8;

%liquid specific volume

[~, ~, raw] = xlsread('C:\Users\Izaak\Documents\Research\H2O_TempSat.xls','Sheet1','C32:C52');

WaterSaturationPropertiesTemperatureTable3 = reshape([raw{:}],size(raw));

clearvars raw;

vsf=WaterSaturationPropertiesTemperatureTable3;

%gaseous specific volume

[~, ~, raw] = xlsread('C:\Users\Izaak\Documents\Research\H2O_TempSat.xls','Sheet1','D32:D52');

WaterSaturationPropertiesTemperatureTable4 = reshape([raw{:}],size(raw));

clearvars raw;

vsg=WaterSaturationPropertiesTemperatureTable4;

%fluid enthalpy

[~, ~, raw] = xlsread('C:\Users\Izaak\Documents\Research\H2O_TempSat.xls','Sheet1','G32:G52');

WaterSaturationPropertiesTemperatureTable5 = reshape([raw{:}],size(raw));

clearvars raw;

hf=WaterSaturationPropertiesTemperatureTable5;

%latent heat

[~, ~, raw] = xlsread('C:\Users\Izaak\Documents\Research\H2O_TempSat.xls','Sheet1','H32:H52');

WaterSaturationPropertiesTemperatureTable6 = reshape([raw{:}],size(raw));

clearvars raw;

hfg=WaterSaturationPropertiesTemperatureTable6;

%gaseous enthalpy

[~, ~, raw] = xlsread('C:\Users\Izaak\Documents\Research\H2O_TempSat.xls','Sheet1','I32:I52');

WaterSaturationPropertiesTemperatureTable7 = reshape([raw{:}],size(raw));

clearvars raw;

hg=WaterSaturationPropertiesTemperatureTable7;

%% Calculation of system properties
%temperature (saturation)

Tsys=Lagint(Ph2o,Th2o,Pin); %Celsius 

% fluid enthalpy

hfsys=Lagint(Ph2o,hf,Pin); %kJ/kg

%gaseous enthalpy

hgsys=Lagint(Ph2o,hg,Pin); %kJ/kg

%liquid density

rholsys=1/Lagint(Ph2o, vsf,Pin); %kg/m^3

%gaseous density

rhogsys=1/Lagint(Ph2o,vsg,Pin); %kg/m^3

%latent heat

hfgsys=Lagint(Ph2o,hfg,Pin); %kJ/kg

% liquid specific heat

Cpl=4.1855*(0.996185+(0.0002874*(((Tsys+100)/100)^5.26))+(0.01116*10^(-0.036*Tsys)));

%% Initial single pass k calculation- 
% pressure differences in each pass section
%
[~, ~, raw] = xlsread('C:\Users\Izaak\Documents\Research\Generic C9 HTS Data.xlsx','FLOW-DP','I13:I17');


DP = reshape([raw{:}],size(raw));

%%calculate values for k for each section

% reference mass flowrate

M=25.8; % kg/s

Rho=780.6; %kg/m^3

keff=DP/(M^2);

reff=keff*Rho;

display(reff);

%% Single Phase Pressure drop

DPm=keff*Minput^2;

DPd=DPm*Rho/rholsys;

DPt=sum(DPd);

display(DPd, 'Pressure drop per section');

display(DPt, 'Total single phase Pressure drop:');

%% Two Phase pressure drop
%thermal equilibrium vapour weight fraction and true weight fraction

x=(hin-hfsys)/(hgsys-hfsys);

xd=-Cpl*(Tsys-Tbulk)/hfgsys;

xprime=x-(xd*exp((x/xd)-1));

