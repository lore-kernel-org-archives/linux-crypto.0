From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 1/9] Moving NX-AES-CBC to be processed logic
Date: Tue, 28 Oct 2014 15:42:46 -0200
Message-ID: <20141028174243.GA16436@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The previous limits were estimated locally in a single step
basead on bound values, however it was not correct since
when given certain scatterlist the function nx_build_sg_lists
was consuming more sg entries than allocated causing a
memory corruption and crashes.

This patch removes the old logic and replaces it into nx_sg_build_lists 
in order to build a correct nx_sg list using the correct sg_max limit 
and bounds.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-cbc.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index cc00b52..a066cc3 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -72,27 +72,19 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	unsigned long irq_flags;
 	unsigned int processed = 0, to_process;
-	u32 max_sg_len;
 	int rc;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
-			   nx_ctx->ap->sglen);
-
 	if (enc)
 		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
 	else
 		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
 	do {
-		to_process = min_t(u64, nbytes - processed,
-				   nx_ctx->ap->databytelen);
-		to_process = min_t(u64, to_process,
-				   NX_PAGE_SIZE * (max_sg_len - 1));
-		to_process = to_process & ~(AES_BLOCK_SIZE - 1);
+		to_process = nbytes - processed;
 
-		rc = nx_build_sg_lists(nx_ctx, desc, dst, src, to_process,
+		rc = nx_build_sg_lists(nx_ctx, desc, dst, src, &to_process,
 				       processed, csbcpb->cpb.aes_cbc.iv);
 		if (rc)
 			goto out;
-- 
1.7.1
