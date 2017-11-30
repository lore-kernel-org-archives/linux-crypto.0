From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 2/6] crypto: tcrypt: fix AEAD decryption speed test
Date: Thu, 30 Nov 2017 10:09:28 +0000
Message-ID: <1512036574-26665-3-git-send-email-gilad@benyossef.com>
References: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The AEAD speed test pretended to support decryption, however that support
was broken as decryption requires a valid auth field which the test did
not provide.

Fix this by running the encryption path once with inout/output sgls
switched to calculate the auth field prior to performing decryption
speed tests.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/tcrypt.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d1fd033..56fb6a6 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -327,10 +327,30 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			sg_set_buf(&sg[0], assoc, aad_size);
 			sg_set_buf(&sgout[0], assoc, aad_size);
 
+			aead_request_set_ad(req, aad_size);
+
+			if (!enc) {
+
+				/*
+				 * For decryption we need a proper auth so
+				 * we do the encryption path once with buffers
+				 * reversed (input <-> output) to calculate it
+				 */
+				aead_request_set_crypt(req, sgout, sg,
+						       *b_size, iv);
+				ret = do_one_aead_op(req,
+						     crypto_aead_encrypt(req));
+
+				if (ret) {
+					pr_err("calculating auth failed failed (%d)\n",
+					       ret);
+					break;
+				}
+			}
+
 			aead_request_set_crypt(req, sg, sgout,
 					       *b_size + (enc ? 0 : authsize),
 					       iv);
-			aead_request_set_ad(req, aad_size);
 
 			if (secs)
 				ret = test_aead_jiffies(req, enc, *b_size,
@@ -1564,16 +1584,24 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 				NULL, 0, 16, 16, aead_speed_template_20);
 		test_aead_speed("gcm(aes)", ENCRYPT, sec,
 				NULL, 0, 16, 8, speed_template_16_24_32);
+		test_aead_speed("rfc4106(gcm(aes))", DECRYPT, sec,
+				NULL, 0, 16, 16, aead_speed_template_20);
+		test_aead_speed("gcm(aes)", DECRYPT, sec,
+				NULL, 0, 16, 8, speed_template_16_24_32);
 		break;
 
 	case 212:
 		test_aead_speed("rfc4309(ccm(aes))", ENCRYPT, sec,
 				NULL, 0, 16, 16, aead_speed_template_19);
+		test_aead_speed("rfc4309(ccm(aes))", DECRYPT, sec,
+				NULL, 0, 16, 16, aead_speed_template_19);
 		break;
 
 	case 213:
 		test_aead_speed("rfc7539esp(chacha20,poly1305)", ENCRYPT, sec,
 				NULL, 0, 16, 8, aead_speed_template_36);
+		test_aead_speed("rfc7539esp(chacha20,poly1305)", DECRYPT, sec,
+				NULL, 0, 16, 8, aead_speed_template_36);
 		break;
 
 	case 214:
-- 
2.7.4
