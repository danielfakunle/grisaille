local M = {}

function M.for_axes(temperature, depth)
  return 'grisaille'
    .. (temperature == 'balanced' and '' or '-' .. temperature)
    .. (depth == 'hard' and '' or '-' .. depth)
end

return M
