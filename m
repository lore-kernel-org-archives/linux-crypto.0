From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 5/7] crypto: talitos - sg_to_link_tbl() not used anymore,
 remove it
Date: Mon,  6 Jun 2016 13:20:42 +0200 (CEST)
Message-ID: <7db7c030af80d42c06a4900de317ca7afe6258c3.1464390096.git.christophe.leroy@c-s.fr>
References: <cover.1464390094.git.christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:33298 "EHLO pegase1.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbcFFNDk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jun 2016 09:03:40 -0400
In-Reply-To: <cover.1464390094.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4ff03c3..ff8cf39 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1111,14 +1111,6 @@ next:
 	return count;
 }
 
-static inline int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
-				 int cryptlen,
-				 struct talitos_ptr *link_tbl_ptr)
-{
-	return sg_to_link_tbl_offset(sg, sg_count, 0, cryptlen,
-				     link_tbl_ptr);
-}
-
 int talitos_sg_map(struct device *dev, struct scatterlist *src,
 		   unsigned int len, struct talitos_edesc *edesc,
 		   struct talitos_ptr *ptr,
-- 
2.1.0
