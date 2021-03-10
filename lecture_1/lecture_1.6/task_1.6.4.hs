
{-
Реализуйте функцию, находящую значение определённого интеграла
от заданной функции `f` на заданном интервале `[a,b]`
методом трапеций. (Используйте равномерную сетку;
достаточно 1000 элементарных отрезков.)

GHCi> integration sin pi 0
-2.0

Результат может отличаться от -2.0, но не более чем на 1e-4.
-}

module Integration where

integration :: (Double -> Double) -> Double -> Double -> Double
integration f a b
  | a == b = 0
  | b < a = - sum b (b - delta) 0 step
  | otherwise = sum a (a + delta) 0 step
  where
    step = 1000
    delta = abs $ (b - a) / step
    sum x0 x1 result 0 = result
    sum x0 x1 result step =
      sum x1 (x1 + delta) (result + (f x0 + f x1) / 2 * (x1 - x0)) (step - 1)

i = integration