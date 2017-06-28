From: karthik@techveda.org
Subject: [PATCH 1/2] staging: ccree: Use __func__ instead of function name
Date: Wed, 28 Jun 2017 15:07:12 +0530
Message-ID: <1498642633-3260-2-git-send-email-karthik@techveda.org>
References: <1498642633-3260-1-git-send-email-karthik@techveda.org>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, sunil.m@techveda.org,
        Karthik Tummala <karthik@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498642633-3260-1-git-send-email-karthik@techveda.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Karthik Tummala <karthik@techveda.org>

Fixed following checkpatch.pl warning:
	WARNING: Prefer using '"%s...", __func__' to using
the function's name, in a string

It is prefered to use '%s & __func__' instead of function
name for logging.

Signed-off-by: Karthik Tummala <karthik@techveda.org>
---
 drivers/staging/ccree/ssi_aead.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index c70e450..4004d69 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1899,7 +1899,7 @@ static int config_gcm_context(struct aead_request *req)
 				(req->cryptlen - ctx->authsize);
 	__be32 counter = cpu_to_be32(2);
 
-	SSI_LOG_DEBUG("config_gcm_context() cryptlen = %d, req->assoclen = %d ctx->authsize = %d \n", cryptlen, req->assoclen, ctx->authsize);
+	SSI_LOG_DEBUG("%s() cryptlen = %d, req->assoclen = %d ctx->authsize = %d \n", __func__, cryptlen, req->assoclen, ctx->authsize);
 
 	memset(req_ctx->hkey, 0, AES_BLOCK_SIZE);
 
@@ -2220,7 +2220,7 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
 
-	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setkey()  keylen %d, key %p \n", keylen, key);
+	SSI_LOG_DEBUG("%s()  keylen %d, key %p \n", __func__, keylen, key);
 
 	if (keylen < 4)
 		return -EINVAL;
@@ -2238,7 +2238,7 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
 
-	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setkey()  keylen %d, key %p \n", keylen, key);
+	SSI_LOG_DEBUG("%s()  keylen %d, key %p \n", __func__, keylen, key);
 
 	if (keylen < 4)
 		return -EINVAL;
@@ -2273,7 +2273,7 @@ static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
 static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
 				      unsigned int authsize)
 {
-	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d \n", authsize);
+	SSI_LOG_DEBUG("%s()  authsize %d \n", __func__, authsize);
 
 	switch (authsize) {
 	case 8:
@@ -2290,7 +2290,7 @@ static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
 static int ssi_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
 				       unsigned int authsize)
 {
-	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setauthsize()  authsize %d \n", authsize);
+	SSI_LOG_DEBUG("%s()  authsize %d \n", __func__, authsize);
 
 	if (authsize != 16)
 		return -EINVAL;
-- 
1.9.1
