Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90803B3BF5
	for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2026 23:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790293884; cv=none; b=U4UKenzbufxBGNisn54CDoKSrVQXNski8KWQ62n+3VYOxA8S9tJ8VJVwN8VEWcVhtr4qE18qrPgSYLb3N1SmG0xZMgX7C/ZjEdPX71bCe3Z0a3m9ujOw+Gn8mD4aL+/ZbRvdCY5KmCqBjQ+L2LaFrWTDBrNVoTmgk8UGK2wk5ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790293884; c=relaxed/simple;
	bh=6L0NjeLbJplSZvx4toERpzY9L3Q5skU0+h9MTU7MozA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u+zpelL1nw3+BT+R8HWuIzGJNtPJKxOuWaJV1F4d8eO9fpDwCOJavopoXilXl+1f3uH7Bbe6vWUXYHSWvQZf0DBxj2PPYLjdnCtet6DtvIc5cZT1EJEuPKa3aSr6V2LNa34NEluGxopN7/dtegzPl0DciYMOq0YvMhf2Htn6RGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gfkJlidC; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gfkJlidC"
Received: by mail-pz2-f43.google.com with SMTP id 41be03b00d2f7-cc4c3304833so95464a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2026 16:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790293882; x=1790898682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n7h+VVCSvpCLVVej2FOvVs0E08BhObs9j96BCD16kt4=;
        b=gfkJlidCy/lUQ2oTTUgIRNBe/ph+Vd9+6G1w2nTqB+cx9PzcQ94CcYTSjq4Rr/JN7B
         SZOzGn6ZCTH7Cw2WT2RRPBpaplC3ub+I1o0C0cB9Fyx0fabb8gSbnqMxuEuPb1jJGijY
         ZMQPFAxAkTUNi9Nny1Xs4QXIjkd0LJFYk6Yu6aa/nWqic4jHjec+P8j02Aekbr+6A5tS
         AbyOnbvcZyIEwN/OKSIwt1C7HM49jv1M0Lih81983bYAyCbwbuDNkMH3m24HOUw+rRr/
         7Po6whY/CLUJe7tFDFltqqsHmzk7R3LIVNS1l6TtYMI4lICffIIHhuLUU7wcd330TX8M
         RYeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790293882; x=1790898682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n7h+VVCSvpCLVVej2FOvVs0E08BhObs9j96BCD16kt4=;
        b=0aOuijlrusXxkriuDMVqlbQ7HZKfnpIsvhVvMhut7yUzZU6gzqdcDSI3WC8wW2lNYp
         S0MVTNBcV1d6nYR7vLnZJn6ja7GKYnCY2Z4lHwbIteYf1gDcU5obp75byYe803kL0klK
         GSiZmebhTT1K47bTUkjry2TqDGNuXJ1KtkDGgIG9HTpVHhdEYjFo/G5gn1ApNFJQvBfb
         e51kda+KLNi0Z6GZVGyEbMRWO0vI5qfDEJbD6zDw6Xr1ZVrRHR1/D+WPxKTvv/64GMMv
         CZJPK00TnMG15l5NXxIl8j19+1gZm6adzmVPnOIRX4KYLqO6NP/Ss1M+igoz/KThXHDw
         PqVA==
X-Gm-Message-State: AFuF++lJ+PJp8wBLQXbbHmpBWAFT//gA0J6YJO5KphN1mu3wdlKtE2Es
	Yzged4TrgH3QgFUVMVxkiccGJNa9A2D8Ia8sr2IKqnY/t8YlmXFC/o2qsRiHhw==
X-Gm-Gg: AYBFou1p7liGlpiQoAsLUpTbzE3QWrQ2/uozKnpL0yj+GOds6QsNuok/ceR/NIXeUwq
	gEYMTzXybbN4U94m0ucOvPf8fdYdNWApvvp278eYwvcpG6CbdnY7+QwqrbFA8S7rPOjIrdORcqR
	VFiZ7R4l3yc4Vr5Mdbn2Wd+6IYxcchy++jfvWVs3uEppGolI4xablfVlcw9MIBhepEA0oprmt5C
	0+PfMlECmbMfjwkUqlbmChKyE1SLC9kTfjrlQpQ+cVwmJZcYoVb17r0XblNdVl0bVLOmU5Ag1+o
	zuqnRa7UaMUD4mKW+MSOhEDSTcb5RGEcbZ1iE1168iVNbbc0DpiVKlTcf4tAKskvYy+HX/7jA6s
	/VD9UKocTKI+LSthbUTYwJoh5ehgFZhbeOEYt5miGZbO6sZNNSG75hYsQVO6IrAqHw7JqHEsTKF
	0IIm4T58T8LpqDBih2tnvleDnlbRfh8xu4p2pozfLlz5PyAz43lBlI2shHklFEZbn0L5BL8HGcg
	IEi8GVYZjJCaCF0EwGdB+7OQPkRqLrwvTS1Gkfe3UEZpL4EE2c2HrrxHpBVw21dlOEJQ5ZNnBSb
	lw3WziY1ZMW9i1w7+zlpq+aV9gXLFR+bp+oQQl0qrtAg3gwY
X-Received: by 2002:a17:90b:1a8e:b0:39d:eda6:8a0b with SMTP id 98e67ed59e1d1-3a098cd4453mr3505870a91.21.1790293881852;
        Thu, 24 Sep 2026 16:51:21 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9357f64sm959429a91.3.2026.09.24.16.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 16:51:21 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] crypto: talitos: fix probe IRQ ordering
Date: Thu, 24 Sep 2026 16:51:19 -0700
Message-ID: <20260924235119.141323-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The talitos interrupt handlers schedule priv->done_task[] via
tasklet_schedule().  In probe(), talitos_probe_irq() ran before
tasklet_init(), so an interrupt arriving during that window (a shared
IRQ, or a completion pending from an earlier transmission) would
schedule an uninitialized tasklet.

Resolve the IRQ numbers before the tasklet_init() calls so the
done_task[] selection can see the secondary IRQ, and only request the
IRQs after the channel fifos are allocated and the device is
initialized.  Every structure the handlers touch is then fully set up
before interrupts are enabled.  This matches remove(), which frees the
IRQs before killing the tasklets.

Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: reshuffle code to avoid NULL derefs
 drivers/crypto/talitos.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 41a87d7c30a0..b9dfa2b7ccbb 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3346,28 +3346,36 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	return t_alg;
 }
 
-static int talitos_probe_irq(struct platform_device *ofdev)
+static int talitos_get_irqs(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	int err;
-	bool is_sec1 = has_ftr_sec1(priv);
 
 	priv->irq[0] = platform_get_irq(ofdev, 0);
 	if (priv->irq[0] < 0)
 		return priv->irq[0];
 
+	priv->irq[1] = platform_get_irq_optional(ofdev, 1);
+	if (priv->irq[1] == -EPROBE_DEFER)
+		return priv->irq[1];
+
+	return 0;
+}
+
+static int talitos_probe_irq(struct platform_device *ofdev)
+{
+	struct device *dev = &ofdev->dev;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	int err;
+	bool is_sec1 = has_ftr_sec1(priv);
+
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
@@ -3379,7 +3387,7 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	if (err)
 		goto primary_out;
 
-	/* get the secondary irq line */
+	/* secondary irq line */
 	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
 			  dev_driver_string(dev), priv);
 	if (err) {
@@ -3481,7 +3489,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		stride = TALITOS2_CH_STRIDE;
 	}
 
-	err = talitos_probe_irq(ofdev);
+	err = talitos_get_irqs(ofdev);
 	if (err)
 		goto err_out;
 
@@ -3540,6 +3548,11 @@ static int talitos_probe(struct platform_device *ofdev)
 		goto err_out;
 	}
 
+	/* enable interrupts once the channel fifos and tasklets are set up */
+	err = talitos_probe_irq(ofdev);
+	if (err)
+		goto err_out;
+
 	/* register the RNG, if available */
 	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
 		err = talitos_register_rng(dev);
-- 
2.55.0

