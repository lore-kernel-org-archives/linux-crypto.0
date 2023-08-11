Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88063C04A6A
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbjHKJ3y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234926AbjHKJ3x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:29:53 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F1A26B2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:29:53 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOSq-0020Y0-8p; Fri, 11 Aug 2023 17:29:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:29:48 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:29:48 +0800
Subject: [PATCH 5/36] crypto: sl3516 - Remove prepare/unprepare request
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOSq-0020Y0-8p@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks for prepare and unprepare request in crypto_engine
is superfluous.  They can be done directly from do_one_request.

Move the code into do_one_request and remove the unused callbacks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/gemini/sl3516-ce-cipher.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index 14d0d83d388d..0232f847785a 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -336,8 +336,6 @@ int sl3516_ce_cipher_init(struct crypto_tfm *tfm)
 		 crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)));
 
 	op->enginectx.op.do_one_request = sl3516_ce_handle_cipher_request;
-	op->enginectx.op.prepare_request = NULL;
-	op->enginectx.op.unprepare_request = NULL;
 
 	err = pm_runtime_get_sync(op->ce->dev);
 	if (err < 0)
