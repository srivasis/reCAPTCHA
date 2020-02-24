clear all;

if ~isfile('character_info_CNN.mat')
    path = "images/easy/";
    files_png = dir(fullfile(path,"*.png"));
    num_of_png_imgs = numel(files_png);
    files_jpg = dir(fullfile(path,"*.jpg"));
    num_of_jpg_imgs = numel(files_jpg);   
    images_png = {};
    labels_png = {};
    images_jpg = {};
    labels_jpg = {};
    char_imgs = {};
    char_labels = {};
    for i = 1:num_of_png_imgs
        filepath = fullfile(path, files_png(i).name);
        str = strsplit(files_png(i).name, '.');
        imglabel = str{1};
        img = rgb2gray(imread(char(filepath)));
        [img1, img2, img3, img4] = charSeperator(img);
        images_png = [images_png, img1];
        labels_png = [labels_png, imglabel(1)];
        images_png = [images_png, img2];
        labels_png = [labels_png, imglabel(2)];
        images_png = [images_png, img3];
        labels_png = [labels_png, imglabel(3)];
        images_png = [images_png, img4];
        labels_png = [labels_png, imglabel(4)];
    end
    for i = 1:num_of_jpg_imgs
        filepath = fullfile(path, files_jpg(i).name);
        str = strsplit(files_jpg(i).name, '.');
        imglabel = str{1};
        img = rgb2gray(imread(char(filepath)));
        [img1, img2, img3, img4] = charSeperator(img);
        images_jpg = [images_jpg, img1];
        labels_jpg = [labels_jpg, imglabel(1)];
        images_jpg = [images_jpg, img2];
        labels_jpg = [labels_jpg, imglabel(2)];
        images_jpg = [images_jpg, img3];
        labels_jpg = [labels_jpg, imglabel(3)];
        images_jpg = [images_jpg, img4];
        labels_jpg = [labels_jpg, imglabel(4)];
    end
 
    path = "images/hard/";
    files_png = dir(fullfile(path,"*.png"));
    num_of_png_imgs = numel(files_png);
    files_jpg = dir(fullfile(path,"*.jpg"));
    num_of_jpg_imgs = numel(files_jpg);
    
    for i = 1:num_of_png_imgs
        filepath = fullfile(path, files_png(i).name);
        str = strsplit(files_png(i).name, '.');
        imglabel = str{1};
        img = rgb2gray(imread(char(filepath)));
        [img1, img2, img3, img4, img5] = charSeperatorHard(img);
        images_png = [images_png, img1];
        labels_png = [labels_png, imglabel(1)];
        images_png = [images_png, img2];
        labels_png = [labels_png, imglabel(2)];
        images_png = [images_png, img3];
        labels_png = [labels_png, imglabel(3)];
        images_png = [images_png, img4];
        labels_png = [labels_png, imglabel(4)];
        images_png = [images_png, img5];
        labels_png = [labels_png, imglabel(5)];
    end
    for i = 1:num_of_jpg_imgs
        filepath = fullfile(path, files_jpg(i).name);
        str = strsplit(files_jpg(i).name, '.');
        imglabel = str{1};
        img = rgb2gray(imread(char(filepath)));
        [img1, img2, img3, img4, img5] = charSeperatorHard(img);
        images_jpg = [images_jpg, img1];
        labels_jpg = [labels_jpg, imglabel(1)];
        images_jpg = [images_jpg, img2];
        labels_jpg = [labels_jpg, imglabel(2)];
        images_jpg = [images_jpg, img3];
        labels_jpg = [labels_jpg, imglabel(3)];
        images_jpg = [images_jpg, img4];
        labels_jpg = [labels_jpg, imglabel(4)];
        images_jpg = [images_jpg, img5];
        labels_jpg = [labels_jpg, imglabel(5)];
    end
    
    char_imgs = [char_imgs, images_png];
    char_labels = [char_labels, labels_png];
    char_imgs = [char_imgs,images_jpg];
    char_labels = [char_labels, labels_jpg];
    
    % Export grey scale images and their labels to file
    save('character_info_CNN.mat', 'char_imgs', 'char_labels')
else
    load('character_info_CNN.mat')
end

for k=1:size(char_imgs, 2)
    folder = strcat('split_images_CNN/',char_labels{k});
    if ~isfolder(folder)
        mkdir(folder);
    end
    baseFileName = sprintf('%s.png', string(k));
    fullFileName = fullfile(folder, baseFileName);
    imwrite(char_imgs{k}, fullFileName);
end

function [img1, img2, img3, img4] = charSeperator(img)
% K-Means

    mask = img>=120;
    [x,y] = find(mask==1);
    [idx,c] = kmeans(y,4);
    c = sort(c);
    m1 = round(c(1)/2);
    m2 = round((c(1)+c(2))/2);
    m3 = round((c(2)+c(3))/2);
    m4 = round((c(3)+c(4))/2);
    m5 = round((c(4)+size(img,2))/2);
    img1 = imresize(img(:,m1:m2),[28,28]);
    img2 = imresize(img(:,m2:m3),[28,28]);
    img3 = imresize(img(:,m3:m4),[28,28]);
    img4 = imresize(img(:,m4:m5),[28,28]);

% Local Minima
%{
    mask = (img >= 120);    
    y = sum(1-mask);
    lm = islocalmin(y);
    w = -9999*(lm-1);
    [v,i] = mink(y+w,3);
    i = sort(i);
    img1 = imresize(img(:,1:i(1)),[28,28]);
    img2 = imresize(img(:,i(1):i(2)),[28,28]);
    img3 = imresize(img(:,i(2):i(3)),[28,28]);
    img4 = imresize(img(:,i(3):size(img,2)),[28,28]);
%}
end

function [img1, img2, img3, img4, img5] = charSeperatorHard(img)
    im_off = img(:,30:size(img,2));
    mask = (im_off >=120).*255;
    x = sum(255-mask);
    b = x>=800;
    im_cut = im_off(:,b);
    p = round(size(im_cut,2)/5);
    img1 = imresize(im_cut(:,1:p),[28,28]);
    img2 = imresize(im_cut(:,p:2*p),[28,28]);
    img3 = imresize(im_cut(:,2*p:3*p),[28,28]);
    img4 = imresize(im_cut(:,3*p:4*p),[28,28]);
    img5 = imresize(im_cut(:,4*p:size(im_cut,2)),[28,28]);
end

