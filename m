From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 08/13] crypto: crypto4xx: fix various warnings
Date: Wed,  4 Oct 2017 01:00:12 +0200
Message-ID: <65233af33b900a33ca0796cf92a8ec7107b9bbae.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:56492 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXAZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 19:00:25 -0400
Received: by mail-wm0-f66.google.com with SMTP id l68so5992116wmd.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Oct 2017 16:00:24 -0700 (PDT)
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto4xx_core.c:179:6: warning: symbol 'crypto4xx_free_state_record'
	was not declared. Should it be static?
crypto4xx_core.c:331:5: warning: symbol 'crypto4xx_get_n_gd'
	was not declared. Should it be static?
crypto4xx_core.c:652:6: warning: symbol 'crypto4xx_return_pd'
	was not declared. Should it be static?

crypto4xx_return_pd() is not used by anything. Therefore it is removed.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 254dc61c91a6..1752ea2125db 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -176,7 +176,7 @@ u32 crypto4xx_alloc_state_record(struct crypto4xx_ctx *ctx)
 	return 0;
 }
 
-void crypto4xx_free_state_record(struct crypto4xx_ctx *ctx)
+static void crypto4xx_free_state_record(struct crypto4xx_ctx *ctx)
 {
 	if (ctx->state_record != NULL)
 		dma_free_coherent(ctx->dev->core_dev->device,
@@ -322,10 +322,11 @@ static inline void crypto4xx_destroy_gdr(struct crypto4xx_device *dev)
  * when this function is called.
  * preemption or interrupt must be disabled
  */
-u32 crypto4xx_get_n_gd(struct crypto4xx_device *dev, int n)
+static u32 crypto4xx_get_n_gd(struct crypto4xx_device *dev, int n)
 {
 	u32 retval;
 	u32 tmp;
+
 	if (n >= PPC4XX_NUM_GD)
 		return ERING_WAS_FULL;
 
@@ -616,17 +617,6 @@ static void crypto4xx_stop_all(struct crypto4xx_core_device *core_dev)
 	kfree(core_dev);
 }
 
-void crypto4xx_return_pd(struct crypto4xx_device *dev,
-			 u32 pd_entry, struct ce_pd *pd,
-			 struct pd_uinfo *pd_uinfo)
-{
-	/* irq should be already disabled */
-	dev->pdr_head = pd_entry;
-	pd->pd_ctl.w = 0;
-	pd->pd_ctl_len.w = 0;
-	pd_uinfo->state = PD_ENTRY_FREE;
-}
-
 static u32 get_next_gd(u32 current)
 {
 	if (current != PPC4XX_LAST_GD)
-- 
2.14.2
