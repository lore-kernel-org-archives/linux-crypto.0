From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto: aesni-intel - Fixed build error on x86-32
Date: Sun, 28 Nov 2010 19:31:49 +0100
Message-ID: <1290969109-28322-1-git-send-email-minipli@googlemail.com>
References: <20101127083524.GC2364@gondor.apana.org.au>
Cc: Huang Ying <ying.huang@intel.com>,
	Mathias Krause <minipli@googlemail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grimli.r00tworld.net ([83.169.44.195]:42645 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab0K1Sbw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Nov 2010 13:31:52 -0500
In-Reply-To: <20101127083524.GC2364@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert, thanks for merge but the AES-GCM code merged meanwhile made the x86-32
bit version break on build. The following patch fixes this:

Exclude AES-GCM code for x86-32 due to heavy usage of 64-bit registers
not available on x86-32.

While at it, fixed unregister order in aesni_exit().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/crypto/aesni-intel_asm.S  |    5 ++++-
 arch/x86/crypto/aesni-intel_glue.c |   26 +++++++++++++-------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index f592e03..d528fde 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -32,6 +32,7 @@
 #include <linux/linkage.h>
 #include <asm/inst.h>
 
+#ifdef __x86_64__
 .data
 POLY:   .octa 0xC2000000000000000000000000000001
 TWOONE: .octa 0x00000001000000000000000000000001
@@ -84,6 +85,7 @@ enc:        .octa 0x2
 #define arg8 STACK_OFFSET+16(%r14)
 #define arg9 STACK_OFFSET+24(%r14)
 #define arg10 STACK_OFFSET+32(%r14)
+#endif
 
 
 #define STATE1	%xmm0
@@ -130,6 +132,7 @@ enc:        .octa 0x2
 #endif
 
 
+#ifdef __x86_64__
 /* GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
 *
 *
@@ -1255,7 +1258,7 @@ _return_T_done_encrypt:
 	pop	%r13
 	pop	%r12
 	ret
-
+#endif
 
 
 _key_expansion_128:
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 8a3b800..0f2c3c6 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -97,7 +97,6 @@ asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 #ifdef CONFIG_X86_64
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
-#endif
 
 /* asmlinkage void aesni_gcm_enc()
  * void *ctx,  AES Key schedule. Starts on a 16 byte boundary.
@@ -149,6 +148,7 @@ aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
 		PTR_ALIGN((u8 *)
 		crypto_tfm_ctx(crypto_aead_tfm(tfm)), AESNI_ALIGN);
 }
+#endif
 
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
@@ -822,6 +822,7 @@ static struct crypto_alg ablk_xts_alg = {
 };
 #endif
 
+#ifdef CONFIG_X86_64
 static int rfc4106_init(struct crypto_tfm *tfm)
 {
 	struct cryptd_aead *cryptd_tfm;
@@ -1237,6 +1238,7 @@ static struct crypto_alg __rfc4106_alg = {
 		},
 	},
 };
+#endif
 
 static int __init aesni_init(void)
 {
@@ -1264,6 +1266,10 @@ static int __init aesni_init(void)
 		goto blk_ctr_err;
 	if ((err = crypto_register_alg(&ablk_ctr_alg)))
 		goto ablk_ctr_err;
+	if ((err = crypto_register_alg(&__rfc4106_alg))
+		goto __aead_gcm_err;
+	if ((err = crypto_register_alg(&rfc4106_alg))
+		goto aead_gcm_err;
 #ifdef HAS_CTR
 	if ((err = crypto_register_alg(&ablk_rfc3686_ctr_alg)))
 		goto ablk_rfc3686_ctr_err;
@@ -1281,19 +1287,9 @@ static int __init aesni_init(void)
 	if ((err = crypto_register_alg(&ablk_xts_alg)))
 		goto ablk_xts_err;
 #endif
-	err = crypto_register_alg(&__rfc4106_alg);
-	if (err)
-		goto __aead_gcm_err;
-	err = crypto_register_alg(&rfc4106_alg);
-	if (err)
-		goto aead_gcm_err;
 	return err;
 
-aead_gcm_err:
-	crypto_unregister_alg(&__rfc4106_alg);
-__aead_gcm_err:
 #ifdef HAS_XTS
-	crypto_unregister_alg(&ablk_xts_alg);
 ablk_xts_err:
 #endif
 #ifdef HAS_PCBC
@@ -1309,6 +1305,10 @@ ablk_lrw_err:
 	crypto_unregister_alg(&ablk_rfc3686_ctr_alg);
 ablk_rfc3686_ctr_err:
 #endif
+	crypto_unregister_alg(&rfc4106_alg);
+aead_gcm_err:
+	crypto_unregister_alg(&__rfc4106_alg);
+__aead_gcm_err:
 	crypto_unregister_alg(&ablk_ctr_alg);
 ablk_ctr_err:
 	crypto_unregister_alg(&blk_ctr_alg);
@@ -1331,8 +1331,6 @@ aes_err:
 
 static void __exit aesni_exit(void)
 {
-	crypto_unregister_alg(&__rfc4106_alg);
-	crypto_unregister_alg(&rfc4106_alg);
 #ifdef HAS_XTS
 	crypto_unregister_alg(&ablk_xts_alg);
 #endif
@@ -1346,6 +1344,8 @@ static void __exit aesni_exit(void)
 #ifdef HAS_CTR
 	crypto_unregister_alg(&ablk_rfc3686_ctr_alg);
 #endif
+	crypto_unregister_alg(&rfc4106_alg);
+	crypto_unregister_alg(&__rfc4106_alg);
 	crypto_unregister_alg(&ablk_ctr_alg);
 	crypto_unregister_alg(&blk_ctr_alg);
 #endif
-- 
1.5.6.5
