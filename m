Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482DD3C1F46
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 19:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783626064; cv=none; b=H+6kOqKgR7nuZI/yKQIb36rtUmAXD2YUVt6w/fNGCU7PWjcEtNyzNP5GgAWOHjxwSzvmuQQyBfZq0vZWu3kH/NmGi0lAijgMEt01i+2EnHdruwG0DlCpSxNAd+PsI2kskAhjwC/PJQl+nEROKbO0OThxvoYlZkJj62k4WSaZmPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783626064; c=relaxed/simple;
	bh=Tn8iQJ9CsVUfhrZiseQzEf1voZTbnVyefAonuptvolQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RREL4KM5sjknstYfA7jOoeONQRSigmIcVdkQcMlpGqnhV+IMKamkxecyBlt4Ux64or3jqoZERnvnR0iWMiK92wNRY4+aPpviS4j9NfoRTruHf0j4sr1n69rc6N/YvX7CJ6rxHNcVndejdlOLx3gjQgDOBNB2rbe9r/7L/0JapSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H3OzUJ0K; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H3OzUJ0K"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493bf73ec2aso1055405e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 12:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783626061; x=1784230861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5KIY3oc9mKAdT5MTP8DhBnrr4oaktG5EnhFMqSWWNRc=;
        b=H3OzUJ0KnqgSO3YwUAhYe0+hGdOgU14D9EK3frVzu0QJsYsdaCFraurdAy5gJNSbEV
         VD0Q4y8A/gxujN2QCjbQNNSZ79sykbuJSQuHsgm2G3q46i101iMvccEgraA9aAJ0zX5S
         QTDWMnrAfSBPPJihLG07w3ttc4ZWlaqNvQQuvtAaMcCKdEpc0TS6jsnhb+tR4/1f9NEL
         6SgIJ8Up7q4lTxmS4NhOggif6XziKHnHIa6CEjUjEbO93AivGRKTo4vmt3gQkrKxzoDs
         pWbsKT+C5lIM7ui29mb+x3P6yvjJSsjU/9/+p9WJMRRMRTWYZWcVxj9PIs8CNC846h0C
         3QZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783626061; x=1784230861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5KIY3oc9mKAdT5MTP8DhBnrr4oaktG5EnhFMqSWWNRc=;
        b=NTYZLIuladxoF9by5LpAzywpGaqpCitmqJ2rp10XvmadEfYnLuc/K6jwaMRey8c9SK
         QCW9M91KZsZcjN2HhKsSNboEh7w4bFBCKs/fm/L+Nzp9pndpZAfYsGSlNeujlNcEu89V
         cdYb4T5nio4ycEYQWUSBUlmpjhsrxJ4fAbmMJrz+iOOfieruS95+n4N1XbAoZtWbInDp
         1bNdL3Hfh7NnvPDBOWs4V7uqQ+nhg6f/xBS7tOYRqYOzG8Wn6lwEeQdaNKaHB+7MAXpw
         YtNtdu3RoawUMFo0Czapvm6fbK24TkY/30D6EnR0BlnoMX2bdmhY2Lhb8oNS7dtFqPTj
         sssg==
X-Forwarded-Encrypted: i=1; AHgh+RqpOoiho4YwB+orhaS+2Gvt09X2RHIJkz7Dl47oE4yMg04kPRqqVwejLy6mZ50T2OUGUGKMSpUVIjXN318=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0TO37UQMroJ+3syhMGBoEUHf1MCWLYFvjytWxVW6kvx+RlAH+
	RN0Z+0VAOE2wh1nWqtP8aBq6YGs1Yifo2r4fhiFU+J8FyvsknwIrobJf
X-Gm-Gg: AfdE7cny7MaDr07D3qWW+kO1vx7/NkdCCIEeeG7XhiaCkvJCrQtPtgIZBO0XH4RFpLC
	J8s+e+9GAMNSTgCvoby2n4hDJAkE1SZ/6WCk64IHAABby3ulhVZzjZKogjozUc2DadNMqOI7eac
	Ibt4bcplUECUPjtcC2q9YL3Wb4An4N0gCUGLpEIxaArtQ7vS0lXbFWt/FK7ZSzi99aBGw+YjVn0
	GCUTPAkvUYU+SMao/w1ydSnUWclBPMA32URjLg9s3h5IhFHxBtb+e5+5hekFtf9VHESwr5iLH5c
	Tzc218xWG67zjUNbgF6PjMz+3sRQlJLOMrJmxM1u05ne3PX7LJF+NE23pXlZZ1ObVRrTb84Dn6N
	kXyLau+hrx+R4mvqqL7gpL/7J/oxanmmyOAxe79jFhC0Cx1cCTkd+zsch15YZVPPfwylKlRWGc7
	ORGI9/S1Zp/hHYNmSif582PuHG
X-Received: by 2002:a05:600c:8b86:b0:493:c548:87fb with SMTP id 5b1f17b1804b1-493e68d6862mr90766245e9.36.1783626060604;
        Thu, 09 Jul 2026 12:41:00 -0700 (PDT)
Received: from mini.main.internal ([2a02:908:c211:cd18:d9f3:ab2b:ac6e:fc84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0a558easm53986441f8f.27.2026.07.09.12.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 12:40:59 -0700 (PDT)
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
Date: Thu,  9 Jul 2026 21:39:56 +0200
Message-ID: <20260709193956.15619-6-ggoerisch@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709193956.15619-1-ggoerisch@gmail.com>
References: <2026070912-pluck-bagful-2a71@gregkh>
 <20260709193956.15619-1-ggoerisch@gmail.com>
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
2.55.0

