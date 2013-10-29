From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH] crypto: omap-aes: Fix CTR mode counter length
Date: Tue, 29 Oct 2013 17:37:38 -0500
Message-ID: <1383086258-22186-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Joel Fernandes <joelf@ti.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

NIST vectors for CTR mode in testmgr.h assume the entire IV as the counter. To
get correct results that match the output of these vectors, we need to set the
counter length correctly.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ce791c2..19055a1 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -275,7 +275,7 @@ static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 	if (dd->flags & FLAGS_CBC)
 		val |= AES_REG_CTRL_CBC;
 	if (dd->flags & FLAGS_CTR) {
-		val |= AES_REG_CTRL_CTR | AES_REG_CTRL_CTR_WIDTH_32;
+		val |= AES_REG_CTRL_CTR | AES_REG_CTRL_CTR_WIDTH_128;
 		mask = AES_REG_CTRL_CTR | AES_REG_CTRL_CTR_WIDTH_MASK;
 	}
 	if (dd->flags & FLAGS_ENCRYPT)
-- 
1.8.1.2
