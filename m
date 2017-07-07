From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 04/13] crypto: caam/qi - properly set IV after {en,de}crypt
Date: Fri, 7 Jul 2017 16:05:14 +0300
Message-ID: <20170707130523.32427-5-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0045.outbound.protection.outlook.com ([104.47.32.45]:7728
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750726AbdGGNFy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 09:05:54 -0400
In-Reply-To: <20170707130523.32427-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caam/qi needs a fix similar to what was done for caam/jr in
commit "crypto: caam/qi - properly set IV after {en,de}crypt",
to allow for ablkcipher/skcipher chunking/streaming.

Cc: <stable@vger.kernel.org>
Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Suggested-by: David Gstir <david@sigma-star.at>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 2dde23abbd3a..a5d634e0aef3 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -776,9 +776,9 @@ static void ablkcipher_done(struct caam_drv_req *drv_req, u32 status)
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	struct caam_ctx *caam_ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct device *qidev = caam_ctx->qidev;
-#ifdef DEBUG
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 
+#ifdef DEBUG
 	dev_err(qidev, "%s %d: status 0x%x\n", __func__, __LINE__, status);
 #endif
 
@@ -799,6 +799,13 @@ static void ablkcipher_done(struct caam_drv_req *drv_req, u32 status)
 	ablkcipher_unmap(qidev, edesc, req);
 	qi_cache_free(edesc);
 
+	/*
+	 * The crypto API expects us to set the IV (req->info) to the last
+	 * ciphertext block. This is used e.g. by the CTS mode.
+	 */
+	scatterwalk_map_and_copy(req->info, req->dst, req->nbytes - ivsize,
+				 ivsize, 0);
+
 	ablkcipher_request_complete(req, status);
 }
 
-- 
2.12.0.264.gd6db3f216544
