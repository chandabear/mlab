function [] = beautify(h, ga)
% pass handle of lines and figure axis to set some default parameters

set(ga,'LineWidth',1.5,'FontWeight','bold','FontSize',12)

set(h(~isnan(h)),'LineWidth',1.5)
