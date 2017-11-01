clear all;
close all;
clc

fileFolder=fullfile('');
dicomlist = dir(fullfile(fileFolder,'000000*'));

for cnt = 138 : 138    
    I{cnt} = dicomread(fullfile(fileFolder,dicomlist(cnt).name));
    info=dicominfo(dicomlist(cnt).name); % image info
    Y=imadjust(I{cnt});
    %figure, imshow(Y,[])
    %title('Imadjust')
    
    for i=1:info.Rows
        for j=1:info.Columns
            if Y(i,j)>=5817 && Y(i,j)<=65535
                ROI(i,j)=Y(i,j);
            else
                ROI(i,j)=0;
            end
        end
    end
    %figure, imshow(ROI,[])
    %title('ROIs')
    
    ROI1=imadjust(ROI);
    figure, imshow(ROI1,[])
    title('Imadust ROIs')
    
    [x,y]=ginput(6) %graphical input
    h=roipoly(ROI1,x,y);
        
    anser=size(h);
    A1=double(h);
    figure,imshow(A1)
      
    k=1;
    while k==1
        figure;imshow(ROI1)
        title('Imadjust ROIs') %ROI1-imadjust(ROI)
        [x,y]=ginput(6) %graphical input
        h=roipoly(ROI1,x,y);
        anser=size(h);
        A2=double(h);
        figure,imshow(h)
        A=A1+A2;
        %figure,imshow(A)
        
        
        %act_conc=measured_activity=Pixel value(mean)/Image Scale Factor
        %Pixel value(mean)=sum(sum(h))/anser(1)*anser(2)
        %Image Scale Factor=RescaleSlope*10^(-6)
        
        injected_activity=3.7*10^6;
        act_conc_max=(sum(sum(h)))/info.RescaleSlope*10^(-6); %Pixel value(max)=(sum(sum(h)))
        SUVmax=act_conc_max*info.PatientWeight/injected_activity;
        disp(SUVmax);        
%       act_conc_mean=(sum(sum(h))/anser(1)*anser(2))/info.RescaleSlope*10^(-6);
%       SUVmean=act_conc_mean*info.PatientWeight/injected_activity;
%       disp(SUVmean);

        T2max=0.307*SUVmax+0.588;
        disp(T2max);
%       T2mean=0.307*SUVmean+0.588;
%       disp(T2mean);
        
        for i=1:info.Rows
            for j=1:info.Columns
                if A(i,j)>=T2max
                    L(i,j)=1;
                else
                    L(i,j)=0;
                end
                B(i,j)=A(i,j).*Y(i,j);
            end
        end
        k=k+1;
    end
%    figure;imshow(L,[])
%    title('Binary image after thresolding')
%    figure;imshow(B,[])
%   title('Initial image after thresholding'')
    
end
subplot(2,2,1);imshow(Y,[])
title('Initial image-Imadjust')
subplot(2,2,2);imshow(ROI1,[])
title('Imadjust ROIs')
subplot(2,2,3);imshow(L,[])
title('Binary image after thresolding')
subplot(2,2,4);imshow(B,[])
title('Initial image after thresholding')
