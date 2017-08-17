From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 0/6] crypto: Add driver for JZ4780 PRNG
Date: Thu, 17 Aug 2017 23:55:14 +0530
Message-ID: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, ralf@linux-mips.org, mturquette@baylibre.com,
        sboyd@codeaurora.org, davem@davemloft.net, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35349 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbdHQSZq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 14:25:46 -0400
Received: by mail-pg0-f65.google.com with SMTP id t80so4943324pgb.2
        for <linux-crypto@vger.kernel.org>; Thu, 17 Aug 2017 11:25:46 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series adds support of pseudo random number generator found
in Ingenic's JZ4780 and X1000 SoC.

The PRNG hardware block registers are a part of same hardware block
that has clock and power registers which is handled by CGU driver.
Ingenic M200 SoC contains power related registers that are present
after the PRNG registers. So instead of reducing the register range,
syscon interface is used to expose a register map that is used by both
CGU driver and this driver. Changes made to jz4740-cgu.c is only compile
tested.

PrasannaKumar Muralidharan (6):
  crypto: jz4780-rng: Add devicetree bindings for RNG in JZ4780 SoC
  crypto: jz4780-rng: Make ingenic CGU driver use syscon
  crypto: jz4780-rng: Add Ingenic JZ4780 hardware PRNG driver
  crypto: jz4780-rng: Add RNG node to jz4780.dtsi
  crypto: jz4780-rng: Add myself as mainatainer for JZ4780 PRNG driver
  crypto: jz4780-rng: Enable PRNG support in CI20 defconfig

 .../devicetree/bindings/rng/ingenic,jz4780-rng.txt |  24 +++
 MAINTAINERS                                        |   5 +
 arch/mips/boot/dts/ingenic/jz4740.dtsi             |  14 +-
 arch/mips/boot/dts/ingenic/jz4780.dtsi             |  18 ++-
 arch/mips/configs/ci20_defconfig                   |   5 +
 drivers/clk/ingenic/cgu.c                          |  46 +++---
 drivers/clk/ingenic/cgu.h                          |   9 +-
 drivers/clk/ingenic/jz4740-cgu.c                   |  30 ++--
 drivers/clk/ingenic/jz4780-cgu.c                   |  10 +-
 drivers/crypto/Kconfig                             |  19 +++
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/jz4780-rng.c                        | 173 +++++++++++++++++++++
 12 files changed, 304 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt
 create mode 100644 drivers/crypto/jz4780-rng.c

-- 
2.10.0
