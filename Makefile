.POSIX:
PREFIX = ${HOME}/.local
BIN_LOC = $(DESTDIR)${PREFIX}/bin
NAME = xterm-copyout
.PHONY: install uninstall clean

$(NAME):
	sed "s|@placeholder@|$(NAME)|" xterm-copyout.sh > $(NAME)

install: $(NAME)
	chmod 755 $(NAME)
	mkdir -p $(BIN_LOC)
	cp -v $(NAME) $(BIN_LOC)/

uninstall:
	rm -vf $(BIN_LOC)/$(NAME)

clean:
	rm $(NAME)
