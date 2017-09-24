From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Sun, 24 Sep 2017 08:24:58 +0200
Message-ID: <1612247.TXa8PiMVpk@positron.chronox.de>
References: <3874163.dZU00zCVt8@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34930 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750880AbdIXGZs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Sep 2017 02:25:48 -0400
In-Reply-To: <3874163.dZU00zCVt8@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The encryption / decryption operation is a noop in case the caller
provides zero input data. As this noop is a "valid" operation, the API
calls will return no error, but simply skip any processing.

This fixes a kernel crash with authenc() ciphers and zero plaintext /
ciphertext that can be triggered via AF_ALG from unprivileged user
space.

Fixes: 7a7ffe65c8c5f ("crypto: skcipher - Add top-level skcipher
interface")
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: <stable@vger.kernel.org>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/skcipher.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 562001cb412b..ca27fbadbe67 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -442,6 +442,9 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 
+	if (!req->cryptlen)
+		return 0;
+
 	return tfm->encrypt(req);
 }
 
@@ -460,6 +463,9 @@ static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 
+	if (!req->cryptlen)
+		return 0;
+
 	return tfm->decrypt(req);
 }
 
-- 
2.13.5
