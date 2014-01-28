From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH] crypto: omap-sham: Map SG pages if they are HIGHMEM before accessing
Date: Tue, 28 Jan 2014 17:43:20 -0600
Message-ID: <1390952600-29913-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Lokesh Vutla <lokeshvutla@ti.com>, Joel Fernandes <joelf@ti.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47088 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbaA1XnX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jan 2014 18:43:23 -0500
Received: from dflxv15.itg.ti.com ([128.247.5.124])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id s0SNhNOX019125
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jan 2014 17:43:23 -0600
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id s0SNhNYt031220
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jan 2014 17:43:23 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

HIGHMEM pages may not be mapped so we must kmap them before accessing.
This resolves a random OOPs error that was showing up during OpenSSL SHA tests.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-sham.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 8bdde57..fcf6562 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -636,11 +636,21 @@ static size_t omap_sham_append_buffer(struct omap_sham_reqctx *ctx,
 static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
 {
 	size_t count;
+	const u8 *vaddr;
 
 	while (ctx->sg) {
+		if (PageHighMem(sg_page(ctx->sg)))
+			vaddr = kmap_atomic(sg_page(ctx->sg));
+		else
+			vaddr = sg_virt(ctx->sg);
+
 		count = omap_sham_append_buffer(ctx,
-				sg_virt(ctx->sg) + ctx->offset,
+				vaddr + ctx->offset,
 				ctx->sg->length - ctx->offset);
+
+		if (PageHighMem(sg_page(ctx->sg)))
+			kunmap_atomic((void *)vaddr);
+
 		if (!count)
 			break;
 		ctx->offset += count;
-- 
1.7.9.5
