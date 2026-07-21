Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FC9374A05
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784641524; cv=none; b=g33qwVjh5/m/wTceozKCR0VcjXJNMgFF7tOKKWxJAJbidb+wFpdOT+pZpa2hBLmLntCzc2GAaJ3YLyI/9nqLH4SMoMKvNMk1J58s7lCWczjOkzMm6G7vJlfIIuZdErkbhft4Ddg9lKwSCsoOXuHo96ZFvVd6uQhLzZ0cRtTh6qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784641524; c=relaxed/simple;
	bh=u3ns9J7SV+wlq3Ub5rl3Zl2GPXPitqTqmT2ODL49mOM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ts2S0TxVjnx8+adwrTNVY1TAyHjD51nleowsJw+DW7Rft4Yq7Bk8cb75k5bd7fFvgmBNLJ1W8+8ltuu69FgYVpMJJPR0XKRLr1fk//KkuoQNI361J0gLklPmUFZ5pOp2KilxAJudXwzQNnSP5ZrMYhZ/svBgcxzr3fNkaoE0kxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=jJ604E9D; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="jJ604E9D"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 39B614E40EA5;
	Tue, 21 Jul 2026 13:45:21 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 0EEB760368;
	Tue, 21 Jul 2026 13:45:21 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9B0F611BD3002;
	Tue, 21 Jul 2026 15:45:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784641520; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=KDSyxi9TB7IeYEB6Cx07WBLh/K56AQYK5ZPXbQRazak=;
	b=jJ604E9DssEvptN3Sp3AdvBqbOHKzJ+DO7f109T6L7Ev+UxCaNqq+s4ON++CwudN72eeyC
	QqE+1bLdgROrXfJKEi4j3s42HDeFhBq/1yXyvfGAnt/DJekEWzWlvgDf+BrO12+VFIQF6D
	wYnYljjiUIjVMri/AbanYxY+X0sRyaJrW72h+bDGNRNzK/7CdzY/bGBq3KAWlPSxKjQlIb
	2Q0LWN57ieFHEGbG3hW9zW+NQeDdjvYeXXisr/Z1ayH7y5XpRzF5kdJ9q0UFOcfGOoV/RA
	to5lkndLSlOebq7kBTTp66Te16adxjfmDt+K1sYJ8o2gfJv+gq7ZQWQi6qPj/w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:43:36 +0200
Subject: [PATCH v3 01/19] crypto: talitos/hash - Use
 CRYPTO_AHASH_BLOCK_ONLY API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-1-c602fa4d00e1@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-c602fa4d00e1@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-c602fa4d00e1@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784641453; l=15337;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=u3ns9J7SV+wlq3Ub5rl3Zl2GPXPitqTqmT2ODL49mOM=;
 b=KbHHtFvG0HxTTOZJPbet37cdGTagSUdo3h2dJg+paaIREvR7+kx350NBtwYU1s0sxyAGgFRX5
 qJNanOD+B02B9tEZfcHwZRNz2J3InaC1fpuGVlqLx0RxI6vjHIR2ozY
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
 drivers/crypto/talitos.c | 168 +++++++++++++++++------------------------------
 1 file changed, 62 insertions(+), 106 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 584508963241..99853faf20e8 100644
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
@@ -2045,62 +2028,17 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
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
 
 	edesc = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
@@ -2125,8 +2063,6 @@ static int ahash_init(struct ahash_request *areq)
 	dma_addr_t dma;
 
 	/* Initialize the context */
-	req_ctx->buf_idx = 0;
-	req_ctx->nbuf = 0;
 	req_ctx->first_request = 1;
 	req_ctx->swinit = 0; /* assume h/w init of context */
 	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
@@ -2223,12 +2159,11 @@ static int ahash_export(struct ahash_request *areq, void *out)
 
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
@@ -2249,12 +2184,11 @@ static int ahash_import(struct ahash_request *areq, const void *in)
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
@@ -2932,8 +2866,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -2948,8 +2884,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -2964,8 +2902,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -2980,8 +2920,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -2996,8 +2938,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3012,8 +2956,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3028,8 +2974,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3044,8 +2992,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3060,8 +3010,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3076,8 +3028,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3092,8 +3046,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3108,8 +3064,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3181,8 +3139,6 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 				   algt.alg.hash);
 
 	ctx->keylen = 0;
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct talitos_ahash_req_ctx));
 
 	return talitos_init_common(ctx, talitos_alg);
 }

-- 
2.55.0

