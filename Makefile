AS65 = ca65
LD65 = ld65
LINKER_CONFIG = ld.cfg
TITLE = innsmouth
SRCDIR = src
OBJLIST = meta graphics main
OBJDIR = obj/nes
INCLUDES = include
IMGDIR = tilesets

OBJLISTNTSC = $(foreach o,$(OBJLIST),$(OBJDIR)/$(o).o)

all: $(TITLE).nes

$(TITLE).nes: $(LINKER_CONFIG) $(OBJLISTNTSC)
	$(LD65) -o $(TITLE).nes -m map.txt -C $^

$(OBJDIR)/%.o: $(SRCDIR)/%.asm $(SRCDIR)/nes.inc $(SRCDIR)/global.inc
	$(AS65) $(CFLAGS65) $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	$(AS65) $(CFLAGS65) $< -o $@

# Files that depend on .incbin'd files
$(OBJDIR)/main.o: $(OBJDIR)/bggfx.chr $(OBJDIR)/spritegfx.chr

$(TITLE).chr: $(OBJDIR)/bggfx.chr $(OBJDIR)/spritegfx.chr
	cat $^ > $@

$(OBJDIR)/%.chr: $(IMGDIR)/%.png
	$(PY) tools/pilbmp2nes.py $< $@

$(OBJDIR)/%16.chr: $(IMGDIR)/%.png
	$(PY) tools/pilbmp2nes.py -H 16 $< $@

clean:
	-rm -rf $(OBJDIR)/*.o $(OBJDIR)/*.s $(objdir)/*.chr *.nes

play: ${TITLE}.nes
	mesen ${TITLE}.nes
