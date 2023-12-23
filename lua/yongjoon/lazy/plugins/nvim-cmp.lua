return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    "L3MON4D3/LuaSnip", -- snippet engine
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },
  config = function()
    local cmp = require("cmp")

    local luasnip = require("luasnip")

    local lspkind = require("lspkind")

    local s = luasnip.snippet
    local sn = luasnip.snippet_node
    local t = luasnip.text_node
    local i = luasnip.insert_node
    local f = luasnip.function_node
    local c = luasnip.choice_node
    local d = luasnip.dynamic_node
    local r = luasnip.restore_node

    local l = require("luasnip.extras").lambda
    local rep = require("luasnip.extras").rep
    local p = require("luasnip.extras").partial
    local m = require("luasnip.extras").match
    local n = require("luasnip.extras").nonempty
    local dl = require("luasnip.extras").dynamic_lambda
    local fmt = require("luasnip.extras.fmt").fmt
    local fmta = require("luasnip.extras.fmt").fmta
    local types = require("luasnip.util.types")
    local conds = require("luasnip.extras.conditions")
    local conds_expand = require("luasnip.extras.conditions.expand")

    -- complicated function for dynamicNode.
    local function jdocsnip(args, _, old_state)
        -- !!! old_state is used to preserve user-input here. DON'T DO IT THAT WAY!
        -- Using a restoreNode instead is much easier.
        -- View this only as an example on how old_state functions.
        local nodes = {
            t({ "/**", " * " }),
            i(1, "A short Description"),
            t({ "", "" }),
        }

        -- These will be merged with the snippet; that way, should the snippet be updated,
        -- some user input eg. text can be referred to in the new snippet.
        local param_nodes = {}

        if old_state then
            nodes[2] = i(1, old_state.descr:get_text())
        end
        param_nodes.descr = nodes[2]

        -- At least one param.
        if string.find(args[2][1], ", ") then
            vim.list_extend(nodes, { t({ " * ", "" }) })
        end

        local insert = 2
        for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
            -- Get actual name parameter.
            arg = vim.split(arg, " ", true)[2]
            if arg then
                local inode
                -- if there was some text in this parameter, use it as static_text for this new snippet.
                if old_state and old_state[arg] then
                    inode = i(insert, old_state["arg" .. arg]:get_text())
                else
                    inode = i(insert)
                end
                vim.list_extend(
                    nodes,
                    { t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) }
                )
                param_nodes["arg" .. arg] = inode

                insert = insert + 1
            end
        end

        if args[1][1] ~= "void" then
            local inode
            if old_state and old_state.ret then
                inode = i(insert, old_state.ret:get_text())
            else
                inode = i(insert)
            end

            vim.list_extend(
                nodes,
                { t({ " * ", " * @return " }), inode, t({ "", "" }) }
            )
            param_nodes.ret = inode
            insert = insert + 1
        end

        if vim.tbl_count(args[3]) ~= 1 then
            local exc = string.gsub(args[3][2], " throws ", "")
            local ins
            if old_state and old_state.ex then
                ins = i(insert, old_state.ex:get_text())
            else
                ins = i(insert)
            end
            vim.list_extend(
                nodes,
                { t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) }
            )
            param_nodes.ex = ins
            insert = insert + 1
        end

        vim.list_extend(nodes, { t({ " */" }) })

        local snip = sn(nil, nodes)
        -- Error on attempting overwrite.
        snip.old_state = param_nodes
        return snip
    end

    -- Every unspecified option will be set to the default.
    luasnip.setup({
        keep_roots = true,
        link_roots = true,
        link_children = true,

        -- Update more often, :h events for more info.
        update_events = "TextChanged,TextChangedI",
        -- Snippets aren't automatically removed if their text is deleted.
        -- `delete_check_events` determines on which events (:h events) a check for
        -- deleted snippets is performed.
        -- This can be especially useful when `history` is enabled.
        delete_check_events = "TextChanged",
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { "choiceNode", "Comment" } },
                },
            },
        },
        -- treesitter-hl has 100, use something higher (default is 200).
        ext_base_prio = 300,
        -- minimal increase in priority.
        ext_prio_increase = 1,
        enable_autosnippets = true,
        -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
        -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
        store_selection_keys = "<Tab>",
        -- luasnip uses this function to get the currently active filetype. This
        -- is the (rather uninteresting) default, but it's possible to use
        -- eg. treesitter for getting the current filetype by setting ft_func to
        -- require("luasnip.extras.filetype_functions").from_cursor (requires
        -- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
        -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
        ft_func = function()
            return vim.split(vim.bo.filetype, ".", true)
        end,
    })


    luasnip.add_snippets("java", {
        -- Very long example for a java class.
        s("fn", {
            d(6, jdocsnip, { 2, 4, 5 }),
            t({ "", "" }),
            c(1, {
                t("public "),
                t("private "),
            }),
            c(2, {
                t("void"),
                t("String"),
                t("char"),
                t("int"),
                t("double"),
                t("boolean"),
                i(nil, ""),
            }),
            t(" "),
            i(3, "myFunc"),
            t("("),
            i(4),
            t(")"),
            c(5, {
                t(""),
                sn(nil, {
                    t({ "", " throws " }),
                    i(1),
                }),
            }),
            t({ " {", "\t" }),
            i(0),
            t({ "", "}" }),
        }),
    }, { key = "java" })

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
--        { name = "nvim_lsp" },
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })

    vim.keymap.set({"i"}, "<C-K>", function() luasnip.expand() end, {silent = true})
    vim.keymap.set({"i", "s"}, "<C-L>", function() luasnip.jump( 1) end, {silent = true})
    vim.keymap.set({"i", "s"}, "<C-J>", function() luasnip.jump(-1) end, {silent = true})

    vim.keymap.set({"i", "s"}, "<C-E>", function()
        if luasnip.choice_active() then
            luasnip.change_choice(1)
        end
    end, {silent = true})
  end,
}
