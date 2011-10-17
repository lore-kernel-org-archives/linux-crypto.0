From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/7] crypto: tcrypt: add serpent speed tests
Date: Tue, 18 Oct 2011 00:03:03 +0300
Message-ID: <20111017210303.13543.9459.stgit@localhost6.localdomain6>
References: <20111017210247.13543.75430.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:51252 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1JQVDF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Oct 2011 17:03:05 -0400
In-Reply-To: <20111017210247.13543.75430.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index dd3a0f8..5526065 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1292,6 +1292,21 @@ static int do_test(int m)
 				  speed_template_16_32);
 		break;
 
+	case 207:
+		test_cipher_speed("ecb(serpent)", ENCRYPT, sec, NULL, 0,
+				  speed_template_16_32);
+		test_cipher_speed("ecb(serpent)", DECRYPT, sec, NULL, 0,
+				  speed_template_16_32);
+		test_cipher_speed("cbc(serpent)", ENCRYPT, sec, NULL, 0,
+				  speed_template_16_32);
+		test_cipher_speed("cbc(serpent)", DECRYPT, sec, NULL, 0,
+				  speed_template_16_32);
+		test_cipher_speed("ctr(serpent)", ENCRYPT, sec, NULL, 0,
+				  speed_template_16_32);
+		test_cipher_speed("ctr(serpent)", DECRYPT, sec, NULL, 0,
+				  speed_template_16_32);
+		break;
+
 	case 300:
 		/* fall through */
 
@@ -1493,6 +1508,21 @@ static int do_test(int m)
 				   speed_template_8);
 		break;
 
+	case 503:
+		test_acipher_speed("ecb(serpent)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("ecb(serpent)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("cbc(serpent)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("cbc(serpent)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("ctr(serpent)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		test_acipher_speed("ctr(serpent)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		break;
+
 	case 1000:
 		test_available();
 		break;
