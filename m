From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 4/6] crypto: talitos - sg_to_link_tbl() not used anymore,
 remove it
Date: Fri, 27 May 2016 11:32:41 +0200 (CEST)
Message-ID: <d25b91a5c4c677716e40645acd25d72eb8618d2d.1464330501.git.christophe.leroy@c-s.fr>
References: <cover.1464330501.git.christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1464330501.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c17e6c9..fcdf83b 100644
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
