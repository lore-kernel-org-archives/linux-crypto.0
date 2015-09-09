From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun4i-ss Fix a possible driver hang with ciphers
Date: Wed,  9 Sep 2015 14:27:07 +0200
Message-ID: <1441801627-31820-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	maxime.ripard@free-electrons.com,
	linux-arm-kernel@lists.infradead.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33544 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbbIIM1h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 08:27:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The sun4i_ss_opti_poll function cipher data until the output miter have
a length of 0.
If the crypto API client, give more SGs than necessary this could result
in an infinite loop.
Fix it by checking for remaining bytes, just like sun4i_ss_cipher_poll().

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index e070c31..a19ee12 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -104,7 +104,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 			sg_miter_next(&mo);
 			oo = 0;
 		}
-	} while (mo.length > 0);
+	} while (oleft > 0);
 
 	if (areq->info) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-- 
2.4.6
