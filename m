From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 27/28] crypto: tcrypt - Add speed test for cts
Date: Wed, 29 Jun 2016 18:04:14 +0800
Message-ID: <E1bICLu-0006y7-PT@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55291 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbcF2KER (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:17 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLu-0005P2-TH
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:14 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds speed tests for cts(cbc(aes)).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9ca822c..2e29221 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1270,6 +1270,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 				speed_template_32_48_64);
 		test_cipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_32_48_64);
+		test_cipher_speed("cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_cipher_speed("cts(cbc(aes))", DECRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
 		test_cipher_speed("ctr(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
 		test_cipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
@@ -1688,6 +1692,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 				   speed_template_32_48_64);
 		test_acipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_48_64);
+		test_acipher_speed("cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("cts(cbc(aes))", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
 		test_acipher_speed("ctr(aes)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
 		test_acipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
