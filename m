Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30E83672B1
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490916; cv=none; b=TviwvcjF1MpM14RnbUjRJmw99AtFj09KULgLzXfPF2L4uhQoy5wdfHLS1cZgc21OP3iEYzqUM3jEr22XUFjinK7I5cW6qExJ28MVmTBOT0shFKD60DXS2dgb0x/y1vhjGP2z/VPrWnYarsppFTa/D23bZdFUo4jkrNR3TNegGgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490916; c=relaxed/simple;
	bh=dAoA7wZBGyBgkuKW+C/Nr5C9eNtwpsHK4EAheW9cuBU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JjA8RO3WSF5aWFScHQghDHAUWZY/5tRLcLIT3hianDo5QW2hh+2yLat6nfc4Dm/1JyMLCKpOE1852wnQo1EU4H61GX56+5N1r3pr0lQoX42zwLfYcXSPTGRmLT1l5DKrVeQkj9OWtfZ/W0Gvgn9KQoELeitmvQPJMDD2oUHnc1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TkTjOjzF; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TkTjOjzF"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-44a7c719151so592706f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490912; x=1780095712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MfLcGNZgqb+V+WxyXEnSFJnXPIqON2cg7XA1OePB+Uk=;
        b=TkTjOjzFpwxChgb3MpeuJR+7f+lWr54PndPLHzy0T5qeXMBg7su+fdnkOF21IooLhR
         pvZOe0NJZmPr6RTBA2a8has8R6E4Cnv4RnEveY+BB5qAu6dD/SSMmKFExEcLvEEsasBO
         mBFtPFexQ/MEJtJjl0f62RCosHbWhRzCtnAgOAUGaOjsr7tQyzV7tTnYPYEggA+y1vCR
         L08QN7DErzZbsORkj1LL5ZX54M1NUOsj0WoaitiFaGwKch3W7vZokubsDoCXT+fT0Wu+
         WxpXJ0gOO8yQYJDHpIHSGs6yJFytfN6CiEykMYffHwqQuDgmh0FTVgr2f63Uxh/4/az/
         XK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490912; x=1780095712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MfLcGNZgqb+V+WxyXEnSFJnXPIqON2cg7XA1OePB+Uk=;
        b=OuenJKQDKJjiDqN3dA9aAD/RJ+8AcGBHVa4MjMB4CPKXtCvVW7AtxvCwtC+D66qlug
         yJgHp05fGW7fz4kRbDPsbMfs3cgxPt9/f4QnMcai6xLlMiGQedPq07QuHtOR+2Agdu70
         1uw/u/dzJtJ9Kz4XEk5ig6Wi8uvndqCERtRA1xOn/iJR+xICoEf1jEx1uF+FeekuQes8
         PdYRnkzwO8wWKJ/SVmCjvFYc93dwh3ns2rY/8Xj9aS0/jipOwin8/Y8V9PyS+YrvQWhb
         Kmue/6nRWFfKkaKLv5IrPEmYn1NGNi+Yj5UsZxLRI2o4LhbkCQ0Med+llYzqZuKe7Jq8
         Helw==
X-Gm-Message-State: AOJu0YyhAK04S9k9/BpzXmmOBLvtA3OR9/uBptcvo3wrF93rwUCzRvga
	alpgsb0yt9PS+PTjWCPxg4kETkfZqZ8UBKNF1olXz1z6ujPKVQ1lk1/Z
X-Gm-Gg: Acq92OExiKNyQqp0xs34bltVH2b0vbkg9lJib3fkK373b0xNVKrYbz8fcgbGOwZgt4/
	0vtERxBToUVVlyw/xeWStbXaeKPAaXkZOSsmfZ//X2UbdeVgbzfDSRxt8dFJsCrZB202dMNGIos
	oZehfb+CRTmAdmRDtThDZvi2HWI44+izA+iv8H8pd3CojnlrPn+EZcFhlc4Ijf0x/fIFUOhPamo
	3sj8tOnaqhaqZxflISG8UWQlgb8x5ZmvaH2RXNS09xrhqpr/ENRuzKKPVAvFOmrsvgZeCPsdgby
	/vWji/ns92XSVBXxNYQ4x+yvzE7UzxSzBCM5Hp4Ft86US8jbqGU3TWDlRKBQ72cDfxkdxX5mz7Y
	Yp1X7PWQT60YXdNXKw0zeTYQsvQzy+I5ysqz1Nhw788CCIfpmsqJlKmUesIN1go7NxU3kGXx2Tf
	Hgdo+K6agUVcln5gMVvYENGBOLocviMVPiV3PSK/Gbr70ptFnV4xPE53c7VTC0BbE=
X-Received: by 2002:a05:600c:590f:b0:488:a2ac:a338 with SMTP id 5b1f17b1804b1-490426cc0dbmr28853145e9.5.1779490911959;
        Fri, 22 May 2026 16:01:51 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:51 -0700 (PDT)
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
Subject: [PATCH v4 09/12] crypto: atmel-i2c - move shared client allocation logic to core
Date: Fri, 22 May 2026 23:01:31 +0000
Message-Id: <20260522230134.32414-10-l.rubusch@gmail.com>
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
 drivers/crypto/atmel-ecc.c | 51 +++-----------------------------------
 drivers/crypto/atmel-i2c.c | 47 +++++++++++++++++++++++++++++++++++
 drivers/crypto/atmel-i2c.h |  3 +++
 3 files changed, 53 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index d2490693a198..16e607cd06c4 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -205,51 +205,6 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
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
-	if (atomic_dec_and_test(&i2c_priv->tfm_count))
-		complete(&i2c_priv->remove_done);
-}
-
 static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 {
 	const char *alg = kpp_alg_name(tfm);
@@ -257,7 +212,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	ctx->curve_id = ECC_CURVE_NIST_P256;
-	ctx->client = atmel_ecc_i2c_client_alloc();
+	ctx->client = atmel_i2c_client_alloc();
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
 		return PTR_ERR(ctx->client);
@@ -267,7 +222,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	if (IS_ERR(fallback)) {
 		dev_err(&ctx->client->dev, "Failed to allocate transformation for '%s': %ld\n",
 			alg, PTR_ERR(fallback));
-		atmel_ecc_i2c_client_free(ctx->client);
+		atmel_i2c_client_free(ctx->client);
 		return PTR_ERR(fallback);
 	}
 
@@ -284,7 +239,7 @@ static void atmel_ecdh_exit_tfm(struct crypto_kpp *tfm)
 	kfree(ctx->public_key);
 	if (ctx->fallback)
 		crypto_free_kpp(ctx->fallback);
-	atmel_ecc_i2c_client_free(ctx->client);
+	atmel_i2c_client_free(ctx->client);
 }
 
 static unsigned int atmel_ecdh_max_size(struct crypto_kpp *tfm)
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index db818ce55033..92d3e28f9d9a 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -57,6 +57,53 @@ static void atmel_i2c_checksum(struct atmel_i2c_cmd *cmd)
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
+	if (atomic_dec_and_test(&i2c_priv->tfm_count))
+		complete(&i2c_priv->remove_done);
+}
+EXPORT_SYMBOL_GPL(atmel_i2c_client_free);
+
 void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd)
 {
 	cmd->word_addr = COMMAND;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 07fd2248e20b..ddab80bc1a72 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -193,6 +193,9 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
+struct i2c_client *atmel_i2c_client_alloc(void);
+void atmel_i2c_client_free(struct i2c_client *client);
+
 void atmel_i2c_deactivate_client(struct atmel_i2c_client_priv *i2c_priv);
 void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
 
-- 
2.39.5

