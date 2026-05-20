Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3DF3BED26
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292649; cv=none; b=REXF7CBXti8ZL1MyTIfv6L2Qwq5cHZEBYU47pjRthnAYNH777UEvFOKpHIlexDeA3SbghFgpoIdW+3SqVV1BCV/RjdvXbnz2KmHrnuOMeNxTDXrANtS1xE/+dQBoT+uRCDubQR0eCCHlprkPjOqwEFWDmUVmU8O5FagEIBZ+CXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292649; c=relaxed/simple;
	bh=SdZXb4YlAIgGQSiYVfEZ5WJEVes53hxYTkfaG3b/d3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dII2pgI6rNX7MIh3YWBrUPctJ4QyHD4a0sqDe23/gFoDNbNO2Bww3ZVe9doI9ZvzEAEknOGmFfnvJufwXXA6fgmEfVCSLqK5wGicLxn3VGU4Wq3pnaHyOCi9n+w/22f+F2eeJrYvVfsowt+0s/BZupZ+0CIE3Dg8ZB1FJkixRJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HapiIFCv; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HapiIFCv"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48d10c981e4so6607965e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292643; x=1779897443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ix3QOsJRJfrw5u43r2mA+N3E2gg1vLyQm9dlzJ2uvsQ=;
        b=HapiIFCvoauHywOC8FjTjGFmO5N9w/QGCYOkvupah06nqqnsTZvjqJ7rNgtd5sLj2t
         EHaTM3ei/qPjkaRydVFESalcqYtoVzdSzpX9etlrWz1o4leJ2IzFcgqw6fxLknPS6ho8
         Hn/n8hGopjDjoEOTJEuHxNWjezEzmXj2JdsQZmkGTVIi4q/aFNlMlQ+gPFXX9F2o8/YZ
         WDCvNl3t4LNuUgKs5rxT9M16gJ7JglhO1DWC9XEMqZZS/b1Nt/tyWI2CQNHRpZJZnhWT
         g8T/os7SdkNDZ8SfDmUA9WJtEWbb4EuKDRcoc96yWtBIir2VVagwSMrQ1UTLa/sUJkM5
         CVnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292643; x=1779897443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ix3QOsJRJfrw5u43r2mA+N3E2gg1vLyQm9dlzJ2uvsQ=;
        b=d+04CyO0gWXuf7OobjWt9W3eV529TrHLoJpkEKpnoY/zdoSCcnD8qhYVSrahLDKKpp
         UPGcJR0pACEQfp6KK05KfuIgDvN3GdB3ZTKJk9emw1mQjZWSuL3/zSYG4sfGDCaAAs+3
         GGR55PQSpJlKG+HRaKrzvBZ5juf2hAmXBJb3CbsNBudKaJabRHTtZoUexe1PE8fYYakz
         o2HJu7xEFPZehrQL1iNzdEgkgaivuQFYI0a/4HIm87CBg8woHMlZmw2Iv1tI2nCmYtx7
         1ePXM8tda5NvUylmMJ9cqm0Y7GQhrutGg+5GWhkjazalBeuyO/9gAbCibnsoSxtNbDRM
         DXtw==
X-Gm-Message-State: AOJu0YxSdO6B88PA4AeoA+/jVUzKP3AA4Bhz5dkEdxk0oNyqrJVW0n4/
	oKoMxUOOIJcfsBQYKk0prAJYoX5dHvXYndaqrcjmfB7BCjyaHM2pa8U0
X-Gm-Gg: Acq92OHRM8LcQR+7bmI0uoRuJljF7VJPY3xWTVT9No4/Y9xtMZSWYyeR3I+2+6/UbQi
	yOiTRxR122W2hF/eo5ElfTVPbYPflEJRTolmdjXV2Jw2ZcUffKUpjQupKX7qm9eHpZ39QWN7zrX
	4CX1q8K30x6C38fb1MamMF8P9HOEKZNFFo5W4EdrgZOfvptLsfnMOmAe1vwya/dn/SjFP4IuvdW
	JKrrRg2HoQtjy3dIVrIcrlS7p3tG/CEjR3ZUXMDgfmbYcvAsjSO4Ig5sNBbrxDtwVJjyeJ5tCq2
	fWKX1/5y3i7PnrpfgyTMzczHHY+gDWa8RpmZdiQnAB8uZaOqX7cfiDYg1dSQFL8vYCXYASYmgn6
	ZAS4L4laLHHJ2yrIpd7VMBbcUOaXxSoqYPMM4vGXF0e0PEX1DeKQzsmLBW/3CY+dDGms1TEmSzr
	yWwxifwwdmt5WlVX0CUiqoiXqthrG5aOCB1dimUh5WhBoSDKdXcIDL1GeeL92/bjQ=
X-Received: by 2002:a05:600c:3b07:b0:48e:6db5:76e6 with SMTP id 5b1f17b1804b1-48fe63099c6mr198267165e9.2.1779292642678;
        Wed, 20 May 2026 08:57:22 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:22 -0700 (PDT)
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
Subject: [PATCH v3 08/12] crypto: atmel-i2c - move shared client allocation logic to core
Date: Wed, 20 May 2026 15:56:59 +0000
Message-Id: <20260520155703.23018-9-l.rubusch@gmail.com>
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
index f166144febfe..19e9ee9c15e5 100644
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
index cf3c57745414..e10713a7bcfe 100644
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

