From: Zain Wang <zain.wang@rock-chips.com>
Subject: [RESEND PATCH 0/4] Crypto: add crypto accelerator support for rk3288
Date: Fri, 30 Oct 2015 16:22:45 +0800
Message-ID: <1446193369-4453-1-git-send-email-zain.wang@rock-chips.com>
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
and the more algorithms or new hash drivers will be added later on.

Zain Wang (4):
  Crypto: Crypto driver support aes/des/des3 for rk3288
  clk: rockchip: set an id for crypto clk
  ARM: dts: rockchip: Add Crypto drivers for rk3288
  crypto: rk_crypto - add DT bindings documentation

 .../devicetree/bindings/crypto/rk-crypto.txt       |  31 ++
 arch/arm/boot/dts/rk3288.dtsi                      |  16 +
 drivers/clk/rockchip/clk-rk3288.c                  |   2 +-
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/rk_crypto/Makefile                  |   3 +
 drivers/crypto/rk_crypto/rk3288_crypto.c           | 393 ++++++++++++++++
 drivers/crypto/rk_crypto/rk3288_crypto.h           | 291 ++++++++++++
 .../crypto/rk_crypto/rk3288_crypto_ablkcipher.c    | 502 +++++++++++++++++++++
 8 files changed, 1238 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rk-crypto.txt
 create mode 100644 drivers/crypto/rk_crypto/Makefile
 create mode 100644 drivers/crypto/rk_crypto/rk3288_crypto.c
 create mode 100644 drivers/crypto/rk_crypto/rk3288_crypto.h
 create mode 100644 drivers/crypto/rk_crypto/rk3288_crypto_ablkcipher.c

-- 
1.9.1
