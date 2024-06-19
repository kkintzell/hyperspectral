clear
% reset random number generator
rng(0)

% generate sediment data set
data1 = randn(60,2);
data1(:,1) = 3.4 + 1.2*data1(:,1);
data1(:,2) = 1.7 + 0.4*data1(:,2);

data2 = randn(60,2);
data2(:,1) = 5.5 + 1.8*data1(:,1);
data2(:,2) = 2.9 + 0.6*data1(:,2);

data3 = randn(60,2);
data3(:,1) = 3.0 + 1.8*data1(:,1);
data3(:,2) = 0.3 + 1.2*data1(:,2);

% create character array for measurement labels; create 60 copies of each
% string (grante) and store in classes
classes(1:60,1:9) = repmat('Granite_1',60,1);
classes(61:120,1:9) = repmat('Granite_2',60,1);
classes(121:180,1:9) = repmat('Granite_3',60,1);

% concatenate variables to a single variable
data = [data1(:,1:2);data2(:,1:2);data3(:,1:2)];
% save in file
save granite.mat

clear
load granite.mat

% create a linear discriminant analysis classifier
cls = ClassificationDiscriminant.fit(data, classes);

% list layers of cls
cls

% list discrimanant type, class names, parameters
cls.Coeffs

% extract parameters of classification boundaries
K1 = cls.Coeffs(2,3).Const;
L1 = cls.Coeffs(2,3).Linear;
K2 = cls.Coeffs(1,2).Const;
L2 = cls.Coeffs(1,2).Linear;

% store the bivariate means
Mu1 = cls.Mu(1,:);
Mu2 = cls.Mu(2,:);
Mu3 = cls.Mu(3,:);

% display result in a graphic
h1 = axes('Box', 'On');
hold on

line(data1(:,1),data1(:,2),...
    'Marker','.','MarkerSize',8,...
    'LineStyle','None','MarkerEdgeColor','r')

line(data2(:,1),data1(:,2),...
    'Marker','.','MarkerSize',8,...
    'LineStyle','None','MarkerEdgeColor','b')

line(data3(:,1),data3(:,2),...
    'Marker','.','MarkerSize',8,...
    'LineStyle','None','MarkerEdgeColor','m')

line(Mu1(:,1),Mu1(:,2),...
    'Marker','o','MarkerEdgeColor','k',...
    'MarkerSize',8,'MarkerFaceColor','k')

line(Mu2(:,1),Mu2(:,2),...
    'Marker','o','MarkerEdgeColor','k',...
    'MarkerSize',8,'MarkerFaceColor','k')

line(Mu3(:,1),Mu3(:,2),...
    'Marker','o','MarkerEdgeColor','k',...
    'MarkerSize',8,'MarkerFaceColor','k')

h2 = legend('Granite 1','Granite 2','Granite 3',...
    'Location','SouthEast');

set(h2,'Box','Off')

f1 = @(x1,x2) K1+L1(1)*x1+L1(2)*x2
h3 = ezplot(f1,[-5 12 0 5]);
set(h3,'Color', 'k')

f2 = @(x1,x2) K2+L2(1)*x1+L2(2)*x2
h4 = ezplot(f2,[-5 10 0 5]);
set(h4,'Color', 'k')

title('Discriminant Analysis')

hold off


