From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v3 07/13] crypto: sun4i-ss: simplify the appended bit assignment
Date: Thu,  1 Jun 2017 21:38:59 +0200
Message-ID: <20170601193905.28829-8-antoine.tenart@free-electrons.com>
References: <20170601193905.28829-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46609 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdFATjk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2017 15:39:40 -0400
In-Reply-To: <20170601193905.28829-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A bit is appended at the end of the input buffer for sha1. Simplify the
code assigning it.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 59d9b4412aca..0c2efc88bc0a 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -392,12 +392,8 @@ static int sun4i_hash(struct ahash_request *areq)
 	}
 
 	/* write the remaining bytes of the nbw buffer */
-	if (nbw) {
-		wb |= ((1 << 7) << (nbw * 8));
-		bf[j++] = wb;
-	} else {
-		bf[j++] = 1 << 7;
-	}
+	wb |= ((1 << 7) << (nbw * 8));
+	bf[j++] = wb;
 
 	/*
 	 * number of space to pad to obtain 64o minus 8(size) minus 4 (final 1)
-- 
2.9.4
