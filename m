Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6375DC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 09:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiKVJbD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 04:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiKVJbC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 04:31:02 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713B662F1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 01:31:01 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oxPcI-00H2tz-Oh; Tue, 22 Nov 2022 17:30:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Nov 2022 17:30:58 +0800
Date:   Tue, 22 Nov 2022 17:30:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>, qat-linux@intel.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: qat - Use helper to set reqsize
Message-ID: <Y3yW0jaRbzC44S4z@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value of reqsize must only be changed through the helper.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 94a26702aeae..935a7e012946 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -494,6 +494,8 @@ static int qat_dh_init_tfm(struct crypto_kpp *tfm)
 	if (!inst)
 		return -EINVAL;
 
+	kpp_set_reqsize(tfm, sizeof(struct qat_asym_request) + 64);
+
 	ctx->p_size = 0;
 	ctx->g2 = false;
 	ctx->inst = inst;
@@ -1230,6 +1232,8 @@ static int qat_rsa_init_tfm(struct crypto_akcipher *tfm)
 	if (!inst)
 		return -EINVAL;
 
+	akcipher_set_reqsize(tfm, sizeof(struct qat_asym_request) + 64);
+
 	ctx->key_sz = 0;
 	ctx->inst = inst;
 	return 0;
@@ -1252,7 +1256,6 @@ static struct akcipher_alg rsa = {
 	.max_size = qat_rsa_max_size,
 	.init = qat_rsa_init_tfm,
 	.exit = qat_rsa_exit_tfm,
-	.reqsize = sizeof(struct qat_asym_request) + 64,
 	.base = {
 		.cra_name = "rsa",
 		.cra_driver_name = "qat-rsa",
@@ -1269,7 +1272,6 @@ static struct kpp_alg dh = {
 	.max_size = qat_dh_max_size,
 	.init = qat_dh_init_tfm,
 	.exit = qat_dh_exit_tfm,
-	.reqsize = sizeof(struct qat_asym_request) + 64,
 	.base = {
 		.cra_name = "dh",
 		.cra_driver_name = "qat-dh",
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
