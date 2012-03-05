From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/6] crypto: tcrypt - add more camellia tests
Date: Mon, 05 Mar 2012 20:26:26 +0200
Message-ID: <20120305182626.25411.32315.stgit@localhost6.localdomain6>
References: <20120305182616.25411.58251.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:33206 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2CES0y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Mar 2012 13:26:54 -0500
In-Reply-To: <20120305182616.25411.58251.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add tests for CTR, LRW and XTS modes.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 7736a9f..8f147bf 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1297,6 +1297,18 @@ static int do_test(int m)
 				speed_template_16_24_32);
 		test_cipher_speed("cbc(camellia)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
+		test_cipher_speed("ctr(camellia)", ENCRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_cipher_speed("ctr(camellia)", DECRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_cipher_speed("lrw(camellia)", ENCRYPT, sec, NULL, 0,
+				speed_template_32_40_48);
+		test_cipher_speed("lrw(camellia)", DECRYPT, sec, NULL, 0,
+				speed_template_32_40_48);
+		test_cipher_speed("xts(camellia)", ENCRYPT, sec, NULL, 0,
+				speed_template_32_48_64);
+		test_cipher_speed("xts(camellia)", DECRYPT, sec, NULL, 0,
+				speed_template_32_48_64);
 		break;
 
 	case 206:
