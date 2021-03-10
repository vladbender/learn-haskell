-- Сделайте тип пары представителем класса типов Printable,
-- реализованного вами в предыдущей задаче, обеспечив следующее поведение:
-- 
-- GHCi> toString (False,())
-- "(false,unit type)"
-- GHCi> toString (True,False)
-- "(true,false)"


-- Это объявление Printable я продублировал чтобы можно было запустить код загрузив всего один модуль

class Printable a where
  toString :: a -> String

instance Printable () where
  toString () = "unit type"

instance Printable Bool where
  toString True = "true"
  toString False = "false"

-- Само решение задачи:

instance (Printable a, Printable b) => Printable (a,b) where
  toString p = "(" ++ toString (fst p) ++ "," ++ toString (snd p) ++ ")"