From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 8/9] crypto: mediatek - Use IPAD/OPAD constant
Date: Mon, 24 Apr 2017 16:16:28 +0200
Message-ID: <20170424141629.27155-8-clabbe.montjoie@gmail.com>
References: <20170424141629.27155-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, qat-linux@intel.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        thomas.lendacky@amd.com, gary.hook@amd.com,
        boris.brezillon@free-electrons.com, arno@natisbad.org,
        matthias.bgg@gmail.com, giovanni.cabiddu@intel.com,
        salvatore.benedetto@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34607 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1172413AbdDXOSv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 10:18:51 -0400
In-Reply-To: <20170424141629.27155-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
define.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/mediatek/mtk-sha.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 2226f12..cbcb522 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -825,8 +825,8 @@ static int mtk_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 	memcpy(bctx->opad, bctx->ipad, bs);
 
 	for (i = 0; i < bs; i++) {
-		bctx->ipad[i] ^= 0x36;
-		bctx->opad[i] ^= 0x5c;
+		bctx->ipad[i] ^= HMAC_IPAD_VALUE;
+		bctx->opad[i] ^= HMAC_OPAD_VALUE;
 	}
 
 	return 0;
-- 
2.10.2
