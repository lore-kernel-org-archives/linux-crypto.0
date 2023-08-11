Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C863AC04A6A
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbjHKJ3r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbjHKJ3r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:29:47 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FDC26BC
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:29:46 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOSj-0020XI-Uz; Fri, 11 Aug 2023 17:29:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:29:42 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:29:42 +0800
Subject: [PATCH 2/36] crypto: sun8i-ss - Remove prepare/unprepare request
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOSj-0020XI-Uz@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks for prepare and unprepare request in crypto_engine
is superfluous.  They can be done directly from do_one_request.

Move the code into do_one_request and remove the unused callbacks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c |    2 --
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   |    2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 381a90fbeaff..2758dadf74eb 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -409,8 +409,6 @@ int sun8i_ss_cipher_init(struct crypto_tfm *tfm)
 	       CRYPTO_MAX_ALG_NAME);
 
 	op->enginectx.op.do_one_request = sun8i_ss_handle_cipher_request;
-	op->enginectx.op.prepare_request = NULL;
-	op->enginectx.op.unprepare_request = NULL;
 
 	err = pm_runtime_resume_and_get(op->ss->dev);
 	if (err < 0) {
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index a4b67d130d11..e6865b49b1df 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -120,8 +120,6 @@ int sun8i_ss_hash_crainit(struct crypto_tfm *tfm)
 	op->ss = algt->ss;
 
 	op->enginectx.op.do_one_request = sun8i_ss_hash_run;
-	op->enginectx.op.prepare_request = NULL;
-	op->enginectx.op.unprepare_request = NULL;
 
 	/* FALLBACK */
 	op->fallback_tfm = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0,
