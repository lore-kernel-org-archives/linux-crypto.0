From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 9/9] crypto: ccp - Use IPAD/OPAD constant
Date: Fri, 19 May 2017 08:53:31 +0200
Message-ID: <20170519065331.27670-10-clabbe.montjoie@gmail.com>
References: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
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
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34659 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752558AbdESGz5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2017 02:55:57 -0400
In-Reply-To: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
define.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/ccp/ccp-crypto-sha.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 6b46eea94932..ce97b3868f4a 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -18,6 +18,7 @@
 #include <linux/crypto.h>
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
+#include <crypto/hmac.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
 #include <crypto/scatterwalk.h>
@@ -308,8 +309,8 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 	}
 
 	for (i = 0; i < block_size; i++) {
-		ctx->u.sha.ipad[i] = ctx->u.sha.key[i] ^ 0x36;
-		ctx->u.sha.opad[i] = ctx->u.sha.key[i] ^ 0x5c;
+		ctx->u.sha.ipad[i] = ctx->u.sha.key[i] ^ HMAC_IPAD_VALUE;
+		ctx->u.sha.opad[i] = ctx->u.sha.key[i] ^ HMAC_OPAD_VALUE;
 	}
 
 	sg_init_one(&ctx->u.sha.opad_sg, ctx->u.sha.opad, block_size);
-- 
2.13.0
