From: Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH] aesni-intel: Merge with fpu.ko
Date: Sat,  7 May 2011 22:22:00 -0400
Message-ID: <7d8af8fba578ff152819ae196694d351d9741c2e.1304820759.git.luto@mit.edu>
Cc: Milan Broz <mbroz@redhat.com>, Andy Lutomirski <luto@mit.edu>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:62832 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577Ab1EHC13 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 May 2011 22:27:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Loading fpu without aesni-intel does nothing.  Loading aesni-intel
without fpu causes modes like xts to fail.  (Unloading
aesni-intel will restore those modes.)

One solution would be to make aesni-intel depend on fpu, but it
seems cleaner to just combine the modules.

This is probably responsible for bugs like:
https://bugzilla.redhat.com/show_bug.cgi?id=589390

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

I'm not sure this is the best fix, but it seems to fix a longstanding bug.

FWIW, I don't understand why the fpu module exists at all.

 arch/x86/crypto/Makefile           |    4 +---
 arch/x86/crypto/aesni-intel_glue.c |    8 ++++++++
 arch/x86/crypto/fpu.c              |   10 ++--------
 crypto/Kconfig                     |    6 ------
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 1a58ad8..c04f1b7 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -2,8 +2,6 @@
 # Arch-specific CryptoAPI modules.
 #
 
-obj-$(CONFIG_CRYPTO_FPU) += fpu.o
-
 obj-$(CONFIG_CRYPTO_AES_586) += aes-i586.o
 obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
 obj-$(CONFIG_CRYPTO_SALSA20_586) += salsa20-i586.o
@@ -24,6 +22,6 @@ aes-x86_64-y := aes-x86_64-asm_64.o aes_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
 
-aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
+aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
 
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index b375b2a..89632d1 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -140,6 +140,9 @@ asmlinkage void aesni_gcm_dec(void *ctx, u8 *out,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
+int crypto_fpu_init(void);
+void crypto_fpu_exit(void);
+
 static inline struct
 aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
 {
@@ -1259,6 +1262,8 @@ static int __init aesni_init(void)
 		return -ENODEV;
 	}
 
+	if ((err = crypto_fpu_init()))
+		goto fpu_err;
 	if ((err = crypto_register_alg(&aesni_alg)))
 		goto aes_err;
 	if ((err = crypto_register_alg(&__aesni_alg)))
@@ -1336,6 +1341,7 @@ blk_ecb_err:
 __aes_err:
 	crypto_unregister_alg(&aesni_alg);
 aes_err:
+fpu_err:
 	return err;
 }
 
@@ -1365,6 +1371,8 @@ static void __exit aesni_exit(void)
 	crypto_unregister_alg(&blk_ecb_alg);
 	crypto_unregister_alg(&__aesni_alg);
 	crypto_unregister_alg(&aesni_alg);
+
+	crypto_fpu_exit();
 }
 
 module_init(aesni_init);
diff --git a/arch/x86/crypto/fpu.c b/arch/x86/crypto/fpu.c
index 1a8f864..98d7a18 100644
--- a/arch/x86/crypto/fpu.c
+++ b/arch/x86/crypto/fpu.c
@@ -150,18 +150,12 @@ static struct crypto_template crypto_fpu_tmpl = {
 	.module = THIS_MODULE,
 };
 
-static int __init crypto_fpu_module_init(void)
+int __init crypto_fpu_init(void)
 {
 	return crypto_register_template(&crypto_fpu_tmpl);
 }
 
-static void __exit crypto_fpu_module_exit(void)
+void __exit crypto_fpu_exit(void)
 {
 	crypto_unregister_template(&crypto_fpu_tmpl);
 }
-
-module_init(crypto_fpu_module_init);
-module_exit(crypto_fpu_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("FPU block cipher wrapper");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4b7cb0e..87b22ca 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -264,11 +264,6 @@ config CRYPTO_XTS
 	  key size 256, 384 or 512 bits. This implementation currently
 	  can't handle a sectorsize which is not a multiple of 16 bytes.
 
-config CRYPTO_FPU
-	tristate
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_MANAGER
-
 comment "Hash modes"
 
 config CRYPTO_HMAC
@@ -543,7 +538,6 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_AES_586 if !64BIT
 	select CRYPTO_CRYPTD
 	select CRYPTO_ALGAPI
-	select CRYPTO_FPU
 	help
 	  Use Intel AES-NI instructions for AES algorithm.
 
-- 
1.7.4.4
