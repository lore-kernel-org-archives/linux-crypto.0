From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 04/13] crypto: rfc4106-gcm-aesni - copy AAD during encryption
Date: Tue, 10 Jan 2017 02:37:49 +0100
Message-ID: <4916033.TzmDy5GXzM@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55392 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941456AbdAJBmN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:13 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Invoke the crypto_aead_copy_ad function during the encryption code path
to copy the AAD from the source to the destination buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/aesni-intel_glue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 36ca150..6149018 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -882,6 +882,7 @@ static int rfc4106_encrypt(struct aead_request *req)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cryptd_aead **ctx = crypto_aead_ctx(tfm);
 	struct cryptd_aead *cryptd_tfm = *ctx;
+	int err;
 
 	tfm = &cryptd_tfm->base;
 	if (irq_fpu_usable() && (!in_atomic() ||
@@ -890,6 +891,10 @@ static int rfc4106_encrypt(struct aead_request *req)
 
 	aead_request_set_tfm(req, tfm);
 
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
+
 	return crypto_aead_encrypt(req);
 }
 
-- 
2.9.3
