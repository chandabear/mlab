clear flags dat* file*

%% Define fileIDs

% file1 = 'path\name';
% dat1 = load(file1);
% 
% file2 = 'path\name';
% dat2 = load(file2);
% 
% % fileID3
% file3 = 'path\name';
% dat4 = load(file3);
% 
% file4 = 'path\name';
% dat4 = load(file4);

%% Define flags
% flags where 1 = keep data, 0 = exclude data.


%%
%   #,  '2variable name'        , '3variable units'         ,4file,5ind,6equ#, (7-9)equ. parameters,10flag1,11flag2,12flag3,13scn1,14scn2 
reader = {
    0,  'timestamp'             , 'time'                    ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []     
    1,  'CO2 flux^{OP}'         , '\mumol m^{-2} s^{-1}'    ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []     
    2,  'Latent heat^{OP}'      , 'W m^{-2}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    3,  'Sensible heat^{OP}'    , 'W m^{-2}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    4,  'u star'                , 'm s^{-1}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    5,  'CO2 flux^{CP}'         , '\mumol m^{-2} s^{-1}'    ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    6,  'Latent heat^{CP}'      , 'W m^{-2}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []          
    7,  'u_{rot}'               , 'm s^{-1}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    8,  'v_{rot}'               , 'm s^{-1}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    9,  'w_{rot}'               , 'm s^{-1}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    10,  'Ts'                   , '\circC'                  ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    11,  'var(u)_{rot}'         , '(m s^{-1})^2'            ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    12,  'var(v)_{rot}'         , '(m s^{-1})^2'            ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    13,  'var(w)_{rot}'         , '(m s^{-1})^2'            ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    14,  'var(Ts)'              , '(\circC)^2'              ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    15,  'CO_2^{OP}'            , 'mmol m^{-3}'             ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    16,  'H_2O^{OP}'            , 'mmol m^{-3}'             ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    17,  'CO_2^{CP}'            , 'mmol m^{-3}'             ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    18,  'H_2O^{CP}'            , 'mmol m^{-3}'             ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    19,  'var(CO_2)^{OP}'       , '(mmol m^{-3})^2'         ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    20,  'var(H_2O)^{OP}'       , '(mmol m^{-3})^2'         ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    21,  'var(CO_2)^{CP}'       , '(mmol m^{-3})^2'         ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    22,  'var(H_2O)^{CP}'       , '(mmol m^{-3})^2'         ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    23,  'w''T'''               , 'm s^{-1} \circC'         ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    24,  'w''CO_2''^{OP}'       , 'mmol m^{-2} s^{-1}'      ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    25,  'w''H_2O''^{OP}'       , 'mmol m^{-2} s^{-1}'      ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    26,  'w''CO_2''^{CP}'       , 'mmol m^{-2} s^{-1}'      ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    27,  'w''H_2O''^{CP}'       , 'mmol m^{-2} s^{-1}'      ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    28,  'Ta-asp'               , '\circC'                  ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    29,  'Ta-HMP'               , '\circC'                  ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    30,  'RH-HMP'               , '%'                       ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    31,  'Pressure'             , 'kPa'                     ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    32,  'Wind spd'             , 'm s^{-1}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    33,  'Wind dir'             , '\circ'                   ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    34,  'SWin'                 , 'W m^{-2}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    35,  'SWout'                , 'W m^{-2}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    36,  'LWin'                 , 'W m^{-2}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    37,  'LWout'                , 'W m^{-2}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    38,  'Rnet'                 , 'W m^{-2}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    39,  'SW2 diff'             , 'W m^{-2}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    40,  'SW2 tot'              , 'W m^{-2}'                ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    41,  'PARin'                , '\mumol m^{-2} s^{-1}'    ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    42,  'PARout'               , '\mumol m^{-2} s^{-1}'    ,  1,    3, [],     [],     [],     [],     [],     [],     [],     [],     []    
    };

%% Assemble datafiles

for i = 1:size(reader,1)
    if reader{i,4} == 1
        dat = dat1(:,reader{i,5});
    elseif reader{i,4} == 2
        dat = dat2(:,reader{i,5});
    elseif reader{i,4} == 3
        dat = dat3(:,reader{i,5});
    elseif reader{i,4} == 4
        dat = dat4(:,reader{i,5});
    else
        dat = nan(size(dat1(:,1)));         % default to NaN
    end
    
    % apply equation
    if reader{i,6} == 1             % linear equation
        dat = dat.*reader{i,7} + reader{i,8};
    elseif reader{i,6} == 2         % power 
        dat = (dat.*reader{i,7}).^reader{i,8};
    elseif reader{i,6} == 3         % mmol/m3 -> ppm
        dat = (dat.*(reader{i,7}+273.15))./reader{i,8}*8.314;
    elseif reader{i,6} == 4         % ppm -> mmol/m3
        dat = (dat.*reader{i,8})./(reader{i,7}+273.15)/8.314;
    end      
    
    % apply flags
    flags = ones(size(dat1(:,1)));
    if ~isempty(reader{i,10})
        flags = flags & reader{i,10};
    end
    if ~isempty(reader{i,11})
        flags = flags & reader{i,11};
    end
    if ~isempty(reader{i,12})
        flags = flags & reader{i,12};
    end
    dat(~flags) = NaN;
       
    ps_data(:,i) = dat; 
end

