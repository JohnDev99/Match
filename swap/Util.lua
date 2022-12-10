function GenerateQuads(texture, width, height)
    local sheetWidth = texture:getWidth() / width
    local sheetHeight = texture:getHeight() / height

    local quadCounter = 1
    local quads = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            --Gerar um quad e armazena-lo na tabela por ordem
            quads[quadCounter] = love.graphics.newQuad(x * width, y * height, width, height, texture:getDimensions())
            quadCounter = quadCounter + 1
        end
    end
    return quads
end

function GenerateTileQuads(atlas)
    --Dividir o meu spritesheet em varios quads
    --Cada quad(bloco) vai ter 6 variantes de cada cor
    local tiles = {}

    local x = 0
    local y = 0
    local counter = 1

    --Por cada linha
    for row = 1, 9 do
        --Spritesheet com 2 colunas cada uma com 6 variantes de uma cor
        for i = 1, 2 do
            --Iniciar uma tabela vazia
            tiles[counter] = {}

            --Por cada coluna
            for col = 1, 6 do
                --Inserir um tile naquela posiçao
                table.insert(tiles[counter], love.graphics.newQuad(x, y, 32, 32, atlas:getDimensions()))
                x = x + 32 --cada tile tem 32 de width
            end
            counter = counter + 1 --incrementar contador de coluna 
            --So existe 2 colunas de 6
        end
        
        --passar para a proxima linha, para o primeiro elemento da respetiva coluna
        y = y + 32
        x = 0
    end
    return tiles
end

--Tabela Recursiva CREDITO DO AUTOR
--coronalabs.com 

function print_r( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
