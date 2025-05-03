.PHONY = build_zed build_cli build desktop install uninstall clean

all: build install


APP_ID       = dev.zed.Zed
PKGNAME      = zed
LIBNAME      = zed-editor

define INFO
	@echo -e "\033[1;32mINFO\033[0m     $(1)"
endef

define WARNING
	@echo -e "\033[1;31mWARNING\033[0m  $(1)"
endef


build_zed:
	@$(call INFO,Building Zed editor...)
	@cargo build --release --package zed

build_cli:
	@$(call INFO,Building Zed CLI...)
	@cargo build --release --package cli

build: build_zed build_cli


desktop:
	@$(call INFO,Creating .desktop file...)
	@export DO_STARTUP_NOTIFY="true"; \
	export APP_ICON="$(PKGNAME)"; \
	export APP_NAME="Zed"; \
	export APP_CLI="$(PKGNAME)"; \
	export APP_ID="$(APP_ID)"; \
	export APP_ARGS="%U"; \
	envsubst < crates/zed/resources/zed.desktop.in > target/release/$(APP_ID).desktop


install: desktop
	@$(call INFO,Installing components...)
	@sudo mkdir -p "usr/lib/zed/"
	@sudo cp target/release/zed /usr/lib/zed/$(LIBNAME)
	@sudo cp target/release/cli /usr/bin/$(PKGNAME)
	@sudo cp target/release/$(APP_ID).desktop /usr/share/applications/$(APP_ID).desktop
	@sudo cp crates/zed/resources/app-icon.png /usr/share/icons/$(PKGNAME).png
	@$(call INFO,Zed has been successfully installed!)


uninstall:
	@$(call WARNING,Uninstalling Zed...)
	@sudo rm /usr/bin/$(PKGNAME)
	@sudo rm /usr/lib/zed/$(LIBNAME)
	@sudo rm /usr/share/applications/$(APP_ID).desktop
	@sudo rm /usr/share/icons/$(PKGNAME).png
	@$(call INFO,All components successfully uninstalled)


clean:
	@$(call WARNING,Cleaning Zed build cache...)
	@cargo clean
