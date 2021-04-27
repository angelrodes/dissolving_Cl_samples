%% Simulate the effect of Cl evaporation during dissolution
%% and check the differences when spiking before, after, or both
%% Angel Rodes, SUERC 2018

clear
close all hidden

% define t and dissolved
t=[1:100];
startdissolutiont=20;
enddissolutiont=80;
dissolved=0*t;
d=0;
for ti=t
    if ti>startdissolutiont && ti<=enddissolutiont
        d=d+1/(enddissolutiont-startdissolutiont);
        dissolved(ti)=d;
    end
    if ti>enddissolutiont
        dissolved(ti)=d;
    end
end

% define materials
acidvolume=300; % ml
carrieraddition=1.3; % mg Cl
carrieradditionvolume=0.3; % ml

rockmass=20; % g
rockCl=100/1000; % mg/g
nat3537=(1-0.2423)/0.2423; % at/at
massnat=35*(1-0.2423)+37*0.2423; % u
carrier3537=20; % at/at
massspk=35*(1-1/(1+carrier3537))+37*(1/(1+carrier3537));
rock36Cl=100000; % at/g
carrier36Cl=5e-15; % at36 / atCl
totalClevap=0.5; % percentage
NA=6.022e23;

figure
hold on

for test=1:3
    if test==1
        carrieradditiont=[10];
        strtitle='Pre-dissolution spike';
    elseif test==2
        carrieradditiont=[90];
        strtitle='Post-dissolution spike';
    else
        carrieradditiont=[10,90];
        strtitle='Double spike';
    end
    
    % model 1 no evaporation
    TotCl=0.*t;
    Cl36=0.*t;
    Cl35=0.*t;
    Cl37=0.*t;
    VOL=0.*t;
    
    TotCli=0;
    Cl36i=0;
    Cl35i=0;
    Cl37i=0;
    VOLi=0;
    
    for ti=t
        
        % acid and rock additions
        if ti>2
            TotCli=TotCli+(dissolved(ti)-dissolved(ti-1))*rockmass*rockCl;
            VOLi=VOLi+acidvolume*(dissolved(ti)-dissolved(ti-1));
            Cl36i=Cl36i+(dissolved(ti)-dissolved(ti-1))*rockmass*rock36Cl;
            Cl35i=Cl35i+(dissolved(ti)-dissolved(ti-1))*rockmass*rockCl/1000*NA/massnat*(1-1/(1+nat3537));
            Cl37i=Cl37i+(dissolved(ti)-dissolved(ti-1))*rockmass*rockCl/1000*NA/massnat*(1/(1+nat3537));
            
        end
        
        % carrier additions
        if sum(ti==carrieradditiont)>0
            TotCli=TotCli+carrieraddition/length(carrieradditiont);
            VOLi=VOLi+carrieradditionvolume/length(carrieradditiont);
            Cl36i=Cl36i+carrieraddition/1000*NA/massnat*carrier36Cl/length(carrieradditiont);
            Cl35i=Cl35i+carrieraddition/1000*NA/massspk*(1-1/(1+carrier3537))/length(carrieradditiont);
            Cl37i=Cl37i+carrieraddition/1000*NA/massspk*(1/(1+carrier3537))/length(carrieradditiont);
        end
        
        % store partial calulations
        TotCl(ti)=TotCli;
        Cl36(ti)=Cl36i;
        Cl35(ti)=Cl35i;
        Cl37(ti)=Cl37i;
        VOL(ti)=VOLi;
    end
    
    % final results
    f1a=TotCl(end);
    f1b=Cl36(end)./(TotCl(end)/1000*NA/massnat+1);
    f1c=Cl35(end)./(Cl37(end)+1);
    TotClref=TotCl;

    subplot(4,3,test)
    hold on
    plot(t,TotCl,'-g')
    title(strtitle)
    
    subplot(4,3,test+3)
    hold on
    plot(t,Cl36./(TotCl/1000*NA/massnat+1),'-g')

    subplot(4,3,test+3*2)
    hold on
    plot(t,Cl35./(Cl37+1),'-g')

    
    subplot(4,3,test+3*3)
    hold on
    plot(t,t.*0,'-g')

    
%     for x=carrieradditiont
%         plot([x,x],[0,acidvolume/2],'-k')
%         text(x,acidvolume/2,'carrier','HorizontalAlignment','center','VerticalAlignment','bottom');
%     end
    
    % model 2 evaporation
    TotCl=0.*t;
    Cl36=0.*t;
    Cl35=0.*t;
    Cl37=0.*t;
    VOL=0.*t;
    
    TotCli=0;
    Cl36i=0;
    Cl35i=0;
    Cl37i=0;
    VOLi=0;
    
    for ti=t
        
        % acid and rock additions
        if ti>2
            TotCli=TotCli+(dissolved(ti)-dissolved(ti-1))*rockmass*rockCl;
            VOLi=VOLi+acidvolume*(dissolved(ti)-dissolved(ti-1));
            Cl36i=Cl36i+(dissolved(ti)-dissolved(ti-1))*rockmass*rock36Cl;
            Cl35i=Cl35i+(dissolved(ti)-dissolved(ti-1))*rockmass*rockCl/1000*NA/massnat*(1-1/(1+nat3537));
            Cl37i=Cl37i+(dissolved(ti)-dissolved(ti-1))*rockmass*rockCl/1000*NA/massnat*(1/(1+nat3537));
            
        end
        
        % carrier additions
        if sum(ti==carrieradditiont)>0
            TotCli=TotCli+carrieraddition/length(carrieradditiont);
            VOLi=VOLi+carrieradditionvolume/length(carrieradditiont);
            Cl36i=Cl36i+carrieraddition/1000*NA/massnat*carrier36Cl/length(carrieradditiont);
            Cl35i=Cl35i+carrieraddition/1000*NA/massspk*(1-1/(1+carrier3537))/length(carrieradditiont);
            Cl37i=Cl37i+carrieraddition/1000*NA/massspk*(1/(1+carrier3537))/length(carrieradditiont);
        end
        
        % evaporation
        if ti>2
            TotCli=TotCli*(1-(dissolved(ti)-dissolved(ti-1))*totalClevap);
            VOLi=VOLi;
            Cl36i=Cl36i*(1-(dissolved(ti)-dissolved(ti-1))*totalClevap);
            Cl35i=Cl35i*(1-(dissolved(ti)-dissolved(ti-1))*totalClevap);
            Cl37i=Cl37i*(1-(dissolved(ti)-dissolved(ti-1))*totalClevap);
            
        end
        
        % store partial calulations
        TotCl(ti)=TotCli;
        Cl36(ti)=Cl36i;
        Cl35(ti)=Cl35i;
        Cl37(ti)=Cl37i;
        VOL(ti)=VOLi;
    end
    
    % final results
    f2a=TotCl(end);
    f2b=Cl36(end)./(TotCl(end)/1000*NA/massnat+1);
    f2c=Cl35(end)./(Cl37(end)+1);
    
    subplot(4,3,test)
    hold on
    plot(t,TotCl,'--r')
    ylabel('Cl (mg in solution)')
    ylim([0 rockCl*rockmass+carrieraddition])
    xlim([min(t) max(t)])
    set(gca,'xtick',[])
    box on
    text(max(t),rockCl*rockmass+carrieraddition,[num2str(round(f2a/f1a*100,0)) '% yield'],'Color','r',...
        'HorizontalAlignment','right','VerticalAlignment','top');
    
    subplot(4,3,test+3)
    hold on
    plot(t,Cl36./(TotCl/1000*NA/massnat+1),'--r')
    ylabel('[^{36}Cl/Cl]')
    ylim([0 rock36Cl*rockmass/(rockCl*rockmass/1000*NA/massnat)])
    xlim([min(t) max(t)])
    set(gca,'xtick',[])
    box on
    text(max(t),rock36Cl*rockmass/(rockCl*rockmass/1000*NA/massnat),[num2str(round(f2b/f1b*100,0)) '% of expected'],'Color','r',...
        'HorizontalAlignment','right','VerticalAlignment','top');
    
    subplot(4,3,test+3*2)
    hold on
    plot(t,Cl35./(Cl37+1),'--r')
    ylabel('[^{35}Cl/^{37}Cl]')
    ylim([0 22])
    xlim([min(t) max(t)])
    set(gca,'xtick',[])
    box on
    text(max(t),22,[num2str(round(f2c/f1c*100,0)) '% of expected'],'Color','r',...
        'HorizontalAlignment','right','VerticalAlignment','top');
    
    
    subplot(4,3,test+3*3)
    hold on
    plot(t,TotClref-TotCl,'--r')
    ylabel('Cl fumed out (mg)')
%     ylim([0 max(TotClref-TotCl)*1.2])
    ylim([0 1.2])
    xlim([min(t) max(t)])
    set(gca,'xtick',[])
    xlabel('-- time -->')
    box on
    disp([num2str(TotCl(81)/TotClref(81)*100) ' yield after dissolution'])
    

    for x=carrieradditiont
        plot([x,x],[0,0.5],'-k')
        text(x,0.5,'Spike','HorizontalAlignment','center','VerticalAlignment','bottom');
    end
    plot([startdissolutiont,enddissolutiont],[1,1],'-k')
    text((startdissolutiont+enddissolutiont)/2,1,...
        'Dissolution','HorizontalAlignment','center','VerticalAlignment','middle',...
        'BackgroundColor','w');
end
