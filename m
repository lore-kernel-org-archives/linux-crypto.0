From: Martin Hicks <mort@bork.org>
Subject: [PATCH v2 3/5] crypto: talitos: Fix off-by-one and use all hardware slots
Date: Tue,  3 Mar 2015 08:21:35 -0500
Message-ID: <1425388897-5434-4-git-send-email-mort@bork.org>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:40574 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbbCCNVw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 08:21:52 -0500
Received: by igal13 with SMTP id l13so27201472iga.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2015 05:21:51 -0800 (PST)
In-Reply-To: <1425388897-5434-1-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The submission count was off by one.

Signed-off-by: Martin Hicks <mort@bork.org>
---
 drivers/crypto/talitos.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 89cf4d5..7709805 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2722,8 +2722,7 @@ static int talitos_probe(struct platform_device *ofdev)
 			goto err_out;
 		}
 
-		atomic_set(&priv->chan[i].submit_count,
-			   -(priv->chfifo_len - 1));
+		atomic_set(&priv->chan[i].submit_count, -priv->chfifo_len);
 	}
 
 	dma_set_mask(dev, DMA_BIT_MASK(36));
-- 
1.7.10.4
