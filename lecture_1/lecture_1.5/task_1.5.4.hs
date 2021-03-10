
fibonacci n | n == 0 = 0
            | n == 1 = 1
            | n > 1 = pos 0 1 n
            | n < 0 = neg 0 1 n

pos prev value 1 = value
pos prev value n = pos (value) (prev + value) (n - 1)

neg prev value (-1) = value
neg prev value n = neg (value) (prev - value) (n + 1)

-- pos 0 1 2 = pos (1) (1) (1)
-- pos 1 1 1 = pos (1) (2) (0)
-- pos 1 2 0 = 3

-- neg 0 1 -1 = 1
-- neg 0 1 -2 = neg (1) (-1) (-1) = -1
-- neg 0 1 -3 = neg (1) (-1) (-2) = neg (-1) (2) (-1) = 2

-- ... -2 -1 0 1 2 3 4 5 6  7 ...
-- ... -1  1 0 1 1 2 3 5 8 13 ...
