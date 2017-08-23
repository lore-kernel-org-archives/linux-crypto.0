From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH v2 0/4] crypto: Add driver for JZ4780 PRNG
Date: Wed, 23 Aug 2017 08:27:03 +0530
Message-ID: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, ralf@linux-mips.org,
        paul@crapouillou.net, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mips@linux-mips.org,
        malat@debian.org, noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34880 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753084AbdHWC5b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 22:57:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series adds support of pseudo random number generator found
in Ingenic's JZ4780 and X1000 SoC.

Based on Paul's review comments, add 'syscon' compatible in CGU node in
jz4780.dtsi. jz4780-rng driver uses regmap exposed via syscon interface
to access the RNG registers. CGU driver is not modified in this patch
set as registers used by CGU driver and this driver are different.

PrasannaKumar Muralidharan (4):
  crypto: jz4780-rng: Add JZ4780 PRNG devicetree binding documentation
  crypto: jz4780-rng: Add Ingenic JZ4780 hardware PRNG driver
  crypto: jz4780-rng: Add RNG node to jz4780.dtsi
  crypto: jz4780-rng: Enable PRNG support in CI20 defconfig

 .../bindings/crypto/ingenic,jz4780-rng.txt         |  20 +++
 MAINTAINERS                                        |   5 +
 arch/mips/boot/dts/ingenic/jz4780.dtsi             |   6 +-
 arch/mips/configs/ci20_defconfig                   |   5 +
 drivers/crypto/Kconfig                             |  19 +++
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/jz4780-rng.c                        | 168 +++++++++++++++++++++
 7 files changed, 223 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
 create mode 100644 drivers/crypto/jz4780-rng.c

-- 
2.10.0
