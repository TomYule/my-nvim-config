import re

import pynvim
from pynvim import Nvim


@pynvim.plugin
class CasePlugin(object):
    def __init__(self, nvim: Nvim):
        self.nvim = nvim

    @pynvim.command("CamelToSnake", nargs="*", range="")
    def camelToSnak(self, args, range):
        text = self.nvim.funcs.getline(range[0], range[1])
        res = []
        for line in text:
            line = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", line)
            line = re.sub("([a-z0-9])([A-Z])", r"\1_\2", line).lower()
            res.append(line)

        self.nvim.api.exec("vsp", True)
        win = self.nvim.api.get_current_win()
        buf = self.nvim.api.create_buf(True, True)
        self.nvim.api.win_set_buf(win, buf)
        self.nvim.api.buf_set_lines(buf, 0, -1, False, res)

    @pynvim.command("SnakeToCamel", nargs="*", range="", sync=True)
    def snakeToCamel(self, args, range):
        text = self.nvim.funcs.getline(range[0], range[1])
        res = []
        for line in text:
            res.append("".join(word.title() for word in line.split("_")))

        win = self.nvim.api.get_current_win()
        buf = self.nvim.api.create_buf(True, True)
        self.nvim.api.win_set_buf(win, buf)
        self.nvim.api.buf_set_lines(buf, 0, -1, False, res)
