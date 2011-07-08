From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/8] crypto: talitos - don't set done notification in hot path
Date: Fri, 8 Jul 2011 17:57:23 -0500
Message-ID: <1310165849-22177-2-git-send-email-kim.phillips@freescale.com>
References: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:54279
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551Ab1GHW6K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2011 18:58:10 -0400
Received: from mail64-am1 (localhost.localdomain [127.0.0.1])	by
 mail64-am1-R.bigfish.com (Postfix) with ESMTP id C91B910C8168	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:08 +0000 (UTC)
Received: from AM1EHSMHS017.bigfish.com (unknown [10.3.201.247])	by
 mail64-am1.bigfish.com (Postfix) with ESMTP id A03B71AF804E	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:08 +0000 (UTC)
In-Reply-To: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IRQ done notification is always set.  Remove its explicit
assignment from the hot path by including it in the
descriptor header template assignment in talitos_cra_init.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b8ca583..bd9e2ca 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -302,9 +302,6 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	unsigned long flags;
 	int head;
 
-	/* select done notification */
-	desc->hdr |= DESC_HDR_DONE_NOTIFY;
-
 	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
 
 	if (!atomic_inc_not_zero(&priv->chan[ch].submit_count)) {
@@ -2264,6 +2261,9 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	/* copy descriptor header template value */
 	ctx->desc_hdr_template = talitos_alg->algt.desc_hdr_template;
 
+	/* select done notification */
+	ctx->desc_hdr_template |= DESC_HDR_DONE_NOTIFY;
+
 	return 0;
 }
 
-- 
1.7.6
