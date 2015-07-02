From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 04/10] crypto: omap-aes: Use BIT() macro
Date: Thu, 2 Jul 2015 10:48:34 +0530
Message-ID: <1435814320-30347-5-git-send-email-lokeshvutla@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35925 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbbGBFV5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 01:21:57 -0400
In-Reply-To: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use BIT()/GENMASK() macros for all register definitions instead of
hand-writing bit masks.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 96fc7f7..d974ab6 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -52,30 +52,30 @@
 #define AES_REG_IV(dd, x)		((dd)->pdata->iv_ofs + ((x) * 0x04))
 
 #define AES_REG_CTRL(dd)		((dd)->pdata->ctrl_ofs)
-#define AES_REG_CTRL_CTR_WIDTH_MASK	(3 << 7)
-#define AES_REG_CTRL_CTR_WIDTH_32		(0 << 7)
-#define AES_REG_CTRL_CTR_WIDTH_64		(1 << 7)
-#define AES_REG_CTRL_CTR_WIDTH_96		(2 << 7)
-#define AES_REG_CTRL_CTR_WIDTH_128		(3 << 7)
-#define AES_REG_CTRL_CTR		(1 << 6)
-#define AES_REG_CTRL_CBC		(1 << 5)
-#define AES_REG_CTRL_KEY_SIZE		(3 << 3)
-#define AES_REG_CTRL_DIRECTION		(1 << 2)
-#define AES_REG_CTRL_INPUT_READY	(1 << 1)
-#define AES_REG_CTRL_OUTPUT_READY	(1 << 0)
-#define AES_REG_CTRL_MASK		FLD_MASK(24, 2)
+#define AES_REG_CTRL_CTR_WIDTH_MASK	GENMASK(8, 7)
+#define AES_REG_CTRL_CTR_WIDTH_32	0
+#define AES_REG_CTRL_CTR_WIDTH_64	BIT(7)
+#define AES_REG_CTRL_CTR_WIDTH_96	BIT(8)
+#define AES_REG_CTRL_CTR_WIDTH_128	GENMASK(8, 7)
+#define AES_REG_CTRL_CTR		BIT(6)
+#define AES_REG_CTRL_CBC		BIT(5)
+#define AES_REG_CTRL_KEY_SIZE		GENMASK(4, 3)
+#define AES_REG_CTRL_DIRECTION		BIT(2)
+#define AES_REG_CTRL_INPUT_READY	BIT(1)
+#define AES_REG_CTRL_OUTPUT_READY	BIT(0)
+#define AES_REG_CTRL_MASK		GENMASK(24, 2)
 
 #define AES_REG_DATA_N(dd, x)		((dd)->pdata->data_ofs + ((x) * 0x04))
 
 #define AES_REG_REV(dd)			((dd)->pdata->rev_ofs)
 
 #define AES_REG_MASK(dd)		((dd)->pdata->mask_ofs)
-#define AES_REG_MASK_SIDLE		(1 << 6)
-#define AES_REG_MASK_START		(1 << 5)
-#define AES_REG_MASK_DMA_OUT_EN		(1 << 3)
-#define AES_REG_MASK_DMA_IN_EN		(1 << 2)
-#define AES_REG_MASK_SOFTRESET		(1 << 1)
-#define AES_REG_AUTOIDLE		(1 << 0)
+#define AES_REG_MASK_SIDLE		BIT(6)
+#define AES_REG_MASK_START		BIT(5)
+#define AES_REG_MASK_DMA_OUT_EN		BIT(3)
+#define AES_REG_MASK_DMA_IN_EN		BIT(2)
+#define AES_REG_MASK_SOFTRESET		BIT(1)
+#define AES_REG_AUTOIDLE		BIT(0)
 
 #define AES_REG_LENGTH_N(x)		(0x54 + ((x) * 0x04))
 
-- 
1.7.9.5
