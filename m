Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2DEC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 14:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E231621736
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 14:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbfBSO5M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:57:12 -0500
Received: from inva021.nxp.com ([92.121.34.21]:48582 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbfBSO5M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 09:57:12 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4DF722004AF;
        Tue, 19 Feb 2019 15:57:09 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4014420012C;
        Tue, 19 Feb 2019 15:57:09 +0100 (CET)
Received: from enigma.ea.freescale.net (enigma.ea.freescale.net [10.171.81.110])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E1F402061F;
        Tue, 19 Feb 2019 15:57:08 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx <linux-imx@nxp.com>
Subject: [PATCH 3/3] crypto: caam - generate hash keys in-place
Date:   Tue, 19 Feb 2019 16:56:57 +0200
Message-Id: <20190219145657.2267-4-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.16.2
In-Reply-To: <20190219145657.2267-1-horia.geanta@nxp.com>
References: <20190219145657.2267-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When generating a split key or hashing the key, DMA mapping the key
buffers coming directly from user is incorrect, since they are
not guaranteed to be DMAable.

Update driver to first copy user-provided key in the output buffer
("key_out") and then use this buffer for in-place computation
(split key generation, respectively key hashing).

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 40 +++++++++++++---------------------------
 drivers/crypto/caam/key_gen.c  | 30 ++++++++++--------------------
 2 files changed, 23 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index a71408f36654..d7483e4d0ce2 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -395,13 +395,13 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 }
 
 /* Digest hash size if it is too large */
-static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
-			   u32 *keylen, u8 *key_out, u32 digestsize)
+static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
+			   u32 digestsize)
 {
 	struct device *jrdev = ctx->jrdev;
 	u32 *desc;
 	struct split_key_result result;
-	dma_addr_t src_dma, dst_dma;
+	dma_addr_t key_dma;
 	int ret;
 
 	desc = kmalloc(CAAM_CMD_SZ * 8 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
@@ -412,18 +412,9 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 
 	init_job_desc(desc, 0);
 
-	src_dma = dma_map_single(jrdev, (void *)key_in, *keylen,
-				 DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, src_dma)) {
-		dev_err(jrdev, "unable to map key input memory\n");
-		kfree(desc);
-		return -ENOMEM;
-	}
-	dst_dma = dma_map_single(jrdev, (void *)key_out, digestsize,
-				 DMA_FROM_DEVICE);
-	if (dma_mapping_error(jrdev, dst_dma)) {
-		dev_err(jrdev, "unable to map key output memory\n");
-		dma_unmap_single(jrdev, src_dma, *keylen, DMA_TO_DEVICE);
+	key_dma = dma_map_single(jrdev, key, *keylen, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(jrdev, key_dma)) {
+		dev_err(jrdev, "unable to map key memory\n");
 		kfree(desc);
 		return -ENOMEM;
 	}
@@ -431,16 +422,16 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 	/* Job descriptor to perform unkeyed hash on key_in */
 	append_operation(desc, ctx->adata.algtype | OP_ALG_ENCRYPT |
 			 OP_ALG_AS_INITFINAL);
-	append_seq_in_ptr(desc, src_dma, *keylen, 0);
+	append_seq_in_ptr(desc, key_dma, *keylen, 0);
 	append_seq_fifo_load(desc, *keylen, FIFOLD_CLASS_CLASS2 |
 			     FIFOLD_TYPE_LAST2 | FIFOLD_TYPE_MSG);
-	append_seq_out_ptr(desc, dst_dma, digestsize, 0);
+	append_seq_out_ptr(desc, key_dma, digestsize, 0);
 	append_seq_store(desc, digestsize, LDST_CLASS_2_CCB |
 			 LDST_SRCDST_BYTE_CONTEXT);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "key_in@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, key_in, *keylen, 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
@@ -456,12 +447,10 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR,
 			       "digested key@"__stringify(__LINE__)": ",
-			       DUMP_PREFIX_ADDRESS, 16, 4, key_in,
-			       digestsize, 1);
+			       DUMP_PREFIX_ADDRESS, 16, 4, key, digestsize, 1);
 #endif
 	}
-	dma_unmap_single(jrdev, src_dma, *keylen, DMA_TO_DEVICE);
-	dma_unmap_single(jrdev, dst_dma, digestsize, DMA_FROM_DEVICE);
+	dma_unmap_single(jrdev, key_dma, *keylen, DMA_BIDIRECTIONAL);
 
 	*keylen = digestsize;
 
@@ -485,13 +474,10 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 #endif
 
 	if (keylen > blocksize) {
-		hashed_key = kmalloc_array(digestsize,
-					   sizeof(*hashed_key),
-					   GFP_KERNEL | GFP_DMA);
+		hashed_key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
 		if (!hashed_key)
 			return -ENOMEM;
-		ret = hash_digest_key(ctx, key, &keylen, hashed_key,
-				      digestsize);
+		ret = hash_digest_key(ctx, &keylen, hashed_key, digestsize);
 		if (ret)
 			goto bad_free_key;
 		key = hashed_key;
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 312b5f042f31..8d0713fae6ac 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -48,7 +48,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out,
 {
 	u32 *desc;
 	struct split_key_result result;
-	dma_addr_t dma_addr_in, dma_addr_out;
+	dma_addr_t dma_addr;
 	int ret = -ENOMEM;
 
 	adata->keylen = split_key_len(adata->algtype & OP_ALG_ALGSEL_MASK);
@@ -71,22 +71,17 @@ int gen_split_key(struct device *jrdev, u8 *key_out,
 		return ret;
 	}
 
-	dma_addr_in = dma_map_single(jrdev, (void *)key_in, keylen,
-				     DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, dma_addr_in)) {
-		dev_err(jrdev, "unable to map key input memory\n");
-		goto out_free;
-	}
+	memcpy(key_out, key_in, keylen);
 
-	dma_addr_out = dma_map_single(jrdev, key_out, adata->keylen_pad,
-				      DMA_FROM_DEVICE);
-	if (dma_mapping_error(jrdev, dma_addr_out)) {
-		dev_err(jrdev, "unable to map key output memory\n");
-		goto out_unmap_in;
+	dma_addr = dma_map_single(jrdev, key_out, adata->keylen_pad,
+				  DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(jrdev, dma_addr)) {
+		dev_err(jrdev, "unable to map key memory\n");
+		goto out_free;
 	}
 
 	init_job_desc(desc, 0);
-	append_key(desc, dma_addr_in, keylen, CLASS_2 | KEY_DEST_CLASS_REG);
+	append_key(desc, dma_addr, keylen, CLASS_2 | KEY_DEST_CLASS_REG);
 
 	/* Sets MDHA up into an HMAC-INIT */
 	append_operation(desc, (adata->algtype & OP_ALG_ALGSEL_MASK) |
@@ -104,12 +99,10 @@ int gen_split_key(struct device *jrdev, u8 *key_out,
 	 * FIFO_STORE with the explicit split-key content store
 	 * (0x26 output type)
 	 */
-	append_fifo_store(desc, dma_addr_out, adata->keylen,
+	append_fifo_store(desc, dma_addr, adata->keylen,
 			  LDST_CLASS_2_CCB | FIFOST_TYPE_SPLIT_KEK);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, key_in, keylen, 1);
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
@@ -129,10 +122,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out,
 #endif
 	}
 
-	dma_unmap_single(jrdev, dma_addr_out, adata->keylen_pad,
-			 DMA_FROM_DEVICE);
-out_unmap_in:
-	dma_unmap_single(jrdev, dma_addr_in, keylen, DMA_TO_DEVICE);
+	dma_unmap_single(jrdev, dma_addr, adata->keylen_pad, DMA_BIDIRECTIONAL);
 out_free:
 	kfree(desc);
 	return ret;
-- 
2.16.2

