Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15103AEF5F
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959389; cv=none; b=T7y45pS02jGty+1JJNotU6RsZooQjJyLyeL/85NG2DpZyBmTgDcAsSz0zOb5lNfp07TXVa3PVZtrKUQAZu88gCC5HzTTpHC4hhaZu3jW9UsIexP0OwcB+TUln5pKP2IP/g2K8tW5Sach45pNfBvoSJob8tUj8HkMlhEgVkG6w3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959389; c=relaxed/simple;
	bh=+p2GgZeogZTfewEXHIK7LPOkpg/e4FldtqmLtyqa18A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ay+v+OZthYwHT0V+c/i7conTsn1FResKYwEgIVOa7tgSiNKVjYVULlHG7KA96RCrbngDH/lXRMFMxdvt+uIsZZKdAlbNs84//A9+wnQOpE+Zox5zi40SSrvf6ai7fov6kmV1bi5QeHPNHc6ZjHrell7FoPYn8STdnFCSc9SWbE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=trr/vtxn; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="trr/vtxn"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id D1B06C62448
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:45 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id AB18960495;
	Thu, 28 May 2026 09:09:45 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 415CA10888CB3;
	Thu, 28 May 2026 11:09:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959384; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Bli1OtLsg/EBK3jU4yfqXHO/RH6s09XQRTVVFHo48Js=;
	b=trr/vtxnGqyFzvaMx7L96W+mmdHkINLN6wwg2IgeK6QDdp+faTc7BoiC1cUER/mvdEQc3s
	vlabSCvurMNTqZrni6PaLrL35zWZZnTTukF9oYSHX9eO8yVGZ7LvbRDPS8yvc7qOode0DV
	U255m6ktUZh/HG9bKoecLgSxxi0vGy/0MXiiJ3rtZyE2sA1iHB0PV7S1KdM9ewvtl0cUPe
	v2AycMbugky0gI1CExPh+LJh7HM31/SDy8xrAnO1IN+ijOs0/YwgOHmXmIdbtlKx9Gs143
	Ubgp81A9bKSQ8WVNLvYz4IKLfMAjchQYnZxzLU/FsvDRsZ5BtRuD8MnbOeAdBw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:33 +0200
Subject: [PATCH 20/29] crypto: talitos - Replace SEC1/SEC2 conditionals
 with ops dispatch
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-20-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=6529;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=+p2GgZeogZTfewEXHIK7LPOkpg/e4FldtqmLtyqa18A=;
 b=fe7ZEMusNxWOuPHdDFjhXWQlZNN/GaFW7JCZm93voPO0tTeKndtGwZfKHks67kvmBVwJCYhA/
 bOu7JY5oX5aCQOlsUEN6pwiptp+jam4VccUZu3nBtCRH7ti1qYsQQr6
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Replace the if/else is_sec1 dispatches in callers with indirect calls
through priv->ops. Add static const sec1_ops and sec2_ops structs
populated with the SEC1 and SEC2 function variants, and set priv->ops
at probe time based on the detected hardware.


Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.c | 88 +++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index b6793d97735e..c4a311a8e7fd 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -258,7 +258,6 @@ static int init_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int ch, err;
-	bool is_sec1 = has_ftr_sec1(priv);
 
 	/*
 	 * Master reset
@@ -266,35 +265,23 @@ static int init_device(struct device *dev)
 	 * are not fully cleared by writing the MCR:SWR bit,
 	 * set bit twice to completely reset
 	 */
-	if (is_sec1)
-		err = sec1_reset_device(dev);
-	else
-		err = sec2_reset_device(dev);
+	err = priv->ops->reset_device(dev);
 
 	if (err)
 		return err;
 
-	if (is_sec1)
-		err = sec1_reset_device(dev);
-	else
-		err = sec2_reset_device(dev);
+	err = priv->ops->reset_device(dev);
 	if (err)
 		return err;
 
 	/* reset channels */
 	for (ch = 0; ch < priv->num_channels; ch++) {
-		if (is_sec1)
-			err = sec1_reset_channel(dev, ch);
-		else
-			err = sec2_reset_channel(dev, ch);
+		err = priv->ops->reset_channel(dev, ch);
 		if (err)
 			return err;
 	}
 
-	if (is_sec1)
-		sec1_configure_device(dev);
-	else
-		sec2_configure_device(dev);
+	priv->ops->configure_device(dev);
 
 	return 0;
 }
@@ -363,7 +350,6 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	struct talitos_request *request;
 	unsigned long flags;
 	int head;
-	bool is_sec1 = has_ftr_sec1(priv);
 
 	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
 
@@ -377,10 +363,8 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	request = &priv->chan[ch].fifo[head];
 
 	/* map descriptor and save caller data */
-	if (is_sec1)
-		sec1_dma_map_request(dev, request, desc);
-	else
-		sec2_dma_map_request(dev, request, desc);
+	priv->ops->dma_map_request(dev, request, desc);
+
 	request->callback = callback;
 	request->context = context;
 
@@ -461,7 +445,6 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 	struct talitos_request *request, saved_req;
 	unsigned long flags;
 	int tail, status;
-	bool is_sec1 = has_ftr_sec1(priv);
 
 	spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
 
@@ -473,10 +456,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		if (is_sec1)
-			hdr = sec1_get_request_hdr(dev, request);
-		else
-			hdr = sec2_get_request_hdr(dev, request);
+		hdr = priv->ops->get_request_hdr(dev, request);
 
 		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
 			status = 0;
@@ -486,10 +466,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 			else
 				status = error;
 
-		if (is_sec1)
-			sec1_dma_unmap_request(dev, request);
-		else
-			sec2_dma_unmap_request(dev, request);
+		priv->ops->dma_unmap_request(dev, request);
 
 		/* copy entries so we can call callback outside lock */
 		saved_req.desc = request->desc;
@@ -611,7 +588,6 @@ static __be32 sec2_search_desc_hdr_in_request(struct talitos_request *request,
 static __be32 current_desc_hdr(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_request *request;
 	int tail, iter;
 	dma_addr_t cur_desc;
@@ -630,10 +606,7 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 	do {
 		request = &priv->chan[ch].fifo[iter];
 
-		if (is_sec1)
-			hdr = sec1_search_desc_hdr_in_request(request, cur_desc);
-		else
-			hdr = sec2_search_desc_hdr_in_request(request, cur_desc);
+		hdr = priv->ops->search_desc_hdr_in_request(request, cur_desc);
 		if (hdr)
 			break;
 
@@ -833,13 +806,9 @@ static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
 static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	int ch, reset_dev;
 
-	if (is_sec1)
-		reset_dev = sec1_talitos_handle_error(dev, isr, isr_lo);
-	else
-		reset_dev = sec2_talitos_handle_error(dev, isr, isr_lo);
+	reset_dev = priv->ops->handle_error(dev, isr, isr_lo);
 
 	if (reset_dev) {
 		dev_err(dev,
@@ -1391,6 +1360,32 @@ static void sec2_init_task(struct device *dev)
 	}
 }
 
+static const struct talitos_ops sec1_ops = {
+	.probe_irq = sec1_talitos_probe_irq,
+	.init_task = sec1_init_task,
+	.reset_device = sec1_reset_device,
+	.reset_channel = sec1_reset_channel,
+	.configure_device = sec1_configure_device,
+	.dma_map_request = sec1_dma_map_request,
+	.dma_unmap_request = sec1_dma_unmap_request,
+	.get_request_hdr = sec1_get_request_hdr,
+	.search_desc_hdr_in_request = sec1_search_desc_hdr_in_request,
+	.handle_error = sec1_talitos_handle_error,
+};
+
+static const struct talitos_ops sec2_ops = {
+	.probe_irq = sec2_talitos_probe_irq,
+	.init_task = sec2_init_task,
+	.reset_device = sec2_reset_device,
+	.reset_channel = sec2_reset_channel,
+	.configure_device = sec2_configure_device,
+	.dma_map_request = sec2_dma_map_request,
+	.dma_unmap_request = sec2_dma_unmap_request,
+	.get_request_hdr = sec2_get_request_hdr,
+	.search_desc_hdr_in_request = sec2_search_desc_hdr_in_request,
+	.handle_error = sec2_talitos_handle_error,
+};
+
 static int talitos_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
@@ -1474,16 +1469,15 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	if (has_ftr_sec1(priv))
-		err = sec1_talitos_probe_irq(ofdev);
+		priv->ops = &sec1_ops;
 	else
-		err = sec2_talitos_probe_irq(ofdev);
+		priv->ops = &sec2_ops;
+
+	err = priv->ops->probe_irq(ofdev);
 	if (err)
 		goto err_out;
 
-	if (has_ftr_sec1(priv))
-		sec1_init_task(dev);
-	else
-		sec2_init_task(dev);
+	priv->ops->init_task(dev);
 
 	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
 

-- 
2.54.0

