From: Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH v2 0/3] hw_random: Add Amlogic Meson SoCs Random Generator driver
Date: Fri, 10 Jun 2016 10:21:52 +0200
Message-ID: <1465546915-24229-1-git-send-email-narmstrong@baylibre.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add support for the Amlogic Meson SoCs Hardware Random generator as a hw_random char driver.
The generator is a single 32bit wide register.
Also adds the Meson GXBB SoC DTSI node and corresponding DT bindings.

Changes since v1 at http://lkml.kernel.org/r/1464943621-18278-1-git-send-email-narmstrong@baylibre.com :
- change to depend on ARCH_MESON || COMPILE_TEST
- check buffer max size in read

Neil Armstrong (3):
  char: hw_random: Add Amlogic Meson Hardware Random Generator
  dt-bindings: hwrng: Add Amlogic Meson Hardware Random Generator
    bindings
  ARM64: dts: meson-gxbb: Add Hardware Random Generator node

 .../devicetree/bindings/rng/amlogic,meson-rng.txt  |  14 +++
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |   5 +
 drivers/char/hw_random/Kconfig                     |  14 +++
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/meson-rng.c                 | 131 +++++++++++++++++++++
 5 files changed, 165 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
 create mode 100644 drivers/char/hw_random/meson-rng.c

-- 
2.7.0
