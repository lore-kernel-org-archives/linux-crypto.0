From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v3 0/2] Add MediaTek crypto accelerator driver
Date: Mon, 19 Dec 2016 10:20:43 +0800
Message-ID: <1482114045-18716-1-git-send-email-ryder.lee@mediatek.com>
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
some SoCs.

This driver currently implement: 
- SHA1 and SHA2 family(HMAC) hash algorithms.
- AES block cipher in CBC/ECB mode with 128/196/256 bits keys.

Chances since v3:
-remove unused structure member
-drop interrupt-parent from DT bindings documentation

Changes since v2:
- use byteorder conversion macros and type identifiers for descriptors
- revise register definition macros to make it more clear
- revise DT compatiable string

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

 .../devicetree/bindings/crypto/mediatek-crypto.txt |   27 +
 drivers/crypto/Kconfig                             |   17 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/mediatek/Makefile                   |    2 +
 drivers/crypto/mediatek/mtk-aes.c                  |  765 +++++++++++
 drivers/crypto/mediatek/mtk-platform.c             |  604 ++++++++
 drivers/crypto/mediatek/mtk-platform.h             |  238 ++++
 drivers/crypto/mediatek/mtk-regs.h                 |  194 +++
 drivers/crypto/mediatek/mtk-sha.c                  | 1437 ++++++++++++++++++++
 9 files changed, 3285 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
 create mode 100644 drivers/crypto/mediatek/Makefile
 create mode 100644 drivers/crypto/mediatek/mtk-aes.c
 create mode 100644 drivers/crypto/mediatek/mtk-platform.c
 create mode 100644 drivers/crypto/mediatek/mtk-platform.h
 create mode 100644 drivers/crypto/mediatek/mtk-regs.h
 create mode 100644 drivers/crypto/mediatek/mtk-sha.c

-- 
1.9.1
