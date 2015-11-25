From: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH v5 0/4] crypto: add crypto accelerator support for rk3288
Date: Wed, 25 Nov 2015 13:43:29 +0800
Message-ID: <1448430213-27203-1-git-send-email-zain.wang@rock-chips.com>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
To: zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Changed in v5:
- copy IV back after operation
- use cra_block_size to tell AES from DES instaed flag AES/TDES

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
 drivers/crypto/rockchip/rk3288_crypto.c            | 393 ++++++++++++++++
 drivers/crypto/rockchip/rk3288_crypto.h            | 216 +++++++++
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 503 +++++++++++++++++++++
 include/dt-bindings/clock/rk3288-cru.h             |   1 +
 10 files changed, 1170 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
 create mode 100644 drivers/crypto/rockchip/Makefile
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto.c
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto.h
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c

-- 
1.9.1


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
