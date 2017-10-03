From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 09/13] crypto: crypto4xx: fix stalls under heavy load
Date: Wed,  4 Oct 2017 01:00:13 +0200
Message-ID: <a6614abc7e42b025ee6050a10a1110961455c2fa.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38632 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdJCXAY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 19:00:24 -0400
Received: by mail-wr0-f195.google.com with SMTP id f12so1018036wra.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Oct 2017 16:00:24 -0700 (PDT)
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the crypto4xx device is continuously loaded by dm-crypt
and ipsec work, it will start to work intermittent after a
few (between 20-30) seconds, hurting throughput and latency.

This patch contains various stability improvements in order
to fix this issue. So far, the hardware has survived more
than a day without suffering any stalls under the continuous
load.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c    | 33 ++++++++++++++++++---------------
 drivers/crypto/amcc/crypto4xx_reg_def.h |  3 +++
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 1752ea2125db..de9044201a23 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -280,17 +280,20 @@ static u32 crypto4xx_get_pd_from_pdr_nolock(struct crypto4xx_device *dev)
 static u32 crypto4xx_put_pd_to_pdr(struct crypto4xx_device *dev, u32 idx)
 {
 	struct pd_uinfo *pd_uinfo = &dev->pdr_uinfo[idx];
+	u32 tail;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->core_dev->lock, flags);
+	pd_uinfo->state = PD_ENTRY_FREE;
+
 	if (dev->pdr_tail != PPC4XX_LAST_PD)
 		dev->pdr_tail++;
 	else
 		dev->pdr_tail = 0;
-	pd_uinfo->state = PD_ENTRY_FREE;
+	tail = dev->pdr_tail;
 	spin_unlock_irqrestore(&dev->core_dev->lock, flags);
 
-	return 0;
+	return tail;
 }
 
 /**
@@ -854,16 +857,16 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		}
 	}
 
-	sa->sa_command_1.bf.hash_crypto_offset = 0;
-	pd->pd_ctl.w = 0;
-	pd->pd_ctl.bf.hash_final =
-		(crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH);
-	pd->pd_ctl.bf.host_ready = 1;
+	pd->pd_ctl.w = PD_CTL_HOST_READY |
+		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) |
+		 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
+			PD_CTL_HASH_FINAL : 0);
 	pd->pd_ctl_len.w = 0x00400000 | datalen;
 	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
 
 	wmb();
 	/* write any value to push engine to read a pd */
+	writel(0, dev->ce_base + CRYPTO4XX_INT_DESCR_RD);
 	writel(1, dev->ce_base + CRYPTO4XX_INT_DESCR_RD);
 	return is_busy ? -EBUSY : -EINPROGRESS;
 }
@@ -964,23 +967,23 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
 	struct pd_uinfo *pd_uinfo;
 	struct ce_pd *pd;
-	u32 tail;
+	u32 tail = core_dev->dev->pdr_tail;
+	u32 head = core_dev->dev->pdr_head;
 
-	while (core_dev->dev->pdr_head != core_dev->dev->pdr_tail) {
-		tail = core_dev->dev->pdr_tail;
+	do {
 		pd_uinfo = &core_dev->dev->pdr_uinfo[tail];
 		pd = &core_dev->dev->pdr[tail];
 		if ((pd_uinfo->state & PD_ENTRY_INUSE) &&
-				   pd->pd_ctl.bf.pe_done &&
-				   !pd->pd_ctl.bf.host_ready) {
-			pd->pd_ctl.bf.pe_done = 0;
+		     ((READ_ONCE(pd->pd_ctl.w) &
+		       (PD_CTL_PE_DONE | PD_CTL_HOST_READY)) ==
+		       PD_CTL_PE_DONE)) {
 			crypto4xx_pd_done(core_dev->dev, tail);
-			crypto4xx_put_pd_to_pdr(core_dev->dev, tail);
+			tail = crypto4xx_put_pd_to_pdr(core_dev->dev, tail);
 		} else {
 			/* if tail not done, break */
 			break;
 		}
-	}
+	} while (head != tail);
 }
 
 /**
diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
index 279b8725559f..0a22ec5d1a96 100644
--- a/drivers/crypto/amcc/crypto4xx_reg_def.h
+++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
@@ -261,6 +261,9 @@ union ce_pd_ctl {
 	} bf;
 	u32 w;
 } __attribute__((packed));
+#define PD_CTL_HASH_FINAL	BIT(4)
+#define PD_CTL_PE_DONE		BIT(1)
+#define PD_CTL_HOST_READY	BIT(0)
 
 union ce_pd_ctl_len {
 	struct {
-- 
2.14.2
