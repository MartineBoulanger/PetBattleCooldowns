local _, PBC = ...

local Events = PBC.Events

function Events.CreateHandler(handlers)
  return function(self, event, ...)
    local handler = handlers[event]

    if handler then
      handler(self, ...)
    end
  end
end

function Events.RegisterAll(frame, handlers)
  for event in pairs(handlers) do
    frame:RegisterEvent(event)
  end
end
