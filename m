From: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Subject: [PATCH] drivers/staging/ccree: Replacing spaces by tab
Date: Tue, 16 May 2017 14:01:51 +0530
Message-ID: <1494923511-8623-1-git-send-email-pushkar.iit@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Pushkar Jambhlekar <pushkar.iit@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Fixing 'checkpatch.pl' ERROR: code indent should use tabs where possible

Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 0941da7..26afa87 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -96,7 +96,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 	SSI_LOG_DEBUG("Clearing context @%p for %s\n",
 		crypto_aead_ctx(tfm), crypto_tfm_alg_name(&(tfm->base)));
 
- 	dev = &ctx->drvdata->plat_dev->dev;
+	dev = &ctx->drvdata->plat_dev->dev;
 	/* Unmap enckey buffer */
 	if (ctx->enckey != NULL) {
 		SSI_RESTORE_DMA_ADDR_TO_48BIT(ctx->enckey_dma_addr);
@@ -2334,22 +2334,22 @@ static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
 static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
 				      unsigned int authsize)
 {
-        SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d \n", authsize );
-
-        switch (authsize) {
-        case 8:
-        case 12:
-        case 16:
-                break;
-        default:
-                return -EINVAL;
-        }
-
-        return ssi_aead_setauthsize(authenc, authsize);
+	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d \n", authsize );
+
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ssi_aead_setauthsize(authenc, authsize);
 }
 
 static int ssi_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
-				      unsigned int authsize)
+				       unsigned int authsize)
 {
 	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setauthsize()  authsize %d \n", authsize );
 
@@ -2364,7 +2364,7 @@ static int ssi_rfc4106_gcm_encrypt(struct aead_request *req)
 	/* Very similar to ssi_aead_encrypt() above. */
 
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-        int rc = -EINVAL;
+	int rc = -EINVAL;
 
 	if (!valid_assoclen(req)) {
 		SSI_LOG_ERR("invalid Assoclen:%u\n", req->assoclen);
@@ -2416,7 +2416,7 @@ static int ssi_rfc4106_gcm_decrypt(struct aead_request *req)
 	/* Very similar to ssi_aead_decrypt() above. */
 
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
-        int rc = -EINVAL;
+	int rc = -EINVAL;
 
 	if (!valid_assoclen(req)) {
 		SSI_LOG_ERR("invalid Assoclen:%u\n", req->assoclen);
-- 
2.7.4
