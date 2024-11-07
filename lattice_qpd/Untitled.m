data=qpd_odt_modulation(qpd_data);
fig=figure(1);
clf
t=linspace(0,150,100);
co = parula(length(data));
fig.Color='w';

VperV2um1 = 0.000988;  % 2024/10/21
VperV2um2 = 0.000695; % 2024/10/21

subplot(2,6,[1 2 3]);
for kk=1:length(data)   
    t=[data(kk).t];t=t(:);
    y2 = [data(kk).DriftFunc1(t)];
    y2 = y2(:);
    plot(t,movmean(data(kk).X1-y2,10),'.','color',co(kk,:));
    hold on;  
end


for kk = 1:length(data)
    t=[data(kk).t];t=t(:);
    y1 = feval(data(kk).Fit1,t);
    y1 = y1(:);    
    y2 = [data(kk).DriftFunc1(t)];
    y2 = y2(:);
    plot(t,y1-y2,'linewidth',2,'color',co(kk,:));
    hold on     
end

xlabel('total modulation time (ms)');
ylabel('qpd1 x-response (V/V)');

subplot(2,6,4);
errorbar([data.Amp1]/VperV2um1,[data.Amp1Err]/VperV2um1,'o');
hold on;
ylabel('predicted X displacement (um)');

subplot(2,6,5);
errorbar([data.Phi1]/(2*pi),[data.Phi1Err]/(2*pi),'o');
hold on
ylabel('phase 1 (2\pi)');

subplot(2,6,6);
errorbar([data.Sum1],[data.Sum1Err],'o');
hold on
ylabel('photodiode 1 (V)');

subplot(2,6,[1 2 3]+6);
for kk=1:length(data)   
    t=[data(kk).t];t=t(:);
    y2 = [data(kk).DriftFunc2(t)];
    y2 = y2(:);
    plot(t,movmean(data(kk).X2-y2,10),'.','color',co(kk,:));
    hold on;  
end

for kk = 1:length(data)
    t=[data(kk).t];t=t(:);
    y1 = feval(data(kk).Fit2,t);
    y1 = y1(:);    
    y2 = [data(kk).DriftFunc2(t)];
    y2 = y2(:);
    plot(t,y1-y2,'linewidth',2,'color',co(kk,:));
    hold on     
end
xlabel('total modulation time (ms)');
ylabel('qpd1 x-response (V/V)');

subplot(2,6,4+6);
errorbar([data.Amp2]/VperV2um2,[data.Amp2Err]/VperV2um2,'o');
hold on
ylabel('predicted X displacement (um)');

subplot(2,6,5+6);
errorbar([data.Phi2]/(2*pi),[data.Phi2Err]/(2*pi),'o');
hold on
ylabel('phase 2 (2\pi)');

subplot(2,6,6+6);
errorbar([data.Sum2],[data.Sum2Err],'o');
hold on
ylabel('photodiode 2 (V)');

D=cov([data(1).X1],[data(1).X2])

