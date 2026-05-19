Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDD73C4545
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223704; cv=none; b=WlNU2rXbGNJXWqm5vZusXKRREnZMSZ7fehs0s6/7InSkYO8GbtdxnSKmTQ3ICQIZbnqJXlHYvphayEk73O//5niPLjQtGR5fO57RUeEuMIw5XZMmL0Aji2vJ+Qbn+nxPEsqFkCjZ4kPtrYUOyHNP/fAuItxjN28lH3wGqOIa2Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223704; c=relaxed/simple;
	bh=2O141NQg4/9uuebb1EfUwG5gECLyMTnC8YQQqB084M4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V46T3Dmp6VztMCgVHv/hYCJJjKButzJFvPn2D8SiO3KCBrom1k23C3zBvERCk3PjsDSs5JR7ZiwZQ2Ln545mVHg6IvKRJpVCul1133tCelCyLq0WJ/ed9LES/LTJO3k7Ylef1yrMeU7bDef8H6ucn8GfRlLTZFe8ZQN+jC2aHKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nuLpsSiX; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nuLpsSiX"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45e5f81074aso263436f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223697; x=1779828497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gxI7hUf51SF8n1So+Ll4nAd4AxUxL7HVVQ7quL1tTus=;
        b=nuLpsSiX4ynqAmkHvzy2jUHzjdbjMzD6U0M6rtcIjbMTafsruFYyv+dPN19lvYodR9
         2dmXbCXihd9qoac6m7JpIvRoHgQfGVWtiSGscUVFk7Lh/NhY5VO/twJbLUDgZj2FM18k
         Fi5CFwAlfyiYVUgZK8wYxdV2IN+OVNiBEHQebxxu8TyiEJUkgJfE/pvfHQkZC1eqqYG6
         OP+Aj4hRxs3ubkFOK6QhPc1muBddZDw8o+FQXNWVwEa7FCMJsitmx0UC4PePw9hqe6QL
         o+O1DVFwqhSd3h2gwcLonXBGE56PFbwf5GellsASHu8cJo8mDAvzulWshtFos0Nr15Oo
         qOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223697; x=1779828497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gxI7hUf51SF8n1So+Ll4nAd4AxUxL7HVVQ7quL1tTus=;
        b=bcYDh17O90JUJAVxo5LpdeIV+b6r0HbjbRL5/mgGvpb3OZGREH3NH0JyR8q9bke81J
         dzQPyT8oG51WQWyrm+mFA20geLuSWD4sFiYXnM+nseRDkblZyoD9SLHt2iwhXPqB4U9p
         xEQUs/B5TeRT3V8IRvbSbtIux5Qvw8stam0v82a+gld94wPS4bss5nFKPsaSVHB9mcek
         Tve7SeSivVloXwbTBNmurAb+0s6lN+XUzGyYetzGIgo3A7t5b8hN8QWBLc5n82Wj8ryJ
         VRU6GdIsdoctR8uArVsg3xwkJCIwa8d9X9XEgDBXaZ6xXfBgLjj7DwV7FKQsGEi+xScd
         QZew==
X-Gm-Message-State: AOJu0Yx0anCWISscb15XTatXnkBbgzFvYruES/JJGsZcihR4XzNTZdkl
	pF0mLXdb/IpstuledaRHnXDdNsRznNYA6WTpYCjSGKDVq1l6snV16ETU
X-Gm-Gg: Acq92OGnfKO0AzWy6IGa2YgfhgydWJ1yjO3xwxkXvCkQfxvNZeAhGg1UIGDHD1eupnm
	qRXJdFsqU5ZdqWCpWXaj2OASVGdPeCm+kVN6rX67ktCV3Xad43bVlt+I/uVbS40m7EayUCAQbQM
	Z8HYkGLki3pMwuCmgPVfHqHlWvf9HJIS0HR/YO4rfztnJhnHcuQVCJTfevs6eSu7lbUURabBVu/
	Y5z5+Wb3ZoAXA4NRjzf/40UJpT4nGIzMabzxaHNXwm+zEdq4DOvKpInR+/LNkAb0FPQ33JZyqCI
	hLVGNCVm2UnxoxqjVWPsPRUMIVLWESaDTy14uHVjqHyo7Bbh/vhyHNTYa8aoiqtV72eTn8aRHH1
	Qs7XJqKOC3BvsAAbJPPVFf/UzeRUFFV4jAwN5BJV1VwdGbt1bUmtZ1Oz3jKPoXnevEJQji3AIeM
	261fpwUehFIqMijU/l4xXK0HHSB2X5q0H0uA6dNJk2BIQMeV+NZQlimMrFgRGZsXo=
X-Received: by 2002:a05:600c:4588:b0:489:1c1f:35e5 with SMTP id 5b1f17b1804b1-48fe664be2amr148849335e9.6.1779223697098;
        Tue, 19 May 2026 13:48:17 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4dac000sm356457755e9.0.2026.05.19.13.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 13:48:16 -0700 (PDT)
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
Subject: [PATCH v2 08/12] crypto: atmel-i2c - move shared client allocation logic to core
Date: Tue, 19 May 2026 20:47:59 +0000
Message-Id: <20260519204803.17034-9-l.rubusch@gmail.com>
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

Migrate the I2C client allocation and runtime load-balancing routines out
of the ECC driver code and into the central atmel-i2c core library module.

Export the symmetric lifecycle helper interfaces atmel_i2c_client_alloc()
and atmel_i2c_client_free() using EXPORT_SYMBOL_GPL() to expose a unified
client management API. This consolidation enables the dynamic selection
subsystem (which chooses the least-loaded client device based on the active
transformation count) to be shared by both the ECC driver and upcoming
Atmel crypto modules.

Refactor the ECC driver's transformation context initialization (init_tfm)
and teardown (exit_tfm) paths to use this centralized core API.

No functional change is intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 50 +++-----------------------------------
 drivers/crypto/atmel-i2c.c | 46 +++++++++++++++++++++++++++++++++++
 drivers/crypto/atmel-i2c.h |  3 +++
 3 files changed, 52 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 4f27e1caf106..7d090c557330 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -203,50 +203,6 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 	return ret;
 }
 
-static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
-{
-	struct atmel_i2c_client_priv *i2c_priv, *min_i2c_priv = NULL;
-	struct i2c_client *client = ERR_PTR(-ENODEV);
-	int min_tfm_cnt = INT_MAX;
-	int tfm_cnt;
-
-	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-
-	if (list_empty(&atmel_i2c_mgmt.i2c_client_list)) {
-		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
-		return ERR_PTR(-ENODEV);
-	}
-
-	list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
-			    i2c_client_list_node) {
-		if (!i2c_priv->ready)
-			continue;
-		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
-		if (tfm_cnt < min_tfm_cnt) {
-			min_tfm_cnt = tfm_cnt;
-			min_i2c_priv = i2c_priv;
-		}
-		if (!min_tfm_cnt)
-			break;
-	}
-
-	if (min_i2c_priv) {
-		atomic_inc(&min_i2c_priv->tfm_count);
-		client = min_i2c_priv->client;
-	}
-
-	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
-
-	return client;
-}
-
-static void atmel_ecc_i2c_client_free(struct i2c_client *client)
-{
-	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
-
-	atomic_dec(&i2c_priv->tfm_count);
-}
-
 static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 {
 	const char *alg = kpp_alg_name(tfm);
@@ -254,7 +210,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	ctx->curve_id = ECC_CURVE_NIST_P256;
-	ctx->client = atmel_ecc_i2c_client_alloc();
+	ctx->client = atmel_i2c_client_alloc();
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
 		return PTR_ERR(ctx->client);
@@ -264,7 +220,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	if (IS_ERR(fallback)) {
 		dev_err(&ctx->client->dev, "Failed to allocate transformation for '%s': %ld\n",
 			alg, PTR_ERR(fallback));
-		atmel_ecc_i2c_client_free(ctx->client);
+		atmel_i2c_client_free(ctx->client);
 		return PTR_ERR(fallback);
 	}
 
@@ -280,7 +236,7 @@ static void atmel_ecdh_exit_tfm(struct crypto_kpp *tfm)
 
 	kfree(ctx->public_key);
 	crypto_free_kpp(ctx->fallback);
-	atmel_ecc_i2c_client_free(ctx->client);
+	atmel_i2c_client_free(ctx->client);
 }
 
 static unsigned int atmel_ecdh_max_size(struct crypto_kpp *tfm)
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index c73ef3cadf0e..4621aa57833f 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -57,6 +57,52 @@ static void atmel_i2c_checksum(struct atmel_i2c_cmd *cmd)
 	*__crc16 = cpu_to_le16(bitrev16(crc16(0, data, len)));
 }
 
+struct i2c_client *atmel_i2c_client_alloc(void)
+{
+	struct atmel_i2c_client_priv *i2c_priv, *min_i2c_priv = NULL;
+	struct i2c_client *client = ERR_PTR(-ENODEV);
+	int min_tfm_cnt = INT_MAX;
+	int tfm_cnt;
+
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+
+	if (list_empty(&atmel_i2c_mgmt.i2c_client_list)) {
+		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+		return ERR_PTR(-ENODEV);
+	}
+
+	list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
+			    i2c_client_list_node) {
+		if (!i2c_priv->ready)
+			continue;
+		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
+		if (tfm_cnt < min_tfm_cnt) {
+			min_tfm_cnt = tfm_cnt;
+			min_i2c_priv = i2c_priv;
+		}
+		if (!min_tfm_cnt)
+			break;
+	}
+
+	if (min_i2c_priv) {
+		atomic_inc(&min_i2c_priv->tfm_count);
+		client = min_i2c_priv->client;
+	}
+
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+
+	return client;
+}
+EXPORT_SYMBOL_GPL(atmel_i2c_client_alloc);
+
+void atmel_i2c_client_free(struct i2c_client *client)
+{
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
+
+	atomic_dec(&i2c_priv->tfm_count);
+}
+EXPORT_SYMBOL_GPL(atmel_i2c_client_free);
+
 void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd)
 {
 	cmd->word_addr = COMMAND;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 351306c426aa..6c2d86fd9068 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -192,6 +192,9 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
+struct i2c_client *atmel_i2c_client_alloc(void);
+void atmel_i2c_client_free(struct i2c_client *client);
+
 void atmel_i2c_deactivate_client(struct atmel_i2c_client_priv *i2c_priv);
 void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
 
-- 
2.39.5

