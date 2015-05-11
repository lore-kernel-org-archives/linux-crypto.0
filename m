From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 19/24] crypto: aesni - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:48:04 +0800
Message-ID: <E1YrkJg-0001Er-K6@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51534 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbbEKJsJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:09 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJh-0000L3-Tq
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:48:06 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/aesni-intel_glue.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 112cefa..2ade2400 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -807,8 +807,9 @@ static int rfc4106_init(struct crypto_tfm *tfm)
 	child_ctx = aesni_rfc4106_gcm_ctx_get(cryptd_child);
 	memcpy(child_ctx, ctx, sizeof(*ctx));
 	ctx->cryptd_tfm = cryptd_tfm;
-	tfm->crt_aead.reqsize = sizeof(struct aead_request)
-		+ crypto_aead_reqsize(&cryptd_tfm->base);
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+		sizeof(struct aead_request) +
+		crypto_aead_reqsize(&cryptd_tfm->base));
 	return 0;
 }
 
