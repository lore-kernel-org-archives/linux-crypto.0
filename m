Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0AFCDB482
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Oct 2023 15:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347288AbjJLPI1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Oct 2023 11:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347295AbjJLPIX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2023 11:08:23 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A578ED8
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 08:08:17 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qqxIK-006Qdx-BN; Thu, 12 Oct 2023 23:08:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Oct 2023 23:08:17 +0800
Date:   Thu, 12 Oct 2023 23:08:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] crypto: hifn_795x - Silence gcc format-truncation false
 positive warnings
Message-ID: <ZSgL4ZfBumB1WL4a@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The heuristics used by gcc triggers false positive truncation
warnings in hifn_alg_alloc.  The warning triggered by the strings
here are clearly false positives (see
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=95755).

Add checks on snprintf calls to silence these warnings, including
the one for cra_driver_name even though it does not currently trigger
a gcc warning.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 8e4a49b7ab4f..7bddc3c786c1 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2393,9 +2393,13 @@ static int hifn_alg_alloc(struct hifn_device *dev, const struct hifn_alg_templat
 	alg->alg = t->skcipher;
 	alg->alg.init = hifn_init_tfm;
 
-	snprintf(alg->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", t->name);
-	snprintf(alg->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s-%s",
-		 t->drv_name, dev->name);
+	err = -EINVAL;
+	if (snprintf(alg->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "%s", t->name) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_alg;
+	if (snprintf(alg->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "%s-%s", t->drv_name, dev->name) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_alg;
 
 	alg->alg.base.cra_priority = 300;
 	alg->alg.base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC;
@@ -2411,6 +2415,7 @@ static int hifn_alg_alloc(struct hifn_device *dev, const struct hifn_alg_templat
 	err = crypto_register_skcipher(&alg->alg);
 	if (err) {
 		list_del(&alg->entry);
+out_free_alg:
 		kfree(alg);
 	}
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
