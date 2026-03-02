Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C79F362147
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 11:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772450540; cv=none; b=T1MxirSbgVNQgkupM/DUdUhfGunASykKIC8CIZoZ1FOolzObG+kpz6xweWnPXTK3frGVqit5VHb9HOKYK4FWjVZqQQNF5QqZomqVn9dSKuWjRMW8+PL3Kvthk7aDCPR2nKdYzrpdB/FULnnUL5SlHhwpUI6a1JyndiLeXZ/ftjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772450540; c=relaxed/simple;
	bh=yKxKlPFwHHfnfIe8NOO4ftQvMM/ItC6tkW/NSKi27zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIgC+9RbujNJHnYORK2Q7oNE9HQNKRPtXSeBQY94lJEwwtqoLMkNg7qjk/owCeL2xLrGCaDhmO71DTO7RTMTKzCAFqfiUunmd6nGp3X6KQDSeRZuyJ5dGEV/L1QD2B3wA4/Pl+Pr0dFynwbmPwNI9iRGM0udu0+5kGlLPfGFU4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=ljScMi+O; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="ljScMi+O"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4836f363ad2so52064955e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 03:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1772450532; x=1773055332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thg/hbiihCY04+UIp7gvux8UYhsB5SO5bPjGIUDMt48=;
        b=ljScMi+OQEMU8TGdiJSIysgosjuFC6GFHRBfIXQqHpsu3j9gBh1wL02JtzqGeUMTxQ
         wwqTlP68Q00cvVn+cq/mW47AUg9Byaxxtaakk45I1n6G1dRCt611W1S/1csqmp7u66f2
         aK91Lh5n05RJzFdM3jWGUg0of+LCGx9mwj2D8CcJ0LbGNWsgClTdZvMV7a9DKQWJDciE
         8yFcgqZwaZIZM+WqTb8TWx0Og7gnHU8Pcy3okPGt1+ZZ6PY651jNPrBq248TUnLqep7T
         LO3TJ3XThka1ceOlpg1pNNDz4gdA5ATGaei6mwM8aBDvLL8lLr9+mUynfoiDjDR2vU4P
         5rOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450532; x=1773055332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=thg/hbiihCY04+UIp7gvux8UYhsB5SO5bPjGIUDMt48=;
        b=Z9Y7dFdSLyLV6d1q1jRqELJ+iLpBcgbYv5DCOtuTPCoTw04n3cNy7BfQcvm3raMJNT
         p3XPNI1TQwXDjrEkJmWVQON/NiRRN4I+1W1nM/UTJy6h9wh1MbfMdPVssBT9PRCQamE0
         d3Xy1UvX6ABoz3ZbI92J8QujlFQcjZ4bzr+lEsdCvgU/k6XlYzstwdLdTVkP3NiSMNra
         lb4fPCxjUvnyUhso0WccFpTSlGSBsDkbN57Yjk6CyvZpqhykHOPgUX24Q/Fo1Hw/fIl4
         2a720uqqOOQY5ZsPos3NSh3uzmakko0skvt/sXptEFKI4fdZ3+5Xu8n+2AehRedFdHvB
         lirQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwSKiT+CBMl4/bmXwTQJwyxmrliX5D/8hVFCvEI+XFCb6EWULmVgJFzV0yogtXitX8/s5NpSPIqxUG9w0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf7gUWWKsyIVKItVCkiE1VJSMTqkrnJrmpVlYw0/uYqtS6d8mp
	Zj2MNStayfTOdfDc7rvre33yKvFlX1P9pRb57g7JRBwDqZzwb2zm2FxJhz4F3hklGgA=
X-Gm-Gg: ATEYQzzJ/NNJgW3sdr5I+ONvc2asrzRQUSugt/HeUGMhqectvTeLgk/jyB47sLZtDf1
	m6/QQyzeBxMiunK9GCEBsNHRf0e8Djbj3EaxCcMr0j9SF7TZ6rE+1qo5IIAeRqNd+cCuMEFsIK1
	Lw7jFiaAlnHZFBtMS2h/Tntu9y0eEr+ssxc2cFPpeYgVJ7nvD3LVu+/YlMumpperL48vWPtsHe8
	gkQcHbEO+qXENZlW3qtuQOIfQg+b8P9pZgBiizovbBlEsXZR/vH3+mQ+gIEX8vgZkQW0izdyeZI
	6YX+g9Jnw2VNh27Cpy9UiOgJgWTdpTMg84XPKDcf+MbLUt1xJjalYdMsN1h+zXiNgxgCHnlHfjM
	Dd4J+5+omVLF/RjKG99AKIsDJI7U+KEw9PdxALjfmLAxpwtqwe9B7NFHFoM83EdKySYo6Lon8hz
	zy7Dk3kIUtR190udcmwfbYFRd+4iubn2pMSUWHABBlIsO3/3xRb2nQRX3OI8eoLjOOhyowEPbwN
	5SBtUFQjBwXwNV7vh2xIjYFAQcr8v64Oh6frBSTUaU=
X-Received: by 2002:a05:600c:468f:b0:477:7bca:8b2b with SMTP id 5b1f17b1804b1-483c9bca601mr213676955e9.15.1772450532402;
        Mon, 02 Mar 2026 03:22:12 -0800 (PST)
Received: from fedora (cpe-109-60-83-135.zg3.cable.xnet.hr. [109.60.83.135])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-483bfbb465bsm292493035e9.3.2026.03.02.03.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:22:12 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	horatiu.vultur@microchip.com,
	Ryan.Wanner@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	daniel.machon@microchip.com
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v6 6/6] arm64: dts: microchip: add EV23X71A board
Date: Mon,  2 Mar 2026 12:20:14 +0100
Message-ID: <20260302112153.464422-7-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302112153.464422-1-robert.marko@sartura.hr>
References: <20260302112153.464422-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Microchip EV23X71A is an LAN9696 based evaluation board.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Acked-by: Daniel Machon <daniel.machon@microchip.com>
Tested-by: Daniel Machon <daniel.machon@microchip.com>
---
Changes in v6:
* Pick Reviewed-by from Claudiu
* Pick Tested-by and Acked-by from Daniel

Changes in v5:
* Remove phys property from port 29
* Alphanumericaly sort pin nodes

Changes in v2:
* Split from SoC DTSI commit
* Apply DTS coding style
* Enclose array in i2c-mux
* Alphanumericaly sort nodes
* Change management port mode to RGMII-ID 

 arch/arm64/boot/dts/microchip/Makefile        |   1 +
 .../boot/dts/microchip/lan9696-ev23x71a.dts   | 756 ++++++++++++++++++
 2 files changed, 757 insertions(+)
 create mode 100644 arch/arm64/boot/dts/microchip/lan9696-ev23x71a.dts

diff --git a/arch/arm64/boot/dts/microchip/Makefile b/arch/arm64/boot/dts/microchip/Makefile
index c6e0313eea0f..09d16fc1ce9a 100644
--- a/arch/arm64/boot/dts/microchip/Makefile
+++ b/arch/arm64/boot/dts/microchip/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+dtb-$(CONFIG_ARCH_LAN969X) += lan9696-ev23x71a.dtb
 dtb-$(CONFIG_ARCH_SPARX5) += sparx5_pcb125.dtb
 dtb-$(CONFIG_ARCH_SPARX5) += sparx5_pcb134.dtb sparx5_pcb134_emmc.dtb
 dtb-$(CONFIG_ARCH_SPARX5) += sparx5_pcb135.dtb sparx5_pcb135_emmc.dtb
diff --git a/arch/arm64/boot/dts/microchip/lan9696-ev23x71a.dts b/arch/arm64/boot/dts/microchip/lan9696-ev23x71a.dts
new file mode 100644
index 000000000000..4012ea7d07bb
--- /dev/null
+++ b/arch/arm64/boot/dts/microchip/lan9696-ev23x71a.dts
@@ -0,0 +1,756 @@
+// SPDX-License-Identifier: (GPL-2.0-or-later OR MIT)
+/*
+ * Copyright (c) 2025 Microchip Technology Inc. and its subsidiaries.
+ */
+
+/dts-v1/;
+
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/leds/common.h>
+#include "lan9691.dtsi"
+
+/ {
+	model = "Microchip EV23X71A";
+	compatible = "microchip,ev23x71a", "microchip,lan9696", "microchip,lan9691";
+
+	aliases {
+		serial0 = &usart0;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+	};
+
+	gpio-restart {
+		compatible = "gpio-restart";
+		gpios = <&gpio 60 GPIO_ACTIVE_LOW>;
+		open-source;
+		priority = <200>;
+	};
+
+	i2c-mux {
+		compatible = "i2c-mux-gpio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		i2c-parent = <&i2c3>;
+		idle-state = <0x8>;
+		mux-gpios = <&sgpio_out 0 1 GPIO_ACTIVE_HIGH>,
+			    <&sgpio_out 0 2 GPIO_ACTIVE_HIGH>,
+			    <&sgpio_out 0 3 GPIO_ACTIVE_HIGH>;
+		settle-time-us = <100>;
+
+		i2c_sfp0: i2c@0 {
+			reg = <0x0>;
+		};
+
+		i2c_sfp1: i2c@1 {
+			reg = <0x1>;
+		};
+
+		i2c_sfp2: i2c@2 {
+			reg = <0x2>;
+		};
+
+		i2c_sfp3: i2c@3 {
+			reg = <0x3>;
+		};
+
+		i2c_poe: i2c@7 {
+			reg = <0x7>;
+		};
+	};
+
+	leds {
+		compatible = "gpio-leds";
+
+		led-status {
+			color = <LED_COLOR_ID_GREEN>;
+			function = LED_FUNCTION_STATUS;
+			gpios = <&gpio 61 GPIO_ACTIVE_LOW>;
+		};
+
+		led-sfp1-green {
+			color = <LED_COLOR_ID_GREEN>;
+			function = LED_FUNCTION_LAN;
+			function-enumerator = <0>;
+			gpios = <&sgpio_out 6 0 GPIO_ACTIVE_LOW>;
+			default-state = "off";
+		};
+
+		led-sfp1-yellow {
+			color = <LED_COLOR_ID_YELLOW>;
+			function = LED_FUNCTION_LAN;
+			function-enumerator = <0>;
+			gpios = <&sgpio_out 6 1 GPIO_ACTIVE_LOW>;
+			default-state = "off";
+		};
+
+		led-sfp2-green {
+			color = <LED_COLOR_ID_GREEN>;
+			function = LED_FUNCTION_LAN;
+			function-enumerator = <1>;
+			gpios = <&sgpio_out 7 0 GPIO_ACTIVE_LOW>;
+			default-state = "off";
+		};
+
+		led-sfp2-yellow {
+			color = <LED_COLOR_ID_YELLOW>;
+			function = LED_FUNCTION_LAN;
+			function-enumerator = <1>;
+			gpios = <&sgpio_out 7 1 GPIO_ACTIVE_LOW>;
+			default-state = "off";
+		};
+
+		led-sfp3-green {
+			color = <LED_COLOR_ID_GREEN>;
+			function = LED_FUNCTION_LAN;
+			function-enumerator = <2>;
+			gpios = <&sgpio_out 8 0 GPIO_ACTIVE_LOW>;
+			default-state = "off";
+		};
+
+		led-sfp3-yellow {
+			color = <LED_COLOR_ID_YELLOW>;
+			function = LED_FUNCTION_LAN;
+			function-enumerator = <2>;
+			gpios = <&sgpio_out 8 1 GPIO_ACTIVE_LOW>;
+			default-state = "off";
+		};
+
+		led-sfp4-green {
+			color = <LED_COLOR_ID_GREEN>;
+			function = LED_FUNCTION_LAN;
+			function-enumerator = <3>;
+			gpios = <&sgpio_out 9 0 GPIO_ACTIVE_LOW>;
+			default-state = "off";
+		};
+
+		led-sfp4-yellow {
+			color = <LED_COLOR_ID_YELLOW>;
+			function = LED_FUNCTION_LAN;
+			function-enumerator = <3>;
+			gpios = <&sgpio_out 9 1 GPIO_ACTIVE_LOW>;
+			default-state = "off";
+		};
+	};
+
+	mux-controller {
+		compatible = "gpio-mux";
+		#mux-control-cells = <0>;
+		mux-gpios = <&sgpio_out 1 2 GPIO_ACTIVE_LOW>,
+			    <&sgpio_out 1 3 GPIO_ACTIVE_LOW>;
+	};
+
+	sfp0: sfp0 {
+		compatible = "sff,sfp";
+		i2c-bus = <&i2c_sfp0>;
+		tx-disable-gpios = <&sgpio_out 6 2 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sgpio_in 6 0 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sgpio_in 6 1 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios = <&sgpio_in 6 2 GPIO_ACTIVE_HIGH>;
+	};
+
+	sfp1: sfp1 {
+		compatible = "sff,sfp";
+		i2c-bus = <&i2c_sfp1>;
+		tx-disable-gpios = <&sgpio_out 7 2 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sgpio_in 7 0 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sgpio_in 7 1 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios = <&sgpio_in 7 2 GPIO_ACTIVE_HIGH>;
+	};
+
+	sfp2: sfp2 {
+		compatible = "sff,sfp";
+		i2c-bus = <&i2c_sfp2>;
+		tx-disable-gpios = <&sgpio_out 8 2 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sgpio_in 8 0 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sgpio_in 8 1 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios = <&sgpio_in 8 2 GPIO_ACTIVE_HIGH>;
+	};
+
+	sfp3: sfp3 {
+		compatible = "sff,sfp";
+		i2c-bus = <&i2c_sfp3>;
+		tx-disable-gpios = <&sgpio_out 9 2 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sgpio_in 9 0 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sgpio_in 9 1 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios = <&sgpio_in 9 2 GPIO_ACTIVE_HIGH>;
+	};
+};
+
+&gpio {
+	emmc_sd_pins: emmc-sd-pins {
+		/* eMMC_SD - CMD, CLK, D0, D1, D2, D3, D4, D5, D6, D7, RSTN */
+		pins = "GPIO_14", "GPIO_15", "GPIO_16", "GPIO_17",
+		       "GPIO_18", "GPIO_19", "GPIO_20", "GPIO_21",
+		       "GPIO_22", "GPIO_23", "GPIO_24";
+		function = "emmc_sd";
+	};
+
+	fan_pins: fan-pins {
+		pins = "GPIO_25", "GPIO_26";
+		function = "fan";
+	};
+
+	fc0_pins: fc0-pins {
+		pins = "GPIO_3", "GPIO_4";
+		function = "fc";
+	};
+
+	fc2_pins: fc2-pins {
+		pins = "GPIO_64", "GPIO_65", "GPIO_66";
+		function = "fc";
+	};
+
+	fc3_pins: fc3-pins {
+		pins = "GPIO_55", "GPIO_56";
+		function = "fc";
+	};
+
+	mdio_irq_pins: mdio-irq-pins {
+		pins = "GPIO_11";
+		function = "miim_irq";
+	};
+
+	mdio_pins: mdio-pins {
+		pins = "GPIO_9", "GPIO_10";
+		function = "miim";
+	};
+
+	ptp_ext_pins: ptp-ext-pins {
+		pins = "GPIO_59";
+		function = "ptpsync_5";
+	};
+
+	ptp_out_pins: ptp-out-pins {
+		pins = "GPIO_58";
+		function = "ptpsync_4";
+	};
+
+	sgpio_pins: sgpio-pins {
+		/* SCK, D0, D1, LD */
+		pins = "GPIO_5", "GPIO_6", "GPIO_7", "GPIO_8";
+		function = "sgpio_a";
+	};
+
+	usb_over_pins: usb-over-pins {
+		pins = "GPIO_13";
+		function = "usb_over_detect";
+	};
+
+	usb_power_pins: usb-power-pins {
+		pins = "GPIO_1";
+		function = "usb_power";
+	};
+
+	usb_rst_pins: usb-rst-pins {
+		pins = "GPIO_12";
+		function = "usb2phy_rst";
+	};
+
+	usb_ulpi_pins: usb-ulpi-pins {
+		pins = "GPIO_30", "GPIO_31", "GPIO_32", "GPIO_33",
+		       "GPIO_34", "GPIO_35", "GPIO_36", "GPIO_37",
+		       "GPIO_38", "GPIO_39", "GPIO_40", "GPIO_41";
+		function = "usb_ulpi";
+	};
+};
+
+&flx0 {
+	atmel,flexcom-mode = <ATMEL_FLEXCOM_MODE_USART>;
+	status = "okay";
+};
+
+&flx2 {
+	atmel,flexcom-mode = <ATMEL_FLEXCOM_MODE_SPI>;
+	status = "okay";
+};
+
+&flx3 {
+	atmel,flexcom-mode = <ATMEL_FLEXCOM_MODE_TWI>;
+	status = "okay";
+};
+
+&i2c3 {
+	pinctrl-0 = <&fc3_pins>;
+	pinctrl-names = "default";
+	i2c-analog-filter;
+	i2c-digital-filter;
+	i2c-digital-filter-width-ns = <35>;
+	i2c-sda-hold-time-ns = <1500>;
+	status = "okay";
+};
+
+&mdio0 {
+	pinctrl-0 = <&mdio_pins>, <&mdio_irq_pins>;
+	pinctrl-names = "default";
+	reset-gpios = <&gpio 62 GPIO_ACTIVE_LOW>;
+	status = "okay";
+
+	phy3: phy@3 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <3>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy4: phy@4 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <4>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy5: phy@5 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <5>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy6: phy@6 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <6>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy7: phy@7 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <7>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy8: phy@8 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <8>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy9: phy@9 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <9>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy10: phy@10 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <10>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy11: phy@11 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <11>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy12: phy@12 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <12>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy13: phy@13 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <13>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy14: phy@14 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <14>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy15: phy@15 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <15>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy16: phy@16 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <16>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy17: phy@17 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <17>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy18: phy@18 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <18>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy19: phy@19 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <19>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy20: phy@20 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <20>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy21: phy@21 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <21>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy22: phy@22 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <22>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy23: phy@23 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <23>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy24: phy@24 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <24>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy25: phy@25 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <25>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy26: phy@26 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <26>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+
+	phy27: phy@27 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <27>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio>;
+	};
+};
+
+&serdes {
+	status = "okay";
+};
+
+&sgpio {
+	pinctrl-0 = <&sgpio_pins>;
+	pinctrl-names = "default";
+	microchip,sgpio-port-ranges = <0 1>, <6 9>;
+	status = "okay";
+
+	gpio@0 {
+		ngpios = <128>;
+	};
+	gpio@1 {
+		ngpios = <128>;
+	};
+};
+
+&spi2 {
+	pinctrl-0 = <&fc2_pins>;
+	pinctrl-names = "default";
+	cs-gpios = <&gpio 63 GPIO_ACTIVE_LOW>;
+	status = "okay";
+};
+
+&switch {
+	pinctrl-0 = <&ptp_out_pins>, <&ptp_ext_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+
+	ethernet-ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port0: port@0 {
+			reg = <0>;
+			phy-handle = <&phy4>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 0>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port1: port@1 {
+			reg = <1>;
+			phy-handle = <&phy5>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 0>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port2: port@2 {
+			reg = <2>;
+			phy-handle = <&phy6>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 0>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port3: port@3 {
+			reg = <3>;
+			phy-handle = <&phy7>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 0>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port4: port@4 {
+			reg = <4>;
+			phy-handle = <&phy8>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 1>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port5: port@5 {
+			reg = <5>;
+			phy-handle = <&phy9>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 1>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port6: port@6 {
+			reg = <6>;
+			phy-handle = <&phy10>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 1>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port7: port@7 {
+			reg = <7>;
+			phy-handle = <&phy11>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 1>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port8: port@8 {
+			reg = <8>;
+			phy-handle = <&phy12>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 2>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port9: port@9 {
+			reg = <9>;
+			phy-handle = <&phy13>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 2>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port10: port@10 {
+			reg = <10>;
+			phy-handle = <&phy14>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 2>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port11: port@11 {
+			reg = <11>;
+			phy-handle = <&phy15>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 2>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port12: port@12 {
+			reg = <12>;
+			phy-handle = <&phy16>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 3>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port13: port@13 {
+			reg = <13>;
+			phy-handle = <&phy17>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 3>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port14: port@14 {
+			reg = <14>;
+			phy-handle = <&phy18>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 3>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port15: port@15 {
+			reg = <15>;
+			phy-handle = <&phy19>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 3>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port16: port@16 {
+			reg = <16>;
+			phy-handle = <&phy20>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 4>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port17: port@17 {
+			reg = <17>;
+			phy-handle = <&phy21>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 4>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port18: port@18 {
+			reg = <18>;
+			phy-handle = <&phy22>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 4>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port19: port@19 {
+			reg = <19>;
+			phy-handle = <&phy23>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 4>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port20: port@20 {
+			reg = <20>;
+			phy-handle = <&phy24>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 5>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port21: port@21 {
+			reg = <21>;
+			phy-handle = <&phy25>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 5>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port22: port@22 {
+			reg = <22>;
+			phy-handle = <&phy26>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 5>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port23: port@23 {
+			reg = <23>;
+			phy-handle = <&phy27>;
+			phy-mode = "qsgmii";
+			phys = <&serdes 5>;
+			microchip,bandwidth = <1000>;
+		};
+
+		port24: port@24 {
+			reg = <24>;
+			phys = <&serdes 6>;
+			phy-mode = "10gbase-r";
+			sfp = <&sfp0>;
+			managed = "in-band-status";
+			microchip,bandwidth = <10000>;
+			microchip,sd-sgpio = <24>;
+		};
+
+		port25: port@25 {
+			reg = <25>;
+			phys = <&serdes 7>;
+			phy-mode = "10gbase-r";
+			sfp = <&sfp1>;
+			managed = "in-band-status";
+			microchip,bandwidth = <10000>;
+			microchip,sd-sgpio = <28>;
+		};
+
+		port26: port@26 {
+			reg = <26>;
+			phys = <&serdes 8>;
+			phy-mode = "10gbase-r";
+			sfp = <&sfp2>;
+			managed = "in-band-status";
+			microchip,bandwidth = <10000>;
+			microchip,sd-sgpio = <32>;
+		};
+
+		port27: port@27 {
+			reg = <27>;
+			phys = <&serdes 9>;
+			phy-mode = "10gbase-r";
+			sfp = <&sfp3>;
+			managed = "in-band-status";
+			microchip,bandwidth = <10000>;
+			microchip,sd-sgpio = <36>;
+		};
+
+		port29: port@29 {
+			reg = <29>;
+			phy-handle = <&phy3>;
+			phy-mode = "rgmii-id";
+			microchip,bandwidth = <1000>;
+		};
+	};
+};
+
+&tmon {
+	pinctrl-0 = <&fan_pins>;
+	pinctrl-names = "default";
+};
+
+&usart0 {
+	pinctrl-0 = <&fc0_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&usb {
+	pinctrl-0 = <&usb_ulpi_pins>, <&usb_rst_pins>, <&usb_over_pins>, <&usb_power_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+};
-- 
2.53.0

