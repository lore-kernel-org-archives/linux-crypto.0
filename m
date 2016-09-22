From: Catalin Vasile <cata.vasile@nxp.com>
Subject: [PATCH] crypto: caam - fix dbg_dump_sg() style issues
Date: Thu, 22 Sep 2016 13:58:27 +0300
Message-ID: <1474541907-28808-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto-owner@vger.kernel.org>, <horia.geanta@nxp.com>,
        "Catalin Vasile" <cata.vasile@nxp.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0073.outbound.protection.outlook.com ([104.47.34.73]:36448
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933445AbcIVLa3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 07:30:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index eb97562..c8ebddb 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -117,8 +117,7 @@
 
 static void dbg_dump_sg(const char *level, const char *prefix_str,
 			int prefix_type, int rowsize, int groupsize,
-			struct scatterlist *sg, size_t tlen, bool ascii,
-			bool may_sleep)
+			struct scatterlist *sg, size_t tlen, bool ascii)
 {
 	struct scatterlist *it;
 	void *it_page;
@@ -132,7 +131,7 @@ static void dbg_dump_sg(const char *level, const char *prefix_str,
 		 */
 		it_page = kmap_atomic(sg_page(it));
 		if (unlikely(!it_page)) {
-			printk(KERN_ERR "dbg_dump_sg: kmap failed\n");
+			pr_err("dbg_dump_sg: kmap failed\n");
 			return;
 		}
 
@@ -145,6 +144,12 @@ static void dbg_dump_sg(const char *level, const char *prefix_str,
 		kunmap_atomic(it_page);
 	}
 }
+#else
+static void dbg_dump_sg(const char *level, const char *prefix_str,
+			int prefix_type, int rowsize, int groupsize,
+			struct scatterlist *sg, size_t tlen, bool ascii)
+{
+}
 #endif
 
 static struct list_head alg_list;
@@ -2018,10 +2023,11 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       edesc->src_nents > 1 ? 100 : ivsize, 1);
+#endif
+
 	dbg_dump_sg(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
 		    DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
-		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1, true);
-#endif
+		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 
 	ablkcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
@@ -2050,10 +2056,10 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       ivsize, 1);
+#endif
 	dbg_dump_sg(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
 		    DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
-		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1, true);
-#endif
+		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 
 	ablkcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
@@ -2207,16 +2213,14 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
 	int len, sec4_sg_index = 0;
 
 #ifdef DEBUG
-	bool may_sleep = ((req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-					      CRYPTO_TFM_REQ_MAY_SLEEP)) != 0);
 	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       ivsize, 1);
 	printk(KERN_ERR "asked=%d, nbytes%d\n", (int)edesc->src_nents ? 100 : req->nbytes, req->nbytes);
+#endif
 	dbg_dump_sg(KERN_ERR, "src    @"__stringify(__LINE__)": ",
 		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,
-		    edesc->src_nents ? 100 : req->nbytes, 1, may_sleep);
-#endif
+		    edesc->src_nents ? 100 : req->nbytes, 1);
 
 	len = desc_len(sh_desc);
 	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
@@ -2267,15 +2271,13 @@ static void init_ablkcipher_giv_job(u32 *sh_desc, dma_addr_t ptr,
 	int len, sec4_sg_index = 0;
 
 #ifdef DEBUG
-	bool may_sleep = ((req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-					      CRYPTO_TFM_REQ_MAY_SLEEP)) != 0);
 	print_hex_dump(KERN_ERR, "presciv@" __stringify(__LINE__) ": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       ivsize, 1);
+#endif
 	dbg_dump_sg(KERN_ERR, "src    @" __stringify(__LINE__) ": ",
 		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,
-		    edesc->src_nents ? 100 : req->nbytes, 1, may_sleep);
-#endif
+		    edesc->src_nents ? 100 : req->nbytes, 1);
 
 	len = desc_len(sh_desc);
 	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
@@ -2544,14 +2546,6 @@ static int aead_decrypt(struct aead_request *req)
 	u32 *desc;
 	int ret = 0;
 
-#ifdef DEBUG
-	bool may_sleep = ((req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-					      CRYPTO_TFM_REQ_MAY_SLEEP)) != 0);
-	dbg_dump_sg(KERN_ERR, "dec src@"__stringify(__LINE__)": ",
-		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,
-		    req->assoclen + req->cryptlen, 1, may_sleep);
-#endif
-
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, AUTHENC_DESC_JOB_IO_LEN,
 				 &all_contig, false);
@@ -2565,6 +2559,9 @@ static int aead_decrypt(struct aead_request *req)
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
+	dbg_dump_sg(KERN_ERR, "dec src@"__stringify(__LINE__)": ",
+		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,
+		    req->assoclen + req->cryptlen, 1);
 
 	desc = edesc->hw_desc;
 	ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
-- 
1.8.3.1
