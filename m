Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB683BFE4F
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223705; cv=none; b=pMMfUFKahEBNIn+YGtZjmq3pzbp6lPq8VnUQ/sctgls6WB4VyRO+xHNXHmvBCgtjBFk9GSDOveFmuz2A6DugwafOfbaZ6WQpFerOhi5hZwdV0QPgyrhfofpNMU0MMPss6RfVX8Gy74ZDAnhaJ22d//1I1N4EQSiv6iHf3nQUV+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223705; c=relaxed/simple;
	bh=m0BO1BJp7UiRiIUF0q/PMhak4m/3xBhMeT8SNCZ26Ow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lfx7HCZaaxJkBSdkysvKCQY/+beojNcQCOz9yNXZmIinaj6sr/s856xY6IQbJsNCD6Wvo29ovHWcvJlyyazxC2LG6ug2Si566ad70epdx2JeRk3PmnRBNbdK6eAoSPFn0fRhGtR2KZ3gxDX2mXJkaIIh6aD9YBF/sdgys5kgFGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bOV0P4GI; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bOV0P4GI"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-44c44af71f8so494201f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223699; x=1779828499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CeQLtV3ZJs9NMCaLxxe8lNWCUSJcJ/X+OKLcCSGP6Uw=;
        b=bOV0P4GImCXLytP0eBSoMlpSuoSGpGWwPGSeZHXaHRCLSq175q41SaSba54ZS5HeVH
         6G/T5O4Ge66ezr20J1G1AyCNeSIysE3oko6PkgTShUIXpxfck7loVSCs/5C/in8hoV41
         LNGNaVcfAVq7Ln6a41Di7zmujj8yqB26MBMjkenWj6uQl+XbSiLCoJhzFHd896H8kUwX
         TRylbwKQHc2mHHHKDA0CeJtSYS/84lW5fzmJD24U9jQpu9pccwjimXFqv0eG2PvYRSHx
         Xeo8FTWffAqebl8g7DrbflzaKxWhV6Ww/VyuJbcJbhYPFs1mw79Pz7XeDYRNByp6e4+Y
         Y90A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223699; x=1779828499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CeQLtV3ZJs9NMCaLxxe8lNWCUSJcJ/X+OKLcCSGP6Uw=;
        b=Xug3x5pPgaC9O1XxAhmhmsZemtZGL3pYLdECmS1vo+8Ynf3Dj7u21Le4eDBFHWzV0b
         8JpH2U0JzlcLhQvaVa2YlMp7CPXZl9DiCdWmmeA4ue/aydGu+r3A2Q4cV2BJZl6dBLdU
         egj06yDIHCOgf1dSJ+ajVsfPbr71dB6qsLkWKIyYfZqTzI1IT3pagdowg2VKTk24p2WM
         4sag++dGhFLCjN4MKlZZELVUYu28X/Y70Y35MJkFzVg03C00t+O4JGF9DbYNr22ZNAzF
         Fv6o7WRS56CYuJk/1ypOSyCzoIh0CAthkr5pWzZAmNiH3+YfoE9cXmf8gK12O89lttOx
         hGzg==
X-Gm-Message-State: AOJu0YzmWg0YWuGbMImwXDeDWCi0dsTQ5X+3JXasTKfMI76Xd4MQ28pA
	LD+DZKR4H8zBVmi2YiEaprWX0J/cwyJUcIWDcxGzjDsweXtDcDRpYQ0u
X-Gm-Gg: Acq92OES6QCUzLkPDb8ZIcOLq4s3XJ7nTmF+mThMps+aGJBIeaYE8HcO2AUs+VN4CZD
	yMGBCsGvTwKLKnaqzIyyfbIRRJoYWML3ym7W8Oj2EM8xzI4QupjXIMjLr9P6xOIr+W+A47c02CD
	g5qyEML97txL/U8eH9f1rBxdTRra0e/Y4gjZiHOud4Tk0xZX7m5fwRIeCHJoQ871qD4iQfzD6FW
	es0CJSqsTJYvNIWYsHALXc6z3eRb2mNEew5kpI5pqKmfL0wE4nF7z3Jnmj3hROnszXt1juljR7H
	ShrIi80BjQIon/XM2iGxqi60wcG6XQtFKeLKK0VhgaNhzOQwSlCKHYzTxMaIZ39E1MtZkHf9zO6
	XaS5vm4Am7m3ixDEMOCAArAXfLLXMimNobIX+YbsA19WO+tNScjTlhad3U89jm/0d0nSs+U5UFk
	krVSR6d6S9iPxceKqxEMsQHIcTq+40l6A1imsBfEmtQM/Nwi8N92fMIVx9aU3THpg=
X-Received: by 2002:a05:600c:4fc5:b0:489:1dc6:d6e with SMTP id 5b1f17b1804b1-48fe5fcf406mr148338135e9.1.1779223699130;
        Tue, 19 May 2026 13:48:19 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4dac000sm356457755e9.0.2026.05.19.13.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 13:48:18 -0700 (PDT)
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
Subject: [PATCH v2 10/12] crypto: atmel-sha204a - integrate into core management tracking
Date: Tue, 19 May 2026 20:48:01 +0000
Message-Id: <20260519204803.17034-11-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260519204803.17034-1-l.rubusch@gmail.com>
References: <20260519204803.17034-1-l.rubusch@gmail.com>
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
before any local hardware cleanup runs, and call
atmel_i2c_unregister_client() at the end of the sequence to safely drop the
node from global tracking.

No functional change intended beyond improved lifecycle handling.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 3853d2b95449..38a269186e2a 100644
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
 
@@ -201,12 +220,13 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
-	atmel_i2c_flush_queue();
+	atmel_i2c_deactivate_client(i2c_priv);
 
+	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
 	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
-
 	kfree((void *)i2c_priv->hwrng.priv);
+
+	atmel_i2c_unregister_client(i2c_priv);
 }
 
 static const struct of_device_id atmel_sha204a_dt_ids[] = {
@@ -239,7 +259,6 @@ static int __init atmel_sha204a_init(void)
 
 static void __exit atmel_sha204a_exit(void)
 {
-	atmel_i2c_flush_queue();
 	i2c_del_driver(&atmel_sha204a_driver);
 }
 
-- 
2.39.5

