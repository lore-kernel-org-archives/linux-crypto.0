Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB497C76195
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 23:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B50C8208C0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 23:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfGRX7F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 19:59:05 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53190 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbfGRX6R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 19:58:17 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B60642003C7;
        Fri, 19 Jul 2019 01:58:15 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A9117200003;
        Fri, 19 Jul 2019 01:58:15 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5E351205D1;
        Fri, 19 Jul 2019 01:58:15 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v2 09/14] crypto: caam - keep both virtual and dma key addresses
Date:   Fri, 19 Jul 2019 02:57:51 +0300
Message-Id: <1563494276-3993-10-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
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
 drivers/crypto/caam/caamhash.c      | 26 ++++++++++++--------------
 drivers/crypto/caam/caamhash_desc.c |  5 ++---
 drivers/crypto/caam/caamhash_desc.h |  2 +-
 drivers/crypto/caam/desc_constr.h   | 10 ++++------
 4 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 2ec4bad..14fdfa1 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -283,13 +283,10 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
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
@@ -299,20 +296,17 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for ahash_{final,finup} */
 	desc = ctx->sh_desc_fin;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_FINALIZE,
-			    digestsize, ctx->ctx_len, 0);
+			    digestsize, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_fin_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc finup shdesc@" __stringify(__LINE__)" : ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	/* key is immediate data for INIT and INITFINAL states */
-	ctx->adata.key_virt = ctx->key;
-
 	/* shared descriptor for first invocation of ahash_update */
 	desc = ctx->sh_desc_update_first;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INIT, ctx->ctx_len,
-			    ctx->ctx_len, ctx->key_dma);
+			    ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_first_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc update first shdesc@" __stringify(__LINE__)
@@ -322,7 +316,7 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for ahash_digest */
 	desc = ctx->sh_desc_digest;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INITFINAL,
-			    digestsize, ctx->ctx_len, 0);
+			    digestsize, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_digest_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("axcbc digest shdesc@" __stringify(__LINE__)" : ",
@@ -341,7 +335,7 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for ahash_update */
 	desc = ctx->sh_desc_update;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_UPDATE,
-			    ctx->ctx_len, ctx->ctx_len, 0);
+			    ctx->ctx_len, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("acmac update shdesc@" __stringify(__LINE__)" : ",
@@ -351,7 +345,7 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for ahash_{final,finup} */
 	desc = ctx->sh_desc_fin;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_FINALIZE,
-			    digestsize, ctx->ctx_len, 0);
+			    digestsize, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_fin_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("acmac finup shdesc@" __stringify(__LINE__)" : ",
@@ -361,7 +355,7 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for first invocation of ahash_update */
 	desc = ctx->sh_desc_update_first;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INIT, ctx->ctx_len,
-			    ctx->ctx_len, 0);
+			    ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_first_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("acmac update first shdesc@" __stringify(__LINE__)
@@ -371,7 +365,7 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 	/* shared descriptor for ahash_digest */
 	desc = ctx->sh_desc_digest;
 	cnstr_shdsc_sk_hash(desc, &ctx->adata, OP_ALG_AS_INITFINAL,
-			    digestsize, ctx->ctx_len, 0);
+			    digestsize, ctx->ctx_len);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_digest_dma,
 				   desc_bytes(desc), ctx->dir);
 	print_hex_dump_debug("acmac digest shdesc@" __stringify(__LINE__)" : ",
@@ -508,6 +502,10 @@ static int axcbc_setkey(struct crypto_ahash *ahash, const u8 *key,
 	memcpy(ctx->key, key, keylen);
 	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
 	ctx->adata.keylen = keylen;
+	/* key is loaded from memory for UPDATE and FINALIZE states */
+	ctx->adata.key_dma = ctx->key_dma;
+	/* key is immediate data for INIT and INITFINAL states */
+	ctx->adata.key_virt = ctx->key;
 
 	print_hex_dump_debug("axcbc ctx.key@" __stringify(__LINE__)" : ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key, keylen, 1);
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

