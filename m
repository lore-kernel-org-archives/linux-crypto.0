Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0435A19F
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:28:20 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g9P-005IPq-Jl; Thu, 30 Nov 2023 20:28:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:28:24 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:28:24 +0800
Subject: [PATCH 17/19] crypto: tcrypt - Remove cfb and ofb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g9P-005IPq-Jl@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove tests for CFB/OFB.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |   76 --------------------------------------------------------
 1 file changed, 76 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 202ca1a3105d..ea4d1cea9c06 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1524,8 +1524,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret = min(ret, tcrypt_test("xts(aes)"));
 		ret = min(ret, tcrypt_test("ctr(aes)"));
 		ret = min(ret, tcrypt_test("rfc3686(ctr(aes))"));
-		ret = min(ret, tcrypt_test("ofb(aes)"));
-		ret = min(ret, tcrypt_test("cfb(aes)"));
 		ret = min(ret, tcrypt_test("xctr(aes)"));
 		break;
 
@@ -1845,14 +1843,12 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 	case 191:
 		ret = min(ret, tcrypt_test("ecb(sm4)"));
 		ret = min(ret, tcrypt_test("cbc(sm4)"));
-		ret = min(ret, tcrypt_test("cfb(sm4)"));
 		ret = min(ret, tcrypt_test("ctr(sm4)"));
 		ret = min(ret, tcrypt_test("xts(sm4)"));
 		break;
 	case 192:
 		ret = min(ret, tcrypt_test("ecb(aria)"));
 		ret = min(ret, tcrypt_test("cbc(aria)"));
-		ret = min(ret, tcrypt_test("cfb(aria)"));
 		ret = min(ret, tcrypt_test("ctr(aria)"));
 		break;
 	case 200:
@@ -1880,10 +1876,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				speed_template_16_24_32);
 		test_cipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("cfb(aes)", ENCRYPT, sec, NULL, 0,
-				speed_template_16_24_32);
-		test_cipher_speed("cfb(aes)", DECRYPT, sec, NULL, 0,
-				speed_template_16_24_32);
 		break;
 
 	case 201:
@@ -2115,10 +2107,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				speed_template_16);
 		test_cipher_speed("cts(cbc(sm4))", DECRYPT, sec, NULL, 0,
 				speed_template_16);
-		test_cipher_speed("cfb(sm4)", ENCRYPT, sec, NULL, 0,
-				speed_template_16);
-		test_cipher_speed("cfb(sm4)", DECRYPT, sec, NULL, 0,
-				speed_template_16);
 		test_cipher_speed("ctr(sm4)", ENCRYPT, sec, NULL, 0,
 				speed_template_16);
 		test_cipher_speed("ctr(sm4)", DECRYPT, sec, NULL, 0,
@@ -2198,10 +2186,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				  speed_template_16_24_32);
 		test_cipher_speed("cbc(aria)", DECRYPT, sec, NULL, 0,
 				  speed_template_16_24_32);
-		test_cipher_speed("cfb(aria)", ENCRYPT, sec, NULL, 0,
-				  speed_template_16_24_32);
-		test_cipher_speed("cfb(aria)", DECRYPT, sec, NULL, 0,
-				  speed_template_16_24_32);
 		test_cipher_speed("ctr(aria)", ENCRYPT, sec, NULL, 0,
 				  speed_template_16_24_32);
 		test_cipher_speed("ctr(aria)", DECRYPT, sec, NULL, 0,
@@ -2436,14 +2420,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				   speed_template_16_24_32);
 		test_acipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("cfb(aes)", ENCRYPT, sec, NULL, 0,
-				   speed_template_16_24_32);
-		test_acipher_speed("cfb(aes)", DECRYPT, sec, NULL, 0,
-				   speed_template_16_24_32);
-		test_acipher_speed("ofb(aes)", ENCRYPT, sec, NULL, 0,
-				   speed_template_16_24_32);
-		test_acipher_speed("ofb(aes)", DECRYPT, sec, NULL, 0,
-				   speed_template_16_24_32);
 		test_acipher_speed("rfc3686(ctr(aes))", ENCRYPT, sec, NULL, 0,
 				   speed_template_20_28_36);
 		test_acipher_speed("rfc3686(ctr(aes))", DECRYPT, sec, NULL, 0,
@@ -2463,18 +2439,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_acipher_speed("cbc(des3_ede)", DECRYPT, sec,
 				   des3_speed_template, DES3_SPEED_VECTORS,
 				   speed_template_24);
-		test_acipher_speed("cfb(des3_ede)", ENCRYPT, sec,
-				   des3_speed_template, DES3_SPEED_VECTORS,
-				   speed_template_24);
-		test_acipher_speed("cfb(des3_ede)", DECRYPT, sec,
-				   des3_speed_template, DES3_SPEED_VECTORS,
-				   speed_template_24);
-		test_acipher_speed("ofb(des3_ede)", ENCRYPT, sec,
-				   des3_speed_template, DES3_SPEED_VECTORS,
-				   speed_template_24);
-		test_acipher_speed("ofb(des3_ede)", DECRYPT, sec,
-				   des3_speed_template, DES3_SPEED_VECTORS,
-				   speed_template_24);
 		break;
 
 	case 502:
@@ -2486,14 +2450,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				   speed_template_8);
 		test_acipher_speed("cbc(des)", DECRYPT, sec, NULL, 0,
 				   speed_template_8);
-		test_acipher_speed("cfb(des)", ENCRYPT, sec, NULL, 0,
-				   speed_template_8);
-		test_acipher_speed("cfb(des)", DECRYPT, sec, NULL, 0,
-				   speed_template_8);
-		test_acipher_speed("ofb(des)", ENCRYPT, sec, NULL, 0,
-				   speed_template_8);
-		test_acipher_speed("ofb(des)", DECRYPT, sec, NULL, 0,
-				   speed_template_8);
 		break;
 
 	case 503:
@@ -2632,10 +2588,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				speed_template_16);
 		test_acipher_speed("cbc(sm4)", DECRYPT, sec, NULL, 0,
 				speed_template_16);
-		test_acipher_speed("cfb(sm4)", ENCRYPT, sec, NULL, 0,
-				speed_template_16);
-		test_acipher_speed("cfb(sm4)", DECRYPT, sec, NULL, 0,
-				speed_template_16);
 		test_acipher_speed("ctr(sm4)", ENCRYPT, sec, NULL, 0,
 				speed_template_16);
 		test_acipher_speed("ctr(sm4)", DECRYPT, sec, NULL, 0,
@@ -2682,14 +2634,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				       speed_template_16_24_32, num_mb);
 		test_mb_skcipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("cfb(aes)", ENCRYPT, sec, NULL, 0,
-				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("cfb(aes)", DECRYPT, sec, NULL, 0,
-				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("ofb(aes)", ENCRYPT, sec, NULL, 0,
-				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("ofb(aes)", DECRYPT, sec, NULL, 0,
-				       speed_template_16_24_32, num_mb);
 		test_mb_skcipher_speed("rfc3686(ctr(aes))", ENCRYPT, sec, NULL,
 				       0, speed_template_20_28_36, num_mb);
 		test_mb_skcipher_speed("rfc3686(ctr(aes))", DECRYPT, sec, NULL,
@@ -2709,18 +2653,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_mb_skcipher_speed("cbc(des3_ede)", DECRYPT, sec,
 				       des3_speed_template, DES3_SPEED_VECTORS,
 				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("cfb(des3_ede)", ENCRYPT, sec,
-				       des3_speed_template, DES3_SPEED_VECTORS,
-				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("cfb(des3_ede)", DECRYPT, sec,
-				       des3_speed_template, DES3_SPEED_VECTORS,
-				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("ofb(des3_ede)", ENCRYPT, sec,
-				       des3_speed_template, DES3_SPEED_VECTORS,
-				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("ofb(des3_ede)", DECRYPT, sec,
-				       des3_speed_template, DES3_SPEED_VECTORS,
-				       speed_template_24, num_mb);
 		break;
 
 	case 602:
@@ -2732,14 +2664,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				       speed_template_8, num_mb);
 		test_mb_skcipher_speed("cbc(des)", DECRYPT, sec, NULL, 0,
 				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("cfb(des)", ENCRYPT, sec, NULL, 0,
-				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("cfb(des)", DECRYPT, sec, NULL, 0,
-				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("ofb(des)", ENCRYPT, sec, NULL, 0,
-				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("ofb(des)", DECRYPT, sec, NULL, 0,
-				       speed_template_8, num_mb);
 		break;
 
 	case 603:
