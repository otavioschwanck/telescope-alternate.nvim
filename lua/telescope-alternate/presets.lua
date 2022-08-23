local M = {}

M.rails = {
  { "app/models/(.*).rb", {
      "app/controllers/[1:pluralize]_controller.rb",
      "app/views/[1:pluralize]/",
      "app/helpers/[1]_helper.rb",
      "app/serializers/[1]_serializer.rb",
  } },
  { "app/controllers/(.*)_controller.rb", {
      "app/models/[1:singularize].rb",
      "app/views/[1]/",
      "app/helpers/[1:singularize]_helper.rb",
      "app/serializers/[1:singularize]_serializer.rb",
  } },
  { "app/views/(.*)/(.*).html.(.*)", {
      "app/controllers/[1]_controller.rb",
      "app/models/[1:singularize].rb",
      "app/helpers/[1:singularize]_helper.rb",
      "app/serializers/[1:singularize]_serializer.rb",
  } },
}

return M
