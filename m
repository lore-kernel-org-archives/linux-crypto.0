From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 06/10] staging: ccree: remove useless debug code
Date: Thu, 14 Dec 2017 14:02:43 +0000
Message-ID: <1513260170-26346-7-git-send-email-gilad@benyossef.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove a bunch of useless debug code ifdef'ed out

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 45 ---------------------------------
 drivers/staging/ccree/ssi_config.h      |  3 ---
 drivers/staging/ccree/ssi_driver.c      | 13 ----------
 drivers/staging/ccree/ssi_request_mgr.c | 23 -----------------
 4 files changed, 84 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index dde6797..ce26e68 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1834,51 +1834,6 @@ static int cc_gcm(struct aead_request *req, struct cc_hw_desc desc[],
 	return 0;
 }
 
-#ifdef CC_DEBUG
-static void cc_dump_gcm(const char *title, struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-
-	if (ctx->cipher_mode != DRV_CIPHER_GCTR)
-		return;
-
-	if (title) {
-		dev_dbg(dev, "----------------------------------------------------------------------------------");
-		dev_dbg(dev, "%s\n", title);
-	}
-
-	dev_dbg(dev, "cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d\n",
-		ctx->cipher_mode, ctx->authsize, ctx->enc_keylen,
-		req->assoclen, req_ctx->cryptlen);
-
-	if (ctx->enckey)
-		dump_byte_array("mac key", ctx->enckey, 16);
-
-	dump_byte_array("req->iv", req->iv, AES_BLOCK_SIZE);
-
-	dump_byte_array("gcm_iv_inc1", req_ctx->gcm_iv_inc1, AES_BLOCK_SIZE);
-
-	dump_byte_array("gcm_iv_inc2", req_ctx->gcm_iv_inc2, AES_BLOCK_SIZE);
-
-	dump_byte_array("hkey", req_ctx->hkey, AES_BLOCK_SIZE);
-
-	dump_byte_array("mac_buf", req_ctx->mac_buf, AES_BLOCK_SIZE);
-
-	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.len_a,
-			AES_BLOCK_SIZE);
-
-	if (req->src && req->cryptlen)
-		dump_byte_array("req->src", sg_virt(req->src),
-				req->cryptlen + req->assoclen);
-
-	if (req->dst)
-		dump_byte_array("req->dst", sg_virt(req->dst),
-				req->cryptlen + ctx->authsize + req->assoclen);
-}
-#endif
-
 static int config_gcm_context(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index e809103..b530974 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -23,11 +23,8 @@
 
 #include <linux/version.h>
 
-//#define FLUSH_CACHE_ALL
-//#define COMPLETION_DELAY
 //#define CC_DUMP_DESCS
 // #define CC_DUMP_BYTES
-// #define CC_DEBUG
 /* was 32 bit, but for juno's sake it was enlarged to 48 bit */
 #define DMA_BIT_MASK_LEN	48
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 6158794..dbca241 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -446,19 +446,6 @@ static int cc7x_probe(struct platform_device *plat_dev)
 {
 	int rc;
 	struct device *dev = &plat_dev->dev;
-#if defined(CONFIG_ARM) && defined(CC_DEBUG)
-	u32 ctr, cacheline_size;
-
-	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
-	cacheline_size =  4 << ((ctr >> 16) & 0xf);
-	dev_dbg(dev, "CP15(L1_CACHE_BYTES) = %u , Kconfig(L1_CACHE_BYTES) = %u\n",
-		cacheline_size, L1_CACHE_BYTES);
-
-	asm volatile("mrc p15, 0, %0, c0, c0, 0" : "=r" (ctr));
-	dev_dbg(dev, "Main ID register (MIDR): Implementer 0x%02X, Arch 0x%01X, Part 0x%03X, Rev r%dp%d\n",
-		(ctr >> 24), (ctr >> 16) & 0xF, (ctr >> 4) & 0xFFF,
-		(ctr >> 20) & 0xF, ctr & 0xF);
-#endif
 
 	/* Map registers space */
 	rc = init_cc_resources(plat_dev);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 07b9404..f6374b0 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -20,9 +20,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <crypto/ctr.h>
-#ifdef FLUSH_CACHE_ALL
-#include <asm/cacheflush.h>
-#endif
 #include <linux/pm_runtime.h>
 #include "ssi_driver.h"
 #include "ssi_buffer_mgr.h"
@@ -359,9 +356,6 @@ int send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 
 	dev_dbg(dev, "Enqueue request head=%u\n", req_mgr_h->req_queue_head);
 
-#ifdef FLUSH_CACHE_ALL
-	flush_cache_all();
-#endif
 	/*
 	 * We are about to push command to the HW via the command registers
 	 * that may refernece hsot memory. We need to issue a memory barrier
@@ -493,23 +487,6 @@ static void proc_completions(struct cc_drvdata *drvdata)
 
 		cc_req = &request_mgr_handle->req_queue[*tail];
 
-#ifdef FLUSH_CACHE_ALL
-		flush_cache_all();
-#endif
-
-#ifdef COMPLETION_DELAY
-		/* Delay */
-		{
-			u32 axi_err;
-			int i;
-
-			dev_info(dev, "Delay\n");
-			for (i = 0; i < 1000000; i++)
-				axi_err = cc_ioread(drvdata,
-						    CC_REG(AXIM_MON_ERR));
-		}
-#endif /* COMPLETION_DELAY */
-
 		if (cc_req->user_cb)
 			cc_req->user_cb(dev, cc_req->user_arg);
 		*tail = (*tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
-- 
2.7.4
