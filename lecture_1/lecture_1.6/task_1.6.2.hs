
-- Реализуйте функцию seqA, находящую элементы следующей рекуррентной последовательности
-- a_0 = 1
-- a_1 = 2
-- a_2 = 3
-- a_{k+3} = a_{k+2} + a_{k+1} - 2 a_{k}
-- То есть: a_{k} = a_{k-1} + a_{k-2} - 2 a_{k-3}
-- Попытайтесь найти эффективное решение.
-- 1, 2, 3, 3, 2, -1, -5, -10, -13, -13, -6, 7, 27

seqA :: Integer -> Integer
seqA n =
  let
    helper first second third 0 = first
    helper first second third 1 = second
    helper first second third 2 = third
    helper first second third k =
      helper second third (third + second - 2 * first) (k - 1)
  in helper 1 2 3 n

{-
Надо рекурентно определить функцию через саму себя,
передавая при этом предыдущие значения
-}