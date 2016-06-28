From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] crypto: tcrypt: Fix linkage error on ARM on division of s64
Date: Tue, 28 Jun 2016 09:23:07 +0200
Message-ID: <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
References: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54522 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbcF1HXS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jun 2016 03:23:18 -0400
In-reply-to: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

gcc 4.7.3 for ARM on Ubuntu couldn't link tcrypt module because of
division of s64:
	ERROR: "__aeabi_ldivmod" [crypto/tcrypt.ko] undefined!

Fixes: 087bcd225c56 ("crypto: tcrypt - Add speed tests for SHA multibuffer algorithms")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 crypto/tcrypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 3788a607921e..1ff373352511 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -668,8 +668,8 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 		}
 
 		printk("\nBlock: %lld cycles (%lld cycles/byte), %d bytes\n",
-			(s64) (end[7]-start[0])/1,
-			(s64) (end[7]-start[0])/(8*speed[i].blen),
+			(s64) (end[7]-start[0]),
+			(s64) div64_s64(end[7]-start[0], 8*speed[i].blen),
 			8*speed[i].blen);
 	}
 	ret = 0;
-- 
1.9.1
