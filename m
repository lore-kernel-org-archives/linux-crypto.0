Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321183A6B8F
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625857; cv=none; b=Fvu0xaF6b6sD0iR+cIEH2U7z26JXIgazR0uZ5fpOdstlD9dAjh7ukiV3PC3GL70hr+4WQdnhgePsx3oUNmjGPx2eL25erckz74zZsRxc75V2ROX+I7zmOsJvrIMSUa2jaDGLspDIU6dAoUFooJ2L/6N+Uu5qFqB2kf4jkwoc0Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625857; c=relaxed/simple;
	bh=05+QPQQ8N2qADDVDGXqp4BROqhMTJEI1EdOTxvGr640=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IS2SajPKDFSL0iDh4gjv4Qa8zpw+OBJCNwnu62n3fyxP56SPHfc8DdVH+Qkvz/oXFnZpWUFapUizDrK8KsAuv/t7WZu/NMtpMGk6hsX5yNKlc/yNiY7ZjK992lBxUQilhEROpOaGYMcJVaTIuD86wHgCzu2Wbf08AF66cCvGDFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NxjO9uGF; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NxjO9uGF"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4891f6b6388so1911655e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625853; x=1779230653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FW3Lz2dkj/BvPnoX47K8raPJn2eGQ3HHuGdfSzXvUi0=;
        b=NxjO9uGFBC3wqElNNP/0CeMxivuVDHyT+2Jtb/6yZo2Mm4QVRpRL6jGbl+rc0D6Zue
         CAWTd76XWiQXvmEifkyqM5jL7q96y7+Ref5ShcXDLjeWLyyUu9BtvlyeBW45I66/UGe5
         3u3fxQGKyLjnu+6ihVYHQr0CUCZcNgBokvoUkUssHbPTcQmZbonJcW7NopgW78Ut4enH
         Hpi3V+sZWtVeQYc9RffMloBvYy4QD4iLvJ3MwKJR17Q8ZjoWhI67F2mpQqMMdx403ktl
         c2CHDgTfXrh2yxsZoBJnwEW6rUwjRdkEpyS19aMGRNAcRForKrWGLx5C0uhiTwI64z4D
         XcNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625853; x=1779230653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FW3Lz2dkj/BvPnoX47K8raPJn2eGQ3HHuGdfSzXvUi0=;
        b=cBIgfcySVLyNxblweI48ey5yB6ZRoJebVJog4gUaOXJEyL0/Z59pAXYX1rZ94i62gF
         /UvSpjCPywFD5UioDkgl0X8rnrIEJNOiLjYql/RPC8ajpBNJM1vXAokwkKoQShGRC23O
         qQniyffVfI9KxlDY0e51jwPirNNCG782BFOo2IpN8L08huV/4Y/7sn/LnaJVPcWl0UsE
         /fCXXBUFibfpxS1lZJBE90JlJvmFt6WFqPRPhkiy0YJBYUd3RXODa8sV9PeXDwL5fVyQ
         LzG1qeIaj0oTP1icXS/MIl4KBkGZ/TZK0LVZhq62QezP1s9L3da/DJHccCj/FpSJX/JL
         f9dA==
X-Gm-Message-State: AOJu0YwihQ8tGT7gUHdB337HAl1V2FlVnCUG3aVxf3B7ptqFHCxkTnpv
	2P3MetTrYtJvGtmiZaY81sQ4xZ8wSOPEpkyjRCJmQTqIw5kL1q/A5N0N
X-Gm-Gg: Acq92OEE9uNw/ha4AA7VwpsF8PaA/jUWH3xmFAoNqgUNxED+7b38rllm46G25aM4kob
	8eiow80tu/v52ZctMvih24b2X1HZGEwx0p/b2ZvqAJwNbE8tMKdGNppZrJkh6hcdfp5ffAq+uf4
	hp1hEIMJ+cdZbP2W/0Z/takt8oUWlux/US2mE0dO2+j9pQ+dV+++6QFOF0PHAimfwoYWY+CyaEF
	cCARvtXp49hYUCWeqT5GV5IzLbWBu5TzBGyBldgJJ3Ia51Gkwa0KhQIi2o7EwsjB89lvafvCHIn
	2xq/tvqgaGr4wZvJXhVKPQr4eBk0d2ocxa7EwFmgvLFLhu91jmBH6nPVR7EhsTjsSOqVHbcvJVq
	zXwRMTG4MErfBWAcVQLncuXBMDG8uzFeVQYf6fPHzxMUjt37EQ/SPinnL1rl42YBeXV3BdmOQGI
	NrNcUQtbuA6jEiH9GCSqPfuWLyH9WNv3641qtakABuD3KLb+BbRUlNmoKWXrmpN/WZv5LdooBAo
	A==
X-Received: by 2002:a05:600c:3149:b0:485:f1d6:2b1d with SMTP id 5b1f17b1804b1-48fc99a8c2emr4963905e9.0.1778625853300;
        Tue, 12 May 2026 15:44:13 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:12 -0700 (PDT)
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
Subject: [PATCH 05/12] crypto: atmel - move RNG support into common i2c core
Date: Tue, 12 May 2026 22:43:42 +0000
Message-Id: <20260512224349.64621-6-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260512224349.64621-1-l.rubusch@gmail.com>
References: <20260512224349.64621-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the hardware RNG implementation from atmel-sha204a into the
shared atmel-i2c core.

The ATSHA204(A) and ATECC devices provide compatible RANDOM commands
through the common Atmel I2C interface. Consolidate the RNG handling in
the core driver and provide a shared atmel_i2c_register_rng() helper for
registering the hwrng device.

This removes duplicated RNG code from atmel-sha204a and enables RNG
support for other compatible Atmel devices, including the ECC family.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     |  12 ++++
 drivers/crypto/atmel-i2c.c     |  93 ++++++++++++++++++++++++++
 drivers/crypto/atmel-i2c.h     |   4 +-
 drivers/crypto/atmel-sha204a.c | 115 +++++----------------------------
 4 files changed, 123 insertions(+), 101 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 7793f7b4e97e..67fa5975fa7f 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -306,6 +306,13 @@ static int atmel_ecc_probe(struct i2c_client *client)
 		      &atmel_i2c_mgmt.i2c_client_list);
 	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
+	/* register rng */
+	ret = atmel_i2c_register_rng(i2c_priv, &client->dev);
+	if (ret) {
+		dev_err(&client->dev, "failed to register hw_random\n");
+		goto err_list_del;
+	}
+
 	/* register algorithms */
 	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 	if (ret) {
@@ -349,6 +356,11 @@ static void atmel_ecc_remove(struct i2c_client *client)
 	atmel_i2c_flush_queue();
 
 	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
+
+	if (i2c_priv->hwrng.priv) {
+		kfree((void *)i2c_priv->hwrng.priv);
+		i2c_priv->hwrng.priv = 0;
+	}
 }
 
 static const struct atmel_i2c_of_match_data atecc508a_match_data = {
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 7fa7cf9ab3c1..d451017171d8 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -208,6 +208,99 @@ int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 }
 EXPORT_SYMBOL(atmel_i2c_init_ecdh_cmd);
 
+static void atmel_i2c_rng_done(struct atmel_i2c_work_data *work_data,
+			       void *areq, int status)
+{
+	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
+	struct hwrng *rng = areq;
+
+	if (status)
+		dev_warn_ratelimited(&i2c_priv->client->dev,
+				     "i2c transaction failed (%d)\n",
+				     status);
+
+	rng->priv = (unsigned long)work_data;
+	atomic_dec(&i2c_priv->tfm_count);
+}
+
+static int atmel_i2c_rng_read_nonblocking(struct hwrng *rng, void *buf,
+					  size_t max)
+{
+	struct atmel_i2c_client_priv *i2c_priv = container_of(rng,
+							      struct atmel_i2c_client_priv,
+							      hwrng);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
+	struct atmel_i2c_work_data *work_data;
+
+	/* keep maximum 1 asynchronous read in flight at any time */
+	if (!atomic_add_unless(&i2c_priv->tfm_count, 1, 1))
+		return 0;
+
+	if (rng->priv) {
+		work_data = (struct atmel_i2c_work_data *)rng->priv;
+		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+		memcpy(buf, &work_data->cmd.data[RSP_DATA_IDX], max);
+		rng->priv = 0;
+	} else {
+		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
+		if (!work_data) {
+			atomic_dec(&i2c_priv->tfm_count);
+			return -ENOMEM;
+		}
+		work_data->ctx = i2c_priv;
+		work_data->client = i2c_priv->client;
+
+		max = 0;
+	}
+
+	atmel_i2c_init_random_cmd(&work_data->cmd, &data->timings);
+	atmel_i2c_enqueue(work_data, atmel_i2c_rng_done, rng);
+
+	return max;
+}
+
+static int atmel_i2c_rng_read(struct hwrng *rng, void *buf, size_t max,
+			      bool wait)
+{
+	struct atmel_i2c_client_priv *i2c_priv = container_of(rng,
+							      struct atmel_i2c_client_priv,
+							      hwrng);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
+	struct atmel_i2c_cmd cmd;
+	int ret;
+
+	if (!wait)
+		return atmel_i2c_rng_read_nonblocking(rng, buf, max);
+
+	atmel_i2c_init_random_cmd(&cmd, &data->timings);
+
+	ret = atmel_i2c_send_receive(i2c_priv->client, &cmd);
+	if (ret)
+		return ret;
+
+	max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+	memcpy(buf, &cmd.data[RSP_DATA_IDX], max);
+
+	return max;
+}
+
+int atmel_i2c_register_rng(struct atmel_i2c_client_priv *i2c_priv,
+			   struct device *dev)
+{
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
+
+	memset(&i2c_priv->hwrng, 0, sizeof(i2c_priv->hwrng));
+
+	i2c_priv->hwrng.name = dev_name(dev);
+	i2c_priv->hwrng.read = atmel_i2c_rng_read;
+
+	if (data->needs_legacy_hwrng)
+		i2c_priv->hwrng.quality = data->needs_legacy_hwrng;
+
+	return devm_hwrng_register(dev, &i2c_priv->hwrng);
+}
+EXPORT_SYMBOL(atmel_i2c_register_rng);
+
 /*
  * After wake and after execution of a command, there will be error, status, or
  * result bytes in the device's output register that can be retrieved by the
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 5224a62c16c9..5f6c9ff0cf64 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -66,7 +66,7 @@ struct atmel_i2c_max_exec_timings {
 };
 
 struct atmel_i2c_of_match_data {
-	const unsigned short *legacy_hwrng;
+	const unsigned short needs_legacy_hwrng;
 	struct atmel_i2c_max_exec_timings timings;
 };
 
@@ -209,6 +209,8 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid,
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey,
 			    const struct atmel_i2c_max_exec_timings *timings);
+int atmel_i2c_register_rng(struct atmel_i2c_client_priv *i2c_priv,
+			   struct device *dev);
 
 struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap);
 void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index febf9891b167..ae24d8fbabf9 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -19,88 +19,6 @@
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
-/*
- * According to review by Bill Cox [1], the ATSHA204 has very low entropy.
- * [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
- */
-static const unsigned short atsha204_quality = 1;
-
-static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
-				   void *areq, int status)
-{
-	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
-	struct hwrng *rng = areq;
-
-	if (status)
-		dev_warn_ratelimited(&i2c_priv->client->dev,
-				     "i2c transaction failed (%d)\n",
-				     status);
-
-	rng->priv = (unsigned long)work_data;
-	atomic_dec(&i2c_priv->tfm_count);
-}
-
-static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *buf,
-					      size_t max)
-{
-	struct atmel_i2c_client_priv *i2c_priv = container_of(rng,
-							      struct atmel_i2c_client_priv,
-							      hwrng);
-	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
-	struct atmel_i2c_work_data *work_data;
-
-	/* keep maximum 1 asynchronous read in flight at any time */
-	if (!atomic_add_unless(&i2c_priv->tfm_count, 1, 1))
-		return 0;
-
-	if (rng->priv) {
-		work_data = (struct atmel_i2c_work_data *)rng->priv;
-		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
-		memcpy(buf, &work_data->cmd.data[RSP_DATA_IDX], max);
-		rng->priv = 0;
-	} else {
-		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
-		if (!work_data) {
-			atomic_dec(&i2c_priv->tfm_count);
-			return -ENOMEM;
-		}
-		work_data->ctx = i2c_priv;
-		work_data->client = i2c_priv->client;
-
-		max = 0;
-	}
-
-	atmel_i2c_init_random_cmd(&work_data->cmd, &data->timings);
-	atmel_i2c_enqueue(work_data, atmel_sha204a_rng_done, rng);
-
-	return max;
-}
-
-static int atmel_sha204a_rng_read(struct hwrng *rng, void *buf, size_t max,
-				  bool wait)
-{
-	struct atmel_i2c_client_priv *i2c_priv = container_of(rng,
-							      struct atmel_i2c_client_priv,
-							      hwrng);
-	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
-	struct atmel_i2c_cmd cmd;
-	int ret;
-
-	if (!wait)
-		return atmel_sha204a_rng_read_nonblocking(rng, buf, max);
-
-	atmel_i2c_init_random_cmd(&cmd, &data->timings);
-
-	ret = atmel_i2c_send_receive(i2c_priv->client, &cmd);
-	if (ret)
-		return ret;
-
-	max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
-	memcpy(buf, &cmd.data[RSP_DATA_IDX], max);
-
-	return max;
-}
-
 static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u8 *otp)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
@@ -169,7 +87,6 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
 	const struct atmel_i2c_of_match_data *data;
-	const unsigned short *quality;
 	int ret;
 
 	ret = atmel_i2c_probe(client);
@@ -193,25 +110,16 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 		      &atmel_i2c_mgmt.i2c_client_list);
 	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
-	/* register rng */
-	memset(&i2c_priv->hwrng, 0, sizeof(i2c_priv->hwrng));
-
-	i2c_priv->hwrng.name = dev_name(&client->dev);
-	i2c_priv->hwrng.read = atmel_sha204a_rng_read;
-
-	quality = i2c_priv->data->legacy_hwrng;
-	if (quality)
-		i2c_priv->hwrng.quality = *quality;
-
-	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
+	ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
 	if (ret) {
-		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
+		dev_err(&client->dev, "failed to register sysfs entry\n");
 		goto err_list_del;
 	}
 
-	ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
+	/* register rng */
+	ret = atmel_i2c_register_rng(i2c_priv, &client->dev);
 	if (ret) {
-		dev_err(&client->dev, "failed to register sysfs entry\n");
+		dev_err(&client->dev, "failed to register hw_random\n");
 		goto err_list_del;
 	}
 
@@ -234,9 +142,12 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
 	atmel_i2c_flush_queue();
 
-	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
+	if (i2c_priv->hwrng.priv) {
+		kfree((void *)i2c_priv->hwrng.priv);
+		i2c_priv->hwrng.priv = 0;
+	}
 
-	kfree((void *)i2c_priv->hwrng.priv);
+	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 }
 
 static const struct atmel_i2c_of_match_data atsha204_match_data = {
@@ -246,7 +157,11 @@ static const struct atmel_i2c_of_match_data atsha204_match_data = {
 		.max_exec_time_read = 4,
 		.max_exec_time_write = 42,
 	},
-	.legacy_hwrng = &atsha204_quality,
+	/*
+	 * According to review by Bill Cox [1], the ATSHA204 has very low entropy.
+	 * [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
+	 */
+	.needs_legacy_hwrng = 1,
 };
 
 static const struct atmel_i2c_of_match_data atsha204a_match_data = {
-- 
2.53.0

