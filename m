From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH v3 0/3] hwrng: stm32 - add support for STM32 HW RNG
Date: Wed, 14 Oct 2015 16:55:22 +0100
Message-ID: <1444838125-3422-1-git-send-email-daniel.thompson@linaro.org>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@linaro.org, linaro-kernel@lists.linaro.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Linus Walleij <linus.walleij@linaro.org>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patchset introduces a driver for the STM32 hardware random number
generator.

Herbert: I have assumed the v2 version is *so* badly broken (sorry
         again for that) that you would probably choose to remove v2
	 completely and replace it with v3. In a moment I will also
	 post a patch to fix the build without ripping out v2. Choose
	 whichever suits you best.

v3:

 * Fixed build with CONFIG_PM (Fengguang Wu). Runtime tested as normal
   and also build tested on stm32 (which has CONFIG_PM set) and on
   x86/COMPILE_TEST with and without CONFIG_PM.

v2:

 * Moved binding docs from .../hwrng/ to .../rng/ and renamed to match
   convention in new directory (Rob Herring).
 * Adopted runtime PM and auto-suspend instead of managing the clocks
   from the read function (Linus Walleij). Increased bandwidth by ~30%.
 * Simplified error detection in main read loop (Linus Walleij, Maxime
   Coquelin).
 * Only WARN_ONCE() when hardware failure mechanisms trigger (Maxime
   Coquelin).
 * Simplify end of probe function after cocci warning (Fengguang Wu).
 * Switch to devm_hwrng_register.


Daniel Thompson (3):
  dt-bindings: Document the STM32 HW RNG bindings
  hwrng: stm32 - add support for STM32 HW RNG
  ARM: dts: stm32f429: Adopt STM32 RNG driver

 .../devicetree/bindings/rng/st,stm32-rng.txt       |  21 +++
 arch/arm/boot/dts/stm32f429.dtsi                   |   7 +
 drivers/char/hw_random/Kconfig                     |  12 ++
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/stm32-rng.c                 | 202 +++++++++++++++++++++
 5 files changed, 243 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/st,stm32-rng.txt
 create mode 100644 drivers/char/hw_random/stm32-rng.c

--
2.4.3
