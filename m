From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: add test cases for SHA-1, SHA-224 and SHA-256
Date: Tue,  1 Apr 2014 18:18:21 +0200
Message-ID: <1396369101-2302-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:35330 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaDAQSf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Apr 2014 12:18:35 -0400
Received: by mail-we0-f175.google.com with SMTP id q58so6598126wes.34
        for <linux-crypto@vger.kernel.org>; Tue, 01 Apr 2014 09:18:34 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds a test case for each of SHA-1, SHA-224 and SHA-256 with a plaintext
size of 64 bytes, which is exactly the block size. The reason is that some
implementations may use a different code path for inputs that are an exact
multiple of the block size.
---

Just some trivial test vectors I have been using locally for my work on arm64,
but may be useful to send upstream. If not, that's also fine.

Regards,
-- 
Ard.



 crypto/testmgr.h | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 7d44aa3d6b44..af00e3abd7f5 100644
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
-- 
1.8.3.2
