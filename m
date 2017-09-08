From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH v2] Staging: ccree: Merge assignment with return
Date: Sat,  9 Sep 2017 02:25:35 +0530
Message-ID: <1504904135-3973-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 outreachy-kernel@googlegroups.com, Srishti Sharma <srishtishar@gmail.com>,
 linux-crypto@vger.kernel.org
To: gilad@benyossef.com
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

Merge the assignment and return statements to return the value
directly. Done using coccinelle.

@@
local idexpression ret;
expression e;
@@

-ret =
+return
     e;
-return ret;

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
Changes in v2:
 - Edit commit message so that it respects the 80 character limit.

 drivers/staging/ccree/ssi_aead.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 5abe6b2..f4532ea 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -651,7 +651,7 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	int rc = 0;
+

 	if (keylen < 3)
 		return -EINVAL;
@@ -659,9 +659,7 @@ static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	keylen -= 3;
 	memcpy(ctx->ctr_nonce, key + keylen, 3);

-	rc = ssi_aead_setkey(tfm, key, keylen);
-
-	return rc;
+	return ssi_aead_setkey(tfm, key, keylen);
 }
 #endif /*SSI_CC_HAS_AES_CCM*/

@@ -2214,7 +2212,7 @@ static int ssi_rfc4309_ccm_decrypt(struct aead_request *req)
 static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	int rc = 0;
+

 	SSI_LOG_DEBUG("%s()  keylen %d, key %p\n", __func__, keylen, key);

@@ -2224,15 +2222,13 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	keylen -= 4;
 	memcpy(ctx->ctr_nonce, key + keylen, 4);

-	rc = ssi_aead_setkey(tfm, key, keylen);
-
-	return rc;
+	return ssi_aead_setkey(tfm, key, keylen);
 }

 static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	int rc = 0;
+

 	SSI_LOG_DEBUG("%s()  keylen %d, key %p\n", __func__, keylen, key);

@@ -2242,9 +2238,7 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	keylen -= 4;
 	memcpy(ctx->ctr_nonce, key + keylen, 4);

-	rc = ssi_aead_setkey(tfm, key, keylen);
-
-	return rc;
+	return ssi_aead_setkey(tfm, key, keylen);
 }

 static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
--
2.7.4
