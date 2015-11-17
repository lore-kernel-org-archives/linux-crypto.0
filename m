From: Zain Wang <zain.wang@rock-chips.com>
Subject: [PATCH v4 0/4] crypto: add crypto accelerator support for rk3288
Date: Tue, 17 Nov 2015 12:00:43 +0800
Message-ID: <1447732847-30514-1-git-send-email-zain.wang@rock-chips.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com, Zain Wang <zain.wang@rock-chips.com>
To: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This commit support three cipher(AES/DES/DES3) and two chainmode(ecb/cbc),
and the more algorithms and new hash drivers will be added later on.

Changed in v4:
- modify irq function
- add devm_add_action in probe
- fix some minor mistakes

Changed in v3:
- add OF depended in Kconfig
- rename some variate
- add reset property
- remove crypto_p variate

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
  crypto: rockchip/crypto - add DT bindings documentation
  clk: rockchip: set an ID for crypto clk
  Crypto: rockchip/crypto - add crypto driver for rk3288
  ARM: dts: rockchip: Add Crypto node for rk3288

 .../devicetree/bindings/crypto/rockchip-crypto.txt |  29 ++
 arch/arm/boot/dts/rk3288.dtsi                      |  12 +
 drivers/clk/rockchip/clk-rk3288.c                  |   2 +-
 drivers/crypto/Kconfig                             |  11 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/rockchip/Makefile                   |   3 +
 drivers/crypto/rockchip/rk3288_crypto.c            | 396 +++++++++++++++++
 drivers/crypto/rockchip/rk3288_crypto.h            | 216 +++++++++
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 489 +++++++++++++++++++++
 include/dt-bindings/clock/rk3288-cru.h             |   1 +
 10 files changed, 1159 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
 create mode 100644 drivers/crypto/rockchip/Makefile
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto.c
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto.h
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c

-- 
1.9.1
