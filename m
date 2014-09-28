From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 3/3] Revert "crypto: aesni - disable "by8" AVX CTR optimization"
Date: Sun, 28 Sep 2014 22:24:01 +0200
Message-ID: <1411935841-11294-4-git-send-email-minipli@googlemail.com>
References: <1411935841-11294-1-git-send-email-minipli@googlemail.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53206 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaI1UY2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Sep 2014 16:24:28 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so12197008wgg.20
        for <linux-crypto@vger.kernel.org>; Sun, 28 Sep 2014 13:24:27 -0700 (PDT)
In-Reply-To: <1411935841-11294-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This reverts commit 7da4b29d496b1389d3a29b55d3668efecaa08ebd.

Now, that the issue is fixed, we can re-enable the code.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
---
 arch/x86/crypto/aesni-intel_glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index a7ccd57f19e4..888950f29fd9 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -481,7 +481,7 @@ static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
 	crypto_inc(ctrblk, AES_BLOCK_SIZE);
 }
 
-#if 0	/* temporary disabled due to failing crypto tests */
+#ifdef CONFIG_AS_AVX
 static void aesni_ctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv)
 {
@@ -1522,7 +1522,7 @@ static int __init aesni_init(void)
 		aesni_gcm_dec_tfm = aesni_gcm_dec;
 	}
 	aesni_ctr_enc_tfm = aesni_ctr_enc;
-#if 0	/* temporary disabled due to failing crypto tests */
+#ifdef CONFIG_AS_AVX
 	if (cpu_has_avx) {
 		/* optimize performance of ctr mode encryption transform */
 		aesni_ctr_enc_tfm = aesni_ctr_enc_avx_tfm;
-- 
1.7.10.4
