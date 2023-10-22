Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4430C25B42
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjJVISr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjJVISq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E723DDD
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B765C433CA
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962724;
        bh=msjZIYn/hX0AcK2md0eJkbgBzivbOxW2vCmrp//6yVA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Z8BCVoRday9FjHk1k0s5ldMfDwu3DKckpz2564exbH12ao85uliBuG76roawa8Yi9
         TVJ1I1tTqnYy1CNisDWFHL47ogVGgJJrr01HaA/r6hmOr6bLpm0S6kqIpeYLp2AkvH
         kmbnM0t96CFr9hGnX+CBut/xSkqa9228/vZoIrZXFs8UVmhl9vPHESZQTDLqEigfWT
         VOeyyq0/nWN/TIIIBhqMnklm/ykT0SLDxVDhmgeQp9+tHfVew5e/Affps5kg04HiDg
         2KKlvVH/bor66/kxRMw7wu4y8DRMqg/LLr6iMtrGXxpqSk+iQA+Bb6tNsk1kXfstZU
         AynWC+cyNBkZw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 04/30] crypto: sun8i-ss - remove unnecessary alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:34 -0700
Message-ID: <20231022081100.123613-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The crypto API's support for alignmasks for ahash algorithms is nearly
useless, as its only effect is to cause the API to align the key and
result buffers.  The drivers that happen to be specifying an alignmask
for ahash rarely actually need it.  When they do, it's easily fixable,
especially considering that these buffers cannot be used for DMA.

In preparation for removing alignmask support from ahash, this patch
makes the sun8i-ss driver no longer use it.  This driver didn't actually
rely on it; it only writes to the result buffer in sun8i_ss_hash_run(),
simply using memcpy().  And sun8i_ss_hmac_setkey() does not assume any
alignment for the key buffer.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 4a9587285c04f..2532d2abc4f7e 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -315,21 +315,20 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.import = sun8i_ss_hash_import,
 		.init_tfm = sun8i_ss_hash_init_tfm,
 		.exit_tfm = sun8i_ss_hash_exit_tfm,
 		.halg = {
 			.digestsize = MD5_DIGEST_SIZE,
 			.statesize = sizeof(struct md5_state),
 			.base = {
 				.cra_name = "md5",
 				.cra_driver_name = "md5-sun8i-ss",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
@@ -348,21 +347,20 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.import = sun8i_ss_hash_import,
 		.init_tfm = sun8i_ss_hash_init_tfm,
 		.exit_tfm = sun8i_ss_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
 			.statesize = sizeof(struct sha1_state),
 			.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "sha1-sun8i-ss",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
@@ -381,21 +379,20 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.import = sun8i_ss_hash_import,
 		.init_tfm = sun8i_ss_hash_init_tfm,
 		.exit_tfm = sun8i_ss_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA224_DIGEST_SIZE,
 			.statesize = sizeof(struct sha256_state),
 			.base = {
 				.cra_name = "sha224",
 				.cra_driver_name = "sha224-sun8i-ss",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
@@ -414,21 +411,20 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.import = sun8i_ss_hash_import,
 		.init_tfm = sun8i_ss_hash_init_tfm,
 		.exit_tfm = sun8i_ss_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA256_DIGEST_SIZE,
 			.statesize = sizeof(struct sha256_state),
 			.base = {
 				.cra_name = "sha256",
 				.cra_driver_name = "sha256-sun8i-ss",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
@@ -448,21 +444,20 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.init_tfm = sun8i_ss_hash_init_tfm,
 		.exit_tfm = sun8i_ss_hash_exit_tfm,
 		.setkey = sun8i_ss_hmac_setkey,
 		.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
 			.statesize = sizeof(struct sha1_state),
 			.base = {
 				.cra_name = "hmac(sha1)",
 				.cra_driver_name = "hmac-sha1-sun8i-ss",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
-- 
2.42.0

