From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 2/2] drivers/crypto/bfin_crc.c: reposition free_irq to avoid access to invalid data
Date: Mon,  7 Jan 2013 11:00:16 +0100
Message-ID: <1357552816-6046-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1357552816-6046-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1357552816-6046-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The data referenced by an interrupt handler should not be freed before the
interrupt is ended.  The handler is bfin_crypto_crc_handler.  It may refer
to crc->regs, which is released by the iounmap.

Furthermore, the second argument to all calls to free_irq is incorrect.  It
should be the same as the last argument of request_irq, which is crc,
rather than crc->dev.

The semantic match that finds the first problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@fn exists@
expression list es;
expression a,b;
identifier f;
@@

if (...) {
  ... when any
  free_irq(a,b);
  ... when any
  f(es);
  ... when any
  return ...;
}

@@
expression list fn.es;
expression fn.a,fn.b;
identifier fn.f;
@@

*f(es);
... when any
*free_irq(a,b);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.  I have not observed the problems in practice; the code just
looks suspicious.

 drivers/crypto/bfin_crc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index a22f1a9..827913d 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -694,7 +694,7 @@ out_error_dma:
 		dma_free_coherent(&pdev->dev, PAGE_SIZE, crc->sg_cpu, crc->sg_dma);
 	free_dma(crc->dma_ch);
 out_error_irq:
-	free_irq(crc->irq, crc->dev);
+	free_irq(crc->irq, crc);
 out_error_unmap:
 	iounmap((void *)crc->regs);
 out_error_free_mem:
@@ -720,10 +720,10 @@ static int bfin_crypto_crc_remove(struct platform_device *pdev)
 
 	crypto_unregister_ahash(&algs);
 	tasklet_kill(&crc->done_task);
-	iounmap((void *)crc->regs);
 	free_dma(crc->dma_ch);
 	if (crc->irq > 0)
-		free_irq(crc->irq, crc->dev);
+		free_irq(crc->irq, crc);
+	iounmap((void *)crc->regs);
 	kfree(crc);
 
 	return 0;
