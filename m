Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8175C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 09:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiKVJ2x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 04:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiKVJ2s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 04:28:48 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1171F2792D
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 01:28:41 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oxPa2-00H2mk-FD; Tue, 22 Nov 2022 17:28:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Nov 2022 17:28:38 +0800
Date:   Tue, 22 Nov 2022 17:28:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Longfang Liu <liulongfang@huawei.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon/hpre - Use helper to set reqsize
Message-ID: <Y3yWRkisp1VmuBLZ@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value of reqsize must only be changed through the helper.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index ef02dadd6217..5f6d363c9435 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -740,6 +740,8 @@ static int hpre_dh_init_tfm(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
+	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ);
+
 	return hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
 }
 
@@ -1165,6 +1167,9 @@ static int hpre_rsa_init_tfm(struct crypto_akcipher *tfm)
 		return PTR_ERR(ctx->rsa.soft_tfm);
 	}
 
+	akcipher_set_reqsize(tfm, sizeof(struct hpre_asym_request) +
+				  HPRE_ALIGN_SZ);
+
 	ret = hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
 	if (ret)
 		crypto_free_akcipher(ctx->rsa.soft_tfm);
@@ -1617,6 +1622,8 @@ static int hpre_ecdh_nist_p192_init_tfm(struct crypto_kpp *tfm)
 
 	ctx->curve_id = ECC_CURVE_NIST_P192;
 
+	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ);
+
 	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
 }
 
@@ -1626,6 +1633,8 @@ static int hpre_ecdh_nist_p256_init_tfm(struct crypto_kpp *tfm)
 
 	ctx->curve_id = ECC_CURVE_NIST_P256;
 
+	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ);
+
 	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
 }
 
@@ -1635,6 +1644,8 @@ static int hpre_ecdh_nist_p384_init_tfm(struct crypto_kpp *tfm)
 
 	ctx->curve_id = ECC_CURVE_NIST_P384;
 
+	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ);
+
 	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
 }
 
@@ -1961,6 +1972,8 @@ static int hpre_curve25519_init_tfm(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
+	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ);
+
 	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
 }
 
@@ -1981,7 +1994,6 @@ static struct akcipher_alg rsa = {
 	.max_size = hpre_rsa_max_size,
 	.init = hpre_rsa_init_tfm,
 	.exit = hpre_rsa_exit_tfm,
-	.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
 	.base = {
 		.cra_ctxsize = sizeof(struct hpre_ctx),
 		.cra_priority = HPRE_CRYPTO_ALG_PRI,
@@ -1998,7 +2010,6 @@ static struct kpp_alg dh = {
 	.max_size = hpre_dh_max_size,
 	.init = hpre_dh_init_tfm,
 	.exit = hpre_dh_exit_tfm,
-	.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
 	.base = {
 		.cra_ctxsize = sizeof(struct hpre_ctx),
 		.cra_priority = HPRE_CRYPTO_ALG_PRI,
@@ -2016,7 +2027,6 @@ static struct kpp_alg ecdh_curves[] = {
 		.max_size = hpre_ecdh_max_size,
 		.init = hpre_ecdh_nist_p192_init_tfm,
 		.exit = hpre_ecdh_exit_tfm,
-		.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
 		.base = {
 			.cra_ctxsize = sizeof(struct hpre_ctx),
 			.cra_priority = HPRE_CRYPTO_ALG_PRI,
@@ -2031,7 +2041,6 @@ static struct kpp_alg ecdh_curves[] = {
 		.max_size = hpre_ecdh_max_size,
 		.init = hpre_ecdh_nist_p256_init_tfm,
 		.exit = hpre_ecdh_exit_tfm,
-		.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
 		.base = {
 			.cra_ctxsize = sizeof(struct hpre_ctx),
 			.cra_priority = HPRE_CRYPTO_ALG_PRI,
@@ -2046,7 +2055,6 @@ static struct kpp_alg ecdh_curves[] = {
 		.max_size = hpre_ecdh_max_size,
 		.init = hpre_ecdh_nist_p384_init_tfm,
 		.exit = hpre_ecdh_exit_tfm,
-		.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
 		.base = {
 			.cra_ctxsize = sizeof(struct hpre_ctx),
 			.cra_priority = HPRE_CRYPTO_ALG_PRI,
@@ -2064,7 +2072,6 @@ static struct kpp_alg curve25519_alg = {
 	.max_size = hpre_curve25519_max_size,
 	.init = hpre_curve25519_init_tfm,
 	.exit = hpre_curve25519_exit_tfm,
-	.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
 	.base = {
 		.cra_ctxsize = sizeof(struct hpre_ctx),
 		.cra_priority = HPRE_CRYPTO_ALG_PRI,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
