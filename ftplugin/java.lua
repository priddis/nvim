local vars = require('vars')

local java_cmd = 'java'

if vars.java17 then
  java_cmd = vars.java17
end

local mason_registry = require("mason-registry")
if not mason_registry.is_installed("jdtls") then
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.expand('$HOME/.workspace/' .. project_name)
local jdtls_home = mason_registry.get_package("jdtls"):get_install_path()
local jdtls_jar = vim.fn.glob(jdtls_home .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local jdtls_config = jdtls_home .. '/config_linux'

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  on_attach = require("lsp_onattach"),
  cmd = {
    java_cmd,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx2g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', jdtls_jar,
    '-configuration', jdtls_config,
    '-data', workspace_dir,
  },
  root_dir = require('jdtls.setup').find_root({'gradlew'}),

  settings = {
    ["java.import.gradle.enabled"] = true,
    ["java.import.gradle.wrapper.enabled"] = true,
    ["java.jdt.ls.protobufSupport.enabled"] = true,
  },
  init_options = {
    bundles = {}
  },
}

require('jdtls').start_or_attach(config)
