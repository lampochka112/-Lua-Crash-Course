-- Класс для работы с рекордами (ООП через метатаблицы)
local HighScore = {}
HighScore.__index = HighScore

function HighScore.new(filename)
    local self = setmetatable({}, HighScore)
    self.filename = filename
    self.scores = {}
    self:load()
    return self
end

-- Загрузка рекордов из файла
function HighScore:load()
    local file = io.open(self.filename, "r")
    if not file then return end

    for line in file:lines() do
        local name, score = line:match("(.+):(%d+)")
        if name and score then
            table.insert(self.scores, {
                name = name,
                score = tonumber(score)
            })
        end
    end
    file:close()
end

-- Сохранение рекордов в файл
function HighScore:save()
    local file = io.open(self.filename, "w")
    if not file then return false end

    for _, record in ipairs(self.scores) do
        file:write(record.name .. ":" .. record.score .. "\n")
    end
    file:close()
    return true
end

-- Добавление нового рекорда
function HighScore:add(name, score)
    table.insert(self.scores, { name = name, score = score })
    table.sort(self.scores, function(a, b) return a.score > b.score end)
    self:save()
end

-- Игра "Угадай число"
local function playGame(highScores)
    math.randomseed(os.time())
    local secret = math.random(1, 100)
    local attempts = 0

    print("\nУгадай число от 1 до 100!")

    -- Корутина для асинхронного ввода
    local function getInput()
        coroutine.yield()
        return tonumber(io.read())
    end

    local co = coroutine.create(getInput)

    while true do
        io.write("Твоя попытка: ")
        local success, guess = coroutine.resume(co)
        if not guess then
            print("Ошибка: введите число!")
            coroutine.resume(co)
        else
            attempts = attempts + 1
            if guess == secret then
                print(("Победа! Ты угадал за %d попыток."):format(attempts))
                io.write("Введи своё имя для таблицы рекордов: ")
                local name = io.read()
                highScores:add(name, attempts)
                break
            elseif guess < secret then
                print("Загаданное число больше.")
            else
                print("Загаданное число меньше.")
            end
        end
    end
end

-- Главное меню
local function main()
    local highScores = HighScore.new("highscores.txt")

    while true do
        print("\n1. Новая игра")
        print("2. Таблица рекордов")
        print("3. Выход")
        io.write("Выбери вариант: ")

        local choice = tonumber(io.read())
        if not choice then
            print("Ошибка: введи число!")
        elseif choice == 1 then
            playGame(highScores)
        elseif choice == 2 then
            print("\n=== ТОП-5 РЕКОРДОВ ===")
            for i, record in ipairs(highScores.scores) do
                if i <= 5 then
                    print(("%d. %s — %d попыток"):format(i, record.name, record.score))
                end
            end
        elseif choice == 3 then
            break
        else
            print("Неизвестный вариант!")
        end
    end
end

-- Запуск
main()