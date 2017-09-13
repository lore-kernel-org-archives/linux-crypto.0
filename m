From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH] crypto: talitos - fix hashing
Date: Wed, 13 Sep 2017 12:44:57 +0200 (CEST)
Message-ID: <20170913104457.CA81D684D7@po15668-vm-win7.idsi0.si.c-s.fr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, Stephan Muller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
index f6f811a1bb..d47b3eb1f0 100644
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
