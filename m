Return-Path: <SRS0=/ZR5=OQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50441 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbeLGLcQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Dec 2018 06:32:16 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-crypto@vger.kernel.org
Cc: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org
Subject: [PATCH] crypto: caam - fix setting IV after decrypt
Date: Fri,  7 Dec 2018 12:31:23 +0100
Message-Id: <20181207113123.3394-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto API wants the updated IV in req->info after decryption. The
updated IV used to be copied correctly to req->info after running the
decryption job. Since 115957bb3e59 this is done before running the job
so instead of the updated IV only the unmodified input IV is given back
to the crypto API.

This was observed running the gcm(aes) selftest which internally uses
ctr(aes) implemented by the CAAM engine.

Fixes: 115957bb3e59 ("crypto: caam - fix IV DMA mapping and updating")

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/crypto/caam/caamalg.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 869f092432de..c05c7938439c 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -917,10 +917,10 @@ static void skcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct skcipher_request *req = context;
 	struct skcipher_edesc *edesc;
-#ifdef DEBUG
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	int ivsize = crypto_skcipher_ivsize(skcipher);
 
+#ifdef DEBUG
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
@@ -937,6 +937,14 @@ static void skcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
 	skcipher_unmap(jrdev, edesc, req);
+
+	/*
+	 * The crypto API expects us to set the IV (req->iv) to the last
+	 * ciphertext block.
+	 */
+	scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen - ivsize,
+				 ivsize, 0);
+
 	kfree(edesc);
 
 	skcipher_request_complete(req, err);
@@ -1588,13 +1596,6 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	/*
-	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block.
-	 */
-	scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen - ivsize,
-				 ivsize, 0);
-
 	/* Create and submit job descriptor*/
 	init_skcipher_job(req, edesc, false);
 	desc = edesc->hw_desc;
-- 
2.19.1
