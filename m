From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: [PATCH v1] crypto: brcm - software fallback for cryptlen zero
Date: Fri, 23 Jun 2017 14:24:30 +0530
Message-ID: <1498208070-15584-1-git-send-email-raveendra.padasalagi@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        linux-crypto@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Zero length payload requests are not handled in
Broadcom SPU2 engine, so this patch adds conditional
check to fallback to software implementation for AES-GCM
and AES-CCM algorithms.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Cc: stable@vger.kernel.org
---

Changes in v1:
 - Added Cc tag in the Signed-off area to send the patch to stable kernel

 drivers/crypto/bcm/cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index cc0d5b9..6c80863 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2625,7 +2625,7 @@ static int aead_need_fallback(struct aead_request *req)
 	 */
 	if (((ctx->cipher.mode == CIPHER_MODE_GCM) ||
 	     (ctx->cipher.mode == CIPHER_MODE_CCM)) &&
-	    (req->assoclen == 0)) {
+	    ((req->assoclen == 0) || (req->cryptlen == 0))) {
 		if ((rctx->is_encrypt && (req->cryptlen == 0)) ||
 		    (!rctx->is_encrypt && (req->cryptlen == ctx->digestsize))) {
 			flow_log("AES GCM/CCM needs fallback for 0 len req\n");
-- 
1.9.1
