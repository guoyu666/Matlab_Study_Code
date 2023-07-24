[w,fs] = audioread("bluewhalesong.au");

whale = timetable(seconds((0:length(w)-1)'/fs),w);

% To hear, type soundsc(w,fs)