Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8F130C158
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 03:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785294155; cv=none; b=TP+rVz3Ax8VfJ/mqumeu+xknB6hV8SQ36IivV8NKzZ9mtvwLLmeBBPbCn85sKGrhT8uA7tJ6sh4Ptg7FFwzJD1ui/oXLbWlIWhFHbnXf2t3zpX+OX7SakQ2DanYwZhv3BLhzFTtrqmHxVPLqBM9RqbOxB1VQ2HFgKVSmRj6Ngo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785294155; c=relaxed/simple;
	bh=Gwcemrq0zRj8ieopVo+zg7dXfV4WwvBbIExYY8p7MyU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HJGc4IOzz1YiOejnXOxWynq/y03+/myjyV/1qOEeQABgFv3HY1A+kH3jqrlK6lov0AG+klUhXqMAI4LWpbXZxE0K7m3Xvoc8X2q4E4O+z1KnEyM/SfGpPRNqKSEoNfkD6NGPK8Nsma0V0qzFYQ4lH53PCUNIRDXu6tlnhsX0Vb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rxu6vdiV; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rxu6vdiV"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3810c5d691bso416134a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 20:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785294154; x=1785898954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0FbzdGwphzv4AdO9FD6SO4LnnJOCSj6BESmpj8f8T1M=;
        b=Rxu6vdiV2fUDvty9O2HuL1BV2Qk/XFNt1aLCCBT3t5x+aftCEn7ycoHAoD5WeUsM8K
         BpC49p7nc7Oxyh9Tm3pACbamla1RT42xeLbfUZe4Sfdeg+2poaDhpnIxYe5pKp4e0zJC
         pmV1gQpE3DwKY702qU9o2yc5lYljeqnq696WxpoaTvhA8V55FREWYf82/pK3AkuvdZxq
         JncjGk07AgZya2Pm4CbsUJesKQQ+FGqXXZyVet4pkVmT00/j+wtyWVwA41hVgGm6nmQX
         rtpf0E/VRm4oZGqU4mVR1vtGogmRHdmmlcf+JbFuycA5SDeNdtmExn6hd7o7R5wYC9RU
         fz9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785294154; x=1785898954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0FbzdGwphzv4AdO9FD6SO4LnnJOCSj6BESmpj8f8T1M=;
        b=Cmu4yrWhdkSElnfM1VJDd94X0/4njy21IWPoYvSxxC7eurO969ikcQQoDkXRxHXoGO
         4AgHn9P7zIWjQ59c4B8x9WAkzZqZrCuRJMex/B5KMIWMO9a3JthV8up4Fvxix5Y9CemY
         BsH3J9kOTVuE0Dck3i0eZaYp+Hn6Qgs4+VQItVT6vYDkhCE+JGf8FWkyK+sXrQ0a+gWB
         7wU6qT1nBMp1H1djgHHV6WGXGWE4yqJ5IclnORqzOOGPJhR+DpsehhZQCl1NZNXP+Hf/
         NjeTGWL86LfpgRIxvi4U6k2n3Zn/J5xr5I89LcGCcJHkutKJuEJ5e5Ji4+yxf0EdUgDB
         060w==
X-Gm-Message-State: AOJu0YxY+aAsscez68kpRrFRcamN0LoskzyKTxD/Kx2Mxu7XZZFbYZrX
	BzMF5CrXcjdO178OPEr6m8B/iGQQVEqCr41kZCvFR6yrWTN85D2zp7C0nQepWw==
X-Gm-Gg: AR+sD12ph/a7qJg3FjPyl04e0nU4ONVSV1mGIkXuyM9g1cS+DKnDf7C03ZLUQsnXLQC
	9R+ysepAiRwjuukeWKno+M3nFFJPX61w0gIKimQTA/pMacnkcHrQQQXLUrFPmjHvahaJNgLgBWG
	1DFR2DIyXFoG20ZYWGaI4aZnY52yE+9otlZtoYRPbde4I8rrnnzVf0T7HubkwOE2rflQ7PuJ37l
	3KaZr30nOmzO03kbT5xHD9/fUP+IVLZ8duKyN02p7iboryUt3CSEvAiTzpsMR5D7Bd0MFgmwMsj
	eC7WO1fJ6x+IdU15s0sCQg+1eqttaDnghwoA0hVjRgza2f7Q+Borza57/7giWo7JMK5QJ3GzSXL
	vyObUehYt+aEcldvs9pt6OfWO2vR+OibNY56QSw85XdD8Dgrxpq/vJYAsvZw1qDB1Ci8NOFAd7w
	PMlmvQEY8CvZag7ZhB0DtNjFveASZlrt9ialdofD/5Ys2sCf19lDUZ28HoqdpCrC4alnf2Itedg
	b1LsCSuu0HdPKdxyCgpCJExYuOVHfexxbfVTzNAp4xUYqakxHKV1ykb8uej4HQATg+CblLnJ2kd
	T8eNtED7w5TkRaYjAptOBoPbN7CazLEzq7ZMP3evtlgSRsWC9g==
X-Received: by 2002:a17:90b:5883:b0:38d:f5bb:e0f4 with SMTP id 98e67ed59e1d1-38f6a33de7fmr5022122a91.1.1785294153498;
        Tue, 28 Jul 2026 20:02:33 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f7f292af9sm627807a91.11.2026.07.28.20.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 20:02:32 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] crypto: talitos: Use platform_get_irq() to retrieve interrupt
Date: Tue, 28 Jul 2026 20:02:31 -0700
Message-ID: <20260729030231.642651-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the need to call irq_dispose_mapping as needed by
irq_of_parse_and_map().

Simplify the function as a result. No need for gotos anymore.

Add a missing free_irq.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: change irq checks as a result
 drivers/crypto/talitos.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 3a3fd21d2c4d..fa96b6bf17e3 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -191,7 +191,7 @@ static int reset_device(struct device *dev)
 	       && --timeout)
 		cpu_relax();
 
-	if (priv->irq[1]) {
+	if (priv->irq[1] > 0) {
 		mcr = TALITOS_MCR_RCA1 | TALITOS_MCR_RCA3;
 		setbits32(priv->reg + TALITOS_MCR, mcr);
 	}
@@ -3241,13 +3241,11 @@ static void talitos_remove(struct platform_device *ofdev)
 		talitos_unregister_rng(dev);
 
 	for (i = 0; i < 2; i++)
-		if (priv->irq[i]) {
+		if (priv->irq[i] > 0)
 			free_irq(priv->irq[i], dev);
-			irq_dispose_mapping(priv->irq[i]);
-		}
 
 	tasklet_kill(&priv->done_task[0]);
-	if (priv->irq[1])
+	if (priv->irq[1] > 0)
 		tasklet_kill(&priv->done_task[1]);
 }
 
@@ -3353,26 +3351,26 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 static int talitos_probe_irq(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
-	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int err;
 	bool is_sec1 = has_ftr_sec1(priv);
 
-	priv->irq[0] = irq_of_parse_and_map(np, 0);
-	if (!priv->irq[0]) {
-		dev_err(dev, "failed to map irq\n");
-		return -EINVAL;
-	}
+	priv->irq[0] = platform_get_irq(ofdev, 0);
+	if (priv->irq[0] < 0)
+		return priv->irq[0];
+
 	if (is_sec1) {
 		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
 		goto primary_out;
 	}
 
-	priv->irq[1] = irq_of_parse_and_map(np, 1);
+	priv->irq[1] = platform_get_irq_optional(ofdev, 1);
+	if (priv->irq[1] == -EPROBE_DEFER)
+		return priv->irq[1];
 
 	/* get the primary irq line */
-	if (!priv->irq[1]) {
+	if (priv->irq[1] < 0) {
 		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
 		goto primary_out;
@@ -3388,7 +3386,6 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 			  dev_driver_string(dev), dev);
 	if (err) {
 		dev_err(dev, "failed to request secondary irq\n");
-		irq_dispose_mapping(priv->irq[1]);
 		priv->irq[1] = 0;
 	}
 
@@ -3397,7 +3394,6 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 primary_out:
 	if (err) {
 		dev_err(dev, "failed to request primary irq\n");
-		irq_dispose_mapping(priv->irq[0]);
 		priv->irq[0] = 0;
 	}
 
@@ -3498,7 +3494,7 @@ static int talitos_probe(struct platform_device *ofdev)
 			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
 				     (unsigned long)dev);
 	} else {
-		if (priv->irq[1]) {
+		if (priv->irq[1] > 0) {
 			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
 				     (unsigned long)dev);
 			tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
@@ -3516,7 +3512,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	for (i = 0; i < priv->num_channels; i++) {
 		priv->chan[i].reg = priv->reg + stride * (i + 1);
-		if (!priv->irq[1] || !(i & 1))
+		if (priv->irq[1] < 0 || !(i & 1))
 			priv->chan[i].reg += TALITOS_CH_BASE_OFFSET;
 
 		spin_lock_init(&priv->chan[i].head_lock);
-- 
2.55.0

