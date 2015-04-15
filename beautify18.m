function [] = beautify18(h, ga)
% pass handle of lines and figure axis to set some default parameters

set(ga,'LineWidth',2,'FontWeight','bold','FontSize',18)

set(h(~isnan(h)),'LineWidth',2)
