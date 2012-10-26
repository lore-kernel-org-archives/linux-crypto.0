From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/3] [v2] crypto: tcrypt - add async speed test for camellia
 cipher
Date: Fri, 26 Oct 2012 14:48:51 +0300
Message-ID: <20121026114851.3373.28271.stgit@localhost6.localdomain6>
References: <20121026114845.3373.17236.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:35644 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab2JZLsy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2012 07:48:54 -0400
In-Reply-To: <20121026114845.3373.17236.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 71b58c6..7ae2130 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1728,6 +1728,29 @@ static int do_test(int m)
 				   speed_template_32_64);
 		break;
 
+	case 508:
+		test_acipher_speed("ecb(camellia)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("ecb(camellia)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("cbc(camellia)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("cbc(camellia)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("ctr(camellia)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("ctr(camellia)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("lrw(camellia)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_48);
+		test_acipher_speed("lrw(camellia)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_48);
+		test_acipher_speed("xts(camellia)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		test_acipher_speed("xts(camellia)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		break;
+
 	case 1000:
 		test_available();
 		break;
