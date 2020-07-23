--[[
CXEngine.exe --cwd=[工作目录] --script_path=[lua文件夹相对工作目录]/  --luapath=[相对script_path下的lua文件路径]
示例：
./bin/Debug/CXEngine.exe --cwd=[CXEngine目录的路径]/  --script_path=scripts/examples/ --luapath=example0.lua

example5 绘制场景

]]
script_system_dofile('../share/enums.lua')
script_system_dofile('../share/vfs.lua')
script_system_dofile('../share/utils.lua')
script_system_dofile('../share/content_system.lua')
script_system_dofile('../share/actor_metatable.lua')

local player = nil
function init()
    content_system_init()--这个函数在content_system.lua里面定义，会加载各种数据表(tables/*.tsv)，游戏内容基本上是由表来定义的
    
    scene_manager_init()

    local scene_tbl = content_system_get_table('scene')
    for id, row in pairs(scene_tbl) do
        scene_manager_add_custom_scene(id, row.name, row.map_id)
    end
    
    player = actor_manager_create_actor(1)
    player:ResetASM()
    player:SetPos(400,300)
    actor_manager_set_local_player(player:GetID())

    local player = actor_manager_fetch_local_player()
    local scene_id = player:GetProperty(PROP_SCENE_ID)    
    scene_manager_switch_scene_by_id(scene_id)
end

function update()
    if not player then return end

    if imgui.IsMouseClicked(0) then
        local mx,my = input_manager_get_mouse_pos()
        local dest_x, dest_y = util_screen_pos_to_map_pos(mx, my)
        player:MoveTo(dest_x,dest_y)
    end
    
    
    actor_manager_update()
    scene_manager_update()

    -- actor_manager_draw()
    -- scene_manager_draw()

  
end

do
    iw_init(800, 600)
    local ok, ret = pcall(init)
    if not ok then
        print(ret)
    end
    iw_render(update)
    iw_deinit()
end
