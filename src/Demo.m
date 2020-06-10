% Saliency detection Demo

close all
clc

img = imread('10_Bruce_dataset.jpg');
SM = Saliency(img);

figure,
subplot(121), imagesc(img), axis image, axis off;
subplot(122), imagesc(SM), colormap(gray), axis image, axis off;
