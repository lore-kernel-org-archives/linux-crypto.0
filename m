From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 0/2] Add MediaTek crypto acclelrator driver
Date: Fri, 2 Dec 2016 11:26:43 +0800
Message-ID: <1480649205-52695-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sean Wang <sean.wnag@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:16701 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751227AbcLBD05 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2016 22:26:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds support for the MediaTek hardware accelerator on 
mt7623 SoC.

This driver currently implement: 
- SHA1 and SHA2 family(HMAC) hash alogrithms.
- AES block cipher in CBC/ECB mode with 128/196/256 bits keys.

Ryder Lee (2):
  Add crypto driver support for some MediaTek chips
  crypto: mediatek - add DT bindings documentation

 .../devicetree/bindings/crypto/mediatek-crypto.txt |   32 +
 drivers/crypto/Kconfig                             |   17 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/mediatek/Makefile                   |    2 +
 drivers/crypto/mediatek/mtk-aes.c                  |  734 +++++++++++
 drivers/crypto/mediatek/mtk-platform.c             |  575 ++++++++
 drivers/crypto/mediatek/mtk-platform.h             |  230 ++++
 drivers/crypto/mediatek/mtk-regs.h                 |  194 +++
 drivers/crypto/mediatek/mtk-sha.c                  | 1384 ++++++++++++++++++++
 9 files changed, 3169 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
 create mode 100644 drivers/crypto/mediatek/Makefile
 create mode 100644 drivers/crypto/mediatek/mtk-aes.c
 create mode 100644 drivers/crypto/mediatek/mtk-platform.c
 create mode 100644 drivers/crypto/mediatek/mtk-platform.h
 create mode 100644 drivers/crypto/mediatek/mtk-regs.h
 create mode 100644 drivers/crypto/mediatek/mtk-sha.c

-- 
1.9.1
