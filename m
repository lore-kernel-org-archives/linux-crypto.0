From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 1/2] crypto: tcrypt - add ctr(des3_ede) sync speed test
Date: Mon, 09 Jun 2014 20:59:49 +0300
Message-ID: <20140609175949.15947.64452.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:58070 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829AbaFISHG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jun 2014 14:07:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/tcrypt.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ba247cf..164ec0e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1585,6 +1585,12 @@ static int do_test(int m)
 		test_cipher_speed("cbc(des3_ede)", DECRYPT, sec,
 				des3_speed_template, DES3_SPEED_VECTORS,
 				speed_template_24);
+		test_cipher_speed("ctr(des3_ede)", ENCRYPT, sec,
+				des3_speed_template, DES3_SPEED_VECTORS,
+				speed_template_24);
+		test_cipher_speed("ctr(des3_ede)", DECRYPT, sec,
+				des3_speed_template, DES3_SPEED_VECTORS,
+				speed_template_24);
 		break;
 
 	case 202:
