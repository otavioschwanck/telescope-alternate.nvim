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

M.nestjs = {
  	{ 'src/(.*)/(.*)([.].*).ts', {
			{ "src/[1]/[2].service.ts", "Service" },
			{ "src/[1]/[2].guard.ts", "Guard" },
			{ "src/[1]/[2].module.ts", "Module" },
			{ "src/[1]/[2].controller.spec.ts", "Test" },
			{ "src/[1]/[2].controller.ts", "Controller" },
			{ "src/[1]/[2].strategy.ts", "Strategy" },
			{ "src/[1]/[2].logger.ts", "Logger" },
		} }
}

return M
