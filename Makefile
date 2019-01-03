AS65 = ca65
LD65 = ld65
LINKER_CONFIG = ld.cfg
TITLE = innsmouth
SRCDIR = src
OBJLIST = meta main
OBJDIR = obj/nes
INCLUDES = include

OBJLISTNTSC = $(foreach o,$(OBJLIST),$(OBJDIR)/$(o).o)

$(TITLE).nes: $(LINKER_CONFIG) $(OBJLISTNTSC)
	$(LD65) -o $(TITLE).nes -m map.txt -C $^

$(OBJDIR)/%.o: $(SRCDIR)/%.asm $(SRCDIR)/nes.inc $(SRCDIR)/global.inc
	$(AS65) $(CFLAGS65) $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	$(AS65) $(CFLAGS65) $< -o $@

clean:
	-rm -rf $(objdir)/*.o $(objdir)/*.s $(objdir)/*.chr *.nes

play: ${TITLE}.nes
	mesen ${TITLE}.nes
