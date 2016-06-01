From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 05/28] crypto: omap-sham: set sw fallback to 240 bytes
Date: Wed, 1 Jun 2016 11:56:06 +0300
Message-ID: <1464771389-10640-6-git-send-email-t-kristo@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>,
	Bin Liu <b-liu@ti.com>, Tero Kristo <t-kristo@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:50151 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249AbcFAI5q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 04:57:46 -0400
In-Reply-To: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Bin Liu <b-liu@ti.com>

Adds software fallback support for small crypto requests. In these cases,
it is undesirable to use DMA, as setting it up itself is rather heavy
operation. Gives about 40% extra performance in ipsec usecase.

Signed-off-by: Bin Liu <b-liu@ti.com>
[t-kristo@ti.com: dropped the extra traces, updated some comments
 on the code]
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 287bc43..a5c823b 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1082,7 +1082,7 @@ static int omap_sham_update(struct ahash_request *req)
 	ctx->offset = 0;
 
 	if (ctx->flags & BIT(FLAGS_FINUP)) {
-		if ((ctx->digcnt + ctx->bufcnt + ctx->total) < 9) {
+		if ((ctx->digcnt + ctx->bufcnt + ctx->total) < 240) {
 			/*
 			* OMAP HW accel works only with buffers >= 9
 			* will switch to bypass in final()
@@ -1138,9 +1138,13 @@ static int omap_sham_final(struct ahash_request *req)
 	if (ctx->flags & BIT(FLAGS_ERROR))
 		return 0; /* uncompleted hash is not needed */
 
-	/* OMAP HW accel works only with buffers >= 9 */
-	/* HMAC is always >= 9 because ipad == block size */
-	if ((ctx->digcnt + ctx->bufcnt) < 9)
+	/*
+	 * OMAP HW accel works only with buffers >= 9.
+	 * HMAC is always >= 9 because ipad == block size.
+	 * If buffersize is less than 240, we use fallback SW encoding,
+	 * as using DMA + HW in this case doesn't provide any benefit.
+	 */
+	if ((ctx->digcnt + ctx->bufcnt) < 240)
 		return omap_sham_final_shash(req);
 	else if (ctx->bufcnt)
 		return omap_sham_enqueue(req, OP_FINAL);
-- 
1.9.1
