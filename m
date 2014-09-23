From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto: aesni - disable "by8" AVX CTR optimization
Date: Tue, 23 Sep 2014 22:31:07 +0200
Message-ID: <1411504267-10170-1-git-send-email-minipli@googlemail.com>
References: <20140917112911.GA2129@gondor.apana.org.au>
Cc: Romain Francoise <romain@orebokech.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Chandramouli Narayanan <mouli@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54545 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaIWUcX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Sep 2014 16:32:23 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so5152052wgg.32
        for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2014 13:32:21 -0700 (PDT)
In-Reply-To: <20140917112911.GA2129@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The "by8" implementation introduced in commit 22cddcc7df8f ("crypto: aes
- AES CTR x86_64 "by8" AVX optimization") is failing crypto tests as it
handles counter block overflows differently. It only accounts the right
most 32 bit as a counter -- not the whole block as all other
implementations do. This makes it fail the cryptomgr test #4 that
specifically tests this corner case.

As we're quite late in the release cycle, just disable the "by8" variant
for now.

Reported-by: Romain Francoise <romain@orebokech.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>

---
I'll try to create a real fix next week but I can't promise much. If
Linus releases v3.17 early, as he has mentioned in his -rc6
announcement, we should hot fix this by just disabling the "by8"
variant. The real fix would add the necessary counter block handling to
the asm code and revert this commit afterwards. Reverting the whole code
is not necessary, imho.

Would that be okay for you, Herbert?
---
 arch/x86/crypto/aesni-intel_glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 888950f29fd9..a7ccd57f19e4 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -481,7 +481,7 @@ static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
 	crypto_inc(ctrblk, AES_BLOCK_SIZE);
 }
 
-#ifdef CONFIG_AS_AVX
+#if 0	/* temporary disabled due to failing crypto tests */
 static void aesni_ctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv)
 {
@@ -1522,7 +1522,7 @@ static int __init aesni_init(void)
 		aesni_gcm_dec_tfm = aesni_gcm_dec;
 	}
 	aesni_ctr_enc_tfm = aesni_ctr_enc;
-#ifdef CONFIG_AS_AVX
+#if 0	/* temporary disabled due to failing crypto tests */
 	if (cpu_has_avx) {
 		/* optimize performance of ctr mode encryption transform */
 		aesni_ctr_enc_tfm = aesni_ctr_enc_avx_tfm;
-- 
1.7.10.4
