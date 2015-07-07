From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH v2 3/7] crypto: omap-aes: Fix configuring of AES mode
Date: Tue, 7 Jul 2015 21:01:45 +0530
Message-ID: <1436283109-13318-4-git-send-email-lokeshvutla@ti.com>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

AES_CTRL_REG is used to configure AES mode. Before configuring
any mode we need to make sure all other modes are reset or else
driver will misbehave. So mask all modes before configuring
any AES mode.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 54925d9..35521b8 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -63,6 +63,7 @@
 #define AES_REG_CTRL_DIRECTION		(1 << 2)
 #define AES_REG_CTRL_INPUT_READY	(1 << 1)
 #define AES_REG_CTRL_OUTPUT_READY	(1 << 0)
+#define AES_REG_CTRL_MASK		GENMASK(24, 2)
 
 #define AES_REG_DATA_N(dd, x)		((dd)->pdata->data_ofs + ((x) * 0x04))
 
@@ -254,7 +255,7 @@ static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 {
 	unsigned int key32;
 	int i, err;
-	u32 val, mask = 0;
+	u32 val;
 
 	err = omap_aes_hw_init(dd);
 	if (err)
@@ -274,17 +275,13 @@ static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 	val = FLD_VAL(((dd->ctx->keylen >> 3) - 1), 4, 3);
 	if (dd->flags & FLAGS_CBC)
 		val |= AES_REG_CTRL_CBC;
-	if (dd->flags & FLAGS_CTR) {
+	if (dd->flags & FLAGS_CTR)
 		val |= AES_REG_CTRL_CTR | AES_REG_CTRL_CTR_WIDTH_128;
-		mask = AES_REG_CTRL_CTR | AES_REG_CTRL_CTR_WIDTH_MASK;
-	}
+
 	if (dd->flags & FLAGS_ENCRYPT)
 		val |= AES_REG_CTRL_DIRECTION;
 
-	mask |= AES_REG_CTRL_CBC | AES_REG_CTRL_DIRECTION |
-			AES_REG_CTRL_KEY_SIZE;
-
-	omap_aes_write_mask(dd, AES_REG_CTRL(dd), val, mask);
+	omap_aes_write_mask(dd, AES_REG_CTRL(dd), val, AES_REG_CTRL_MASK);
 
 	return 0;
 }
-- 
1.9.1
