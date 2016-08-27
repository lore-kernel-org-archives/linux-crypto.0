From: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/4] hw_random: Add driver for Ingenic JZ4780 SoC RNG
Date: Sat, 27 Aug 2016 23:44:53 +0530
Message-ID: <1472321697-3094-1-git-send-email-prasannatsmkumar@gmail.com>
To: mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
        mark.rutland-5wv7dgnIgG8@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org,
        gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
        harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org, prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org, narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org,
        linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This is the v2 patch series that adds support for random number generator
present in Ingenic JZ4780 SoC.

Patch 1: Add device tree bindings for RNG in JZ4780 SoC.
Patch 2: Add Ingenic JZ4780 hardware RNG driver.
Patch 3: Add RNG to jz4780.dtsi.
Patch 4: Enable RNG in ci20_defconfig

PrasannaKumar Muralidharan (4):
  hw_random: jz4780-rng: Add devicetree bindings for RNG in JZ4780 SoC
  hw_random: jz4780-rng: Add Ingenic JZ4780 hardware RNG driver
  hw_random: jz4780-rng: Add RNG node to jz4780.dtsi
  hw_random: jz4780-rng: Enable hardware RNG in CI20 defconfig

 Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt |   12 +
 MAINTAINERS                                                  |    5 
 arch/mips/boot/dts/ingenic/jz4780.dtsi                       |    7 
 arch/mips/configs/ci20_defconfig                             |    4 
 drivers/char/hw_random/Kconfig                               |   14 +
 drivers/char/hw_random/Makefile                              |    1 
 drivers/char/hw_random/jz4780-rng.c                          |  102 +++++++++++
 7 files changed, 143 insertions(+), 2 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
