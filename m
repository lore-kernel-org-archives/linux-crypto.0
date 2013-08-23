From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 03/10] crypto: nx - fix limits to sg lists for AES-CBC
Date: Fri, 23 Aug 2013 17:01:07 -0300
Message-ID: <1377288074-18998-4-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch updates the nx-aes-cbc implementation to perform several
hyper calls if needed in order to always respect the length limits for
scatter/gather lists.

Two different limits are considered:

 - "ibm,max-sg-len": maximum number of bytes of each scatter/gather
   list.

 - "ibm,max-sync-cop":
    - The total number of bytes that a scatter/gather list can hold.
    - The maximum number of elements that a scatter/gather list can have.

Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-cbc.c | 50 +++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index f334a60..fa37df1 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -71,40 +71,50 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
 	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	unsigned long irq_flags;
+	unsigned int processed = 0, to_process;
+	u32 max_sg_len;
 	int rc;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	if (nbytes > nx_ctx->ap->databytelen) {
-		rc = -EINVAL;
-		goto out;
-	}
+	max_sg_len = min_t(u32, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
+			   nx_ctx->ap->sglen);
 
 	if (enc)
 		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
 	else
 		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
-	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes, 0,
-			       csbcpb->cpb.aes_cbc.iv);
-	if (rc)
-		goto out;
+	do {
+		to_process = min_t(u64, nbytes - processed,
+				   nx_ctx->ap->databytelen);
+		to_process = min_t(u64, to_process,
+				   NX_PAGE_SIZE * (max_sg_len - 1));
+		to_process = to_process & ~(AES_BLOCK_SIZE - 1);
 
-	if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
-		rc = -EINVAL;
-		goto out;
-	}
+		rc = nx_build_sg_lists(nx_ctx, desc, dst, src, to_process,
+				       processed, csbcpb->cpb.aes_cbc.iv);
+		if (rc)
+			goto out;
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (rc)
-		goto out;
+		if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
+			rc = -EINVAL;
+			goto out;
+		}
 
-	memcpy(desc->info, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
+				   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+		if (rc)
+			goto out;
 
-	atomic_inc(&(nx_ctx->stats->aes_ops));
-	atomic64_add(csbcpb->csb.processed_byte_count,
-		     &(nx_ctx->stats->aes_bytes));
+		memcpy(desc->info, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
+
+		atomic_inc(&(nx_ctx->stats->aes_ops));
+		atomic64_add(csbcpb->csb.processed_byte_count,
+			     &(nx_ctx->stats->aes_bytes));
+
+		processed += to_process;
+	} while (processed < nbytes);
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
-- 
1.7.12
