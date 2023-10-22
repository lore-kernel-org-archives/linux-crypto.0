Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC042CDB474
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjJVISx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjJVISr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93EBD6
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563EBC433C8
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962725;
        bh=nsEGWgLIg9i79Cc2Ebg5dQoQdi0mU0M4U4wWady7BaU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZqexhcWw1lK/dgjHYUsfAu3X6h4l0HQFqh9bncy/NxyPq3+6srOTlc7fVYrk73o2A
         jSNgu3wdVYZ7Sl08pD9qmmgX/aA7cKxol9+8519whluBhgsTvzkt/BDSI6BuxNPkth
         dMXK1H4blvzy4n4OSAn+Q3legvna3OuyRPclOweKXw1rUZBkP618/u7Fth5F92F7MS
         fH5ribo8AJvuYhq5KBNcyKA30LvvzMWgpNbC2Dg6t0wroNuW+wcZHhWhfGghMPr/2R
         azDmFrC6Q6v/qQ6tgAkIFSUS69356FjbcXg6IwPvBkv9gnH6Td/JPQH0nvj7zPWEqi
         HpTz22UDdN5+w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 08/30] crypto: s5p-sss - remove unnecessary alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:38 -0700
Message-ID: <20231022081100.123613-9-ebiggers@kernel.org>
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
makes the s5p-sss driver no longer use it.  This driver didn't actually
rely on it; it only writes to the result buffer in
s5p_hash_copy_result(), simply using memcpy().  And this driver only
supports unkeyed hash algorithms, so the key buffer need not be
considered.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/s5p-sss.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index fe8cf9ba8005c..43b840c7b743f 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -217,23 +217,20 @@
 #define HASH_FLAGS_FINAL	1
 #define HASH_FLAGS_DMA_ACTIVE	2
 #define HASH_FLAGS_OUTPUT_READY	3
 #define HASH_FLAGS_DMA_READY	4
 #define HASH_FLAGS_SGS_COPIED	5
 #define HASH_FLAGS_SGS_ALLOCED	6
 
 /* HASH HW constants */
 #define BUFLEN			HASH_BLOCK_SIZE
 
-#define SSS_HASH_DMA_LEN_ALIGN	8
-#define SSS_HASH_DMA_ALIGN_MASK	(SSS_HASH_DMA_LEN_ALIGN - 1)
-
 #define SSS_HASH_QUEUE_LENGTH	10
 
 /**
  * struct samsung_aes_variant - platform specific SSS driver data
  * @aes_offset: AES register offset from SSS module's base.
  * @hash_offset: HASH register offset from SSS module's base.
  * @clk_names: names of clocks needed to run SSS IP
  *
  * Specifies platform specific configuration of SSS module.
  * Note: A structure for driver specific platform data is used for future
@@ -1739,21 +1736,20 @@ static struct ahash_alg algs_sha1_md5_sha256[] = {
 	.halg.digestsize	= SHA1_DIGEST_SIZE,
 	.halg.base	= {
 		.cra_name		= "sha1",
 		.cra_driver_name	= "exynos-sha1",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_ASYNC |
 					  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= HASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
-		.cra_alignmask		= SSS_HASH_DMA_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= s5p_hash_cra_init,
 		.cra_exit		= s5p_hash_cra_exit,
 	}
 },
 {
 	.init		= s5p_hash_init,
 	.update		= s5p_hash_update,
 	.final		= s5p_hash_final,
 	.finup		= s5p_hash_finup,
@@ -1764,21 +1760,20 @@ static struct ahash_alg algs_sha1_md5_sha256[] = {
 	.halg.digestsize	= MD5_DIGEST_SIZE,
 	.halg.base	= {
 		.cra_name		= "md5",
 		.cra_driver_name	= "exynos-md5",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_ASYNC |
 					  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= HASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
-		.cra_alignmask		= SSS_HASH_DMA_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= s5p_hash_cra_init,
 		.cra_exit		= s5p_hash_cra_exit,
 	}
 },
 {
 	.init		= s5p_hash_init,
 	.update		= s5p_hash_update,
 	.final		= s5p_hash_final,
 	.finup		= s5p_hash_finup,
@@ -1789,21 +1784,20 @@ static struct ahash_alg algs_sha1_md5_sha256[] = {
 	.halg.digestsize	= SHA256_DIGEST_SIZE,
 	.halg.base	= {
 		.cra_name		= "sha256",
 		.cra_driver_name	= "exynos-sha256",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_ASYNC |
 					  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= HASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
-		.cra_alignmask		= SSS_HASH_DMA_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= s5p_hash_cra_init,
 		.cra_exit		= s5p_hash_cra_exit,
 	}
 }
 
 };
 
 static void s5p_set_aes(struct s5p_aes_dev *dev,
 			const u8 *key, const u8 *iv, const u8 *ctr,
-- 
2.42.0

