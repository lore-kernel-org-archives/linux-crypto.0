Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4A0C25B6E
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 10:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345671AbjJ0KZv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345595AbjJ0KZu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 06:25:50 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EF110E
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 03:25:46 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qwK2A-00Bdnd-8R; Fri, 27 Oct 2023 18:25:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Oct 2023 18:25:48 +0800
Date:   Fri, 27 Oct 2023 18:25:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] crypto: ccree - Silence gcc format-truncation false positive
 warnings
Message-ID: <ZTuQLPxApI9K8wmv@gondor.apana.org.au>
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

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 109ffb375fc6..5ef39d682389 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -2569,9 +2569,13 @@ static struct cc_crypto_alg *cc_create_aead_alg(struct cc_alg_template *tmpl,
 
 	alg = &tmpl->template_aead;
 
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
-	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 tmpl->driver_name);
+	if (snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s",
+		     tmpl->name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+	if (snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		     tmpl->driver_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CC_CRA_PRIO;
 
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 2cd44d7457a4..d229e54fa935 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -1427,9 +1427,13 @@ static struct cc_crypto_alg *cc_create_alg(const struct cc_alg_template *tmpl,
 
 	memcpy(alg, &tmpl->template_skcipher, sizeof(*alg));
 
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
-	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 tmpl->driver_name);
+	if (snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s",
+		     tmpl->name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+	if (snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		     tmpl->driver_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CC_CRA_PRIO;
 	alg->base.cra_blocksize = tmpl->blocksize;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
