From: Martin Hicks <mort@bork.org>
Subject: [PATCH 1/2] crypto: talitos: Clean ups and comment fixes for ablkcipher commands
Date: Fri, 20 Feb 2015 12:00:09 -0500
Message-ID: <1424451610-5786-2-git-send-email-mort@bork.org>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:56749 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbbBTRAS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 12:00:18 -0500
Received: by mail-ig0-f179.google.com with SMTP id l13so4548871iga.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 09:00:17 -0800 (PST)
In-Reply-To: <1424451610-5786-1-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This just cleans up some of the initializers, and improves the comments
should any other ablkcipher modes be added in the future.  The header
words 1 and 5 have more possibilities than just passing an IV.  These
are pointers to the Cipher Context in/out registers.

Signed-off-by: Martin Hicks <mort@bork.org>
---
 drivers/crypto/talitos.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 226654c..6b2a19a 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1377,11 +1377,9 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	int sg_count, ret;
 
 	/* first DWORD empty */
-	desc->ptr[0].len = 0;
-	to_talitos_ptr(&desc->ptr[0], 0);
-	desc->ptr[0].j_extent = 0;
+	desc->ptr[0] = zero_entry;
 
-	/* cipher iv */
+	/* cipher context */
 	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
 	desc->ptr[1].len = cpu_to_be16(ivsize);
 	desc->ptr[1].j_extent = 0;
@@ -1444,14 +1442,12 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
 	}
 
-	/* iv out */
+	/* cipher context out */
 	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv, 0,
 			       DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
-	desc->ptr[6].len = 0;
-	to_talitos_ptr(&desc->ptr[6], 0);
-	desc->ptr[6].j_extent = 0;
+	desc->ptr[6] = zero_entry;
 
 	edesc->req.callback = callback;
 	edesc->req.context = areq;
-- 
1.7.10.4
