From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] [crypto] tcrypto group common used speed-templates
Date: Sat, 19 Jan 2008 01:02:11 +0100
Message-ID: <1200700935-3844-2-git-send-email-sebastian@breakpoint.cc>
References: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@ml.breakpoint.cc,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38852 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbYASIde (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2008 03:33:34 -0500
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1JG98v-0002cw-1A
	for linux-crypto@vger.kernel.org; Sat, 19 Jan 2008 09:33:33 +0100
In-Reply-To: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some crypto ciphers which are impleneted support similar key sizes
(16,24 & 32 byte). They can be grouped together and use a common
templatte instead of their own which contains the same data.
Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/tcrypt.c |   70 ++++++++++++-------------
 crypto/tcrypt.h |  158 ++++++++++++++++++++-----------------------------------
 2 files changed, 91 insertions(+), 137 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1ab8c01..cff1836 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1621,89 +1621,85 @@ static void do_test(void)
 
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
-				  aes_speed_template);
+				speed_template_16_24_32);
 		test_cipher_speed("ecb(aes)", DECRYPT, sec, NULL, 0,
-				  aes_speed_template);
+				speed_template_16_24_32);
 		test_cipher_speed("cbc(aes)", ENCRYPT, sec, NULL, 0,
-				  aes_speed_template);
+				speed_template_16_24_32);
 		test_cipher_speed("cbc(aes)", DECRYPT, sec, NULL, 0,
-				  aes_speed_template);
+				speed_template_16_24_32);
 		test_cipher_speed("lrw(aes)", ENCRYPT, sec, NULL, 0,
-				  aes_lrw_speed_template);
+				speed_template_32_40_48);
 		test_cipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
-				  aes_lrw_speed_template);
+				speed_template_32_40_48);
 		test_cipher_speed("xts(aes)", ENCRYPT, sec, NULL, 0,
-				  aes_xts_speed_template);
+				speed_template_32_48_64);
 		test_cipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
-				  aes_xts_speed_template);
+				speed_template_32_48_64);
 		break;
 
 	case 201:
 		test_cipher_speed("ecb(des3_ede)", ENCRYPT, sec,
-				  des3_ede_enc_tv_template,
-				  DES3_EDE_ENC_TEST_VECTORS,
-				  des3_ede_speed_template);
+				des3_ede_enc_tv_template, DES3_EDE_ENC_TEST_VECTORS,
+				speed_template_24);
 		test_cipher_speed("ecb(des3_ede)", DECRYPT, sec,
-				  des3_ede_dec_tv_template,
-				  DES3_EDE_DEC_TEST_VECTORS,
-				  des3_ede_speed_template);
+				des3_ede_enc_tv_template, DES3_EDE_ENC_TEST_VECTORS,
+				speed_template_24);
 		test_cipher_speed("cbc(des3_ede)", ENCRYPT, sec,
-				  des3_ede_enc_tv_template,
-				  DES3_EDE_ENC_TEST_VECTORS,
-				  des3_ede_speed_template);
+				des3_ede_enc_tv_template, DES3_EDE_ENC_TEST_VECTORS,
+				speed_template_24);
 		test_cipher_speed("cbc(des3_ede)", DECRYPT, sec,
-				  des3_ede_dec_tv_template,
-				  DES3_EDE_DEC_TEST_VECTORS,
-				  des3_ede_speed_template);
+				des3_ede_enc_tv_template, DES3_EDE_ENC_TEST_VECTORS,
+				speed_template_24);
 		break;
 
 	case 202:
 		test_cipher_speed("ecb(twofish)", ENCRYPT, sec, NULL, 0,
-				  twofish_speed_template);
+				speed_template_16_24_32);
 		test_cipher_speed("ecb(twofish)", DECRYPT, sec, NULL, 0,
-				  twofish_speed_template);
+				speed_template_16_24_32);
 		test_cipher_speed("cbc(twofish)", ENCRYPT, sec, NULL, 0,
-				  twofish_speed_template);
+				speed_template_16_24_32);
 		test_cipher_speed("cbc(twofish)", DECRYPT, sec, NULL, 0,
-				  twofish_speed_template);
+				speed_template_16_24_32);
 		break;
 
 	case 203:
 		test_cipher_speed("ecb(blowfish)", ENCRYPT, sec, NULL, 0,
-				  blowfish_speed_template);
+				  speed_template_8_32);
 		test_cipher_speed("ecb(blowfish)", DECRYPT, sec, NULL, 0,
-				  blowfish_speed_template);
+				  speed_template_8_32);
 		test_cipher_speed("cbc(blowfish)", ENCRYPT, sec, NULL, 0,
-				  blowfish_speed_template);
+				  speed_template_8_32);
 		test_cipher_speed("cbc(blowfish)", DECRYPT, sec, NULL, 0,
-				  blowfish_speed_template);
+				  speed_template_8_32);
 		break;
 
 	case 204:
 		test_cipher_speed("ecb(des)", ENCRYPT, sec, NULL, 0,
-				  des_speed_template);
+				  speed_template_8);
 		test_cipher_speed("ecb(des)", DECRYPT, sec, NULL, 0,
-				  des_speed_template);
+				  speed_template_8);
 		test_cipher_speed("cbc(des)", ENCRYPT, sec, NULL, 0,
-				  des_speed_template);
+				  speed_template_8);
 		test_cipher_speed("cbc(des)", DECRYPT, sec, NULL, 0,
-				  des_speed_template);
+				  speed_template_8);
 		break;
 
 	case 205:
 		test_cipher_speed("ecb(camellia)", ENCRYPT, sec, NULL, 0,
-				camellia_speed_template);
+				speed_template_16_24_32);
 		test_cipher_speed("ecb(camellia)", DECRYPT, sec, NULL, 0,
-				camellia_speed_template);
+				speed_template_16_24_32);
 		test_cipher_speed("cbc(camellia)", ENCRYPT, sec, NULL, 0,
-				camellia_speed_template);
+				speed_template_16_24_32);
 		test_cipher_speed("cbc(camellia)", DECRYPT, sec, NULL, 0,
-				camellia_speed_template);
+				speed_template_16_24_32);
 		break;
 
 	case 206:
 		test_cipher_speed("salsa20", ENCRYPT, sec, NULL, 0,
-				  salsa20_speed_template);
+				  speed_template_16_32);
 		break;
 
 	case 300:
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index f785e56..4180a74 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -8032,7 +8032,62 @@ static struct hash_testvec crc32c_tv_template[] = {
 /*
  * Cipher speed tests
  */
-static struct cipher_speed aes_speed_template[] = {
+static struct cipher_speed speed_template_8[] = {
+	{ .klen = 8, .blen = 16, },
+	{ .klen = 8, .blen = 64, },
+	{ .klen = 8, .blen = 256, },
+	{ .klen = 8, .blen = 1024, },
+	{ .klen = 8, .blen = 8192, },
+
+	/* End marker */
+	{  .klen = 0, .blen = 0, }
+};
+
+static struct cipher_speed speed_template_24[] = {
+	{ .klen = 24, .blen = 16, },
+	{ .klen = 24, .blen = 64, },
+	{ .klen = 24, .blen = 256, },
+	{ .klen = 24, .blen = 1024, },
+	{ .klen = 24, .blen = 8192, },
+
+	/* End marker */
+	{  .klen = 0, .blen = 0, }
+};
+
+static struct cipher_speed speed_template_8_32[] = {
+	/* Don't support blowfish keys > 256 bit in this test */
+	{ .klen = 8, .blen = 16, },
+	{ .klen = 8, .blen = 64, },
+	{ .klen = 8, .blen = 256, },
+	{ .klen = 8, .blen = 1024, },
+	{ .klen = 8, .blen = 8192, },
+	{ .klen = 32, .blen = 16, },
+	{ .klen = 32, .blen = 64, },
+	{ .klen = 32, .blen = 256, },
+	{ .klen = 32, .blen = 1024, },
+	{ .klen = 32, .blen = 8192, },
+
+	/* End marker */
+	{  .klen = 0, .blen = 0, }
+};
+
+static struct cipher_speed speed_template_16_32[] = {
+      { .klen = 16, .blen = 16, },
+      { .klen = 16, .blen = 64, },
+      { .klen = 16, .blen = 256, },
+      { .klen = 16, .blen = 1024, },
+      { .klen = 16, .blen = 8192, },
+      { .klen = 32, .blen = 16, },
+      { .klen = 32, .blen = 64, },
+      { .klen = 32, .blen = 256, },
+      { .klen = 32, .blen = 1024, },
+      { .klen = 32, .blen = 8192, },
+
+      /* End marker */
+      {  .klen = 0, .blen = 0, }
+};
+
+static struct cipher_speed speed_template_16_24_32[] = {
 	{ .klen = 16, .blen = 16, },
 	{ .klen = 16, .blen = 64, },
 	{ .klen = 16, .blen = 256, },
@@ -8053,7 +8108,7 @@ static struct cipher_speed aes_speed_template[] = {
 	{  .klen = 0, .blen = 0, }
 };
 
-static struct cipher_speed aes_lrw_speed_template[] = {
+static struct cipher_speed speed_template_32_40_48[] = {
 	{ .klen = 32, .blen = 16, },
 	{ .klen = 32, .blen = 64, },
 	{ .klen = 32, .blen = 256, },
@@ -8074,7 +8129,7 @@ static struct cipher_speed aes_lrw_speed_template[] = {
 	{  .klen = 0, .blen = 0, }
 };
 
-static struct cipher_speed aes_xts_speed_template[] = {
+static struct cipher_speed speed_template_32_48_64[] = {
 	{ .klen = 32, .blen = 16, },
 	{ .klen = 32, .blen = 64, },
 	{ .klen = 32, .blen = 256, },
@@ -8095,66 +8150,6 @@ static struct cipher_speed aes_xts_speed_template[] = {
 	{  .klen = 0, .blen = 0, }
 };
 
-static struct cipher_speed des3_ede_speed_template[] = {
-	{ .klen = 24, .blen = 16, },
-	{ .klen = 24, .blen = 64, },
-	{ .klen = 24, .blen = 256, },
-	{ .klen = 24, .blen = 1024, },
-	{ .klen = 24, .blen = 8192, },
-
-	/* End marker */
-	{  .klen = 0, .blen = 0, }
-};
-
-static struct cipher_speed twofish_speed_template[] = {
-	{ .klen = 16, .blen = 16, },
-	{ .klen = 16, .blen = 64, },
-	{ .klen = 16, .blen = 256, },
-	{ .klen = 16, .blen = 1024, },
-	{ .klen = 16, .blen = 8192, },
-	{ .klen = 24, .blen = 16, },
-	{ .klen = 24, .blen = 64, },
-	{ .klen = 24, .blen = 256, },
-	{ .klen = 24, .blen = 1024, },
-	{ .klen = 24, .blen = 8192, },
-	{ .klen = 32, .blen = 16, },
-	{ .klen = 32, .blen = 64, },
-	{ .klen = 32, .blen = 256, },
-	{ .klen = 32, .blen = 1024, },
-	{ .klen = 32, .blen = 8192, },
-
-	/* End marker */
-	{  .klen = 0, .blen = 0, }
-};
-
-static struct cipher_speed blowfish_speed_template[] = {
-	/* Don't support blowfish keys > 256 bit in this test */
-	{ .klen = 8, .blen = 16, },
-	{ .klen = 8, .blen = 64, },
-	{ .klen = 8, .blen = 256, },
-	{ .klen = 8, .blen = 1024, },
-	{ .klen = 8, .blen = 8192, },
-	{ .klen = 32, .blen = 16, },
-	{ .klen = 32, .blen = 64, },
-	{ .klen = 32, .blen = 256, },
-	{ .klen = 32, .blen = 1024, },
-	{ .klen = 32, .blen = 8192, },
-
-	/* End marker */
-	{  .klen = 0, .blen = 0, }
-};
-
-static struct cipher_speed des_speed_template[] = {
-	{ .klen = 8, .blen = 16, },
-	{ .klen = 8, .blen = 64, },
-	{ .klen = 8, .blen = 256, },
-	{ .klen = 8, .blen = 1024, },
-	{ .klen = 8, .blen = 8192, },
-
-	/* End marker */
-	{  .klen = 0, .blen = 0, }
-};
-
 /*
  * Digest speed tests
  */
@@ -8186,41 +8181,4 @@ static struct hash_speed generic_hash_speed_template[] = {
 	{  .blen = 0,	.plen = 0, }
 };
 
-static struct cipher_speed camellia_speed_template[] = {
-      { .klen = 16, .blen = 16, },
-      { .klen = 16, .blen = 64, },
-      { .klen = 16, .blen = 256, },
-      { .klen = 16, .blen = 1024, },
-      { .klen = 16, .blen = 8192, },
-      { .klen = 24, .blen = 16, },
-      { .klen = 24, .blen = 64, },
-      { .klen = 24, .blen = 256, },
-      { .klen = 24, .blen = 1024, },
-      { .klen = 24, .blen = 8192, },
-      { .klen = 32, .blen = 16, },
-      { .klen = 32, .blen = 64, },
-      { .klen = 32, .blen = 256, },
-      { .klen = 32, .blen = 1024, },
-      { .klen = 32, .blen = 8192, },
-
-      /* End marker */
-      {  .klen = 0, .blen = 0, }
-};
-
-static struct cipher_speed salsa20_speed_template[] = {
-      { .klen = 16, .blen = 16, },
-      { .klen = 16, .blen = 64, },
-      { .klen = 16, .blen = 256, },
-      { .klen = 16, .blen = 1024, },
-      { .klen = 16, .blen = 8192, },
-      { .klen = 32, .blen = 16, },
-      { .klen = 32, .blen = 64, },
-      { .klen = 32, .blen = 256, },
-      { .klen = 32, .blen = 1024, },
-      { .klen = 32, .blen = 8192, },
-
-      /* End marker */
-      {  .klen = 0, .blen = 0, }
-};
-
 #endif	/* _CRYPTO_TCRYPT_H */
-- 
1.5.3.6
