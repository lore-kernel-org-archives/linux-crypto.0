From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 01/10] crypto: tcrypt - Add ChaCha20/Poly1305 speed tests
Date: Tue,  7 Jul 2015 21:36:47 +0200
Message-ID: <1436297816-16414-2-git-send-email-martin@strongswan.org>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:44665 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252AbbGGThV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 15:37:21 -0400
In-Reply-To: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adds individual ChaCha20 and Poly1305 and a combined rfc7539esp AEAD speed
test using mode numbers 214, 321 and 213. For Poly1305 we add a specific
speed template, as it expects the key prepended to the input data.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 crypto/tcrypt.c | 15 +++++++++++++++
 crypto/tcrypt.h | 20 ++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9f6f10b..0e2f651 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1767,6 +1767,17 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 				NULL, 0, 16, 8, aead_speed_template_19);
 		break;
 
+	case 213:
+		test_aead_speed("rfc7539esp(chacha20,poly1305)", ENCRYPT, sec,
+				NULL, 0, 16, 8, aead_speed_template_36);
+		break;
+
+	case 214:
+		test_cipher_speed("chacha20", ENCRYPT, sec, NULL, 0,
+				  speed_template_32);
+		break;
+
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
@@ -1855,6 +1866,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		test_hash_speed("crct10dif", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
+	case 321:
+		test_hash_speed("poly1305", sec, poly1305_speed_template);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 6cc1b85..f0bfee1 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -61,12 +61,14 @@ static u8 speed_template_32_40_48[] = {32, 40, 48, 0};
 static u8 speed_template_32_48[] = {32, 48, 0};
 static u8 speed_template_32_48_64[] = {32, 48, 64, 0};
 static u8 speed_template_32_64[] = {32, 64, 0};
+static u8 speed_template_32[] = {32, 0};
 
 /*
  * AEAD speed tests
  */
 static u8 aead_speed_template_19[] = {19, 0};
 static u8 aead_speed_template_20[] = {20, 0};
+static u8 aead_speed_template_36[] = {36, 0};
 
 /*
  * Digest speed tests
@@ -127,4 +129,22 @@ static struct hash_speed hash_speed_template_16[] = {
 	{  .blen = 0,	.plen = 0,	.klen = 0, }
 };
 
+static struct hash_speed poly1305_speed_template[] = {
+	{ .blen = 96,	.plen = 16, },
+	{ .blen = 96,	.plen = 32, },
+	{ .blen = 96,	.plen = 96, },
+	{ .blen = 288,	.plen = 16, },
+	{ .blen = 288,	.plen = 32, },
+	{ .blen = 288,	.plen = 288, },
+	{ .blen = 1056,	.plen = 32, },
+	{ .blen = 1056,	.plen = 1056, },
+	{ .blen = 2080,	.plen = 32, },
+	{ .blen = 2080,	.plen = 2080, },
+	{ .blen = 4128,	.plen = 4128, },
+	{ .blen = 8224,	.plen = 8224, },
+
+	/* End marker */
+	{  .blen = 0,	.plen = 0, }
+};
+
 #endif	/* _CRYPTO_TCRYPT_H */
-- 
1.9.1
