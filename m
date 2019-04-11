Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB39C282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAD5F2184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfDKIvC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:02 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41204 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbfDKIvC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:02 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQC-0003K3-BV
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:00 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQC-0006ls-24; Thu, 11 Apr 2019 16:51:00 +0800
Subject: [PATCH 4/24] crypto: atmel - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQC-0006ls-24@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:00 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.

This patch also removes the bogus CFB 3DES modes that only work
with a short 3DES key not otherwise allowed by the crypto API.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/atmel-tdes.c |  103 ++++----------------------------------------
 1 file changed, 10 insertions(+), 93 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 65bf1a299562..12492d932ad7 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -801,19 +801,16 @@ static int atmel_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 {
 	struct atmel_tdes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 	const char *alg_name;
+	u32 flags;
+	int err;
 
 	alg_name = crypto_tfm_alg_name(crypto_ablkcipher_tfm(tfm));
 
-	/*
-	 * HW bug in cfb 3-keys mode.
-	 */
-	if (!ctx->dd->caps.has_cfb_3keys && strstr(alg_name, "cfb")
-			&& (keylen != 2*DES_KEY_SIZE)) {
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	} else if ((keylen != 2*DES_KEY_SIZE) && (keylen != 3*DES_KEY_SIZE)) {
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
+	flags = crypto_ablkcipher_get_flags(tfm);
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(tfm, flags);
+		return err;
 	}
 
 	memcpy(ctx->key, key, keylen);
@@ -1060,7 +1057,7 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
 	.cra_u.ablkcipher = {
-		.min_keysize	= 2 * DES_KEY_SIZE,
+		.min_keysize	= 3 * DES_KEY_SIZE,
 		.max_keysize	= 3 * DES_KEY_SIZE,
 		.setkey		= atmel_tdes_setkey,
 		.encrypt	= atmel_tdes_ecb_encrypt,
@@ -1079,7 +1076,7 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
 	.cra_u.ablkcipher = {
-		.min_keysize	= 2*DES_KEY_SIZE,
+		.min_keysize	= 3*DES_KEY_SIZE,
 		.max_keysize	= 3*DES_KEY_SIZE,
 		.ivsize		= DES_BLOCK_SIZE,
 		.setkey		= atmel_tdes_setkey,
@@ -1088,86 +1085,6 @@ static struct crypto_alg tdes_algs[] = {
 	}
 },
 {
-	.cra_name		= "cfb(des3_ede)",
-	.cra_driver_name	= "atmel-cfb-tdes",
-	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= DES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct atmel_tdes_ctx),
-	.cra_alignmask		= 0x7,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= atmel_tdes_cra_init,
-	.cra_u.ablkcipher = {
-		.min_keysize	= 2*DES_KEY_SIZE,
-		.max_keysize	= 2*DES_KEY_SIZE,
-		.ivsize		= DES_BLOCK_SIZE,
-		.setkey		= atmel_tdes_setkey,
-		.encrypt	= atmel_tdes_cfb_encrypt,
-		.decrypt	= atmel_tdes_cfb_decrypt,
-	}
-},
-{
-	.cra_name		= "cfb8(des3_ede)",
-	.cra_driver_name	= "atmel-cfb8-tdes",
-	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= CFB8_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct atmel_tdes_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= atmel_tdes_cra_init,
-	.cra_u.ablkcipher = {
-		.min_keysize	= 2*DES_KEY_SIZE,
-		.max_keysize	= 2*DES_KEY_SIZE,
-		.ivsize		= DES_BLOCK_SIZE,
-		.setkey		= atmel_tdes_setkey,
-		.encrypt	= atmel_tdes_cfb8_encrypt,
-		.decrypt	= atmel_tdes_cfb8_decrypt,
-	}
-},
-{
-	.cra_name		= "cfb16(des3_ede)",
-	.cra_driver_name	= "atmel-cfb16-tdes",
-	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= CFB16_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct atmel_tdes_ctx),
-	.cra_alignmask		= 0x1,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= atmel_tdes_cra_init,
-	.cra_u.ablkcipher = {
-		.min_keysize	= 2*DES_KEY_SIZE,
-		.max_keysize	= 2*DES_KEY_SIZE,
-		.ivsize		= DES_BLOCK_SIZE,
-		.setkey		= atmel_tdes_setkey,
-		.encrypt	= atmel_tdes_cfb16_encrypt,
-		.decrypt	= atmel_tdes_cfb16_decrypt,
-	}
-},
-{
-	.cra_name		= "cfb32(des3_ede)",
-	.cra_driver_name	= "atmel-cfb32-tdes",
-	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= CFB32_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct atmel_tdes_ctx),
-	.cra_alignmask		= 0x3,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= atmel_tdes_cra_init,
-	.cra_u.ablkcipher = {
-		.min_keysize	= 2*DES_KEY_SIZE,
-		.max_keysize	= 2*DES_KEY_SIZE,
-		.ivsize		= DES_BLOCK_SIZE,
-		.setkey		= atmel_tdes_setkey,
-		.encrypt	= atmel_tdes_cfb32_encrypt,
-		.decrypt	= atmel_tdes_cfb32_decrypt,
-	}
-},
-{
 	.cra_name		= "ofb(des3_ede)",
 	.cra_driver_name	= "atmel-ofb-tdes",
 	.cra_priority		= 100,
@@ -1179,7 +1096,7 @@ static struct crypto_alg tdes_algs[] = {
 	.cra_module		= THIS_MODULE,
 	.cra_init		= atmel_tdes_cra_init,
 	.cra_u.ablkcipher = {
-		.min_keysize	= 2*DES_KEY_SIZE,
+		.min_keysize	= 3*DES_KEY_SIZE,
 		.max_keysize	= 3*DES_KEY_SIZE,
 		.ivsize		= DES_BLOCK_SIZE,
 		.setkey		= atmel_tdes_setkey,
