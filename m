Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243FBC25B67
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 10:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjJ0KfT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjJ0KfT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 06:35:19 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE693186
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 03:35:16 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qwKBL-00Be7u-B6; Fri, 27 Oct 2023 18:35:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Oct 2023 18:35:17 +0800
Date:   Fri, 27 Oct 2023 18:35:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH] crypto: marvell/cesa - Silence gcc format-truncation false
 positive warnings
Message-ID: <ZTuSZRDELWk/keOX@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The heuristics used by gcc triggers false positive truncation
warnings in hifn_alg_alloc.  The warnings are false positives
because nengines is at most 2.

Make the buffer bigger and change the snprintf to use unsigned
integers to eliminate these warnings.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 5744df30c838..5fd31ba715c2 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -488,7 +488,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 
 	for (i = 0; i < caps->nengines; i++) {
 		struct mv_cesa_engine *engine = &cesa->engines[i];
-		char res_name[7];
+		char res_name[16];
 
 		engine->id = i;
 		spin_lock_init(&engine->lock);
@@ -509,7 +509,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		 * Not all platforms can gate the CESA clocks: do not complain
 		 * if the clock does not exist.
 		 */
-		snprintf(res_name, sizeof(res_name), "cesa%d", i);
+		snprintf(res_name, sizeof(res_name), "cesa%u", i);
 		engine->clk = devm_clk_get(dev, res_name);
 		if (IS_ERR(engine->clk)) {
 			engine->clk = devm_clk_get(dev, NULL);
@@ -517,7 +517,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 				engine->clk = NULL;
 		}
 
-		snprintf(res_name, sizeof(res_name), "cesaz%d", i);
+		snprintf(res_name, sizeof(res_name), "cesaz%u", i);
 		engine->zclk = devm_clk_get(dev, res_name);
 		if (IS_ERR(engine->zclk))
 			engine->zclk = NULL;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
