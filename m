From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 02/13] crypto: caam/qi - fix compilation with DEBUG enabled
Date: Mon, 10 Jul 2017 08:40:28 +0300
Message-ID: <20170710054039.21555-3-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
 <20170710054039.21555-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0071.outbound.protection.outlook.com ([104.47.32.71]:54176
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751224AbdGJFlF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 01:41:05 -0400
In-Reply-To: <20170710054039.21555-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caam/qi driver does not compile when DEBUG is enabled
(CRYPTO_DEV_FSL_CAAM_DEBUG=y):

drivers/crypto/caam/caamalg_qi.c: In function 'ablkcipher_done':
drivers/crypto/caam/caamalg_qi.c:794:2: error: implicit declaration of function 'dbg_dump_sg' [-Werror=implicit-function-declaration]
  dbg_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",

Since dbg_dump_sg() is shared between caam/jr and caam/qi, move it
in a shared location and export it.

At the same time:
-reduce ifdeferry by providing a no-op implementation for !DEBUG case
-rename it to caam_dump_sg() to be consistent in terms of
exported symbols namespace (caam_*)

Cc: <stable@vger.kernel.org>
Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c    | 66 +++++++++-------------------------------
 drivers/crypto/caam/caamalg_qi.c |  6 ++--
 drivers/crypto/caam/error.c      | 40 ++++++++++++++++++++++++
 drivers/crypto/caam/error.h      |  4 +++
 4 files changed, 62 insertions(+), 54 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 398807d1b77e..92fb15e0a4f7 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -81,40 +81,6 @@
 #define debug(format, arg...)
 #endif
 
-#ifdef DEBUG
-#include <linux/highmem.h>
-
-static void dbg_dump_sg(const char *level, const char *prefix_str,
-			int prefix_type, int rowsize, int groupsize,
-			struct scatterlist *sg, size_t tlen, bool ascii)
-{
-	struct scatterlist *it;
-	void *it_page;
-	size_t len;
-	void *buf;
-
-	for (it = sg; it != NULL && tlen > 0 ; it = sg_next(sg)) {
-		/*
-		 * make sure the scatterlist's page
-		 * has a valid virtual memory mapping
-		 */
-		it_page = kmap_atomic(sg_page(it));
-		if (unlikely(!it_page)) {
-			printk(KERN_ERR "dbg_dump_sg: kmap failed\n");
-			return;
-		}
-
-		buf = it_page + it->offset;
-		len = min_t(size_t, tlen, it->length);
-		print_hex_dump(level, prefix_str, prefix_type, rowsize,
-			       groupsize, buf, len, ascii);
-		tlen -= len;
-
-		kunmap_atomic(it_page);
-	}
-}
-#endif
-
 static struct list_head alg_list;
 
 struct caam_alg_entry {
@@ -898,10 +864,10 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       edesc->src_nents > 1 ? 100 : ivsize, 1);
-	dbg_dump_sg(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
-		    DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
-		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 #endif
+	caam_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",
+		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
+		     edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 
 	ablkcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
@@ -929,10 +895,10 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       ivsize, 1);
-	dbg_dump_sg(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
-		    DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
-		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 #endif
+	caam_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",
+		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
+		     edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 
 	ablkcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
@@ -1091,10 +1057,10 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
 		       ivsize, 1);
 	pr_err("asked=%d, nbytes%d\n",
 	       (int)edesc->src_nents > 1 ? 100 : req->nbytes, req->nbytes);
-	dbg_dump_sg(KERN_ERR, "src    @"__stringify(__LINE__)": ",
-		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,
-		    edesc->src_nents > 1 ? 100 : req->nbytes, 1);
 #endif
+	caam_dump_sg(KERN_ERR, "src    @" __stringify(__LINE__)": ",
+		     DUMP_PREFIX_ADDRESS, 16, 4, req->src,
+		     edesc->src_nents > 1 ? 100 : req->nbytes, 1);
 
 	len = desc_len(sh_desc);
 	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
@@ -1148,10 +1114,10 @@ static void init_ablkcipher_giv_job(u32 *sh_desc, dma_addr_t ptr,
 	print_hex_dump(KERN_ERR, "presciv@" __stringify(__LINE__) ": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       ivsize, 1);
-	dbg_dump_sg(KERN_ERR, "src    @" __stringify(__LINE__) ": ",
-		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,
-		    edesc->src_nents > 1 ? 100 : req->nbytes, 1);
 #endif
+	caam_dump_sg(KERN_ERR, "src    @" __stringify(__LINE__) ": ",
+		     DUMP_PREFIX_ADDRESS, 16, 4, req->src,
+		     edesc->src_nents > 1 ? 100 : req->nbytes, 1);
 
 	len = desc_len(sh_desc);
 	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
@@ -1433,11 +1399,9 @@ static int aead_decrypt(struct aead_request *req)
 	u32 *desc;
 	int ret = 0;
 
-#ifdef DEBUG
-	dbg_dump_sg(KERN_ERR, "dec src@"__stringify(__LINE__)": ",
-		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,
-		    req->assoclen + req->cryptlen, 1);
-#endif
+	caam_dump_sg(KERN_ERR, "dec src@" __stringify(__LINE__)": ",
+		     DUMP_PREFIX_ADDRESS, 16, 4, req->src,
+		     req->assoclen + req->cryptlen, 1);
 
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, AUTHENC_DESC_JOB_IO_LEN,
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index b63bc3019f42..2dde23abbd3a 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -791,9 +791,9 @@ static void ablkcipher_done(struct caam_drv_req *drv_req, u32 status)
 	print_hex_dump(KERN_ERR, "dstiv  @" __stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       edesc->src_nents > 1 ? 100 : ivsize, 1);
-	dbg_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",
-		    DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
-		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
+	caam_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",
+		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
+		     edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 #endif
 
 	ablkcipher_unmap(qidev, edesc, req);
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 6f44ccb55c63..3d639f3b45aa 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -9,6 +9,46 @@
 #include "desc.h"
 #include "error.h"
 
+#ifdef DEBUG
+#include <linux/highmem.h>
+
+void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
+		  int rowsize, int groupsize, struct scatterlist *sg,
+		  size_t tlen, bool ascii)
+{
+	struct scatterlist *it;
+	void *it_page;
+	size_t len;
+	void *buf;
+
+	for (it = sg; it && tlen > 0 ; it = sg_next(sg)) {
+		/*
+		 * make sure the scatterlist's page
+		 * has a valid virtual memory mapping
+		 */
+		it_page = kmap_atomic(sg_page(it));
+		if (unlikely(!it_page)) {
+			pr_err("caam_dump_sg: kmap failed\n");
+			return;
+		}
+
+		buf = it_page + it->offset;
+		len = min_t(size_t, tlen, it->length);
+		print_hex_dump(level, prefix_str, prefix_type, rowsize,
+			       groupsize, buf, len, ascii);
+		tlen -= len;
+
+		kunmap_atomic(it_page);
+	}
+}
+#else
+void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
+		  int rowsize, int groupsize, struct scatterlist *sg,
+		  size_t tlen, bool ascii)
+{}
+#endif /* DEBUG */
+EXPORT_SYMBOL(caam_dump_sg);
+
 static const struct {
 	u8 value;
 	const char *error_text;
diff --git a/drivers/crypto/caam/error.h b/drivers/crypto/caam/error.h
index b6350b0d9153..250e1a21c473 100644
--- a/drivers/crypto/caam/error.h
+++ b/drivers/crypto/caam/error.h
@@ -8,4 +8,8 @@
 #define CAAM_ERROR_H
 #define CAAM_ERROR_STR_MAX 302
 void caam_jr_strstatus(struct device *jrdev, u32 status);
+
+void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
+		  int rowsize, int groupsize, struct scatterlist *sg,
+		  size_t tlen, bool ascii);
 #endif /* CAAM_ERROR_H */
-- 
2.12.0.264.gd6db3f216544
