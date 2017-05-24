From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 09/13] crypto: omap-aes: export some AES driver functionality locally
Date: Wed, 24 May 2017 10:35:30 +0300
Message-ID: <1495611334-15039-10-git-send-email-t-kristo@ti.com>
References: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:51589 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966650AbdEXHgT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 03:36:19 -0400
In-Reply-To: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These are going to be required by the addition of the GCM support.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-aes.c | 12 ++++++------
 drivers/crypto/omap-aes.h |  7 +++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index cf7968c..bf3b27d 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -55,7 +55,7 @@
 	_read_ret;						\
 })
 #else
-static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
+inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
 {
 	return __raw_readl(dd->io_base + offset);
 }
@@ -69,7 +69,7 @@ static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
 		__raw_writel(value, dd->io_base + offset);		\
 	} while (0)
 #else
-static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
+inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
 				  u32 value)
 {
 	__raw_writel(value, dd->io_base + offset);
@@ -112,7 +112,7 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 	return 0;
 }
 
-static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
+int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 {
 	unsigned int key32;
 	int i, err;
@@ -183,7 +183,7 @@ static void omap_aes_dma_stop(struct omap_aes_dev *dd)
 	omap_aes_write_mask(dd, AES_REG_MASK(dd), 0, mask);
 }
 
-static struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_reqctx *rctx)
+struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_reqctx *rctx)
 {
 	struct omap_aes_dev *dd;
 
@@ -321,7 +321,7 @@ static int omap_aes_crypt_dma(struct omap_aes_dev *dd,
 	return 0;
 }
 
-static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
+int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 {
 	int err;
 
@@ -366,7 +366,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 	pm_runtime_put_autosuspend(dd->dev);
 }
 
-static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
+int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 {
 	pr_debug("total: %d\n", dd->total);
 
diff --git a/drivers/crypto/omap-aes.h b/drivers/crypto/omap-aes.h
index ce4346e..11e1784 100644
--- a/drivers/crypto/omap-aes.h
+++ b/drivers/crypto/omap-aes.h
@@ -164,4 +164,11 @@ struct omap_aes_dev {
 	const struct omap_aes_pdata	*pdata;
 };
 
+u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset);
+void omap_aes_write(struct omap_aes_dev *dd, u32 offset, u32 value);
+struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_reqctx *rctx);
+int omap_aes_write_ctrl(struct omap_aes_dev *dd);
+int omap_aes_crypt_dma_start(struct omap_aes_dev *dd);
+int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd);
+
 #endif
-- 
1.9.1
