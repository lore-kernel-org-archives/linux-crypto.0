Received: from mail-dl2-f40.google.com (mail-dl2-f40.google.com [74.125.229.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768463B8BC7
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 21:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150646; cv=none; b=uLm1TgFng0RmJef4+EogjdZP0lEsOnydsRY5LKOwUvhR3eqg+kve6kIniI2tNOSsdcx965DnLrPAlj3Jq9FTsPDdkamdT98VXvc+p14MeM3yl50EmtJpHpZULmS8/2iV9GMOBRpJGqA3KvEe3lu4F9lXW3j8L1e7BmO4UXfs85c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150646; c=relaxed/simple;
	bh=005wmVDhIjHmxV8E64+HaG6G200We7gr964+HBH3FhA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gKVH64kPaDA1D4G40jDenJjFhPMA1JYez+gmS9yHk0TiDaRmMPy5h2JmQTC/PjQw/bDAHVbtypWdhNL5pWI7RoNvFc0xJQOjcNcJuCsLjUz5jnYwf53Bf0HH5XTZBhRJJWIzS2hFfox03bVslxQHxkIKFGBpDDdEOs8n42kipz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SsvS9GZY; arc=none smtp.client-ip=74.125.229.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SsvS9GZY"
Received: by mail-dl2-f40.google.com with SMTP id a92af1059eb24-154e9d2d877so239382c88.0
        for <linux-crypto@vger.kernel.org>; Sun, 04 Oct 2026 14:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791150644; x=1791755444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e2dgUERMJ9zgT7cA30qvueorKToJxEejYLolsCAr6Ks=;
        b=SsvS9GZYrkKZEefsdmhq6jAa8tYUHt1mYDX7j7LtYb5RRXKtW+AagU9rVJj3eaRcLT
         VWdaYJYeJrv3g8qQs0fa/hVA1aOYNOuliJZPe1jvTrdhXnWtojkE3pMAaMVtWm2BnK8v
         XnJPbN2oy54o8xeq2uN4G/U4CWmEMfjOASmJdFE5yAizuDtPLQdBtI9D9SxvddNxKael
         ZkuOOQrHV31w+lU4BXRBvGODGzDYmVv2sLD3AkOhNSAYQN1RgxVLc50IHL7qUS3hSb0I
         ka2R0YJnQhEn5iujsm6qeuybvZtGPK+v2idc/xCcCN/dBx0hPw0tOhKMSnJNROCwxgCe
         lSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791150644; x=1791755444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e2dgUERMJ9zgT7cA30qvueorKToJxEejYLolsCAr6Ks=;
        b=GLTfRzsN+cZcWRvrjg1QZ1w0VoZ9zwAoOaqnLahxEuTtQwtW9Y9IyfR6OeLj8fZRsG
         6TnFFW1Qj4/dtmyY4/JukzLqeCXuA3scBHAPtkk4FwO8lhvLkYyvGhyKvZpFL2Hfffov
         UKfKv84KhvHmMLFadM1B91LJoqO+8PJzwGJOS7GXCgWrr2apiWbim+qQwBk14rmG9kou
         FCOIxUPX2gW2M35a9mT3SKww2+TToKnKbVMcXuGdCaBYAaKy1RnDHLSp033QIVhW9EFP
         c2HNvBMhTTe7jJPBLSTBd5fsiwfYwh71+gpgllYNy+w/nsSX2goVf0E72CkrGzs+zpdl
         l45g==
X-Gm-Message-State: AFuF++loaaMXvk4AKobn7bIP/2W8edvDMWCohLY77HX4h8y+hzDp9yUv
	3f4D6lGBYbJdnGGJOsqn5/ymEZwZQKgMbLEoD8RhY0QxilMJn35nKianpDbwJKA8
X-Gm-Gg: AYBFou037OJ2lujU+3iZh2EAMXNpfyJc+9Y3dLYyxybUWNfAES6WUQLTjPSvzSeyxq8
	PZdblZTh8yNOcj+SVNNNm1xq0tThdu3t5EP3gjHBebkvBD4APMLdkJqWyCaj7dVxNPeerZzMMoF
	cu8ZDYxZ9H/1v31xGAWJpWTx+DQ/m4KvYC3+kZXNvbTDFQEIJdgijv8t5BKkWGHsJ8r7i4mdHva
	OpX0xK5prIT5SZRRN6INHt7ZFZjVL401UKV/jUWRyl3tOleIsgpMyLwp9VZpH3yoivygiJrccW7
	KVPiD6T3s4G+EHe2VlyBuZp6fLeMlo11WxqqtIYe3JS6U35pZ7r2FSEAQAk0t50q9vMgEBZhrHG
	hN7grS5cuawRRF2y063iy8ySsAdWM+LX1oKhueTaB34D74sLNkRlR0ePXYjC8SGX8Zn2PjN7Ksf
	YP6tGKkA6524dXoq5KjVtpSiY/sdgNdzZL8SptR9S/yTugUdXBRa6kjbqzauQl4IEq1A/58OA3I
	Fv1mvAswBSxB/770sDq+1Z5lWLm1W3Ir2yIBQOCjW8HfEm0EQs1ACwi3yZ/6OfwSHi9k+dvzmtj
	4uFHdhKVzGf74PR5MyoLJwzWHlyYl+azp9UR78OepD/xjwIr
X-Received: by 2002:a05:7022:798:b0:14d:c7ae:85dd with SMTP id a92af1059eb24-14f5b50b67fmr15595843c88.7.1791150644150;
        Sun, 04 Oct 2026 14:50:44 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351271847fbsm11970410eec.15.2026.10.04.14.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 14:50:43 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4] crypto: talitos: init tasklets before requesting IRQs
Date: Sun,  4 Oct 2026 14:50:42 -0700
Message-ID: <20261004215042.383358-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The talitos interrupt handlers schedule priv->done_task[] via
tasklet_schedule(). Since the second IRQ support, probe has requested
the IRQs before calling tasklet_init(), so an interrupt already pending
when a line is requested, e.g. engine state left by the bootloader or
a kexec'd kernel, would schedule a tasklet with a NULL callback.

Look up the IRQ numbers and map the registers up front, so that
-EPROBE_DEFER returns before anything is allocated and the done_task[]
selection and reset_device() can see the secondary IRQ. Only request
the IRQs once the channel fifos are allocated and init_device() has
reset the engine. This matches remove(), which frees the IRQs before
killing the tasklets.

remove() frees every IRQ number that is > 0, so make sure that only
requested lines are set when it runs from the probe error path: clear
both numbers when probe fails before the request, and clear any line
talitos_probe_irq() did not request. Previously a failed primary
request in the two-IRQ case freed the never-requested secondary line.

Fixes: c3e337f88a5b ("crypto: talitos - support for channel remap and 2nd IRQ")
Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v4: actually fix IRQs this time. Add a Fixes: tag.
 v3: reshuffle again to fix IRQs.
 v2: reshuffle code to avoid NULL derefs
 drivers/crypto/talitos.c | 54 ++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 41a87d7c30a0..c7d9ce2905be 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3353,21 +3353,13 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	int err;
 	bool is_sec1 = has_ftr_sec1(priv);
 
-	priv->irq[0] = platform_get_irq(ofdev, 0);
-	if (priv->irq[0] < 0)
-		return priv->irq[0];
-
 	if (is_sec1) {
 		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
 				  dev_driver_string(dev), priv);
 		goto primary_out;
 	}
 
-	priv->irq[1] = platform_get_irq_optional(ofdev, 1);
-	if (priv->irq[1] == -EPROBE_DEFER)
-		return priv->irq[1];
-
-	/* get the primary irq line */
+	/* single (or primary) irq line */
 	if (priv->irq[1] < 0) {
 		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
 				  dev_driver_string(dev), priv);
@@ -3379,7 +3371,7 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	if (err)
 		goto primary_out;
 
-	/* get the secondary irq line */
+	/* secondary irq line */
 	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
 			  dev_driver_string(dev), priv);
 	if (err) {
@@ -3392,7 +3384,9 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 primary_out:
 	if (err) {
 		dev_err(dev, "failed to request primary irq\n");
+		/* neither line is requested, keep remove() from freeing them */
 		priv->irq[0] = 0;
+		priv->irq[1] = 0;
 	}
 
 	return err;
@@ -3404,12 +3398,27 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv;
 	unsigned int num_channels;
+	void __iomem *reg;
 	int i, err;
 	int stride;
+	int irq0;
+	int irq1;
 
 	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
 		return -EINVAL;
 
+	irq0 = platform_get_irq(ofdev, 0);
+	if (irq0 < 0)
+		return irq0;
+
+	irq1 = platform_get_irq_optional(ofdev, 1);
+	if (irq1 == -EPROBE_DEFER)
+		return irq1;
+
+	reg = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+
 	priv = devm_kzalloc(dev, struct_size(priv, chan, num_channels), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -3425,12 +3434,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	spin_lock_init(&priv->reg_lock);
 
-	priv->reg = devm_platform_ioremap_resource(ofdev, 0);
-	if (IS_ERR(priv->reg)) {
-		dev_err(dev, "failed to of_iomap\n");
-		err = PTR_ERR(priv->reg);
-		goto err_out;
-	}
+	priv->reg = reg;
 
 	/* get SEC version capabilities from device tree */
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
@@ -3481,9 +3485,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		stride = TALITOS2_CH_STRIDE;
 	}
 
-	err = talitos_probe_irq(ofdev);
-	if (err)
-		goto err_out;
+	priv->irq[0] = irq0;
 
 	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
@@ -3493,6 +3495,7 @@ static int talitos_probe(struct platform_device *ofdev)
 			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
 				     (unsigned long)dev);
 	} else {
+		priv->irq[1] = irq1;
 		if (priv->irq[1] > 0) {
 			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
 				     (unsigned long)dev);
@@ -3524,7 +3527,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		if (!priv->chan[i].fifo) {
 			dev_err(dev, "failed to allocate request fifo %d\n", i);
 			err = -ENOMEM;
-			goto err_out;
+			goto err_noirq;
 		}
 
 		atomic_set(&priv->chan[i].submit_count,
@@ -3537,9 +3540,14 @@ static int talitos_probe(struct platform_device *ofdev)
 	err = init_device(dev);
 	if (err) {
 		dev_err(dev, "failed to initialize device\n");
-		goto err_out;
+		goto err_noirq;
 	}
 
+	/* enable interrupts once the channel fifos and tasklets are set up */
+	err = talitos_probe_irq(ofdev);
+	if (err)
+		goto err_out;
+
 	/* register the RNG, if available */
 	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
 		err = talitos_register_rng(dev);
@@ -3597,6 +3605,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	return 0;
 
+err_noirq:
+	/* the irq numbers are known, but the lines are not requested yet */
+	priv->irq[0] = 0;
+	priv->irq[1] = 0;
 err_out:
 	talitos_remove(ofdev);
 
-- 
2.56.0

