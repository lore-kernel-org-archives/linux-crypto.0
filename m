From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/8] crypto: testmgr - Disable authenc test and convert test vectors
Date: Thu, 30 Jul 2015 17:53:14 +0800
Message-ID: <E1ZKkWY-0004Ah-Vl@gondolin.me.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37513 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbbG3JxS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 05:53:18 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZKkWZ-0005hD-80
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2015 19:53:15 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch disables the authenc tests while the conversion to the
new IV calling convention takes place.  It also replaces the authenc
test vectors with ones that will work with the new IV convention.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.c |   26 +++++------
 crypto/testmgr.h |  122 +++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 109 insertions(+), 39 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d0a42bd..0b14f71 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2090,7 +2090,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha1),cbc(aes))",
+		.alg = "authenc(hmac(sha1),cbc(aes))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2104,7 +2104,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha1),cbc(des))",
+		.alg = "authenc(hmac(sha1),cbc(des))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2118,7 +2118,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha1),cbc(des3_ede))",
+		.alg = "authenc(hmac(sha1),cbc(des3_ede))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2152,7 +2152,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha224),cbc(des))",
+		.alg = "authenc(hmac(sha224),cbc(des))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2166,7 +2166,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha224),cbc(des3_ede))",
+		.alg = "authenc(hmac(sha224),cbc(des3_ede))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2180,7 +2180,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha256),cbc(aes))",
+		.alg = "authenc(hmac(sha256),cbc(aes))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2194,7 +2194,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha256),cbc(des))",
+		.alg = "authenc(hmac(sha256),cbc(des))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2208,7 +2208,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha256),cbc(des3_ede))",
+		.alg = "authenc(hmac(sha256),cbc(des3_ede))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2222,7 +2222,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha384),cbc(des))",
+		.alg = "authenc(hmac(sha384),cbc(des))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2236,7 +2236,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha384),cbc(des3_ede))",
+		.alg = "authenc(hmac(sha384),cbc(des3_ede))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2250,7 +2250,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha512),cbc(aes))",
+		.alg = "authenc(hmac(sha512),cbc(aes))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2264,7 +2264,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha512),cbc(des))",
+		.alg = "authenc(hmac(sha512),cbc(des))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2278,7 +2278,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha512),cbc(des3_ede))",
+		.alg = "authenc(hmac(sha512),cbc(des3_ede))-disabled",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index dc467ab..64b8a80 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15038,6 +15038,9 @@ static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 20 + 16,
 		.iv     = "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
 			  "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
+		.assoc	= "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
+			  "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
+		.alen	= 16,
 		.input  = "Single block msg",
 		.ilen   = 16,
 		.result = "\xe3\x53\x77\x9c\x10\x79\xae\xb8"
@@ -15063,6 +15066,9 @@ static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 20 + 16,
 		.iv     = "\x56\x2e\x17\x99\x6d\x09\x3d\x28"
 			  "\xdd\xb3\xba\x69\x5a\x2e\x6f\x58",
+		.assoc	= "\x56\x2e\x17\x99\x6d\x09\x3d\x28"
+			  "\xdd\xb3\xba\x69\x5a\x2e\x6f\x58",
+		.alen	= 16,
 		.input  = "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
 			  "\x10\x11\x12\x13\x14\x15\x16\x17"
@@ -15093,6 +15099,9 @@ static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 20 + 16,
 		.iv     = "\xc7\x82\xdc\x4c\x09\x8c\x66\xcb"
 			  "\xd9\xcd\x27\xd8\x25\x68\x2c\x81",
+		.assoc	= "\xc7\x82\xdc\x4c\x09\x8c\x66\xcb"
+			  "\xd9\xcd\x27\xd8\x25\x68\x2c\x81",
+		.alen	= 16,
 		.input  = "This is a 48-byte message (exactly 3 AES blocks)",
 		.ilen   = 48,
 		.result = "\xd0\xa0\x2b\x38\x36\x45\x17\x53"
@@ -15122,6 +15131,9 @@ static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 20 + 16,
 		.iv     = "\x8c\xe8\x2e\xef\xbe\xa0\xda\x3c"
 			  "\x44\x69\x9e\xd7\xdb\x51\xb7\xd9",
+		.assoc	= "\x8c\xe8\x2e\xef\xbe\xa0\xda\x3c"
+			  "\x44\x69\x9e\xd7\xdb\x51\xb7\xd9",
+		.alen	= 16,
 		.input  = "\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7"
 			  "\xa8\xa9\xaa\xab\xac\xad\xae\xaf"
 			  "\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7"
@@ -15160,8 +15172,10 @@ static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 20 + 16,
 		.iv     = "\xe9\x6e\x8c\x08\xab\x46\x57\x63"
 			  "\xfd\x09\x8d\x45\xdd\x3f\xf8\x93",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\xe9\x6e\x8c\x08\xab\x46\x57\x63"
+			  "\xfd\x09\x8d\x45\xdd\x3f\xf8\x93",
+		.alen   = 24,
 		.input  = "\x08\x00\x0e\xbd\xa7\x0a\x00\x00"
 			  "\x8e\x9c\x08\x3d\xb9\x5b\x07\x00"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
@@ -15205,6 +15219,9 @@ static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 20 + 24,
 		.iv     = "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.alen	= 16,
 		.input  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -15245,6 +15262,9 @@ static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 20 + 32,
 		.iv     = "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.alen	= 16,
 		.input  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -15380,6 +15400,9 @@ static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 32 + 16,
 		.iv     = "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
 			  "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
+		.assoc	= "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
+			  "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
+		.alen	= 16,
 		.input  = "Single block msg",
 		.ilen   = 16,
 		.result = "\xe3\x53\x77\x9c\x10\x79\xae\xb8"
@@ -15407,6 +15430,9 @@ static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 32 + 16,
 		.iv     = "\x56\x2e\x17\x99\x6d\x09\x3d\x28"
 			  "\xdd\xb3\xba\x69\x5a\x2e\x6f\x58",
+		.assoc	= "\x56\x2e\x17\x99\x6d\x09\x3d\x28"
+			  "\xdd\xb3\xba\x69\x5a\x2e\x6f\x58",
+		.alen	= 16,
 		.input  = "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
 			  "\x10\x11\x12\x13\x14\x15\x16\x17"
@@ -15439,6 +15465,9 @@ static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 32 + 16,
 		.iv     = "\xc7\x82\xdc\x4c\x09\x8c\x66\xcb"
 			  "\xd9\xcd\x27\xd8\x25\x68\x2c\x81",
+		.assoc	= "\xc7\x82\xdc\x4c\x09\x8c\x66\xcb"
+			  "\xd9\xcd\x27\xd8\x25\x68\x2c\x81",
+		.alen	= 16,
 		.input  = "This is a 48-byte message (exactly 3 AES blocks)",
 		.ilen   = 48,
 		.result = "\xd0\xa0\x2b\x38\x36\x45\x17\x53"
@@ -15470,6 +15499,9 @@ static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 32 + 16,
 		.iv     = "\x8c\xe8\x2e\xef\xbe\xa0\xda\x3c"
 			  "\x44\x69\x9e\xd7\xdb\x51\xb7\xd9",
+		.assoc	= "\x8c\xe8\x2e\xef\xbe\xa0\xda\x3c"
+			  "\x44\x69\x9e\xd7\xdb\x51\xb7\xd9",
+		.alen	= 16,
 		.input  = "\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7"
 			  "\xa8\xa9\xaa\xab\xac\xad\xae\xaf"
 			  "\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7"
@@ -15510,8 +15542,10 @@ static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 32 + 16,
 		.iv     = "\xe9\x6e\x8c\x08\xab\x46\x57\x63"
 			  "\xfd\x09\x8d\x45\xdd\x3f\xf8\x93",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\xe9\x6e\x8c\x08\xab\x46\x57\x63"
+			  "\xfd\x09\x8d\x45\xdd\x3f\xf8\x93",
+		.alen   = 24,
 		.input  = "\x08\x00\x0e\xbd\xa7\x0a\x00\x00"
 			  "\x8e\x9c\x08\x3d\xb9\x5b\x07\x00"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
@@ -15557,6 +15591,9 @@ static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 32 + 24,
 		.iv     = "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.alen   = 16,
 		.input  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -15599,6 +15636,9 @@ static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 32 + 32,
 		.iv     = "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.alen   = 16,
 		.input  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -15647,6 +15687,9 @@ static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 64 + 16,
 		.iv     = "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
 			  "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
+		.assoc	= "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
+			  "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
+		.alen   = 16,
 		.input  = "Single block msg",
 		.ilen   = 16,
 		.result = "\xe3\x53\x77\x9c\x10\x79\xae\xb8"
@@ -15682,6 +15725,9 @@ static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 64 + 16,
 		.iv     = "\x56\x2e\x17\x99\x6d\x09\x3d\x28"
 			  "\xdd\xb3\xba\x69\x5a\x2e\x6f\x58",
+		.assoc	= "\x56\x2e\x17\x99\x6d\x09\x3d\x28"
+			  "\xdd\xb3\xba\x69\x5a\x2e\x6f\x58",
+		.alen   = 16,
 		.input  = "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
 			  "\x10\x11\x12\x13\x14\x15\x16\x17"
@@ -15722,6 +15768,9 @@ static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 64 + 16,
 		.iv     = "\xc7\x82\xdc\x4c\x09\x8c\x66\xcb"
 			  "\xd9\xcd\x27\xd8\x25\x68\x2c\x81",
+		.assoc	= "\xc7\x82\xdc\x4c\x09\x8c\x66\xcb"
+			  "\xd9\xcd\x27\xd8\x25\x68\x2c\x81",
+		.alen   = 16,
 		.input  = "This is a 48-byte message (exactly 3 AES blocks)",
 		.ilen   = 48,
 		.result = "\xd0\xa0\x2b\x38\x36\x45\x17\x53"
@@ -15761,6 +15810,9 @@ static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 64 + 16,
 		.iv     = "\x8c\xe8\x2e\xef\xbe\xa0\xda\x3c"
 			  "\x44\x69\x9e\xd7\xdb\x51\xb7\xd9",
+		.assoc	= "\x8c\xe8\x2e\xef\xbe\xa0\xda\x3c"
+			  "\x44\x69\x9e\xd7\xdb\x51\xb7\xd9",
+		.alen   = 16,
 		.input  = "\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7"
 			  "\xa8\xa9\xaa\xab\xac\xad\xae\xaf"
 			  "\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7"
@@ -15809,8 +15861,10 @@ static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 64 + 16,
 		.iv     = "\xe9\x6e\x8c\x08\xab\x46\x57\x63"
 			  "\xfd\x09\x8d\x45\xdd\x3f\xf8\x93",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\xe9\x6e\x8c\x08\xab\x46\x57\x63"
+			  "\xfd\x09\x8d\x45\xdd\x3f\xf8\x93",
+		.alen   = 24,
 		.input  = "\x08\x00\x0e\xbd\xa7\x0a\x00\x00"
 			  "\x8e\x9c\x08\x3d\xb9\x5b\x07\x00"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
@@ -15864,6 +15918,9 @@ static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 64 + 24,
 		.iv     = "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.alen   = 16,
 		.input  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -15914,6 +15971,9 @@ static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 		.klen   = 8 + 64 + 32,
 		.iv     = "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.alen   = 16,
 		.input  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -15961,8 +16021,9 @@ static struct aead_testvec hmac_sha1_des_cbc_enc_tv_temp[] = {
 			  "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24",
 		.klen	= 8 + 20 + 8,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
 		.input	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
@@ -16021,8 +16082,9 @@ static struct aead_testvec hmac_sha224_des_cbc_enc_tv_temp[] = {
 			  "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24",
 		.klen	= 8 + 24 + 8,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
 		.input	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
@@ -16082,8 +16144,9 @@ static struct aead_testvec hmac_sha256_des_cbc_enc_tv_temp[] = {
 			  "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24",
 		.klen	= 8 + 32 + 8,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
 		.input	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
@@ -16146,8 +16209,9 @@ static struct aead_testvec hmac_sha384_des_cbc_enc_tv_temp[] = {
 			  "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24",
 		.klen	= 8 + 48 + 8,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
 		.input	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
@@ -16214,8 +16278,9 @@ static struct aead_testvec hmac_sha512_des_cbc_enc_tv_temp[] = {
 			  "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24",
 		.klen	= 8 + 64 + 8,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
 		.input	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
@@ -16281,8 +16346,9 @@ static struct aead_testvec hmac_sha1_des3_ede_cbc_enc_tv_temp[] = {
 			  "\xEA\xC2\x84\xE8\x14\x95\xDB\xE8",
 		.klen	= 8 + 20 + 24,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
 		.input	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 		  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
@@ -16343,8 +16409,9 @@ static struct aead_testvec hmac_sha224_des3_ede_cbc_enc_tv_temp[] = {
 			  "\xEA\xC2\x84\xE8\x14\x95\xDB\xE8",
 		.klen	= 8 + 24 + 24,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
 		.input	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
@@ -16406,8 +16473,9 @@ static struct aead_testvec hmac_sha256_des3_ede_cbc_enc_tv_temp[] = {
 			  "\xEA\xC2\x84\xE8\x14\x95\xDB\xE8",
 		.klen	= 8 + 32 + 24,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
 		.input	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
@@ -16472,8 +16540,9 @@ static struct aead_testvec hmac_sha384_des3_ede_cbc_enc_tv_temp[] = {
 			  "\xEA\xC2\x84\xE8\x14\x95\xDB\xE8",
 		.klen	= 8 + 48 + 24,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
-	.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
 		.input	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
@@ -16542,8 +16611,9 @@ static struct aead_testvec hmac_sha512_des3_ede_cbc_enc_tv_temp[] = {
 			  "\xEA\xC2\x84\xE8\x14\x95\xDB\xE8",
 		.klen	= 8 + 64 + 24,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
-		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01",
-		.alen   = 8,
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
 		.input	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
