From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] Move command descriptor setup to seperate function as preparation
Date: Wed, 19 Nov 2008 17:03:26 +0300
Message-ID: <12271034132587-git-send-email-zbr@ioremap.net>
References: <12271034133347-git-send-email-zbr@ioremap.net>
Cc: linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zbr.yandex.ru ([213.180.219.33]:37385 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753986AbYKSOHy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2008 09:07:54 -0500
In-Reply-To: <12271034133347-git-send-email-zbr@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Note 1: also fix a harmless typo while moving it: sa_idx is initialized
	to dma->resi instead of dma->cmdi.

Note 2: errors from command descriptor setup are not propagated back,
	anymore, they can't be handled anyway and all conditions leading
	to errors should be checked earlier.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/crypto/hifn_795x.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 4d22b21..320d08d 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1296,7 +1296,7 @@ static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
 
 	dma->srcr[idx].p = __cpu_to_le32(addr);
 	dma->srcr[idx].l = __cpu_to_le32(size | HIFN_D_VALID |
-			HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
+			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST);
 
 	if (++idx == HIFN_D_SRC_RSIZE) {
 		dma->srcr[idx].l = __cpu_to_le32(HIFN_D_VALID |
@@ -1324,7 +1324,7 @@ static void hifn_setup_res_desc(struct hifn_device *dev)
 			HIFN_D_VALID | HIFN_D_LAST);
 	/*
 	 * dma->resr[dma->resi].l = __cpu_to_le32(HIFN_MAX_RESULT | HIFN_D_VALID |
-	 *					HIFN_D_LAST);
+	 *					HIFN_D_LAST | HIFN_D_NOINVALID);
 	 */
 
 	if (++dma->resi == HIFN_D_RES_RSIZE) {
@@ -1353,12 +1353,12 @@ static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
 	idx = dma->dsti;
 	dma->dstr[idx].p = __cpu_to_le32(addr);
 	dma->dstr[idx].l = __cpu_to_le32(size |	HIFN_D_VALID |
-			HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
+			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST);
 
 	if (++idx == HIFN_D_DST_RSIZE) {
 		dma->dstr[idx].l = __cpu_to_le32(HIFN_D_VALID |
 				HIFN_D_JUMP | HIFN_D_MASKDONEIRQ |
-				HIFN_D_LAST);
+				HIFN_D_LAST | HIFN_D_NOINVALID);
 		idx = 0;
 	}
 	dma->dsti = idx;
-- 
1.5.2.5

