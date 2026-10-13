Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9EC18CC13
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897132; cv=none; b=WpYHdd3eA/UIV/rVc9mQTAJDs7fWV6SJ1DSm6J4gnwAU4KpQINkY3CM6y15duughYbRUP3zdO2YqS9n14sghgr4J/hOrqOq0seGJbuPz8V+GzCxCIJVvUf1J6Ss9ZuE+bK1UbkpoE6OEf4ZoAZAOXgDk00Pg8RD7xkDd5Up0eEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897132; c=relaxed/simple;
	bh=3Yzij5bDsYV/36/w7suwqNDeRci/n3NB/uyC11cddSQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ELJnpLr5QT0wr79LkwptGSLuOlqcDuTabDR2XP2VzPXmP4DzwMOg8eWZBJFT0li6z0lLE22VSoURpiYXOb8gogLJcYulF4k8I00t1YFB2S9ltzUx62DCcycKers0LufW225VmC1q9Zp46iNdtwYcTv3CBgplVlwzo1zisi9mGcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=JrRHjFkm; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="JrRHjFkm"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id CC3BB1A1215
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:12:08 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9F9E660362;
	Tue, 13 Oct 2026 13:12:08 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DF65711D7139C;
	Tue, 13 Oct 2026 15:12:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897124; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=U5GCKHIldHKV3o+9ldWuJR3gPjAi98WRoRW4dopdWTs=;
	b=JrRHjFkmakonyVroc3NQoi5Ng+0Hzn8p4v9YezaZCVGfkVqLYMQQMwHSDt1MPuC5MYMxeb
	zz/pX7gUl+J/DwFUuCtvBwd1QvhlKaqMdL4IaR3+26qzxIcsd0M+YXjprkX5mjoATq+xZj
	0nfnUqo2aUZ4bScNK35DSFj0tRkOVEStpjEx5Q3GGDwAMVRCA6Q28GiD0b7tzI9R5Xl+pv
	uqZUUycXiiQuijMqoVNE5TqPuMVACltazosOBke7QjAELeXLYAn8A1c7SQahQPDFVYYBIr
	iJjahWxNCSGr3dX8MTq57eAlYUTPiUqI8Wgntfh4oy5J6qGWL6/o1KbObcCTGQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:27 +0200
Subject: [PATCH v8 01/20] crypto: talitos/hash - Use
 CRYPTO_AHASH_BLOCK_ONLY API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-1-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=16416;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=3Yzij5bDsYV/36/w7suwqNDeRci/n3NB/uyC11cddSQ=;
 b=Qkr0hLJW68rYh+0wKYp4hkU+uXr2xPgbL/QMY8OM+oIHfuPh3GL8m8dcfD8n7xBt+knEo/+iI
 esEacXiHnpLABISKFu+UyKq4UXRUkG+IragCJ7j7cQ4zvh1Sr7FfP3O
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
 drivers/crypto/talitos.c | 179 +++++++++++++++++++----------------------------
 1 file changed, 73 insertions(+), 106 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c7d9ce2905be..28a179e609b5 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -932,31 +932,26 @@ struct talitos_ctx {
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
@@ -1823,14 +1818,8 @@ static void ahash_done(struct device *dev,
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
 
@@ -1848,14 +1837,9 @@ static void ahash_done(struct device *dev,
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
 
@@ -1863,21 +1847,27 @@ static void ahash_done(struct device *dev,
  * SEC1 doesn't like hashing of 0 sized message, so we do the padding
  * ourself and submit a padded block
  */
-static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
-			       struct talitos_edesc *edesc,
-			       struct talitos_ptr *ptr)
+static void talitos_handle_buggy_hash(struct ahash_request *areq,
+				      struct talitos_edesc *edesc,
+				      struct talitos_ptr *ptr)
 {
-	static u8 padded_hash[64] = {
-		0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	};
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 
+	__be64 be_len = cpu_to_be64(req_ctx->message_size << 3);
+	__le64 le_len = cpu_to_le64(req_ctx->message_size << 3);
+
+	memset(req_ctx->padding_buf, 0, sizeof(req_ctx->padding_buf));
+	req_ctx->padding_buf[0] = 0x80;
+	if (crypto_ahash_digestsize(tfm) == MD5_DIGEST_SIZE)
+		memcpy(&req_ctx->padding_buf[56], &le_len, sizeof(le_len));
+	else
+		memcpy(&req_ctx->padding_buf[56], &be_len, sizeof(be_len));
 	pr_err_once("Bug in SEC1, padding ourself\n");
 	edesc->desc.hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
-	map_single_talitos_ptr(ctx->dev, ptr, sizeof(padded_hash),
-			       (char *)padded_hash, DMA_TO_DEVICE);
+	map_single_talitos_ptr(ctx->dev, ptr, sizeof(req_ctx->padding_buf),
+			       (char *)req_ctx->padding_buf, DMA_TO_DEVICE);
 }
 
 static void common_nonsnoop_hash(struct talitos_edesc *edesc,
@@ -1942,7 +1932,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* last DWORD empty */
 
 	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
-		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
+		talitos_handle_buggy_hash(areq, edesc, &desc->ptr[3]);
 
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
@@ -1975,7 +1965,7 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
 	size_t offset = 0;
 
 	do {
-		src = scatterwalk_ffwd(tmp, req_ctx->psrc, offset);
+		src = scatterwalk_ffwd(tmp, areq->src, offset);
 
 		to_hash_this_desc =
 			min(nbytes, ALIGN_DOWN(desc_max, blocksize));
@@ -1988,8 +1978,7 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
 			return edesc;
 		}
 
-		edesc->src =
-			scatterwalk_ffwd(edesc->bufsl, req_ctx->psrc, offset);
+		edesc->src = scatterwalk_ffwd(edesc->bufsl, areq->src, offset);
 		edesc->desc.hdr = ctx->desc_hdr_template;
 		edesc->first = offset == 0;
 		edesc->last = nbytes - to_hash_this_desc == 0;
@@ -2042,62 +2031,17 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
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
+	nbytes_to_hash = ALIGN_DOWN(nbytes, blocksize);
+	to_hash_later = nbytes - nbytes_to_hash;
 
-	/* At least (blocksize + 1) bytes are available to hash */
-	nbytes_to_hash = nbytes + req_ctx->nbuf;
-	to_hash_later = nbytes_to_hash & (blocksize - 1);
-
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
 	}
 
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
-	}
 	req_ctx->to_hash_later = to_hash_later;
 
 	edesc = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
@@ -2105,9 +2049,13 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
+	req_ctx->message_size += nbytes_to_hash;
+
 	ret = talitos_submit(dev, ctx->ch, &edesc->desc, ahash_done, areq);
-	if (ret != -EINPROGRESS)
+	if (ret != -EINPROGRESS) {
+		req_ctx->message_size -= nbytes_to_hash;
 		free_edesc_list_from(areq, edesc);
+	}
 
 	return ret;
 }
@@ -2122,8 +2070,6 @@ static int ahash_init(struct ahash_request *areq)
 	dma_addr_t dma;
 
 	/* Initialize the context */
-	req_ctx->buf_idx = 0;
-	req_ctx->nbuf = 0;
 	req_ctx->first_request = 1;
 	req_ctx->swinit = 0; /* assume h/w init of context */
 	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
@@ -2131,6 +2077,7 @@ static int ahash_init(struct ahash_request *areq)
 			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
 	req_ctx->hw_context_size = size;
 	req_ctx->last_request = 0;
+	req_ctx->message_size = 0;
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
 			     DMA_TO_DEVICE);
@@ -2220,12 +2167,11 @@ static int ahash_export(struct ahash_request *areq, void *out)
 
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
@@ -2246,12 +2192,11 @@ static int ahash_import(struct ahash_request *areq, const void *in)
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
@@ -2929,8 +2874,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -2945,8 +2892,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -2961,8 +2910,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -2977,8 +2928,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -2993,8 +2946,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3009,8 +2964,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3025,8 +2982,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3041,8 +3000,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3057,8 +3018,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3073,8 +3036,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3089,8 +3054,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3105,8 +3072,10 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3178,8 +3147,6 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 				   algt.alg.hash);
 
 	ctx->keylen = 0;
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct talitos_ahash_req_ctx));
 
 	return talitos_init_common(ctx, talitos_alg);
 }

-- 
2.56.0

