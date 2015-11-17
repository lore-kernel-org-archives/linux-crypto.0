From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 1/1] crypto: tcrypt: fix keysize argument of test_aead_speed for gcm(aes)
Date: Tue, 17 Nov 2015 13:37:10 +0100
Message-ID: <35cb25c643325f2051831dde57cba2362925cd56.1447763536.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:29127 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbbKQMgt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 07:36:49 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The key sizes used by AES in GCM mode should be 128, 192 or 256 bits (16,
24 or 32 bytes).
There is no additional 4byte nonce as for RFC 4106.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 crypto/tcrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 46a4a757d478..270bc4b82bd9 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1789,7 +1789,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		test_aead_speed("rfc4106(gcm(aes))", ENCRYPT, sec,
 				NULL, 0, 16, 16, aead_speed_template_20);
 		test_aead_speed("gcm(aes)", ENCRYPT, sec,
-				NULL, 0, 16, 8, aead_speed_template_20);
+				NULL, 0, 16, 8, speed_template_16_24_32);
 		break;
 
 	case 212:
-- 
1.8.2.2
