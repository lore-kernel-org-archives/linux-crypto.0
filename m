From: Zain Wang <zain.wang@rock-chips.com>
Subject: [PATCH v2 0/4] Crypto: add crypto accelerator support for rk3288
Date: Fri,  6 Nov 2015 09:17:20 +0800
Message-ID: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com, Zain Wang <zain.wang@rock-chips.com>
To: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.137]:58520 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFBTi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Nov 2015 20:19:38 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This commit support three cipher(AES/DES/DES3) and two chainmode(ecb/cbc),
and the more algorithms and new hash drivers will be added later on.

Changed in v2:
- remove some part about hash
- add weak key detection
- changed some variate's type

Changed in v1:
- modify some variate's name
- modify some variate's type
- modify some return value
- remove or modify some print info
- use more dev_xxx in probe
- modify the prio of cipher
- add Kconfig

Zain Wang (4):
  Crypto: Crypto driver support aes/des/des3 for rk3288
  clk: rockchip: set an id for crypto clk
  ARM: dts: rockchip: Add Crypto drivers for rk3288
  crypto: rockchip/crypto - add DT bindings documentation

 .../devicetree/bindings/crypto/rockchip-crypto.txt |  29 ++
 arch/arm/boot/dts/rk3288.dtsi                      |  15 +
 drivers/clk/rockchip/clk-rk3288.c                  |   2 +-
 drivers/crypto/Kconfig                             |  11 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/rockchip/Makefile                   |   3 +
 drivers/crypto/rockchip/rk3288_crypto.c            | 380 +++++++++++++++
 drivers/crypto/rockchip/rk3288_crypto.h            | 222 +++++++++
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 511 +++++++++++++++++++++
 include/dt-bindings/clock/rk3288-cru.h             |   1 +
 10 files changed, 1174 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
 create mode 100644 drivers/crypto/rockchip/Makefile
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto.c
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto.h
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c

-- 
1.9.1
