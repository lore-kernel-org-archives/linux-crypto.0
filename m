From: Catalin Vasile <cata.vasile@nxp.com>
Subject: [PATCH] crypto: caam - fix sg dump
Date: Fri, 16 Sep 2016 12:06:27 +0300
Message-ID: <1474016787-5792-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto-owner@vger.kernel.org>, <horia.geanta@nxp.com>,
        <alexandru.porosanu@nxp.com>, Catalin Vasile <cata.vasile@nxp.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0059.outbound.protection.outlook.com ([104.47.37.59]:51582
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754364AbcIPJVa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 05:21:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ensure scatterlists have a virtual memory mapping before dumping.

Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 65 +++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 6dc5971..49f1ea7 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -111,6 +111,41 @@
 #else
 #define debug(format, arg...)
 #endif
+
+#ifdef DEBUG
+#include <linux/highmem.h>
+
+static void dbg_dump_sg(const char *level, const char *prefix_str,
+			int prefix_type, int rowsize, int groupsize,
+			struct scatterlist *sg, size_t tlen, bool ascii)
+{
+	struct scatterlist *it;
+	size_t len;
+	void *buf;
+
+	for (it = sg; it != NULL && tlen > 0 ; it = sg_next(sg)) {
+		/*
+		 * make sure the scatterlist's page
+		 * has a valid virtual memory mapping
+		 */
+		buf = kmap(sg_page(it));
+
+		len = min(tlen, it->length);
+		print_hex_dump(level, prefix_str, prefix_type, rowsize,
+			       groupsize, sg_virt(it), len, ascii);
+		tlen -= len;
+
+		kunmap(sg_page(it));
+	}
+}
+#else
+static void dbg_dump_sg(const char *level, const char *prefix_str,
+			int prefix_type, int rowsize, int groupsize,
+			struct scatterlist *sg, size_t tlen, bool ascii)
+{
+}
+#endif
+
 static struct list_head alg_list;
 
 struct caam_alg_entry {
@@ -1984,9 +2019,9 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       edesc->src_nents > 1 ? 100 : ivsize, 1);
-	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
+	dbg_dump_sg(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
+		    DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
+		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 #endif
 
 	ablkcipher_unmap(jrdev, edesc, req);
@@ -2016,9 +2051,9 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       ivsize, 1);
-	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
+	dbg_dump_sg(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
+		    DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
+		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 #endif
 
 	ablkcipher_unmap(jrdev, edesc, req);
@@ -2176,9 +2211,9 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
 	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       ivsize, 1);
-	print_hex_dump(KERN_ERR, "src    @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       edesc->src_nents ? 100 : req->nbytes, 1);
+	dbg_dump_sg(KERN_ERR, "src    @"__stringify(__LINE__)": ",
+		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,
+		    edesc->src_nents ? 100 : req->nbytes, 1);
 #endif
 
 	len = desc_len(sh_desc);
@@ -2233,9 +2268,9 @@ static void init_ablkcipher_giv_job(u32 *sh_desc, dma_addr_t ptr,
 	print_hex_dump(KERN_ERR, "presciv@" __stringify(__LINE__) ": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       ivsize, 1);
-	print_hex_dump(KERN_ERR, "src    @" __stringify(__LINE__) ": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       edesc->src_nents ? 100 : req->nbytes, 1);
+	dbg_dump_sg(KERN_ERR, "src    @" __stringify(__LINE__) ": ",
+		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,
+		    edesc->src_nents ? 100 : req->nbytes, 1);
 #endif
 
 	len = desc_len(sh_desc);
@@ -2512,9 +2547,9 @@ static int aead_decrypt(struct aead_request *req)
 		return PTR_ERR(edesc);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "dec src@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       req->assoclen + req->cryptlen, 1);
+	dbg_dump_sg(KERN_ERR, "dec src@"__stringify(__LINE__)": ",
+		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,
+		    req->assoclen + req->cryptlen, 1);
 #endif
 
 	/* Create and submit job descriptor*/
-- 
1.8.3.1
