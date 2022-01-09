if FirstLoad then
  PauseReasons = {
    [false] = true
  }
  ThreadDebugHook = false
end
local message_to_staticfuncs = {}
local threadPersist = 1048576
local threadOnMap = 2097152
function Msg(message, ...)
  local funcs = message_to_staticfuncs[message]
  if funcs then
    for i = 1, #funcs do
      procall(funcs[i], ...)
    end
  end
  MsgThreads(message, ...)
end
function MsgClear(message)
  message_to_staticfuncs[message] = nil
end
function GetHandledMsg(sorted)
  return table.keys(message_to_staticfuncs, sorted)
end
OnMsg = {}
setmetatable(OnMsg, {
  __newindex = function(_, message, func)
    local funcs = message_to_staticfuncs[message]
    if funcs then
      funcs[#funcs + 1] = func
    else
      message_to_staticfuncs[message] = {func}
    end
  end
})
function Halt()
  DeleteThread(CurrentThread(), true)
end
function ClearGameThreads()
  for thread in pairs(ThreadsRegister) do
    if ThreadHasFlags(thread, threadOnMap) then
      DeleteThread(thread)
    end
  end
end
function OnMsg.PreNewMap()
  ResetGameTime()
  UpdateRenderEngineTime()
end
function OnMsg.PostDoneMap()
  ClearGameThreads()
  ResetGameTime()
  UpdateRenderEngineTime()
end
function OnMsg.LoadGame()
  UpdateRenderEngineTime()
end
function ThreadErrorHandler(thread, err)
  err = string.match(tostring(err), ".-%.lua:%d+: (.*)") or err
  error(thread, err)
end
function Pause(reason)
  reason = reason or false
  if next(PauseReasons) == nil then
    PauseGame()
    PauseSounds(1, true)
    ChangeGameState({paused = true})
    Msg("Pause", reason)
    PauseReasons[reason] = true
    if IsGameTimeThread() then
      InterruptAdvance()
    end
  else
    PauseReasons[reason] = true
  end
end
function Resume(reason)
  reason = reason or false
  if PauseReasons[reason] ~= nil then
    PauseReasons[reason] = nil
    if next(PauseReasons) == nil then
      ResumeGame()
      ResumeSounds(1)
      ChangeGameState({paused = false})
      Msg("Resume", reason)
    end
  end
end
if not Platform.cmdline then
  IsPaused = GetGamePause
end
function _PrintPauseReasons(print_func, indent)
  indent = indent or ""
  print_func = print_func or print
  for reason in pairs(PauseReasons) do
    if type(reason) ~= "table" or not reason.class then
    end
    print_func(indent, (tostring(reason)))
  end
end
function OnMsg.BugReportStart(print_func)
  if next(PauseReasons) ~= nil then
    print_func("Active pause reasons:")
    _PrintPauseReasons(print_func, "\t")
    print_func("")
  end
end
function ToggleHighSpeed(sync)
  if GetTimeFactor() ~= const.DefaultTimeFactor then
    SetTimeFactor(const.DefaultTimeFactor, sync)
  else
    SetTimeFactor(const.DefaultTimeFactor * 10, sync)
  end
end
function CreateMapRealTimeThread(f, ...)
  local thread = CreateRealTimeThread(f, ...)
  ThreadSetFlags(thread, threadOnMap)
  return thread
end
function MakeThreadPersistable(thread)
  ThreadSetFlags(thread, threadPersist)
end
function WaitRealTimeThread(f, ...)
  local params = pack_params(...)
  local thread
  thread = CreateRealTimeThread(function()
    Msg(thread, f(unpack_params(params)))
  end)
  return select(2, WaitMsg(thread))
end
if FirstLoad then
  ThreadsWaitingSingle = {}
  setmetatable(ThreadsWaitingSingle, {__mode = "v"})
end
function WaitSingleRealTimeThread(f, ...)
  local thread = ThreadsWaitingSingle[f]
  if not thread then
    do
      local params = pack_params(...)
      thread = CreateRealTimeThread(function()
        Msg(thread, f(unpack_params(params)))
        ThreadsWaitingSingle[f] = nil
      end)
      ThreadsWaitingSingle[f] = thread
    end
  else
  end
  return select(2, WaitMsg(thread))
end
function SetThreadDebugHook(hook)
  local set_hook = hook or debug.sethook
  for thread, _ in pairs(ThreadsRegister) do
    set_hook(thread)
  end
  ThreadsEnableDebugHook(hook)
  ThreadDebugHook = hook or false
end
function GetThreadDebugHook()
  return ThreadDebugHook
end
if FirstLoad and not Platform.goldmaster then
  ReportThreads = false
  CreateRealTimeThread(function()
    while true do
      Sleep(1000)
      if (ReportThreads == "full" or ReportThreads == "short") and not IsPaused() then
        local rt_threads, rt_resumes, rt_time, rt_allocs, rt_mem = 0, 0, 0, 0, 0
        local gt_threads, gt_resumes, gt_time, gt_allocs, gt_mem = 0, 0, 0, 0, 0
        local threads = {}
        for thread, src in pairs(ThreadsRegister) do
          local resumes, time, allocs, mem = ThreadProfilerData(thread, "reset")
          if not resumes then
            return
          end
          local info = threads[src]
          if info then
            info.threads = info.threads + 1
            info.resumes = info.resumes + resumes
            info.time = info.time + time
            info.allocs = info.allocs + allocs
            info.mem = info.mem + mem
          else
            threads[src] = {
              name = src,
              threads = 1,
              resumes = resumes,
              time = time,
              allocs = allocs,
              mem = mem
            }
          end
          if IsRealTimeThread(thread) then
            rt_threads = rt_threads + 1
            rt_resumes = rt_resumes + resumes
            rt_time = rt_time + time
            rt_allocs = rt_allocs + allocs
            rt_mem = rt_mem + mem
          else
            gt_threads = gt_threads + 1
            gt_resumes = gt_resumes + resumes
            gt_time = gt_time + time
            gt_allocs = gt_allocs + allocs
            gt_mem = gt_mem + mem
          end
        end
        local list = {}
        local skipped = 0
        for src, info in pairs(threads) do
          if ReportThreads == "full" or info.time > 100 or info.allocs > 200 then
            table.insert(list, info)
          else
            skipped = skipped + 1
          end
        end
        cls()
        print("<tab 400 right>threads<tab 470 right>resumes<tab 540 right>time<tab 610 right>allocs<tab 680 right>mem<tab 750 right>")
        table.sortby_field_descending(list, "time")
        for i = 1, #list do
          local t = list[i]
          local suffix = t.name:sub(1, 6) == "<color" and "</color>" or ""
          printf("%s<tab 400 right>%d<tab 470 right>%d<tab 540 right>%d<tab 610 right>%d<tab 680 right>%d<tab 750 right>%s", t.name, t.threads, t.resumes, t.time, t.allocs, t.mem, suffix)
        end
        if skipped > 0 then
          printf("Skipped %d low impact threads, type ReportThreads='full' to see all", skipped)
        end
        printf("real time threads %d, resumes %d, time %d, allocs %d, mem %d", rt_threads, rt_resumes, rt_time, rt_allocs, rt_mem)
        printf("game time threads %d, resumes %d, time %d, allocs %d, mem %d", gt_threads, gt_resumes, gt_time, gt_allocs, gt_mem)
      end
    end
  end)
end
function OnMsg.PersistGatherPermanents(permanents, direction)
  permanents["cthread.CreateRealTimeThread"] = CreateRealTimeThread
  permanents["cthread.LaunchRealTimeThread"] = LaunchRealTimeThread
  permanents["cthread.CreateGameTimeThread"] = CreateGameTimeThread
  permanents["cthread.ThreadDebugHook"] = ThreadDebugHook
  permanents["cthread.Sleep"] = Sleep
  permanents["cthread.DeleteThread"] = DeleteThread
  permanents["cthread.InterruptAdvance"] = InterruptAdvance
  permanents["cthread.WaitWakeup"] = WaitWakeup
  permanents["cthread.WaitMsg"] = WaitMsg
  permanents["cthread.PlayState"] = CObject.PlayState
end
function OnMsg.PersistSave(data)
  data["cthreads.time"] = GameTime()
  data["cthreads.threads"] = ThreadsPersistSave()
  local message_threads = {}
  for message, threads in pairs(ThreadsMessageToThreads) do
    local t
    for i = 1, #threads do
      local thread = threads[i]
      if ThreadHasFlags(thread, threadPersist) then
        t = t or {}
        t[#t + 1] = thread
      end
    end
    message_threads[message] = t
  end
  data["cthreads.message_threads"] = message_threads
end
function OnMsg.PersistLoad(data)
  ClearGameThreads()
  ResetGameTime(data["cthreads.time"])
  ThreadsPersistLoad(data["cthreads.threads"])
  local message_threads = data["cthreads.message_threads"]
  local message_to_threads = ThreadsMessageToThreads
  local thread_to_message = ThreadsThreadToMessage
  for message, threads in pairs(message_threads) do
    local threads_array = message_to_threads[message]
    if not threads_array then
      threads_array = {}
      message_to_threads[message] = threads_array
    end
    for i = 1, #threads do
      local thread = threads[i]
      threads_array[#threads_array + 1] = thread
      thread_to_message[thread] = message
    end
  end
end
ThreadLockThreads = rawget(_G, "ThreadLockThreads") or {}
ThreadLockWaitingThreads = rawget(_G, "ThreadLockWaitingThreads") or {}
function ThreadLockKey(key, timeout)
  if not CanYield() then
    return false
  end
  local thread = ThreadLockThreads[key]
  if IsValidThread(thread) then
    local waiting_threads = ThreadLockWaitingThreads[key]
    if waiting_threads then
      waiting_threads[#waiting_threads + 1] = CurrentThread()
    else
      waiting_threads = {
        CurrentThread()
      }
      ThreadLockWaitingThreads[key] = waiting_threads
    end
    local success = WaitWakeup(timeout)
    table.remove_entry(waiting_threads, CurrentThread())
    if not waiting_threads[1] and ThreadLockWaitingThreads[key] == waiting_threads then
      ThreadLockWaitingThreads[key] = nil
    end
    return success
  end
  ThreadLockThreads[key] = CurrentThread()
  return true
end
function ThreadUnlockKey(key, ...)
  if CurrentThread() == ThreadLockThreads[key] then
    local waiting_threads = ThreadLockWaitingThreads[key]
    local thread = waiting_threads and waiting_threads[1]
    if waiting_threads then
      table.remove(waiting_threads, 1)
    end
    if not IsValidThread(thread) or not thread then
      thread = nil
    end
    ThreadLockThreads[key] = thread
    Wakeup(thread)
  end
  return ...
end
