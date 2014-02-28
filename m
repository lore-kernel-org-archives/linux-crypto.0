From: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Subject: [PATCH 1/2] Crypto: Add support for 192 & 256 bit keys to AESNI
 RFC4106
Date: Fri, 28 Feb 2014 17:00:26 -0600
Message-ID: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA61ADC6@USEA-EXCH7.na.uis.unisys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.bemta8.messagelabs.com ([216.82.243.201]:36628 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbaB1XH0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Feb 2014 18:07:26 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


These patches fix the RFC4106 implementation in the aesni-intel module so it supports 192 & 256 bit keys.
Since AVX was recently added to this module, and this patch only affects the SSE implementation, changes 
were also made to use the SSE version if key sizes other than 128 are specified.

RFC4106 specifies that 192 & 256 bit keys must be supported (section 8.4).

Also, this should fix Strongswan issue 341 where the aesni module needs to be unloaded if 256 bit keys are used:
http://wiki.strongswan.org/issues/341

This patch has been tested with Sandy Bridge and Haswell processors.  With 128 bit keys and 
input buffers > 512 bytes a slight performance degradation was noticed (~1%), input buffers 
less than 512 bytes there was no performance impact.  Compared to 128 bit keys,
256 bit key size performance is approx. .5 cycles per byte slower on Sandy Bridge, 
and .37 cycles per byte slower on Haswell (vs. SSE code).

This patch has also been tested with StrongSwan IPSec connections where it worked correctly.

I created this diff from a git clone of crypto-2.6.git.  

Any questions, please feel free to contact me.

Signed off by: Timothy.McCaffrey@Unisys.com

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 948ad0e..df37cd7 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -177,7 +177,8 @@ static void aesni_gcm_enc_avx(void *ctx, u8 *out,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
-	if (plaintext_len < AVX_GEN2_OPTSIZE) {
+        struct crypto_aes_ctx *aes_ctx = (struct crypto_aes_ctx*)ctx;
+	if ((plaintext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length != AES_KEYSIZE_128)){
 		aesni_gcm_enc(ctx, out, in, plaintext_len, iv, hash_subkey, aad,
 				aad_len, auth_tag, auth_tag_len);
 	} else {
@@ -192,7 +193,8 @@ static void aesni_gcm_dec_avx(void *ctx, u8 *out,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
-	if (ciphertext_len < AVX_GEN2_OPTSIZE) {
+        struct crypto_aes_ctx *aes_ctx = (struct crypto_aes_ctx*)ctx;
+	if ((ciphertext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length != AES_KEYSIZE_128)) {
 		aesni_gcm_dec(ctx, out, in, ciphertext_len, iv, hash_subkey, aad,
 				aad_len, auth_tag, auth_tag_len);
 	} else {
@@ -226,7 +228,8 @@ static void aesni_gcm_enc_avx2(void *ctx, u8 *out,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
-	if (plaintext_len < AVX_GEN2_OPTSIZE) {
+       struct crypto_aes_ctx *aes_ctx = (struct crypto_aes_ctx*)ctx;
+	if ((plaintext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length != AES_KEYSIZE_128)) {
 		aesni_gcm_enc(ctx, out, in, plaintext_len, iv, hash_subkey, aad,
 				aad_len, auth_tag, auth_tag_len);
 	} else if (plaintext_len < AVX_GEN4_OPTSIZE) {
@@ -245,7 +248,8 @@ static void aesni_gcm_dec_avx2(void *ctx, u8 *out,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
-	if (ciphertext_len < AVX_GEN2_OPTSIZE) {
+       struct crypto_aes_ctx *aes_ctx = (struct crypto_aes_ctx*)ctx;
+	if ((ciphertext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length != AES_KEYSIZE_128)) {
 		aesni_gcm_dec(ctx, out, in, ciphertext_len, iv, hash_subkey,
 				aad, aad_len, auth_tag, auth_tag_len);
 	} else if (ciphertext_len < AVX_GEN4_OPTSIZE) {
@@ -878,7 +882,8 @@ static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
 	}
 	/*Account for 4 byte nonce at the end.*/
 	key_len -= 4;
-	if (key_len != AES_KEYSIZE_128) {
+	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
+	    key_len != AES_KEYSIZE_256) {
 		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
