From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 02/13] crypto: gcm_generic - copy AAD during encryption
Date: Tue, 10 Jan 2017 02:37:06 +0100
Message-ID: <5602132.eBAxP8yXb3@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55404 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941456AbdAJBmS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:18 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From 8690e52f7e90663b14b2490d37a3b5b1c5a53bfe Mon Sep 17 00:00:00 2001
From: Stephan Mueller <smueller@chronox.de>
Date: Mon, 9 Jan 2017 12:35:35 +0100
Subject: 

Invoke the crypto_aead_copy_ad function during the encryption code path
to copy the AAD from the source to the destination buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/gcm.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index b7ad808..1ca0b05c 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -496,11 +496,16 @@ static int crypto_gcm_encrypt(struct aead_request *req)
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct skcipher_request *skreq = &pctx->u.skreq;
 	u32 flags = aead_request_flags(req);
+	int err;
 
 	crypto_gcm_init_common(req);
 	crypto_gcm_init_crypt(req, req->cryptlen);
 	skcipher_request_set_callback(skreq, flags, gcm_encrypt_done, req);
 
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
+
 	return crypto_skcipher_encrypt(skreq) ?:
 	       gcm_encrypt_continue(req, flags);
 }
@@ -866,9 +871,15 @@ static struct aead_request *crypto_rfc4106_crypt(struct aead_request *req)
 
 static int crypto_rfc4106_encrypt(struct aead_request *req)
 {
+	int err;
+
 	if (req->assoclen != 16 && req->assoclen != 20)
 		return -EINVAL;
 
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
+
 	req = crypto_rfc4106_crypt(req);
 
 	return crypto_aead_encrypt(req);
@@ -1099,6 +1110,12 @@ static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc)
 
 static int crypto_rfc4543_encrypt(struct aead_request *req)
 {
+	int err;
+
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
+
 	return crypto_rfc4543_crypt(req, true);
 }
 
-- 
2.9.3
