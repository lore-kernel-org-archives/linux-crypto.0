From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 5/9] crypto: mv_cesa - Use IPAD/OPAD constant
Date: Mon, 24 Apr 2017 16:16:25 +0200
Message-ID: <20170424141629.27155-5-clabbe.montjoie@gmail.com>
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
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35266 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1172416AbdDXOSw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 10:18:52 -0400
In-Reply-To: <20170424141629.27155-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
define.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/mv_cesa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 451fa18..41ae190 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -822,8 +822,8 @@ static int mv_hash_setkey(struct crypto_ahash *tfm, const u8 * key,
 		memcpy(opad, ipad, bs);
 
 		for (i = 0; i < bs; i++) {
-			ipad[i] ^= 0x36;
-			opad[i] ^= 0x5c;
+			ipad[i] ^= HMAC_IPAD_VALUE;
+			opad[i] ^= HMAC_OPAD_VALUE;
 		}
 
 		rc = crypto_shash_init(shash) ? :
-- 
2.10.2
