From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 05/13] crypto: crypto4xx: add backlog queue support
Date: Wed,  4 Oct 2017 01:00:09 +0200
Message-ID: <85525066b4f6058953d745c59588ab9f450a3703.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37500 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdJCXAY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 19:00:24 -0400
Received: by mail-wr0-f196.google.com with SMTP id v38so3900802wrc.4
        for <linux-crypto@vger.kernel.org>; Tue, 03 Oct 2017 16:00:23 -0700 (PDT)
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Previously, If the crypto4xx driver used all available
security contexts, it would simply refuse new requests
with -EAGAIN. CRYPTO_TFM_REQ_MAY_BACKLOG was ignored.

in case of dm-crypt.c's crypt_convert() function this was
causing the following errors to manifest, if the system was
pushed hard enough:

| EXT4-fs warning (dm-1): ext4_end_bio:314: I/O error -5 writing to ino ..
| EXT4-fs warning (dm-1): ext4_end_bio:314: I/O error -5 writing to ino ..
| EXT4-fs warning (dm-1): ext4_end_bio:314: I/O error -5 writing to ino ..
| JBD2: Detected IO errors while flushing file data on dm-1-8
| Aborting journal on device dm-1-8.
| EXT4-fs error : ext4_journal_check_start:56: Detected aborted journal
| EXT4-fs (dm-1): Remounting filesystem read-only
| EXT4-fs : ext4_writepages: jbd2_start: 2048 pages, inode 498...; err -30

(This did cause corruptions due to failed writes)

To fix this mess, the crypto4xx driver needs to notifiy the
user to slow down. This can be achieved by returning -EBUSY
on requests, once the crypto hardware was falling behind.

Note: -EBUSY has two different meanings. Setting the flag
CRYPTO_TFM_REQ_MAY_BACKLOG implies that the request was
successfully queued, by the crypto driver. To achieve this
requirement, the implementation introduces a threshold check and
adds logic to the completion routines in much the same way as
AMD's Cryptographic Coprocessor (CCP) driver do.

Note2: Tests showed that dm-crypt starved ipsec traffic.
Under load, ipsec links dropped to 0 Kbits/s. This is because
dm-crypt's callback would instantly queue the next request.
In order to not starve ipsec, the driver reserves a small
portion of the available crypto contexts for this purpose.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 47 ++++++++++++++++++++++++++++++------
 drivers/crypto/amcc/crypto4xx_core.h |  3 ++-
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index cb45365166ae..abdf1db9b0eb 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -39,6 +39,7 @@
 #include <crypto/ctr.h>
 #include <crypto/sha.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/internal/skcipher.h>
 #include "crypto4xx_reg_def.h"
 #include "crypto4xx_core.h"
 #include "crypto4xx_sa.h"
@@ -573,8 +574,10 @@ static u32 crypto4xx_ablkcipher_done(struct crypto4xx_device *dev,
 				    dst->offset, dst->length, DMA_FROM_DEVICE);
 	}
 	crypto4xx_ret_sg_desc(dev, pd_uinfo);
-	if (ablk_req->base.complete != NULL)
-		ablk_req->base.complete(&ablk_req->base, 0);
+
+	if (pd_uinfo->state & PD_ENTRY_BUSY)
+		ablkcipher_request_complete(ablk_req, -EINPROGRESS);
+	ablkcipher_request_complete(ablk_req, 0);
 
 	return 0;
 }
@@ -591,9 +594,10 @@ static u32 crypto4xx_ahash_done(struct crypto4xx_device *dev,
 	crypto4xx_copy_digest_to_dst(pd_uinfo,
 				     crypto_tfm_ctx(ahash_req->base.tfm));
 	crypto4xx_ret_sg_desc(dev, pd_uinfo);
-	/* call user provided callback function x */
-	if (ahash_req->base.complete != NULL)
-		ahash_req->base.complete(&ahash_req->base, 0);
+
+	if (pd_uinfo->state & PD_ENTRY_BUSY)
+		ahash_request_complete(ahash_req, -EINPROGRESS);
+	ahash_request_complete(ahash_req, 0);
 
 	return 0;
 }
@@ -704,6 +708,7 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 	struct pd_uinfo *pd_uinfo = NULL;
 	unsigned int nbytes = datalen, idx;
 	u32 gd_idx = 0;
+	bool is_busy;
 
 	/* figure how many gd is needed */
 	num_gd = sg_nents_for_len(src, datalen);
@@ -734,6 +739,31 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 	 * already got must be return the original place.
 	 */
 	spin_lock_irqsave(&dev->core_dev->lock, flags);
+	/*
+	 * Let the caller know to slow down, once more than 13/16ths = 81%
+	 * of the available data contexts are being used simultaneously.
+	 *
+	 * With PPC4XX_NUM_PD = 256, this will leave a "backlog queue" for
+	 * 31 more contexts. Before new requests have to be rejected.
+	 */
+	if (req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		is_busy = ((dev->pdr_head - dev->pdr_tail) % PPC4XX_NUM_PD) >=
+			((PPC4XX_NUM_PD * 13) / 16);
+	} else {
+		/*
+		 * To fix contention issues between ipsec (no blacklog) and
+		 * dm-crypto (backlog) reserve 32 entries for "no backlog"
+		 * data contexts.
+		 */
+		is_busy = ((dev->pdr_head - dev->pdr_tail) % PPC4XX_NUM_PD) >=
+			((PPC4XX_NUM_PD * 15) / 16);
+
+		if (is_busy) {
+			spin_unlock_irqrestore(&dev->core_dev->lock, flags);
+			return -EBUSY;
+		}
+	}
+
 	if (num_gd) {
 		fst_gd = crypto4xx_get_n_gd(dev, num_gd);
 		if (fst_gd == ERING_WAS_FULL) {
@@ -888,11 +918,12 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 	sa->sa_command_1.bf.hash_crypto_offset = 0;
 	pd->pd_ctl.w = ctx->pd_ctl;
 	pd->pd_ctl_len.w = 0x00400000 | datalen;
-	pd_uinfo->state = PD_ENTRY_INUSE;
+	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
+
 	wmb();
 	/* write any value to push engine to read a pd */
 	writel(1, dev->ce_base + CRYPTO4XX_INT_DESCR_RD);
-	return -EINPROGRESS;
+	return is_busy ? -EBUSY : -EINPROGRESS;
 }
 
 /**
@@ -997,7 +1028,7 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 		tail = core_dev->dev->pdr_tail;
 		pd_uinfo = &core_dev->dev->pdr_uinfo[tail];
 		pd = &core_dev->dev->pdr[tail];
-		if ((pd_uinfo->state == PD_ENTRY_INUSE) &&
+		if ((pd_uinfo->state & PD_ENTRY_INUSE) &&
 				   pd->pd_ctl.bf.pe_done &&
 				   !pd->pd_ctl.bf.host_ready) {
 			pd->pd_ctl.bf.pe_done = 0;
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 27e439c1f5bf..dbe29043e0c5 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -44,7 +44,8 @@
 #define PPC4XX_LAST_SD				(PPC4XX_NUM_SD - 1)
 #define PPC4XX_SD_BUFFER_SIZE			2048
 
-#define PD_ENTRY_INUSE				1
+#define PD_ENTRY_BUSY				BIT(1)
+#define PD_ENTRY_INUSE				BIT(0)
 #define PD_ENTRY_FREE				0
 #define ERING_WAS_FULL				0xffffffff
 
-- 
2.14.2
