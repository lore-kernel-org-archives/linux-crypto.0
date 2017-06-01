From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v1 0/2] remove mediatek ethif clock in crypto driver
Date: Thu, 1 Jun 2017 10:30:20 +0800
Message-ID: <1496284222-12560-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:62779 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751052AbdFACai (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 May 2017 22:30:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series only remove redundant clock setting in mediatek crypto driver.

Changes since v1:
-rework the commit message.

Ryder Lee (2):
  crypto: mediatek - remove redundant clock setting
  dt-bindings: crypto: remove mediatek ethif clock

 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt |  8 +++-----
 drivers/crypto/mediatek/mtk-platform.c                       | 10 +---------
 drivers/crypto/mediatek/mtk-platform.h                       |  2 --
 3 files changed, 4 insertions(+), 16 deletions(-)

-- 
1.9.1
