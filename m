Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EE83CBE97
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041238; cv=none; b=K4lyiGoIE3elfRqsibHSxLafTNIvPA9Ib8GaDRZbg/wBjo3jvYbT+0TPAYAMpFgGbBsudhOvLHWnmEWvcJa8pSWwgCFQcS++ZuYH7TdIAUCnWW5WMzeNLUwtvCPQlUj3Pt7yqtZfYf3clV/FQ0KZ+7+QoOIgK6W+BngwAshiOTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041238; c=relaxed/simple;
	bh=8CYR6ggy/KHhCAqm6qu1i3JqF7qNai4ADGH0anF/GPA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fz0o35yWrM6fugxeBGceSAjPTdcBSPMdPjw4o+m+RiIrRR29dd41OC3kyCkMIMG0vhTo+4zEkji/ha3M5a7kT+ylUIxcC5vDh2H41rF14W3LP/h67+y3wOEQ8Std19rbulXCGtSGTZR3/N5J1mb/cPbYtcH3JINZ+mPyIWmpzF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AODvYy4p; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AODvYy4p"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48fde2f2d61so2893055e9.3
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041219; x=1779646019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVgxZ97arp1tDrxkndKJZ1UkHaadytuLX7zd1XhXT7c=;
        b=AODvYy4pxr0KI4j6J16IFsdmZP3D6lINGXT49IxHr7DGsWudppw1MRDsn0rJ6ohVco
         QwWuFYYrxLMD6Ob0YyobmA3h2G7wzrvqIrq+12vRA970uUUAltUYpH1uaWgRfhBXaQwb
         rWBlCVvccakMmcEnlUBF5nJDLgIW6PY4iuHd/H2xrUFY5lt1HlDyvfhusr5FieO6c8xY
         QvNJ5LSr60ce3pKG1F4HaoNPIFuCBiLvKbAS2DD6dM0MbcjZbmp8IRNWkC1qFwbPFI3V
         bu0/8x1RMoVNd5bwsm90yPRWUpUHcUrj+PUJzgdiMMDVKRy8mJsCDetwz42EE0ziTzfN
         dAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041219; x=1779646019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KVgxZ97arp1tDrxkndKJZ1UkHaadytuLX7zd1XhXT7c=;
        b=AcDgiP/D8yMrjqTOQ7K1KvHBn8OkEtP5MJGhyuGEdxuVeIR0pRQjeeixtNB/O3h82R
         0DMg9qWAP4rKZqbTik0+e5b6qcRS2HZLpPs5TCSl0OCvRWG0wXuKMoVWs6lVNONT5Nbg
         Xp9Zlwg8PB4BcRLZ8HdnN3k6+Gr4hJdJEyZL2nqCGUVfFbYPVqMkRwtxkM9ZkS2CJdBI
         vIrxHMuYToORmVPVbrXAPX91uW2aM07GTovsPGA09u53FrB0Y0L5tt7piwoobsYcQCgT
         sBVYbmiQuXzSaHnAB0/4BBrL46JWT+OBsfRdXzfAS/kq6Zbp1kZqBUNwtCZKTeLntzhe
         yRjw==
X-Gm-Message-State: AOJu0YzO5kFM8tfiHhoe8SfHgQFcNlksMfK9tf2eKL9ncUh3dVy0prDt
	QXbjef1ZbhkDyXQ4QMuq49bU2mbeB0MVC8BrPAw2HCkHOl+OJIPi2wPq
X-Gm-Gg: Acq92OEdytT03lobSSUCCJFPMdKGHOoqe3Dm4mBkKuzfhUBKQqEFhDFi/xmBWbcwv/6
	8lYiCO0EX4PrD4FoU0tZDeN6QoRVYeKprQa2DODVcPCdSXvEXmKWf5ujH9tsSmzEtJWpEVJUjnZ
	2SNRZj4h7477rqCdXCg1HuoA+OxAcFIpDoZ4kkjWzQAN0fP1bNkRf+mTkdixDmhlfXbRv3VDn7B
	19B1znQsnz2t98JD9tcIKm92Bd/Ja6PXFEZEnZNWaj0WEicpnDz8R4sfZqWEFdF1Ui6rlzHxTWH
	wJ6YHLDuOEYrntNvyAfX/sQmwRlP9Q/sRIjUc/JYsI86+tD2Y26WtKgF4OrEgkdWZ/vQxr46zgr
	umZdztGmwi7F5S2mMxfOqsXPjMsb+IurIhg+K+TL58nju1y6hP1d1K6uZ1zNuX4wQIfuJIMzP/h
	xBR36uPE+9N4MacjLxwKrGZZ7w07LS07bXFpL4+syVavnwZed6NdKBaFPhVjqlpP0=
X-Received: by 2002:a05:600c:310f:b0:48e:7a10:1f5e with SMTP id 5b1f17b1804b1-48fe5fd5b3amr81048735e9.2.1779041219238;
        Sun, 17 May 2026 11:06:59 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:58 -0700 (PDT)
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
Subject: [PATCH 11/12] crypto: atmel - move i2c client selection to core driver
Date: Sun, 17 May 2026 18:06:38 +0000
Message-Id: <20260517180639.9657-13-l.rubusch@gmail.com>
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

Move the I2C client selection/allocation logic from the ECC-specific driver
into the shared Atmel I2C core.

This consolidates hardware client selection in a single place, allowing all
Atmel crypto drivers to reuse the same balancing logic for selecting the
least-loaded I2C client based on the current transformation count.

No functional change is intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 37 +------------------------------------
 drivers/crypto/atmel-i2c.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/atmel-i2c.h |  1 +
 3 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index ce7a2e750ba8..f877f236552f 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -200,41 +200,6 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
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
 static void atmel_ecc_i2c_client_free(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
@@ -249,7 +214,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	ctx->curve_id = ECC_CURVE_NIST_P256;
-	ctx->client = atmel_ecc_i2c_client_alloc();
+	ctx->client = atmel_i2c_client_alloc();
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
 		return PTR_ERR(ctx->client);
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 861af52d7a88..4beab68997c4 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -57,6 +57,42 @@ static void atmel_i2c_checksum(struct atmel_i2c_cmd *cmd)
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
+EXPORT_SYMBOL(atmel_i2c_client_alloc);
+
 void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd)
 {
 	cmd->word_addr = COMMAND;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 43a0c1cfcd94..ba5a860011c8 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -190,6 +190,7 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
+struct i2c_client *atmel_i2c_client_alloc(void);
 void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
 
 #endif /* __ATMEL_I2C_H__ */
-- 
2.53.0

