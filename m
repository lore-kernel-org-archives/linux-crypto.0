Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668342C3757
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779549114; cv=none; b=hn5z8fRM2klrw/2ZE9XU2/BuKCwxuMza9BhU0WQwbogzdceY8s/FcqC8L6jgG57d0r3NoMDCyl1A4IdzqzbXCnbOMNm3pOCN+xJrqKSG1aJsZQJsEkLyeiu1xl8C70IcjVEbRuRjQAmhTN2iF0i6vLyrCrje5MA+QY5vD6Uvzl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779549114; c=relaxed/simple;
	bh=hGWlZAdSKJyrO4vnRYHgI0oT7ZubZ5JXgla6IQEgQvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nE8N1tEzpOCHI5Kxdg3Cn8miOT1B6l6qNmMpcyW3n8U3lYKNdd//pbDnd4ymm5MUOlvKudadprOz+J2nm/SmycvgGxDeHrXTC8l2HE8AFfGejfCisgW+asRsBcfpqsZCf8SG+ZQk+/1BIOeoJLtAghOJCM8U6nTptQgTIv+rr2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GAm6LvM1; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GAm6LvM1"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-44e5624c053so5015020f8f.2
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 08:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779549111; x=1780153911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHCpxEue7VXEZ9tnLbMHa9jIi5zBsJ5AQM9y2uBm52M=;
        b=GAm6LvM1UkA8A/aE5kLdkBwlTwMiGw49hMtuwBZdWwwr3Eoq8Uik8at5SQ3CJOOMaf
         mAh0lGqR7P+27rH9ToAXCt1hjL1smpqYwgpUYQI8JiaGHmCJM7Z1sE50u2lERPtsFva1
         810KePWYkwltEj5Z8QUmnCNEKm7mAx7oQaL07fMVpKJjSp9IRJNay0A/u1WVc877ImdJ
         wk5OkkrAi5tyVFhsCF1rKOwQLyTsHy/EcB08jo485bBkP48/uoHtK4eNAIbdVlcFVWnQ
         LJLxAJkWCPNboWqsZu3Od35pZ6XyzKiuo8SH4q8hXBv5fQ+GdlNdA1jYNm+Htl1s6AdM
         vTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779549111; x=1780153911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gHCpxEue7VXEZ9tnLbMHa9jIi5zBsJ5AQM9y2uBm52M=;
        b=Ga5AsUNcOOymH1RGSCMwo+NoZyO47swkStut35gtJ46JlsCf5t/sGIjhlF0oaalcEH
         N8z9Kq+Z8o8Tb+BSfCMfMto+JG4xETpABWE0AfVfw3Qg5ShpGfj5VnKBy8Iz9NFeURIL
         8XmAEIhKxopxc6MqiMvIMiUPf1BrW3yWseCnjwV8ii9iifSiXHWB7Y8M/arV9C7jTazn
         8FinfVDjJLCEkqzXCWvKAFyJlNXdcg9xZcTgLbwz9gj1AR4O07PPQj1Bgl1NQaSC/OlJ
         qW/KXFip2k1r79Jr+5Ifm1KsdDqDCzTQ8E9bzqdzkQlUbYR9gaRgYltWwxZ6MI4gIgXt
         gHFg==
X-Forwarded-Encrypted: i=1; AFNElJ/YuCjFKZKQoC4wGkpZQ3qD2aabEvayxY2xNigUXJND66IrcHahv4Ggk3jzeTGMq2jwnd8iJ2JKYZBN95k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcvkAvQ+M7hTIj2Mpm5EkK5ML0l7lE5h4WDEdr69DQ/rwNjWqU
	ocu5BfEvnOJL8PG3wb9HLm0T8oZDhxRcJM4g9QfVPBi8MOpG8kPI6BBP
X-Gm-Gg: Acq92OEgZSpP2/JOrnYu/JbOe+IM+r46ck0yMGv2y/wyglzecmCl2DDcoE0O2US1BQu
	7zh2yCSLgdhgqpKBaF/iTQB4u23m/+TMHTjQ6Vx9tTgieqiXa6+GuxVyLE3BN+ibEHlqCHExJ2y
	nkbq/C52wcXnMvIf3R8qUnX89DfFTEKLE7LsQKHa1AD0BrGUxUjEwF0o1bOouzbIc/1zDUr9NMD
	0/ttzy4wZu8YwQiSMmLu8STBvSb16JNLcOOfQaGyH02QwpdkAXpFXuu7zNgdBajRU9PHTlrMM30
	r3Ebmlfjse0sxKiYh6WnNd7aJlZFtRbkXqnM7FWTq2fLYtvHaLkc36RGnhJ7NLu8XR9oBItZPTp
	6Y6PKOpnh4igsuAjG7T5Oo/seYLjfGbHX7OziWnDNoHsKtSx2GJaDHsQdueBlE52LYKtdhydEpc
	OpsbL6Y0B0P9S7V30jFsEiK7xUfJoynDjP
X-Received: by 2002:a05:6000:4605:b0:43d:7bc9:9b2c with SMTP id ffacd0b85a97d-45eb3687941mr13035816f8f.17.1779549110601;
        Sat, 23 May 2026 08:11:50 -0700 (PDT)
Received: from mini.main.internal ([2a02:908:c211:cd18:36:c98d:902c:348d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d7167dsm12629156f8f.35.2026.05.23.08.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 08:11:49 -0700 (PDT)
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
Subject: [PATCH 1/5] Revert "crypto: talitos - rename first/last to first_desc/last_desc"
Date: Sat, 23 May 2026 17:10:44 +0200
Message-ID: <20260523151048.14914-2-ggoerisch@gmail.com>
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

This reverts commit a866e2b1c65edaee2e1bb1024ee2c761ced335f8.
---
 drivers/crypto/talitos.c | 46 ++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 347483f6fc5d..f78a44f99101 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -869,8 +869,8 @@ struct talitos_ahash_req_ctx {
 	u8 buf[2][HASH_MAX_BLOCK_SIZE];
 	int buf_idx;
 	unsigned int swinit;
-	unsigned int first_desc;
-	unsigned int last_desc;
+	unsigned int first;
+	unsigned int last;
 	unsigned int last_request;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
@@ -889,8 +889,8 @@ struct talitos_export_state {
 	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
 	u8 buf[HASH_MAX_BLOCK_SIZE];
 	unsigned int swinit;
-	unsigned int first_desc;
-	unsigned int last_desc;
+	unsigned int first;
+	unsigned int last;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
 };
@@ -1722,7 +1722,7 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	if (desc->next_desc &&
 	    desc->ptr[5].ptr != desc2->ptr[5].ptr)
 		unmap_single_talitos_ptr(dev, &desc2->ptr[5], DMA_FROM_DEVICE);
-	if (req_ctx->last_desc)
+	if (req_ctx->last)
 		memcpy(areq->result, req_ctx->hw_context,
 		       crypto_ahash_digestsize(tfm));
 
@@ -1759,7 +1759,7 @@ static void ahash_done(struct device *dev,
 		 container_of(desc, struct talitos_edesc, desc);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	if (!req_ctx->last_desc && req_ctx->to_hash_later) {
+	if (!req_ctx->last && req_ctx->to_hash_later) {
 		/* Position any partial block for next update/final/finup */
 		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
 		req_ctx->nbuf = req_ctx->to_hash_later;
@@ -1825,7 +1825,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* first DWORD empty */
 
 	/* hash context in */
-	if (!req_ctx->first_desc || req_ctx->swinit) {
+	if (!req_ctx->first || req_ctx->swinit) {
 		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
@@ -1833,7 +1833,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		req_ctx->swinit = 0;
 	}
 	/* Indicate next op is not the first. */
-	req_ctx->first_desc = 0;
+	req_ctx->first = 0;
 
 	/* HMAC key */
 	if (ctx->keylen)
@@ -1866,7 +1866,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* fifth DWORD empty */
 
 	/* hash/HMAC out -or- hash context out */
-	if (req_ctx->last_desc)
+	if (req_ctx->last)
 		map_single_talitos_ptr(dev, &desc->ptr[5],
 				       crypto_ahash_digestsize(tfm),
 				       req_ctx->hw_context, DMA_FROM_DEVICE);
@@ -1908,7 +1908,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		if (sg_count > 1)
 			sync_needed = true;
 		copy_talitos_ptr(&desc2->ptr[5], &desc->ptr[5], is_sec1);
-		if (req_ctx->last_desc)
+		if (req_ctx->last)
 			map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
 						      req_ctx->hw_context_size,
 						      req_ctx->hw_context,
@@ -1964,7 +1964,7 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	bool is_sec1 = has_ftr_sec1(priv);
 	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
 
-	if (!req_ctx->last_desc && (nbytes + req_ctx->nbuf <= blocksize)) {
+	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
 		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
 		if (nents < 0) {
@@ -1981,7 +1981,7 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	nbytes_to_hash = nbytes + req_ctx->nbuf;
 	to_hash_later = nbytes_to_hash & (blocksize - 1);
 
-	if (req_ctx->last_desc)
+	if (req_ctx->last)
 		to_hash_later = 0;
 	else if (to_hash_later)
 		/* There is a partial block. Hash the full block(s) now */
@@ -2041,19 +2041,19 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	edesc->desc.hdr = ctx->desc_hdr_template;
 
 	/* On last one, request SEC to pad; otherwise continue */
-	if (req_ctx->last_desc)
+	if (req_ctx->last)
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
 	else
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
 
 	/* request SEC to INIT hash. */
-	if (req_ctx->first_desc && !req_ctx->swinit)
+	if (req_ctx->first && !req_ctx->swinit)
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
 
 	/* When the tfm context has a keylen, it's an HMAC.
 	 * A first or last (ie. not middle) descriptor must request HMAC.
 	 */
-	if (ctx->keylen && (req_ctx->first_desc || req_ctx->last_desc))
+	if (ctx->keylen && (req_ctx->first || req_ctx->last))
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
 	return common_nonsnoop_hash(edesc, req_ctx->areq, nbytes_to_hash, ahash_done);
@@ -2076,7 +2076,7 @@ static void sec1_ahash_process_remaining(struct work_struct *work)
 			req_ctx->remaining_ahash_request_bytes;
 
 		if (req_ctx->last_request)
-			req_ctx->last_desc = 1;
+			req_ctx->last = 1;
 	}
 
 	err = ahash_process_req_one(req_ctx->areq,
@@ -2103,7 +2103,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 		if (nbytes > TALITOS1_MAX_DATA_LEN)
 			nbytes = TALITOS1_MAX_DATA_LEN;
 		else if (req_ctx->last_request)
-			req_ctx->last_desc = 1;
+			req_ctx->last = 1;
 	}
 
 	req_ctx->current_ahash_request_bytes = nbytes;
@@ -2124,14 +2124,14 @@ static int ahash_init(struct ahash_request *areq)
 	/* Initialize the context */
 	req_ctx->buf_idx = 0;
 	req_ctx->nbuf = 0;
-	req_ctx->first_desc = 1; /* first_desc indicates h/w must init its context */
+	req_ctx->first = 1; /* first indicates h/w must init its context */
 	req_ctx->swinit = 0; /* assume h/w init of context */
 	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
 			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
 			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
 	req_ctx->hw_context_size = size;
 	req_ctx->last_request = 0;
-	req_ctx->last_desc = 0;
+	req_ctx->last = 0;
 	INIT_WORK(&req_ctx->sec1_ahash_process_remaining, sec1_ahash_process_remaining);
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
@@ -2223,8 +2223,8 @@ static int ahash_export(struct ahash_request *areq, void *out)
 	       req_ctx->hw_context_size);
 	memcpy(export->buf, req_ctx->buf[req_ctx->buf_idx], req_ctx->nbuf);
 	export->swinit = req_ctx->swinit;
-	export->first_desc = req_ctx->first_desc;
-	export->last_desc = req_ctx->last_desc;
+	export->first = req_ctx->first;
+	export->last = req_ctx->last;
 	export->to_hash_later = req_ctx->to_hash_later;
 	export->nbuf = req_ctx->nbuf;
 
@@ -2249,8 +2249,8 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 	memcpy(req_ctx->hw_context, export->hw_context, size);
 	memcpy(req_ctx->buf[0], export->buf, export->nbuf);
 	req_ctx->swinit = export->swinit;
-	req_ctx->first_desc = export->first_desc;
-	req_ctx->last_desc = export->last_desc;
+	req_ctx->first = export->first;
+	req_ctx->last = export->last;
 	req_ctx->to_hash_later = export->to_hash_later;
 	req_ctx->nbuf = export->nbuf;
 
-- 
2.54.0

