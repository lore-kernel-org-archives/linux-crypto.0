Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B541C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 10:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiKVKHB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 05:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiKVKHA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 05:07:00 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFB725C54
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 02:06:59 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oxQB6-00H4Aw-Jy; Tue, 22 Nov 2022 18:06:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Nov 2022 18:06:56 +0800
Date:   Tue, 22 Nov 2022 18:06:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: dh - Use helper to set reqsize
Message-ID: <Y3yfQKX1GVkfHOe0@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value of reqsize must only be changed through the helper.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/dh.c b/crypto/dh.c
index 99c3b2ef7adc..e39c1bde1ac0 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -318,6 +318,9 @@ static int dh_safe_prime_init_tfm(struct crypto_kpp *tfm)
 	if (IS_ERR(tfm_ctx->dh_tfm))
 		return PTR_ERR(tfm_ctx->dh_tfm);
 
+	kpp_set_reqsize(tfm, sizeof(struct kpp_request) +
+			     crypto_kpp_reqsize(tfm_ctx->dh_tfm));
+
 	return 0;
 }
 
@@ -593,7 +596,6 @@ static int __maybe_unused __dh_safe_prime_create(
 	inst->alg.max_size = dh_safe_prime_max_size;
 	inst->alg.init = dh_safe_prime_init_tfm;
 	inst->alg.exit = dh_safe_prime_exit_tfm;
-	inst->alg.reqsize = sizeof(struct kpp_request) + dh_alg->reqsize;
 	inst->alg.base.cra_priority = dh_alg->base.cra_priority;
 	inst->alg.base.cra_module = THIS_MODULE;
 	inst->alg.base.cra_ctxsize = sizeof(struct dh_safe_prime_tfm_ctx);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
