
function utils_fetch_sort_keys(tbl)
    local kset = {}
    for k,v in pairs(tbl) do
        table.insert(kset,k)
    end
    table.sort(kset)
    return kset
end

function utils_string_split(str, cut)
    str = str..cut
    local pattern  = '(.-)'..cut
    local res = {}
    for w in string.gmatch(str, pattern) do
        table.insert(res,w)
        --print(w)
    end
    return res
end


function utils_string_split_fixcnt(str, cut, fixcnt)
    local strs = utils_str_split(str,cut)
    while #strs > fixcnt do
        table.remove(strs,#strs)
    end
    while #strs < fixcnt do
        table.insert(strs,'')
    end
    assert(#strs==fixcnt,'fixcnt is error')
    return strs 
end


function utils_dump_table(t)
    if not t or type(t)~='table' then return end
   
    local count = 1 
    local next_layer = {}
    table.insert(next_layer, t)
    while true do 
        if #next_layer == 0 then break end
        local next_t = table.remove(next_layer,1)
        for k,v in pairs(next_t) do 
            if type(v) == 'table' then
                if count > 5 then break end
                count = count + 1
                table.insert(next_layer, v)
            else
                print(k,v)
            end
        end    
    end
end

function imgui_std_horizontal_button_layout(tbl, next_fn, on_click)
    local line_width = imgui.GetContentRegionAvailWidth()
    local cx, cy = imgui.GetCursorPos()
    local layout_x = cx
    do
        local st,v,k
        while true do
            st, v, k = next_fn(tbl, st)
            if st == nil then break end
            if k == nil then k = st end
            if imgui.Button(k) then
                on_click(k,v)
            end
            local iw,ih = imgui.GetItemRectSize()
            layout_x = layout_x + iw + 8
            if layout_x < line_width-iw-8 then
                imgui.SameLine()
            else
                layout_x = cx 
            end
        end
        if layout_x~= cx then
            imgui.NewLine()
        end
    end
end