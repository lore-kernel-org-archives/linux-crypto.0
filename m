From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH] crypto: x86 - build AVX block cipher implementations only
 if assembler supports AVX instructions
Date: Sun, 24 Mar 2013 15:34:07 +0200
Message-ID: <20130324133407.2632.1596.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:33489 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab3CXNeM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Mar 2013 09:34:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These modules require AVX support in assembler, so add new check to Makefile
for this.

Other option would be to use CONFIG_AS_AVX inside source files, but that would
result dummy/empty/no-fuctionality modules being created.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/Makefile |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index ca96761..83681a3 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -2,6 +2,8 @@
 # Arch-specific CryptoAPI modules.
 #
 
+avx_supported := $(call as-instr,vpxor %xmm0$(comma)%xmm0$(comma)%xmm0,yes,no)
+
 obj-$(CONFIG_CRYPTO_ABLK_HELPER_X86) += ablk_helper.o
 obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
 
@@ -12,16 +14,11 @@ obj-$(CONFIG_CRYPTO_SERPENT_SSE2_586) += serpent-sse2-i586.o
 
 obj-$(CONFIG_CRYPTO_AES_X86_64) += aes-x86_64.o
 obj-$(CONFIG_CRYPTO_CAMELLIA_X86_64) += camellia-x86_64.o
-obj-$(CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64) += camellia-aesni-avx-x86_64.o
-obj-$(CONFIG_CRYPTO_CAST5_AVX_X86_64) += cast5-avx-x86_64.o
-obj-$(CONFIG_CRYPTO_CAST6_AVX_X86_64) += cast6-avx-x86_64.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64_3WAY) += twofish-x86_64-3way.o
-obj-$(CONFIG_CRYPTO_TWOFISH_AVX_X86_64) += twofish-avx-x86_64.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
 obj-$(CONFIG_CRYPTO_SERPENT_SSE2_X86_64) += serpent-sse2-x86_64.o
-obj-$(CONFIG_CRYPTO_SERPENT_AVX_X86_64) += serpent-avx-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 
@@ -29,6 +26,16 @@ obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 obj-$(CONFIG_CRYPTO_CRC32_PCLMUL) += crc32-pclmul.o
 
+# These modules require assembler to support AVX.
+ifeq ($(avx_supported),yes)
+	obj-$(CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64) += \
+						camellia-aesni-avx-x86_64.o
+	obj-$(CONFIG_CRYPTO_CAST5_AVX_X86_64) += cast5-avx-x86_64.o
+	obj-$(CONFIG_CRYPTO_CAST6_AVX_X86_64) += cast6-avx-x86_64.o
+	obj-$(CONFIG_CRYPTO_TWOFISH_AVX_X86_64) += twofish-avx-x86_64.o
+	obj-$(CONFIG_CRYPTO_SERPENT_AVX_X86_64) += serpent-avx-x86_64.o
+endif
+
 aes-i586-y := aes-i586-asm_32.o aes_glue.o
 twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
 salsa20-i586-y := salsa20-i586-asm_32.o salsa20_glue.o
@@ -36,17 +43,22 @@ serpent-sse2-i586-y := serpent-sse2-i586-asm_32.o serpent_sse2_glue.o
 
 aes-x86_64-y := aes-x86_64-asm_64.o aes_glue.o
 camellia-x86_64-y := camellia-x86_64-asm_64.o camellia_glue.o
-camellia-aesni-avx-x86_64-y := camellia-aesni-avx-asm_64.o \
-			       camellia_aesni_avx_glue.o
-cast5-avx-x86_64-y := cast5-avx-x86_64-asm_64.o cast5_avx_glue.o
-cast6-avx-x86_64-y := cast6-avx-x86_64-asm_64.o cast6_avx_glue.o
 blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 twofish-x86_64-3way-y := twofish-x86_64-asm_64-3way.o twofish_glue_3way.o
-twofish-avx-x86_64-y := twofish-avx-x86_64-asm_64.o twofish_avx_glue.o
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
 serpent-sse2-x86_64-y := serpent-sse2-x86_64-asm_64.o serpent_sse2_glue.o
-serpent-avx-x86_64-y := serpent-avx-x86_64-asm_64.o serpent_avx_glue.o
+
+ifeq ($(avx_supported),yes)
+	camellia-aesni-avx-x86_64-y := camellia-aesni-avx-asm_64.o \
+					camellia_aesni_avx_glue.o
+	cast5-avx-x86_64-y := cast5-avx-x86_64-asm_64.o cast5_avx_glue.o
+	cast6-avx-x86_64-y := cast6-avx-x86_64-asm_64.o cast6_avx_glue.o
+	twofish-avx-x86_64-y := twofish-avx-x86_64-asm_64.o \
+				twofish_avx_glue.o
+	serpent-avx-x86_64-y := serpent-avx-x86_64-asm_64.o \
+				serpent_avx_glue.o
+endif
 
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
