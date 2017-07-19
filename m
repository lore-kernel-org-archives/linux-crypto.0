From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: tcrypt - remove AES-XTS-192 speed tests
Date: Wed, 19 Jul 2017 19:40:32 +0300
Message-ID: <20170719164032.17731-1-horia.geanta@nxp.com>
References: <1787722.TLPNYLEBHS@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>,
        Dan Douglass <dan.douglass@nxp.com>,
        <linux-crypto@vger.kernel.org>, <dm-devel@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0052.outbound.protection.outlook.com ([104.47.32.52]:54352
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933101AbdGSQkw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 12:40:52 -0400
In-Reply-To: <1787722.TLPNYLEBHS@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove xts(aes) speed tests with 2 x 192-bit keys, since implementations
adhering strictly to IEEE 1619-2007 standard cannot cope with key sizes
other than 2 x 128, 2 x 256 bits - i.e. AES-XTS-{128,256}:
[...]
tcrypt: test 5 (384 bit key, 16 byte blocks):
caam_jr 8020000.jr: key size mismatch
tcrypt: setkey() failed flags=200000
[...]

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 crypto/tcrypt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 0dd6a432d6ca..0022a18d36ee 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1404,9 +1404,9 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		test_cipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_32_40_48);
 		test_cipher_speed("xts(aes)", ENCRYPT, sec, NULL, 0,
-				speed_template_32_48_64);
+				speed_template_32_64);
 		test_cipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
-				speed_template_32_48_64);
+				speed_template_32_64);
 		test_cipher_speed("cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
 		test_cipher_speed("cts(cbc(aes))", DECRYPT, sec, NULL, 0,
@@ -1837,9 +1837,9 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		test_acipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_40_48);
 		test_acipher_speed("xts(aes)", ENCRYPT, sec, NULL, 0,
-				   speed_template_32_48_64);
+				   speed_template_32_64);
 		test_acipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
-				   speed_template_32_48_64);
+				   speed_template_32_64);
 		test_acipher_speed("cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
 		test_acipher_speed("cts(cbc(aes))", DECRYPT, sec, NULL, 0,
-- 
2.12.0.264.gd6db3f216544
