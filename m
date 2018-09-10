From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH] crypto: cavium/nitrox - use dma_pool_zalloc()
Date: Mon, 10 Sep 2018 13:54:52 +0530
Message-ID: <20180910082452.19842-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgadam@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

use dma_pool_zalloc() instead of dma_pool_alloc with __GFP_ZERO flag.
crypto dma pool renamed to "nitrox-context".

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_lib.c b/drivers/crypto/cavium/nitrox/nitrox_lib.c
index 4d31df07777f..7a721c7c12a4 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_lib.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_lib.c
@@ -122,7 +122,7 @@ static int create_crypto_dma_pool(struct nitrox_device *ndev)
 
 	/* Crypto context pool, 16 byte aligned */
 	size = CRYPTO_CTX_SIZE + sizeof(struct ctx_hdr);
-	ndev->ctx_pool = dma_pool_create("crypto-context",
+	ndev->ctx_pool = dma_pool_create("nitrox-context",
 					 DEV(ndev), size, 16, 0);
 	if (!ndev->ctx_pool)
 		return -ENOMEM;
@@ -149,7 +149,7 @@ void *crypto_alloc_context(struct nitrox_device *ndev)
 	void *vaddr;
 	dma_addr_t dma;
 
-	vaddr = dma_pool_alloc(ndev->ctx_pool, (GFP_KERNEL | __GFP_ZERO), &dma);
+	vaddr = dma_pool_zalloc(ndev->ctx_pool, GFP_KERNEL, &dma);
 	if (!vaddr)
 		return NULL;
 
-- 
2.17.1
