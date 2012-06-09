From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/3] crypto: tcrypt: add ecb(arc4) speed tests
Date: Sat, 09 Jun 2012 18:25:35 +0300
Message-ID: <20120609152535.16420.13917.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:55284 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2FIPZi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jun 2012 11:25:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8f147bf..cc86706 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1339,6 +1339,11 @@ static int do_test(int m)
 				  speed_template_32_64);
 		break;
 
+	case 208:
+		test_cipher_speed("ecb(arc4)", ENCRYPT, sec, NULL, 0,
+				  speed_template_8);
+		break;
+
 	case 300:
 		/* fall through */
 
@@ -1563,6 +1568,11 @@ static int do_test(int m)
 				   speed_template_32_64);
 		break;
 
+	case 504:
+		test_acipher_speed("ecb(arc4)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8);
+		break;
+
 	case 1000:
 		test_available();
 		break;
