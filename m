Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D49C05027
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 05:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjBHFxh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 00:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBHFxf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 00:53:35 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B4819F0B
        for <linux-crypto@vger.kernel.org>; Tue,  7 Feb 2023 21:53:33 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pPdOW-008kzC-9K; Wed, 08 Feb 2023 13:53:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Feb 2023 13:53:24 +0800
Date:   Wed, 8 Feb 2023 13:53:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
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
Subject: [v2 PATCH 2/32] crypto: cryptd - Use subreq for AEAD
Message-ID: <Y+M41Lo9b3p2thrm@gondor.apana.org.au>
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
 <E1pMlaN-005ve7-GT@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pMlaN-005ve7-GT@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v2 fixes the patch so that we actually call crypt with subreq and
not the original request.

---8<---
AEAD reuses the existing request object for its child.  This is
error-prone and unnecessary.  This patch adds a subrequest object
just like we do for skcipher and hash.

This patch also restores the original completion function as we
do for skcipher/hash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 1ff58a021d57..9d60acc920cb 100644
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
@@ -722,13 +724,23 @@ static void cryptd_aead_crypt(struct aead_request *req,
 
 	rctx = aead_request_ctx(req);
 	compl = rctx->complete;
+	subreq = &rctx->req;
 
 	tfm = crypto_aead_reqtfm(req);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
-	aead_request_set_tfm(req, child);
-	err = crypt( req );
+
+	aead_request_set_tfm(subreq, child);
+	aead_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
+				  NULL, NULL);
+	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
+			       req->iv);
+	aead_request_set_ad(subreq, req->assoclen);
+
+	err = crypt(subreq);
+
+	req->base.complete = compl;
 
 out:
 	ctx = crypto_aead_ctx(tfm);
@@ -798,8 +810,8 @@ static int cryptd_aead_init_tfm(struct crypto_aead *tfm)
 
 	ctx->child = cipher;
 	crypto_aead_set_reqsize(
-		tfm, max((unsigned)sizeof(struct cryptd_aead_request_ctx),
-			 crypto_aead_reqsize(cipher)));
+		tfm, sizeof(struct cryptd_aead_request_ctx) +
+		     crypto_aead_reqsize(cipher));
 	return 0;
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
