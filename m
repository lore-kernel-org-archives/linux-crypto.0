From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: [PATCH v1] crypto: brcm - Fix SHA3-512 algorithm failure
Date: Fri, 23 Jun 2017 14:34:08 +0530
Message-ID: <1498208648-15948-1-git-send-email-raveendra.padasalagi@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In Broadcom SPU driver, due to missing break statement
in spu2_hash_xlate() while mapping SPU2 equivalent
SHA3-512 value, -EINVAL is chosen and hence leading to
failure of SHA3-512 algorithm. This patch fixes the same.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Cc: stable@vger.kernel.org
---

Changes in v1:
 - Added Cc and fixes tag in the Signed-off area to send the patch
   to stable kernel

 drivers/crypto/bcm/spu2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
index ef04c97..bf7ac62 100644
--- a/drivers/crypto/bcm/spu2.c
+++ b/drivers/crypto/bcm/spu2.c
@@ -302,6 +302,7 @@ static int spu2_hash_mode_xlate(enum hash_mode hash_mode,
 		break;
 	case HASH_ALG_SHA3_512:
 		*spu2_type = SPU2_HASH_TYPE_SHA3_512;
+		break;
 	case HASH_ALG_LAST:
 	default:
 		err = -EINVAL;
-- 
1.9.1
