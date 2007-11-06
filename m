From: Jonathan Lynch <jonathan.lynch@intel.com>
Subject: [PATCH] [CRYPTO] Extend sha256_generic.c to support SHA-224 and SHA-224-HMAC
Date: Tue, 6 Nov 2007 18:28:00 +0000
Message-ID: <20071106182800.GA32299@compsoc.nuigalway.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, jonathan.lynch@intel.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.nuigalway.ie ([140.203.201.100]:11337 "EHLO
	mx1.nuigalway.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbXKFSaI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 13:30:08 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


This patch extends sha256_generic.c to support SHA-224 as described in
FIPS 180-2 and RFC 3874. HMAC-SHA-224 as described in RFC4231 is then
supported through the hmac interface.

SHA-224 should be chosen as a hash algorithm when 112 bits of security
strength is required.

Patch includes test vectors for SHA-224 and HMAC-SHA-224 taken from the
above mentioned standards to the tcrypt test suite. The tests pass with
the vectors for SHA-224 and HMAC-SHA-224.

Patch generated against the 2.6.24-rc1 kernel and I have tested against
2.6.24-rc1-git14 which includes fix for scatter gather implementation
for HMAC. 

Please Apply.

Signed-off-by: Jonathan Lynch <jonathan.lynch@intel.com>

---

diff -uprN -X linux-2.6.24-rc1-vanilla/Documentation/dontdiff linux-2.6.24-rc1-vanilla/crypto/Kconfig linux-2.6.24-rc1/crypto/Kconfig
--- linux-2.6.24-rc1-vanilla/crypto/Kconfig	2007-11-05 17:12:50.291842000 +0000
+++ linux-2.6.24-rc1/crypto/Kconfig	2007-11-05 18:18:31.571720000 +0000
@@ -91,7 +91,7 @@ config CRYPTO_SHA1
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
 config CRYPTO_SHA256
-	tristate "SHA256 digest algorithm"
+	tristate "SHA224 and SHA256 digest algorithm"
 	select CRYPTO_ALGAPI
 	help
 	  SHA256 secure hash standard (DFIPS 180-2).
@@ -99,6 +99,9 @@ config CRYPTO_SHA256
 	  This version of SHA implements a 256 bit hash with 128 bits of
 	  security against collision attacks.
 
+          This code also includes SHA-224, a 224 bit hash with 112 bits
+          of security against collision attacks.
+
 config CRYPTO_SHA512
 	tristate "SHA384 and SHA512 digest algorithms"
 	select CRYPTO_ALGAPI
diff -uprN -X linux-2.6.24-rc1-vanilla/Documentation/dontdiff linux-2.6.24-rc1-vanilla/crypto/sha256_generic.c linux-2.6.24-rc1/crypto/sha256_generic.c
--- linux-2.6.24-rc1-vanilla/crypto/sha256_generic.c	2007-11-05 17:12:50.454842000 +0000
+++ linux-2.6.24-rc1/crypto/sha256_generic.c	2007-11-06 14:24:52.872908000 +0000
@@ -9,6 +9,7 @@
  * Copyright (c) Jean-Luc Cooke <jlcooke@certainkey.com>
  * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
+ * SHA224 Support Copyright 2007 Intel Corporation <jonathan.lynch@intel.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -219,6 +220,22 @@ static void sha256_transform(u32 *state,
 	memset(W, 0, 64 * sizeof(u32));
 }
 
+
+static void sha224_init(struct crypto_tfm *tfm)
+{
+	struct sha256_ctx *sctx = crypto_tfm_ctx(tfm);
+	sctx->state[0] = SHA224_H0;
+	sctx->state[1] = SHA224_H1;
+	sctx->state[2] = SHA224_H2;
+	sctx->state[3] = SHA224_H3;
+	sctx->state[4] = SHA224_H4;
+	sctx->state[5] = SHA224_H5;
+	sctx->state[6] = SHA224_H6;
+	sctx->state[7] = SHA224_H7;
+	sctx->count[0] = 0;
+	sctx->count[1] = 0;
+}
+
 static void sha256_init(struct crypto_tfm *tfm)
 {
 	struct sha256_ctx *sctx = crypto_tfm_ctx(tfm);
@@ -295,8 +312,17 @@ static void sha256_final(struct crypto_t
 	memset(sctx, 0, sizeof(*sctx));
 }
 
+static void sha224_final(struct crypto_tfm *tfm, u8 *hash)
+{
+	u8 D[SHA256_DIGEST_SIZE];
+
+	sha256_final(tfm, D);
+
+	memcpy(hash, D, SHA224_DIGEST_SIZE);
+	memset(D, 0, SHA256_DIGEST_SIZE);
+}
 
-static struct crypto_alg alg = {
+static struct crypto_alg sha256 = {
 	.cra_name	=	"sha256",
 	.cra_driver_name=	"sha256-generic",
 	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
@@ -304,28 +330,58 @@ static struct crypto_alg alg = {
 	.cra_ctxsize	=	sizeof(struct sha256_ctx),
 	.cra_module	=	THIS_MODULE,
 	.cra_alignmask	=	3,
-	.cra_list       =       LIST_HEAD_INIT(alg.cra_list),
+	.cra_list	=	LIST_HEAD_INIT(sha256.cra_list),
 	.cra_u		=	{ .digest = {
 	.dia_digestsize	=	SHA256_DIGEST_SIZE,
-	.dia_init   	= 	sha256_init,
-	.dia_update 	=	sha256_update,
-	.dia_final  	=	sha256_final } }
+	.dia_init	=	sha256_init,
+	.dia_update	=	sha256_update,
+	.dia_final	=	sha256_final } }
+};
+
+static struct crypto_alg sha224 = {
+	.cra_name	= "sha224",
+	.cra_driver_name = "sha224-generic",
+	.cra_flags	= CRYPTO_ALG_TYPE_DIGEST,
+	.cra_blocksize	= SHA224_BLOCK_SIZE,
+	.cra_ctxsize	= sizeof(struct sha256_ctx),
+	.cra_module	= THIS_MODULE,
+	.cra_alignmask	= 3,
+	.cra_list	= LIST_HEAD_INIT(sha224.cra_list),
+	.cra_u		= { .digest = {
+	.dia_digestsize = SHA224_DIGEST_SIZE,
+	.dia_init	= sha224_init,
+	.dia_update	= sha256_update,
+	.dia_final	= sha224_final } }
 };
 
 static int __init init(void)
 {
-	return crypto_register_alg(&alg);
+	int ret = 0;
+
+	ret = crypto_register_alg(&sha224);
+
+	if (ret < 0)
+		return ret;
+
+	ret = crypto_register_alg(&sha256);
+
+	if (ret < 0)
+		crypto_unregister_alg(&sha224);
+
+	return ret;
 }
 
 static void __exit fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_alg(&sha224);
+	crypto_unregister_alg(&sha256);
 }
 
 module_init(init);
 module_exit(fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm");
+MODULE_DESCRIPTION("SHA-224 and SHA-256 Secure Hash Algorithm");
 
+MODULE_ALIAS("sha224");
 MODULE_ALIAS("sha256");
diff -uprN -X linux-2.6.24-rc1-vanilla/Documentation/dontdiff linux-2.6.24-rc1-vanilla/crypto/tcrypt.c linux-2.6.24-rc1/crypto/tcrypt.c
--- linux-2.6.24-rc1-vanilla/crypto/tcrypt.c	2007-11-05 17:12:50.468842000 +0000
+++ linux-2.6.24-rc1/crypto/tcrypt.c	2007-11-06 10:20:30.985270000 +0000
@@ -12,6 +12,7 @@
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
+ * 2007-11-06 Added SHA-224 and SHA-224-HMAC tests
  * 2006-12-07 Added SHA384 HMAC and SHA512 HMAC tests
  * 2004-08-09 Added cipher speed tests (Reyk Floeter <reyk@vantronix.net>)
  * 2003-09-14 Rewritten by Kartikey Mahendra Bhatt
@@ -74,9 +75,9 @@ static char *xbuf;
 static char *tvmem;
 
 static char *check[] = {
-	"des", "md5", "des3_ede", "rot13", "sha1", "sha256", "blowfish",
-	"twofish", "serpent", "sha384", "sha512", "md4", "aes", "cast6",
-	"arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
+	"des", "md5", "des3_ede", "rot13", "sha1", "sha224", "sha256",
+	"blowfish", "twofish", "serpent", "sha384", "sha512", "md4", "aes",
+	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
 	"camellia", "seed", NULL
 };
@@ -908,6 +909,8 @@ static void do_test(void)
 
 		test_hash("md4", md4_tv_template, MD4_TEST_VECTORS);
 
+		test_hash("sha224", sha224_tv_template, SHA224_TEST_VECTORS);
+
 		test_hash("sha256", sha256_tv_template, SHA256_TEST_VECTORS);
 
 		//BLOWFISH
@@ -1053,6 +1056,8 @@ static void do_test(void)
 			  HMAC_MD5_TEST_VECTORS);
 		test_hash("hmac(sha1)", hmac_sha1_tv_template,
 			  HMAC_SHA1_TEST_VECTORS);
+		test_hash("hmac(sha224)", hmac_sha224_tv_template,
+			  HMAC_SHA224_TEST_VECTORS);
 		test_hash("hmac(sha256)", hmac_sha256_tv_template,
 			  HMAC_SHA256_TEST_VECTORS);
 		test_hash("hmac(sha384)", hmac_sha384_tv_template,
@@ -1097,10 +1102,14 @@ static void do_test(void)
 		break;
 
 	case 6:
-		test_hash("sha256", sha256_tv_template, SHA256_TEST_VECTORS);
+		test_hash("sha224", sha224_tv_template, SHA224_TEST_VECTORS);
 		break;
 
 	case 7:
+		test_hash("sha256", sha256_tv_template, SHA256_TEST_VECTORS);
+		break;
+
+	case 8:
 		test_cipher("ecb(blowfish)", ENCRYPT, bf_enc_tv_template,
 			    BF_ENC_TEST_VECTORS);
 		test_cipher("ecb(blowfish)", DECRYPT, bf_dec_tv_template,
@@ -1111,7 +1120,7 @@ static void do_test(void)
 			    BF_CBC_DEC_TEST_VECTORS);
 		break;
 
-	case 8:
+	case 9:
 		test_cipher("ecb(twofish)", ENCRYPT, tf_enc_tv_template,
 			    TF_ENC_TEST_VECTORS);
 		test_cipher("ecb(twofish)", DECRYPT, tf_dec_tv_template,
@@ -1122,14 +1131,14 @@ static void do_test(void)
 			    TF_CBC_DEC_TEST_VECTORS);
 		break;
 
-	case 9:
+	case 10:
 		test_cipher("ecb(serpent)", ENCRYPT, serpent_enc_tv_template,
 			    SERPENT_ENC_TEST_VECTORS);
 		test_cipher("ecb(serpent)", DECRYPT, serpent_dec_tv_template,
 			    SERPENT_DEC_TEST_VECTORS);
 		break;
 
-	case 10:
+	case 11:
 		test_cipher("ecb(aes)", ENCRYPT, aes_enc_tv_template,
 			    AES_ENC_TEST_VECTORS);
 		test_cipher("ecb(aes)", DECRYPT, aes_dec_tv_template,
@@ -1148,88 +1157,88 @@ static void do_test(void)
 			    AES_XTS_DEC_TEST_VECTORS);
 		break;
 
-	case 11:
+	case 12:
 		test_hash("sha384", sha384_tv_template, SHA384_TEST_VECTORS);
 		break;
 
-	case 12:
+	case 13:
 		test_hash("sha512", sha512_tv_template, SHA512_TEST_VECTORS);
 		break;
 
-	case 13:
+	case 14:
 		test_deflate();
 		break;
 
-	case 14:
+	case 15:
 		test_cipher("ecb(cast5)", ENCRYPT, cast5_enc_tv_template,
 			    CAST5_ENC_TEST_VECTORS);
 		test_cipher("ecb(cast5)", DECRYPT, cast5_dec_tv_template,
 			    CAST5_DEC_TEST_VECTORS);
 		break;
 
-	case 15:
+	case 16:
 		test_cipher("ecb(cast6)", ENCRYPT, cast6_enc_tv_template,
 			    CAST6_ENC_TEST_VECTORS);
 		test_cipher("ecb(cast6)", DECRYPT, cast6_dec_tv_template,
 			    CAST6_DEC_TEST_VECTORS);
 		break;
 
-	case 16:
+	case 17:
 		test_cipher("ecb(arc4)", ENCRYPT, arc4_enc_tv_template,
 			    ARC4_ENC_TEST_VECTORS);
 		test_cipher("ecb(arc4)", DECRYPT, arc4_dec_tv_template,
 			    ARC4_DEC_TEST_VECTORS);
 		break;
 
-	case 17:
+	case 18:
 		test_hash("michael_mic", michael_mic_tv_template, MICHAEL_MIC_TEST_VECTORS);
 		break;
 
-	case 18:
+	case 19:
 		test_hash("crc32c", crc32c_tv_template, CRC32C_TEST_VECTORS);
 		break;
 
-	case 19:
+	case 20:
 		test_cipher("ecb(tea)", ENCRYPT, tea_enc_tv_template,
 			    TEA_ENC_TEST_VECTORS);
 		test_cipher("ecb(tea)", DECRYPT, tea_dec_tv_template,
 			    TEA_DEC_TEST_VECTORS);
 		break;
 
-	case 20:
+	case 21:
 		test_cipher("ecb(xtea)", ENCRYPT, xtea_enc_tv_template,
 			    XTEA_ENC_TEST_VECTORS);
 		test_cipher("ecb(xtea)", DECRYPT, xtea_dec_tv_template,
 			    XTEA_DEC_TEST_VECTORS);
 		break;
 
-	case 21:
+	case 22:
 		test_cipher("ecb(khazad)", ENCRYPT, khazad_enc_tv_template,
 			    KHAZAD_ENC_TEST_VECTORS);
 		test_cipher("ecb(khazad)", DECRYPT, khazad_dec_tv_template,
 			    KHAZAD_DEC_TEST_VECTORS);
 		break;
 
-	case 22:
+	case 23:
 		test_hash("wp512", wp512_tv_template, WP512_TEST_VECTORS);
 		break;
 
-	case 23:
+	case 24:
 		test_hash("wp384", wp384_tv_template, WP384_TEST_VECTORS);
 		break;
 
-	case 24:
+	case 25:
 		test_hash("wp256", wp256_tv_template, WP256_TEST_VECTORS);
 		break;
 
-	case 25:
+	case 26:
 		test_cipher("ecb(tnepres)", ENCRYPT, tnepres_enc_tv_template,
 			    TNEPRES_ENC_TEST_VECTORS);
 		test_cipher("ecb(tnepres)", DECRYPT, tnepres_dec_tv_template,
 			    TNEPRES_DEC_TEST_VECTORS);
 		break;
 
-	case 26:
+	case 27:
 		test_cipher("ecb(anubis)", ENCRYPT, anubis_enc_tv_template,
 			    ANUBIS_ENC_TEST_VECTORS);
 		test_cipher("ecb(anubis)", DECRYPT, anubis_dec_tv_template,
@@ -1240,34 +1249,34 @@ static void do_test(void)
 			    ANUBIS_CBC_ENC_TEST_VECTORS);
 		break;
 
-	case 27:
+	case 28:
 		test_hash("tgr192", tgr192_tv_template, TGR192_TEST_VECTORS);
 		break;
 
-	case 28:
+	case 29:
 
 		test_hash("tgr160", tgr160_tv_template, TGR160_TEST_VECTORS);
 		break;
 
-	case 29:
+	case 30:
 		test_hash("tgr128", tgr128_tv_template, TGR128_TEST_VECTORS);
 		break;
 		
-	case 30:
+	case 31:
 		test_cipher("ecb(xeta)", ENCRYPT, xeta_enc_tv_template,
 			    XETA_ENC_TEST_VECTORS);
 		test_cipher("ecb(xeta)", DECRYPT, xeta_dec_tv_template,
 			    XETA_DEC_TEST_VECTORS);
 		break;
 
-	case 31:
+	case 32:
 		test_cipher("pcbc(fcrypt)", ENCRYPT, fcrypt_pcbc_enc_tv_template,
 			    FCRYPT_ENC_TEST_VECTORS);
 		test_cipher("pcbc(fcrypt)", DECRYPT, fcrypt_pcbc_dec_tv_template,
 			    FCRYPT_DEC_TEST_VECTORS);
 		break;
 
-	case 32:
+	case 33:
 		test_cipher("ecb(camellia)", ENCRYPT,
 			    camellia_enc_tv_template,
 			    CAMELLIA_ENC_TEST_VECTORS);
@@ -1293,16 +1302,21 @@ static void do_test(void)
 		break;
 
 	case 102:
+		test_hash("hmac(sha224)", hmac_sha224_tv_template,
+			HMAC_SHA224_TEST_VECTORS);
+		break;
+
+	case 103:
 		test_hash("hmac(sha256)", hmac_sha256_tv_template,
 			  HMAC_SHA256_TEST_VECTORS);
 		break;
 
-	case 103:
+	case 104:
 		test_hash("hmac(sha384)", hmac_sha384_tv_template,
 			  HMAC_SHA384_TEST_VECTORS);
 		break;
 
-	case 104:
+	case 105:
 		test_hash("hmac(sha512)", hmac_sha512_tv_template,
 			  HMAC_SHA512_TEST_VECTORS);
 		break;
@@ -1406,38 +1420,42 @@ static void do_test(void)
 		if (mode > 300 && mode < 400) break;
 
 	case 304:
-		test_hash_speed("sha256", sec, generic_hash_speed_template);
+		test_hash_speed("sha224", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
 	case 305:
-		test_hash_speed("sha384", sec, generic_hash_speed_template);
+		test_hash_speed("sha256", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
 	case 306:
-		test_hash_speed("sha512", sec, generic_hash_speed_template);
+		test_hash_speed("sha384", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
 	case 307:
-		test_hash_speed("wp256", sec, generic_hash_speed_template);
+		test_hash_speed("sha512", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
 	case 308:
-		test_hash_speed("wp384", sec, generic_hash_speed_template);
+		test_hash_speed("wp256", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
 	case 309:
-		test_hash_speed("wp512", sec, generic_hash_speed_template);
+		test_hash_speed("wp384", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
 	case 310:
-		test_hash_speed("tgr128", sec, generic_hash_speed_template);
+		test_hash_speed("wp512", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
 	case 311:
-		test_hash_speed("tgr160", sec, generic_hash_speed_template);
+		test_hash_speed("tgr128", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
 	case 312:
+		test_hash_speed("tgr160", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
+	case 313:
 		test_hash_speed("tgr192", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
diff -uprN -X linux-2.6.24-rc1-vanilla/Documentation/dontdiff linux-2.6.24-rc1-vanilla/crypto/tcrypt.h linux-2.6.24-rc1/crypto/tcrypt.h
--- linux-2.6.24-rc1-vanilla/crypto/tcrypt.h	2007-11-05 17:12:50.492842000 +0000
+++ linux-2.6.24-rc1/crypto/tcrypt.h	2007-11-05 18:18:31.610720000 +0000
@@ -173,6 +173,33 @@ static struct hash_testvec sha1_tv_templ
 	}
 };
 
+
+/*
+ * SHA224 test vectors from from FIPS PUB 180-2
+ */
+#define SHA224_TEST_VECTORS     2
+
+static struct hash_testvec sha224_tv_template[] = {
+	{
+		.plaintext = "abc",
+		.psize  = 3,
+		.digest = { 0x23, 0x09, 0x7D, 0x22, 0x34, 0x05, 0xD8, 0x22,
+			0x86, 0x42, 0xA4, 0x77, 0xBD, 0xA2, 0x55, 0xB3,
+			0x2A, 0xAD, 0xBC, 0xE4, 0xBD, 0xA0, 0xB3, 0xF7,
+			0xE3, 0x6C, 0x9D, 0xA7},
+	}, {
+		.plaintext =
+		"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
+		.psize  = 56,
+		.digest = { 0x75, 0x38, 0x8B, 0x16, 0x51, 0x27, 0x76, 0xCC,
+			0x5D, 0xBA, 0x5D, 0xA1, 0xFD, 0x89, 0x01, 0x50,
+			0xB0, 0xC6, 0x45, 0x5C, 0xB4, 0xF5, 0x8B, 0x19,
+			0x52, 0x52, 0x25, 0x25 },
+		.np     = 2,
+		.tap    = { 28, 28 }
+	}
+};
+
 /*
  * SHA256 test vectors from from NIST
  */
@@ -753,6 +780,7 @@ static struct hash_testvec hmac_md5_tv_t
 	},
 };
 
+
 /*
  * HMAC-SHA1 test vectors from RFC2202
  */
@@ -817,6 +845,121 @@ static struct hash_testvec hmac_sha1_tv_
 	},
 };
 
+
+/*
+ * SHA224 HMAC test vectors from RFC4231
+ */
+#define HMAC_SHA224_TEST_VECTORS    4
+
+static struct hash_testvec hmac_sha224_tv_template[] = {
+	{
+		.key    = { 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b,
+			0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b,
+			0x0b, 0x0b, 0x0b, 0x0b },
+		.ksize  = 20,
+		/*  ("Hi There") */
+		.plaintext = { 0x48, 0x69, 0x20, 0x54, 0x68, 0x65, 0x72, 0x65 },
+		.psize  = 8,
+		.digest = { 0x89, 0x6f, 0xb1, 0x12, 0x8a, 0xbb, 0xdf, 0x19,
+			0x68, 0x32, 0x10, 0x7c, 0xd4, 0x9d, 0xf3, 0x3f,
+			0x47, 0xb4, 0xb1, 0x16, 0x99, 0x12, 0xba, 0x4f,
+			0x53, 0x68, 0x4b, 0x22},
+	}, {
+		.key    = { 0x4a, 0x65, 0x66, 0x65 }, /* ("Jefe") */
+		.ksize  = 4,
+		/* ("what do ya want for nothing?") */
+		.plaintext = { 0x77, 0x68, 0x61, 0x74, 0x20, 0x64, 0x6f, 0x20,
+			0x79, 0x61, 0x20, 0x77, 0x61, 0x6e, 0x74, 0x20,
+			0x66, 0x6f, 0x72, 0x20, 0x6e, 0x6f, 0x74, 0x68,
+			0x69, 0x6e, 0x67, 0x3f },
+		.psize  = 28,
+		.digest = { 0xa3, 0x0e, 0x01, 0x09, 0x8b, 0xc6, 0xdb, 0xbf,
+			0x45, 0x69, 0x0f, 0x3a, 0x7e, 0x9e, 0x6d, 0x0f,
+			0x8b, 0xbe, 0xa2, 0xa3, 0x9e, 0x61, 0x48, 0x00,
+			0x8f, 0xd0, 0x5e, 0x44 },
+		.np = 4,
+		.tap    = { 7, 7, 7, 7 }
+	}, {
+		.key    = { 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa },
+		.ksize  = 131,
+		/* ("Test Using Larger Than Block-Size Key - Hash Key First") */
+		.plaintext = { 0x54, 0x65, 0x73, 0x74, 0x20, 0x55, 0x73, 0x69,
+			0x6e, 0x67, 0x20, 0x4c, 0x61, 0x72, 0x67, 0x65,
+			0x72, 0x20, 0x54, 0x68, 0x61, 0x6e, 0x20, 0x42,
+			0x6c, 0x6f, 0x63, 0x6b, 0x2d, 0x53, 0x69, 0x7a,
+			0x65, 0x20, 0x4b, 0x65, 0x79, 0x20, 0x2d, 0x20,
+			0x48, 0x61, 0x73, 0x68, 0x20, 0x4b, 0x65, 0x79,
+			0x20, 0x46, 0x69, 0x72, 0x73, 0x74 },
+		.psize  = 54,
+		.digest = { 0x95, 0xe9, 0xa0, 0xdb, 0x96, 0x20, 0x95, 0xad,
+			0xae, 0xbe, 0x9b, 0x2d, 0x6f, 0x0d, 0xbc, 0xe2,
+			0xd4, 0x99, 0xf1, 0x12, 0xf2, 0xd2, 0xb7, 0x27,
+			0x3f, 0xa6, 0x87, 0x0e },
+	}, {
+		.key    = { 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
+			0xaa, 0xaa, 0xaa },
+		.ksize  = 131,
+		/* ("This is a test using a larger than block-size key and a")
+		(" larger than block-size data. The key needs to be")
+			(" hashed before being used by the HMAC algorithm.") */
+		.plaintext = { 0x54, 0x68, 0x69, 0x73, 0x20, 0x69, 0x73, 0x20,
+			0x61, 0x20, 0x74, 0x65, 0x73, 0x74, 0x20, 0x75,
+			0x73, 0x69, 0x6e, 0x67, 0x20, 0x61, 0x20, 0x6c,
+			0x61, 0x72, 0x67, 0x65, 0x72, 0x20, 0x74, 0x68,
+			0x61, 0x6e, 0x20, 0x62, 0x6c, 0x6f, 0x63, 0x6b,
+			0x2d, 0x73, 0x69, 0x7a, 0x65, 0x20, 0x6b, 0x65,
+			0x79, 0x20, 0x61, 0x6e, 0x64, 0x20, 0x61, 0x20,
+			0x6c, 0x61, 0x72, 0x67, 0x65, 0x72, 0x20, 0x74,
+			0x68, 0x61, 0x6e, 0x20, 0x62, 0x6c, 0x6f, 0x63,
+			0x6b, 0x2d, 0x73, 0x69, 0x7a, 0x65, 0x20, 0x64,
+			0x61, 0x74, 0x61, 0x2e, 0x20, 0x54, 0x68, 0x65,
+			0x20, 0x6b, 0x65, 0x79, 0x20, 0x6e, 0x65, 0x65,
+			0x64, 0x73, 0x20, 0x74, 0x6f, 0x20, 0x62, 0x65,
+			0x20, 0x68, 0x61, 0x73, 0x68, 0x65, 0x64, 0x20,
+			0x62, 0x65, 0x66, 0x6f, 0x72, 0x65, 0x20, 0x62,
+			0x65, 0x69, 0x6e, 0x67, 0x20, 0x75, 0x73, 0x65,
+			0x64, 0x20, 0x62, 0x79, 0x20, 0x74, 0x68, 0x65,
+			0x20, 0x48, 0x4d, 0x41, 0x43, 0x20, 0x61, 0x6c,
+			0x67, 0x6f, 0x72, 0x69, 0x74, 0x68, 0x6d, 0x2e },
+		.psize  = 152,
+		.digest = { 0x3a, 0x85, 0x41, 0x66, 0xac, 0x5d, 0x9f, 0x02,
+			0x3f, 0x54, 0xd5, 0x17, 0xd0, 0xb3, 0x9d, 0xbd,
+			0x94, 0x67, 0x70, 0xdb, 0x9c, 0x2b, 0x95, 0xc9,
+			0xf6, 0xf5, 0x65, 0xd1 },
+	},
+};
+
 /*
  * HMAC-SHA256 test vectors from
  * draft-ietf-ipsec-ciph-sha-256-01.txt
diff -uprN -X linux-2.6.24-rc1-vanilla/Documentation/dontdiff linux-2.6.24-rc1-vanilla/include/crypto/sha.h linux-2.6.24-rc1/include/crypto/sha.h
--- linux-2.6.24-rc1-vanilla/include/crypto/sha.h	2007-11-05 17:14:02.110724000 +0000
+++ linux-2.6.24-rc1/include/crypto/sha.h	2007-11-06 15:04:22.997509000 +0000
@@ -8,6 +8,9 @@
 #define SHA1_DIGEST_SIZE        20
 #define SHA1_BLOCK_SIZE         64
 
+#define SHA224_DIGEST_SIZE	28
+#define SHA224_BLOCK_SIZE	64
+
 #define SHA256_DIGEST_SIZE      32
 #define SHA256_BLOCK_SIZE       64
 
@@ -23,6 +26,15 @@
 #define SHA1_H3		0x10325476UL
 #define SHA1_H4		0xc3d2e1f0UL
 
+#define SHA224_H0	0xc1059ed8UL
+#define SHA224_H1	0x367cd507UL
+#define SHA224_H2	0x3070dd17UL
+#define SHA224_H3	0xf70e5939UL
+#define SHA224_H4	0xffc00b31UL
+#define SHA224_H5	0x68581511UL
+#define SHA224_H6	0x64f98fa7UL
+#define SHA224_H7	0xbefa4fa4UL
+
 #define SHA256_H0	0x6a09e667UL
 #define SHA256_H1	0xbb67ae85UL
 #define SHA256_H2	0x3c6ef372UL

Signed-off-by: Jonathan Lynch <jonathan.lynch@intel.com>
