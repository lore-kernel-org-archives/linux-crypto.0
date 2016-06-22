From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 04/27] crypto: omap-sham: set sw fallback to 240 bytes
Date: Wed, 22 Jun 2016 16:23:37 +0300
Message-ID: <1466601840-18486-5-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:57902 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbcFVNZD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:03 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
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
index fd3cac3..6247887 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1095,7 +1095,7 @@ static int omap_sham_update(struct ahash_request *req)
 	ctx->offset = 0;
 
 	if (ctx->flags & BIT(FLAGS_FINUP)) {
-		if ((ctx->digcnt + ctx->bufcnt + ctx->total) < 9) {
+		if ((ctx->digcnt + ctx->bufcnt + ctx->total) < 240) {
 			/*
 			* OMAP HW accel works only with buffers >= 9
 			* will switch to bypass in final()
@@ -1151,9 +1151,13 @@ static int omap_sham_final(struct ahash_request *req)
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
