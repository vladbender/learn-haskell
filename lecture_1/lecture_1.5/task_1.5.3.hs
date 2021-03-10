-- ... -2 -1 0 1 2 3 4 5 6  7 ...
-- ... -1  1 0 1 1 2 3 5 8 13 ...
-- Fn = Fn-1 + Fn-2
-- ~> Fn-2 = Fn - Fn-1
-- ~> Fn = Fn+2 - Fn+1
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n | n > 0 = fibonacci (n - 1) + fibonacci (n - 2)
            | n < 0 = fibonacci (n + 2) - fibonacci (n + 1)
-- -1 = f(1) - f(0) = 1 - 0
-- -2 = f(0) - f(-1) = 0 - 1 = -1
-- -3 = f(-1) - f(-2) = 0 - -1 = 1
-- -4 = f(-2) - f(-3) = ...