From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 4/5] crypto: Use dma_pool_zalloc
Date: Fri, 29 Apr 2016 22:09:11 +0200
Message-ID: <1461960552-7429-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1461960552-7429-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461960552-7429-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dma_pool_zalloc combines dma_pool_alloc and memset 0.  The semantic patch
that makes this transformation is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression d,e;
statement S;
@@

        d =
-            dma_pool_alloc
+            dma_pool_zalloc
             (...);
        if (!d) S
-       memset(d, 0, sizeof(*d));
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---

 drivers/crypto/marvell/tdma.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 7642798..0ad8f1e 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -99,12 +99,11 @@ mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
 	struct mv_cesa_tdma_desc *new_tdma = NULL;
 	dma_addr_t dma_handle;
 
-	new_tdma = dma_pool_alloc(cesa_dev->dma->tdma_desc_pool, flags,
-				  &dma_handle);
+	new_tdma = dma_pool_zalloc(cesa_dev->dma->tdma_desc_pool, flags,
+				   &dma_handle);
 	if (!new_tdma)
 		return ERR_PTR(-ENOMEM);
 
-	memset(new_tdma, 0, sizeof(*new_tdma));
 	new_tdma->cur_dma = dma_handle;
 	if (chain->last) {
 		chain->last->next_dma = cpu_to_le32(dma_handle);
