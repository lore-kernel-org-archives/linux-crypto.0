From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 7/9] crypto: qat - Use IPAD/OPAD constant
Date: Fri, 19 May 2017 08:53:29 +0200
Message-ID: <20170519065331.27670-8-clabbe.montjoie@gmail.com>
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
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33465 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbdESGzz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2017 02:55:55 -0400
In-Reply-To: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
define.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 20f35df8a01f..5b5efcc52cb5 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -51,6 +51,7 @@
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 #include <crypto/hash.h>
+#include <crypto/hmac.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
 #include <linux/dma-mapping.h>
@@ -178,8 +179,8 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	for (i = 0; i < block_size; i++) {
 		char *ipad_ptr = ipad + i;
 		char *opad_ptr = opad + i;
-		*ipad_ptr ^= 0x36;
-		*opad_ptr ^= 0x5C;
+		*ipad_ptr ^= HMAC_IPAD_VALUE;
+		*opad_ptr ^= HMAC_OPAD_VALUE;
 	}
 
 	if (crypto_shash_init(shash))
-- 
2.13.0
