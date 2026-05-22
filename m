Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD8E3672B1
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490924; cv=none; b=H4rFBqYa+s+DDJSS3DWRYdH5cl+fq1JUa5Bg4S/pSYAKqUq8ffr4ZJWqG2DCsHOdSCE9akPilJDvWs2QfGKv5GI0eIoLeuE1oK4AdeJFOFl5QXSJ98m5YXswu8CiWFM5o6jXtLpPKrurrj+gdfyiSFdVLU31yOO0ys/UO2IYrQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490924; c=relaxed/simple;
	bh=lKGPcQDLn9w68YKEAYXZZehbSZlsT66QfLnnSBn/f4c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=syd4gx5Nckq/pmu2ID7ABlyMnKf1IH/eD7vaHOwaZVWcmlZJVGFUk3HppnK/BPipxyKOU0Df/Y1QJqp5PC+HxWnSjti4Msd+Q/T8hG33EvC+lzH1+WZb8YHib7xurIa6SEnI7Hxd/v83385PfV6y9+AQh6eR6Ng0SsOY85zkCiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BxvsQUWR; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxvsQUWR"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4493cf2f982so705311f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490915; x=1780095715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uuVvbPMfCmoiXjDpDixu/ffXb2eS9sn4npWm18kEdeo=;
        b=BxvsQUWRXnEVgtqY7TnUgGWrckxjvfh5Sai8ZlUwNOFgSOLnD8U2S8j8YQmMtUpSDg
         RmBB2yUk2Nq+wrudUX2RfKlwD6qpCRRwh4vXsEzi9qB2ISMZUorV0rP57tv0DQhKW+UP
         w7AInzl8koo0ySVdV+Ylun92DV3+ErxB2gbHAzc+Vd1YUhAD/CO/95l8rMx2uxnbKT46
         yqsJIvuyVtKZt1yk6WOr5Q4H3vrrylzVRaNxDMANOIG7xKyTS+PU6wrI36yWloKUJZHU
         AryOxET2SuIm6PnuktLWcpezESM1CN6CdGFsDmfF0M+ObyXiYuhINcN53iQxzO5IxUc+
         mLPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490915; x=1780095715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uuVvbPMfCmoiXjDpDixu/ffXb2eS9sn4npWm18kEdeo=;
        b=QDZB1x+p2d6hkpK13BE2V++qCoUQ2owbVG6bi8ZhnAl716Tou0YyuukUuucRtqFkQD
         NB7pf5TIoAIoyGcKVROIP7Sf1NeewfCOKLAhuVq0QimUMtpBzeNNW29CwpC+qDVC19Rx
         A10bAtKkQrGARIBfgknYjk72HU7rY44C30AL5S7q4fPYaZxHXPoSG5IyE8NtCGzEm+pC
         UKIGxwBQZu5dJDx30EyTWpASqOYfHwoCT/7RL9EdzpXqC4DEjijl/3ZWAbKLvTvKTADm
         Yity04dLr6P6RYExr/Fk10ZX/U8JW0UQyyXila519rnT61Ai6FVIbzEY25u5tW6xXmWD
         UA1g==
X-Gm-Message-State: AOJu0YwYBaN0+2l1XMcaSAonN9k9DzmXez4rPeMTRBHVZ1CvKGGAFOLs
	kMJEJqUO9TCUX6fvyUtGV771QscTO9Xod2GrxigVs2baSNXKXo4+C8Yv
X-Gm-Gg: Acq92OEIsjO7m3paDGuH/BtSu1IUajCN7voiKVBlnBAX6Bs0Ym5e0S6faC4K1MR37Xu
	I6VH5/g1DQPlv25ps3YvFmYGWWX5LrjJF809jUkKY5LiFInhDLecZZnEqzeQWqd20SJnSVy/Qj4
	TVrQ/Fw8HNGgP4yToD0NSRnPJfBnJ7RJRROk4Z4mQdlzKE4GL4xT4MqYfiGBJWlbd2N6G/9BQ7a
	PLBxmumsGcI1+TvmcVZTeBgtvyDzvVzdIzrS5YcrfXo3H5zmraiIS4I5tK/7GEBNSRBFb4pIfcc
	GKqt+b2HJo9vTdvNZJ7kaUYpwHkRgLFzpBHCf3WqjoJAK/+bLmSRZYbGZwTxUGu5knmgmvbWhsD
	UUFjnOtg2yKmTy2Fk/6FqrcLlaWBxEQiHFV6R0vim2+/eRnywkREx2iq+EZfuI89kGhpwrnTAJF
	dblfwdNxWeDtkz2Mz2jsjvZ+M1XwTnBdcNgY+7hxy9sCZv6fHFogk5EyjRRn6FjZQ=
X-Received: by 2002:a05:600c:1386:b0:490:6ab:406a with SMTP id 5b1f17b1804b1-49042be7044mr34931885e9.8.1779490914815;
        Fri, 22 May 2026 16:01:54 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:54 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	ardb@kernel.org,
	linusw@kernel.org,
	krzk+dt@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v4 11/12] crypto: atmel-sha204a - integrate into core management tracking
Date: Fri, 22 May 2026 23:01:33 +0000
Message-Id: <20260522230134.32414-12-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260522230134.32414-1-l.rubusch@gmail.com>
References: <20260522230134.32414-1-l.rubusch@gmail.com>
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
 drivers/crypto/atmel-sha204a.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 0c5b5cdbfcbc..86a68f2a27e0 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -177,9 +177,15 @@ static int atmel_sha204a_probe(struct i2c_client *client)
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
@@ -192,15 +198,26 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
 	if (ret) {
 		dev_err(&client->dev, "failed to register RNG (%d)\n", ret);
-		return ret;
+		goto err_list_del;
 	}
 
 	ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
 	if (ret) {
 		dev_err(&client->dev, "failed to create sysfs group (%d)\n", ret);
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
 
@@ -208,9 +225,11 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
+	atmel_i2c_deactivate_client(i2c_priv);
+
 	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
-	atmel_i2c_flush_queue();
+	atmel_i2c_unregister_client(i2c_priv);
 
 	kfree((void *)i2c_priv->hwrng.priv);
 }
@@ -245,7 +264,6 @@ static int __init atmel_sha204a_init(void)
 
 static void __exit atmel_sha204a_exit(void)
 {
-	atmel_i2c_flush_queue();
 	i2c_del_driver(&atmel_sha204a_driver);
 }
 
-- 
2.39.5

