local M = {}

M.rails = {
  { "app/models/(.*).rb", {
    { "app/controllers/**/*[1:pluralize]_controller.rb", "Controller" },
    { "app/views/[1:pluralize]/*.html.erb", "View" },
    { "app/helpers/[1]_helper.rb", "Helper" },
    { "app/serializers/**/*[1]_serializer.rb", "Serializer" }
  } },
  { "app/controllers(.*)/(.*)_controller.rb", {
    { "app/models/**/*[2:singularize].rb", "Model" },
    { "app/views/[1][2]/*.html.erb", "View" },
    { "app/helpers/**/*[2]_helper.rb", "Helper" },
    { "app/serializers/**/*[2]_serializer.rb", "Serializer" }
  } },
  { "app/views/(.*)/(.*).html.(.*)", {
    { "app/controllers/**/*[1]_controller.rb", "Controller" },
    { "app/models/[1:singularize].rb", "Model" },
    { "app/helpers/**/*[1]_helper.rb", "Helper" },
  } },
}

return M
