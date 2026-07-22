Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243E847F2E8;
	Wed, 22 Jul 2026 08:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710474; cv=none; b=rUWd0xdR4TWKyvK+1SvdUKDCIHKJZNwiD37UrRZbue6V4GqFxKt3831hs6G43MG8usla0qDIyTpmKzYSvxdIZqcKQYrIYYloVJlx6oUxJyTrWugpdAliRrQB5oE9+FkCmD2VcSlGx173sIOR11qIaf3Blir1EWuBSjGZGcvU2h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710474; c=relaxed/simple;
	bh=kj1iszGliwFJ0BhcOzJ9mjLNWMt5WfYuBQkTtTpO63E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J9wWKLxI4IUPA6H3QZdhJWZHSV4ZDi5A9Pw5aNVAJLF3M4FHmRWPTXWypHLowdIuIHvSaIJixF/CIx9OS4db4DNNqidy99sllOyDOYNbbYmCaGPP77wYOm67qeKBR0i7ERZwZxw9oOfzN+aS9haQH/e2861qbAjrLmzPTEx/mZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=wbCZ9oRn; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="wbCZ9oRn"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 79F2C1A1166;
	Wed, 22 Jul 2026 08:54:29 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 489B660388;
	Wed, 22 Jul 2026 08:54:29 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D5FFB11BD1850;
	Wed, 22 Jul 2026 10:54:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784710468; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=aRUvRHU9A3bHnNfY/yNfWzJi4AtZuOXd9YiX3pV99HA=;
	b=wbCZ9oRnlnr7VLLjkM90/pNNJIpido+MJijNtWdwBWN/xvML2s1cpwjCGOTcgdPiSKzYj+
	CB+N6y26oU2V49EElHlriKzdr182WcgfEVfeOi+/0qx+K38WJ7g3Bl1wW1S8QcfTgtQH6U
	FQm89Djk2CA3RPaX1FplPDmE6CU4iJh4nuNy7TST1MMt3cKZa2xkAuHjIiEtwNrtL3BshA
	uHr/+A8k3hNCCQEmKkwJz3HtNT5OScMuPNhRuDwrJH1KxwmEg991jet98ksimWL9oumkks
	/HcDfLQT2GUQF4Wpkl9hO6S/ujajQ74eOZTW7oCwSkGLEBIx7dDocfXpumD29w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 22 Jul 2026 10:53:45 +0200
Subject: [PATCH v4 01/19] crypto: talitos/hash - Use
 CRYPTO_AHASH_BLOCK_ONLY API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-7-1-rc1_talitos_cleanup-v4-1-81d1ed2ad911@bootlin.com>
References: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
In-Reply-To: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784710463; l=15722;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=kj1iszGliwFJ0BhcOzJ9mjLNWMt5WfYuBQkTtTpO63E=;
 b=TLKPTd582FmJ6VvFyV9oQ5M8Hlkn2cYBHgMOG6Wpo8LgIDV8tNWwQyPvyyY/2TdN53EjM7mzu
 05c1pjMAw8IDnrbPc9/y2zmQWcChRyvSmobs4tI/8nDDq9ePz44JO5Q
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

The hash implementation maintained a software buffer to accumulate
partial blocks across update() calls, copying data to/from scatterlists
with sg_copy_to_buffer()/sg_pcopy_to_buffer() and chaining in a virtual
scatterlist entry.  This is unnecessary now with
CRYPTO_AHASH_ALG_BLOCK_ONLY flag.

Remove unnecessary fields in the request and export structure. On
completion, pass any remaining tail bytes back via
ahash_request_complete() so that the core re-submits them with the next
request.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 170 ++++++++++++++++++-----------------------------
 1 file changed, 64 insertions(+), 106 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 584508963241..3550321ddc6c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -935,31 +935,26 @@ struct talitos_ctx {
 	unsigned int authkeylen;
 };
 
-#define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
 #define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
 
 struct talitos_ahash_req_ctx {
 	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
+	u8 padding_buf[64];
+	u64 message_size;
 	unsigned int hw_context_size;
-	u8 buf[2][HASH_MAX_BLOCK_SIZE];
-	int buf_idx;
 	unsigned int swinit;
 	unsigned int first_request;
 	unsigned int last_request;
 	unsigned int to_hash_later;
-	unsigned int nbuf;
-	struct scatterlist bufsl[2];
-	struct scatterlist *psrc;
 };
 
 struct talitos_export_state {
 	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
-	u8 buf[HASH_MAX_BLOCK_SIZE];
+	u64 message_size;
 	unsigned int swinit;
 	unsigned int first_request;
 	unsigned int last_request;
 	unsigned int to_hash_later;
-	unsigned int nbuf;
 };
 
 static int aead_setkey(struct crypto_aead *authenc,
@@ -1826,14 +1821,8 @@ static void ahash_done(struct device *dev,
 	struct talitos_edesc *next;
 
 	if (is_sec1) {
-		if (!req_ctx->last_request && req_ctx->to_hash_later) {
-			/* Position any partial block for next update/final/finup */
-			req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
-			req_ctx->nbuf = req_ctx->to_hash_later;
-		}
-
 		free_edesc_list_from(areq, edesc);
-		ahash_request_complete(areq, err);
+		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
 	} else {
 		next = edesc->next_desc;
 
@@ -1851,14 +1840,9 @@ static void ahash_done(struct device *dev,
 			return;
 		}
 out:
-		if (!req_ctx->last_request && req_ctx->to_hash_later) {
-			/* Position any partial block for next update/final/finup */
-			req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
-			req_ctx->nbuf = req_ctx->to_hash_later;
-		}
 		if (err && next)
 			free_edesc_list_from(areq, next);
-		ahash_request_complete(areq, err);
+		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
 	}
 }
 
@@ -1866,21 +1850,21 @@ static void ahash_done(struct device *dev,
  * SEC1 doesn't like hashing of 0 sized message, so we do the padding
  * ourself and submit a padded block
  */
-static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
-			       struct talitos_edesc *edesc,
-			       struct talitos_ptr *ptr)
+static void talitos_handle_buggy_hash(struct talitos_ahash_req_ctx *req_ctx,
+				      struct talitos_ctx *ctx,
+				      struct talitos_edesc *edesc,
+				      struct talitos_ptr *ptr)
 {
-	static u8 padded_hash[64] = {
-		0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	};
+	__be64 len = cpu_to_be64(req_ctx->message_size << 3);
+
+	memset(req_ctx->padding_buf, 0, sizeof(req_ctx->padding_buf));
+	req_ctx->padding_buf[0] = 0x80;
+	memcpy(&req_ctx->padding_buf[56], &len, sizeof(len));
 
 	pr_err_once("Bug in SEC1, padding ourself\n");
 	edesc->desc.hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
-	map_single_talitos_ptr(ctx->dev, ptr, sizeof(padded_hash),
-			       (char *)padded_hash, DMA_TO_DEVICE);
+	map_single_talitos_ptr(ctx->dev, ptr, sizeof(req_ctx->padding_buf),
+			       (char *)req_ctx->padding_buf, DMA_TO_DEVICE);
 }
 
 static void common_nonsnoop_hash(struct talitos_edesc *edesc,
@@ -1945,7 +1929,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* last DWORD empty */
 
 	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
-		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
+		talitos_handle_buggy_hash(req_ctx, ctx, edesc, &desc->ptr[3]);
 
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
@@ -1978,7 +1962,7 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
 	size_t offset = 0;
 
 	do {
-		src = scatterwalk_ffwd(tmp, req_ctx->psrc, offset);
+		src = scatterwalk_ffwd(tmp, areq->src, offset);
 
 		to_hash_this_desc =
 			min(nbytes, ALIGN_DOWN(desc_max, blocksize));
@@ -1991,8 +1975,7 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
 			return edesc;
 		}
 
-		edesc->src =
-			scatterwalk_ffwd(edesc->bufsl, req_ctx->psrc, offset);
+		edesc->src = scatterwalk_ffwd(edesc->bufsl, areq->src, offset);
 		edesc->desc.hdr = ctx->desc_hdr_template;
 		edesc->first = offset == 0;
 		edesc->last = nbytes - to_hash_this_desc == 0;
@@ -2045,63 +2028,19 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(ctx->dev));
 	unsigned int nbytes_to_hash;
 	unsigned int to_hash_later;
-	unsigned int nsg;
-	int nents;
 	struct device *dev = ctx->dev;
-	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
 	int ret;
 
-	if (!req_ctx->last_request && (nbytes + req_ctx->nbuf <= blocksize)) {
-		/* Buffer up to one whole block */
-		nents = sg_nents_for_len(areq->src, nbytes);
-		if (nents < 0) {
-			dev_err(dev, "Invalid number of src SG.\n");
-			return nents;
-		}
-		sg_copy_to_buffer(areq->src, nents,
-				  ctx_buf + req_ctx->nbuf, nbytes);
-		req_ctx->nbuf += nbytes;
-		return 0;
-	}
-
-	/* At least (blocksize + 1) bytes are available to hash */
-	nbytes_to_hash = nbytes + req_ctx->nbuf;
-	to_hash_later = nbytes_to_hash & (blocksize - 1);
+	nbytes_to_hash = ALIGN_DOWN(nbytes, blocksize);
+	to_hash_later = nbytes - nbytes_to_hash;
 
-	if (req_ctx->last_request)
+	if (req_ctx->last_request) {
+		nbytes_to_hash = nbytes;
 		to_hash_later = 0;
-	else if (to_hash_later)
-		/* There is a partial block. Hash the full block(s) now */
-		nbytes_to_hash -= to_hash_later;
-	else {
-		/* Keep one block buffered */
-		nbytes_to_hash -= blocksize;
-		to_hash_later = blocksize;
-	}
-
-	/* Chain in any previously buffered data */
-	if (req_ctx->nbuf) {
-		nsg = (req_ctx->nbuf < nbytes_to_hash) ? 2 : 1;
-		sg_init_table(req_ctx->bufsl, nsg);
-		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
-		if (nsg > 1)
-			sg_chain(req_ctx->bufsl, 2, areq->src);
-		req_ctx->psrc = req_ctx->bufsl;
-	} else
-		req_ctx->psrc = areq->src;
-
-	if (to_hash_later) {
-		nents = sg_nents_for_len(areq->src, nbytes);
-		if (nents < 0) {
-			dev_err(dev, "Invalid number of src SG.\n");
-			return nents;
-		}
-		sg_pcopy_to_buffer(areq->src, nents,
-				   req_ctx->buf[(req_ctx->buf_idx + 1) & 1],
-				      to_hash_later,
-				      nbytes - to_hash_later);
 	}
+
 	req_ctx->to_hash_later = to_hash_later;
+	req_ctx->message_size += nbytes_to_hash;
 
 	edesc = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
 					  is_sec1);
@@ -2125,8 +2064,6 @@ static int ahash_init(struct ahash_request *areq)
 	dma_addr_t dma;
 
 	/* Initialize the context */
-	req_ctx->buf_idx = 0;
-	req_ctx->nbuf = 0;
 	req_ctx->first_request = 1;
 	req_ctx->swinit = 0; /* assume h/w init of context */
 	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
@@ -2134,6 +2071,7 @@ static int ahash_init(struct ahash_request *areq)
 			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
 	req_ctx->hw_context_size = size;
 	req_ctx->last_request = 0;
+	req_ctx->message_size = 0;
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
 			     DMA_TO_DEVICE);
@@ -2223,12 +2161,11 @@ static int ahash_export(struct ahash_request *areq, void *out)
 
 	memcpy(export->hw_context, req_ctx->hw_context,
 	       req_ctx->hw_context_size);
-	memcpy(export->buf, req_ctx->buf[req_ctx->buf_idx], req_ctx->nbuf);
 	export->swinit = req_ctx->swinit;
 	export->first_request = req_ctx->first_request;
 	export->last_request = req_ctx->last_request;
 	export->to_hash_later = req_ctx->to_hash_later;
-	export->nbuf = req_ctx->nbuf;
+	export->message_size = req_ctx->message_size;
 
 	return 0;
 }
@@ -2249,12 +2186,11 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
 	req_ctx->hw_context_size = size;
 	memcpy(req_ctx->hw_context, export->hw_context, size);
-	memcpy(req_ctx->buf[0], export->buf, export->nbuf);
 	req_ctx->swinit = export->swinit;
 	req_ctx->first_request = export->first_request;
 	req_ctx->last_request = export->last_request;
 	req_ctx->to_hash_later = export->to_hash_later;
-	req_ctx->nbuf = export->nbuf;
+	req_ctx->message_size = export->message_size;
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
 			     DMA_TO_DEVICE);
@@ -2932,8 +2868,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "md5",
 				.cra_driver_name = "md5-talitos",
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2948,8 +2886,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "sha1",
 				.cra_driver_name = "sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2964,8 +2904,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "sha224",
 				.cra_driver_name = "sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2980,8 +2922,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "sha256",
 				.cra_driver_name = "sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2996,8 +2940,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "sha384",
 				.cra_driver_name = "sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -3012,8 +2958,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "sha512",
 				.cra_driver_name = "sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -3028,8 +2976,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(md5)",
 				.cra_driver_name = "hmac-md5-talitos",
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -3044,8 +2994,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(sha1)",
 				.cra_driver_name = "hmac-sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -3060,8 +3012,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(sha224)",
 				.cra_driver_name = "hmac-sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -3076,8 +3030,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(sha256)",
 				.cra_driver_name = "hmac-sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -3092,8 +3048,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(sha384)",
 				.cra_driver_name = "hmac-sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -3108,8 +3066,10 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(sha512)",
 				.cra_driver_name = "hmac-sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
+				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
 				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
+					     CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -3181,8 +3141,6 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 				   algt.alg.hash);
 
 	ctx->keylen = 0;
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct talitos_ahash_req_ctx));
 
 	return talitos_init_common(ctx, talitos_alg);
 }

-- 
2.55.0

