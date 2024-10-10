Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB88919DF8D;
	Thu, 10 Oct 2024 19:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589706; cv=none; b=Kws93cnXe124BMSksqn86e5rCpJN0wNsG/bhm6Ssg6ts2tzHn29LGaYkypfFirnkukNJ7qh8vD3sYUCwUrS6nBT3y8qjR7jT8R9BIevcCR/lqEzOfMGg/h7BypTLTbUceFZSqWPe2A5A9cK08ismQ9J2W1AtrGGyr0ByySQbH/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589706; c=relaxed/simple;
	bh=wU61fSEYGDupU27pSHrnq72iytvQJFsnqW9ld6Fn7FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrpBj30nWcjr05kTt1Q2gg9eJyZFww/NOiEKfxS/LPg+PB3JLkTNwTOTyIHZdVs+/6H3z1tug4esaPV90kWJFXsmqnwHCsfT1Aqa3fI0NaYq+K407TT+V+dNhJnj80czztIwgbAwPoMtlWZNx83M0Vhb0xpQPuK579RwV5Zjzkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I2V6ov9B; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I2V6ov9B"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2e2dc61bc41so667802a91.1;
        Thu, 10 Oct 2024 12:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728589704; x=1729194504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1GuWNsXFGOMo3lH7BBn0cMg8y1+dST6iH9D48T7Y7L0=;
        b=I2V6ov9B62kS2kU2Px/5lYJjGfOdtR5F6afgk9Qpjoj4gQQHzU0fjUWLPLzWht2Sdk
         RuSDOA+IGBh/llwumPF0E4fZdovTuT/RomHWdj1907CqJygJ32Jm9JjT6EJZ3WjNKveR
         UpNiYYd1dZuu+qQTofIu+MeYZWXacY+YH/O24PtmyVBdEbQAkdckEWQBdURlzfobFIfm
         2n5fg9yJba3W55imbgO87417aOOumF9cqLrteV3MRwayIxkzuXmY0N9LvvjjeGJkT72o
         4UKwwnYgGrHvuooa1hYsiQ+9qmHvhIW8zxgWxeMoZU7JZGs8bv9Fqt3SA4kDUprCx4fR
         HHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728589704; x=1729194504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1GuWNsXFGOMo3lH7BBn0cMg8y1+dST6iH9D48T7Y7L0=;
        b=MLRiLUfeLnquQ66qmC2UATTuY/kMEFRNbXQS3sIR3TcPr9y01lclOoMqvZUMJpNqFr
         5hNXQ/+NPjbc7xd8AqmvvY/gv/e8djCEcrFWDtFdHJaLO0VESe+HEvWNmlaIEBwhjrp9
         xD6ArMy50xvUaA4kpSrWygwAq3Axj+KeHlU2ue4PsEUI3pMTtK1LmTc7SbbTNQY/eDue
         0KvxschEUvbSY1vyn5vGO2P2rmexsheRiTK+3OCI8atwgCVp2Xv4ulxcS0ZOpv8B7AMQ
         hgKEEy8jVOQgb+/OXMFzTs0WSVIixxVoW7+qZvYOW9ppWTnLSjkLaesid6fgFtZwtbg+
         6F/g==
X-Forwarded-Encrypted: i=1; AJvYcCWiP2JO/NjtsGE5ptfGsMd4YYZv8f7xshtzAOZYUOcq05/sJvgjCCrvqjANgA6Rh+eKfKFQuFRJx3+J7Wo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiICxwC1LsLgRG/BiN6OcMrJsoKVF63736Gjpg0+DFwYDVMqr6
	w0ysWkWHw5c9Srj4DwwsUlLk3tBiDwnJKHbn7nSGGD1ig0CZTLZFv5ED34Ef
X-Google-Smtp-Source: AGHT+IEUzVhzN8lIO9E9En17wfZlXO6vQ00QyNPD3VNk3rneoK/PUubQBgDKvqLnSj+4Urut3JGkhw==
X-Received: by 2002:a17:90a:eacf:b0:2e2:da8d:2098 with SMTP id 98e67ed59e1d1-2e2f0a170e4mr371006a91.2.1728589704048;
        Thu, 10 Oct 2024 12:48:24 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2d5df0ce8sm1754381a91.14.2024.10.10.12.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 12:48:23 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] crypto: crypto4xx_core: use devm in probe
Date: Thu, 10 Oct 2024 12:48:21 -0700
Message-ID: <20241010194821.18970-2-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241010194821.18970-1-rosenp@gmail.com>
References: <20241010194821.18970-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allows removing some gotos and simplifying remove a bit.

Tested Cisco MX60W.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 39 ++++++++++------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 5ebbf83b4f3e..4e9aa1c37fc7 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -653,8 +653,6 @@ static void crypto4xx_stop_all(struct crypto4xx_core_device *core_dev)
 	crypto4xx_destroy_pdr(core_dev->dev);
 	crypto4xx_destroy_gdr(core_dev->dev);
 	crypto4xx_destroy_sdr(core_dev->dev);
-	kfree(core_dev->dev);
-	kfree(core_dev);
 }
 
 static u32 get_next_gd(u32 current)
@@ -1368,16 +1366,17 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 
 	of_node_put(np);
 
-	core_dev = kzalloc(sizeof(struct crypto4xx_core_device), GFP_KERNEL);
+	core_dev = devm_kzalloc(
+		&ofdev->dev, sizeof(struct crypto4xx_core_device), GFP_KERNEL);
 	if (!core_dev)
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, core_dev);
 	core_dev->ofdev = ofdev;
-	core_dev->dev = kzalloc(sizeof(struct crypto4xx_device), GFP_KERNEL);
-	rc = -ENOMEM;
+	core_dev->dev = devm_kzalloc(
+		&ofdev->dev, sizeof(struct crypto4xx_device), GFP_KERNEL);
 	if (!core_dev->dev)
-		goto err_alloc_dev;
+		return -ENOMEM;
 
 	/*
 	 * Older version of 460EX/GT have a hardware bug.
@@ -1396,7 +1395,9 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	core_dev->dev->core_dev = core_dev;
 	core_dev->dev->is_revb = is_revb;
 	core_dev->device = dev;
-	mutex_init(&core_dev->rng_lock);
+	rc = devm_mutex_init(&ofdev->dev, &core_dev->rng_lock);
+	if (rc)
+		return rc;
 	spin_lock_init(&core_dev->lock);
 	INIT_LIST_HEAD(&core_dev->dev->alg_list);
 	ratelimit_default_init(&core_dev->dev->aead_ratelimit);
@@ -1424,12 +1425,12 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 
 	/* Register for Crypto isr, Crypto Engine IRQ */
 	core_dev->irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
-	rc = request_irq(core_dev->irq, is_revb ?
-			 crypto4xx_ce_interrupt_handler_revb :
-			 crypto4xx_ce_interrupt_handler, 0,
-			 KBUILD_MODNAME, dev);
+	rc = devm_request_irq(&ofdev->dev, core_dev->irq,
+			      is_revb ? crypto4xx_ce_interrupt_handler_revb :
+					crypto4xx_ce_interrupt_handler,
+			      0, KBUILD_MODNAME, dev);
 	if (rc)
-		goto err_request_irq;
+		goto err_iomap;
 
 	/* need to setup pdr, rdr, gdr and sdr before this */
 	crypto4xx_hw_init(core_dev->dev);
@@ -1438,25 +1439,17 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	rc = crypto4xx_register_alg(core_dev->dev, crypto4xx_alg,
 			       ARRAY_SIZE(crypto4xx_alg));
 	if (rc)
-		goto err_start_dev;
+		goto err_iomap;
 
 	ppc4xx_trng_probe(core_dev);
 	return 0;
 
-err_start_dev:
-	free_irq(core_dev->irq, dev);
-err_request_irq:
-	irq_dispose_mapping(core_dev->irq);
 err_iomap:
 	tasklet_kill(&core_dev->tasklet);
 err_build_sdr:
 	crypto4xx_destroy_sdr(core_dev->dev);
 	crypto4xx_destroy_gdr(core_dev->dev);
 	crypto4xx_destroy_pdr(core_dev->dev);
-	kfree(core_dev->dev);
-err_alloc_dev:
-	kfree(core_dev);
-
 	return rc;
 }
 
@@ -1467,13 +1460,9 @@ static void crypto4xx_remove(struct platform_device *ofdev)
 
 	ppc4xx_trng_remove(core_dev);
 
-	free_irq(core_dev->irq, dev);
-	irq_dispose_mapping(core_dev->irq);
-
 	tasklet_kill(&core_dev->tasklet);
 	/* Un-register with Linux CryptoAPI */
 	crypto4xx_unregister_alg(core_dev->dev);
-	mutex_destroy(&core_dev->rng_lock);
 	/* Free all allocated memory */
 	crypto4xx_stop_all(core_dev);
 }
-- 
2.46.2

