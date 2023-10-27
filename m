Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B5F0C25B67
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 10:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjJ0Kog (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjJ0Kog (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 06:44:36 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1B118A
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 03:44:34 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qwKKK-00BeIu-CD; Fri, 27 Oct 2023 18:44:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Oct 2023 18:44:34 +0800
Date:   Fri, 27 Oct 2023 18:44:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: n2 - Silence gcc format-truncation false positive
 warnings
Message-ID: <ZTuUkpyin4MGA3HX@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The heuristics used by gcc triggers false positive truncation
warnings in hifn_alg_alloc.

Add checks on snprintf calls to silence these warnings, including
the one for cra_driver_name even though it does not currently trigger
a gcc warning.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index d282ca9343bb..3a28254ab002 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1404,8 +1404,12 @@ static int __n2_register_one_hmac(struct n2_ahash_alg *n2ahash)
 	ahash->setkey = n2_hmac_async_setkey;
 
 	base = &ahash->halg.base;
-	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)", p->child_alg);
-	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "hmac-%s-n2", p->child_alg);
+	if (snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)",
+	 	     p->child_alg) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_p;
+	if (snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "hmac-%s-n2",
+		     p->child_alg) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_p;
 
 	base->cra_ctxsize = sizeof(struct n2_hmac_ctx);
 	base->cra_init = n2_hmac_cra_init;
@@ -1416,6 +1420,7 @@ static int __n2_register_one_hmac(struct n2_ahash_alg *n2ahash)
 	if (err) {
 		pr_err("%s alg registration failed\n", base->cra_name);
 		list_del(&p->derived.entry);
+out_free_p:
 		kfree(p);
 	} else {
 		pr_info("%s alg registered\n", base->cra_name);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
