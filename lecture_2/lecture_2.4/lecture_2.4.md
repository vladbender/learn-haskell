
# Стандартные классы типов

## Расширение класса (Class Extention)

Расширение классов типов - некий эквивалент наследования интерфейсов.

```haskell
class Eq a where
  (==), (/=) :: a -> a -> Bool
  x == y = not (x /= y)
  x /= y = not (x == y)

class (Eq a) => Ord a where
  (<), (<=), (>=), (>) :: a -> a -> Bool
  max, min :: a -> a -> a
  compare :: a -> a -> Ordering
```

Класс типов `Ord` параметризован параметром `a` и имеет контекст `Eq a`. Это означает, что класс типов `Ord` расширяет класс типов `Eq`. Для того, чтобы объявить тип представителем класса типов `Ord`, надо объявить его представителем `Eq`.

Класс типов `Ord` объявлен в стандартной библиотеке. Позволяет сравнивать элементы.

Функция `compare` возвращает некоторый тип `Ordering`, который является перечислением:
```haskell
Prelude> :i Ordering
data Ordering = LT | EQ | GT
```

Минимальное полное определение класса `Ord` - определить функцию `compare` или `<=`.

Допустимо множественное расширение:
```haskell
class (Eq a, Printable a) => MyClass a where
...
```

## Задача 1

Пусть существуют два класса типов `KnownToGork` и `KnownToMork`, которые предоставляют методы `stomp` (`stab`) и `doesEnrageGork` (`doesEnrageMork`) соответственно:
```haskell
class KnownToGork a where
    stomp :: a -> a
    doesEnrageGork :: a -> Bool

class KnownToMork a where
    stab :: a -> a
    doesEnrageMork :: a -> Bool
```
Класс типов `KnownToGorkAndMork` является расширением обоих этих классов, предоставляя дополнительно метод `stompOrStab`:
```haskell
class (KnownToGork a, KnownToMork a) => KnownToGorkAndMork a where
    stompOrStab :: a -> a
```
Задайте реализацию по умолчанию метода `stompOrStab`, которая вызывает метод `stomp`, если переданное ему значение приводит в ярость Морка; вызывает `stab`, если оно приводит в ярость Горка и вызывает сначала `stab`, а потом `stomp`, если оно приводит в ярость их обоих. Если не происходит ничего из вышеперечисленного, метод должен возвращать переданный ему аргумент.

**Ответ:**
```haskell
class (KnownToGork a, KnownToMork a) => KnownToGorkAndMork a where
  stompOrStab :: a -> a
  stompOrStab a | doesEnrageMork a && doesEnrageGork a = stomp (stab a)
                | doesEnrageMork a = stomp a
                | doesEnrageGork a = stab a
                | otherwise = a
```

Код задачи можно загрузить [из файла](./task_2.4.1.hs).

## Классы Show и Read

Класс `Printable`, реализуемый ранее в рамках задач, является полезным. Подобный класс типов есть в стандартной библиотеке. Называется он **`Show`**. Основной метод - `show`:
```haskell
Prelude> :t show
show :: Show a => a -> String
Prelude> show "hello"
"\"hello\""
Prelude> show 5
"5"
Prelude> show 5.0
"5.0"
Prelude> show True
"True"
Prelude> show [1,2,3]
"[1,2,3]"
Prelude> show (1, True)
"(1,True)"
```

За обратную процедуру отвечает класс типов `Read`, основная функция - `read`:
```haskell
Prelude> :t read
read :: Read a => String -> a
Prelude> read "5"
*** Exception: Prelude.read: no parse
```
Видно, что при попытке просто написать `read "5"` выводится сообщение об ошибке. Это потому, что `read` **полиморфна по возвращаемому значению**. В таком случае мы должны снять полиморфизм и указать тип:
```haskell
Prelude> read "5" :: Int
5
Prelude> read "5" :: Double
5.0
Prelude> read "[1,2,3]" :: [Int]
[1,2,3]
```

`read` определена не в классе типов `Read`, а вне его. При этом она не всегда удобна. Невозможно разобрать строки вида `"5 files"`. Поэтому в классе типов `Read` определена функция `reads`:
```haskell
Prelude> reads "5 files" :: [(Int, String)]
[(5," files")]
```
Начало строки интерпретируется как тип `Int`, а остаток возвращается как второй элемент кортежа. Кортеж обернут в список, т.к. возможны следующие случаи: возникла ошибка, тогда вернется пустой список; разбор неоднозначный, вернется несколько результатов.

## Задача 2

Имея функцию `ip = show a ++ show b ++ show c ++ show d` определите значения `a`, `b`, `c`, `d` так, чтобы добиться следующего поведения:
```haskell
GHCi> ip
"127.224.120.12"
```

**Ответ:**
```haskell
a = 127.2
b = 24.1
c = 20.1
d = 2
```

## Классы Enum и Bounded

Многие встроенные типами являются типами перечислениями. Значения этих типов как будто можно выписать подряд в строчку, каждое последующее будет больше предыдущего.

Для этого существует класс типов `Enum`:
```haskell
class Enum a where
  succ, pred :: a -> a
  toEnum :: Int -> a
  fromEnum :: a -> Int
```
Это не все функции класса типов `Enum`.

Пример использования:
```haskell
*Main> succ 10
11
*Main> pred 10
9
*Main> succ 'a'
'b'
*Main> pred 'a'
'`'
*Main> fromEnum 'a'
97
*Main> toEnum 97
*** Exception: Prelude.Enum.().toEnum: bad argument
*Main> toEnum 97 :: Int
97
*Main> toEnum 97 :: Char
'a'
```
Функция `toEnum` полиморфна по возвращаемому значению, она требует разрешения полиморфизма при вызове.

Для указания верхней и нижней границы типов служит класс `Bounded`:
```haskell
class Bounded a where
  minBound, maxBound :: a
```
Он существует для разрешения такой проблемы:
```haskell
*Main> succ True
*** Exception: Prelude.Enum.Bool.succ: bad argument
```

Поэтому мы можем узнать границы, прежде чем брать следующее или предыдущее значение:
```haskell
*Main> maxBound :: Bool
True
*Main> minBound :: Bool
False
*Main> maxBound :: Char
'\1114111'
*Main> minBound :: Char
'\NUL'
*Main> maxBound :: Int
9223372036854775807
*Main> minBound :: Int
-9223372036854775808
```

Тип `Integer` является перечислением, но не является `Bounded`, т.к. в нем бесконечное число элементов и границы отсутствуют:
```haskell
*Main> succ (1 :: Integer)
2
*Main> maxBound :: Integer
<interactive>:30:1: error:
    • No instance for (Bounded Integer)
        arising from a use of ‘maxBound’
    • In the expression: maxBound :: Integer
      In an equation for ‘it’: it = maxBound :: Integer
```

## Задача 3

Реализуйте класс типов
```haskell
class SafeEnum a where
  ssucc :: a -> a
  spred :: a -> a
```
обе функции которого ведут себя как succ и pred стандартного класса Enum, однако являются тотальными, то есть не останавливаются с ошибкой на наибольшем и наименьшем значениях типа-перечисления соответственно, а обеспечивают циклическое поведение. Ваш класс должен быть расширением ряда классов типов стандартной библиотеки, так чтобы можно было написать реализацию по умолчанию его методов, позволяющую объявлять его представителей без необходимости писать какой бы то ни было код. Например, для типа Bool должно быть достаточно написать строку
```haskell
instance SafeEnum Bool
```
и получить возможность вызывать
```haskell
GHCi> ssucc False
True
GHCi> ssucc True
False
```

**Ответ:**
```haskell
class (Eq a, Enum a, Bounded a) => SafeEnum a where
  ssucc :: a -> a
  ssucc a | a == maxBound = minBound
          | otherwise = succ a

  spred :: a -> a
  spred a | a == minBound = maxBound
          | otherwise = pred a
```

Код задачи можно загрузить [из файла](./task_2.4.3.hs).

## Класс Num и его расширения

```haskell
class Num a where
  (+), (-), (*) :: a -> a -> a
  negate :: a -> a -- Унарный минус транслируется в вызов этой функции
  abs :: a -> a
  signum :: a -> a -- Знак числа
  fromInteger :: Integer -> a
  
  -- Единственные реализации по умолчанию (рекурсивные)
  x - y = x + negate y
  negate x = 0 - x
```

Неявные законы для классов типов (компилятор их не может проверять, но они должны выполняться чтобы поведение было предсказуемым):
```haskell
abs x * signum x == x
```

Исследуем `Num` и его расширения:
```haskell
Prelude> :i Num
class Num a where
  (+) :: a -> a -> a
  (-) :: a -> a -> a
  (*) :: a -> a -> a
  negate :: a -> a
  abs :: a -> a
  signum :: a -> a
  fromInteger :: Integer -> a
  {-# MINIMAL (+), (*), abs, signum, fromInteger, (negate | (-)) #-}
        -- Defined in ‘GHC.Num’
instance Num Word -- Defined in ‘GHC.Num’
instance Num Integer -- Defined in ‘GHC.Num’
instance Num Int -- Defined in ‘GHC.Num’
instance Num Float -- Defined in ‘GHC.Float’
instance Num Double -- Defined in ‘GHC.Float’
```

Целочисленное деление, класс типов `Integral`:
```haskell
Prelude> :i Integral
class (Real a, Enum a) => Integral a where
  quot :: a -> a -> a
  rem :: a -> a -> a
  div :: a -> a -> a
  mod :: a -> a -> a
  quotRem :: a -> a -> (a, a)
  divMod :: a -> a -> (a, a)
  toInteger :: a -> Integer
  {-# MINIMAL quotRem, toInteger #-}
        -- Defined in ‘GHC.Real’
instance Integral Word -- Defined in ‘GHC.Real’
instance Integral Integer -- Defined in ‘GHC.Real’
instance Integral Int -- Defined in ‘GHC.Real’
```

`quot`, `rem` - такое же целочисленное деление, как и `div`, `mod`, но на отрицательных числах работают иначе.

Полноценное деление, класс типов `Fractional`:
```haskell
Prelude> :i Fractional
class Num a => Fractional a where
  (/) :: a -> a -> a
  recip :: a -> a
  fromRational :: Rational -> a
  {-# MINIMAL fromRational, (recip | (/)) #-}
        -- Defined in ‘GHC.Real’
instance Fractional Float -- Defined in ‘GHC.Float’
instance Fractional Double -- Defined in ‘GHC.Float’
```

Стандартные математические функции - класс типов `Floating`:
```haskell
Prelude> :i Floating
class Fractional a => Floating a where
  pi :: a
  exp :: a -> a
  log :: a -> a
  sqrt :: a -> a
  (**) :: a -> a -> a
  logBase :: a -> a -> a
  sin :: a -> a
  cos :: a -> a
  tan :: a -> a
  asin :: a -> a
  acos :: a -> a
  atan :: a -> a
  sinh :: a -> a
  cosh :: a -> a
  tanh :: a -> a
  asinh :: a -> a
  acosh :: a -> a
  atanh :: a -> a
  GHC.Float.log1p :: a -> a
  GHC.Float.expm1 :: a -> a
  GHC.Float.log1pexp :: a -> a
  GHC.Float.log1mexp :: a -> a
  {-# MINIMAL pi, exp, log, sin, cos, asin, acos, atan, sinh, cosh,
              asinh, acosh, atanh #-}
        -- Defined in ‘GHC.Float’
instance Floating Float -- Defined in ‘GHC.Float’
instance Floating Double -- Defined in ‘GHC.Float’
```

Функции, связанные с округлением до целого - класс типов `RealFrac`:
```haskell
Prelude> :i RealFrac
class (Real a, Fractional a) => RealFrac a where
  properFraction :: Integral b => a -> (b, a)
  truncate :: Integral b => a -> b
  round :: Integral b => a -> b
  ceiling :: Integral b => a -> b
  floor :: Integral b => a -> b
  {-# MINIMAL properFraction #-}
        -- Defined in ‘GHC.Real’
instance RealFrac Float -- Defined in ‘GHC.Float’
instance RealFrac Double -- Defined in ‘GHC.Float’
```

Внутреннее представление чисел с плавающей точкой - класс типов `RealFloat`:
```haskell
Prelude> :i RealFloat
class (RealFrac a, Floating a) => RealFloat a where
  floatRadix :: a -> Integer
  floatDigits :: a -> Int
  floatRange :: a -> (Int, Int)
  decodeFloat :: a -> (Integer, Int)
  encodeFloat :: Integer -> Int -> a
  exponent :: a -> Int
  significand :: a -> a
  scaleFloat :: Int -> a -> a
  isNaN :: a -> Bool
  isInfinite :: a -> Bool
  isDenormalized :: a -> Bool
  isNegativeZero :: a -> Bool
  isIEEE :: a -> Bool
  atan2 :: a -> a -> a
  {-# MINIMAL floatRadix, floatDigits, floatRange, decodeFloat,
              encodeFloat, isNaN, isInfinite, isDenormalized, isNegativeZero,
              isIEEE #-}
        -- Defined in ‘GHC.Float’
instance RealFloat Float -- Defined in ‘GHC.Float’
instance RealFloat Double -- Defined in ‘GHC.Float’
```

## Задача 4

Напишите функцию с сигнатурой:
```
avg :: Int -> Int -> Int -> Double
```
вычисляющую среднее значение переданных в нее аргументов:
```
GHCi> avg 3 4 8
5.0
```

**Ответ:**
```haskell
avg :: Int -> Int -> Int -> Double
avg a b c = (conv a + conv b + conv c) / 3
  where conv a = fromInteger (toInteger a) :: Double
```

Код задачи можно загрузить [из файла](./task_2.4.4.hs).
