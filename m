From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 14/19] crypto: tea - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:23:02 +0100
Message-ID: <1266538983-3542-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44202 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0BSAXV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Feb 2010 19:23:21 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/tea.c |   68 +++++++++++++++++++++++++++++-----------------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/crypto/tea.c b/crypto/tea.c
index 412bc74..9029bbc 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -1,9 +1,9 @@
-/* 
+/*
  * Cryptographic API.
  *
  * TEA, XTEA, and XETA crypto alogrithms
  *
- * The TEA and Xtended TEA algorithms were developed by David Wheeler 
+ * The TEA and Xtended TEA algorithms were developed by David Wheeler
  * and Roger Needham at the Computer Laboratory of Cambridge University.
  *
  * Due to the order of evaluation in XTEA many people have incorrectly
@@ -55,7 +55,7 @@ static int tea_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 	ctx->KEY[2] = le32_to_cpu(key[2]);
 	ctx->KEY[3] = le32_to_cpu(key[3]);
 
-	return 0; 
+	return 0;
 
 }
 
@@ -82,7 +82,7 @@ static void tea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 		y += ((z << 4) + k0) ^ (z + sum) ^ ((z >> 5) + k1);
 		z += ((y << 4) + k2) ^ (y + sum) ^ ((y >> 5) + k3);
 	}
-	
+
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
 }
@@ -112,7 +112,7 @@ static void tea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 		y -= ((z << 4) + k0) ^ (z + sum) ^ ((z >> 5) + k1);
 		sum -= TEA_DELTA;
 	}
-	
+
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
 }
@@ -128,7 +128,7 @@ static int xtea_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 	ctx->KEY[2] = le32_to_cpu(key[2]);
 	ctx->KEY[3] = le32_to_cpu(key[3]);
 
-	return 0; 
+	return 0;
 
 }
 
@@ -144,11 +144,11 @@ static void xtea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	z = le32_to_cpu(in[1]);
 
 	while (sum != limit) {
-		y += ((z << 4 ^ z >> 5) + z) ^ (sum + ctx->KEY[sum&3]); 
+		y += ((z << 4 ^ z >> 5) + z) ^ (sum + ctx->KEY[sum & 3]);
 		sum += XTEA_DELTA;
-		z += ((y << 4 ^ y >> 5) + y) ^ (sum + ctx->KEY[sum>>11 &3]); 
+		z += ((y << 4 ^ y >> 5) + y) ^ (sum + ctx->KEY[sum>>11 & 3]);
 	}
-	
+
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
 }
@@ -170,7 +170,7 @@ static void xtea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 		sum -= XTEA_DELTA;
 		y -= ((z << 4 ^ z >> 5) + z) ^ (sum + ctx->KEY[sum & 3]);
 	}
-	
+
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
 }
@@ -188,11 +188,11 @@ static void xeta_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	z = le32_to_cpu(in[1]);
 
 	while (sum != limit) {
-		y += (z << 4 ^ z >> 5) + (z ^ sum) + ctx->KEY[sum&3];
+		y += (z << 4 ^ z >> 5) + (z ^ sum) + ctx->KEY[sum & 3];
 		sum += XTEA_DELTA;
-		z += (y << 4 ^ y >> 5) + (y ^ sum) + ctx->KEY[sum>>11 &3];
+		z += (y << 4 ^ y >> 5) + (y ^ sum) + ctx->KEY[sum>>11 & 3];
 	}
-	
+
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
 }
@@ -214,7 +214,7 @@ static void xeta_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 		sum -= XTEA_DELTA;
 		y -= (z << 4 ^ z >> 5) + (z ^ sum) + ctx->KEY[sum & 3];
 	}
-	
+
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
 }
@@ -223,54 +223,54 @@ static struct crypto_alg tea_alg = {
 	.cra_name		=	"tea",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	TEA_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof (struct tea_ctx),
+	.cra_ctxsize		=	sizeof(struct tea_ctx),
 	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(tea_alg.cra_list),
 	.cra_u			=	{ .cipher = {
-	.cia_min_keysize	=	TEA_KEY_SIZE,
-	.cia_max_keysize	=	TEA_KEY_SIZE,
-	.cia_setkey		= 	tea_setkey,
-	.cia_encrypt		=	tea_encrypt,
-	.cia_decrypt		=	tea_decrypt } }
+		.cia_min_keysize	=	TEA_KEY_SIZE,
+		.cia_max_keysize	=	TEA_KEY_SIZE,
+		.cia_setkey		=	tea_setkey,
+		.cia_encrypt		=	tea_encrypt,
+		.cia_decrypt		=	tea_decrypt } }
 };
 
 static struct crypto_alg xtea_alg = {
 	.cra_name		=	"xtea",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	XTEA_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof (struct xtea_ctx),
+	.cra_ctxsize		=	sizeof(struct xtea_ctx),
 	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(xtea_alg.cra_list),
 	.cra_u			=	{ .cipher = {
-	.cia_min_keysize	=	XTEA_KEY_SIZE,
-	.cia_max_keysize	=	XTEA_KEY_SIZE,
-	.cia_setkey		= 	xtea_setkey,
-	.cia_encrypt		=	xtea_encrypt,
-	.cia_decrypt		=	xtea_decrypt } }
+		.cia_min_keysize	=	XTEA_KEY_SIZE,
+		.cia_max_keysize	=	XTEA_KEY_SIZE,
+		.cia_setkey		=	xtea_setkey,
+		.cia_encrypt		=	xtea_encrypt,
+		.cia_decrypt		=	xtea_decrypt } }
 };
 
 static struct crypto_alg xeta_alg = {
 	.cra_name		=	"xeta",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	XTEA_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof (struct xtea_ctx),
+	.cra_ctxsize		=	sizeof(struct xtea_ctx),
 	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(xtea_alg.cra_list),
 	.cra_u			=	{ .cipher = {
-	.cia_min_keysize	=	XTEA_KEY_SIZE,
-	.cia_max_keysize	=	XTEA_KEY_SIZE,
-	.cia_setkey		= 	xtea_setkey,
-	.cia_encrypt		=	xeta_encrypt,
-	.cia_decrypt		=	xeta_decrypt } }
+		.cia_min_keysize	=	XTEA_KEY_SIZE,
+		.cia_max_keysize	=	XTEA_KEY_SIZE,
+		.cia_setkey		=	xtea_setkey,
+		.cia_encrypt		=	xeta_encrypt,
+		.cia_decrypt		=	xeta_decrypt } }
 };
 
 static int __init tea_mod_init(void)
 {
 	int ret = 0;
-	
+
 	ret = crypto_register_alg(&tea_alg);
 	if (ret < 0)
 		goto out;
@@ -288,7 +288,7 @@ static int __init tea_mod_init(void)
 		goto out;
 	}
 
-out:	
+out:
 	return ret;
 }
 
-- 
1.6.6.1

