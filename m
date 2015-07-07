From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH v2 4/7] crypto: omap-aes: Use BIT() macro
Date: Tue, 7 Jul 2015 21:01:46 +0530
Message-ID: <1436283109-13318-5-git-send-email-lokeshvutla@ti.com>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:44565 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbbGGPe7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 11:34:59 -0400
In-Reply-To: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use BIT()/GENMASK() macros for all register definitions instead of
hand-writing bit masks.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 35521b8..eba2314 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -52,17 +52,17 @@
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
 #define AES_REG_CTRL_MASK		GENMASK(24, 2)
 
 #define AES_REG_DATA_N(dd, x)		((dd)->pdata->data_ofs + ((x) * 0x04))
@@ -70,12 +70,12 @@
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
1.9.1
