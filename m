From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/8] crypto: talitos - ensure request ordering within a single tfm
Date: Fri, 8 Jul 2011 17:57:22 -0500
Message-ID: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:4383 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1GHW6I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2011 18:58:08 -0400
Received: from mail108-va3 (localhost.localdomain [127.0.0.1])	by
 mail108-va3-R.bigfish.com (Postfix) with ESMTP id 1C33F1030425	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:08 +0000 (UTC)
Received: from VA3EHSMHS010.bigfish.com (unknown [10.7.14.240])	by
 mail108-va3.bigfish.com (Postfix) with ESMTP id B706915004C	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:07 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Assign single target channel per tfm in talitos_cra_init instead of
performing channel scheduling dynamically during the encryption request.
This changes the talitos_submit interface to accept a new channel
number argument.  Without this, rapid bursts of misc. sized requests
could make it possible for IPsec packets to be encrypted out-of-order,
which would result in packet drops due to sequence numbers falling
outside the anti-reply window on a peer gateway.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 854e263..b8ca583 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1,7 +1,7 @@
 /*
  * talitos - Freescale Integrated Security Engine (SEC) device driver
  *
- * Copyright (c) 2008-2010 Freescale Semiconductor, Inc.
+ * Copyright (c) 2008-2011 Freescale Semiconductor, Inc.
  *
  * Scatterlist Crypto API glue code copied from files with the following:
  * Copyright (c) 2006-2007 Herbert Xu <herbert@gondor.apana.org.au>
@@ -282,6 +282,7 @@ static int init_device(struct device *dev)
 /**
  * talitos_submit - submits a descriptor to the device for processing
  * @dev:	the SEC device to be used
+ * @ch:		the SEC device channel to be used
  * @desc:	the descriptor to be processed by the device
  * @callback:	whom to call when processing is complete
  * @context:	a handle for use by caller (optional)
@@ -290,7 +291,7 @@ static int init_device(struct device *dev)
  * callback must check err and feedback in descriptor header
  * for device processing status.
  */
-static int talitos_submit(struct device *dev, struct talitos_desc *desc,
+static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 			  void (*callback)(struct device *dev,
 					   struct talitos_desc *desc,
 					   void *context, int error),
@@ -298,15 +299,12 @@ static int talitos_submit(struct device *dev, struct talitos_desc *desc,
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request;
-	unsigned long flags, ch;
+	unsigned long flags;
 	int head;
 
 	/* select done notification */
 	desc->hdr |= DESC_HDR_DONE_NOTIFY;
 
-	/* emulate SEC's round-robin channel fifo polling scheme */
-	ch = atomic_inc_return(&priv->last_chan) & (priv->num_channels - 1);
-
 	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
 
 	if (!atomic_inc_not_zero(&priv->chan[ch].submit_count)) {
@@ -706,6 +704,7 @@ static void talitos_unregister_rng(struct device *dev)
 
 struct talitos_ctx {
 	struct device *dev;
+	int ch;
 	__be32 desc_hdr_template;
 	u8 key[TALITOS_MAX_KEY_SIZE];
 	u8 iv[TALITOS_MAX_IV_LENGTH];
@@ -1117,7 +1116,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv, 0,
 			       DMA_FROM_DEVICE);
 
-	ret = talitos_submit(dev, desc, callback, areq);
+	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
 		ipsec_esp_unmap(dev, edesc, areq);
 		kfree(edesc);
@@ -1524,7 +1523,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	to_talitos_ptr(&desc->ptr[6], 0);
 	desc->ptr[6].j_extent = 0;
 
-	ret = talitos_submit(dev, desc, callback, areq);
+	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_unmap(dev, edesc, areq);
 		kfree(edesc);
@@ -1703,7 +1702,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* last DWORD empty */
 	desc->ptr[6] = zero_entry;
 
-	ret = talitos_submit(dev, desc, callback, areq);
+	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_hash_unmap(dev, edesc, areq);
 		kfree(edesc);
@@ -2244,6 +2243,7 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	struct crypto_alg *alg = tfm->__crt_alg;
 	struct talitos_crypto_alg *talitos_alg;
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct talitos_private *priv;
 
 	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AHASH)
 		talitos_alg = container_of(__crypto_ahash_alg(alg),
@@ -2256,6 +2256,11 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	/* update context with ptr to dev */
 	ctx->dev = talitos_alg->dev;
 
+	/* assign SEC channel to tfm in round-robin fashion */
+	priv = dev_get_drvdata(ctx->dev);
+	ctx->ch = atomic_inc_return(&priv->last_chan) &
+		  (priv->num_channels - 1);
+
 	/* copy descriptor header template value */
 	ctx->desc_hdr_template = talitos_alg->algt.desc_hdr_template;
 
-- 
1.7.6
