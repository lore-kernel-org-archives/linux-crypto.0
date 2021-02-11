Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F70EC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0846D64DD1
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhBKUC1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Feb 2021 15:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbhBKUCL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Feb 2021 15:02:11 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A00C061788
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:30 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id m144so6499115qke.10
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aN4Ar0ko3Rto1g1pRIsQic5bApXWaoyHtlgB9BLpWjA=;
        b=dO+XL05EXMTxsPkfh2TslSCw5vPK9eq/OsR1PGv9WuhlruX9G0nDaxt52yNN8Q4HTd
         rOWLRhOGVe1ws/MjJzHva9kDt9M2mS40PDDP7X0gVPz1JkHsg28pJmWpKQDxTFH3c6Zq
         /8k9erWJw7Bk+aSOK8k67eOTAx29VHkpYXZgKmS6BX9pv+RyFHJPRgm7mzrmAEiX9s9g
         dXZce8fg7liBoxiN+ZRdR7e5lXz6SD1bfZUaLvXbquVq+8ArCB+XvBRdDqAnI0x4gRNv
         Z/M3stqyNpiq4GUy6UA3rn02NXo+qzUv+kcxkPRWV+JsAKgDGu01XSVp2+aKFFQwGpz+
         jEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aN4Ar0ko3Rto1g1pRIsQic5bApXWaoyHtlgB9BLpWjA=;
        b=WSaq+jH1KEPM137uUF0qqYjgp3SR0svhYs3xSCF9VsyJv3X4DhyLSgQ0+7CNTF7ZCt
         IYMVEDoEaXc5TanawBDgDX3xvJdTyIuCarmy9/UIp8d0Wi4IRN+Wh6R5zcBIO0WJz9tr
         KKcYbhxJRjwoAu8hJIJZUpWowM7g5ARjNKNKMjO36W51bNCZmd5Zti4OHcjlpmalJOlV
         EUouqxc31OAVLdABGbzgb1tyV3q4m9OoI7J9o2ZhQz1kk+JnVa38l2XCEsZjHntikC7X
         zDLPfI5/c7uvlVrooerImuvYHSjZyGjibLg1eh1eRdUECWzUJoy3efw/GvMNiBkfyN2g
         3nfQ==
X-Gm-Message-State: AOAM530DXukJx4cDnDG2oFB5ECJcPnqS1zi4gnaWkn3b+8SyKULk69ky
        4GNK6rt4WoVhoXluBNDvqmXBWQ==
X-Google-Smtp-Source: ABdhPJwVZpEcyjTPfMrxCn9krDVGzdTfDFSC796VUlhEzVigmep1EY496KvgIEzFUwhCL2phVwUGCQ==
X-Received: by 2002:a05:620a:2281:: with SMTP id o1mr9855196qkh.313.1613073690171;
        Thu, 11 Feb 2021 12:01:30 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id 17sm4496243qtu.23.2021.02.11.12.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:01:29 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 01/11] crypto: qce: sha: Restore/save ahash state with custom struct in export/import
Date:   Thu, 11 Feb 2021 15:01:18 -0500
Message-Id: <20210211200128.2886388-2-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211200128.2886388-1-thara.gopinath@linaro.org>
References: <20210211200128.2886388-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Export and import interfaces save and restore partial transformation
states. The partial states were being stored and restored in struct
sha1_state for sha1/hmac(sha1) transformations and sha256_state for
sha256/hmac(sha256) transformations.This led to a bunch of corner cases
where improper state was being stored and restored. A few of the corner
cases that turned up during testing are:

- wrong byte_count restored if export/import is called twice without h/w
transaction in between
- wrong buflen restored back if the pending buffer
length is exactly the block size.
- wrong state restored if buffer length is 0.

To fix these issues, save and restore the partial transformation state
using the newly introduced qce_sha_saved_state struct. This ensures that
all the pieces required to properly restart the transformation is captured
and restored back

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---

v4->v5:
	- Fixed build warning/error in patch for wrong assignment of const
	  pointer as reported by kernel test robot <lkp@intel.com>.
v1->v2:
	- Introduced custom struct qce_sha_saved_state to store and
	  restore partial sha transformation. v1 was re-using
	  qce_sha_reqctx to save and restore partial states and this
	  could lead to potential memcpy issues around pointer copying.


 drivers/crypto/qce/sha.c | 122 +++++++++++----------------------------
 1 file changed, 34 insertions(+), 88 deletions(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 61c418c12345..7da562dca740 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -12,9 +12,15 @@
 #include "core.h"
 #include "sha.h"
 
-/* crypto hw padding constant for first operation */
-#define SHA_PADDING		64
-#define SHA_PADDING_MASK	(SHA_PADDING - 1)
+struct qce_sha_saved_state {
+	u8 pending_buf[QCE_SHA_MAX_BLOCKSIZE];
+	u8 partial_digest[QCE_SHA_MAX_DIGESTSIZE];
+	__be32 byte_count[2];
+	unsigned int pending_buflen;
+	unsigned int flags;
+	u64 count;
+	bool first_blk;
+};
 
 static LIST_HEAD(ahash_algs);
 
@@ -139,97 +145,37 @@ static int qce_ahash_init(struct ahash_request *req)
 
 static int qce_ahash_export(struct ahash_request *req, void *out)
 {
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
-	unsigned long flags = rctx->flags;
-	unsigned int digestsize = crypto_ahash_digestsize(ahash);
-	unsigned int blocksize =
-			crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
-
-	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
-		struct sha1_state *out_state = out;
-
-		out_state->count = rctx->count;
-		qce_cpu_to_be32p_array((__be32 *)out_state->state,
-				       rctx->digest, digestsize);
-		memcpy(out_state->buffer, rctx->buf, blocksize);
-	} else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags)) {
-		struct sha256_state *out_state = out;
-
-		out_state->count = rctx->count;
-		qce_cpu_to_be32p_array((__be32 *)out_state->state,
-				       rctx->digest, digestsize);
-		memcpy(out_state->buf, rctx->buf, blocksize);
-	} else {
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int qce_import_common(struct ahash_request *req, u64 in_count,
-			     const u32 *state, const u8 *buffer, bool hmac)
-{
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
-	unsigned int digestsize = crypto_ahash_digestsize(ahash);
-	unsigned int blocksize;
-	u64 count = in_count;
-
-	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
-	rctx->count = in_count;
-	memcpy(rctx->buf, buffer, blocksize);
-
-	if (in_count <= blocksize) {
-		rctx->first_blk = 1;
-	} else {
-		rctx->first_blk = 0;
-		/*
-		 * For HMAC, there is a hardware padding done when first block
-		 * is set. Therefore the byte_count must be incremened by 64
-		 * after the first block operation.
-		 */
-		if (hmac)
-			count += SHA_PADDING;
-	}
+	struct qce_sha_saved_state *export_state = out;
 
-	rctx->byte_count[0] = (__force __be32)(count & ~SHA_PADDING_MASK);
-	rctx->byte_count[1] = (__force __be32)(count >> 32);
-	qce_cpu_to_be32p_array((__be32 *)rctx->digest, (const u8 *)state,
-			       digestsize);
-	rctx->buflen = (unsigned int)(in_count & (blocksize - 1));
+	memcpy(export_state->pending_buf, rctx->buf, rctx->buflen);
+	memcpy(export_state->partial_digest, rctx->digest, sizeof(rctx->digest));
+	export_state->byte_count[0] = rctx->byte_count[0];
+	export_state->byte_count[1] = rctx->byte_count[1];
+	export_state->pending_buflen = rctx->buflen;
+	export_state->count = rctx->count;
+	export_state->first_blk = rctx->first_blk;
+	export_state->flags = rctx->flags;
 
 	return 0;
 }
 
 static int qce_ahash_import(struct ahash_request *req, const void *in)
 {
-	struct qce_sha_reqctx *rctx;
-	unsigned long flags;
-	bool hmac;
-	int ret;
-
-	ret = qce_ahash_init(req);
-	if (ret)
-		return ret;
-
-	rctx = ahash_request_ctx(req);
-	flags = rctx->flags;
-	hmac = IS_SHA_HMAC(flags);
-
-	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
-		const struct sha1_state *state = in;
-
-		ret = qce_import_common(req, state->count, state->state,
-					state->buffer, hmac);
-	} else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags)) {
-		const struct sha256_state *state = in;
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	const struct qce_sha_saved_state *import_state = in;
 
-		ret = qce_import_common(req, state->count, state->state,
-					state->buf, hmac);
-	}
+	memset(rctx, 0, sizeof(*rctx));
+	rctx->count = import_state->count;
+	rctx->buflen = import_state->pending_buflen;
+	rctx->first_blk = import_state->first_blk;
+	rctx->flags = import_state->flags;
+	rctx->byte_count[0] = import_state->byte_count[0];
+	rctx->byte_count[1] = import_state->byte_count[1];
+	memcpy(rctx->buf, import_state->pending_buf, rctx->buflen);
+	memcpy(rctx->digest, import_state->partial_digest, sizeof(rctx->digest));
 
-	return ret;
+	return 0;
 }
 
 static int qce_ahash_update(struct ahash_request *req)
@@ -450,7 +396,7 @@ static const struct qce_ahash_def ahash_def[] = {
 		.drv_name	= "sha1-qce",
 		.digestsize	= SHA1_DIGEST_SIZE,
 		.blocksize	= SHA1_BLOCK_SIZE,
-		.statesize	= sizeof(struct sha1_state),
+		.statesize	= sizeof(struct qce_sha_saved_state),
 		.std_iv		= std_iv_sha1,
 	},
 	{
@@ -459,7 +405,7 @@ static const struct qce_ahash_def ahash_def[] = {
 		.drv_name	= "sha256-qce",
 		.digestsize	= SHA256_DIGEST_SIZE,
 		.blocksize	= SHA256_BLOCK_SIZE,
-		.statesize	= sizeof(struct sha256_state),
+		.statesize	= sizeof(struct qce_sha_saved_state),
 		.std_iv		= std_iv_sha256,
 	},
 	{
@@ -468,7 +414,7 @@ static const struct qce_ahash_def ahash_def[] = {
 		.drv_name	= "hmac-sha1-qce",
 		.digestsize	= SHA1_DIGEST_SIZE,
 		.blocksize	= SHA1_BLOCK_SIZE,
-		.statesize	= sizeof(struct sha1_state),
+		.statesize	= sizeof(struct qce_sha_saved_state),
 		.std_iv		= std_iv_sha1,
 	},
 	{
@@ -477,7 +423,7 @@ static const struct qce_ahash_def ahash_def[] = {
 		.drv_name	= "hmac-sha256-qce",
 		.digestsize	= SHA256_DIGEST_SIZE,
 		.blocksize	= SHA256_BLOCK_SIZE,
-		.statesize	= sizeof(struct sha256_state),
+		.statesize	= sizeof(struct qce_sha_saved_state),
 		.std_iv		= std_iv_sha256,
 	},
 };
-- 
2.25.1

