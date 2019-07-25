Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E42CC7618B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 13:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 069392075E
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 13:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404365AbfGYN7P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 09:59:15 -0400
Received: from inva021.nxp.com ([92.121.34.21]:58400 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404264AbfGYN6m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 09:58:42 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0273E200722;
        Thu, 25 Jul 2019 15:58:40 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E862120071D;
        Thu, 25 Jul 2019 15:58:39 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 9CD7C205E8;
        Thu, 25 Jul 2019 15:58:39 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v3 09/14] crypto: caam - keep both virtual and dma key addresses
Date:   Thu, 25 Jul 2019 16:58:21 +0300
Message-Id: <1564063106-9552-10-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
References: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

Update alginfo struct to keep both virtual and dma key addresses,
so that descriptors have them at hand.
One example where this is needed is in the xcbc(aes) shared descriptors,
which are updated in current patch.
Another example is the upcoming fix for DKP.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
Changes since v2:
- move key_dma assignment in .cra_init callback.
---

 drivers/crypto/caam/caamhash.c      | 37 +++++++++++++++++--------------------
 drivers/crypto/caam/caamhash_desc.c |  5 ++---
 drivers/crypto/caam/caamhash_desc.h |  2 +-
 drivers/crypto/caam/desc_constr.h   | 10 ++++------
 4 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 60163d1..49ab6ca 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -95,7 +95,6 @@ struct caam_hash_ctx {
 	dma_addr_t sh_desc_update_first_dma;
 	dma_addr_t sh_desc_fin_dma;
 	dma_addr_t sh_desc_digest_dma;
-	dma_addr_t key_dma;
 	enum dma_data_direction dir;
 	struct device *jrdev;
 	int ctx_len;
@@ -282,13 +281,10 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 	struct device *jrdev = ctx->jrdev;
 	u32 *desc;
 
-	/* key is loaded from memory for UPDATE and FINALIZE states */
-	ctx->adata.key_dma = ctx->key_dma;
-
 	/* shared descriptor for ahash_update */
 	desc = ctx->sh_desc_update;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_UPDATE,
-			    ctx->ctx_len, ctx->ctx_len, 0);
+			    ctx->ctx_len, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc update shdesc@" __stringify(__LINE__)" : ",
@@ -298,7 +294,7 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for ahash_{final,finup} */
 	desc = ctx->sh_desc_fin;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_FINALIZE,
-			    digestsize, ctx->ctx_len, 0);
+			    digestsize, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_fin_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc finup shdesc@" __stringify(__LINE__)" : ",
@@ -311,7 +307,7 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for first invocation of ahash_update */
 	desc = ctx->sh_desc_update_first;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INIT, ctx->ctx_len,
-			    ctx->ctx_len, ctx->key_dma);
+			    ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_first_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc update first shdesc@" __stringify(__LINE__)
@@ -321,7 +317,7 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for ahash_digest */
 	desc = ctx->sh_desc_digest;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INITFINAL,
-			    digestsize, ctx->ctx_len, 0);
+			    digestsize, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_digest_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc digest shdesc@" __stringify(__LINE__)" : ",
@@ -340,7 +336,7 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for ahash_update */
 	desc = ctx->sh_desc_update;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_UPDATE,
-			    ctx->ctx_len, ctx->ctx_len, 0);
+			    ctx->ctx_len, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("acmac update shdesc@" __stringify(__LINE__)" : ",
@@ -350,7 +346,7 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for ahash_{final,finup} */
 	desc = ctx->sh_desc_fin;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_FINALIZE,
-			    digestsize, ctx->ctx_len, 0);
+			    digestsize, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_fin_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("acmac finup shdesc@" __stringify(__LINE__)" : ",
@@ -360,7 +356,7 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for first invocation of ahash_update */
 	desc = ctx->sh_desc_update_first;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INIT, ctx->ctx_len,
-			    ctx->ctx_len, 0);
+			    ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_first_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("acmac update first shdesc@" __stringify(__LINE__)
@@ -370,7 +366,7 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for ahash_digest */
 	desc = ctx->sh_desc_digest;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INITFINAL,
-			    digestsize, ctx->ctx_len, 0);
+			    digestsize, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_digest_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("acmac digest shdesc@" __stringify(__LINE__)" : ",
@@ -507,7 +503,8 @@ static int axcbc_setkey(struct crypto_ahash *ahash, const u8 *key,
 	}
 
 	memcpy(ctx->key, key, keylen);
-	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
+	dma_sync_single_for_device(jrdev, ctx->adata.key_dma, keylen,
+				   DMA_TO_DEVICE);
 	ctx->adata.keylen = keylen;
 
 	print_hex_dump_debug("axcbc ctx.key@" __stringify(__LINE__)" : ",
@@ -1831,11 +1828,11 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 		ctx->adata.algtype = OP_TYPE_CLASS1_ALG | caam_hash->alg_type;
 		ctx->ctx_len = 48;
 
-		ctx->key_dma = dma_map_single_attrs(ctx->jrdev, ctx->key,
-						    ARRAY_SIZE(ctx->key),
-						    DMA_BIDIRECTIONAL,
-						    DMA_ATTR_SKIP_CPU_SYNC);
-		if (dma_mapping_error(ctx->jrdev, ctx->key_dma)) {
+		ctx->adata.key_dma = dma_map_single_attrs(ctx->jrdev, ctx->key,
+							  ARRAY_SIZE(ctx->key),
+							  DMA_BIDIRECTIONAL,
+							  DMA_ATTR_SKIP_CPU_SYNC);
+		if (dma_mapping_error(ctx->jrdev, ctx->adata.key_dma)) {
 			dev_err(ctx->jrdev, "unable to map key\n");
 			caam_jr_free(ctx->jrdev);
 			return -ENOMEM;
@@ -1859,7 +1856,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 		dev_err(ctx->jrdev, "unable to map shared descriptors\n");
 
 		if (is_xcbc_aes(caam_hash->alg_type))
-			dma_unmap_single_attrs(ctx->jrdev, ctx->key_dma,
+			dma_unmap_single_attrs(ctx->jrdev, ctx->adata.key_dma,
 					       ARRAY_SIZE(ctx->key),
 					       DMA_BIDIRECTIONAL,
 					       DMA_ATTR_SKIP_CPU_SYNC);
@@ -1895,7 +1892,7 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 			       offsetof(struct caam_hash_ctx, key),
 			       ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (is_xcbc_aes(ctx->adata.algtype))
-		dma_unmap_single_attrs(ctx->jrdev, ctx->key_dma,
+		dma_unmap_single_attrs(ctx->jrdev, ctx->adata.key_dma,
 				       ARRAY_SIZE(ctx->key), DMA_BIDIRECTIONAL,
 				       DMA_ATTR_SKIP_CPU_SYNC);
 	caam_jr_free(ctx->jrdev);
diff --git a/drivers/crypto/caam/caamhash_desc.c b/drivers/crypto/caam/caamhash_desc.c
index 71d0183..78383d7 100644
--- a/drivers/crypto/caam/caamhash_desc.c
+++ b/drivers/crypto/caam/caamhash_desc.c
@@ -83,10 +83,9 @@ EXPORT_SYMBOL(cnstr_shdsc_ahash);
  * @state: algorithm state OP_ALG_AS_{INIT, FINALIZE, INITFINALIZE, UPDATE}
  * @digestsize: algorithm's digest size
  * @ctx_len: size of Context Register
- * @key_dma: I/O Virtual Address of the key
  */
 void cnstr_shdsc_sk_hash(u32 * const desc, struct alginfo *adata, u32 state,
-			 int digestsize, int ctx_len, dma_addr_t key_dma)
+			 int digestsize, int ctx_len)
 {
 	u32 *skip_key_load;
 
@@ -136,7 +135,7 @@ void cnstr_shdsc_sk_hash(u32 * const desc, struct alginfo *adata, u32 state,
 			 LDST_SRCDST_BYTE_CONTEXT);
 	if (is_xcbc_aes(adata->algtype) && state == OP_ALG_AS_INIT)
 		/* Save K1 */
-		append_fifo_store(desc, key_dma, adata->keylen,
+		append_fifo_store(desc, adata->key_dma, adata->keylen,
 				  LDST_CLASS_1_CCB | FIFOST_TYPE_KEY_KEK);
 }
 EXPORT_SYMBOL(cnstr_shdsc_sk_hash);
diff --git a/drivers/crypto/caam/caamhash_desc.h b/drivers/crypto/caam/caamhash_desc.h
index 6947ee1..4f369b8 100644
--- a/drivers/crypto/caam/caamhash_desc.h
+++ b/drivers/crypto/caam/caamhash_desc.h
@@ -25,5 +25,5 @@ void cnstr_shdsc_ahash(u32 * const desc, struct alginfo *adata, u32 state,
 		       int digestsize, int ctx_len, bool import_ctx, int era);
 
 void cnstr_shdsc_sk_hash(u32 * const desc, struct alginfo *adata, u32 state,
-			 int digestsize, int ctx_len, dma_addr_t key_dma);
+			 int digestsize, int ctx_len);
 #endif /* _CAAMHASH_DESC_H_ */
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 5988a26..8154174 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -457,8 +457,8 @@ do { \
  *           functions where it is used.
  * @keylen: length of the provided algorithm key, in bytes
  * @keylen_pad: padded length of the provided algorithm key, in bytes
- * @key: address where algorithm key resides; virtual address if key_inline
- *       is true, dma (bus) address if key_inline is false.
+ * @key_dma: dma (bus) address where algorithm key resides
+ * @key_virt: virtual address where algorithm key resides
  * @key_inline: true - key can be inlined in the descriptor; false - key is
  *              referenced by the descriptor
  */
@@ -466,10 +466,8 @@ struct alginfo {
 	u32 algtype;
 	unsigned int keylen;
 	unsigned int keylen_pad;
-	union {
-		dma_addr_t key_dma;
-		const void *key_virt;
-	};
+	dma_addr_t key_dma;
+	const void *key_virt;
 	bool key_inline;
 };
 
-- 
2.1.0

