Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF589C43461
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 09:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002FD21473
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 09:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgIGJeL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 05:34:11 -0400
Received: from e2i568.smtp2go.com ([103.2.142.56]:47597 "EHLO
        e2i568.smtp2go.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgIGJeJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 05:34:09 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2020 05:34:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=smtpservice.net; s=mcg8n0.a1-4.dyn; x=1599472147; h=Feedback-ID:
        X-Smtpcorp-Track:Message-Id:Date:Subject:To:From:Reply-To:Sender:
        List-Unsubscribe; bh=+5heHyxIfhjxQ4UjlBR39E6AkAk+G/JJE8R5++J2aQ4=; b=vCq7uwgo
        DznjCq+YwdQRWQ0vXBf6g5bQ8SGBMas/WBxvEOOOXlJ3ptGIfLyJmTYW+PPQTa0PhpPjyxAAjyoDR
        XohsoFUOfNCCOKkC0pWEaS8YEKt1w+aq9x9kreZELlUbHmQvKUWGf/LD2ObOPO9IF+KJcqPRS+dye
        TD7m8TgQ4ckeGVxwEZw/VMxabsxGKwpSEap7KkOamjTBjvcWOA7BIDpzebG2CUBV91iMOpCHrAUp4
        nVduDFbDf0UqxjSkxET6XSRyWNE9OSk8pvxRs3zalf7SYwfRHAMiBiA2y40svESm4yKh69MJNhfnu
        j+W609AwcThIjgbQLfnwi7yiqg==;
Received: from [10.45.79.71] (helo=SmtpCorp)
        by smtpcorp.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-S2G)
        (envelope-from <pvanleeuwen@rambus.com>)
        id 1kFDOD-qt4JZn-TS; Mon, 07 Sep 2020 09:24:42 +0000
Received: from [10.159.100.118] (helo=localhost.localdomain.com)
        by smtpcorp.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-S2G)
        (envelope-from <pvanleeuwen@rambus.com>)
        id 1kFDOC-Duuhs5-1G; Mon, 07 Sep 2020 09:24:40 +0000
From:   Pascal van Leeuwen <pvanleeuwen@rambus.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, Pascal van Leeuwen <pvanleeuwen@rambus.com>
Subject: [PATCH] crypto: inside-secure - Fix corruption on not fully coherent systems
Date:   Mon,  7 Sep 2020 10:19:44 +0200
Message-Id: <1599466784-23596-1-git-send-email-pvanleeuwen@rambus.com>
X-Mailer: git-send-email 1.8.3.1
X-Smtpcorp-Track: 1kFDOCDIIhs51G.VlxZPy89M
Feedback-ID: 580919m:580919aJ_Wy3x:580919siq9SVmyag
X-Report-Abuse: Please forward a copy of this message, including all headers, to <abuse-report@smtp2go.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A customer of ours (Rambus) reported corruption issues running the driver
on their SoC platform, which turned out to be not fully coherent.
This caused problems with the DMA mapping of the state and cache buffers
stored inside the safexcel_ahash_req struct, as these buffers would not
start and/or end on a cacheline boundary, hence they could share a cache
line with the CPU. Which could cause the CPU to read stale data from the
cache (loaded from memory *before* the accelerator updated it).

Fixed by determining the system cacheline size and dynamically moving
these 2 buffers to a cacheline aligned boundary. Also ensuring that the
last cacheline of the last buffer is not shared (by overallocating).

This was tested by the customer to solve their coherence problems. It
was also tested by me on a VCU118 board w/ EIP-197c and Macchiatobin.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@rambus.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 97 +++++++++++++++++++---------
 1 file changed, 65 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 16a4679..e350f39 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -22,6 +22,8 @@ struct safexcel_ahash_ctx {
 	struct safexcel_context base;
 	struct safexcel_crypto_priv *priv;
 
+	int extra_req_bytes;
+	int req_align;
 	u32 alg;
 	u8  key_sz;
 	bool cbcmac;
@@ -56,17 +58,19 @@ struct safexcel_ahash_req {
 	u8 state_sz;    /* expected state size, only set once */
 	u8 block_sz;    /* block size, only set once */
 	u8 digest_sz;   /* output digest size, only set once */
-	__le32 state[SHA3_512_BLOCK_SIZE /
-		     sizeof(__le32)] __aligned(sizeof(__le32));
+	__le32 *state;  /* pointer to DMA safe state buffer  */
 
 	u64 len;
 	u64 processed;
 
-	u8 cache[HASH_CACHE_SIZE] __aligned(sizeof(u32));
+	u8 *cache; /* pointer to DMA safe cache buffer */
 	dma_addr_t cache_dma;
 	unsigned int cache_sz;
 
 	u8 cache_next[HASH_CACHE_SIZE] __aligned(sizeof(u32));
+
+	/* this is where the DMA buffers for state & cache end up */
+	u8 dma_buf_area[];
 };
 
 static inline u64 safexcel_queued_len(struct safexcel_ahash_req *req)
@@ -613,7 +617,6 @@ static int safexcel_ahash_send(struct crypto_async_request *async,
 		ret = safexcel_ahash_send_inv(async, ring, commands, results);
 	else
 		ret = safexcel_ahash_send_req(async, ring, commands, results);
-
 	return ret;
 }
 
@@ -889,6 +892,25 @@ static int safexcel_ahash_export(struct ahash_request *areq, void *out)
 	return 0;
 }
 
+static void safexcel_hash_req_init(struct safexcel_ahash_req *req,
+				   int req_align)
+{
+	memset(req, 0, sizeof(*req));
+
+	/*
+	 * put cache buffer at first cacheline aligned address at end of
+	 * struct safexcel_ahash_req
+	 */
+	req->cache = (u8 *)__ALIGN_MASK((uintptr_t)req->dma_buf_area,
+					(uintptr_t)req_align);
+	/*
+	 * put state buffer at first cacheline aligned address behind
+	 * the cache buffer
+	 */
+	req->state = (__le32 *)__ALIGN_MASK((uintptr_t)req->cache +
+					    HASH_CACHE_SIZE, (uintptr_t)req_align);
+}
+
 static int safexcel_ahash_import(struct ahash_request *areq, const void *in)
 {
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
@@ -921,9 +943,20 @@ static int safexcel_ahash_cra_init(struct crypto_tfm *tfm)
 	ctx->base.send = safexcel_ahash_send;
 	ctx->base.handle_result = safexcel_handle_result;
 	ctx->fb_do_setkey = false;
+	ctx->req_align = cache_line_size() - 1;
+
+	/*
+	 * compute how many bytes we need, worst case, to store cache
+	 * aligned buffers for cache and state, padding to the next
+	 * cacheline as well to avoid anything else ending up there
+	 */
+	ctx->extra_req_bytes = ctx->req_align; /* worst case to next line */
+	ctx->extra_req_bytes += __ALIGN_MASK(SHA3_512_BLOCK_SIZE, ctx->req_align);
+	ctx->extra_req_bytes += __ALIGN_MASK(HASH_CACHE_SIZE, ctx->req_align);
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct safexcel_ahash_req));
+				 sizeof(struct safexcel_ahash_req) +
+				 ctx->extra_req_bytes);
 	return 0;
 }
 
@@ -932,7 +965,7 @@ static int safexcel_sha1_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA1;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1009,7 +1042,7 @@ static int safexcel_hmac_sha1_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SHA1_DIGEST_SIZE);
@@ -1106,7 +1139,7 @@ static int safexcel_hmac_init_iv(struct ahash_request *areq,
 				 unsigned int blocksize, u8 *pad, void *state)
 {
 	struct safexcel_ahash_result result;
-	struct safexcel_ahash_req *req;
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 	struct scatterlist sg;
 	int ret;
 
@@ -1120,7 +1153,6 @@ static int safexcel_hmac_init_iv(struct ahash_request *areq,
 	if (ret)
 		return ret;
 
-	req = ahash_request_ctx(areq);
 	req->hmac = true;
 	req->last_req = true;
 
@@ -1253,7 +1285,7 @@ static int safexcel_sha256_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA256;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1310,7 +1342,7 @@ static int safexcel_sha224_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA224;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1374,7 +1406,7 @@ static int safexcel_hmac_sha224_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SHA256_DIGEST_SIZE);
@@ -1446,7 +1478,7 @@ static int safexcel_hmac_sha256_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SHA256_DIGEST_SIZE);
@@ -1511,7 +1543,7 @@ static int safexcel_sha512_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA512;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1568,7 +1600,7 @@ static int safexcel_sha384_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA384;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1632,7 +1664,7 @@ static int safexcel_hmac_sha512_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SHA512_DIGEST_SIZE);
@@ -1704,7 +1736,7 @@ static int safexcel_hmac_sha384_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SHA512_DIGEST_SIZE);
@@ -1769,7 +1801,7 @@ static int safexcel_md5_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_MD5;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -1826,7 +1858,7 @@ static int safexcel_hmac_md5_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, MD5_DIGEST_SIZE);
@@ -1909,7 +1941,7 @@ static int safexcel_crc32_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Start from loaded key */
 	req->state[0]	= (__force __le32)le32_to_cpu(~ctx->ipad[0]);
@@ -1981,7 +2013,7 @@ static int safexcel_cbcmac_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Start from loaded keys */
 	memcpy(req->state, ctx->ipad, ctx->key_sz);
@@ -2264,7 +2296,7 @@ static int safexcel_sm3_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SM3;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
@@ -2328,7 +2360,7 @@ static int safexcel_hmac_sm3_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Start from ipad precompute */
 	memcpy(req->state, ctx->ipad, SM3_DIGEST_SIZE);
@@ -2394,7 +2426,7 @@ static int safexcel_sha3_224_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA3_224;
 	req->digest = CONTEXT_CONTROL_DIGEST_INITIAL;
@@ -2536,7 +2568,8 @@ static int safexcel_sha3_cra_init(struct crypto_tfm *tfm)
 	/* Update statesize from fallback algorithm! */
 	crypto_hash_alg_common(ahash)->statesize =
 		crypto_ahash_statesize(ctx->fback);
-	crypto_ahash_set_reqsize(ahash, max(sizeof(struct safexcel_ahash_req),
+	crypto_ahash_set_reqsize(ahash, max(sizeof(struct safexcel_ahash_req) +
+					    ctx->extra_req_bytes,
 					    sizeof(struct ahash_request) +
 					    crypto_ahash_reqsize(ctx->fback)));
 	return 0;
@@ -2587,7 +2620,7 @@ static int safexcel_sha3_256_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA3_256;
 	req->digest = CONTEXT_CONTROL_DIGEST_INITIAL;
@@ -2645,7 +2678,7 @@ static int safexcel_sha3_384_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA3_384;
 	req->digest = CONTEXT_CONTROL_DIGEST_INITIAL;
@@ -2703,7 +2736,7 @@ static int safexcel_sha3_512_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA3_512;
 	req->digest = CONTEXT_CONTROL_DIGEST_INITIAL;
@@ -2853,7 +2886,7 @@ static int safexcel_hmac_sha3_224_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Copy (half of) the key */
 	memcpy(req->state, ctx->ipad, SHA3_224_BLOCK_SIZE / 2);
@@ -2924,7 +2957,7 @@ static int safexcel_hmac_sha3_256_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Copy (half of) the key */
 	memcpy(req->state, ctx->ipad, SHA3_256_BLOCK_SIZE / 2);
@@ -2995,7 +3028,7 @@ static int safexcel_hmac_sha3_384_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Copy (half of) the key */
 	memcpy(req->state, ctx->ipad, SHA3_384_BLOCK_SIZE / 2);
@@ -3066,7 +3099,7 @@ static int safexcel_hmac_sha3_512_init(struct ahash_request *areq)
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 
-	memset(req, 0, sizeof(*req));
+	safexcel_hash_req_init(req, ctx->req_align);
 
 	/* Copy (half of) the key */
 	memcpy(req->state, ctx->ipad, SHA3_512_BLOCK_SIZE / 2);
-- 
1.8.3.1

