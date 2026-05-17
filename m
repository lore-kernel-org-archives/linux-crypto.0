Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313F93CBE88
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041224; cv=none; b=j+9hnrHETTqnW57icmLPRr18V88gXEjzXepKZJUzf2fyNIAqAOBPirqkOyWB78fjfQXqbtKPbVWRwke/21XLSSWVCx5/xJBb6XePjLWZMzEMx+NZl/BLf/cau+2zI6eeAqWVFpx6bWv1SRUjNlwUD9Vv+ou/nTi5unvTlQIoJ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041224; c=relaxed/simple;
	bh=BfIoE2EgHiX5HcimtCpSI/ihSU7AhR9eDkloFf03Afk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BBgUT5bAk0SizqlTjkgThm8UN7J6p4t8HTa9rMdCZ8XHralZeZZIF3QMbiv8W6fTMNaejcFwOqPItaE4SaLkoRCbfrVgCiifFOml7zdWnELokoSoRwCm2jHuoflFYQ95Jbg5+CPEP2MS6/UAANzSH0zFT0W8ib//WD2rkQKJwL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7kX1ObB; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7kX1ObB"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48962cd0864so2315505e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041213; x=1779646013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZeqSTb+Ww2f5MTxnXj9yvOCpat7Odm2G/43tTwf1sE=;
        b=f7kX1ObBXMdtErffe2O9VJhsKkkFrCM73EjSNzoYng1kRO8nrv34zuQNKDXPnsMwuX
         bCGwTWwOs9abIzfOShAXSsU/dEb/UlmNSoWw3dqJ/SYgS8SwcC2Y7b9Jfy8n9a4bBMws
         6GU1OdhF1nDLtGr85A/F/C4QEtWtsSeijxq3cHYbdTJmCBIjliqIUXBSsXmhAXtUslTz
         ISuvJolZ2X3i9usQLBtI2TVGLZ64l758GwsUEu2oho+XgHPz43zzaSdj7YPm1ukIilRv
         eO6a5az7Ae+rw3qfORVnRtgRZsFl1lcdQX661nnz+McCmgR50WVoKLDrhDBOm5xWw5cJ
         skTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041213; x=1779646013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xZeqSTb+Ww2f5MTxnXj9yvOCpat7Odm2G/43tTwf1sE=;
        b=sP/Oz7VxYlQRisRbeIMjGIwd9SBIXhu6LNNpGZqh3oiatVGAf3+MBaVKv+Qhlw5fCU
         PxgJlfBTmGXJN17eUGqoUi23gyl7ui/MNibTOalgXIkD6GCGG0bihHJHZVZzeeMbdtR8
         jQL7A/Kg/fWtYls+dbriAz1Znwt08wgWKRRyrJJN5VabeNJaB+b9Ufw0zhVERk5Rtgo2
         UrB13+vxTTM3Rn0Av8IW6nXMlqYArMVd8OYNQN3EJyX31R6MChHsi689gYYXSKn1IQbR
         KD6idGUw02km34P2kpJn3PqeZf/JWWEVf/bXpfZbT3CtB+sZf57qdWQ7VfyEcail/suO
         kkUw==
X-Gm-Message-State: AOJu0YxvBThIf2karS0zZ8Bw8wnblNZXKMHoRElilqofiW4rZFodaJdc
	8B9ZunOle/PZvldAf35y6dB0FDsL1aPCbzW0yEDAdyhWxA78T+RkFv0X
X-Gm-Gg: Acq92OEELOPnGPDdB1KOiJKKtipaPWppkiqvyWER9rHS015YpwtZ8jtqv/bGIZQ2Gwc
	z/xdS0e7Hb9xWVJ/ZGMfZJREUXv5+g1U6WNmDN8EvafF/MjwZPT9OXbpEBs4ZJ5m7xloas34VZI
	T1K07GonjdIdf9+GmZrykVV2e+xfRFVZHguhs2Kf06tgX32eOoJi4/BRrP612PJpG4ZXAPlbLTd
	3ifjffPo/hf+MmRS6luLiWotAm5lGrjblF2PqH/yohczAKpXZoRfIdpXishXomyGvDCY2oaixwp
	jZ4No5kZC7ihVoyvI9St5zLdNq/B9S2jw1XzCRbd9q6RuzRuWu4p1PpNObh7+J/0J8yBsOF3azn
	E+37mEeuSn87ygJjWXlUpX5MTRSH3wvJ0v/MQLCESfV/KUjDIt2TG2GP8W17Z5Jy17aNewXyxTZ
	ZJ+fF2KjuH8f8J/MLWQgYy3Ny4Jm1RtUp8+i1k0RZkR4hzYAEVkr4IkTA7g6D4fZg8XAXw/dsLV
	Q==
X-Received: by 2002:a5d:5f90:0:b0:454:454a:4cbd with SMTP id ffacd0b85a97d-45e5c6000c3mr8001358f8f.5.1779041213530;
        Sun, 17 May 2026 11:06:53 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:53 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH 06/12] crypto: atmel-sha204a - add i2c hw client list and improve probe error handling
Date: Sun, 17 May 2026 18:06:33 +0000
Message-Id: <20260517180639.9657-8-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260517180639.9657-1-l.rubusch@gmail.com>
References: <20260517180639.9657-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add registration of the SHA204A I2C client into the shared atmel_i2c client
management list during probe.

This allows the driver to participate in the common hardware selection
infrastructure used by Atmel crypto devices.

Improve error handling in atmel_sha204a_probe() by ensuring that partial
initialization (hwrng registration or sysfs creation) results in proper
cleanup of the client list entry.

No functional change intended beyond improved lifecycle handling.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 6e6ac4770416..cdfdcf2e43a7 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -173,6 +173,13 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 
+	/* add to client list */
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	list_add_tail(&i2c_priv->i2c_client_list_node,
+		      &atmel_i2c_mgmt.i2c_client_list);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+
+	/* register rng */
 	memset(&i2c_priv->hwrng, 0, sizeof(i2c_priv->hwrng));
 
 	i2c_priv->hwrng.name = dev_name(&client->dev);
@@ -183,15 +190,24 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 		i2c_priv->hwrng.quality = *quality;
 
 	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
-	if (ret)
+	if (ret) {
 		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
+		goto err_list_del;
+	}
 
 	ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
 	if (ret) {
 		dev_err(&client->dev, "failed to register sysfs entry\n");
-		return ret;
+		goto err_list_del;
 	}
 
+	return ret;
+
+err_list_del:
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	list_del(&i2c_priv->i2c_client_list_node);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+
 	return ret;
 }
 
-- 
2.53.0

