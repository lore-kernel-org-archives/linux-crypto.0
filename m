From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/5] crypto: aesni - Fix cryptd reordering problem on gcm
Date: Tue, 21 Jun 2016 16:55:14 +0800
Message-ID: <E1bFHSk-0005VB-Ht@gondolin.me.apana.org.au>
References: <20160621085321.GA21044@gondor.apana.org.au>
To: Raj Ammanur <rammanur@arista.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45235 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbcFUIzV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 04:55:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes an old bug where gcm requests can be reordered
because some are processed by cryptd while others are processed
directly in softirq context.

The fix is to always postpone to cryptd if there are currently
requests outstanding from the same tfm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/aesni-intel_glue.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 5b7fa14..9e15572e 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1098,9 +1098,12 @@ static int rfc4106_encrypt(struct aead_request *req)
 	struct cryptd_aead **ctx = crypto_aead_ctx(tfm);
 	struct cryptd_aead *cryptd_tfm = *ctx;
 
-	aead_request_set_tfm(req, irq_fpu_usable() ?
-				  cryptd_aead_child(cryptd_tfm) :
-				  &cryptd_tfm->base);
+	tfm = &cryptd_tfm->base;
+	if (irq_fpu_usable() && (!in_atomic() ||
+				 !cryptd_aead_queued(cryptd_tfm)))
+		tfm = cryptd_aead_child(cryptd_tfm);
+
+	aead_request_set_tfm(req, tfm);
 
 	return crypto_aead_encrypt(req);
 }
@@ -1111,9 +1114,12 @@ static int rfc4106_decrypt(struct aead_request *req)
 	struct cryptd_aead **ctx = crypto_aead_ctx(tfm);
 	struct cryptd_aead *cryptd_tfm = *ctx;
 
-	aead_request_set_tfm(req, irq_fpu_usable() ?
-				  cryptd_aead_child(cryptd_tfm) :
-				  &cryptd_tfm->base);
+	tfm = &cryptd_tfm->base;
+	if (irq_fpu_usable() && (!in_atomic() ||
+				 !cryptd_aead_queued(cryptd_tfm)))
+		tfm = cryptd_aead_child(cryptd_tfm);
+
+	aead_request_set_tfm(req, tfm);
 
 	return crypto_aead_decrypt(req);
 }
