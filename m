Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80739C636CC
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjAaIBw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjAaIBv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:01:51 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4EE40BF5
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:01:50 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlaN-005ve7-GT; Tue, 31 Jan 2023 16:01:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:01:47 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:01:47 +0800
Subject: [PATCH 2/32] crypto: cryptd - Use subreq for AEAD
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        linux-arm-kernel@axis.com,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        George Cherian <gcherian@marvell.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com, Thara Gopinath <thara.gopinath@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Message-Id: <E1pMlaN-005ve7-GT@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AEAD reuses the existing request object for its child.  This is
error-prone and unnecessary.  This patch adds a subrequest object
just like we do for skcipher and hash.

This patch also restores the original completion function as we
do for skcipher/hash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 1ff58a021d57..c0c416eda8e8 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -93,6 +93,7 @@ struct cryptd_aead_ctx {
 
 struct cryptd_aead_request_ctx {
 	crypto_completion_t complete;
+	struct aead_request req;
 };
 
 static void cryptd_queue_worker(struct work_struct *work);
@@ -715,6 +716,7 @@ static void cryptd_aead_crypt(struct aead_request *req,
 			int (*crypt)(struct aead_request *req))
 {
 	struct cryptd_aead_request_ctx *rctx;
+	struct aead_request *subreq;
 	struct cryptd_aead_ctx *ctx;
 	crypto_completion_t compl;
 	struct crypto_aead *tfm;
@@ -722,14 +724,24 @@ static void cryptd_aead_crypt(struct aead_request *req,
 
 	rctx = aead_request_ctx(req);
 	compl = rctx->complete;
+	subreq = &rctx->req;
 
 	tfm = crypto_aead_reqtfm(req);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
-	aead_request_set_tfm(req, child);
+
+	aead_request_set_tfm(subreq, child);
+	aead_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
+				  NULL, NULL);
+	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
+			       req->iv);
+	aead_request_set_ad(subreq, req->assoclen);
+
 	err = crypt( req );
 
+	req->base.complete = compl;
+
 out:
 	ctx = crypto_aead_ctx(tfm);
 	refcnt = refcount_read(&ctx->refcnt);
@@ -798,8 +810,8 @@ static int cryptd_aead_init_tfm(struct crypto_aead *tfm)
 
 	ctx->child = cipher;
 	crypto_aead_set_reqsize(
-		tfm, max((unsigned)sizeof(struct cryptd_aead_request_ctx),
-			 crypto_aead_reqsize(cipher)));
+		tfm, sizeof(struct cryptd_aead_request_ctx) +
+		     crypto_aead_reqsize(cipher));
 	return 0;
 }
 
