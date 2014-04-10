From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: add test cases for SHA-1, SHA-224, SHA-256 and AES-CCM
Date: Thu, 10 Apr 2014 19:16:43 +0200
Message-ID: <1397150203-12654-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61141 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758AbaDJRQx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Apr 2014 13:16:53 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so3234069eek.21
        for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2014 10:16:52 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds test cases for SHA-1, SHA-224, SHA-256 and AES-CCM with an input size
that is an exact multiple of the block size. The reason is that some
implementations use a different code path for these cases.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

This is the same patch as I posted last week, but this time with the S-o-b line,
and I also added another test case that I used to test my Arm64 AES in CCM mode.

 crypto/testmgr.h | 53 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 6 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 3db83dbba1d9..c5d911dd8039 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -487,7 +487,7 @@ static struct hash_testvec crct10dif_tv_template[] = {
  * SHA1 test vectors  from from FIPS PUB 180-1
  * Long vector from CAVS 5.0
  */
-#define SHA1_TEST_VECTORS	3
+#define SHA1_TEST_VECTORS	4
 
 static struct hash_testvec sha1_tv_template[] = {
 	{
@@ -529,6 +529,11 @@ static struct hash_testvec sha1_tv_template[] = {
 			  "\x45\x9c\x02\xb6\x9b\x4a\xa8\xf5\x82\x17",
 		.np	= 4,
 		.tap	= { 63, 64, 31, 5 }
+	}, {
+		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-",
+		.psize	= 64,
+		.digest = "\xc8\x71\xf6\x9a\x63\xcc\xa9\x84\x84\x82"
+			  "\x64\xe7\x79\x95\x5d\xd7\x19\x41\x7c\x91",
 	}
 };
 
@@ -536,7 +541,7 @@ static struct hash_testvec sha1_tv_template[] = {
 /*
  * SHA224 test vectors from from FIPS PUB 180-2
  */
-#define SHA224_TEST_VECTORS     2
+#define SHA224_TEST_VECTORS     3
 
 static struct hash_testvec sha224_tv_template[] = {
 	{
@@ -556,13 +561,20 @@ static struct hash_testvec sha224_tv_template[] = {
 			  "\x52\x52\x25\x25",
 		.np     = 2,
 		.tap    = { 28, 28 }
+	}, {
+		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-",
+		.psize	= 64,
+		.digest = "\xc4\xdb\x2b\x3a\x58\xc3\x99\x01"
+			  "\x42\xfd\x10\x92\xaa\x4e\x04\x08"
+			  "\x58\xbb\xbb\xe8\xf8\x14\xa7\x0c"
+			  "\xef\x3b\xcb\x0e",
 	}
 };
 
 /*
  * SHA256 test vectors from from NIST
  */
-#define SHA256_TEST_VECTORS	2
+#define SHA256_TEST_VECTORS	3
 
 static struct hash_testvec sha256_tv_template[] = {
 	{
@@ -581,7 +593,14 @@ static struct hash_testvec sha256_tv_template[] = {
 			  "\xf6\xec\xed\xd4\x19\xdb\x06\xc1",
 		.np	= 2,
 		.tap	= { 28, 28 }
-	},
+	}, {
+		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-",
+		.psize	= 64,
+		.digest = "\xb5\xfe\xad\x56\x7d\xff\xcb\xa4"
+			  "\x2c\x32\x29\x32\x19\xbb\xfb\xfa"
+			  "\xd6\xff\x94\xa3\x72\x91\x85\x66"
+			  "\x3b\xa7\x87\x77\x58\xa3\x40\x3a",
+	}
 };
 
 /*
@@ -12844,7 +12863,7 @@ static struct cipher_testvec cast6_xts_dec_tv_template[] = {
 #define AES_GCM_4106_DEC_TEST_VECTORS 7
 #define AES_GCM_4543_ENC_TEST_VECTORS 1
 #define AES_GCM_4543_DEC_TEST_VECTORS 2
-#define AES_CCM_ENC_TEST_VECTORS 7
+#define AES_CCM_ENC_TEST_VECTORS 8
 #define AES_CCM_DEC_TEST_VECTORS 7
 #define AES_CCM_4309_ENC_TEST_VECTORS 7
 #define AES_CCM_4309_DEC_TEST_VECTORS 10
@@ -18746,7 +18765,29 @@ static struct aead_testvec aes_ccm_enc_tv_template[] = {
 			  "\x7c\xf9\xbe\xc2\x40\x88\x97\xc6"
 			  "\xba",
 		.rlen	= 33,
-	},
+	}, {
+		/*
+		 * This is the same vector as aes_ccm_rfc4309_enc_tv_template[0]
+		 * below but rewritten to use the ccm algorithm directly.
+		 */
+		.key	= "\x83\xac\x54\x66\xc2\xeb\xe5\x05"
+			  "\x2e\x01\xd1\xfc\x5d\x82\x66\x2e",
+		.klen	= 16,
+		.iv	= "\x03\x96\xac\x59\x30\x07\xa1\xe2\xa2\xc7\x55\x24\0\0\0\0",
+		.alen	= 0,
+		.input	= "\x19\xc8\x81\xf6\xe9\x86\xff\x93"
+			  "\x0b\x78\x67\xe5\xbb\xb7\xfc\x6e"
+			  "\x83\x77\xb3\xa6\x0c\x8c\x9f\x9c"
+			  "\x35\x2e\xad\xe0\x62\xf9\x91\xa1",
+		.ilen	= 32,
+		.result	= "\xab\x6f\xe1\x69\x1d\x19\x99\xa8"
+			  "\x92\xa0\xc4\x6f\x7e\xe2\x8b\xb1"
+			  "\x70\xbb\x8c\xa6\x4c\x6e\x97\x8a"
+			  "\x57\x2b\xbe\x5d\x98\xa6\xb1\x32"
+			  "\xda\x24\xea\xd9\xa1\x39\x98\xfd"
+			  "\xa4\xbe\xd9\xf2\x1a\x6d\x22\xa8",
+		.rlen	= 48,
+	}
 };
 
 static struct aead_testvec aes_ccm_dec_tv_template[] = {
-- 
1.8.3.2
