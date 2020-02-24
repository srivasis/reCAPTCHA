clear all;

if ~isfile('character_info_SVM.mat')
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
        images_jpg = [images_jpg, img1];
        labels_jpg = [labels_jpg, imglabel(1)];
        images_jpg = [images_jpg, img2];
        labels_jpg = [labels_jpg, imglabel(2)];
        images_jpg = [images_jpg, img3];
        labels_jpg = [labels_jpg, imglabel(3)];
        images_jpg = [images_jpg, img4];
        labels_jpg = [labels_jpg, imglabel(4)];
    end
    char_imgs = [char_imgs,images_png];
    char_labels = [char_labels, labels_png];
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
    char_imgs = [char_imgs,images_jpg];
    char_labels = [char_labels, labels_jpg];
   
    % Export grey scale images and their labels to file
    save('character_info_SVM.mat', 'char_imgs', 'char_labels')
else
    load('character_info_SVM.mat')
end

for k=1:size(char_imgs, 2)
    folder = strcat('split_images_SVM/',char_labels{k});
    if ~isfolder(folder)
        mkdir(folder);
    end
    baseFileName = sprintf('%s.png', string(k));
    fullFileName = fullfile(folder, baseFileName);
    imwrite(char_imgs{k}, fullFileName);
end

function [img1, img2, img3, img4] = charSeperator(img)
    mask = img>=120;
    y = sum(255-mask.*255);
    bar(y);
    lm = islocalmin(y);
    w = -9999*(lm-1);
    [v,i] = mink(y+w,3);
    i = sort(i);
    img1 = imresize(img(:,1:i(1)),[24,18]);
    img2 = imresize(img(:,i(1):i(2)),[24,18]);
    img3 = imresize(img(:,i(2):i(3)),[24,18]);
    img4 = imresize(img(:,i(3):size(img,2)),[24,18]);
end