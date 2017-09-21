From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 2/6] crypto: talitos - fix hashing
Date: Thu, 21 Sep 2017 09:19:49 +0200 (CEST)
Message-ID: <af19f4aa51d30b352b08acd416d13a917529ddd2.1575825623.git.christophe.leroy@c-s.fr>
References: <cover.1575825623.git.christophe.leroy@c-s.fr>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:63718 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751528AbdIUHTu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 03:19:50 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 3xySfd070bz9ttBX
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:37 +0200 (CEST)
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id tL35aYm-9Xgy for <linux-crypto@vger.kernel.org>;
        Thu, 21 Sep 2017 09:19:36 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 3xySfc6pJpz9ttBK
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:36 +0200 (CEST)
In-Reply-To: <cover.1575825623.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

md5sum on some files gives wrong result

Exemple:

With the md5sum from libkcapi:
c15115c05bad51113f81bdaee735dd09  test

With the original md5sum:
bbdf41d80ba7e8b2b7be3a0772be76cb  test

This patch fixes this issue

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 5cc160078286..49f1561fa694 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1769,7 +1769,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
-		sg_copy_to_buffer(areq->src, sg_count, edesc->buf, length);
+		sg_copy_to_buffer(req_ctx->psrc, sg_count, edesc->buf, length);
 	else
 		sg_count = dma_map_sg(dev, req_ctx->psrc, sg_count,
 				      DMA_TO_DEVICE);
-- 
2.13.3
