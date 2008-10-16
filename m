From: Vishnu Suresh <Vishnu@freescale.com>
Subject: [PATCH] crypto: talitos Preempt overflow interrupts off-by-one fix
Date: Thu, 16 Oct 2008 15:14:51 +0530
Message-ID: <1224150291-28500-1-git-send-email-Vishnu@freescale.com>
Cc: Lee.Nipper@freescale.com, Vishnu Suresh <Vishnu@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:63767 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbYJPJkM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Oct 2008 05:40:12 -0400
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by de01egw02.freescale.net (8.12.11/de01egw02) with ESMTP id m9G9e1Kw029610
	for <linux-crypto@vger.kernel.org>; Thu, 16 Oct 2008 02:40:05 -0700 (MST)
Received: from zin33exm21.fsl.freescale.net (zin33exm21.ap.freescale.net [10.232.192.8])
	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id m9G9dwqW027878
	for <linux-crypto@vger.kernel.org>; Thu, 16 Oct 2008 04:39:59 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In commit ec6644d6325b5a38525f1d5b20fd4bf7db05cf2a "crypto: talitos - Preempt
overflow interrupts", the test in atomic_inc_not_zero was interpreted by the
author to be applied after the increment operation (not before). This off-by-one
fix prevents overflow error interrupts from occurring when requests are frequent
and large enough to do so.

Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6836cb7..c2294f2 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1598,7 +1598,7 @@ static int talitos_probe(struct of_device *ofdev,
 		goto err_out;
 	}
 	for (i = 0; i < priv->num_channels; i++)
-		atomic_set(&priv->submit_count[i], -priv->chfifo_len);
+		atomic_set(&priv->submit_count[i], -(priv->chfifo_len - 1));
 
 	priv->head = kzalloc(sizeof(int) * priv->num_channels, GFP_KERNEL);
 	priv->tail = kzalloc(sizeof(int) * priv->num_channels, GFP_KERNEL);
-- 
1.5.4

