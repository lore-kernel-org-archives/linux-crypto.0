Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5C6C282DA
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 270982184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfDKIvN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:13 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41244 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbfDKIvM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:12 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQN-0003Om-CL
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:11 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQN-0006nU-3e; Thu, 11 Apr 2019 16:51:11 +0800
Subject: [PATCH 14/24] crypto: ixp4xx - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQN-0006nU-3e@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:11 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ixp4xx_crypto.c |   64 +++++++++++++++++++++++++++++++++++------
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 5c4659b04d70..9bbde2f26cac 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -758,14 +758,6 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 			return -EINVAL;
 		}
 		cipher_cfg |= keylen_cfg;
-	} else if (cipher_cfg & MOD_3DES) {
-		const u32 *K = (const u32 *)key;
-		if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-			     !((K[2] ^ K[4]) | (K[3] ^ K[5]))))
-		{
-			*flags |= CRYPTO_TFM_RES_BAD_KEY_SCHED;
-			return -EINVAL;
-		}
 	} else {
 		u32 tmp[DES_EXPKEY_WORDS];
 		if (des_ekey(tmp, key) == 0) {
@@ -859,6 +851,19 @@ static int ablk_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	return ret;
 }
 
+static int ablk_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+			    unsigned int key_len)
+{
+	u32 flags = crypto_ablkcipher_get_flags(tfm);
+	int err;
+
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err))
+		crypto_ablkcipher_set_flags(tfm, flags);
+
+	return ablk_setkey(tfm, key, key_len);
+}
+
 static int ablk_rfc3686_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		unsigned int key_len)
 {
@@ -1175,6 +1180,43 @@ static int aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	return -EINVAL;
 }
 
+static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
+	u32 flags = CRYPTO_TFM_RES_BAD_KEY_LEN;
+	struct crypto_authenc_keys keys;
+	int err;
+
+	err = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (unlikely(err))
+		goto badkey;
+
+	err = -EINVAL;
+	if (keys.authkeylen > sizeof(ctx->authkey))
+		goto badkey;
+
+	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
+		goto badkey;
+
+	flags = crypto_aead_get_flags(tfm);
+	err = __des3_verify_key(&flags, keys.enckey);
+	if (unlikely(err))
+		goto badkey;
+
+	memcpy(ctx->authkey, keys.authkey, keys.authkeylen);
+	memcpy(ctx->enckey, keys.enckey, keys.enckeylen);
+	ctx->authkey_len = keys.authkeylen;
+	ctx->enckey_len = keys.enckeylen;
+
+	memzero_explicit(&keys, sizeof(keys));
+	return aead_setup(tfm, crypto_aead_authsize(tfm));
+badkey:
+	crypto_aead_set_flags(tfm, flags);
+	memzero_explicit(&keys, sizeof(keys));
+	return err;
+}
+
 static int aead_encrypt(struct aead_request *req)
 {
 	return aead_perform(req, 1, req->assoclen, req->cryptlen, req->iv);
@@ -1220,6 +1262,7 @@ static struct ixp_alg ixp4xx_algos[] = {
 			.min_keysize	= DES3_EDE_KEY_SIZE,
 			.max_keysize	= DES3_EDE_KEY_SIZE,
 			.ivsize		= DES3_EDE_BLOCK_SIZE,
+			.setkey		= ablk_des3_setkey,
 			}
 		}
 	},
@@ -1232,6 +1275,7 @@ static struct ixp_alg ixp4xx_algos[] = {
 		.cra_u		= { .ablkcipher = {
 			.min_keysize	= DES3_EDE_KEY_SIZE,
 			.max_keysize	= DES3_EDE_KEY_SIZE,
+			.setkey		= ablk_des3_setkey,
 			}
 		}
 	},
@@ -1313,6 +1357,7 @@ static struct ixp_aead_alg ixp4xx_aeads[] = {
 		},
 		.ivsize		= DES3_EDE_BLOCK_SIZE,
 		.maxauthsize	= MD5_DIGEST_SIZE,
+		.setkey		= des3_aead_setkey,
 	},
 	.hash = &hash_alg_md5,
 	.cfg_enc = CIPH_ENCR | MOD_3DES | MOD_CBC_ENC | KEYLEN_192,
@@ -1337,6 +1382,7 @@ static struct ixp_aead_alg ixp4xx_aeads[] = {
 		},
 		.ivsize		= DES3_EDE_BLOCK_SIZE,
 		.maxauthsize	= SHA1_DIGEST_SIZE,
+		.setkey		= des3_aead_setkey,
 	},
 	.hash = &hash_alg_sha1,
 	.cfg_enc = CIPH_ENCR | MOD_3DES | MOD_CBC_ENC | KEYLEN_192,
@@ -1443,7 +1489,7 @@ static int __init ixp_module_init(void)
 		/* authenc */
 		cra->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
 				      CRYPTO_ALG_ASYNC;
-		cra->setkey = aead_setkey;
+		cra->setkey = cra->setkey ?: aead_setkey;
 		cra->setauthsize = aead_setauthsize;
 		cra->encrypt = aead_encrypt;
 		cra->decrypt = aead_decrypt;
