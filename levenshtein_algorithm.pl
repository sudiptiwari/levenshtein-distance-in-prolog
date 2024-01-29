% Refers to the video: https://www.youtube.com/watch?v=d-Eq6x1yssU

% Wrapper predicate to convert the strings into lists of character codes
levenshtein_dist(S1, S2, D) :-
    string_codes(S1, Cs1), % convert string to list of character codes
    string_codes(S2, Cs2),
    % ld/3, defined below, does the actual work to calculate Levenshtein Distance
    ld(Cs1, Cs2, D).

% cache the code list arguments normally, but just keep the minimum value found for distance
:- table ld(_,_, min).

ld([], Cs, D) :-
    length(Cs, D). % return length of second if first is empty
ld(Cs, [], D) :-
    length(Cs, D). % return length of first if second is empty

% drop first character of left string (Deletion)
ld([_H_Cs1|T_Cs1], Cs2, D) :-
    ld(T_Cs1, Cs2, D0), % recursive call using Tail of Cs1 and whole string of Cs2
    D is D0 + 1.

% drop first character of right string (Insertion)
ld(Cs1, [_H_Cs2|T_Cs2], D) :-
    ld(Cs1, T_Cs2, D0), % recursive call using whole string of Cs1 and Tail of Cs2
    D is D0 + 1.

% ( Substitution )
ld([H_Cs1|T_Cs1], [H_Cs2|T_Cs2], D) :-
    (  H_Cs1 == H_Cs2 ->  K = 0; K = 1), % if first character is same, add 0, else add 1 to distance.
    ld(T_Cs1, T_Cs2, D0),
    D is D0 + K.

find_levenshtein_distance(String1, String2, Distance) :-
    levenshtein_dist(String1, String2, Distance).

% query like this:
% ?- find_levenshtein_distance("hat","can",Distance).
