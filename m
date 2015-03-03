From: Martin Hicks <mort@bork.org>
Subject: [PATCH v2 1/5] crypto: talitos: Simplify per-channel initialization
Date: Tue,  3 Mar 2015 08:21:33 -0500
Message-ID: <1425388897-5434-2-git-send-email-mort@bork.org>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35136 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbbCCNVu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 08:21:50 -0500
Received: by igqa13 with SMTP id a13so27204850igq.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2015 05:21:49 -0800 (PST)
In-Reply-To: <1425388897-5434-1-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There were multiple loops in a row, for each separate step of the
initialization of the channels.  Simplify to a single loop.

Signed-off-by: Martin Hicks <mort@bork.org>
---
 drivers/crypto/talitos.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 067ec21..c49d977 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2706,20 +2706,16 @@ static int talitos_probe(struct platform_device *ofdev)
 		goto err_out;
 	}
 
+	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
+
 	for (i = 0; i < priv->num_channels; i++) {
 		priv->chan[i].reg = priv->reg + TALITOS_CH_STRIDE * (i + 1);
 		if (!priv->irq[1] || !(i & 1))
 			priv->chan[i].reg += TALITOS_CH_BASE_OFFSET;
-	}
 
-	for (i = 0; i < priv->num_channels; i++) {
 		spin_lock_init(&priv->chan[i].head_lock);
 		spin_lock_init(&priv->chan[i].tail_lock);
-	}
 
-	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
-
-	for (i = 0; i < priv->num_channels; i++) {
 		priv->chan[i].fifo = kzalloc(sizeof(struct talitos_request) *
 					     priv->fifo_len, GFP_KERNEL);
 		if (!priv->chan[i].fifo) {
@@ -2727,11 +2723,10 @@ static int talitos_probe(struct platform_device *ofdev)
 			err = -ENOMEM;
 			goto err_out;
 		}
-	}
 
-	for (i = 0; i < priv->num_channels; i++)
 		atomic_set(&priv->chan[i].submit_count,
 			   -(priv->chfifo_len - 1));
+	}
 
 	dma_set_mask(dev, DMA_BIT_MASK(36));
 
-- 
1.7.10.4
