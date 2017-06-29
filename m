From: karthik@techveda.org
Subject: [PATCH v2] staging: ccree: Use __func__ instead of function name
Date: Thu, 29 Jun 2017 22:38:45 +0530
Message-ID: <1498756125-3330-1-git-send-email-karthik@techveda.org>
References: <20170629141829.GA29662@kroah.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, sunil.m@techveda.org,
        Karthik Tummala <karthik@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33169 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752136AbdF2RJk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2017 13:09:40 -0400
Received: by mail-pg0-f68.google.com with SMTP id u62so12609222pgb.0
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jun 2017 10:09:39 -0700 (PDT)
In-Reply-To: <20170629141829.GA29662@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Karthik Tummala <karthik@techveda.org>

Fixed following checkpatch.pl warning:
	WARNING: Prefer using '"%s...", __func__' to using
the function's name, in a string

It is prefered to use '%s & __func__' instead of function
name for logging.

Signed-off-by: Karthik Tummala <karthik@techveda.org>
---
Changes for v2:
v1 was a patch series, which consisted of two patches in which
second one was already submitted by Gilad Ben-Yossef, so dropped
that one.

Patch generated on staging-testing as suggested by Greg-K H.
---
 drivers/staging/ccree/ssi_aead.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 1fc0b05..1168161 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1886,7 +1886,7 @@ static int config_gcm_context(struct aead_request *req)
 				(req->cryptlen - ctx->authsize);
 	__be32 counter = cpu_to_be32(2);
 
-	SSI_LOG_DEBUG("config_gcm_context() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n", cryptlen, req->assoclen, ctx->authsize);
+	SSI_LOG_DEBUG("%s() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n", __func__, cryptlen, req->assoclen, ctx->authsize);
 
 	memset(req_ctx->hkey, 0, AES_BLOCK_SIZE);
 
@@ -2198,7 +2198,7 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
 
-	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setkey()  keylen %d, key %p\n", keylen, key);
+	SSI_LOG_DEBUG("%s()  keylen %d, key %p\n", __func__, keylen, key);
 
 	if (keylen < 4)
 		return -EINVAL;
@@ -2216,7 +2216,7 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
 
-	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setkey()  keylen %d, key %p\n", keylen, key);
+	SSI_LOG_DEBUG("%s()  keylen %d, key %p\n", __func__, keylen, key);
 
 	if (keylen < 4)
 		return -EINVAL;
-- 
1.9.1
