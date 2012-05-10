From: Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH v2 3/3] crypto: ux500: Cleanup hardware identification
Date: Thu, 10 May 2012 10:14:08 +0200
Message-ID: <1336637648-10064-4-git-send-email-andreas.westin@stericsson.com>
References: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <arnd@arndb.de>,
	<sfr@canb.auug.org.au>, <lee.jones@linaro.org>,
	<linus.walleij@linaro.org>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:57819 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757300Ab2EJIOo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 04:14:44 -0400
In-Reply-To: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Don't use SOC specific functions to identify
which crypto hardware we are talking to and use
the ID provided in the module instead.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andreas Westin <andreas.westin@stericsson.com>
---
 drivers/crypto/ux500/cryp/cryp.c      |   10 ++++------
 drivers/crypto/ux500/cryp/cryp_p.h    |    1 -
 drivers/crypto/ux500/hash/hash_core.c |   10 ----------
 3 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp.c b/drivers/crypto/ux500/cryp/cryp.c
index bd206ff..e208cea 100644
--- a/drivers/crypto/ux500/cryp/cryp.c
+++ b/drivers/crypto/ux500/cryp/cryp.c
@@ -37,18 +37,16 @@ int cryp_check(struct cryp_device_data *device_data)
 	if (NULL == device_data)
 		return -EINVAL;
 
-	if (cpu_is_u8500())
-		peripheralid2 = CRYP_PERIPHERAL_ID2_DB8500;
-	else if (cpu_is_u5500())
-		peripheralid2 = CRYP_PERIPHERAL_ID2_DB5500;
+	peripheralid2 = readl_relaxed(&device_data->base->periphId2);
+
+	if (peripheralid2 != CRYP_PERIPHERAL_ID2_DB8500)
+		return -EPERM;
 
 	/* Check Peripheral and Pcell Id Register for CRYP */
 	if ((CRYP_PERIPHERAL_ID0 ==
 		readl_relaxed(&device_data->base->periphId0))
 	    && (CRYP_PERIPHERAL_ID1 ==
 		    readl_relaxed(&device_data->base->periphId1))
-	    && (peripheralid2 ==
-		    readl_relaxed(&device_data->base->periphId2))
 	    && (CRYP_PERIPHERAL_ID3 ==
 		    readl_relaxed(&device_data->base->periphId3))
 	    && (CRYP_PCELL_ID0 ==
diff --git a/drivers/crypto/ux500/cryp/cryp_p.h b/drivers/crypto/ux500/cryp/cryp_p.h
index 0e07082..6dcffe1 100644
--- a/drivers/crypto/ux500/cryp/cryp_p.h
+++ b/drivers/crypto/ux500/cryp/cryp_p.h
@@ -41,7 +41,6 @@
 #define CRYP_PERIPHERAL_ID1		0x05
 
 #define CRYP_PERIPHERAL_ID2_DB8500	0x28
-#define CRYP_PERIPHERAL_ID2_DB5500	0x29
 #define CRYP_PERIPHERAL_ID3		0x00
 
 #define CRYP_PCELL_ID0			0x0D
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 77f7508..6dbb9ec 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -574,15 +574,6 @@ static int hash_init(struct ahash_request *req)
 	memset(&req_ctx->state, 0, sizeof(struct hash_state));
 	req_ctx->updated = 0;
 	if (hash_mode == HASH_MODE_DMA) {
-		if ((ctx->config.oper_mode == HASH_OPER_MODE_HMAC) &&
-				cpu_is_u5500()) {
-			pr_debug(DEV_DBG_NAME " [%s] HMAC and DMA not working "
-					"on u5500, directing to CPU mode.",
-					__func__);
-			req_ctx->dma_mode = false; /* Don't use DMA */
-			goto out;
-		}
-
 		if (req->nbytes < HASH_DMA_ALIGN_SIZE) {
 			req_ctx->dma_mode = false; /* Don't use DMA */
 
@@ -604,7 +595,6 @@ static int hash_init(struct ahash_request *req)
 			}
 		}
 	}
-out:
 	return 0;
 }
 
-- 
1.7.10
