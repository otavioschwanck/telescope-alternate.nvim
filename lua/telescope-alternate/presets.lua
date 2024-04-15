local M = {}

M.rails = {
  { 'app/models/(.*).rb', {
    { 'app/controllers/**/*[1:pluralize]_controller.rb', 'Controller' },
    { 'app/views/[1:pluralize]/*.html.erb', 'View' },
    { 'app/helpers/[1]_helper.rb', 'Helper' },
    { 'app/serializers/**/*[1]_serializer.rb', 'Serializer' }
  } },
  { 'app/controllers(.*)/(.*)_controller.rb', {
    { 'app/models/**/*[2:singularize].rb', 'Model' },
    { 'app/views/[1][2]/*.html.erb', 'View' },
    { 'app/helpers/**/*[2]_helper.rb', 'Helper' },
    { 'app/serializers/**/*[2]_serializer.rb', 'Serializer' }
  } },
  { 'app/views/(.*)/(.*).html.(.*)', {
    { 'app/controllers/**/*[1]_controller.rb', 'Controller' },
    { 'app/models/[1:singularize].rb', 'Model' },
    { 'app/helpers/**/*[1]_helper.rb', 'Helper' },
  } },
}

M.rspec = {
  { 'app/(.*).rb', { { 'spec/[1]_spec.rb', 'Test' } } },
  { 'spec/(.*)_spec.rb', { { 'app/[1].rb', 'Original', true } } },
  { 'app/controllers/(.*)_controller.rb', { { 'spec/requests/[1]_spec.rb', 'Request Test' } } },
  { 'spec/requests/(.*)_spec.rb', { { 'app/controllers/[1]_controller.rb', 'Original', true }, } },
}

M.nestjs = {
  { 'src/(.*)/(.*)([.].*).ts', {
    { 'src/[1]/[2].service.ts', 'Service' },
    { 'src/[1]/[2].guard.ts', 'Guard' },
    { 'src/[1]/[2].module.ts', 'Module' },
    { 'src/[1]/[2].controller.spec.ts', 'Test' },
    { 'src/[1]/[2].controller.ts', 'Controller' },
    { 'src/[1]/[2].strategy.ts', 'Strategy' },
    { 'src/[1]/[2].logger.ts', 'Logger' },
  } }
}

local exclude_test_file = function()
  return not string.match(vim.api.nvim_buf_get_name(0), ".*_test.go")
end

M.go = {
  { "(.*).go", { { "[1]_test.go", "Test", exclude_test_file } } },
  { "(.*)_test.go", { { "[1].go", "Original", true } } },
}

M.angular = {
  { "src/(.*)/(.*).ts", {
    { "src/[1]/[2].spec.ts", "Test" },
  } },
  { "src/(.*)/(.*).spec.ts", {
    { "src/[1]/[2].interceptor.ts", "Interceptor" },
    { "src/[1]/[2].directive.ts", "Directive" },
    { "src/[1]/[2].guard.ts", "Guard" },
    { "src/[1]/[2].pipe.ts", "Pipe" },
    { "src/[1]/[2].ts", "Class" },
  } },
  { "src/(.*)/(.*).component.(.*)", {
    { "src/[1]/[2].module.ts", "Module" },
    { "src/[1]/[2].component.ts", "Component" },
    { "src/[1]/[2].service.ts", "Service" },
    { "src/[1]/[2].component.html", "Template" },
    { "src/[1]/[2].component.css", "Styles" },
    { "src/[1]/[2].component.scss", "Styles" },
    { "src/[1]/[2]-routing.module.ts", "Routing" },
  } },
  { "src/(.*)/(.*).service.ts", {
    { "src/[1]/[2].module.ts", "Module" },
    { "src/[1]/[2].component.ts", "Component" },
    { "src/[1]/[2].component.html", "Template" },
    { "src/[1]/[2].component.css", "Styles" },
    { "src/[1]/[2].component.scss", "Styles" },
    { "src/[1]/[2].component.spec.ts", "Test" },
    { "src/[1]/[2]-routing.module.ts", "Routing" },
  } },
  { "src/(.*)/(.*).module.ts", {
    { "src/[1]/[2].component.ts", "Component" },
    { "src/[1]/[2].service.ts", "Service" },
    { "src/[1]/[2].component.html", "Template" },
    { "src/[1]/[2].component.css", "Styles" },
    { "src/[1]/[2].component.scss", "Styles" },
    { "src/[1]/[2].component.spec.ts", "Test" },
    { "src/[1]/[2]-routing.module.ts", "Routing" },
  } },
}


return M
