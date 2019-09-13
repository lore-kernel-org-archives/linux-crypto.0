Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9674BC49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 11:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 549EB20693
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 11:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sQJjKUrw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfIMLcc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 07:32:32 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45927 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfIMLcc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 07:32:32 -0400
Received: by mail-ed1-f67.google.com with SMTP id f19so26702330eds.12
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 04:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5tLSKnctlFg2HClMAzcnSt7+wLRF8eEWG59dGZCj4t4=;
        b=sQJjKUrw+RvOAc89rjmjEN+kLKEwNWNZopjM5UGSfMla2TzvpsDO3u7JBx91p75Svh
         qp5TxrNWOmYoYVPl58hKAGKYWAF0vLuHtD+B10e9nput8LSDJivN91JD9weYzQLGaw5c
         QlSJlf9jFGLilB5Xjjzexan6GVZQ1p4w0T9f6nDm7RcYGYjtQBg/yZo0pJOtV2iCkjGw
         GvR4MeX/9X5nGKqfp9Jkp7QfYpQRylPVmfwht5Z8U/roeR1ILm5NQcN/XBckqIQZQnGu
         Cq1jSM+PdNiek9wxbl5tslLM/9HvcaBS/eU+yFM9Go2lkVVUZj21bSZos83SVINIZSt+
         9MGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5tLSKnctlFg2HClMAzcnSt7+wLRF8eEWG59dGZCj4t4=;
        b=iyP/lD9asATHwVdvPAkGluv8odyUDM12GWjSnoGcIsr4jEA5Ti+BYeKRcaq7AUYEqS
         hmF9RYFuMbkR9+SjtafPvI8X5mXko46UWBJnHjBwOWENxqjlaFACkih0ljHMIhiP1KSN
         WThXxn/pDEYXHoqw29zJMxFwv3iDAM2jf3LeX/nsLtl1ZjkBchOo9HDjUpRE3Jw3gwQC
         yfq9QPtpWAAOI5QozdlmtmDbDRYSWQVBW+xzNJuGrRJq3vH7WFBDgjp1uOv44TIpfZ80
         FfhXdsEkYxJfGlSVE8cz8J0ZtWcVWS1DMD8OxKeppLIuZ27a1VbTZP+usk6ge38oWD0v
         SOjw==
X-Gm-Message-State: APjAAAUY3VVzOIeS6GNljtCi/Z+nEOfkatNcfSh2BR37S5PH31S66hpf
        ZuFXy8114bEX8JWbqbQkqah8PNko
X-Google-Smtp-Source: APXvYqzu9oA7zhAi24F6knDQhjChL0998yDgA5Q4XL/R20dLnsbMhzE3n98Fv77znkNNOAuxD81sxg==
X-Received: by 2002:a17:906:5ac2:: with SMTP id x2mr37672938ejs.77.1568374349973;
        Fri, 13 Sep 2019 04:32:29 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id y25sm173197eju.39.2019.09.13.04.32.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 04:32:29 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/2] crypto: inside-secure - Add SHA3 family of basic hash algorithms
Date:   Fri, 13 Sep 2019 12:29:32 +0200
Message-Id: <1568370573-3712-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568370573-3712-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568370573-3712-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for sha3-224, sha3-256, sha3-384 and sha3-512
basic hashes.

The patch has been tested with the eip197c_iewxkbc configuration on the
Xilinx VCU118 development board, including the testmgr extra tests.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c      |   4 +
 drivers/crypto/inside-secure/safexcel.h      |   9 +
 drivers/crypto/inside-secure/safexcel_hash.c | 351 +++++++++++++++++++++++++++
 3 files changed, 364 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 69079fb..f211082 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1187,6 +1187,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_authenc_hmac_sm3_cbc_sm4,
 	&safexcel_alg_authenc_hmac_sha1_ctr_sm4,
 	&safexcel_alg_authenc_hmac_sm3_ctr_sm4,
+	&safexcel_alg_sha3_224,
+	&safexcel_alg_sha3_256,
+	&safexcel_alg_sha3_384,
+	&safexcel_alg_sha3_512,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 77e71c2..16d09f2 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -360,6 +360,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_ALG_AES256	(0x7 << 17)
 #define CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20	(0x8 << 17)
 #define CONTEXT_CONTROL_CRYPTO_ALG_SM4		(0xd << 17)
+#define CONTEXT_CONTROL_DIGEST_INITIAL		(0x0 << 21)
 #define CONTEXT_CONTROL_DIGEST_PRECOMPUTED	(0x1 << 21)
 #define CONTEXT_CONTROL_DIGEST_XCM		(0x2 << 21)
 #define CONTEXT_CONTROL_DIGEST_HMAC		(0x3 << 21)
@@ -375,6 +376,10 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC192	(0x2 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC256	(0x3 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_SM3		(0x7 << 23)
+#define CONTEXT_CONTROL_CRYPTO_ALG_SHA3_256	(0xb << 23)
+#define CONTEXT_CONTROL_CRYPTO_ALG_SHA3_224	(0xc << 23)
+#define CONTEXT_CONTROL_CRYPTO_ALG_SHA3_512	(0xd << 23)
+#define CONTEXT_CONTROL_CRYPTO_ALG_SHA3_384	(0xe << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_POLY1305	(0xf << 23)
 #define CONTEXT_CONTROL_INV_FR			(0x5 << 24)
 #define CONTEXT_CONTROL_INV_TR			(0x6 << 24)
@@ -882,5 +887,9 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_cbc_sm4;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_sm4;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_ctr_sm4;
+extern struct safexcel_alg_template safexcel_alg_sha3_224;
+extern struct safexcel_alg_template safexcel_alg_sha3_256;
+extern struct safexcel_alg_template safexcel_alg_sha3_384;
+extern struct safexcel_alg_template safexcel_alg_sha3_512;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index fdf4bcc..50f2050 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -9,6 +9,7 @@
 #include <crypto/hmac.h>
 #include <crypto/md5.h>
 #include <crypto/sha.h>
+#include <crypto/sha3.h>
 #include <crypto/skcipher.h>
 #include <crypto/sm3.h>
 #include <linux/device.h>
@@ -24,11 +25,14 @@ struct safexcel_ahash_ctx {
 	u32 alg;
 	u8  key_sz;
 	bool cbcmac;
+	bool do_fallback;
+	bool fb_init_done;
 
 	u32 ipad[SHA512_DIGEST_SIZE / sizeof(u32)];
 	u32 opad[SHA512_DIGEST_SIZE / sizeof(u32)];
 
 	struct crypto_cipher *kaes;
+	struct crypto_ahash *fback;
 };
 
 struct safexcel_ahash_req {
@@ -2350,3 +2354,350 @@ struct safexcel_alg_template safexcel_alg_hmac_sm3 = {
 		},
 	},
 };
+
+static int safexcel_sha3_224_init(struct ahash_request *areq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+
+	memset(req, 0, sizeof(*req));
+
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA3_224;
+	req->digest = CONTEXT_CONTROL_DIGEST_INITIAL;
+	req->state_sz = SHA3_224_DIGEST_SIZE;
+	req->block_sz = SHA3_224_BLOCK_SIZE;
+	ctx->do_fallback = false;
+	ctx->fb_init_done = false;
+	return 0;
+}
+
+static int safexcel_sha3_fbcheck(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *subreq = ahash_request_ctx(req);
+	int ret = 0;
+
+	if (ctx->do_fallback) {
+		ahash_request_set_tfm(subreq, ctx->fback);
+		ahash_request_set_callback(subreq, req->base.flags,
+					   req->base.complete, req->base.data);
+		ahash_request_set_crypt(subreq, req->src, req->result,
+					req->nbytes);
+		if (!ctx->fb_init_done) {
+			ret = crypto_ahash_init(subreq);
+			ctx->fb_init_done = true;
+		}
+	}
+	return ret;
+}
+
+static int safexcel_sha3_update(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *subreq = ahash_request_ctx(req);
+
+	ctx->do_fallback = true;
+	return safexcel_sha3_fbcheck(req) ?: crypto_ahash_update(subreq);
+}
+
+static int safexcel_sha3_final(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *subreq = ahash_request_ctx(req);
+
+	ctx->do_fallback = true;
+	return safexcel_sha3_fbcheck(req) ?: crypto_ahash_final(subreq);
+}
+
+static int safexcel_sha3_finup(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *subreq = ahash_request_ctx(req);
+
+	ctx->do_fallback |= !req->nbytes;
+	if (ctx->do_fallback)
+		/* Update or ex/import happened or len 0, cannot use the HW */
+		return safexcel_sha3_fbcheck(req) ?:
+		       crypto_ahash_finup(subreq);
+	else
+		return safexcel_ahash_finup(req);
+}
+
+static int safexcel_sha3_digest_fallback(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *subreq = ahash_request_ctx(req);
+
+	ctx->do_fallback = true;
+	ctx->fb_init_done = false;
+	return safexcel_sha3_fbcheck(req) ?: crypto_ahash_finup(subreq);
+}
+
+static int safexcel_sha3_224_digest(struct ahash_request *req)
+{
+	if (req->nbytes)
+		return safexcel_sha3_224_init(req) ?: safexcel_ahash_finup(req);
+
+	/* HW cannot do zero length hash, use fallback instead */
+	return safexcel_sha3_digest_fallback(req);
+}
+
+static int safexcel_sha3_export(struct ahash_request *req, void *out)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *subreq = ahash_request_ctx(req);
+
+	ctx->do_fallback = true;
+	return safexcel_sha3_fbcheck(req) ?: crypto_ahash_export(subreq, out);
+}
+
+static int safexcel_sha3_import(struct ahash_request *req, const void *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *subreq = ahash_request_ctx(req);
+
+	ctx->do_fallback = true;
+	return safexcel_sha3_fbcheck(req) ?: crypto_ahash_import(subreq, in);
+	// return safexcel_ahash_import(req, in);
+}
+
+static int safexcel_sha3_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
+	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_ahash_cra_init(tfm);
+
+	/* Allocate fallback implementation */
+	ctx->fback = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0,
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->fback))
+		return PTR_ERR(ctx->fback);
+
+	/* Update statesize from fallback algorithm! */
+	crypto_hash_alg_common(ahash)->statesize =
+		crypto_ahash_statesize(ctx->fback);
+	crypto_ahash_set_reqsize(ahash, max(sizeof(struct safexcel_ahash_req),
+					    sizeof(struct ahash_request) +
+					    crypto_ahash_reqsize(ctx->fback)));
+	return 0;
+}
+
+static void safexcel_sha3_cra_exit(struct crypto_tfm *tfm)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_ahash(ctx->fback);
+	safexcel_ahash_cra_exit(tfm);
+}
+
+struct safexcel_alg_template safexcel_alg_sha3_224 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA3,
+	.alg.ahash = {
+		.init = safexcel_sha3_224_init,
+		.update = safexcel_sha3_update,
+		.final = safexcel_sha3_final,
+		.finup = safexcel_sha3_finup,
+		.digest = safexcel_sha3_224_digest,
+		.export = safexcel_sha3_export,
+		.import = safexcel_sha3_import,
+		.halg = {
+			.digestsize = SHA3_224_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "sha3-224",
+				.cra_driver_name = "safexcel-sha3-224",
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_NEED_FALLBACK,
+				.cra_blocksize = SHA3_224_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_sha3_cra_init,
+				.cra_exit = safexcel_sha3_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
+
+static int safexcel_sha3_256_init(struct ahash_request *areq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+
+	memset(req, 0, sizeof(*req));
+
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA3_256;
+	req->digest = CONTEXT_CONTROL_DIGEST_INITIAL;
+	req->state_sz = SHA3_256_DIGEST_SIZE;
+	req->block_sz = SHA3_256_BLOCK_SIZE;
+	ctx->do_fallback = false;
+	ctx->fb_init_done = false;
+	return 0;
+}
+
+static int safexcel_sha3_256_digest(struct ahash_request *req)
+{
+	if (req->nbytes)
+		return safexcel_sha3_256_init(req) ?: safexcel_ahash_finup(req);
+
+	/* HW cannot do zero length hash, use fallback instead */
+	return safexcel_sha3_digest_fallback(req);
+}
+
+struct safexcel_alg_template safexcel_alg_sha3_256 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA3,
+	.alg.ahash = {
+		.init = safexcel_sha3_256_init,
+		.update = safexcel_sha3_update,
+		.final = safexcel_sha3_final,
+		.finup = safexcel_sha3_finup,
+		.digest = safexcel_sha3_256_digest,
+		.export = safexcel_sha3_export,
+		.import = safexcel_sha3_import,
+		.halg = {
+			.digestsize = SHA3_256_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "sha3-256",
+				.cra_driver_name = "safexcel-sha3-256",
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_NEED_FALLBACK,
+				.cra_blocksize = SHA3_256_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_sha3_cra_init,
+				.cra_exit = safexcel_sha3_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
+
+static int safexcel_sha3_384_init(struct ahash_request *areq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+
+	memset(req, 0, sizeof(*req));
+
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA3_384;
+	req->digest = CONTEXT_CONTROL_DIGEST_INITIAL;
+	req->state_sz = SHA3_384_DIGEST_SIZE;
+	req->block_sz = SHA3_384_BLOCK_SIZE;
+	ctx->do_fallback = false;
+	ctx->fb_init_done = false;
+	return 0;
+}
+
+static int safexcel_sha3_384_digest(struct ahash_request *req)
+{
+	if (req->nbytes)
+		return safexcel_sha3_384_init(req) ?: safexcel_ahash_finup(req);
+
+	/* HW cannot do zero length hash, use fallback instead */
+	return safexcel_sha3_digest_fallback(req);
+}
+
+struct safexcel_alg_template safexcel_alg_sha3_384 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA3,
+	.alg.ahash = {
+		.init = safexcel_sha3_384_init,
+		.update = safexcel_sha3_update,
+		.final = safexcel_sha3_final,
+		.finup = safexcel_sha3_finup,
+		.digest = safexcel_sha3_384_digest,
+		.export = safexcel_sha3_export,
+		.import = safexcel_sha3_import,
+		.halg = {
+			.digestsize = SHA3_384_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "sha3-384",
+				.cra_driver_name = "safexcel-sha3-384",
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_NEED_FALLBACK,
+				.cra_blocksize = SHA3_384_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_sha3_cra_init,
+				.cra_exit = safexcel_sha3_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
+
+static int safexcel_sha3_512_init(struct ahash_request *areq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+
+	memset(req, 0, sizeof(*req));
+
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA3_512;
+	req->digest = CONTEXT_CONTROL_DIGEST_INITIAL;
+	req->state_sz = SHA3_512_DIGEST_SIZE;
+	req->block_sz = SHA3_512_BLOCK_SIZE;
+	ctx->do_fallback = false;
+	ctx->fb_init_done = false;
+	return 0;
+}
+
+static int safexcel_sha3_512_digest(struct ahash_request *req)
+{
+	if (req->nbytes)
+		return safexcel_sha3_512_init(req) ?: safexcel_ahash_finup(req);
+
+	/* HW cannot do zero length hash, use fallback instead */
+	return safexcel_sha3_digest_fallback(req);
+}
+
+struct safexcel_alg_template safexcel_alg_sha3_512 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA3,
+	.alg.ahash = {
+		.init = safexcel_sha3_512_init,
+		.update = safexcel_sha3_update,
+		.final = safexcel_sha3_final,
+		.finup = safexcel_sha3_finup,
+		.digest = safexcel_sha3_512_digest,
+		.export = safexcel_sha3_export,
+		.import = safexcel_sha3_import,
+		.halg = {
+			.digestsize = SHA3_512_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "sha3-512",
+				.cra_driver_name = "safexcel-sha3-512",
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY |
+					     CRYPTO_ALG_NEED_FALLBACK,
+				.cra_blocksize = SHA3_512_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_sha3_cra_init,
+				.cra_exit = safexcel_sha3_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
-- 
1.8.3.1

