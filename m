Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B31C4649A
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 08:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A07F0218BC
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 08:39:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cr7SZLNj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfGEIjB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 04:39:01 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37191 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfGEIjB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 04:39:01 -0400
Received: by mail-ed1-f68.google.com with SMTP id w13so7546081eds.4
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jul 2019 01:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0wG0Qp0DymOFsW+hfNfz0YB5oNq3mQs/TYBemqc1SNE=;
        b=cr7SZLNjQkEIW7VK9CvdSCSgl9yttfJsBrx6OcHUYalczB80C1wUhL+5+T16T51Sfi
         ozrR2qwc4Zbx+9XGfdQxUsvIHyZ8rr4MN3w3eWPvJtZFOU5NOvBqL7u9xVllb+zqYTfT
         kTlvHiMGDmA0/VkmFnM/rsgQ3UnxFiCk1cP0whE+FRuj7y4PnjZzimglQ79oAFJp5uu+
         9NfcXUomOqKyfY+q6+4KilUfNJbrFY1rjRVRKWHee3awWq9hgjrv0mJlqkqIXwKFxA7r
         KElHdOXpXTjXFhhtQ3M7YH8R+op3ZTqjd6c7gNrYgfSBwSmJgZXFJRz3cStQua9eD9rU
         1ZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0wG0Qp0DymOFsW+hfNfz0YB5oNq3mQs/TYBemqc1SNE=;
        b=FlucLHE9Di5kD0gaOQG4pG0XqblyeFmifydnLQf7B0OHUHGjeaVT1JH9ILltFAmKX9
         DqPsr6PQ+wPWW4Y5Zfa5G71W7vUrOu4Xhh5WfUDNpW/czUI9jBJ2uRfRNRFIi+cC8eox
         RjPrWLVWDUExPJZriXdCne3BHC0gVCUuwtXqEiaSadb40n1X/uQhSc+awIZWCKNWKa9B
         LRCwZMBR/jHYugsFdfyLrPwLTlEShA1LtXGqc+8h/pypOK1mXWqiW+DsStSsUDwGfqFK
         TqNyenAzyDZDcl+PI0tyzSjKuSOXMJT0lQdPnPxpdKkBBk0o4pOvVswmdfAcly3ka6js
         2E6Q==
X-Gm-Message-State: APjAAAWQSX+3mfd53yuTTJ+5bXRnIOtpI2qOnBqyB1+Oc/CSOYavk0xX
        eyTAM/v67p+63niR4JZQk+4rYndy
X-Google-Smtp-Source: APXvYqxkqO0QUG68MK4MqWtHOPSptm81nukfn5w1h56BYkVN0Yu4m6pjJoxAyTupLoLdR1jfYM8EkA==
X-Received: by 2002:a17:906:505:: with SMTP id j5mr2303032eja.261.1562315938358;
        Fri, 05 Jul 2019 01:38:58 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id r44sm2457525edd.20.2019.07.05.01.38.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 01:38:57 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure -reduce hash byte counters to 64 bits
Date:   Fri,  5 Jul 2019 09:36:31 +0200
Message-Id: <1562312191-8202-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch recognises the fact that the hardware cannot ever process more
than 2,199,023,386,111 bytes of hash or HMAC payload, so there is no point
in maintaining 128 bit wide byte counters, 64 bits is more than sufficient

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.h      |  4 +-
 drivers/crypto/inside-secure/safexcel_hash.c | 88 +++++++++++-----------------
 2 files changed, 36 insertions(+), 56 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 36657c3..379d0b0 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -643,8 +643,8 @@ struct safexcel_context {
 #define HASH_CACHE_SIZE			SHA512_BLOCK_SIZE
 
 struct safexcel_ahash_export_state {
-	u64 len[2];
-	u64 processed[2];
+	u64 len;
+	u64 processed;
 
 	u32 digest;
 
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index bdbaea9..626dd82 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -41,8 +41,8 @@ struct safexcel_ahash_req {
 	u8 block_sz;    /* block size, only set once */
 	u32 state[SHA512_DIGEST_SIZE / sizeof(u32)] __aligned(sizeof(u32));
 
-	u64 len[2];
-	u64 processed[2];
+	u64 len;
+	u64 processed;
 
 	u8 cache[HASH_CACHE_SIZE] __aligned(sizeof(u32));
 	dma_addr_t cache_dma;
@@ -53,12 +53,7 @@ struct safexcel_ahash_req {
 
 static inline u64 safexcel_queued_len(struct safexcel_ahash_req *req)
 {
-	u64 len, processed;
-
-	len = (0xffffffff * req->len[1]) + req->len[0];
-	processed = (0xffffffff * req->processed[1]) + req->processed[0];
-
-	return len - processed;
+	return req->len - req->processed;
 }
 
 static void safexcel_hash_token(struct safexcel_command_desc *cdesc,
@@ -94,7 +89,7 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 	 * fields. Do this now as we need it to setup the first command
 	 * descriptor.
 	 */
-	if ((!req->processed[0]) && (!req->processed[1])) {
+	if (!req->processed) {
 		/* First - and possibly only - block of basic hash only */
 		if (req->finish) {
 			cdesc->control_data.control0 |=
@@ -119,11 +114,8 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 	if (req->finish) {
 		/* Compute digest count for hash/HMAC finish operations */
 		if ((req->digest == CONTEXT_CONTROL_DIGEST_PRECOMPUTED) ||
-		    req->hmac_zlen || req->processed[1] ||
-		    (req->processed[0] != req->block_sz)) {
-			count = req->processed[0] / EIP197_COUNTER_BLOCK_SIZE;
-			count += ((0x100000000ULL / EIP197_COUNTER_BLOCK_SIZE) *
-				  req->processed[1]);
+		    req->hmac_zlen || (req->processed != req->block_sz)) {
+			count = req->processed / EIP197_COUNTER_BLOCK_SIZE;
 
 			/* This is a hardware limitation, as the
 			 * counter must fit into an u32. This represents
@@ -141,8 +133,7 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 		    /* Special case: zero length HMAC */
 		    req->hmac_zlen ||
 		    /* PE HW < 4.4 cannot do HMAC continue, fake using hash */
-		    ((req->processed[1] ||
-		      (req->processed[0] != req->block_sz)))) {
+		    (req->processed != req->block_sz)) {
 			/* Basic hash continue operation, need digest + cnt */
 			cdesc->control_data.control0 |=
 				CONTEXT_CONTROL_SIZE((req->state_sz >> 2) + 1) |
@@ -234,11 +225,9 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
 
 			memcpy(sreq->state, ctx->opad, sreq->state_sz);
 
-			sreq->len[0] = sreq->block_sz +
-				       crypto_ahash_digestsize(ahash);
-			sreq->len[1] = 0;
-			sreq->processed[0] = sreq->block_sz;
-			sreq->processed[1] = 0;
+			sreq->len = sreq->block_sz +
+				    crypto_ahash_digestsize(ahash);
+			sreq->processed = sreq->block_sz;
 			sreq->hmac = 0;
 
 			ctx->base.needs_inv = true;
@@ -393,9 +382,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 
 	safexcel_rdr_req_set(priv, ring, rdesc, &areq->base);
 
-	req->processed[0] += len;
-	if (req->processed[0] < len)
-		req->processed[1]++;
+	req->processed += len;
 
 	*commands = n_cdesc;
 	*results = 1;
@@ -603,15 +590,14 @@ static int safexcel_ahash_enqueue(struct ahash_request *areq)
 
 	if (ctx->base.ctxr) {
 		if (priv->flags & EIP197_TRC_CACHE && !ctx->base.needs_inv &&
-		    (req->processed[0] || req->processed[1]) &&
+		    req->processed &&
 		    (/* invalidate for basic hash continuation finish */
 		     (req->finish &&
 		      (req->digest == CONTEXT_CONTROL_DIGEST_PRECOMPUTED)) ||
 		     /* invalidate if (i)digest changed */
 		     memcmp(ctx->base.ctxr->data, req->state, req->state_sz) ||
 		     /* invalidate for HMAC continuation finish */
-		     (req->finish && (req->processed[1] ||
-		      (req->processed[0] != req->block_sz))) ||
+		     (req->finish && (req->processed != req->block_sz)) ||
 		     /* invalidate for HMAC finish with odigest changed */
 		     (req->finish &&
 		      memcmp(ctx->base.ctxr->data + (req->state_sz>>2),
@@ -662,9 +648,7 @@ static int safexcel_ahash_update(struct ahash_request *areq)
 	ret = safexcel_ahash_cache(areq);
 
 	/* Update total request length */
-	req->len[0] += areq->nbytes;
-	if (req->len[0] < areq->nbytes)
-		req->len[1]++;
+	req->len += areq->nbytes;
 
 	/* If not all data could fit into the cache, go process the excess.
 	 * Also go process immediately for an HMAC IV precompute, which
@@ -683,7 +667,7 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 
 	req->finish = true;
 
-	if (unlikely(!req->len[0] && !req->len[1] && !areq->nbytes)) {
+	if (unlikely(!req->len && !areq->nbytes)) {
 		/*
 		 * If we have an overall 0 length *hash* request:
 		 * The HW cannot do 0 length hash, so we provide the correct
@@ -709,8 +693,8 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 			       SHA512_DIGEST_SIZE);
 
 		return 0;
-	} else if (unlikely(req->hmac && !req->len[1] &&
-			    (req->len[0] == req->block_sz) &&
+	} else if (unlikely(req->hmac &&
+			    (req->len == req->block_sz) &&
 			    !areq->nbytes)) {
 		/*
 		 * If we have an overall 0 length *HMAC* request:
@@ -736,7 +720,7 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 						      255;
 		}
 
-		req->len[0] += req->block_sz; /* plus 1 hash block */
+		req->len += req->block_sz; /* plus 1 hash block */
 
 		/* Set special zero-length HMAC flag */
 		req->hmac_zlen = true;
@@ -766,10 +750,8 @@ static int safexcel_ahash_export(struct ahash_request *areq, void *out)
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 	struct safexcel_ahash_export_state *export = out;
 
-	export->len[0] = req->len[0];
-	export->len[1] = req->len[1];
-	export->processed[0] = req->processed[0];
-	export->processed[1] = req->processed[1];
+	export->len = req->len;
+	export->processed = req->processed;
 
 	export->digest = req->digest;
 
@@ -789,10 +771,8 @@ static int safexcel_ahash_import(struct ahash_request *areq, const void *in)
 	if (ret)
 		return ret;
 
-	req->len[0] = export->len[0];
-	req->len[1] = export->len[1];
-	req->processed[0] = export->processed[0];
-	req->processed[1] = export->processed[1];
+	req->len = export->len;
+	req->processed = export->processed;
 
 	req->digest = export->digest;
 
@@ -902,8 +882,8 @@ static int safexcel_hmac_sha1_init(struct ahash_request *areq)
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SHA1_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
-	req->len[0]	  = SHA1_BLOCK_SIZE;
-	req->processed[0] = SHA1_BLOCK_SIZE;
+	req->len	= SHA1_BLOCK_SIZE;
+	req->processed	= SHA1_BLOCK_SIZE;
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA1;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1258,8 +1238,8 @@ static int safexcel_hmac_sha224_init(struct ahash_request *areq)
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SHA256_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
-	req->len[0]	  = SHA256_BLOCK_SIZE;
-	req->processed[0] = SHA256_BLOCK_SIZE;
+	req->len	= SHA256_BLOCK_SIZE;
+	req->processed	= SHA256_BLOCK_SIZE;
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA224;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1327,8 +1307,8 @@ static int safexcel_hmac_sha256_init(struct ahash_request *areq)
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SHA256_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
-	req->len[0]	  = SHA256_BLOCK_SIZE;
-	req->processed[0] = SHA256_BLOCK_SIZE;
+	req->len	= SHA256_BLOCK_SIZE;
+	req->processed	= SHA256_BLOCK_SIZE;
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA256;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1504,8 +1484,8 @@ static int safexcel_hmac_sha512_init(struct ahash_request *areq)
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SHA512_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
-	req->len[0]	  = SHA512_BLOCK_SIZE;
-	req->processed[0] = SHA512_BLOCK_SIZE;
+	req->len	= SHA512_BLOCK_SIZE;
+	req->processed	= SHA512_BLOCK_SIZE;
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA512;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1573,8 +1553,8 @@ static int safexcel_hmac_sha384_init(struct ahash_request *areq)
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SHA512_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
-	req->len[0]	  = SHA512_BLOCK_SIZE;
-	req->processed[0] = SHA512_BLOCK_SIZE;
+	req->len	= SHA512_BLOCK_SIZE;
+	req->processed	= SHA512_BLOCK_SIZE;
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA384;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1689,8 +1669,8 @@ static int safexcel_hmac_md5_init(struct ahash_request *areq)
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, MD5_DIGEST_SIZE);
 	/* Already processed the key^ipad part now! */
-	req->len[0]	  = MD5_HMAC_BLOCK_SIZE;
-	req->processed[0] = MD5_HMAC_BLOCK_SIZE;
+	req->len	= MD5_HMAC_BLOCK_SIZE;
+	req->processed	= MD5_HMAC_BLOCK_SIZE;
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_MD5;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
-- 
1.8.3.1

