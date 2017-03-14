From: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Subject: [PATCH 0/4] STM32 CRC crypto driver
Date: Tue, 14 Mar 2017 17:37:22 +0100
Message-ID: <1489509446-32283-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alexandre Torgue <alexandre.torgue-qxv4g6HH51o@public.gmane.org>,
        Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This set of patches adds a new crypto driver for STMicroelectronics stm32f746.
The drivers uses the crypto API and provides with an HW-enabled CRC32 algorithm.
It was developed and tested (tcrypt / testmgr) on evaluation board stm32746g.

Fabien Dessenne (4):
  dt-bindings: Document STM32 CRC bindings
  crypto: stm32 - Support for STM32 CRC32 crypto module
  ARM: dts: stm32: Add CRC support to stm32f746
  ARM: dts: stm32: enable CRC on stm32746g-eval board

 .../devicetree/bindings/crypto/st,stm32-crc.txt    |  16 +
 arch/arm/boot/dts/stm32746g-eval.dts               |   4 +
 arch/arm/boot/dts/stm32f746.dtsi                   |   7 +
 drivers/crypto/Kconfig                             |   2 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/stm32/Kconfig                       |   8 +
 drivers/crypto/stm32/Makefile                      |   2 +
 drivers/crypto/stm32/stm32_crc32.c                 | 325 +++++++++++++++++++++
 8 files changed, 365 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
 create mode 100644 drivers/crypto/stm32/Kconfig
 create mode 100644 drivers/crypto/stm32/Makefile
 create mode 100644 drivers/crypto/stm32/stm32_crc32.c

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
