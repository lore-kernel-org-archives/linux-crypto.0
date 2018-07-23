From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] crypto: cavium: nitrox: Replace GFP_ATOMIC with GFP_KERNEL in crypto_alloc_context()
Date: Mon, 23 Jul 2018 16:14:26 +0800
Message-ID: <20180723081426.31780-1-baijiaju1990@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        kstewart@linuxfoundation.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, pombredanne@nexb.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

crypto_alloc_context() is only called by nitrox_skcipher_init(), which is
never called in atomic context.

crypto_alloc_context() calls dma_pool_alloc() with GFP_ATOMIC,
which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.
I also manually check the kernel code before reporting it.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/crypto/cavium/nitrox/nitrox_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_lib.c b/drivers/crypto/cavium/nitrox/nitrox_lib.c
index 4fdc921ba611..ebe267379ac9 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_lib.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_lib.c
@@ -148,7 +148,7 @@ void *crypto_alloc_context(struct nitrox_device *ndev)
 	void *vaddr;
 	dma_addr_t dma;
 
-	vaddr = dma_pool_alloc(ndev->ctx_pool, (GFP_ATOMIC | __GFP_ZERO), &dma);
+	vaddr = dma_pool_alloc(ndev->ctx_pool, (GFP_KERNEL | __GFP_ZERO), &dma);
 	if (!vaddr)
 		return NULL;
 
-- 
2.17.0
