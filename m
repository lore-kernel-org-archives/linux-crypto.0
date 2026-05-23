Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A56029DB6E
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779549119; cv=none; b=cj0mhFPGijuP5+J7aiT9pnEKCsJsGdlOLQy4OJLzxJPop3KoishzvMB36JmqjTF5xW0JwvmUs1ecRgN31RDVpEoAT4jYmzCRr9SMKPFp1jmU7aK1k2ICYzbWupA7NuBKYEwqIPRihPTx5+4F1pH5AnV8NZaj+7O2yqaWWgVqgv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779549119; c=relaxed/simple;
	bh=UhcV2HdpQ+a1WeL2yh6GXWRx4nW2TmUkpOWjjAelJEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Inw9c8HcTYHTFonAY6V0ZpdlwFMB1GBrFLGI1Gm7u78UcQrUMa9R09XKPjN7RQc5U8R2CLBlNik/ajlzzuVdM0WkYaYmnx8sAekucseoOFaHWuxhrc0NoaouhOHOz6dZNKB2PtFF9I6qRUq5fzMaVTNZ7bDcGqKTL9mxABACRAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OtA0Yk7n; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OtA0Yk7n"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-459bf19e87bso4862673f8f.1
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 08:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779549116; x=1780153916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nw29HGfKQpelf6EJNW+UfbygqyH8IA9037buMtMPBXs=;
        b=OtA0Yk7nLtxkgFEGYqNZwQzIOP72g+GEYqGzlRo72JveZzUVghtL/7Hn6kOE9SY/Q2
         bzvwcQGURXDR+tvh+q5RrMTfiKofwRkPVbOVaWbXBfL3NI59Sn+GCClcIWxo0k7XihNF
         6S4JdfdZs31ZX25NZQzlpau5fc1Egfe9nZNivm0zV0NchTl2R3dN/933VQ8484i73yb2
         t5meLd81GCQm3wcvRq8QvG22V3gaWbkKAD5nLptiSL19ohSx3QDAkEeUjjFRTOxDS9tD
         MHpzWoRoW+X3QGFg6ymgM2rJGWJYt3pafUzmYJVUpc6E0nNyC5heCFRsDDSdwJ+0++k9
         XG1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779549116; x=1780153916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nw29HGfKQpelf6EJNW+UfbygqyH8IA9037buMtMPBXs=;
        b=M/dna/hYJIlcAY1f9O23qitKF970+sUPcw9WXDcuRT3njrOLxe42CYEA7TEWwUvh4l
         IzEYusnYPAPqrgOI7kP2w0IQX5abZGHs4HKO3sFVewxGjZnJWicU+bXQyzFotFVSArX7
         qU4RYSX6CIzaUPmU4OZE8elL3Gf22AonwYK2agLCICQi5CYTPAL70Jlu1fI7Ci9kOTgh
         MtjpZ5otek4VqqMfWL1kjnh1BGAIsVzRNfcijojE0EHeT4V6xBnId8+fYYz1WxeV50UA
         v4XajHR1xTHqifk3iWg9IHXFoZ0RdL73Ipq2//NL33XkiRtaVpxrSE16StwDnlii5frI
         OZGg==
X-Forwarded-Encrypted: i=1; AFNElJ+N/u2zD69kxgcbdkw0Kh+Lp1vKK07NPcuLnjKMPpYpzAiv/5rE20Bfp1t5n8uaQh5bwA4Q/i8ck/BcZmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjBflOOT/6X1JpJ9K/gAMaH7lajNUXAJT2zPZWXCEuUa4Yteh4
	ikJHglL4rEz3/c1tCMJk+TT6gkvg6cRUeYCx4s6qv3/ZYJg9Jwlnz8d1
X-Gm-Gg: Acq92OFsGnIU1Ylt70udk7/qQjp30YwCEWm/CFo6gTBlp6JuEp7XoAHdGho+5t5jxp/
	nJ0hiVp2qMM4YXfycQel4AhK2uSRuUsxlJY7H7kORYdqQj+v4gT55Nvp7uCVQCJCB76XIYqfpyC
	027H7ON00WBtHWnaSq7S5uSjdgCoswgCinC6zOxdkZ7LjH6spUhdXi2J/T+4JV/zti76jkdpTFM
	QZN0Q9Ja9VRb+/L2xapf75AM0juE5PJBZsf/4X2eB9qfONMKcoeIezp0MmfwfaVvUezFALImnkn
	XwvgkftwolwKRTb9olYOEj1wWVNd8/cJX41gLGA8LQIZPaVChzphepAoMzy6uHNhFU5pIaLuz24
	RTCr2oOGbTlDr4nfelZQXKgV1mqJCEMeD+2jO+O25uallJptAS4+CF6OfIBq0QUKIFoU9Ro9jxY
	E+l8okA2TC2j+bLgz4eODxlcjO5mlo6F5f
X-Received: by 2002:a05:6000:430b:b0:44b:ad5a:cd33 with SMTP id ffacd0b85a97d-45eb38e4b24mr12088339f8f.40.1779549116456;
        Sat, 23 May 2026 08:11:56 -0700 (PDT)
Received: from mini.main.internal ([2a02:908:c211:cd18:36:c98d:902c:348d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d7167dsm12629156f8f.35.2026.05.23.08.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 08:11:55 -0700 (PDT)
From: Goetz Goerisch <ggoerisch@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ggoerisch@gmail.com,
	herbert@gondor.apana.org.au,
	herve.codina@bootlin.com,
	linux-crypto@vger.kernel.org,
	miquel.raynal@bootlin.com,
	paul.louvel@bootlin.com,
	sashal@kernel.org,
	stable@vger.kernel.org,
	thomas.petazzoni@bootlin.com
Subject: [PATCH 5/5] crypto: talitos - rename first/last to first_desc/last_desc
Date: Sat, 23 May 2026 17:10:48 +0200
Message-ID: <20260523151048.14914-6-ggoerisch@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260523151048.14914-1-ggoerisch@gmail.com>
References: <2026052212-aged-amply-7bd8@gregkh>
 <20260523151048.14914-1-ggoerisch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Louvel <paul.louvel@bootlin.com>

commit a1b80018b8cec27fc06a8b04a7f8b5f6cfe86eae upstream.

Previous commit introduces a new last_request variable in the context
structure.

Renaming the first/last existing member variable in the context
structure to improve readability.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/talitos.c | 46 ++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index ea6ae72c71ad..fb1adc2956b8 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -869,8 +869,8 @@ struct talitos_ahash_req_ctx {
 	u8 buf[2][HASH_MAX_BLOCK_SIZE];
 	int buf_idx;
 	unsigned int swinit;
-	unsigned int first;
-	unsigned int last;
+	unsigned int first_desc;
+	unsigned int last_desc;
 	unsigned int last_request;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
@@ -889,8 +889,8 @@ struct talitos_export_state {
 	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
 	u8 buf[HASH_MAX_BLOCK_SIZE];
 	unsigned int swinit;
-	unsigned int first;
-	unsigned int last;
+	unsigned int first_desc;
+	unsigned int last_desc;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
 };
@@ -1722,7 +1722,7 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	if (desc->next_desc &&
 	    desc->ptr[5].ptr != desc2->ptr[5].ptr)
 		unmap_single_talitos_ptr(dev, &desc2->ptr[5], DMA_FROM_DEVICE);
-	if (req_ctx->last)
+	if (req_ctx->last_desc)
 		memcpy(areq->result, req_ctx->hw_context,
 		       crypto_ahash_digestsize(tfm));
 
@@ -1759,7 +1759,7 @@ static void ahash_done(struct device *dev,
 		 container_of(desc, struct talitos_edesc, desc);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	if (!req_ctx->last && req_ctx->to_hash_later) {
+	if (!req_ctx->last_desc && req_ctx->to_hash_later) {
 		/* Position any partial block for next update/final/finup */
 		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
 		req_ctx->nbuf = req_ctx->to_hash_later;
@@ -1825,7 +1825,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* first DWORD empty */
 
 	/* hash context in */
-	if (!req_ctx->first || req_ctx->swinit) {
+	if (!req_ctx->first_desc || req_ctx->swinit) {
 		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
@@ -1833,7 +1833,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		req_ctx->swinit = 0;
 	}
 	/* Indicate next op is not the first. */
-	req_ctx->first = 0;
+	req_ctx->first_desc = 0;
 
 	/* HMAC key */
 	if (ctx->keylen)
@@ -1866,7 +1866,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* fifth DWORD empty */
 
 	/* hash/HMAC out -or- hash context out */
-	if (req_ctx->last)
+	if (req_ctx->last_desc)
 		map_single_talitos_ptr(dev, &desc->ptr[5],
 				       crypto_ahash_digestsize(tfm),
 				       req_ctx->hw_context, DMA_FROM_DEVICE);
@@ -1908,7 +1908,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		if (sg_count > 1)
 			sync_needed = true;
 		copy_talitos_ptr(&desc2->ptr[5], &desc->ptr[5], is_sec1);
-		if (req_ctx->last)
+		if (req_ctx->last_desc)
 			map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
 						      req_ctx->hw_context_size,
 						      req_ctx->hw_context,
@@ -1964,7 +1964,7 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	bool is_sec1 = has_ftr_sec1(priv);
 	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
 
-	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
+	if (!req_ctx->last_desc && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
 		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
 		if (nents < 0) {
@@ -1981,7 +1981,7 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	nbytes_to_hash = nbytes + req_ctx->nbuf;
 	to_hash_later = nbytes_to_hash & (blocksize - 1);
 
-	if (req_ctx->last)
+	if (req_ctx->last_desc)
 		to_hash_later = 0;
 	else if (to_hash_later)
 		/* There is a partial block. Hash the full block(s) now */
@@ -2041,19 +2041,19 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	edesc->desc.hdr = ctx->desc_hdr_template;
 
 	/* On last one, request SEC to pad; otherwise continue */
-	if (req_ctx->last)
+	if (req_ctx->last_desc)
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
 	else
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
 
 	/* request SEC to INIT hash. */
-	if (req_ctx->first && !req_ctx->swinit)
+	if (req_ctx->first_desc && !req_ctx->swinit)
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
 
 	/* When the tfm context has a keylen, it's an HMAC.
 	 * A first or last (ie. not middle) descriptor must request HMAC.
 	 */
-	if (ctx->keylen && (req_ctx->first || req_ctx->last))
+	if (ctx->keylen && (req_ctx->first_desc || req_ctx->last_desc))
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
 	return common_nonsnoop_hash(edesc, req_ctx->areq, nbytes_to_hash, ahash_done);
@@ -2076,7 +2076,7 @@ static void sec1_ahash_process_remaining(struct work_struct *work)
 			req_ctx->remaining_ahash_request_bytes;
 
 		if (req_ctx->last_request)
-			req_ctx->last = 1;
+			req_ctx->last_desc = 1;
 	}
 
 	err = ahash_process_req_one(req_ctx->areq,
@@ -2103,7 +2103,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 		if (nbytes > TALITOS1_MAX_DATA_LEN)
 			nbytes = TALITOS1_MAX_DATA_LEN;
 		else if (req_ctx->last_request)
-			req_ctx->last = 1;
+			req_ctx->last_desc = 1;
 	}
 
 	req_ctx->current_ahash_request_bytes = nbytes;
@@ -2124,14 +2124,14 @@ static int ahash_init(struct ahash_request *areq)
 	/* Initialize the context */
 	req_ctx->buf_idx = 0;
 	req_ctx->nbuf = 0;
-	req_ctx->first = 1; /* first indicates h/w must init its context */
+	req_ctx->first_desc = 1; /* first_desc indicates h/w must init its context */
 	req_ctx->swinit = 0; /* assume h/w init of context */
 	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
 			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
 			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
 	req_ctx->hw_context_size = size;
 	req_ctx->last_request = 0;
-	req_ctx->last = 0;
+	req_ctx->last_desc = 0;
 	INIT_WORK(&req_ctx->sec1_ahash_process_remaining, sec1_ahash_process_remaining);
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
@@ -2224,8 +2224,8 @@ static int ahash_export(struct ahash_request *areq, void *out)
 	       req_ctx->hw_context_size);
 	memcpy(export->buf, req_ctx->buf[req_ctx->buf_idx], req_ctx->nbuf);
 	export->swinit = req_ctx->swinit;
-	export->first = req_ctx->first;
-	export->last = req_ctx->last;
+	export->first_desc = req_ctx->first_desc;
+	export->last_desc = req_ctx->last_desc;
 	export->to_hash_later = req_ctx->to_hash_later;
 	export->nbuf = req_ctx->nbuf;
 
@@ -2250,8 +2250,8 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 	memcpy(req_ctx->hw_context, export->hw_context, size);
 	memcpy(req_ctx->buf[0], export->buf, export->nbuf);
 	req_ctx->swinit = export->swinit;
-	req_ctx->first = export->first;
-	req_ctx->last = export->last;
+	req_ctx->first_desc = export->first_desc;
+	req_ctx->last_desc = export->last_desc;
 	req_ctx->to_hash_later = export->to_hash_later;
 	req_ctx->nbuf = export->nbuf;
 
-- 
2.54.0

