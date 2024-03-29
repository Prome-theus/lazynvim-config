return {
    -- tools
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, {
                "stylua", "selene", "luacheck", "shellcheck", "shfmt",
                "tailwindcss-language-server", "typescript-language-server",
                "css-lsp"
            })
        end
    }, -- lsp servers
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = {enabled = true},
            ---@type lspconfig.options
            servers = {
                eslint = {
                    settings = {
                        -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
                        workingDirectory = {mode = "auto"}
                    }
                },
                pyright = {},
                ruff_lsp = {
                    keys = {
                        {
                            "<leader>co",
                            function()
                                vim.lsp.buf.code_action({
                                    apply = true,
                                    context = {
                                        only = {"source.organizeImports"},
                                        diagnostics = {}
                                    }
                                })
                            end,
                            desc = "Organize Imports"
                        }
                    }
                },
                cssls = {},
                tailwindcss = {
                    root_dir = function(...)
                        return require("lspconfig.util").root_pattern(".git")(
                                   ...)
                    end
                },
                tsserver = {
                    root_dir = function(...)
                        return require("lspconfig.util").root_pattern(".git")(
                                   ...)
                    end,
                    single_file_support = false,
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "literal",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = false,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true
                            }
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true
                            }
                        }
                    }
                },
                html = {},
                yamlls = {settings = {yaml = {keyOrdering = false}}},
                lua_ls = {
                    -- enabled = false,
                    single_file_support = true,
                    settings = {
                        Lua = {
                            workspace = {checkThirdParty = false},
                            completion = {
                                workspaceWord = true,
                                callSnippet = "Both"
                            },
                            misc = {
                                parameters = {
                                    -- "--log-level=trace",
                                }
                            },
                            hint = {
                                enable = true,
                                setType = false,
                                paramType = true,
                                paramName = "Disable",
                                semicolon = "Disable",
                                arrayIndex = "Disable"
                            },
                            doc = {privateName = {"^_"}},
                            type = {castNumberToInteger = true},
                            diagnostics = {
                                disable = {
                                    "incomplete-signature-doc", "trailing-space"
                                },
                                -- enable = false,
                                groupSeverity = {
                                    strong = "Warning",
                                    strict = "Warning"
                                },
                                groupFileStatus = {
                                    ["ambiguity"] = "Opened",
                                    ["await"] = "Opened",
                                    ["codestyle"] = "None",
                                    ["duplicate"] = "Opened",
                                    ["global"] = "Opened",
                                    ["luadoc"] = "Opened",
                                    ["redefined"] = "Opened",
                                    ["strict"] = "Opened",
                                    ["strong"] = "Opened",
                                    ["type-check"] = "Opened",
                                    ["unbalanced"] = "Opened",
                                    ["unused"] = "Opened"
                                },
                                unusedLocalExclude = {"_*"}
                            },
                            format = {
                                enable = false,
                                defaultConfig = {
                                    indent_style = "space",
                                    indent_size = "4",
                                    continuation_indent_size = "4"
                                }
                            }
                        }
                    }
                }
            },
            setup = {
                ruff_lsp = function()
                    require("lazyvim.util").lsp.on_attach(function(client, _)
                        if client.name == "ruff_lsp" then
                            -- Disable hover in favor of Pyright
                            client.server_capabilities.hoverProvider = false
                        end
                    end)
                end
            }
        }
    }
}
