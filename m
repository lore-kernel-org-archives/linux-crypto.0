From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [RFC PATCH 2/6] crypto: tcrypt - add async cipher speed tests for
 blowfish
Date: Sat, 13 Apr 2013 13:46:40 +0300
Message-ID: <20130413104640.10667.27531.stgit@localhost6.localdomain6>
References: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/tcrypt.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 24ea7df..66d254c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1768,6 +1768,21 @@ static int do_test(int m)
 				   speed_template_32_64);
 		break;
 
+	case 509:
+		test_acipher_speed("ecb(blowfish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		test_acipher_speed("ecb(blowfish)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		test_acipher_speed("cbc(blowfish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		test_acipher_speed("cbc(blowfish)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		test_acipher_speed("ctr(blowfish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		test_acipher_speed("ctr(blowfish)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		break;
+
 	case 1000:
 		test_available();
 		break;
