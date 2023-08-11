Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2080BC41513
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbjHKJ37 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbjHKJ3z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:29:55 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302642D5B
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:29:55 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOSs-0020Yo-B5; Fri, 11 Aug 2023 17:29:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:29:50 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:29:50 +0800
Subject: [PATCH 6/36] crypto: keembay - Remove prepare/unprepare request
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOSs-0020Yo-B5@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks for prepare and unprepare request in crypto_engine
is superfluous.  They can be done directly from do_one_request.

Move the code into do_one_request and remove the unused callbacks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c |    4 ----
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c      |    2 --
 2 files changed, 6 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index ae31be00357a..f94f48289683 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -1150,9 +1150,7 @@ static int kmb_ocs_sm4_ccm_decrypt(struct aead_request *req)
 
 static inline int ocs_common_init(struct ocs_aes_tctx *tctx)
 {
-	tctx->engine_ctx.op.prepare_request = NULL;
 	tctx->engine_ctx.op.do_one_request = kmb_ocs_aes_sk_do_one_request;
-	tctx->engine_ctx.op.unprepare_request = NULL;
 
 	return 0;
 }
@@ -1208,9 +1206,7 @@ static void ocs_exit_tfm(struct crypto_skcipher *tfm)
 
 static inline int ocs_common_aead_init(struct ocs_aes_tctx *tctx)
 {
-	tctx->engine_ctx.op.prepare_request = NULL;
 	tctx->engine_ctx.op.do_one_request = kmb_ocs_aes_aead_do_one_request;
-	tctx->engine_ctx.op.unprepare_request = NULL;
 
 	return 0;
 }
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index 2269df17514c..e91e570b7ae0 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -794,9 +794,7 @@ static int kmb_ecc_tctx_init(struct ocs_ecc_ctx *tctx, unsigned int curve_id)
 	if (!tctx->curve)
 		return -EOPNOTSUPP;
 
-	tctx->engine_ctx.op.prepare_request = NULL;
 	tctx->engine_ctx.op.do_one_request = kmb_ocs_ecc_do_one_request;
-	tctx->engine_ctx.op.unprepare_request = NULL;
 
 	return 0;
 }
