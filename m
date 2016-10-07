From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: crypto4xx - Fix size used in dma_free_coherent()
Date: Fri,  7 Oct 2016 22:36:20 +0200
Message-ID: <1475872580-14643-1-git-send-email-christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The size used in 'dma_free_coherent()' looks un-initialized here.
ctx->sa_len is set a few lines below and is apparently not set by the
caller.
So use 'size' as in the corresponding 'dma_alloc_coherent()' a few lines
above.

This has been spotted with coccinelle, using the following script:
////////////////////
@r@
expression x0, x1, y0, y1, z0, z1, t0, t1, ret;
@@

*   ret = dma_alloc_coherent(x0, y0, z0, t0);
    ...
*   dma_free_coherent(x1, y1, ret, t1);


@script:python@
y0 << r.y0;
y1 << r.y1;

@@
if y1.find(y0) == -1:
 print "WARNING: sizes look different:  '%s'   vs   '%s'" % (y0, y1)
////////////////////

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/amcc/crypto4xx_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index dae1e39139e9..d10b4ae5e0da 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -135,8 +135,7 @@ int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size)
 	ctx->sa_out = dma_alloc_coherent(ctx->dev->core_dev->device, size * 4,
 					 &ctx->sa_out_dma_addr, GFP_ATOMIC);
 	if (ctx->sa_out == NULL) {
-		dma_free_coherent(ctx->dev->core_dev->device,
-				  ctx->sa_len * 4,
+		dma_free_coherent(ctx->dev->core_dev->device, size * 4,
 				  ctx->sa_in, ctx->sa_in_dma_addr);
 		return -ENOMEM;
 	}
-- 
2.7.4

