all:
	$(MAKE) -C bloomd
	$(MAKE) -C bloomcmd
	$(MAKE) -C libbloom

clean:
	$(MAKE) clean -C bloomd
	$(MAKE) clean -C bloomcmd
	$(MAKE) clean -C libbloom
