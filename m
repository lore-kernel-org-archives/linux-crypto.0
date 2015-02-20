From: Martin Hicks <mort@bork.org>
Subject: [PATCH 3/5] crypto: talitos: Fix off-by-one and use all hardware slots
Date: Fri, 20 Feb 2015 11:21:14 -0500
Message-ID: <1424449276-5288-4-git-send-email-mort@bork.org>
References: <1424449276-5288-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:43232 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbbBTQVx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 11:21:53 -0500
Received: by iebtr6 with SMTP id tr6so8870641ieb.10
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 08:21:52 -0800 (PST)
In-Reply-To: <1424449276-5288-1-git-send-email-mort@bork.org>
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
