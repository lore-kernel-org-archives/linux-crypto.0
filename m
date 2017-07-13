From: Lionel Debieve <lionel.debieve-qxv4g6HH51o@public.gmane.org>
Subject: [PATCH 0/2] STM32 HASH crypto driver
Date: Thu, 13 Jul 2017 15:32:25 +0200
Message-ID: <1499952747-16423-1-git-send-email-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard-qxv4g6HH51o@public.gmane.org>,
        Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>,
        Ludovic Barre <ludovic.barre-qxv4g6HH51o@public.gmane.org>,
        Lionel Debieve <lionel.debieve-qxv4g6HH51o@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alexandre Torgue <alexandre.torgue-qxv4g6HH51o@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This set of patches adds a new crypto driver for STMicroelectronics stm32 HW.
This drivers uses the crypto API and provides with HW-enabled md5, sha1,
sha224, sha256 hash based algorithms.
It makes use of the crypto engine to support ahash requests.

This driver was successfully tested with tcrypt / testmgr.

Note:
Since two other set of patches (update of STM32 CRC32 and addition of STM32
CRYP) are being proposed, it may happen that there are some minor conflicts in
'Kconfig' and 'Makefile'. In that case, I will fix the issue in due course.

Lionel Debieve (2):
  dt-bindings: Document STM32 HASH bindings
  crypto: stm32 - Support for STM32 HASH module

 .../devicetree/bindings/crypto/st,stm32-hash.txt   |   30 +
 drivers/crypto/stm32/Kconfig                       |   13 +
 drivers/crypto/stm32/Makefile                      |    1 +
 drivers/crypto/stm32/stm32-hash.c                  | 1576 ++++++++++++++++++++
 4 files changed, 1620 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-hash.txt
 create mode 100644 drivers/crypto/stm32/stm32-hash.c

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
