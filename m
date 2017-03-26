From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/7] crypto: aes/arm64 - eliminate dependency on crypto_aes_set_key()
Date: Sun, 26 Mar 2017 19:49:05 +0100
Message-ID: <1490554148-10953-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:35797 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdCZS4U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 14:56:20 -0400
Received: by mail-wr0-f174.google.com with SMTP id u1so27350097wra.2
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2017 11:56:18 -0700 (PDT)
In-Reply-To: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Call crypto_aes_expand_key() rather than crypto_aes_set_key() so
that we can move to another implementation of it in a subsequent
patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index bcf596b0197e..f4e0e122a86e 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -23,7 +23,6 @@
 #ifdef USE_V8_CRYPTO_EXTENSIONS
 #define MODE			"ce"
 #define PRIO			300
-#define aes_setkey		ce_aes_setkey
 #define aes_expandkey		ce_aes_expandkey
 #define aes_ecb_encrypt		ce_aes_ecb_encrypt
 #define aes_ecb_decrypt		ce_aes_ecb_decrypt
@@ -37,7 +36,6 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #else
 #define MODE			"neon"
 #define PRIO			200
-#define aes_setkey		crypto_aes_set_key
 #define aes_expandkey		crypto_aes_expand_key
 #define aes_ecb_encrypt		neon_aes_ecb_encrypt
 #define aes_ecb_decrypt		neon_aes_ecb_decrypt
@@ -103,7 +101,15 @@ struct mac_desc_ctx {
 static int skcipher_aes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			       unsigned int key_len)
 {
-	return aes_setkey(crypto_skcipher_tfm(tfm), in_key, key_len);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
+
+	ret = aes_expandkey(ctx, in_key, key_len);
+	if (!ret)
+		return 0;
+
+	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
 }
 
 static int xts_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
-- 
2.7.4
