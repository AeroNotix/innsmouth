CC65 = cc65
AS65 = ca65
LD65 = ld65
LINKER_CONFIG = ld.cfg
TITLE = innsmouth
SRCDIR = src
OBJLIST = meta palette zp player graphics input main
C_OBJLIST = player graphics
OBJDIR = obj/nes
INCLUDES = include
IMGDIR = tilesets

OBJLISTNTSC = $(foreach o,$(OBJLIST),$(OBJDIR)/$(o).o)
C_FILES = $(foreach o,$(C_OBJLIST),$(SRCDIR)/$(o).asm)

all: ${C_FILES} $(TITLE).nes

$(TITLE).nes: $(LINKER_CONFIG) $(OBJLISTNTSC)
	$(LD65) -o $(TITLE).nes -m map.txt -C $^ nes.lib

$(OBJDIR)/%.o: $(SRCDIR)/%.asm $(SRCDIR)/nes.inc $(SRCDIR)/global.inc
	$(AS65) $(CFLAGS65) $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	$(AS65) $(CFLAGS65) $< -o $@

$(SRCDIR)/%.asm: $(SRCDIR)/%.c
	$(CC65) --include-dir /usr/share/cc65/include/ -Oirs -t nes $< -o $@

# Files that depend on .incbin'd files
$(OBJDIR)/main.o: $(OBJDIR)/bggfx.chr $(OBJDIR)/spritegfx.chr

$(TITLE).chr: $(OBJDIR)/bggfx.chr $(OBJDIR)/spritegfx.chr
	cat $^ > $@

$(OBJDIR)/%.chr: $(IMGDIR)/%.png
	$(PY) tools/pilbmp2nes.py $< $@

$(OBJDIR)/%16.chr: $(IMGDIR)/%.png
	$(PY) tools/pilbmp2nes.py -H 16 $< $@

clean:
	-rm -rf $(OBJDIR)/*.o $(OBJDIR)/*.s $(objdir)/*.chr *.nes ${C_FILES}

play: ${TITLE}.nes
	mesen ${TITLE}.nes

e:
	@echo ${OBJLISTNTSC}
