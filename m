Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2A5C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 04:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4879C20737
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 04:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgGBEgw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 00:36:52 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37168 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgGBEgw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 00:36:52 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jqqxs-0000KZ-4h; Thu, 02 Jul 2020 14:36:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Jul 2020 14:36:48 +1000
Date:   Thu, 2 Jul 2020 14:36:48 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH] crypto: caam - Remove broken arc4 support
Message-ID: <20200702043648.GA21823@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The arc4 algorithm requires storing state in the request context
in order to allow more than one encrypt/decrypt operation.  As this
driver does not seem to do that, it means that using it for more
than one operation is broken.

Fixes: eaed71a44ad9 ("crypto: caam - add ecb(*) support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b2f9882bc010f..797bff9b93182 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -810,12 +810,6 @@ static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
 	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
 }
 
-static int arc4_skcipher_setkey(struct crypto_skcipher *skcipher,
-				const u8 *key, unsigned int keylen)
-{
-	return skcipher_setkey(skcipher, key, keylen, 0);
-}
-
 static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
@@ -1967,21 +1961,6 @@ static struct caam_skcipher_alg driver_algs[] = {
 		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_ECB,
 	},
-	{
-		.skcipher = {
-			.base = {
-				.cra_name = "ecb(arc4)",
-				.cra_driver_name = "ecb-arc4-caam",
-				.cra_blocksize = ARC4_BLOCK_SIZE,
-			},
-			.setkey = arc4_skcipher_setkey,
-			.encrypt = skcipher_encrypt,
-			.decrypt = skcipher_decrypt,
-			.min_keysize = ARC4_MIN_KEY_SIZE,
-			.max_keysize = ARC4_MAX_KEY_SIZE,
-		},
-		.caam.class1_alg_type = OP_ALG_ALGSEL_ARC4 | OP_ALG_AAI_ECB,
-	},
 };
 
 static struct caam_aead_alg driver_aeads[] = {
@@ -3457,7 +3436,6 @@ int caam_algapi_init(struct device *ctrldev)
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	int i = 0, err = 0;
 	u32 aes_vid, aes_inst, des_inst, md_vid, md_inst, ccha_inst, ptha_inst;
-	u32 arc4_inst;
 	unsigned int md_limit = SHA512_DIGEST_SIZE;
 	bool registered = false, gcm_support;
 
@@ -3477,8 +3455,6 @@ int caam_algapi_init(struct device *ctrldev)
 			   CHA_ID_LS_DES_SHIFT;
 		aes_inst = cha_inst & CHA_ID_LS_AES_MASK;
 		md_inst = (cha_inst & CHA_ID_LS_MD_MASK) >> CHA_ID_LS_MD_SHIFT;
-		arc4_inst = (cha_inst & CHA_ID_LS_ARC4_MASK) >>
-			    CHA_ID_LS_ARC4_SHIFT;
 		ccha_inst = 0;
 		ptha_inst = 0;
 
@@ -3499,7 +3475,6 @@ int caam_algapi_init(struct device *ctrldev)
 		md_inst = mdha & CHA_VER_NUM_MASK;
 		ccha_inst = rd_reg32(&priv->ctrl->vreg.ccha) & CHA_VER_NUM_MASK;
 		ptha_inst = rd_reg32(&priv->ctrl->vreg.ptha) & CHA_VER_NUM_MASK;
-		arc4_inst = rd_reg32(&priv->ctrl->vreg.afha) & CHA_VER_NUM_MASK;
 
 		gcm_support = aesa & CHA_VER_MISC_AES_GCM;
 	}
@@ -3522,10 +3497,6 @@ int caam_algapi_init(struct device *ctrldev)
 		if (!aes_inst && (alg_sel == OP_ALG_ALGSEL_AES))
 				continue;
 
-		/* Skip ARC4 algorithms if not supported by device */
-		if (!arc4_inst && alg_sel == OP_ALG_ALGSEL_ARC4)
-			continue;
-
 		/*
 		 * Check support for AES modes not available
 		 * on LP devices.
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index 60e2a54c19f11..c3c22a8de4c00 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -43,7 +43,6 @@
 #include <crypto/akcipher.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
-#include <crypto/arc4.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/rsa.h>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
