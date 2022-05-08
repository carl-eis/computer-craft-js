--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]

local ____modules = {}
local ____moduleCache = {}
local ____originalRequire = require
local function require(file, ...)
    if ____moduleCache[file] then
        return ____moduleCache[file].value
    end
    if ____modules[file] then
        local module = ____modules[file]
        ____moduleCache[file] = { value = (select("#", ...) > 0) and module(...) or module(file) }
        return ____moduleCache[file].value
    else
        if ____originalRequire then
            return ____originalRequire(file)
        else
            error("module '" .. file .. "' not found")
        end
    end
end
____modules = {
    ["event"] = function(...)
        --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
        -- Lua Library inline imports
        local function __TS__Class(self)
            local c = {prototype = {}}
            c.prototype.__index = c.prototype
            c.prototype.constructor = c
            return c
        end

        local function __TS__New(target, ...)
            local instance = setmetatable({}, target.prototype)
            instance:____constructor(...)
            return instance
        end

        local function __TS__ArrayIsArray(value)
            return type(value) == "table" and (value[1] ~= nil or next(value, nil) == nil)
        end

        local function __TS__ArrayConcat(arr1, ...)
            local args = {...}
            local out = {}
            for ____, val in ipairs(arr1) do
                out[#out + 1] = val
            end
            for ____, arg in ipairs(args) do
                if __TS__ArrayIsArray(arg) then
                    local argAsArray = arg
                    for ____, val in ipairs(argAsArray) do
                        out[#out + 1] = val
                    end
                else
                    out[#out + 1] = arg
                end
            end
            return out
        end

        local function __TS__ArraySlice(list, first, last)
            local len = #list
            local relativeStart = first or 0
            local k
            if relativeStart < 0 then
                k = math.max(len + relativeStart, 0)
            else
                k = math.min(relativeStart, len)
            end
            local relativeEnd = last
            if last == nil then
                relativeEnd = len
            end
            local final
            if relativeEnd < 0 then
                final = math.max(len + relativeEnd, 0)
            else
                final = math.min(relativeEnd, len)
            end
            local out = {}
            local n = 0
            while k < final do
                out[n + 1] = list[k + 1]
                k = k + 1
                n = n + 1
            end
            return out
        end

        local __TS__Symbol, Symbol
        do
            local symbolMetatable = {__tostring = function(self)
                return ("Symbol(" .. (self.description or "")) .. ")"
            end}
            function __TS__Symbol(description)
                return setmetatable({description = description}, symbolMetatable)
            end
            Symbol = {
                iterator = __TS__Symbol("Symbol.iterator"),
                hasInstance = __TS__Symbol("Symbol.hasInstance"),
                species = __TS__Symbol("Symbol.species"),
                toStringTag = __TS__Symbol("Symbol.toStringTag")
            }
        end

        local function __TS__InstanceOf(obj, classTbl)
            if type(classTbl) ~= "table" then
                error("Right-hand side of 'instanceof' is not an object", 0)
            end
            if classTbl[Symbol.hasInstance] ~= nil then
                return not not classTbl[Symbol.hasInstance](classTbl, obj)
            end
            if type(obj) == "table" then
                local luaClass = obj.constructor
                while luaClass ~= nil do
                    if luaClass == classTbl then
                        return true
                    end
                    luaClass = luaClass.____super
                end
            end
            return false
        end

        local ____exports = {}
        ____exports.CharEvent = __TS__Class()
        local CharEvent = ____exports.CharEvent
        CharEvent.name = "CharEvent"
        function CharEvent.prototype.____constructor(self)
            self.character = ""
        end
        function CharEvent.prototype.get_name(self)
            return "char"
        end
        function CharEvent.prototype.get_args(self)
            return {self.character}
        end
        function CharEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "char" then
                return nil
            end
            local ev = __TS__New(____exports.CharEvent)
            ev.character = args[2]
            return ev
        end
        ____exports.KeyEvent = __TS__Class()
        local KeyEvent = ____exports.KeyEvent
        KeyEvent.name = "KeyEvent"
        function KeyEvent.prototype.____constructor(self)
            self.key = 0
            self.isHeld = false
            self.isUp = false
        end
        function KeyEvent.prototype.get_name(self)
            return self.isUp and "key_up" or "key"
        end
        function KeyEvent.prototype.get_args(self)
            local ____self_key_1 = self.key
            local ____table_isUp_0
            if self.isUp then
                ____table_isUp_0 = nil
            else
                ____table_isUp_0 = self.isHeld
            end
            return {____self_key_1, ____table_isUp_0}
        end
        function KeyEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "key" and args[1] ~= "key_up" then
                return nil
            end
            local ev = __TS__New(____exports.KeyEvent)
            ev.key = args[2]
            ev.isUp = args[1] == "key_up"
            local ____ev_3 = ev
            local ____ev_isUp_2
            if ev.isUp then
                ____ev_isUp_2 = false
            else
                ____ev_isUp_2 = args[3]
            end
            ____ev_3.isHeld = ____ev_isUp_2
            return ev
        end
        ____exports.PasteEvent = __TS__Class()
        local PasteEvent = ____exports.PasteEvent
        PasteEvent.name = "PasteEvent"
        function PasteEvent.prototype.____constructor(self)
            self.text = ""
        end
        function PasteEvent.prototype.get_name(self)
            return "paste"
        end
        function PasteEvent.prototype.get_args(self)
            return {self.text}
        end
        function PasteEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "paste" then
                return nil
            end
            local ev = __TS__New(____exports.PasteEvent)
            ev.text = args[2]
            return ev
        end
        ____exports.TimerEvent = __TS__Class()
        local TimerEvent = ____exports.TimerEvent
        TimerEvent.name = "TimerEvent"
        function TimerEvent.prototype.____constructor(self)
            self.id = 0
            self.isAlarm = false
        end
        function TimerEvent.prototype.get_name(self)
            return self.isAlarm and "alarm" or "timer"
        end
        function TimerEvent.prototype.get_args(self)
            return {self.id}
        end
        function TimerEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "timer" and args[1] ~= "alarm" then
                return nil
            end
            local ev = __TS__New(____exports.TimerEvent)
            ev.id = args[2]
            ev.isAlarm = args[1] == "alarm"
            return ev
        end
        ____exports.TaskCompleteEvent = __TS__Class()
        local TaskCompleteEvent = ____exports.TaskCompleteEvent
        TaskCompleteEvent.name = "TaskCompleteEvent"
        function TaskCompleteEvent.prototype.____constructor(self)
            self.id = 0
            self.success = false
            self.error = nil
            self.params = {}
        end
        function TaskCompleteEvent.prototype.get_name(self)
            return "task_complete"
        end
        function TaskCompleteEvent.prototype.get_args(self)
            if self.success then
                return __TS__ArrayConcat({self.id, self.success}, self.params)
            else
                return {self.id, self.success, self.error}
            end
        end
        function TaskCompleteEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "task_complete" then
                return nil
            end
            local ev = __TS__New(____exports.TaskCompleteEvent)
            ev.id = args[2]
            ev.success = args[3]
            if ev.success then
                ev.error = nil
                ev.params = __TS__ArraySlice(args, 3)
            else
                ev.error = args[4]
                ev.params = {}
            end
            return ev
        end
        ____exports.RedstoneEvent = __TS__Class()
        local RedstoneEvent = ____exports.RedstoneEvent
        RedstoneEvent.name = "RedstoneEvent"
        function RedstoneEvent.prototype.____constructor(self)
        end
        function RedstoneEvent.prototype.get_name(self)
            return "redstone"
        end
        function RedstoneEvent.prototype.get_args(self)
            return {}
        end
        function RedstoneEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "redstone" then
                return nil
            end
            local ev = __TS__New(____exports.RedstoneEvent)
            return ev
        end
        ____exports.TerminateEvent = __TS__Class()
        local TerminateEvent = ____exports.TerminateEvent
        TerminateEvent.name = "TerminateEvent"
        function TerminateEvent.prototype.____constructor(self)
        end
        function TerminateEvent.prototype.get_name(self)
            return "terminate"
        end
        function TerminateEvent.prototype.get_args(self)
            return {}
        end
        function TerminateEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "terminate" then
                return nil
            end
            local ev = __TS__New(____exports.TerminateEvent)
            return ev
        end
        ____exports.DiskEvent = __TS__Class()
        local DiskEvent = ____exports.DiskEvent
        DiskEvent.name = "DiskEvent"
        function DiskEvent.prototype.____constructor(self)
            self.side = ""
            self.eject = false
        end
        function DiskEvent.prototype.get_name(self)
            return self.eject and "disk_eject" or "disk"
        end
        function DiskEvent.prototype.get_args(self)
            return {self.side}
        end
        function DiskEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "disk" and args[1] ~= "disk_eject" then
                return nil
            end
            local ev = __TS__New(____exports.DiskEvent)
            ev.side = args[2]
            ev.eject = args[1] == "disk_eject"
            return ev
        end
        ____exports.PeripheralEvent = __TS__Class()
        local PeripheralEvent = ____exports.PeripheralEvent
        PeripheralEvent.name = "PeripheralEvent"
        function PeripheralEvent.prototype.____constructor(self)
            self.side = ""
            self.detach = false
        end
        function PeripheralEvent.prototype.get_name(self)
            return self.detach and "peripheral_detach" or "peripheral"
        end
        function PeripheralEvent.prototype.get_args(self)
            return {self.side}
        end
        function PeripheralEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "peripheral" and args[1] ~= "peripheral_detach" then
                return nil
            end
            local ev = __TS__New(____exports.PeripheralEvent)
            ev.side = args[2]
            ev.detach = args[1] == "peripheral_detach"
            return ev
        end
        ____exports.RednetMessageEvent = __TS__Class()
        local RednetMessageEvent = ____exports.RednetMessageEvent
        RednetMessageEvent.name = "RednetMessageEvent"
        function RednetMessageEvent.prototype.____constructor(self)
            self.sender = 0
            self.protocol = nil
        end
        function RednetMessageEvent.prototype.get_name(self)
            return "rednet_message"
        end
        function RednetMessageEvent.prototype.get_args(self)
            return {self.sender, self.message, self.protocol}
        end
        function RednetMessageEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "rednet_message" then
                return nil
            end
            local ev = __TS__New(____exports.RednetMessageEvent)
            ev.sender = args[2]
            ev.message = args[3]
            ev.protocol = args[4]
            return ev
        end
        ____exports.ModemMessageEvent = __TS__Class()
        local ModemMessageEvent = ____exports.ModemMessageEvent
        ModemMessageEvent.name = "ModemMessageEvent"
        function ModemMessageEvent.prototype.____constructor(self)
            self.side = ""
            self.channel = 0
            self.replyChannel = 0
            self.distance = 0
        end
        function ModemMessageEvent.prototype.get_name(self)
            return "modem_message"
        end
        function ModemMessageEvent.prototype.get_args(self)
            return {
                self.side,
                self.channel,
                self.replyChannel,
                self.message,
                self.distance
            }
        end
        function ModemMessageEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "modem_message" then
                return nil
            end
            local ev = __TS__New(____exports.ModemMessageEvent)
            ev.side = args[2]
            ev.channel = args[3]
            ev.replyChannel = args[4]
            ev.message = args[5]
            ev.distance = args[6]
            return ev
        end
        ____exports.HTTPEvent = __TS__Class()
        local HTTPEvent = ____exports.HTTPEvent
        HTTPEvent.name = "HTTPEvent"
        function HTTPEvent.prototype.____constructor(self)
            self.url = ""
            self.handle = nil
            self.error = nil
        end
        function HTTPEvent.prototype.get_name(self)
            return self.error == nil and "http_success" or "http_failure"
        end
        function HTTPEvent.prototype.get_args(self)
            local ____self_url_6 = self.url
            local ____temp_4
            if self.error == nil then
                ____temp_4 = self.handle
            else
                ____temp_4 = self.error
            end
            local ____temp_5
            if self.error ~= nil then
                ____temp_5 = self.handle
            else
                ____temp_5 = nil
            end
            return {____self_url_6, ____temp_4, ____temp_5}
        end
        function HTTPEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "http_success" and args[1] ~= "http_failure" then
                return nil
            end
            local ev = __TS__New(____exports.HTTPEvent)
            ev.url = args[2]
            if args[1] == "http_success" then
                ev.error = nil
                ev.handle = args[3]
            else
                ev.error = args[3]
                if ev.error == nil then
                    ev.error = ""
                end
                ev.handle = args[4]
            end
            return ev
        end
        ____exports.WebSocketEvent = __TS__Class()
        local WebSocketEvent = ____exports.WebSocketEvent
        WebSocketEvent.name = "WebSocketEvent"
        function WebSocketEvent.prototype.____constructor(self)
            self.handle = nil
            self.error = nil
        end
        function WebSocketEvent.prototype.get_name(self)
            return self.error == nil and "websocket_success" or "websocket_failure"
        end
        function WebSocketEvent.prototype.get_args(self)
            local ____temp_7
            if self.handle == nil then
                ____temp_7 = self.error
            else
                ____temp_7 = self.handle
            end
            return {____temp_7}
        end
        function WebSocketEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "websocket_success" and args[1] ~= "websocket_failure" then
                return nil
            end
            local ev = __TS__New(____exports.WebSocketEvent)
            if args[1] == "websocket_success" then
                ev.handle = args[2]
                ev.error = nil
            else
                ev.error = args[2]
                ev.handle = nil
            end
            return ev
        end
        ____exports.MouseEventType = MouseEventType or ({})
        ____exports.MouseEventType.Click = 0
        ____exports.MouseEventType[____exports.MouseEventType.Click] = "Click"
        ____exports.MouseEventType.Up = 1
        ____exports.MouseEventType[____exports.MouseEventType.Up] = "Up"
        ____exports.MouseEventType.Scroll = 2
        ____exports.MouseEventType[____exports.MouseEventType.Scroll] = "Scroll"
        ____exports.MouseEventType.Drag = 3
        ____exports.MouseEventType[____exports.MouseEventType.Drag] = "Drag"
        ____exports.MouseEventType.Touch = 4
        ____exports.MouseEventType[____exports.MouseEventType.Touch] = "Touch"
        ____exports.MouseEventType.Move = 5
        ____exports.MouseEventType[____exports.MouseEventType.Move] = "Move"
        ____exports.MouseEvent = __TS__Class()
        local MouseEvent = ____exports.MouseEvent
        MouseEvent.name = "MouseEvent"
        function MouseEvent.prototype.____constructor(self)
            self.button = 0
            self.x = 0
            self.y = 0
            self.side = nil
            self.type = ____exports.MouseEventType.Click
        end
        function MouseEvent.prototype.get_name(self)
            return ({
                [____exports.MouseEventType.Click] = "mouse_click",
                [____exports.MouseEventType.Up] = "mouse_up",
                [____exports.MouseEventType.Scroll] = "mouse_scroll",
                [____exports.MouseEventType.Drag] = "mouse_drag",
                [____exports.MouseEventType.Touch] = "monitor_touch",
                [____exports.MouseEventType.Move] = "mouse_move"
            })[self.type]
        end
        function MouseEvent.prototype.get_args(self)
            local ____temp_8
            if self.type == ____exports.MouseEventType.Touch then
                ____temp_8 = self.side
            else
                ____temp_8 = self.button
            end
            return {____temp_8, self.x, self.y}
        end
        function MouseEvent.init(self, args)
            if not (type(args[1]) == "string") then
                return nil
            end
            local ev = __TS__New(____exports.MouseEvent)
            local ____type = args[1]
            if ____type == "mouse_click" then
                ev.type = ____exports.MouseEventType.Click
                ev.button = args[2]
                ev.side = nil
            elseif ____type == "mouse_up" then
                ev.type = ____exports.MouseEventType.Up
                ev.button = args[2]
                ev.side = nil
            elseif ____type == "mouse_scroll" then
                ev.type = ____exports.MouseEventType.Scroll
                ev.button = args[2]
                ev.side = nil
            elseif ____type == "mouse_drag" then
                ev.type = ____exports.MouseEventType.Drag
                ev.button = args[2]
                ev.side = nil
            elseif ____type == "monitor_touch" then
                ev.type = ____exports.MouseEventType.Touch
                ev.button = 0
                ev.side = args[2]
            elseif ____type == "mouse_move" then
                ev.type = ____exports.MouseEventType.Move
                ev.button = args[2]
                ev.side = nil
            else
                return nil
            end
            ev.x = args[3]
            ev.y = args[4]
            return ev
        end
        ____exports.ResizeEvent = __TS__Class()
        local ResizeEvent = ____exports.ResizeEvent
        ResizeEvent.name = "ResizeEvent"
        function ResizeEvent.prototype.____constructor(self)
            self.side = nil
        end
        function ResizeEvent.prototype.get_name(self)
            return self.side == nil and "term_resize" or "monitor_resize"
        end
        function ResizeEvent.prototype.get_args(self)
            return {self.side}
        end
        function ResizeEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "term_resize" and args[1] ~= "monitor_resize" then
                return nil
            end
            local ev = __TS__New(____exports.ResizeEvent)
            if args[1] == "monitor_resize" then
                ev.side = args[2]
            else
                ev.side = nil
            end
            return ev
        end
        ____exports.TurtleInventoryEvent = __TS__Class()
        local TurtleInventoryEvent = ____exports.TurtleInventoryEvent
        TurtleInventoryEvent.name = "TurtleInventoryEvent"
        function TurtleInventoryEvent.prototype.____constructor(self)
        end
        function TurtleInventoryEvent.prototype.get_name(self)
            return "turtle_inventory"
        end
        function TurtleInventoryEvent.prototype.get_args(self)
            return {}
        end
        function TurtleInventoryEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "turtle_inventory" then
                return nil
            end
            local ev = __TS__New(____exports.TurtleInventoryEvent)
            return ev
        end
        local SpeakerAudioEmptyEvent = __TS__Class()
        SpeakerAudioEmptyEvent.name = "SpeakerAudioEmptyEvent"
        function SpeakerAudioEmptyEvent.prototype.____constructor(self)
            self.side = ""
        end
        function SpeakerAudioEmptyEvent.prototype.get_name(self)
            return "speaker_audio_empty"
        end
        function SpeakerAudioEmptyEvent.prototype.get_args(self)
            return {self.side}
        end
        function SpeakerAudioEmptyEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "speaker_audio_empty" then
                return nil
            end
            local ev
            ev.side = args[2]
            return ev
        end
        local ComputerCommandEvent = __TS__Class()
        ComputerCommandEvent.name = "ComputerCommandEvent"
        function ComputerCommandEvent.prototype.____constructor(self)
            self.args = {}
        end
        function ComputerCommandEvent.prototype.get_name(self)
            return "computer_command"
        end
        function ComputerCommandEvent.prototype.get_args(self)
            return self.args
        end
        function ComputerCommandEvent.init(self, args)
            if not (type(args[1]) == "string") or args[1] ~= "computer_command" then
                return nil
            end
            local ev
            ev.args = __TS__ArraySlice(args, 1)
            return ev
        end
        ____exports.GenericEvent = __TS__Class()
        local GenericEvent = ____exports.GenericEvent
        GenericEvent.name = "GenericEvent"
        function GenericEvent.prototype.____constructor(self)
            self.args = {}
        end
        function GenericEvent.prototype.get_name(self)
            return self.args[1]
        end
        function GenericEvent.prototype.get_args(self)
            return __TS__ArraySlice(self.args, 1)
        end
        function GenericEvent.init(self, args)
            local ev = __TS__New(____exports.GenericEvent)
            ev.args = args
            return ev
        end
        local eventInitializers = {
            ____exports.CharEvent.init,
            ____exports.KeyEvent.init,
            ____exports.PasteEvent.init,
            ____exports.TimerEvent.init,
            ____exports.TaskCompleteEvent.init,
            ____exports.RedstoneEvent.init,
            ____exports.TerminateEvent.init,
            ____exports.DiskEvent.init,
            ____exports.PeripheralEvent.init,
            ____exports.RednetMessageEvent.init,
            ____exports.ModemMessageEvent.init,
            ____exports.HTTPEvent.init,
            ____exports.WebSocketEvent.init,
            ____exports.MouseEvent.init,
            ____exports.ResizeEvent.init,
            ____exports.TurtleInventoryEvent.init,
            SpeakerAudioEmptyEvent.init,
            ComputerCommandEvent.init,
            ____exports.GenericEvent.init
        }
        function ____exports.pullEventRaw(self, filter)
            if filter == nil then
                filter = nil
            end
            local args = table.pack({coroutine.yield(filter)})
            for ____, init in ipairs(eventInitializers) do
                local ev = init(nil, args)
                if ev ~= nil then
                    return ev
                end
            end
            return ____exports.GenericEvent:init(args)
        end
        function ____exports.pullEvent(self, filter)
            if filter == nil then
                filter = nil
            end
            local ev = ____exports.pullEventRaw(nil, filter)
            if __TS__InstanceOf(ev, ____exports.TerminateEvent) then
                error("Terminated", 0)
            end
            return ev
        end
        function ____exports.pullEventRawAs(self, ____type, filter)
            if filter == nil then
                filter = nil
            end
            local ev = ____exports.pullEventRaw(nil, filter)
            if __TS__InstanceOf(ev, ____type) then
                return ev
            else
                return nil
            end
        end
        function ____exports.pullEventAs(self, ____type, filter)
            if filter == nil then
                filter = nil
            end
            local ev = ____exports.pullEvent(nil, filter)
            if __TS__InstanceOf(ev, ____type) then
                return ev
            else
                return nil
            end
        end
        return ____exports
    end,
    ["main"] = function(...)
        --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
        -- Lua Library inline imports
        local function __TS__ObjectValues(obj)
            local result = {}
            for key in pairs(obj) do
                result[#result + 1] = obj[key]
            end
            return result
        end

        local function __TS__ArrayIncludes(self, searchElement, fromIndex)
            if fromIndex == nil then
                fromIndex = 0
            end
            local len = #self
            local k = fromIndex
            if fromIndex < 0 then
                k = len + fromIndex
            end
            if k < 0 then
                k = 0
            end
            for i = k, len do
                if self[i + 1] == searchElement then
                    return true
                end
            end
            return false
        end

        local function __TS__Class(self)
            local c = {prototype = {}}
            c.prototype.__index = c.prototype
            c.prototype.constructor = c
            return c
        end

        local __TS__Unpack = table.unpack or unpack

        local function __TS__FunctionBind(fn, thisArg, ...)
            local boundArgs = {...}
            return function(____, ...)
                local args = {...}
                do
                    local i = 0
                    while i < #boundArgs do
                        table.insert(args, i + 1, boundArgs[i + 1])
                        i = i + 1
                    end
                end
                return fn(
                        thisArg,
                        __TS__Unpack(args)
                )
            end
        end

        local function __TS__StringSubstr(self, from, length)
            if from ~= from then
                from = 0
            end
            if length ~= nil then
                if length ~= length or length <= 0 then
                    return ""
                end
                length = length + from
            end
            if from >= 0 then
                from = from + 1
            end
            return string.sub(self, from, length)
        end

        local function __TS__StringSubstring(self, start, ____end)
            if ____end ~= ____end then
                ____end = 0
            end
            if ____end ~= nil and start > ____end then
                start, ____end = ____end, start
            end
            if start >= 0 then
                start = start + 1
            else
                start = 1
            end
            if ____end ~= nil and ____end < 0 then
                ____end = 0
            end
            return string.sub(self, start, ____end)
        end

        local __TS__ParseInt
        do
            local parseIntBasePattern = "0123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTvVwWxXyYzZ"
            function __TS__ParseInt(numberString, base)
                if base == nil then
                    base = 10
                    local hexMatch = string.match(numberString, "^%s*-?0[xX]")
                    if hexMatch then
                        base = 16
                        local ____string_match_result__0_0
                        if string.match(hexMatch, "-") then
                            ____string_match_result__0_0 = "-" .. __TS__StringSubstr(numberString, #hexMatch)
                        else
                            ____string_match_result__0_0 = __TS__StringSubstr(numberString, #hexMatch)
                        end
                        numberString = ____string_match_result__0_0
                    end
                end
                if base < 2 or base > 36 then
                    return 0 / 0
                end
                local ____temp_1
                if base <= 10 then
                    ____temp_1 = __TS__StringSubstring(parseIntBasePattern, 0, base)
                else
                    ____temp_1 = __TS__StringSubstr(parseIntBasePattern, 0, 10 + 2 * (base - 10))
                end
                local allowedDigits = ____temp_1
                local pattern = ("^%s*(-?[" .. allowedDigits) .. "]*)"
                local number = tonumber(
                        string.match(numberString, pattern),
                        base
                )
                if number == nil then
                    return 0 / 0
                end
                if number >= 0 then
                    return math.floor(number)
                else
                    return math.ceil(number)
                end
            end
        end

        local function __TS__New(target, ...)
            local instance = setmetatable({}, target.prototype)
            instance:____constructor(...)
            return instance
        end

        local ____exports = {}
        local event = require("event")
        local sleep = os.sleep
        local FUEL_TYPES = {LAVA_BUCKET = "minecraft:lava_bucket", COAL = "minecraft:coal", CHARCOAL = "minecraft:charcoal", LOG = "minecraft:log"}
        local FLOOR_TYPES = {COBBLESTONE = "minecraft:cobblestone"}
        local INVENTORY_SIZE = 16
        local FUEL_BUFFER_AMOUNT = 2
        local DIRECTIONS = DIRECTIONS or ({})
        DIRECTIONS.Down = "DOWN"
        DIRECTIONS.Forwards = "FORWARDS"
        DIRECTIONS.Up = "UP"
        local PROGRAMS = PROGRAMS or ({})
        PROGRAMS.DIG = "dig"
        PROGRAMS.TUNNEL = "tunnel"
        PROGRAMS.FLOOR = "floor"
        local function getDirection(self, xDir, zDir)
            if xDir == 0 then
                if zDir == 1 then
                    return "NORTH"
                elseif zDir == 0 then
                    return "SOUTH"
                end
            end
            if xDir == 1 then
                if zDir == 0 then
                    return "EAST"
                elseif zDir == 1 then
                    return "WEST"
                end
            end
            return "UNKNOWN"
        end
        local function isFuel(self, index)
            if turtle.getItemCount(index) == 0 then
                return false
            end
            local data = turtle.getItemDetail(index)
            local ____temp_0 = data
            local name = ____temp_0.name
            return __TS__ArrayIncludes(
                    __TS__ObjectValues(FUEL_TYPES),
                    name
            )
        end
        local function checkFuelExists(self)
            local hasFuel = false
            do
                local i = 1
                while i < INVENTORY_SIZE + 1 do
                    if isFuel(nil, i) then
                        hasFuel = true
                        print("Fuel found at slot", i)
                        break
                    end
                    i = i + 1
                end
            end
            return hasFuel
        end
        local function getSlotContainingItems(self, itemList)
            if itemList == nil then
                itemList = __TS__ObjectValues(FLOOR_TYPES)
            end
            do
                local i = 0
                while i < INVENTORY_SIZE do
                    if turtle.getItemCount(i + 1) > 0 then
                        local data = turtle.getItemDetail(i + 1)
                        local ____temp_1 = data
                        local name = ____temp_1.name
                        if __TS__ArrayIncludes(itemList, name) then
                            return i + 1
                        end
                    end
                    i = i + 1
                end
            end
            return -1
        end
        local function refillFromAllSlots(self, fuelRequiredToReturn)
            local fueled = false
            do
                local i = 1
                while i < INVENTORY_SIZE + 1 do
                    if turtle.getItemCount(i) > 0 then
                        turtle.select(i)
                        if turtle.refuel(1) then
                            while turtle.getItemCount(i) > 0 and turtle.getFuelLevel() < fuelRequiredToReturn do
                                turtle.refuel(1)
                            end
                            if turtle.getFuelLevel() >= fuelRequiredToReturn then
                                fueled = true
                            end
                        end
                    end
                    i = i + 1
                end
            end
            turtle.select(1)
            return fueled
        end
        local TurtleEngine = __TS__Class()
        TurtleEngine.name = "TurtleEngine"
        function TurtleEngine.prototype.____constructor(self, ...)
            local args = {...}
            self.hasFuel = false
            self.xPos = 0
            self.yPos = 0
            self.zPos = 0
            self.xDirection = 0
            self.zDirection = 1
            self.collected = 0
            self.unloaded = 0
            self.amountMoves = 0
            self.maxMoves = 50
            self.validateArgs = function()
                local programName = self.cliArguments[1]
                local possiblePrograms = {PROGRAMS.DIG, PROGRAMS.TUNNEL, PROGRAMS.FLOOR}
                local function printHelp()
                    print("Please specify program name with arguments.\n")
                    print("Usage:")
                    print("dig <length> <width>")
                    print("floor <width> <length> <shift?>")
                    print("tunnel <width> <height> <length>")
                end
                if not __TS__ArrayIncludes(possiblePrograms, programName) then
                    printHelp(nil)
                    return false
                end
                repeat
                    local ____switch28 = programName
                    local ____cond28 = ____switch28 == PROGRAMS.DIG
                    if ____cond28 then
                        do
                            if #self.cliArguments == 3 then
                                self.selectedProgram = PROGRAMS.DIG
                                return true
                            else
                                print("Usage:")
                                print("dig <length> <width>")
                                return false
                            end
                        end
                    end
                    ____cond28 = ____cond28 or ____switch28 == PROGRAMS.TUNNEL
                    if ____cond28 then
                        do
                            if #self.cliArguments == 4 then
                                self.selectedProgram = PROGRAMS.TUNNEL
                                return true
                            else
                                print("Usage:")
                                print("tunnel <width> <height> <length>")
                                return false
                            end
                        end
                    end
                    ____cond28 = ____cond28 or ____switch28 == PROGRAMS.FLOOR
                    if ____cond28 then
                        do
                            if __TS__ArrayIncludes({3, 4}, #self.cliArguments) then
                                self.selectedProgram = PROGRAMS.FLOOR
                                return true
                            else
                                print("Usage:")
                                print("floor <width> <length> <shift?>")
                                return false
                            end
                        end
                    end
                    do
                        do
                            printHelp(nil)
                            return false
                        end
                    end
                until true
            end
            self.logPosition = function()
                print((((((tostring(self.xPos) .. "x ") .. tostring(self.yPos)) .. "y ") .. tostring(self.zPos)) .. "z facing ") .. getDirection(nil, self.xDirection, self.zDirection))
            end
            self.attemptRefuel = function(____, manualAmount)
                local fuelLevel = turtle.getFuelLevel()
                if fuelLevel == "unlimited" then
                    return true
                end
                local fuelRequiredToReturn = manualAmount or self.xPos + self.zPos + math.abs(self.yPos) + FUEL_BUFFER_AMOUNT
                if fuelLevel > fuelRequiredToReturn then
                    return true
                end
                return refillFromAllSlots(nil, fuelRequiredToReturn)
            end
            self.checkInitialFuel = function(____, isInitialCheck)
                if isInitialCheck == nil then
                    isInitialCheck = false
                end
                self.hasFuel = checkFuelExists(nil)
                if not self.hasFuel and isInitialCheck then
                    print("\nNo fuel found. Please add fuel into an inventory slot and try again.")
                    return
                end
            end
            self.tryCollect = function()
                local allSlotsFull = true
                local totalItems = 0
                do
                    local i = 0
                    while i < INVENTORY_SIZE do
                        local count = turtle.getItemCount(i + 1)
                        if count == 0 then
                            allSlotsFull = false
                        end
                        totalItems = totalItems + count
                        i = i + 1
                    end
                end
                if totalItems > self.collected then
                    self.collected = totalItems
                    if (self.collected + self.unloaded) % 50 == 0 then
                        print(("Mined " .. tostring(self.collected + self.unloaded)) .. " items.")
                    end
                end
                if allSlotsFull then
                    print("No empty slots left")
                    return false
                end
                return true
            end
            self.returnSupplies = function(____, resume)
                if resume == nil then
                    resume = true
                end
                local ____temp_2 = self
                local xPos = ____temp_2.xPos
                local yPos = ____temp_2.yPos
                local zPos = ____temp_2.zPos
                local xDirection = ____temp_2.xDirection
                local zDirection = ____temp_2.zDirection
                print("Returning to surface...")
                self:goTo(
                        0,
                        0,
                        0,
                        0,
                        -1
                )
                if not resume then
                    self:unload(true)
                    self:turnRight()
                    self:turnRight()
                    return
                end
                local fuelNeeded = 2 * (xPos + yPos + zPos) + 1
                if not self:attemptRefuel(fuelNeeded) then
                    self:unload(true)
                    print("Waiting for fuel")
                    while not self:attemptRefuel(fuelNeeded) do
                        event:pullEventAs(event.TurtleInventoryEvent, "turtle_inventory")
                    end
                else
                    self:unload(true)
                end
                print("Resuming mining...")
                self:goTo(
                        xPos,
                        yPos,
                        zPos,
                        xDirection,
                        zDirection
                )
            end
            self.unload = function(____, keepOneFuelStack)
                if keepOneFuelStack == nil then
                    keepOneFuelStack = true
                end
                print("Unloading items...")
                do
                    local i = 0
                    while i < INVENTORY_SIZE do
                        local slotIndex = i + 1
                        local amountItemsInSlot = turtle.getItemCount(slotIndex)
                        if amountItemsInSlot > 0 then
                            turtle.select(slotIndex)
                            local shouldDrop = true
                            if keepOneFuelStack and turtle.refuel(0) then
                                shouldDrop = false
                                keepOneFuelStack = false
                            end
                            if shouldDrop then
                                turtle.drop()
                                self.unloaded = self.unloaded + amountItemsInSlot
                            end
                        end
                        i = i + 1
                    end
                end
                self.collected = 0
                turtle.select(1)
            end
            self.goTo = function(____, x, y, z, xDir, zDir)
                while self.yPos > y do
                    if turtle.up() then
                        self.yPos = self.yPos - 1
                    elseif turtle.digUp() or turtle.attackUp() then
                        self:tryCollect()
                    else
                        sleep(0.5)
                    end
                end
                if self.xPos > x then
                    while self.xDirection ~= -1 do
                        self:turnLeft()
                    end
                    while self.xPos > x do
                        if turtle.forward() then
                            self.xPos = self.xPos - 1
                        elseif turtle.dig() or turtle.attack() then
                            self:tryCollect()
                        else
                            sleep(0.5)
                        end
                    end
                elseif self.xPos < x then
                    while self.xDirection ~= 1 do
                        self:turnLeft()
                    end
                    while self.xPos < x do
                        if turtle.forward() then
                            self.xPos = self.xPos + 1
                        elseif turtle.dig() or turtle.attack() then
                            self:tryCollect()
                        else
                            sleep(0.5)
                        end
                    end
                end
                if self.zPos > z then
                    while self.zDirection ~= -1 do
                        self:turnLeft()
                    end
                    while self.zPos > z do
                        if turtle.forward() then
                            self.zPos = self.zPos - 1
                        elseif turtle.dig() or turtle.attack() then
                            self:tryCollect()
                        else
                            sleep(0.5)
                        end
                    end
                elseif self.zPos < z then
                    while self.zDirection ~= 1 do
                        self:turnLeft()
                    end
                    while self.zPos < z do
                        if turtle.forward() then
                            self.zPos = self.zPos + 1
                        elseif turtle.dig() or turtle.attack() then
                            self:tryCollect()
                        else
                            sleep(0.5)
                        end
                    end
                end
                while self.yPos < y do
                    if turtle.down() then
                        self.yPos = self.yPos + 1
                    elseif turtle.digDown() or turtle.attackDown() then
                        self:tryCollect()
                    else
                        sleep(0.5)
                    end
                end
                while self.zDirection ~= zDir or self.xDirection ~= xDir do
                    self:turnLeft()
                end
            end
            self.collectOrReturn = function()
                if not self:tryCollect() then
                    print("\nUnable to collect, returning back to base.")
                    self:returnSupplies()
                end
            end
            self.tryDirection = function(____, direction)
                if not self:attemptRefuel() then
                    print("\nOut of fuel. Returning to surface")
                    self:returnSupplies()
                end
                local move
                local detect
                local dig
                local attack
                repeat
                    local ____switch99 = direction
                    local ____cond99 = ____switch99 == DIRECTIONS.Forwards
                    if ____cond99 then
                        do
                            move = turtle.forward
                            detect = turtle.detect
                            dig = turtle.dig
                            attack = turtle.attack
                            break
                        end
                    end
                    ____cond99 = ____cond99 or ____switch99 == DIRECTIONS.Down
                    if ____cond99 then
                        do
                            move = turtle.down
                            detect = turtle.detectDown
                            dig = turtle.digDown
                            attack = turtle.attackDown
                            break
                        end
                    end
                    ____cond99 = ____cond99 or ____switch99 == DIRECTIONS.Up
                    if ____cond99 then
                        do
                            move = turtle.up
                            detect = turtle.detectUp
                            dig = turtle.digUp
                            attack = turtle.attackUp
                            break
                        end
                    end
                    do
                        do
                            break
                        end
                    end
                until true
                while not move(nil) do
                    if detect(nil) then
                        if dig(nil) then
                            self:collectOrReturn()
                        else
                            print("Unable to dig. Possibly stuck")
                            return false
                        end
                    elseif attack(nil) then
                        self:collectOrReturn()
                    else
                        sleep(0.1)
                    end
                end
                repeat
                    local ____switch110 = direction
                    local ____cond110 = ____switch110 == DIRECTIONS.Forwards
                    if ____cond110 then
                        do
                            self.xPos = self.xPos + self.xDirection
                            self.zPos = self.zPos + self.zDirection
                            self.amountMoves = self.amountMoves + 1
                            break
                        end
                    end
                    ____cond110 = ____cond110 or ____switch110 == DIRECTIONS.Down
                    if ____cond110 then
                        do
                            self.yPos = self.yPos + 1
                            if self.yPos % 10 == 0 then
                                print(("Descended " .. tostring(self.yPos)) .. " metres.")
                            end
                            self.amountMoves = self.amountMoves + 1
                            break
                        end
                    end
                    ____cond110 = ____cond110 or ____switch110 == DIRECTIONS.Up
                    if ____cond110 then
                        do
                            self.yPos = self.yPos - 1
                            self.amountMoves = self.amountMoves + 1
                            break
                        end
                    end
                    do
                        do
                            break
                        end
                    end
                until true
                return true
            end
            self.tryForwards = function() return self:tryDirection(DIRECTIONS.Forwards) end
            self.tryDown = function() return self:tryDirection(DIRECTIONS.Down) end
            self.tryUp = function() return self:tryDirection(DIRECTIONS.Up) end
            self.dig = function()
                if not self:attemptRefuel() then
                    print("Out of fuel.")
                    return
                end
                print("Digging...")
                local done = false
                local alternate = 0
                while not done do
                    do
                        local widthMined = 0
                        while widthMined < self.width do
                            do
                                local lengthMined = 0
                                while lengthMined < self.length - 1 do
                                    if not self:tryForwards() then
                                        done = true
                                        break
                                    end
                                    lengthMined = lengthMined + 1
                                end
                            end
                            if done then
                                break
                            end
                            if widthMined < self.width - 1 then
                                if (widthMined + 1 + alternate) % 2 == 0 then
                                    self:turnLeft()
                                    if not self:tryForwards() then
                                        done = true
                                        break
                                    end
                                    self:turnLeft()
                                else
                                    self:turnRight()
                                    if not self:tryForwards() then
                                        done = true
                                        break
                                    end
                                    self:turnRight()
                                end
                            end
                            widthMined = widthMined + 1
                        end
                    end
                    if done then
                        break
                    end
                    if self.width > 1 then
                        if self.width % 2 == 0 then
                            self:turnRight()
                        else
                            if alternate == 0 then
                                self:turnLeft()
                            else
                                self:turnRight()
                            end
                            alternate = 1 - alternate
                        end
                    end
                    if not self:tryDown() then
                        done = true
                        break
                    end
                end
            end
            self.tunnel = function()
                if not self:attemptRefuel() then
                    print("Out of fuel.")
                    return
                end
                print("Tunneling...")
                local done = false
                local alternate = 0
                local isMiningUp = true
                if not self:tryForwards() then
                    return
                end
                self:turnRight()
                do
                    local lengthMined = 0
                    while lengthMined < self.length do
                        do
                            local widthMined = 0
                            while widthMined < self.width do
                                do
                                    local heightMined = 0
                                    while heightMined < self.height - 1 do
                                        local ____isMiningUp_3
                                        if isMiningUp then
                                            ____isMiningUp_3 = self.tryUp
                                        else
                                            ____isMiningUp_3 = self.tryDown
                                        end
                                        local miningMethod = ____isMiningUp_3
                                        if not miningMethod(nil) then
                                            done = true
                                            break
                                        end
                                        heightMined = heightMined + 1
                                    end
                                end
                                isMiningUp = not isMiningUp
                                if widthMined < self.width - 1 then
                                    if not self:tryForwards() then
                                        done = true
                                        break
                                    end
                                end
                                widthMined = widthMined + 1
                            end
                        end
                        if lengthMined < self.length - 1 then
                            local ____temp_4
                            if alternate == 0 then
                                ____temp_4 = self.turnLeft
                            else
                                ____temp_4 = self.turnRight
                            end
                            local turnDirection = ____temp_4
                            turnDirection(nil)
                            if not self:tryForwards() then
                                done = true
                                break
                            end
                            turnDirection(nil)
                            alternate = 1 - alternate
                        end
                        lengthMined = lengthMined + 1
                    end
                end
                print("Job complete, returning.")
                self:returnSupplies(false)
            end
            self.floor = function(____, shiftOne)
                if shiftOne == nil then
                    shiftOne = false
                end
                if not self:attemptRefuel() then
                    print("Out of fuel.")
                    return
                end
                local itemSlot = getSlotContainingItems(nil, {FLOOR_TYPES.COBBLESTONE})
                if itemSlot == -1 then
                    print("No floor items found!")
                    return
                end
                turtle.select(itemSlot)
                if shiftOne then
                    self:tryForwards()
                end
                self:turnRight()
                local function placeFloor()
                    if not turtle.placeDown() then
                        if turtle.detectDown() then
                            if turtle.compareDown() then
                                return
                            end
                            if turtle.digDown() then
                                self:collectOrReturn()
                            else
                                print("Unable to dig. Possibly stuck")
                                return false
                            end
                        elseif turtle.attackDown() then
                            self:collectOrReturn()
                        else
                            sleep(0.1)
                        end
                        local itemSlot = getSlotContainingItems(nil, {FLOOR_TYPES.COBBLESTONE})
                        if itemSlot == -1 then
                            return false
                        end
                        turtle.select(itemSlot)
                        if not turtle.placeDown() then
                            return false
                        end
                    end
                end
                local lengthMoved = 0
                local alternate = 0
                while lengthMoved < self.length do
                    local j = 0
                    while j < self.width - 1 do
                        placeFloor(nil)
                        self:tryForwards()
                        j = j + 1
                    end
                    local ____temp_5
                    if alternate == 1 then
                        ____temp_5 = self.turnRight
                    else
                        ____temp_5 = self.turnLeft
                    end
                    local turn = ____temp_5
                    turn(nil)
                    placeFloor(nil)
                    if lengthMoved < self.length - 1 then
                        if not self:tryForwards() then
                            break
                        end
                        placeFloor(nil)
                        turn(nil)
                    end
                    alternate = 1 - alternate
                    lengthMoved = lengthMoved + 1
                end
                print("Job complete, returning.")
                self:logPosition()
                self:returnSupplies(false)
            end
            self.runSelectedProgram = function()
                repeat
                    local ____switch168 = self.selectedProgram
                    local ____cond168 = ____switch168 == PROGRAMS.DIG
                    if ____cond168 then
                        do
                            self.length = __TS__ParseInt(self.cliArguments[2], 10)
                            self.width = __TS__ParseInt(self.cliArguments[3], 10)
                            self:dig()
                            return
                        end
                    end
                    ____cond168 = ____cond168 or ____switch168 == PROGRAMS.TUNNEL
                    if ____cond168 then
                        do
                            self.width = __TS__ParseInt(self.cliArguments[2], 10)
                            self.height = __TS__ParseInt(self.cliArguments[3], 10)
                            self.length = __TS__ParseInt(self.cliArguments[4], 10)
                            self:tunnel()
                            return
                        end
                    end
                    ____cond168 = ____cond168 or ____switch168 == PROGRAMS.FLOOR
                    if ____cond168 then
                        do
                            self.width = __TS__ParseInt(self.cliArguments[2], 10)
                            self.length = __TS__ParseInt(self.cliArguments[3], 10)
                            local shiftOne = self.cliArguments[4] == "true"
                            self:floor(shiftOne)
                            return
                        end
                    end
                    do
                        do
                            return
                        end
                    end
                until true
            end
            self.cliArguments = args
            self.height = 0
            self.length = 0
            self.width = 0
            self.tryUp = __TS__FunctionBind(self.tryUp, self)
            self.tryDown = __TS__FunctionBind(self.tryDown, self)
            self.tryForwards = __TS__FunctionBind(self.tryForwards, self)
            self.turnRight = __TS__FunctionBind(self.turnRight, self)
            self.turnLeft = __TS__FunctionBind(self.turnLeft, self)
        end
        function TurtleEngine.prototype.turnLeft(self)
            turtle.turnLeft()
            local prevXDirection = self.xDirection
            local prevZDirection = self.zDirection
            self.xDirection = -prevZDirection
            self.zDirection = prevXDirection
        end
        function TurtleEngine.prototype.turnRight(self)
            turtle.turnRight()
            local prevXDirection = self.xDirection
            self.xDirection = self.zDirection
            self.zDirection = -prevXDirection
        end
        local function main(self, ...)
            print("\nExcavator Pro by MeguminGG")
            print("https://github.com/carl-eis")
            print("------------------------------------")
            local TurtleInstance = __TS__New(TurtleEngine, ...)
            if not TurtleInstance:validateArgs() then
                return
            end
            TurtleInstance:runSelectedProgram()
        end
        main(nil, ...)
        return ____exports
    end,
    ["turtle-core"] = function(...)
        --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
        -- Lua Library inline imports
        local function __TS__Class(self)
            local c = {prototype = {}}
            c.prototype.__index = c.prototype
            c.prototype.constructor = c
            return c
        end

        TurtleCore = __TS__Class()
        TurtleCore.name = "TurtleCore"
        function TurtleCore.prototype.____constructor(self)
        end
        function TurtleCore.prototype.move(self, direction)
        end
    end,
}
return require("main", ...)
