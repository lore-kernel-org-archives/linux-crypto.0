Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBA5C001DB
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbjHKJbA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjHKJai (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:38 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3A430D5
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:37 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTY-0020hp-CR; Fri, 11 Aug 2023 17:30:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:32 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:32 +0800
Subject: [PATCH 26/36] crypto: aspeed - Remove non-standard sha512 algorithms
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTY-0020hp-CR@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Algorithms must never be added to a driver unless there is a generic
implementation.  These truncated versions of sha512 slipped through.
Remove them as they are useless.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/aspeed/aspeed-hace-hash.c |  212 -------------------------------
 1 file changed, 212 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index abc459af2ac8..0b6e49c06eff 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -59,28 +59,6 @@ static const __be64 sha512_iv[8] = {
 	cpu_to_be64(SHA512_H6), cpu_to_be64(SHA512_H7)
 };
 
-static const __be32 sha512_224_iv[16] = {
-	cpu_to_be32(0xC8373D8CUL), cpu_to_be32(0xA24D5419UL),
-	cpu_to_be32(0x6699E173UL), cpu_to_be32(0xD6D4DC89UL),
-	cpu_to_be32(0xAEB7FA1DUL), cpu_to_be32(0x829CFF32UL),
-	cpu_to_be32(0x14D59D67UL), cpu_to_be32(0xCF9F2F58UL),
-	cpu_to_be32(0x692B6D0FUL), cpu_to_be32(0xA84DD47BUL),
-	cpu_to_be32(0x736FE377UL), cpu_to_be32(0x4289C404UL),
-	cpu_to_be32(0xA8859D3FUL), cpu_to_be32(0xC8361D6AUL),
-	cpu_to_be32(0xADE61211UL), cpu_to_be32(0xA192D691UL)
-};
-
-static const __be32 sha512_256_iv[16] = {
-	cpu_to_be32(0x94213122UL), cpu_to_be32(0x2CF72BFCUL),
-	cpu_to_be32(0xA35F559FUL), cpu_to_be32(0xC2644CC8UL),
-	cpu_to_be32(0x6BB89323UL), cpu_to_be32(0x51B1536FUL),
-	cpu_to_be32(0x19773896UL), cpu_to_be32(0xBDEA4059UL),
-	cpu_to_be32(0xE23E2896UL), cpu_to_be32(0xE3FF8EA8UL),
-	cpu_to_be32(0x251E5EBEUL), cpu_to_be32(0x92398653UL),
-	cpu_to_be32(0xFC99012BUL), cpu_to_be32(0xAAB8852CUL),
-	cpu_to_be32(0xDC2DB70EUL), cpu_to_be32(0xA22CC581UL)
-};
-
 /* The purpose of this padding is to ensure that the padded message is a
  * multiple of 512 bits (SHA1/SHA224/SHA256) or 1024 bits (SHA384/SHA512).
  * The bit "1" is appended at the end of the message followed by
@@ -765,62 +743,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 	return 0;
 }
 
-static int aspeed_sha512s_init(struct ahash_request *req)
-{
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-	struct aspeed_sha_hmac_ctx *bctx = tctx->base;
-
-	AHASH_DBG(hace_dev, "digest size: %d\n", crypto_ahash_digestsize(tfm));
-
-	rctx->cmd = HASH_CMD_ACC_MODE;
-	rctx->flags = 0;
-
-	switch (crypto_ahash_digestsize(tfm)) {
-	case SHA224_DIGEST_SIZE:
-		rctx->cmd |= HASH_CMD_SHA512_SER | HASH_CMD_SHA512_224 |
-			     HASH_CMD_SHA_SWAP;
-		rctx->flags |= SHA_FLAGS_SHA512_224;
-		rctx->digsize = SHA224_DIGEST_SIZE;
-		rctx->block_size = SHA512_BLOCK_SIZE;
-		rctx->sha_iv = sha512_224_iv;
-		rctx->ivsize = 64;
-		memcpy(rctx->digest, sha512_224_iv, rctx->ivsize);
-		break;
-	case SHA256_DIGEST_SIZE:
-		rctx->cmd |= HASH_CMD_SHA512_SER | HASH_CMD_SHA512_256 |
-			     HASH_CMD_SHA_SWAP;
-		rctx->flags |= SHA_FLAGS_SHA512_256;
-		rctx->digsize = SHA256_DIGEST_SIZE;
-		rctx->block_size = SHA512_BLOCK_SIZE;
-		rctx->sha_iv = sha512_256_iv;
-		rctx->ivsize = 64;
-		memcpy(rctx->digest, sha512_256_iv, rctx->ivsize);
-		break;
-	default:
-		dev_warn(tctx->hace_dev->dev, "digest size %d not support\n",
-			 crypto_ahash_digestsize(tfm));
-		return -EINVAL;
-	}
-
-	rctx->bufcnt = 0;
-	rctx->total = 0;
-	rctx->digcnt[0] = 0;
-	rctx->digcnt[1] = 0;
-
-	/* HMAC init */
-	if (tctx->flags & SHA_FLAGS_HMAC) {
-		rctx->digcnt[0] = rctx->block_size;
-		rctx->bufcnt = rctx->block_size;
-		memcpy(rctx->buffer, bctx->ipad, rctx->block_size);
-		rctx->flags |= SHA_FLAGS_HMAC;
-	}
-
-	return 0;
-}
-
 static int aspeed_sham_digest(struct ahash_request *req)
 {
 	return aspeed_sham_init(req) ? : aspeed_sham_finup(req);
@@ -1195,70 +1117,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 			.do_one_request = aspeed_ahash_do_one,
 		},
 	},
-	{
-		.alg.ahash.base = {
-			.init	= aspeed_sha512s_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA224_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "sha512_224",
-					.cra_driver_name	= "aspeed-sha512_224",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA512_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg.ahash.base = {
-			.init	= aspeed_sha512s_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA256_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "sha512_256",
-					.cra_driver_name	= "aspeed-sha512_256",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA512_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
 	{
 		.alg_base = "sha384",
 		.alg.ahash.base = {
@@ -1329,76 +1187,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 			.do_one_request = aspeed_ahash_do_one,
 		},
 	},
-	{
-		.alg_base = "sha512_224",
-		.alg.ahash.base = {
-			.init	= aspeed_sha512s_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA224_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha512_224)",
-					.cra_driver_name	= "aspeed-hmac-sha512_224",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA512_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha512_256",
-		.alg.ahash.base = {
-			.init	= aspeed_sha512s_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA256_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha512_256)",
-					.cra_driver_name	= "aspeed-hmac-sha512_256",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA512_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
 };
 
 void aspeed_unregister_hace_hash_algs(struct aspeed_hace_dev *hace_dev)
