
-- Реализуйте функцию, находящую сумму и количество цифр десятичной записи заданного целого числа.

sum'n'count :: Integer -> (Integer, Integer)
sum'n'count x
    | x == 0 = (0, 1)
    | x < 0 = helper 0 0 (abs x)
    | otherwise = helper 0 0 x
  where
    helper sum count 0 = (sum, count)
    helper sum count num = helper (sum + mod num 10) (count + 1) (div num 10)
