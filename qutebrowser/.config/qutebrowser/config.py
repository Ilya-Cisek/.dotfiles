config.load_autoconfig()

# Close tabs with x instead of d in normal mode.
config.bind("x", "tab-close")
config.unbind("d")

# Default page and automatic restoration of open tabs/windows.
c.url.start_pages = ["https://www.google.com/"]
c.url.default_page = "https://www.google.com/"
c.auto_save.session = True

# Use the local HTTP proxy for both HTTP and HTTPS traffic by default.
c.content.proxy = "http://127.0.0.1:7897"
c.aliases["set_proxy"] = "set content.proxy http://127.0.0.1:7897"
c.aliases["disable_proxy"] = "set content.proxy none"

# Search engine
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "yt": "https://youtube.com{}",
    "gh": "https://github.com{}",
    "w": "https://wikipedia.org{}",
}

# Dark theme
c.colors.webpage.darkmode.enabled = True
