From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v1 0/2] Add MediaTek crypto acclelrator driver
Date: Mon, 5 Dec 2016 15:01:22 +0800
Message-ID: <1480921284-45827-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Roy Luo <cheng-hao.luo@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

This adds support for the MediaTek hardware accelerator on 
mt7623 SoC.

This driver currently implement: 
- SHA1 and SHA2 family(HMAC) hash alogrithms.
- AES block cipher in CBC/ECB mode with 128/196/256 bits keys.

Changes since v1:
- remove EXPORT_SYMBOL
- remove unused PRNG setting
- sort headers in alphabetical order
- add a definition for IRQ unmber
- replace ambiguous definition
- add more annotation and function comment
- add COMPILE_TEST in Kconfig


Ryder Lee (2):
  Add crypto driver support for some MediaTek chips
  crypto: mediatek - add DT bindings documentation

 .../devicetree/bindings/crypto/mediatek-crypto.txt |   32 +
 drivers/crypto/Kconfig                             |   17 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/mediatek/Makefile                   |    2 +
 drivers/crypto/mediatek/mtk-aes.c                  |  763 +++++++++++
 drivers/crypto/mediatek/mtk-platform.c             |  580 ++++++++
 drivers/crypto/mediatek/mtk-platform.h             |  235 ++++
 drivers/crypto/mediatek/mtk-regs.h                 |  194 +++
 drivers/crypto/mediatek/mtk-sha.c                  | 1423 ++++++++++++++++++++
 9 files changed, 3247 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
 create mode 100644 drivers/crypto/mediatek/Makefile
 create mode 100644 drivers/crypto/mediatek/mtk-aes.c
 create mode 100644 drivers/crypto/mediatek/mtk-platform.c
 create mode 100644 drivers/crypto/mediatek/mtk-platform.h
 create mode 100644 drivers/crypto/mediatek/mtk-regs.h
 create mode 100644 drivers/crypto/mediatek/mtk-sha.c

-- 
1.9.1
