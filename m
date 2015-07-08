From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/14] crypto: tcrypt - Add support for new IV convention
Date: Thu, 09 Jul 2015 07:17:26 +0800
Message-ID: <E1ZCyak-0007Zf-No@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53005 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbbGHXRa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:30 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyal-0005Fl-Nv
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:27 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch allows the AEAD speed tests to cope with the new seqiv
calling convention as well as the old one.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 3603c7c..73ed4f2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -344,7 +344,12 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 		goto out_nosg;
 	sgout = &sg[9];
 
-	tfm = crypto_alloc_aead(algo, 0, 0);
+	tfm = crypto_alloc_aead(algo, CRYPTO_ALG_AEAD_NEW,
+				CRYPTO_ALG_AEAD_NEW);
+	if (PTR_ERR(tfm) == -ENOENT) {
+		aad_size -= 8;
+		tfm = crypto_alloc_aead(algo, 0, CRYPTO_ALG_AEAD_NEW);
+	}
 
 	if (IS_ERR(tfm)) {
 		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
@@ -1778,14 +1783,14 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 
 	case 211:
 		test_aead_speed("rfc4106(gcm(aes))", ENCRYPT, sec,
-				NULL, 0, 16, 8, aead_speed_template_20);
+				NULL, 0, 16, 16, aead_speed_template_20);
 		test_aead_speed("gcm(aes)", ENCRYPT, sec,
 				NULL, 0, 16, 8, aead_speed_template_20);
 		break;
 
 	case 212:
 		test_aead_speed("rfc4309(ccm(aes))", ENCRYPT, sec,
-				NULL, 0, 16, 8, aead_speed_template_19);
+				NULL, 0, 16, 16, aead_speed_template_19);
 		break;
 
 	case 300:
