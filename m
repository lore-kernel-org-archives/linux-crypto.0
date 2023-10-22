Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13784CDB474
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjJVISt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbjJVISq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B27DA
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E0DC433CB
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962724;
        bh=bQATfADIXiBxUHc7OZfuaiVgVmZJfg74IAsz7wBYD4w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kbMGf6BMeendzu5ePzbYBBMM5v7X/xK7EMh9zZs2A12PJdl2Du1edqOxhh4fhuaRF
         q2dfD4Vc743GPpqT994aPdgHjeDowjDFfQUoJgAKXd1I6s60iQAJKkU/NYy3CdjCbw
         5jUy80wKlodC5x6xbqtco1TR+eLvBBtNygNkBTpCB109SKW11b4dwW+sPxuIzhFQz/
         /HZ1GQBHa5Qccvq9YsAcPdjB66bGOpLxZi0ILLfZBOGRHNUETqq/sMxXmi31InqKjc
         YUgTQEpCNAtrp2o/IjW0pgD7N0Dhoxchv/VhXCHei7Vko/UvNO8GxG/qbX2MKqWqfl
         z4t3O//M7lzUg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 03/30] crypto: sun8i-ce - remove unnecessary alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:33 -0700
Message-ID: <20231022081100.123613-4-ebiggers@kernel.org>
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
makes the sun8i-ce driver no longer use it.  This driver didn't actually
rely on it; it only writes to the result buffer in sun8i_ce_hash_run(),
simply using memcpy().  And this driver only supports unkeyed hash
algorithms, so the key buffer need not be considered.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index d4ccd5254280b..4362e60905b09 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -407,21 +407,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.import = sun8i_ce_hash_import,
 		.init_tfm = sun8i_ce_hash_init_tfm,
 		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = MD5_DIGEST_SIZE,
 			.statesize = sizeof(struct md5_state),
 			.base = {
 				.cra_name = "md5",
 				.cra_driver_name = "md5-sun8i-ce",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
@@ -441,21 +440,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.import = sun8i_ce_hash_import,
 		.init_tfm = sun8i_ce_hash_init_tfm,
 		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
 			.statesize = sizeof(struct sha1_state),
 			.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "sha1-sun8i-ce",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
@@ -474,21 +472,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.import = sun8i_ce_hash_import,
 		.init_tfm = sun8i_ce_hash_init_tfm,
 		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA224_DIGEST_SIZE,
 			.statesize = sizeof(struct sha256_state),
 			.base = {
 				.cra_name = "sha224",
 				.cra_driver_name = "sha224-sun8i-ce",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
@@ -507,21 +504,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.import = sun8i_ce_hash_import,
 		.init_tfm = sun8i_ce_hash_init_tfm,
 		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA256_DIGEST_SIZE,
 			.statesize = sizeof(struct sha256_state),
 			.base = {
 				.cra_name = "sha256",
 				.cra_driver_name = "sha256-sun8i-ce",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
@@ -540,21 +536,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.import = sun8i_ce_hash_import,
 		.init_tfm = sun8i_ce_hash_init_tfm,
 		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA384_DIGEST_SIZE,
 			.statesize = sizeof(struct sha512_state),
 			.base = {
 				.cra_name = "sha384",
 				.cra_driver_name = "sha384-sun8i-ce",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
@@ -573,21 +568,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.import = sun8i_ce_hash_import,
 		.init_tfm = sun8i_ce_hash_init_tfm,
 		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA512_DIGEST_SIZE,
 			.statesize = sizeof(struct sha512_state),
 			.base = {
 				.cra_name = "sha512",
 				.cra_driver_name = "sha512-sun8i-ce",
 				.cra_priority = 300,
-				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	.alg.hash.op = {
-- 
2.42.0

