import 

% read the 5 Chinese music sound from the sample;
[y,Fs] = audioread('DIZI.wav');
[y_guqin,Fs_guqin] = audioread('Guqin.wav');
[y_matouqin,Fs_matouqin] = audioread('Matouqin.wav');
[y_drum,Fs_drum] = audioread('ChineseDrum.wav');
[y_wood,Fs_wood] = audioread('Wood.wav');

% cut a piece of 20, 000 samples
x = y(200718:200718+20000); % Cut a piece of y and store it into x. for Dizi.
x_guqin = y_guqin(10:10+20000); % Cut a piece of Suona and store it into x_suona.
x_matouqin = y_matouqin(10:10+20000); % Cut a piece of Matouqin and store it into x_matouqin.
x_drum = y_drum(10:10+20000, 1); % Cut a piece of drum and store it into x_drum.
x_wood = y_wood(1000:1000+20000, 1); % Cut a piece of wood and store it into x_wood.

% Write and store the cropped sound to a file
filename = 'sound_dizi.wav';
audiowrite(filename,x,Fs);

filename_guqin = 'sound_guqin.wav';
audiowrite(filename_guqin,x_guqin,Fs_guqin);

filename_matouqin = 'sound_matouqin.wav';
audiowrite(filename_matouqin,x_matouqin,Fs_matouqin);

filename_drum  = 'sound_drum.wav';
audiowrite(filename_drum,x_drum,Fs_drum);

filename_wood  = 'sound_wood.wav';
audiowrite(filename_wood,x_wood,Fs_wood);

sound(x,Fs); 
pause(1)  
sound(x_guqin, Fs_guqin);
pause(1)  
sound(x_matouqin, Fs_matouqin);
pause(1)  
sound(x_drum, Fs_drum);
pause(1)  
sound(x_wood, Fs_wood);


% to convert the wavefrom to 20,000 12-bit binary sequence
n = 0;  
m = 12;

x_matrix = [x, x_guqin, x_matouqin, x_drum, x_wood]; % construct a matrix all 5 sound's cropped samples
min_x_matrix = min(x_matrix); % find min for each sound's samples

min_x = min(x); % the minimum number in x vector.

min_x_populate = repmat(min_x_matrix,20001,1);
x_after_submin = x_matrix - min_x_populate; % shift the grpah up to make sure all the numbers are non-negative.


max_x_after_submin = max(x_after_submin); % the maximum number after the shift.

max_x_after_submin_matrix = repmat(max_x_after_submin,20001,1);

x_after_submin_divide = x_after_submin ./ max_x_after_submin_matrix; % for each number, divide them by the maximum number so all the numbers are between 0 and 1.

x_after_submin_divide_multi = x_after_submin_divide.*4095; % multiply each number by 4096, so all the numbers are in the range of [0, 4096].
int_version = uint16(round(x_after_submin_divide_multi));
int_versin_one_column = int_version(:);
d2b = dec2bin(x_after_submin_divide_multi, 12);

