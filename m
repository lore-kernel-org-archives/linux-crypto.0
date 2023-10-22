Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72558C25B44
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjJVIS5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjJVISs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62762DD
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D7BC433C7
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962726;
        bh=fY3Yo02zzOcwjv6jRswp1rMvFiNyKF6/v+v5fC4t1Os=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Ls1PaJG4hWcrwcyqxZs7McuhrDJpV/JW9yfI/M687j28EAQa+rqYu8vmWJhEMm9Rb
         PdINtMZBgyz1YjNpfuFi0VrLUkENASMIHdfiCTYy1ucTwe8cMzoI/XGCBHQ4tkH78i
         1fKsV0ijkrTXdUKPsgYCWDuuqicpsPG6dbEwY0uArKLi0ZpwGyErM7KUzgA0sziLz3
         FzldfMsOJT2NS6qOq5RBm89ALSly2BbOfuRPyUW2HEcMaSLD+GL8TK9b7G1jS6eNDe
         WIbIXqbSesssXh02Axm2YzqS4AUJKWuBYx6///i2zIs0sfCB/9e0vXch1xTB9XjwIn
         DaQlH7b0AvP/A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 12/30] crypto: starfive - remove unnecessary alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:42 -0700
Message-ID: <20231022081100.123613-13-ebiggers@kernel.org>
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
makes the starfive driver no longer use it.  This driver did actually
rely on it, but only for storing to the result buffer using int stores
in starfive_hash_copy_hash().  This patch makes
starfive_hash_copy_hash() use put_unaligned() instead.  (It really
should use a specific endianness, but that's an existing bug.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/starfive/jh7110-hash.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-hash.c b/drivers/crypto/starfive/jh7110-hash.c
index cc7650198d703..b6d1808012ca7 100644
--- a/drivers/crypto/starfive/jh7110-hash.c
+++ b/drivers/crypto/starfive/jh7110-hash.c
@@ -202,21 +202,22 @@ static int starfive_hash_copy_hash(struct ahash_request *req)
 	int count, *data;
 	int mlen;
 
 	if (!req->result)
 		return 0;
 
 	mlen = rctx->digsize / sizeof(u32);
 	data = (u32 *)req->result;
 
 	for (count = 0; count < mlen; count++)
-		data[count] = readl(ctx->cryp->base + STARFIVE_HASH_SHARDR);
+		put_unaligned(readl(ctx->cryp->base + STARFIVE_HASH_SHARDR),
+			      &data[count]);
 
 	return 0;
 }
 
 void starfive_hash_done_task(unsigned long param)
 {
 	struct starfive_cryp_dev *cryp = (struct starfive_cryp_dev *)param;
 	int err = cryp->err;
 
 	if (!err)
@@ -621,21 +622,20 @@ static struct ahash_engine_alg algs_sha2_sm3[] = {
 		.statesize  = sizeof(struct sha256_state),
 		.base = {
 			.cra_name		= "sha224",
 			.cra_driver_name	= "sha224-starfive",
 			.cra_priority		= 200,
 			.cra_flags		= CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= SHA224_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
 	},
 	.op = {
 		.do_one_request = starfive_hash_one_request,
 	},
 }, {
 	.base.init     = starfive_hash_init,
 	.base.update   = starfive_hash_update,
 	.base.final    = starfive_hash_final,
@@ -651,21 +651,20 @@ static struct ahash_engine_alg algs_sha2_sm3[] = {
 		.statesize  = sizeof(struct sha256_state),
 		.base = {
 			.cra_name		= "hmac(sha224)",
 			.cra_driver_name	= "sha224-hmac-starfive",
 			.cra_priority		= 200,
 			.cra_flags		= CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= SHA224_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
 	},
 	.op = {
 		.do_one_request = starfive_hash_one_request,
 	},
 }, {
 	.base.init     = starfive_hash_init,
 	.base.update   = starfive_hash_update,
 	.base.final    = starfive_hash_final,
@@ -680,21 +679,20 @@ static struct ahash_engine_alg algs_sha2_sm3[] = {
 		.statesize  = sizeof(struct sha256_state),
 		.base = {
 			.cra_name		= "sha256",
 			.cra_driver_name	= "sha256-starfive",
 			.cra_priority		= 200,
 			.cra_flags		= CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= SHA256_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
 	},
 	.op = {
 		.do_one_request = starfive_hash_one_request,
 	},
 }, {
 	.base.init     = starfive_hash_init,
 	.base.update   = starfive_hash_update,
 	.base.final    = starfive_hash_final,
@@ -710,21 +708,20 @@ static struct ahash_engine_alg algs_sha2_sm3[] = {
 		.statesize  = sizeof(struct sha256_state),
 		.base = {
 			.cra_name		= "hmac(sha256)",
 			.cra_driver_name	= "sha256-hmac-starfive",
 			.cra_priority		= 200,
 			.cra_flags		= CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= SHA256_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
 	},
 	.op = {
 		.do_one_request = starfive_hash_one_request,
 	},
 }, {
 	.base.init     = starfive_hash_init,
 	.base.update   = starfive_hash_update,
 	.base.final    = starfive_hash_final,
@@ -739,21 +736,20 @@ static struct ahash_engine_alg algs_sha2_sm3[] = {
 		.statesize  = sizeof(struct sha512_state),
 		.base = {
 			.cra_name		= "sha384",
 			.cra_driver_name	= "sha384-starfive",
 			.cra_priority		= 200,
 			.cra_flags		= CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= SHA384_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
 	},
 	.op = {
 		.do_one_request = starfive_hash_one_request,
 	},
 }, {
 	.base.init     = starfive_hash_init,
 	.base.update   = starfive_hash_update,
 	.base.final    = starfive_hash_final,
@@ -769,21 +765,20 @@ static struct ahash_engine_alg algs_sha2_sm3[] = {
 		.statesize  = sizeof(struct sha512_state),
 		.base = {
 			.cra_name		= "hmac(sha384)",
 			.cra_driver_name	= "sha384-hmac-starfive",
 			.cra_priority		= 200,
 			.cra_flags		= CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= SHA384_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
 	},
 	.op = {
 		.do_one_request = starfive_hash_one_request,
 	},
 }, {
 	.base.init     = starfive_hash_init,
 	.base.update   = starfive_hash_update,
 	.base.final    = starfive_hash_final,
@@ -798,21 +793,20 @@ static struct ahash_engine_alg algs_sha2_sm3[] = {
 		.statesize  = sizeof(struct sha512_state),
 		.base = {
 			.cra_name		= "sha512",
 			.cra_driver_name	= "sha512-starfive",
 			.cra_priority		= 200,
 			.cra_flags		= CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= SHA512_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
 	},
 	.op = {
 		.do_one_request = starfive_hash_one_request,
 	},
 }, {
 	.base.init     = starfive_hash_init,
 	.base.update   = starfive_hash_update,
 	.base.final    = starfive_hash_final,
@@ -828,21 +822,20 @@ static struct ahash_engine_alg algs_sha2_sm3[] = {
 		.statesize  = sizeof(struct sha512_state),
 		.base = {
 			.cra_name		= "hmac(sha512)",
 			.cra_driver_name	= "sha512-hmac-starfive",
 			.cra_priority		= 200,
 			.cra_flags		= CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= SHA512_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
 	},
 	.op = {
 		.do_one_request = starfive_hash_one_request,
 	},
 }, {
 	.base.init     = starfive_hash_init,
 	.base.update   = starfive_hash_update,
 	.base.final    = starfive_hash_final,
@@ -857,21 +850,20 @@ static struct ahash_engine_alg algs_sha2_sm3[] = {
 		.statesize  = sizeof(struct sm3_state),
 		.base = {
 			.cra_name		= "sm3",
 			.cra_driver_name	= "sm3-starfive",
 			.cra_priority		= 200,
 			.cra_flags		= CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= SM3_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
 	},
 	.op = {
 		.do_one_request = starfive_hash_one_request,
 	},
 }, {
 	.base.init	  = starfive_hash_init,
 	.base.update	  = starfive_hash_update,
 	.base.final	  = starfive_hash_final,
@@ -887,21 +879,20 @@ static struct ahash_engine_alg algs_sha2_sm3[] = {
 		.statesize  = sizeof(struct sm3_state),
 		.base = {
 			.cra_name		= "hmac(sm3)",
 			.cra_driver_name	= "sm3-hmac-starfive",
 			.cra_priority		= 200,
 			.cra_flags		= CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= SM3_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
 	},
 	.op = {
 		.do_one_request = starfive_hash_one_request,
 	},
 },
 };
 
 int starfive_hash_register_algs(void)
-- 
2.42.0

