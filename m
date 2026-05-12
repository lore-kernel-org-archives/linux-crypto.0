Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E703A255F
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625851; cv=none; b=syyFx+Rb8aZSOYo7MwSa7TeGjfFMtSeWUN69FAfnNDjZrDVz5a1z7nJqpbE6I3uuHHeUimpbyRESl5vqym8liC3UA6xGDGlpN0sQsF6D/d5DAjrbrIviC42Nk7qfH0vWM04YJoWcy/zGJVitCwXgwaNC/IoPrVzMPOLV+9nwsAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625851; c=relaxed/simple;
	bh=CAJ0dYA0gL3B6kPJiD8HFdKtM9CzlZN+ytYYY5F+eeA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s/gNUeUskKl4CRzPwmdDjT8tcyQZTXsE6fqiCkcUUWXkGO0416iV8LS/00PhxYbwlNgURMyoyNaHI2BkOwHFhULYvUcdfpslOzoiMixf3ZcWU7HKcG6O+BnjITG0bogq29Q5jwLH7pY4zlPFR9SzZHkMwbt8Vc3OgcjrKuJzMTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lvUweJ+y; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvUweJ+y"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d7828221bso303397f8f.3
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625849; x=1779230649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61M3DMNG+oWQqxSuQprE2URgrjy5u8AgK8OgQ9rm0Ps=;
        b=lvUweJ+yu9Vx4xjOCdzNj9OXFq6/F6b1stholp5nxVl5W7lp7Dx7vifMZ8GzatvWnB
         lVM1gy+cgLc8Nl+rCZO5OfVUEE4jwZx2eA8pdSWSJfSQKr2S4le1ew01gurM3qPeAGaZ
         uo0WsOIp3JgHwJFym6/iOSM4OdAlfLhd/TL43G+PBJCgJq1ED0MnMGmTjKV+Si00esB9
         +1KpCrCxS8YGvKV42xu9lRU3UKD1QfRdMxwR6gC8N7murcKs0SordNUMB8R43pzu39tX
         swfG9UkykUG1wJA9rfL0fHewqgl0AoTSmSw7k9JWO+jstXGh5a50FbXuwKAgLRn8zDVQ
         GAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625849; x=1779230649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=61M3DMNG+oWQqxSuQprE2URgrjy5u8AgK8OgQ9rm0Ps=;
        b=RiEhRCtrJ3ZeJINJ4wdPtdPNPowjKFIqJk1qQM0o8Afvh2J2zYMOhaOYH8LzyMWEpF
         1+MDIg8Zq+pRQR2GfTZVX0r/m/dmo9+AQ/u75Qga3X10/RMsFu1EXvWLTqhChkumqERl
         vL0KVVm2yHDMoSOXkXiYenLVkCU+Y3cXcwuVIDbplyFiEhiXGyIR74seQd983MzBNpRV
         LdKDDatb/4RI44RNJvB7YU/G12bmhlLOWqJKxaXlrfKLD8spnkIZFwmxXjJScyGGsWtq
         qO2xMMuJ0kd+qmqFHgeQN4lS8BFnJIzx6DilshpPfucHrJaE0ZLXXohW+mjNzkmmknrJ
         DNiQ==
X-Gm-Message-State: AOJu0Yw5e5UlklgwxIGxZVvTvMrKrb05oVwgy0ecdWrTbjCITFcyD6jS
	0KQHpuLIc1xXt6g59LMNsWpDnxCJzvCGoihsLYo8v1vhRMSiRPcE5Ek0
X-Gm-Gg: Acq92OEoWpVdfqEDHz3PNB7klNkzOGtwm96px/bc/gyBTx6ovdOOyjn3/m5YZCe+4nC
	3xP9gJ8QnGhoR9Xtt5R2yj2FkLZolkeBFD4Dq5tm9BY6l0gxaIGm5xi2MqtFxH55egnUyZZvFZf
	qi5CPIrHbFvmDnCXCMt0fcQrl2f3vjeyAefVb7CdeTaL4H+squ4MVOXQtVEHS++98TwRl+rXghR
	IIAtswXk60wbZJgmkiT8m+6m3sbcPcaOBO444upqezr+54jmGPKM77lSw93fCjo1QqmuBWCUGkD
	L5ultq21JgIUcnSBYACe8CiIWPNLQhD9I3fohrcwQEEi7shJ1tjyjhETNCSMxmCQqnCOB6+TvpC
	fJuUeAe99dns2Tg7Swr6CmiqnYP6uwK4EWC4EuZXwrYpKdghtge9y8V6YIC3ZyYeqF/GnaR0+Aw
	bxjUu7CE8n8r/iA8yl0BIfmWjAYpmvIKxr1O6vMFTodXlCBD9YS2H2h8u5FZVjccbo4kn97bts/
	w==
X-Received: by 2002:a05:600c:3b16:b0:48a:79da:c87 with SMTP id 5b1f17b1804b1-48fc9a51444mr4274175e9.8.1778625848430;
        Tue, 12 May 2026 15:44:08 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:08 -0700 (PDT)
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
Subject: [PATCH 01/12] crypto: atmel - introduce shared I2C client management
Date: Tue, 12 May 2026 22:43:38 +0000
Message-Id: <20260512224349.64621-2-l.rubusch@gmail.com>
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

Introduce a shared I2C client management infrastructure in the
atmel-i2c core and convert the atmel-ecc and atmel-sha204a drivers
to use it.

Replace the driver-local atmel_ecc_driver_data structure with the
common atmel_i2c_mgmt instance, providing a shared client list and
locking for compatible Atmel secure element devices. Add a common
atmel_i2c_unregister_client() helper to centralize client removal
handling.

Refactor both drivers to use module_i2c_driver() and move duplicated
client list handling into the shared infrastructure. Probe and remove
paths are updated accordingly, including consistent error unwinding
for client registration failures.

Subsequent patches will build on the shared client infrastructure.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     | 58 ++++++++++++++--------------------
 drivers/crypto/atmel-i2c.c     | 15 +++++++++
 drivers/crypto/atmel-i2c.h     |  5 ++-
 drivers/crypto/atmel-sha204a.c | 38 ++++++++++++----------
 4 files changed, 65 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 3738a4eb8701..cba4238735cc 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -23,8 +23,6 @@
 #include <crypto/kpp.h>
 #include "atmel-i2c.h"
 
-static struct atmel_ecc_driver_data driver_data;
-
 /**
  * struct atmel_ecdh_ctx - transformation context
  * @client     : pointer to i2c client device
@@ -209,14 +207,14 @@ static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 	int min_tfm_cnt = INT_MAX;
 	int tfm_cnt;
 
-	spin_lock(&driver_data.i2c_list_lock);
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 
-	if (list_empty(&driver_data.i2c_client_list)) {
-		spin_unlock(&driver_data.i2c_list_lock);
+	if (list_empty(&atmel_i2c_mgmt.i2c_client_list)) {
+		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 		return ERR_PTR(-ENODEV);
 	}
 
-	list_for_each_entry(i2c_priv, &driver_data.i2c_client_list,
+	list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
 			    i2c_client_list_node) {
 		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
 		if (tfm_cnt < min_tfm_cnt) {
@@ -232,7 +230,7 @@ static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 		client = min_i2c_priv->client;
 	}
 
-	spin_unlock(&driver_data.i2c_list_lock);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
 	return client;
 }
@@ -319,27 +317,34 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
 	ret = atmel_i2c_probe(client);
 	if (ret)
-		return ret;
+		goto done;
 
 	i2c_priv = i2c_get_clientdata(client);
 
-	spin_lock(&driver_data.i2c_list_lock);
+	/* add to client list */
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
-		      &driver_data.i2c_client_list);
-	spin_unlock(&driver_data.i2c_list_lock);
+		      &atmel_i2c_mgmt.i2c_client_list);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
+	/* register algorithms */
 	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 	if (ret) {
-		spin_lock(&driver_data.i2c_list_lock);
-		list_del(&i2c_priv->i2c_client_list_node);
-		spin_unlock(&driver_data.i2c_list_lock);
-
 		dev_err(&client->dev, "%s alg registration failed\n",
 			atmel_ecdh_nist_p256.base.cra_driver_name);
+		goto err_list_del;
 	} else {
 		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
 	}
 
+	goto done;
+
+err_list_del:
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	list_del(&i2c_priv->i2c_client_list_node);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+
+done:
 	return ret;
 }
 
@@ -361,11 +366,10 @@ static void atmel_ecc_remove(struct i2c_client *client)
 		return;
 	}
 
-	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
+	atmel_i2c_unregister_client(i2c_priv);
+	atmel_i2c_flush_queue();
 
-	spin_lock(&driver_data.i2c_list_lock);
-	list_del(&i2c_priv->i2c_client_list_node);
-	spin_unlock(&driver_data.i2c_list_lock);
+	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
 }
 
 #ifdef CONFIG_OF
@@ -398,21 +402,7 @@ static struct i2c_driver atmel_ecc_driver = {
 	.id_table	= atmel_ecc_id,
 };
 
-static int __init atmel_ecc_init(void)
-{
-	spin_lock_init(&driver_data.i2c_list_lock);
-	INIT_LIST_HEAD(&driver_data.i2c_client_list);
-	return i2c_add_driver(&atmel_ecc_driver);
-}
-
-static void __exit atmel_ecc_exit(void)
-{
-	atmel_i2c_flush_queue();
-	i2c_del_driver(&atmel_ecc_driver);
-}
-
-module_init(atmel_ecc_init);
-module_exit(atmel_ecc_exit);
+module_i2c_driver(atmel_ecc_driver);
 
 MODULE_AUTHOR("Tudor Ambarus");
 MODULE_DESCRIPTION("Microchip / Atmel ECC (I2C) driver");
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 0e275dbdc8c5..861af52d7a88 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -21,6 +21,12 @@
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
+struct atmel_i2c_client_mgmt atmel_i2c_mgmt = {
+	.i2c_list_lock = __SPIN_LOCK_UNLOCKED(atmel_i2c_mgmt.i2c_list_lock),
+	.i2c_client_list = LIST_HEAD_INIT(atmel_i2c_mgmt.i2c_client_list),
+};
+EXPORT_SYMBOL_GPL(atmel_i2c_mgmt);
+
 static const struct {
 	u8 value;
 	const char *error_text;
@@ -348,6 +354,15 @@ static int device_sanity_check(struct i2c_client *client)
 	return ret;
 }
 
+void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv)
+{
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	if (!list_empty(&i2c_priv->i2c_client_list_node))
+		list_del_init(&i2c_priv->i2c_client_list_node);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+}
+EXPORT_SYMBOL(atmel_i2c_unregister_client);
+
 int atmel_i2c_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 72f04c15682f..43a0c1cfcd94 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -115,10 +115,11 @@ struct atmel_i2c_cmd {
 #define ECDH_PREFIX_MODE		0x00
 
 /* Used for binding tfm objects to i2c clients. */
-struct atmel_ecc_driver_data {
+struct atmel_i2c_client_mgmt {
 	struct list_head i2c_client_list;
 	spinlock_t i2c_list_lock;
 } ____cacheline_aligned;
+extern struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
 
 /**
  * atmel_i2c_client_priv - i2c_client private data
@@ -189,4 +190,6 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
+void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
+
 #endif /* __ATMEL_I2C_H__ */
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index ed7d69bf6890..e6808c2bc891 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -169,10 +169,17 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 
 	ret = atmel_i2c_probe(client);
 	if (ret)
-		return ret;
+		goto done;
 
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
@@ -183,15 +190,26 @@ static int atmel_sha204a_probe(struct i2c_client *client)
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
 
+	goto done;
+
+err_list_del:
+	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	list_del(&i2c_priv->i2c_client_list_node);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+
+done:
 	return ret;
 }
 
@@ -230,19 +248,7 @@ static struct i2c_driver atmel_sha204a_driver = {
 	.driver.of_match_table	= of_match_ptr(atmel_sha204a_dt_ids),
 };
 
-static int __init atmel_sha204a_init(void)
-{
-	return i2c_add_driver(&atmel_sha204a_driver);
-}
-
-static void __exit atmel_sha204a_exit(void)
-{
-	atmel_i2c_flush_queue();
-	i2c_del_driver(&atmel_sha204a_driver);
-}
-
-module_init(atmel_sha204a_init);
-module_exit(atmel_sha204a_exit);
+module_i2c_driver(atmel_sha204a_driver);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_DESCRIPTION("Microchip / Atmel SHA204A (I2C) driver");
-- 
2.53.0

