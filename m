Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3643C25B45
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjJVIS7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjJVISt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975CBCF
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663F9C433CA
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962726;
        bh=BCF/IKknJGOxDyL3q/kFif5oBmpkW4H+u9uUhiQNKGQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dCjVk8Evzos/U2XOb73dRrrAjDEX1tGQzlC09kLYTptC7Z7F82oVbyS7430Pqy+Uq
         dP/xyN1CsoiTKJNZaSa7NRkDevazmWfTO8LIETwe7Tmh4z+sIEmOfxBfvfsB8udYO5
         d4OJZwPjUD9vOIb7RnRDsljpi54x+mwPGCUEYkLAT5FpIAJ9/ieN2AGy4ftjolt9Lp
         LsiR07s74ZUPOKrfrPOzxYjlz/TfKOKRt/hTKfJsdoonIwvGUjPaq6ZM21xIjRqQBf
         VkDFLHo1fvjawePtKQ2uLEIGKpZ0gshdt6SBJQlvrCAlriTUYU0x4Vq7i9w/3nqNDP
         zR8ntNDad/zDw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 13/30] crypto: stm32 - remove unnecessary alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:43 -0700
Message-ID: <20231022081100.123613-14-ebiggers@kernel.org>
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
makes the stm32 driver no longer use it.  This driver didn't actually
rely on it; it only writes to the result buffer in stm32_hash_finish(),
simply using memcpy().  And stm32_hash_setkey() does not assume any
alignment for the key buffer.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/stm32/stm32-hash.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 2b2382d4332c5..34e0d7e381a8c 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1276,21 +1276,20 @@ static struct ahash_engine_alg algs_md5[] = {
 			.digestsize = MD5_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "md5",
 				.cra_driver_name = "stm32-md5",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1306,21 +1305,20 @@ static struct ahash_engine_alg algs_md5[] = {
 			.digestsize = MD5_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "hmac(md5)",
 				.cra_driver_name = "stm32-hmac-md5",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_hmac_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	}
 };
@@ -1338,21 +1336,20 @@ static struct ahash_engine_alg algs_sha1[] = {
 			.digestsize = SHA1_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "stm32-sha1",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1368,21 +1365,20 @@ static struct ahash_engine_alg algs_sha1[] = {
 			.digestsize = SHA1_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "hmac(sha1)",
 				.cra_driver_name = "stm32-hmac-sha1",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_hmac_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 };
@@ -1400,21 +1396,20 @@ static struct ahash_engine_alg algs_sha224[] = {
 			.digestsize = SHA224_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "sha224",
 				.cra_driver_name = "stm32-sha224",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1430,21 +1425,20 @@ static struct ahash_engine_alg algs_sha224[] = {
 			.digestsize = SHA224_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "hmac(sha224)",
 				.cra_driver_name = "stm32-hmac-sha224",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_hmac_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 };
@@ -1462,21 +1456,20 @@ static struct ahash_engine_alg algs_sha256[] = {
 			.digestsize = SHA256_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "sha256",
 				.cra_driver_name = "stm32-sha256",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1492,21 +1485,20 @@ static struct ahash_engine_alg algs_sha256[] = {
 			.digestsize = SHA256_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "hmac(sha256)",
 				.cra_driver_name = "stm32-hmac-sha256",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_hmac_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 };
@@ -1524,21 +1516,20 @@ static struct ahash_engine_alg algs_sha384_sha512[] = {
 			.digestsize = SHA384_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "sha384",
 				.cra_driver_name = "stm32-sha384",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1554,21 +1545,20 @@ static struct ahash_engine_alg algs_sha384_sha512[] = {
 			.digestsize = SHA384_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "hmac(sha384)",
 				.cra_driver_name = "stm32-hmac-sha384",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_hmac_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1583,21 +1573,20 @@ static struct ahash_engine_alg algs_sha384_sha512[] = {
 			.digestsize = SHA512_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "sha512",
 				.cra_driver_name = "stm32-sha512",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1613,21 +1602,20 @@ static struct ahash_engine_alg algs_sha384_sha512[] = {
 			.digestsize = SHA512_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "hmac(sha512)",
 				.cra_driver_name = "stm32-hmac-sha512",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_hmac_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 };
@@ -1645,21 +1633,20 @@ static struct ahash_engine_alg algs_sha3[] = {
 			.digestsize = SHA3_224_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "sha3-224",
 				.cra_driver_name = "stm32-sha3-224",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA3_224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_sha3_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1675,21 +1662,20 @@ static struct ahash_engine_alg algs_sha3[] = {
 			.digestsize = SHA3_224_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "hmac(sha3-224)",
 				.cra_driver_name = "stm32-hmac-sha3-224",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA3_224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_sha3_hmac_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1704,21 +1690,20 @@ static struct ahash_engine_alg algs_sha3[] = {
 			.digestsize = SHA3_256_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "sha3-256",
 				.cra_driver_name = "stm32-sha3-256",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA3_256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_sha3_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1734,21 +1719,20 @@ static struct ahash_engine_alg algs_sha3[] = {
 			.digestsize = SHA3_256_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "hmac(sha3-256)",
 				.cra_driver_name = "stm32-hmac-sha3-256",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA3_256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_sha3_hmac_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1763,21 +1747,20 @@ static struct ahash_engine_alg algs_sha3[] = {
 			.digestsize = SHA3_384_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "sha3-384",
 				.cra_driver_name = "stm32-sha3-384",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA3_384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_sha3_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1793,21 +1776,20 @@ static struct ahash_engine_alg algs_sha3[] = {
 			.digestsize = SHA3_384_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "hmac(sha3-384)",
 				.cra_driver_name = "stm32-hmac-sha3-384",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA3_384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_sha3_hmac_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1822,21 +1804,20 @@ static struct ahash_engine_alg algs_sha3[] = {
 			.digestsize = SHA3_512_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "sha3-512",
 				.cra_driver_name = "stm32-sha3-512",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA3_512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_sha3_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	},
 	{
@@ -1852,21 +1833,20 @@ static struct ahash_engine_alg algs_sha3[] = {
 			.digestsize = SHA3_512_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
 				.cra_name = "hmac(sha3-512)",
 				.cra_driver_name = "stm32-hmac-sha3-512",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA3_512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
-				.cra_alignmask = 3,
 				.cra_init = stm32_hash_cra_sha3_hmac_init,
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
 		},
 		.op = {
 			.do_one_request = stm32_hash_one_request,
 		},
 	}
 };
-- 
2.42.0

