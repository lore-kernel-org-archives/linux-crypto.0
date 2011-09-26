From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/3] crypto: tcrypt: add ctr(twofish) speed test
Date: Mon, 26 Sep 2011 16:47:15 +0300
Message-ID: <20110926134715.21453.18179.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:50252 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1IZNrV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Sep 2011 09:47:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index e353a28..fc35650 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1039,6 +1039,10 @@ static int do_test(int m)
 				speed_template_16_24_32);
 		test_cipher_speed("cbc(twofish)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
+		test_cipher_speed("ctr(twofish)", ENCRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_cipher_speed("ctr(twofish)", DECRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
 		break;
 
 	case 203:
