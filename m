Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2CD369D4E
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292652; cv=none; b=AJ4ttBJHqb3GVwYEI/wLqThAv1jx41T1oKfmhE6R0aPW+RUygmf+BwnQwxQtKABzDnXjP5voSXpBkyBRUxUrH0W+H4Iv5QWL8eJDmzTmNFhye5iMdE2oP5+Rhf0tpnW+QUhxsHEp/7ONI0FWJ+1y9Tk9slIpL1Wb9zwbYtcPFOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292652; c=relaxed/simple;
	bh=uTqRw9ZHkWp+fln1pdSGn4zT19f/st0v4wNEfxmP3yU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a/65flk2PqTNwBYxrmWqtvVu/8T44gnkvhieGSrBLeJ8sy107YkC79wkAaHBQ+mNDPp6v2iaj0oexeW5xsOpPDNLtHnjiEN/CjAbWHFFO1GG6ZIaseyD2+f0UrUbsYBmbvYB2iKxZpFW8518e6N6jLMmzStcGrLrwCAp0pCov3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AzIVlHDS; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AzIVlHDS"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48e69e60063so4651435e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292645; x=1779897445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4fqnKQyfEX10m0YEJcZYCgsQ4k4ZpuOar6eAbgyMF0M=;
        b=AzIVlHDS0vzfuTe2eJDe1Qcq6PXbvIBC6y8p8k8kB+AQN93wwPblp/B0IUHb5wFH5Y
         bf4POzUQV6DetBUsyRTZyHS0Nlpuc++0BuV6lsO5uYDIRnLjewaizfJWDHYY2DCfigti
         1VENnJKkjHvtHEE2/KaTdv4PzLq0d7wIAI2A5GGuAZJw7nkPPDzf+s4pTMLB+vPv8Lvm
         qnyrnuJMn8qoeQQLidJsar2Vx09R+825hyn7Ig7mF/KHh+547FOsTavnFDs1lfqL5qtx
         eFGk5jsdyVy+KvPFY13qyMD6DW2MPMVGytGCRFoFSB2o3+9It0pND9cLvPmuUYiY+uEW
         3D8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292645; x=1779897445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4fqnKQyfEX10m0YEJcZYCgsQ4k4ZpuOar6eAbgyMF0M=;
        b=GRb7jenaKhQrnYwijynLMYTxmYO3LW+IYHTciY2rlLhPc5Oh9DBWdq2oMINhV3F2ST
         CPAFnJHv9gwxUEimqDzDd60WwMq9QBsMOUdiU5GhJI3IuPiyStDyJIrZP8WrdDGFMRtj
         21pJQ0qWLe3cpm3YHpmJLGuloHnVBPKBrRkyLBsPQV6RqfF+ZUdfbangcOfxmf8c8pNx
         /ULoJbbbc6M2YyTHMkE+xC0uuImFf3Gue1sqauPoKH/0B9694HUKRVEYNJDNLS3z5Jwx
         8nws8NePn2B28l3pnp9SZ5eBL0SxWIY/J710blC0gQuYQEDUtTxvajAlfxuiKxB2faGQ
         Cvvw==
X-Gm-Message-State: AOJu0YxUA+tTB0tLqT5E+uY/aeMvfF8lrOP9/K0xy3r+X4QJIwesHJ5M
	7n2ynwNaAlPneT9Offu+d17+4sOM3V/IHpLdWi3nvnsFTrIMVVcfVXoe
X-Gm-Gg: Acq92OGz9A4sp7qzT1mmBosihI/Ha9J9EE8FbK+pP+Zvk9BkP6YHwJwpJRG2CfL/e93
	NAulKO8nVzfJJDvWSSLvqC6YEffJ/mgVI7INhpF8UDYZTLeaXV6oQy4XwVcnbzOQKlVylWzwAFo
	0c38PD+J6qJbLRIpmvd9zLcBV/I6mOBk9/W8OEH7TyPUYEyiAsuwuwnpnQEJlEtum1vP1zyL+bC
	5sW+Gzq2+3sAT/dxGEwqH7bRxQgGbRllyuzgmyKW6EAKA65j64hiJgDKL8hUZSWwLwWTWLoDPPz
	jLMuxwOrnieTGewkT6g1QRl9UY66ZIv6fzoSM2BLHooZ6xCMoQ4FCcAs9MQpGA2gwoqP7pp4E55
	s5vkc8k+qGabY/exJZYktVhMrU3WWVTUs7sqHW9Wup6yGku+3FYQGCO7QuO+tXirTHq4koMGaZw
	j1zPkLK5047Bx3VJ2bDtx2tog+U9oUegWq2JX0kg9RX5TZJfUg8hGdDYccGyZy2vg=
X-Received: by 2002:a05:600c:470e:b0:485:f1d6:2b1d with SMTP id 5b1f17b1804b1-48fe59adb12mr166420295e9.0.1779292645281;
        Wed, 20 May 2026 08:57:25 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:24 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	ardb@kernel.org,
	linusw@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v3 10/12] crypto: atmel-sha204a - integrate into core management tracking
Date: Wed, 20 May 2026 15:57:01 +0000
Message-Id: <20260520155703.23018-11-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260520155703.23018-1-l.rubusch@gmail.com>
References: <20260520155703.23018-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Register the SHA204A I2C device instance into the shared atmel_i2c client
management tracking list during the probe phase. This allows the driver to
participate in the central hardware selection infrastructure.

Rework the error-unwind paths inside atmel_sha204a_probe() to prevent stale
entries from remaining in the global tracking structures if a partial
initialization failure occurs. If sysfs group creation fails, explicitly
trigger devm_hwrng_unregister() to preserve the strict lifecycle ordering
introduced in previous stability fixes.

Convert the removal path to use the core teardown helpers. Ensure the
device readiness state is deactivated using atmel_i2c_deactivate_client()
and the tracking node is removed via atmel_i2c_unregister_client() before
local memory resources are freed. This guarantees that any in-flight work
queue items are unconditionally flushed, eliminating a potential
Use-After-Free (UAF) window during device removal.

No functional change intended beyond improved lifecycle handling.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 3853d2b95449..db61ac0177f6 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -172,9 +172,15 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 		return ret;
 
 	i2c_priv = i2c_get_clientdata(client);
+	i2c_priv->ready = false;
 
 	i2c_priv->caps = 0;
 
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	list_add_tail(&i2c_priv->i2c_client_list_node,
+		      &atmel_i2c_mgmt.i2c_client_list);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+
 	memset(&i2c_priv->hwrng, 0, sizeof(i2c_priv->hwrng));
 
 	i2c_priv->hwrng.name = dev_name(&client->dev);
@@ -185,15 +191,28 @@ static int atmel_sha204a_probe(struct i2c_client *client)
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
+		goto err_hwrng_unregister;
 	}
 
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	i2c_priv->ready = true;
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+
+	return 0;
+
+err_hwrng_unregister:
+	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
+err_list_del:
+	atmel_i2c_unregister_client(i2c_priv);
+
 	return ret;
 }
 
@@ -201,9 +220,10 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
-	atmel_i2c_flush_queue();
+	atmel_i2c_deactivate_client(i2c_priv);
 
+	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
+	atmel_i2c_unregister_client(i2c_priv);
 	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 
 	kfree((void *)i2c_priv->hwrng.priv);
@@ -239,7 +259,6 @@ static int __init atmel_sha204a_init(void)
 
 static void __exit atmel_sha204a_exit(void)
 {
-	atmel_i2c_flush_queue();
 	i2c_del_driver(&atmel_sha204a_driver);
 }
 
-- 
2.39.5

