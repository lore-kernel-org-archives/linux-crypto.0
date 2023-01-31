Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A1BC38142
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjAaICS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjAaICH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:02:07 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AADF410BD
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:07 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlae-005vhm-Cz; Tue, 31 Jan 2023 16:02:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:04 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:04 +0800
Subject: [PATCH 10/32] crypto: rsa-pkcs1pad - Use akcipher_request_complete
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
Message-Id: <E1pMlae-005vhm-Cz@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the akcipher_request_complete helper instead of calling the
completion function directly.  In fact the previous code was buggy
in that EINPROGRESS was never passed back to the original caller.

Fixes: 3d5b1ecdea6f ("crypto: rsa - RSA padding algorithm")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rsa-pkcs1pad.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 6ee5b8a060c0..4e9d2244ee31 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -214,16 +214,14 @@ static void pkcs1pad_encrypt_sign_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
 	struct akcipher_request *req = child_async_req->data;
-	struct crypto_async_request async_req;
 
 	if (err == -EINPROGRESS)
-		return;
+		goto out;
+
+	err = pkcs1pad_encrypt_sign_complete(req, err);
 
-	async_req.data = req->base.data;
-	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags = child_async_req->flags;
-	req->base.complete(&async_req,
-			pkcs1pad_encrypt_sign_complete(req, err));
+out:
+	akcipher_request_complete(req, err);
 }
 
 static int pkcs1pad_encrypt(struct akcipher_request *req)
@@ -332,15 +330,14 @@ static void pkcs1pad_decrypt_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
 	struct akcipher_request *req = child_async_req->data;
-	struct crypto_async_request async_req;
 
 	if (err == -EINPROGRESS)
-		return;
+		goto out;
+
+	err = pkcs1pad_decrypt_complete(req, err);
 
-	async_req.data = req->base.data;
-	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags = child_async_req->flags;
-	req->base.complete(&async_req, pkcs1pad_decrypt_complete(req, err));
+out:
+	akcipher_request_complete(req, err);
 }
 
 static int pkcs1pad_decrypt(struct akcipher_request *req)
@@ -513,15 +510,14 @@ static void pkcs1pad_verify_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
 	struct akcipher_request *req = child_async_req->data;
-	struct crypto_async_request async_req;
 
 	if (err == -EINPROGRESS)
-		return;
+		goto out;
 
-	async_req.data = req->base.data;
-	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags = child_async_req->flags;
-	req->base.complete(&async_req, pkcs1pad_verify_complete(req, err));
+	err = pkcs1pad_verify_complete(req, err);
+
+out:
+	akcipher_request_complete(req, err);
 }
 
 /*
