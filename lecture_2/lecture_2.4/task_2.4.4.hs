-- Напишите функцию с сигнатурой:

-- avg :: Int -> Int -> Int -> Double
-- вычисляющую среднее значение переданных в нее аргументов:

-- GHCi> avg 3 4 8
-- 5.0

avg :: Int -> Int -> Int -> Double
avg a b c = (conv a + conv b + conv c) / 3
  where conv a = fromInteger (toInteger a) :: Double
