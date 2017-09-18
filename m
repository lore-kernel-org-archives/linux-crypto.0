From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH v3 0/4] crypto: Add driver for JZ4780 PRNG
Date: Mon, 18 Sep 2017 19:32:37 +0530
Message-ID: <20170918140241.24003-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, robh+dt@kernel.org,
        ralf@linux-mips.org, davem@davemloft.net, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org,
        malat@debian.org, noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38680 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752150AbdIROD5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Sep 2017 10:03:57 -0400
Received: by mail-pg0-f68.google.com with SMTP id m30so289974pgn.5
        for <linux-crypto@vger.kernel.org>; Mon, 18 Sep 2017 07:03:57 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series adds support of pseudo random number generator found
in Ingenic's JZ4780 and X1000 SoC.

Create cgublock node which has CGU and RNG node as its children. The
cgublock node uses "simple-bus" compatible which helps in exposing CGU
and RNG nodes without changing CGU driver. Add 'syscon' compatible in
CGU node in jz4780.dtsi. The jz4780-rng driver uses regmap exposed via
syscon interface to access the RNG registers. CGU driver is not
modified in this patch set as registers used by CGU driver and this
driver are different.

PrasannaKumar Muralidharan (4):
  crypto: jz4780-rng: Add JZ4780 PRNG devicetree binding documentation
  crypto: jz4780-rng: Add Ingenic JZ4780 hardware PRNG driver
  crypto: jz4780-rng: Add RNG node to jz4780.dtsi
  crypto: jz4780-rng: Enable PRNG support in CI20 defconfig

 .../devicetree/bindings/rng/ingenic,jz4780-rng.txt |  21 +++
 MAINTAINERS                                        |   7 +
 arch/mips/boot/dts/ingenic/jz4780.dtsi             |  25 ++-
 arch/mips/configs/ci20_defconfig                   |   5 +
 drivers/crypto/Kconfig                             |  19 ++
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/jz4780-rng.c                        | 193 +++++++++++++++++++++
 7 files changed, 266 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt
 create mode 100644 drivers/crypto/jz4780-rng.c

-- 
2.10.0
