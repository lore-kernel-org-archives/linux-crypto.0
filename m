Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6831DC38142
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjAaIC1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjAaICM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:02:12 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA6841B40
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:11 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlai-005vix-I8; Tue, 31 Jan 2023 16:02:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:08 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:08 +0800
Subject: [PATCH 12/32] crypto: atmel - Use request_complete helpers
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
Message-Id: <E1pMlai-005vix-I8@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the request_complete helpers instead of calling the completion
function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/atmel-aes.c  |    4 ++--
 drivers/crypto/atmel-sha.c  |    4 ++--
 drivers/crypto/atmel-tdes.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index e90e4a6cc37a..ed10f2ae4523 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -554,7 +554,7 @@ static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 	}
 
 	if (dd->is_async)
-		dd->areq->complete(dd->areq, err);
+		crypto_request_complete(dd->areq, err);
 
 	tasklet_schedule(&dd->queue_task);
 
@@ -955,7 +955,7 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 		return ret;
 
 	if (backlog)
-		backlog->complete(backlog, -EINPROGRESS);
+		crypto_request_complete(backlog, -EINPROGRESS);
 
 	ctx = crypto_tfm_ctx(areq->tfm);
 
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 00be792e605c..a77cf0da0816 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -292,7 +292,7 @@ static inline int atmel_sha_complete(struct atmel_sha_dev *dd, int err)
 	clk_disable(dd->iclk);
 
 	if ((dd->is_async || dd->force_complete) && req->base.complete)
-		req->base.complete(&req->base, err);
+		ahash_request_complete(req, err);
 
 	/* handle new request */
 	tasklet_schedule(&dd->queue_task);
@@ -1080,7 +1080,7 @@ static int atmel_sha_handle_queue(struct atmel_sha_dev *dd,
 		return ret;
 
 	if (backlog)
-		backlog->complete(backlog, -EINPROGRESS);
+		crypto_request_complete(backlog, -EINPROGRESS);
 
 	ctx = crypto_tfm_ctx(async_req->tfm);
 
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 8b7bc1076e0d..b2d48c1649b9 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -590,7 +590,7 @@ static void atmel_tdes_finish_req(struct atmel_tdes_dev *dd, int err)
 	if (!err && (rctx->mode & TDES_FLAGS_OPMODE_MASK) != TDES_FLAGS_ECB)
 		atmel_tdes_set_iv_as_last_ciphertext_block(dd);
 
-	req->base.complete(&req->base, err);
+	skcipher_request_complete(req, err);
 }
 
 static int atmel_tdes_handle_queue(struct atmel_tdes_dev *dd,
@@ -619,7 +619,7 @@ static int atmel_tdes_handle_queue(struct atmel_tdes_dev *dd,
 		return ret;
 
 	if (backlog)
-		backlog->complete(backlog, -EINPROGRESS);
+		crypto_request_complete(backlog, -EINPROGRESS);
 
 	req = skcipher_request_cast(async_req);
 
