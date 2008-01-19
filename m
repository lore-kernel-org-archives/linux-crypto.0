From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] [crypto] cipher: add return parameter
Date: Sat, 19 Jan 2008 01:02:14 +0100
Message-ID: <1200700935-3844-5-git-send-email-sebastian@breakpoint.cc>
References: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@ml.breakpoint.cc,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38856 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbYASIdv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2008 03:33:51 -0500
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1JG99B-0002dJ-Fy
	for linux-crypto@vger.kernel.org; Sat, 19 Jan 2008 09:33:49 +0100
In-Reply-To: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Software usually can't fail because they don't do anything
dangerous. However HW implementation could fail for $reason.
This patch changes the prototype and adjusts all ciphers. Most
of them return zero except s390 and geode since the HW provides
a return parameter.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/s390/crypto/aes_s390.c    |   14 ++++++------
 arch/s390/crypto/des_s390.c    |   24 +++++++++++-----------
 arch/x86/crypto/aes_glue.c     |    6 +++-
 arch/x86/crypto/twofish_glue.c |    6 +++-
 crypto/aes_generic.c           |    6 +++-
 crypto/anubis.c                |    6 +++-
 crypto/arc4.c                  |    3 +-
 crypto/blowfish.c              |    6 +++-
 crypto/camellia.c              |    6 +++-
 crypto/cast5.c                 |    6 +++-
 crypto/cast6.c                 |    6 +++-
 crypto/cbc.c                   |    8 +++---
 crypto/cipher.c                |   20 +++++++++---------
 crypto/crypto_null.c           |    3 +-
 crypto/ctr.c                   |    4 +-
 crypto/des_generic.c           |   12 +++++++---
 crypto/ecb.c                   |    2 +-
 crypto/fcrypt.c                |    6 +++-
 crypto/khazad.c                |    6 +++-
 crypto/lrw.c                   |    4 +-
 crypto/pcbc.c                  |    6 ++--
 crypto/seed.c                  |    6 +++-
 crypto/serpent.c               |   12 +++++++---
 crypto/tea.c                   |   18 +++++++++++-----
 crypto/twofish.c               |    8 +++---
 crypto/xts.c                   |    6 ++--
 drivers/crypto/geode-aes.c     |   42 +++++++++++++++++++--------------------
 drivers/crypto/padlock-aes.c   |    6 +++-
 include/linux/crypto.h         |    8 +++---
 29 files changed, 152 insertions(+), 114 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 46c9705..dc12e07 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -110,7 +110,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return setkey_fallback_cip(tfm, in_key, key_len);
 }
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 
@@ -121,15 +121,15 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 
 	switch (sctx->key_len) {
 	case 16:
-		crypt_s390_km(KM_AES_128_ENCRYPT, &sctx->key, out, in,
+		return crypt_s390_km(KM_AES_128_ENCRYPT, &sctx->key, out, in,
 			      AES_BLOCK_SIZE);
 		break;
 	case 24:
-		crypt_s390_km(KM_AES_192_ENCRYPT, &sctx->key, out, in,
+		return crypt_s390_km(KM_AES_192_ENCRYPT, &sctx->key, out, in,
 			      AES_BLOCK_SIZE);
 		break;
 	case 32:
-		crypt_s390_km(KM_AES_256_ENCRYPT, &sctx->key, out, in,
+		return crypt_s390_km(KM_AES_256_ENCRYPT, &sctx->key, out, in,
 			      AES_BLOCK_SIZE);
 		break;
 	}
@@ -146,15 +146,15 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 
 	switch (sctx->key_len) {
 	case 16:
-		crypt_s390_km(KM_AES_128_DECRYPT, &sctx->key, out, in,
+		return crypt_s390_km(KM_AES_128_DECRYPT, &sctx->key, out, in,
 			      AES_BLOCK_SIZE);
 		break;
 	case 24:
-		crypt_s390_km(KM_AES_192_DECRYPT, &sctx->key, out, in,
+		return crypt_s390_km(KM_AES_192_DECRYPT, &sctx->key, out, in,
 			      AES_BLOCK_SIZE);
 		break;
 	case 32:
-		crypt_s390_km(KM_AES_256_DECRYPT, &sctx->key, out, in,
+		return crypt_s390_km(KM_AES_256_DECRYPT, &sctx->key, out, in,
 			      AES_BLOCK_SIZE);
 		break;
 	}
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index ea22707..c3fa6dd 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -59,18 +59,18 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return ret;
 }
 
-static void des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct crypt_s390_des_ctx *dctx = crypto_tfm_ctx(tfm);
 
-	crypt_s390_km(KM_DEA_ENCRYPT, dctx->key, out, in, DES_BLOCK_SIZE);
+	return crypt_s390_km(KM_DEA_ENCRYPT, dctx->key, out, in, DES_BLOCK_SIZE);
 }
 
-static void des_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int des_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct crypt_s390_des_ctx *dctx = crypto_tfm_ctx(tfm);
 
-	crypt_s390_km(KM_DEA_DECRYPT, dctx->key, out, in, DES_BLOCK_SIZE);
+	return crypt_s390_km(KM_DEA_DECRYPT, dctx->key, out, in, DES_BLOCK_SIZE);
 }
 
 static struct crypto_alg des_alg = {
@@ -263,19 +263,19 @@ static int des3_128_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return 0;
 }
 
-static void des3_128_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int des3_128_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypt_s390_des3_128_ctx *dctx = crypto_tfm_ctx(tfm);
 
-	crypt_s390_km(KM_TDEA_128_ENCRYPT, dctx->key, dst, (void*)src,
+	return crypt_s390_km(KM_TDEA_128_ENCRYPT, dctx->key, dst, (void*)src,
 		      DES3_128_BLOCK_SIZE);
 }
 
-static void des3_128_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int des3_128_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypt_s390_des3_128_ctx *dctx = crypto_tfm_ctx(tfm);
 
-	crypt_s390_km(KM_TDEA_128_DECRYPT, dctx->key, dst, (void*)src,
+	return crypt_s390_km(KM_TDEA_128_DECRYPT, dctx->key, dst, (void*)src,
 		      DES3_128_BLOCK_SIZE);
 }
 
@@ -425,19 +425,19 @@ static int des3_192_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return 0;
 }
 
-static void des3_192_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int des3_192_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypt_s390_des3_192_ctx *dctx = crypto_tfm_ctx(tfm);
 
-	crypt_s390_km(KM_TDEA_192_ENCRYPT, dctx->key, dst, (void*)src,
+	return crypt_s390_km(KM_TDEA_192_ENCRYPT, dctx->key, dst, (void*)src,
 		      DES3_192_BLOCK_SIZE);
 }
 
-static void des3_192_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int des3_192_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypt_s390_des3_192_ctx *dctx = crypto_tfm_ctx(tfm);
 
-	crypt_s390_km(KM_TDEA_192_DECRYPT, dctx->key, dst, (void*)src,
+	return crypt_s390_km(KM_TDEA_192_DECRYPT, dctx->key, dst, (void*)src,
 		      DES3_192_BLOCK_SIZE);
 }
 
diff --git a/arch/x86/crypto/aes_glue.c b/arch/x86/crypto/aes_glue.c
index 71f4578..d844afd 100644
--- a/arch/x86/crypto/aes_glue.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -8,14 +8,16 @@
 asmlinkage void aes_enc_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in);
 asmlinkage void aes_dec_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in);
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	aes_enc_blk(tfm, dst, src);
+	return 0;
 }
 
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	aes_dec_blk(tfm, dst, src);
+	return 0;
 }
 
 static struct crypto_alg aes_alg = {
diff --git a/arch/x86/crypto/twofish_glue.c b/arch/x86/crypto/twofish_glue.c
index cefaf8b..028a1ae 100644
--- a/arch/x86/crypto/twofish_glue.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -47,14 +47,16 @@
 asmlinkage void twofish_enc_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 asmlinkage void twofish_dec_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 
-static void twofish_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int twofish_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	twofish_enc_blk(tfm, dst, src);
+	return 0;
 }
 
-static void twofish_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int twofish_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	twofish_dec_blk(tfm, dst, src);
+	return 0;
 }
 
 static struct crypto_alg alg = {
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index cf30af7..f33a99c 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -317,7 +317,7 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
 	f_rl(bo, bi, 3, k);	\
 } while (0)
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __le32 *src = (const __le32 *)in;
@@ -356,6 +356,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	dst[1] = cpu_to_le32(b0[1]);
 	dst[2] = cpu_to_le32(b0[2]);
 	dst[3] = cpu_to_le32(b0[3]);
+	return 0;
 }
 
 /* decrypt a block of text */
@@ -389,7 +390,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	i_rl(bo, bi, 3, k);	\
 } while (0)
 
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __le32 *src = (const __le32 *)in;
@@ -428,6 +429,7 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	dst[1] = cpu_to_le32(b0[1]);
 	dst[2] = cpu_to_le32(b0[2]);
 	dst[3] = cpu_to_le32(b0[3]);
+	return 0;
 }
 
 static struct crypto_alg aes_alg = {
diff --git a/crypto/anubis.c b/crypto/anubis.c
index 4ff0e1e..8241f62 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -659,16 +659,18 @@ static void anubis_crypt(u32 roundKey[ANUBIS_MAX_ROUNDS + 1][4],
 		dst[i] = cpu_to_be32(inter[i]);
 }
 
-static void anubis_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int anubis_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct anubis_ctx *ctx = crypto_tfm_ctx(tfm);
 	anubis_crypt(ctx->E, dst, src, ctx->R);
+	return 0;
 }
 
-static void anubis_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int anubis_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct anubis_ctx *ctx = crypto_tfm_ctx(tfm);
 	anubis_crypt(ctx->D, dst, src, ctx->R);
+	return 0;
 }
 
 static struct crypto_alg anubis_alg = {
diff --git a/crypto/arc4.c b/crypto/arc4.c
index 8be47e1..2f27a07 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -49,7 +49,7 @@ static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 }
 
-static void arc4_crypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int arc4_crypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
 
@@ -68,6 +68,7 @@ static void arc4_crypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 
 	ctx->x = x;
 	ctx->y = y;
+	return 0;
 }
 
 static struct crypto_alg arc4_alg = {
diff --git a/crypto/blowfish.c b/crypto/blowfish.c
index 80c3fd8..7385bcd 100644
--- a/crypto/blowfish.c
+++ b/crypto/blowfish.c
@@ -348,7 +348,7 @@ static void encrypt_block(struct bf_ctx *bctx, u32 *dst, u32 *src)
 	dst[1] = yl;
 }
 
-static void bf_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int bf_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	const __be32 *in_blk = (const __be32 *)src;
 	__be32 *const out_blk = (__be32 *)dst;
@@ -359,9 +359,10 @@ static void bf_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	encrypt_block(crypto_tfm_ctx(tfm), out32, in32);
 	out_blk[0] = cpu_to_be32(out32[0]);
 	out_blk[1] = cpu_to_be32(out32[1]);
+	return 0;
 }
 
-static void bf_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int bf_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct bf_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __be32 *in_blk = (const __be32 *)src;
@@ -393,6 +394,7 @@ static void bf_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 
 	out_blk[0] = cpu_to_be32(yr);
 	out_blk[1] = cpu_to_be32(yl);
+	return 0;
 }
 
 /* 
diff --git a/crypto/camellia.c b/crypto/camellia.c
index 493fee7..37d416e 100644
--- a/crypto/camellia.c
+++ b/crypto/camellia.c
@@ -1042,7 +1042,7 @@ camellia_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 }
 
-static void camellia_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int camellia_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)in;
@@ -1064,9 +1064,10 @@ static void camellia_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	dst[1] = cpu_to_be32(tmp[3]);
 	dst[2] = cpu_to_be32(tmp[0]);
 	dst[3] = cpu_to_be32(tmp[1]);
+	return 0;
 }
 
-static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)in;
@@ -1088,6 +1089,7 @@ static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	dst[1] = cpu_to_be32(tmp[3]);
 	dst[2] = cpu_to_be32(tmp[0]);
 	dst[3] = cpu_to_be32(tmp[1]);
+	return 0;
 }
 
 static struct crypto_alg camellia_alg = {
diff --git a/crypto/cast5.c b/crypto/cast5.c
index 13ea60a..4eef890 100644
--- a/crypto/cast5.c
+++ b/crypto/cast5.c
@@ -577,7 +577,7 @@ static const u32 sb8[256] = {
     (((s1[I >> 24] + s2[(I>>16)&0xff]) ^ s3[(I>>8)&0xff]) - s4[I&0xff]) )
 
 
-static void cast5_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
+static int cast5_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 {
 	struct cast5_ctx *c = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)inbuf;
@@ -640,9 +640,10 @@ static void cast5_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 	 *  concatenate to form the ciphertext.) */
 	dst[0] = cpu_to_be32(r);
 	dst[1] = cpu_to_be32(l);
+	return 0;
 }
 
-static void cast5_decrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
+static int cast5_decrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 {
 	struct cast5_ctx *c = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)inbuf;
@@ -692,6 +693,7 @@ static void cast5_decrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 
 	dst[0] = cpu_to_be32(r);
 	dst[1] = cpu_to_be32(l);
+	return 0;
 }
 
 static void key_schedule(u32 * x, u32 * z, u32 * k)
diff --git a/crypto/cast6.c b/crypto/cast6.c
index 5fd9420..0e23e26 100644
--- a/crypto/cast6.c
+++ b/crypto/cast6.c
@@ -445,7 +445,7 @@ static void QBAR (u32 * block, u8 * Kr, u32 * Km) {
         block[2] ^= F1(block[3], Kr[0], Km[0]);
 }
 
-static void cast6_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
+static int cast6_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 {
 	struct cast6_ctx *c = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)inbuf;
@@ -476,9 +476,10 @@ static void cast6_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 	dst[1] = cpu_to_be32(block[1]);
 	dst[2] = cpu_to_be32(block[2]);
 	dst[3] = cpu_to_be32(block[3]);
+	return 0;
 }	
 
-static void cast6_decrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf) {
+static int cast6_decrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf) {
 	struct cast6_ctx * c = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)inbuf;
 	__be32 *dst = (__be32 *)outbuf;
@@ -508,6 +509,7 @@ static void cast6_decrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf) {
 	dst[1] = cpu_to_be32(block[1]);
 	dst[2] = cpu_to_be32(block[2]);
 	dst[3] = cpu_to_be32(block[3]);
+	return 0;
 }	
 
 static struct crypto_alg alg = {
diff --git a/crypto/cbc.c b/crypto/cbc.c
index 6affff8..a525dcc 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -43,7 +43,7 @@ static int crypto_cbc_encrypt_segment(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
 				      struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_encrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
@@ -67,7 +67,7 @@ static int crypto_cbc_encrypt_inplace(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
 				      struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_encrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
@@ -115,7 +115,7 @@ static int crypto_cbc_decrypt_segment(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
 				      struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_decrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
@@ -141,7 +141,7 @@ static int crypto_cbc_decrypt_inplace(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
 				      struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_decrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
diff --git a/crypto/cipher.c b/crypto/cipher.c
index 9a1a731..625ad73 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -60,47 +60,47 @@ static int setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 	return cia->cia_setkey(tfm, key, keylen);
 }
 
-static void cipher_crypt_unaligned(void (*fn)(struct crypto_tfm *, u8 *,
+static int cipher_crypt_unaligned(int (*fn)(struct crypto_tfm *, u8 *,
 					      const u8 *),
 				   struct crypto_tfm *tfm,
 				   u8 *dst, const u8 *src)
 {
+	int ret;
 	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
 	unsigned int size = crypto_tfm_alg_blocksize(tfm);
 	u8 buffer[size + alignmask];
 	u8 *tmp = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 
 	memcpy(tmp, src, size);
-	fn(tfm, tmp, tmp);
+	ret = fn(tfm, tmp, tmp);
 	memcpy(dst, tmp, size);
+	return ret;
 }
 
-static void cipher_encrypt_unaligned(struct crypto_tfm *tfm,
+static int cipher_encrypt_unaligned(struct crypto_tfm *tfm,
 				     u8 *dst, const u8 *src)
 {
 	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
 	struct cipher_alg *cipher = &tfm->__crt_alg->cra_cipher;
 
 	if (unlikely(((unsigned long)dst | (unsigned long)src) & alignmask)) {
-		cipher_crypt_unaligned(cipher->cia_encrypt, tfm, dst, src);
-		return;
+		return cipher_crypt_unaligned(cipher->cia_encrypt, tfm, dst, src);
 	}
 
-	cipher->cia_encrypt(tfm, dst, src);
+	return cipher->cia_encrypt(tfm, dst, src);
 }
 
-static void cipher_decrypt_unaligned(struct crypto_tfm *tfm,
+static int cipher_decrypt_unaligned(struct crypto_tfm *tfm,
 				     u8 *dst, const u8 *src)
 {
 	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
 	struct cipher_alg *cipher = &tfm->__crt_alg->cra_cipher;
 
 	if (unlikely(((unsigned long)dst | (unsigned long)src) & alignmask)) {
-		cipher_crypt_unaligned(cipher->cia_decrypt, tfm, dst, src);
-		return;
+		return cipher_crypt_unaligned(cipher->cia_decrypt, tfm, dst, src);
 	}
 
-	cipher->cia_decrypt(tfm, dst, src);
+	return cipher->cia_decrypt(tfm, dst, src);
 }
 
 int crypto_init_cipher_ops(struct crypto_tfm *tfm)
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index ff7b3de..cef6f15 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -52,9 +52,10 @@ static int null_setkey(struct crypto_tfm *tfm, const u8 *key,
 		       unsigned int keylen)
 { return 0; }
 
-static void null_crypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int null_crypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	memcpy(dst, src, NULL_BLOCK_SIZE);
+	return 0;
 }
 
 static int skcipher_null_crypt(struct blkcipher_desc *desc,
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 2d7425f..c2f74f3 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -68,7 +68,7 @@ static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
 static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
 				    struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		   crypto_cipher_alg(tfm)->cia_encrypt;
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
 	u8 *ctrblk = walk->iv;
@@ -94,7 +94,7 @@ static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
 static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 				    struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		   crypto_cipher_alg(tfm)->cia_encrypt;
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
 	unsigned long alignmask = crypto_cipher_alignmask(tfm);
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 355ecb7..7554b80 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -800,7 +800,7 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return 0;
 }
 
-static void des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u32 *K = ctx->expkey;
@@ -821,9 +821,10 @@ static void des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 
 	d[0] = cpu_to_le32(R);
 	d[1] = cpu_to_le32(L);
+	return 0;
 }
 
-static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u32 *K = ctx->expkey + DES_EXPKEY_WORDS - 2;
@@ -844,6 +845,7 @@ static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 
 	d[0] = cpu_to_le32(R);
 	d[1] = cpu_to_le32(L);
+	return 0;
 }
 
 /*
@@ -881,7 +883,7 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return 0;
 }
 
-static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des3_ede_ctx *dctx = crypto_tfm_ctx(tfm);
 	const u32 *K = dctx->expkey;
@@ -910,9 +912,10 @@ static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 
 	d[0] = cpu_to_le32(R);
 	d[1] = cpu_to_le32(L);
+	return 0;
 }
 
-static void des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des3_ede_ctx *dctx = crypto_tfm_ctx(tfm);
 	const u32 *K = dctx->expkey + DES3_EDE_EXPKEY_WORDS - 2;
@@ -941,6 +944,7 @@ static void des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 
 	d[0] = cpu_to_le32(R);
 	d[1] = cpu_to_le32(L);
+	return 0;
 }
 
 static struct crypto_alg des_alg = {
diff --git a/crypto/ecb.c b/crypto/ecb.c
index 6310387..1edb94f 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -41,7 +41,7 @@ static int crypto_ecb_setkey(struct crypto_tfm *parent, const u8 *key,
 static int crypto_ecb_crypt(struct blkcipher_desc *desc,
 			    struct blkcipher_walk *walk,
 			    struct crypto_cipher *tfm,
-			    void (*fn)(struct crypto_tfm *, u8 *, const u8 *))
+			    int (*fn)(struct crypto_tfm *, u8 *, const u8 *))
 {
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes;
diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index a32cb68..1cc94d5 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -233,7 +233,7 @@ do {									\
 /*
  * encryptor
  */
-static void fcrypt_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int fcrypt_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	const struct fcrypt_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct {
@@ -260,12 +260,13 @@ static void fcrypt_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	F_ENCRYPT(X.l, X.r, ctx->sched[0xf]);
 
 	memcpy(dst, &X, sizeof(X));
+	return 0;
 }
 
 /*
  * decryptor
  */
-static void fcrypt_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int fcrypt_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	const struct fcrypt_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct {
@@ -292,6 +293,7 @@ static void fcrypt_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	F_ENCRYPT(X.r, X.l, ctx->sched[0x0]);
 
 	memcpy(dst, &X, sizeof(X));
+	return 0;
 }
 
 /*
diff --git a/crypto/khazad.c b/crypto/khazad.c
index 704ebfe..9eaff36 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -834,16 +834,18 @@ static void khazad_crypt(const u64 roundKey[KHAZAD_ROUNDS + 1],
 	*dst = cpu_to_be64(state);
 }
 
-static void khazad_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int khazad_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct khazad_ctx *ctx = crypto_tfm_ctx(tfm);
 	khazad_crypt(ctx->E, dst, src);
+	return 0;
 }
 
-static void khazad_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int khazad_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct khazad_ctx *ctx = crypto_tfm_ctx(tfm);
 	khazad_crypt(ctx->D, dst, src);
+	return 0;
 }
 
 static struct crypto_alg khazad_alg = {
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 621095d..b15f3f8 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -86,7 +86,7 @@ static int setkey(struct crypto_tfm *parent, const u8 *key,
 struct sinfo {
 	be128 t;
 	struct crypto_tfm *tfm;
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *);
 };
 
 static inline void inc(be128 *iv)
@@ -123,7 +123,7 @@ static inline int get_index128(be128 *block)
 
 static int crypt(struct blkcipher_desc *d,
 		 struct blkcipher_walk *w, struct priv *ctx,
-		 void (*fn)(struct crypto_tfm *, u8 *, const u8 *))
+		 int (*fn)(struct crypto_tfm *, u8 *, const u8 *))
 {
 	int err;
 	unsigned int avail;
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index fe70477..819504c 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -71,7 +71,7 @@ static int crypto_pcbc_encrypt_inplace(struct blkcipher_desc *desc,
 				       struct blkcipher_walk *walk,
 				       struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_encrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
@@ -124,7 +124,7 @@ static int crypto_pcbc_decrypt_segment(struct blkcipher_desc *desc,
 				       struct blkcipher_walk *walk,
 				       struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_decrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
@@ -151,7 +151,7 @@ static int crypto_pcbc_decrypt_inplace(struct blkcipher_desc *desc,
 				       struct blkcipher_walk *walk,
 				       struct crypto_cipher *tfm)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_decrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
diff --git a/crypto/seed.c b/crypto/seed.c
index d3e422f..af750bc 100644
--- a/crypto/seed.c
+++ b/crypto/seed.c
@@ -365,7 +365,7 @@ static int seed_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 /* encrypt a block of text */
 
-static void seed_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int seed_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)in;
@@ -399,11 +399,12 @@ static void seed_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	dst[1] = cpu_to_be32(x4);
 	dst[2] = cpu_to_be32(x1);
 	dst[3] = cpu_to_be32(x2);
+	return 0;
 }
 
 /* decrypt a block of text */
 
-static void seed_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int seed_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)in;
@@ -437,6 +438,7 @@ static void seed_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	dst[1] = cpu_to_be32(x4);
 	dst[2] = cpu_to_be32(x1);
 	dst[3] = cpu_to_be32(x2);
+	return 0;
 }
 
 
diff --git a/crypto/serpent.c b/crypto/serpent.c
index 2b0a19a..2e4ff9a 100644
--- a/crypto/serpent.c
+++ b/crypto/serpent.c
@@ -360,7 +360,7 @@ static int serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return 0;
 }
 
-static void serpent_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int serpent_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct serpent_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u32
@@ -417,9 +417,10 @@ static void serpent_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	d[1] = cpu_to_le32(r1);
 	d[2] = cpu_to_le32(r2);
 	d[3] = cpu_to_le32(r3);
+	return 0;
 }
 
-static void serpent_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int serpent_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct serpent_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u32
@@ -471,6 +472,7 @@ static void serpent_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	d[1] = cpu_to_le32(r3);
 	d[2] = cpu_to_le32(r1);
 	d[3] = cpu_to_le32(r4);
+	return 0;
 }
 
 static struct crypto_alg serpent_alg = {
@@ -501,7 +503,7 @@ static int tnepres_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return serpent_setkey(tfm, rev_key, keylen);
 }
 
-static void tnepres_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int tnepres_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	const u32 * const s = (const u32 * const)src;
 	u32 * const d = (u32 * const)dst;
@@ -519,9 +521,10 @@ static void tnepres_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	d[1] = swab32(rd[2]);
 	d[2] = swab32(rd[1]);
 	d[3] = swab32(rd[0]);
+	return 0;
 }
 
-static void tnepres_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int tnepres_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	const u32 * const s = (const u32 * const)src;
 	u32 * const d = (u32 * const)dst;
@@ -539,6 +542,7 @@ static void tnepres_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	d[1] = swab32(rd[2]);
 	d[2] = swab32(rd[1]);
 	d[3] = swab32(rd[0]);
+	return 0;
 }
 
 static struct crypto_alg tnepres_alg = {
diff --git a/crypto/tea.c b/crypto/tea.c
index 6893b3f..efb23a3 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -59,7 +59,7 @@ static int tea_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 
 }
 
-static void tea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int tea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, n, sum = 0;
 	u32 k0, k1, k2, k3;
@@ -85,9 +85,10 @@ static void tea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
+	return 0;
 }
 
-static void tea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int tea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, n, sum;
 	u32 k0, k1, k2, k3;
@@ -115,6 +116,7 @@ static void tea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
+	return 0;
 }
 
 static int xtea_setkey(struct crypto_tfm *tfm, const u8 *in_key,
@@ -132,7 +134,7 @@ static int xtea_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 
 }
 
-static void xtea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int xtea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, sum = 0;
 	u32 limit = XTEA_DELTA * XTEA_ROUNDS;
@@ -151,9 +153,10 @@ static void xtea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
+	return 0;
 }
 
-static void xtea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int xtea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, sum;
 	struct tea_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -173,10 +176,11 @@ static void xtea_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
+	return 0;
 }
 
 
-static void xeta_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int xeta_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, sum = 0;
 	u32 limit = XTEA_DELTA * XTEA_ROUNDS;
@@ -195,9 +199,10 @@ static void xeta_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
+	return 0;
 }
 
-static void xeta_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static int xeta_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	u32 y, z, sum;
 	struct tea_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -217,6 +222,7 @@ static void xeta_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	
 	out[0] = cpu_to_le32(y);
 	out[1] = cpu_to_le32(z);
+	return 0;
 }
 
 static struct crypto_alg tea_alg = {
diff --git a/crypto/twofish.c b/crypto/twofish.c
index 4979a2b..aa9beaf 100644
--- a/crypto/twofish.c
+++ b/crypto/twofish.c
@@ -106,7 +106,7 @@
 
 
 /* Encrypt one block.  in and out may be the same. */
-static void twofish_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int twofish_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct twofish_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __le32 *src = (const __le32 *)in;
@@ -139,11 +139,11 @@ static void twofish_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	OUTUNPACK (1, d, 5);
 	OUTUNPACK (2, a, 6);
 	OUTUNPACK (3, b, 7);
-	
+	return 0;
 }
 
 /* Decrypt one block.  in and out may be the same. */
-static void twofish_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int twofish_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct twofish_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __le32 *src = (const __le32 *)in;
@@ -176,7 +176,7 @@ static void twofish_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	OUTUNPACK (1, b, 1);
 	OUTUNPACK (2, c, 2);
 	OUTUNPACK (3, d, 3);
-
+	return 0;
 }
 
 static struct crypto_alg alg = {
diff --git a/crypto/xts.c b/crypto/xts.c
index 8eb08bf..a154b2c 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -79,7 +79,7 @@ static int setkey(struct crypto_tfm *parent, const u8 *key,
 struct sinfo {
 	be128 t;
 	struct crypto_tfm *tfm;
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
+	int (*fn)(struct crypto_tfm *, u8 *, const u8 *);
 };
 
 static inline void xts_round(struct sinfo *s, void *dst, const void *src)
@@ -91,8 +91,8 @@ static inline void xts_round(struct sinfo *s, void *dst, const void *src)
 
 static int crypt(struct blkcipher_desc *d,
 		 struct blkcipher_walk *w, struct priv *ctx,
-		 void (*tw)(struct crypto_tfm *, u8 *, const u8 *),
-		 void (*fn)(struct crypto_tfm *, u8 *, const u8 *))
+		 int (*tw)(struct crypto_tfm *, u8 *, const u8 *),
+		 int (*fn)(struct crypto_tfm *, u8 *, const u8 *))
 {
 	int err;
 	unsigned int avail;
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 4801162..a757d2b 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -63,7 +63,7 @@ do_crypt(void *src, void *dst, int len, u32 flags)
 
 	/* Clear the event */
 	iowrite32((status & 0xFF) | AES_INTRA_PENDING, _iobase + AES_INTR_REG);
-	return counter ? 0 : 1;
+	return counter ? 0 : -1;
 }
 
 static unsigned int
@@ -101,14 +101,13 @@ geode_aes_crypt(struct geode_aes_op *op)
 	}
 
 	ret = do_crypt(op->src, op->dst, op->len, flags);
-	BUG_ON(ret);
 
 	if (op->mode == AES_MODE_CBC)
 		_readfield(AES_WRITEIV0_REG, op->iv);
 
 	spin_unlock_irqrestore(&lock, iflags);
 
-	return op->len;
+	return ret;
 }
 
 /* CRYPTO-API Functions */
@@ -212,14 +211,14 @@ static int fallback_blk_enc(struct blkcipher_desc *desc,
 	return ret;
 }
 
-static void
+static int
 geode_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
 	if (unlikely(op->keylen != AES_KEYSIZE_128)) {
 		crypto_cipher_encrypt_one(op->fallback.cip, out, in);
-		return;
+		return 0;
 	}
 
 	op->src = (void *) in;
@@ -229,18 +228,18 @@ geode_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	op->len = AES_MIN_BLOCK_SIZE;
 	op->dir = AES_DIR_ENCRYPT;
 
-	geode_aes_crypt(op);
+	return geode_aes_crypt(op);
 }
 
 
-static void
+static int
 geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
 	if (unlikely(op->keylen != AES_KEYSIZE_128)) {
 		crypto_cipher_decrypt_one(op->fallback.cip, out, in);
-		return;
+		return 0;
 	}
 
 	op->src = (void *) in;
@@ -250,7 +249,7 @@ geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	op->len = AES_MIN_BLOCK_SIZE;
 	op->dir = AES_DIR_DECRYPT;
 
-	geode_aes_crypt(op);
+	return geode_aes_crypt(op);
 }
 
 static int fallback_init_cip(struct crypto_tfm *tfm)
@@ -308,7 +307,7 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 {
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
-	int err, ret;
+	int err, ret = 0;
 
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
@@ -325,12 +324,11 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 		op->dir = AES_DIR_DECRYPT;
 
 		ret = geode_aes_crypt(op);
-
-		nbytes -= ret;
+		nbytes -= op->len;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	return err;
+	return err ? err : ret;
 }
 
 static int
@@ -340,7 +338,7 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 {
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
-	int err, ret;
+	int err, ret = 0;
 
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
@@ -357,11 +355,11 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 		op->dir = AES_DIR_ENCRYPT;
 
 		ret = geode_aes_crypt(op);
-		nbytes -= ret;
+		nbytes -= op->len;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	return err;
+	return err ? err : ret;
 }
 
 static int fallback_init_blk(struct crypto_tfm *tfm)
@@ -421,7 +419,7 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 {
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
-	int err, ret;
+	int err, ret = 0;
 
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
@@ -437,11 +435,11 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 		op->dir = AES_DIR_DECRYPT;
 
 		ret = geode_aes_crypt(op);
-		nbytes -= ret;
+		nbytes -= op->len;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	return err;
+	return err ? err : ret;
 }
 
 static int
@@ -451,7 +449,7 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 {
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
-	int err, ret;
+	int err, ret = 0;
 
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
@@ -467,11 +465,11 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 		op->dir = AES_DIR_ENCRYPT;
 
 		ret = geode_aes_crypt(op);
-		nbytes -= ret;
+		nbytes -= op->len;
 		ret =  blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	return err;
+	return err ? err : ret;
 }
 
 static struct crypto_alg geode_ecb_alg = {
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 2f3ad3f..08fc240 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -483,18 +483,20 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
 	return iv;
 }
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
 	padlock_reset_key();
 	aes_crypt(in, out, ctx->E, &ctx->cword.encrypt);
+	return 0;
 }
 
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static int aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
 	padlock_reset_key();
 	aes_crypt(in, out, ctx->D, &ctx->cword.decrypt);
+	return 0;
 }
 
 static struct crypto_alg aes_alg = {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 5e02d1b..9ee7fea 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -232,8 +232,8 @@ struct cipher_alg {
 	unsigned int cia_max_keysize;
 	int (*cia_setkey)(struct crypto_tfm *tfm, const u8 *key,
 	                  unsigned int keylen);
-	void (*cia_encrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-	void (*cia_decrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
+	int (*cia_encrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
+	int (*cia_decrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 };
 
 struct digest_alg {
@@ -374,8 +374,8 @@ struct blkcipher_tfm {
 struct cipher_tfm {
 	int (*cit_setkey)(struct crypto_tfm *tfm,
 	                  const u8 *key, unsigned int keylen);
-	void (*cit_encrypt_one)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-	void (*cit_decrypt_one)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
+	int (*cit_encrypt_one)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
+	int (*cit_decrypt_one)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 };
 
 struct hash_tfm {
-- 
1.5.3.6
