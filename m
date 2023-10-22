Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC481C25B43
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjJVIS4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjJVISs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0FFE8
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE139C43391
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962725;
        bh=/Cfq0RY4zUnrDGJwojsl3Ln90Xniz2usLN5xUMqzG1Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=J/+606EtxfLsJD5ithWjIVsvs7SjU+AQUXcISp7CZgnG8m8U2+4D8U0m6qcK5cr5q
         yExlaXvUx1qpTApOgKTGy4uttF+stam/XdBcSZJEO1R+2+IMbhNDx0LjoAFEjT67gs
         AvQmWUl1UzMOXAfbYI4ArWgFZEN26eQLxBjl+Ye5cNiRav6EZmANS27I2fG20z7v/S
         tKAZa0f2vKdDHfuIIF5gMZb5butjvlPQmHanez1j0RyFs+/TFoswSIY/penRcsTT2Z
         UBOzUzhkZ2atEt6mAneCyRL2XN8p4f+z1ev03kpbZbJ1kWinYU2Ngnx9+VAQTT7497
         nCsynL0XNifRg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 10/30] crypto: omap-sham - stop setting alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:40 -0700
Message-ID: <20231022081100.123613-11-ebiggers@kernel.org>
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
makes the omap-sham driver no longer use it.  This driver did actually
rely on it, but only for storing to the result buffer using __u32 stores
in omap_sham_copy_ready_hash().  This patch makes
omap_sham_copy_ready_hash() use put_unaligned() instead.  (It really
should use a specific endianness, but that's an existing bug.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/omap-sham.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a6b4a0b3ace30..c4d77d8533313 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -349,24 +349,24 @@ static void omap_sham_copy_ready_hash(struct ahash_request *req)
 		break;
 	case FLAGS_MODE_SHA512:
 		d = SHA512_DIGEST_SIZE / sizeof(u32);
 		break;
 	default:
 		d = 0;
 	}
 
 	if (big_endian)
 		for (i = 0; i < d; i++)
-			hash[i] = be32_to_cpup((__be32 *)in + i);
+			put_unaligned(be32_to_cpup((__be32 *)in + i), &hash[i]);
 	else
 		for (i = 0; i < d; i++)
-			hash[i] = le32_to_cpup((__le32 *)in + i);
+			put_unaligned(le32_to_cpup((__le32 *)in + i), &hash[i]);
 }
 
 static void omap_sham_write_ctrl_omap2(struct omap_sham_dev *dd, size_t length,
 				 int final, int dma)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
 	u32 val = length << 5, mask;
 
 	if (likely(ctx->digcnt))
 		omap_sham_write(dd, SHA_REG_DIGCNT(dd), ctx->digcnt);
@@ -1428,21 +1428,20 @@ static struct ahash_engine_alg algs_sha1_md5[] = {
 	.base.halg.digestsize	= SHA1_DIGEST_SIZE,
 	.base.halg.base	= {
 		.cra_name		= "sha1",
 		.cra_driver_name	= "omap-sha1",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 {
 	.base.init		= omap_sham_init,
 	.base.update		= omap_sham_update,
 	.base.final		= omap_sham_final,
@@ -1451,21 +1450,20 @@ static struct ahash_engine_alg algs_sha1_md5[] = {
 	.base.halg.digestsize	= MD5_DIGEST_SIZE,
 	.base.halg.base	= {
 		.cra_name		= "md5",
 		.cra_driver_name	= "omap-md5",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 {
 	.base.init		= omap_sham_init,
 	.base.update		= omap_sham_update,
 	.base.final		= omap_sham_final,
@@ -1476,21 +1474,20 @@ static struct ahash_engine_alg algs_sha1_md5[] = {
 	.base.halg.base	= {
 		.cra_name		= "hmac(sha1)",
 		.cra_driver_name	= "omap-hmac-sha1",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
 					sizeof(struct omap_sham_hmac_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_sha1_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 {
 	.base.init		= omap_sham_init,
 	.base.update		= omap_sham_update,
 	.base.final		= omap_sham_final,
@@ -1501,21 +1498,20 @@ static struct ahash_engine_alg algs_sha1_md5[] = {
 	.base.halg.base	= {
 		.cra_name		= "hmac(md5)",
 		.cra_driver_name	= "omap-hmac-md5",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
 					sizeof(struct omap_sham_hmac_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_md5_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 }
 };
 
 /* OMAP4 has some algs in addition to what OMAP2 has */
 static struct ahash_engine_alg algs_sha224_sha256[] = {
@@ -1528,21 +1524,20 @@ static struct ahash_engine_alg algs_sha224_sha256[] = {
 	.base.halg.digestsize	= SHA224_DIGEST_SIZE,
 	.base.halg.base	= {
 		.cra_name		= "sha224",
 		.cra_driver_name	= "omap-sha224",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA224_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 {
 	.base.init		= omap_sham_init,
 	.base.update		= omap_sham_update,
 	.base.final		= omap_sham_final,
@@ -1551,21 +1546,20 @@ static struct ahash_engine_alg algs_sha224_sha256[] = {
 	.base.halg.digestsize	= SHA256_DIGEST_SIZE,
 	.base.halg.base	= {
 		.cra_name		= "sha256",
 		.cra_driver_name	= "omap-sha256",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 {
 	.base.init		= omap_sham_init,
 	.base.update		= omap_sham_update,
 	.base.final		= omap_sham_final,
@@ -1576,21 +1570,20 @@ static struct ahash_engine_alg algs_sha224_sha256[] = {
 	.base.halg.base	= {
 		.cra_name		= "hmac(sha224)",
 		.cra_driver_name	= "omap-hmac-sha224",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA224_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
 					sizeof(struct omap_sham_hmac_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_sha224_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 {
 	.base.init		= omap_sham_init,
 	.base.update		= omap_sham_update,
 	.base.final		= omap_sham_final,
@@ -1601,21 +1594,20 @@ static struct ahash_engine_alg algs_sha224_sha256[] = {
 	.base.halg.base	= {
 		.cra_name		= "hmac(sha256)",
 		.cra_driver_name	= "omap-hmac-sha256",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
 					sizeof(struct omap_sham_hmac_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_sha256_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 };
 
 static struct ahash_engine_alg algs_sha384_sha512[] = {
 {
@@ -1627,21 +1619,20 @@ static struct ahash_engine_alg algs_sha384_sha512[] = {
 	.base.halg.digestsize	= SHA384_DIGEST_SIZE,
 	.base.halg.base	= {
 		.cra_name		= "sha384",
 		.cra_driver_name	= "omap-sha384",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA384_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 {
 	.base.init		= omap_sham_init,
 	.base.update		= omap_sham_update,
 	.base.final		= omap_sham_final,
@@ -1650,21 +1641,20 @@ static struct ahash_engine_alg algs_sha384_sha512[] = {
 	.base.halg.digestsize	= SHA512_DIGEST_SIZE,
 	.base.halg.base	= {
 		.cra_name		= "sha512",
 		.cra_driver_name	= "omap-sha512",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA512_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 {
 	.base.init		= omap_sham_init,
 	.base.update		= omap_sham_update,
 	.base.final		= omap_sham_final,
@@ -1675,21 +1665,20 @@ static struct ahash_engine_alg algs_sha384_sha512[] = {
 	.base.halg.base	= {
 		.cra_name		= "hmac(sha384)",
 		.cra_driver_name	= "omap-hmac-sha384",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA384_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
 					sizeof(struct omap_sham_hmac_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_sha384_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 {
 	.base.init		= omap_sham_init,
 	.base.update		= omap_sham_update,
 	.base.final		= omap_sham_final,
@@ -1700,21 +1689,20 @@ static struct ahash_engine_alg algs_sha384_sha512[] = {
 	.base.halg.base	= {
 		.cra_name		= "hmac(sha512)",
 		.cra_driver_name	= "omap-hmac-sha512",
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA512_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
 					sizeof(struct omap_sham_hmac_ctx),
-		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_sha512_init,
 		.cra_exit		= omap_sham_cra_exit,
 	},
 	.op.do_one_request = omap_sham_hash_one_req,
 },
 };
 
 static void omap_sham_done_task(unsigned long data)
 {
-- 
2.42.0

