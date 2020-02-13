clear all;

if ~isfile('character_info.mat')
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
    save('character_info.mat', 'char_imgs', 'char_labels')
else
    load('character_info.mat')
end

for k=1:size(char_imgs, 2)
    folder = strcat('split_images\',char_labels{k});
    mkdir(folder);
    baseFileName = sprintf('%s.png', string(k));
    fullFileName = fullfile(folder, baseFileName);
    imwrite(char_imgs{k}, fullFileName);
end


function [img1, img2, img3, img4] = charSeperator(img)
    mask = img>=120;
    [x,y] = find(mask==1);
    [idx,c] = kmeans(y,4);
    c = sort(c);
    m1 = round(c(1)/2);
    m2 = round((c(1)+c(2))/2);
    m3 = round((c(2)+c(3))/2);
    m4 = round((c(3)+c(4))/2);
    m5 = round((c(4)+size(img,2))/2);
    img1 = img(:,m1:m2);
    img2 = img(:,m2:m3);
    img3 = img(:,m3:m4);
    img4 = img(:,m4:m5);
end
