Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F92C636CD
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjAaIC2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjAaICO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:02:14 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8535241B6D
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:13 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlak-005vjY-N1; Tue, 31 Jan 2023 16:02:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:10 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:10 +0800
Subject: [PATCH 13/32] crypto: artpec6 - Use request_complete helpers
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
Message-Id: <E1pMlak-005vjY-N1@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the request_complete helpers instead of calling the completion
function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/axis/artpec6_crypto.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index f6f41e316dfe..8493a45e1bd4 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2143,13 +2143,13 @@ static void artpec6_crypto_task(unsigned long data)
 
 	list_for_each_entry_safe(req, n, &complete_in_progress,
 				 complete_in_progress) {
-		req->req->complete(req->req, -EINPROGRESS);
+		crypto_request_complete(req->req, -EINPROGRESS);
 	}
 }
 
 static void artpec6_crypto_complete_crypto(struct crypto_async_request *req)
 {
-	req->complete(req, 0);
+	crypto_request_complete(req, 0);
 }
 
 static void
@@ -2161,7 +2161,7 @@ artpec6_crypto_complete_cbc_decrypt(struct crypto_async_request *req)
 	scatterwalk_map_and_copy(cipher_req->iv, cipher_req->src,
 				 cipher_req->cryptlen - AES_BLOCK_SIZE,
 				 AES_BLOCK_SIZE, 0);
-	req->complete(req, 0);
+	skcipher_request_complete(cipher_req, 0);
 }
 
 static void
@@ -2173,7 +2173,7 @@ artpec6_crypto_complete_cbc_encrypt(struct crypto_async_request *req)
 	scatterwalk_map_and_copy(cipher_req->iv, cipher_req->dst,
 				 cipher_req->cryptlen - AES_BLOCK_SIZE,
 				 AES_BLOCK_SIZE, 0);
-	req->complete(req, 0);
+	skcipher_request_complete(cipher_req, 0);
 }
 
 static void artpec6_crypto_complete_aead(struct crypto_async_request *req)
@@ -2211,12 +2211,12 @@ static void artpec6_crypto_complete_aead(struct crypto_async_request *req)
 		}
 	}
 
-	req->complete(req, result);
+	aead_request_complete(areq, result);
 }
 
 static void artpec6_crypto_complete_hash(struct crypto_async_request *req)
 {
-	req->complete(req, 0);
+	crypto_request_complete(req, 0);
 }
 
 
