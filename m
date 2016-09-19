From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 5/8] crypto: omap-sham: change the DMA threshold value to a define
Date: Mon, 19 Sep 2016 18:22:16 +0300
Message-ID: <1474298539-23897-6-git-send-email-t-kristo@ti.com>
References: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:53481 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932164AbcISPXO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2016 11:23:14 -0400
In-Reply-To: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently the threshold value was hardcoded in the driver. Having a define
for it makes it easier to configure.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 8558989..5c95bf9 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -137,6 +137,7 @@
 #define OMAP_ALIGNED		__attribute__((aligned(sizeof(u32))))
 
 #define BUFLEN			PAGE_SIZE
+#define OMAP_SHA_DMA_THRESHOLD	256
 
 struct omap_sham_dev;
 
@@ -1435,10 +1436,11 @@ static int omap_sham_final(struct ahash_request *req)
 	/*
 	 * OMAP HW accel works only with buffers >= 9.
 	 * HMAC is always >= 9 because ipad == block size.
-	 * If buffersize is less than 240, we use fallback SW encoding,
-	 * as using DMA + HW in this case doesn't provide any benefit.
+	 * If buffersize is less than DMA_THRESHOLD, we use fallback
+	 * SW encoding, as using DMA + HW in this case doesn't provide
+	 * any benefit.
 	 */
-	if (!ctx->digcnt && ctx->bufcnt < 240)
+	if (!ctx->digcnt && ctx->bufcnt < OMAP_SHA_DMA_THRESHOLD)
 		return omap_sham_final_shash(req);
 	else if (ctx->bufcnt)
 		return omap_sham_enqueue(req, OP_FINAL);
-- 
1.9.1
