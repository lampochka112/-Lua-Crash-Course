-- Функция для вычисления факториала
function factorial(n)
    if n == 0 then
        return 1
    else
        return n * factorial(n - 1)
    end
end

-- Запрос числа у пользователя
io.write("Введите число для вычисления факториала: ")
local num = tonumber(io.read())

-- Проверка ввода и вывод результата
if num then
    if num >= 0 then
        print("Факториал числа " .. num .. " равен " .. factorial(num))
    else
        print("Ошибка: факториал отрицательного числа не определён.")
    end
else
    print("Ошибка: введено не число!")
end