From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 12/13] crypto: nx - copy AAD during encryption
Date: Tue, 10 Jan 2017 02:40:32 +0100
Message-ID: <6034656.8T7AjXVcWL@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55372 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933311AbdAJBmB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:01 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Invoke the crypto_aead_copy_ad function during the encryption code path
to copy the AAD from the source to the destination buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/crypto/nx/nx-aes-ccm.c |  4 ++++
 drivers/crypto/nx/nx-aes-gcm.c | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index 7038f36..ee570bf 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -428,6 +428,10 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 	unsigned int processed = 0, to_process;
 	int rc = -1;
 
+	rc = crypto_aead_copy_ad(req);
+	if (rc)
+		return rc;
+
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
 	rc = generate_pat(desc->info, req, nx_ctx, authsize, nbytes, assoclen,
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index abd465f..0cc0533 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -432,9 +432,14 @@ static int gcm_aes_nx_encrypt(struct aead_request *req)
 {
 	struct nx_gcm_rctx *rctx = aead_request_ctx(req);
 	char *iv = rctx->iv;
+	int err;
 
 	memcpy(iv, req->iv, 12);
 
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
+
 	return gcm_aes_nx_crypt(req, 1, req->assoclen);
 }
 
@@ -455,6 +460,7 @@ static int gcm4106_aes_nx_encrypt(struct aead_request *req)
 	struct nx_gcm_rctx *rctx = aead_request_ctx(req);
 	char *iv = rctx->iv;
 	char *nonce = nx_ctx->priv.gcm.nonce;
+	int err;
 
 	memcpy(iv, nonce, NX_GCM4106_NONCE_LEN);
 	memcpy(iv + NX_GCM4106_NONCE_LEN, req->iv, 8);
@@ -462,6 +468,10 @@ static int gcm4106_aes_nx_encrypt(struct aead_request *req)
 	if (req->assoclen < 8)
 		return -EINVAL;
 
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
+
 	return gcm_aes_nx_crypt(req, 1, req->assoclen - 8);
 }
 
-- 
2.9.3
