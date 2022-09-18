local M = {}

M.rails = {
  { "app/models/(.*).rb", {
      { "app/controllers/**/*[1:pluralize]_controller.rb", "Controller" },
      { "app/views/[1:pluralize]/*.html.erb", "View" },
      { "app/helpers/[1]_helper.rb", "Helper" },
      { "app/serializers/**/*[1]_serializer.rb", "Serializer" }
  } },
  { "app/controllers/(.*)_controller.rb", {
  } },
  { "app/views/(.*)/(.*).html.(.*)", {
  } },
}

return M
