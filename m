From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [[RFC] PATCH 3/4] crypto: tcrypt: add ctr(blowfish) speed test
Date: Fri, 02 Sep 2011 01:45:17 +0300
Message-ID: <20110901224517.7795.28909.stgit@localhost6.localdomain6>
References: <20110901224506.7795.35128.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:56987 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1IAWxT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Sep 2011 18:53:19 -0400
In-Reply-To: <20110901224506.7795.35128.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add ctr(blowfish) speed test to receive results for blowfish x86_64 assembly
patch.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 2222617..e353a28 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1050,6 +1050,10 @@ static int do_test(int m)
 				  speed_template_8_32);
 		test_cipher_speed("cbc(blowfish)", DECRYPT, sec, NULL, 0,
 				  speed_template_8_32);
+		test_cipher_speed("ctr(blowfish)", ENCRYPT, sec, NULL, 0,
+				  speed_template_8_32);
+		test_cipher_speed("ctr(blowfish)", DECRYPT, sec, NULL, 0,
+				  speed_template_8_32);
 		break;
 
 	case 204:
