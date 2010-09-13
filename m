From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/3] crypto: talitos - fix checkpatch warning
Date: Mon, 13 Sep 2010 17:45:36 -0500
Message-ID: <20100913174536.6bde8468.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:43824 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0IMWpm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Sep 2010 18:45:42 -0400
Received: from mail132-tx2 (localhost.localdomain [127.0.0.1])	by
 mail132-tx2-R.bigfish.com (Postfix) with ESMTP id 7B0EA14706A4	for
 <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 22:45:39 +0000 (UTC)
Received: from TX2EHSMHS004.bigfish.com (unknown [10.9.14.245])	by
 mail132-tx2.bigfish.com (Postfix) with ESMTP id AA1901BD805E	for
 <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 22:45:38 +0000 (UTC)
Received: from az33smr02.freescale.net (az33smr02.freescale.net
 [10.64.34.200])	by de01egw01.freescale.net (8.14.3/8.14.3) with ESMTP id
 o8DMjbNJ025921	for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 15:45:37
 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net
 [10.64.32.10])	by az33smr02.freescale.net (8.13.1/8.13.0) with ESMTP id
 o8DMjhMN018079	for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 17:45:43
 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

WARNING: kfree(NULL) is safe this check is probably not required
+		if (priv->chan[i].fifo)
+			kfree(priv->chan[i].fifo);

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index d4c1fc2..f22666c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2333,8 +2333,7 @@ static int talitos_remove(struct platform_device *ofdev)
 		talitos_unregister_rng(dev);
 
 	for (i = 0; i < priv->num_channels; i++)
-		if (priv->chan[i].fifo)
-			kfree(priv->chan[i].fifo);
+		kfree(priv->chan[i].fifo);
 
 	kfree(priv->chan);
 
-- 
1.7.1
