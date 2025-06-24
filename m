Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFF32D4B59;
	Tue, 24 Jun 2025 13:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773197; cv=none; b=rD1Pm00KJSKuF/4mxq74K0kV6fvOnmfKAyHQSsD+d322dBdrvPEXJOBwKMBCRFO2D5tADifnUkc5gJDPDOffV6vMiFcLJTTT0KcFuIR9LDfPsfZnXTL94RRiw/llx9UwyBkMKXYC0X0TSV/TxB2GUx8oyjPbjp1CrZ6GS8l5D1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773197; c=relaxed/simple;
	bh=ckRpwDMjsuQ16JCO462+YPT83WjsgnuQ+s0s5BisuXM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RAas29buitOhK6q5UhAGorXfDJ50KfR2FhWApFzdCPMJ7apE07isjwr5KCNoDkRbm2tdkD9lkB6fxj59pDFrmN1F3eFsF9W7dw/FdUGPpnIdK5+Yft1JQl5GAoHdZWJzmojzUsnMl7+DnG2SzAM9l96mZlY20vqo32YzAIS0e5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L8JryqOU; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L8JryqOU"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-553dceb345eso5969354e87.1;
        Tue, 24 Jun 2025 06:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773194; x=1751377994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkOwiBZHh5F6vKmK4j0gXkJ41uKyJ1upYAHO+AvK97k=;
        b=L8JryqOUw18U0Iq+QqnduG0trl1FIqjZtrdqhRWE268kZitaG1KwIgngogJ6XR4gvH
         fb2QcCVgA+t1riI/irvEhRYAa9JnRuawzjEUjcLVFLMZpwsQmTH5J5M7Oe2alX8dmWLe
         rAPaopOo4nhZaft3wPg9G/LX11lSQ3rvWzHTyoO9tetGElrAtg8v47pp3IicyDmRjeKq
         1Cfic5DB18h4BSaTUwBJk7Hg8TEpdvRKKkQZUu1OP5RlpUVjmfsZJk9khBNdmaaXWoxm
         LtQJnFvk9BsstKl3HIqzyk1db1djSfJA7NFgVqE0/lljq0fuYeHMyDHL3PexLWLLlbv/
         g06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773194; x=1751377994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pkOwiBZHh5F6vKmK4j0gXkJ41uKyJ1upYAHO+AvK97k=;
        b=CrmLr8x5APOQu9E/JyA1CxMUBEYPzqj0RYC3YG9b2pSM/GTNG3RnPohEfolEeBpS+k
         Ly5fCzvO2CXIAKHnvhjp1UvnXL/00QQB5n8FFZDRKkjt+SDiespESylTUCUK7GFM9zSG
         kwjmAUOSsqy0xJoK76aIB43UaCZL2MJocOJdqStRmj1DEsa/+/CjKHvuRXcJkd0Tp/hZ
         hhxizz2MrZV8sRZXxLVPANEQS0YRyVViapnD25+UmX5+NGdnl31rHOOCZCaYerk9OzbF
         2FJhh98ISL/pGKh54CDtodm/m+6pEZc5nHZxQXuNtsE3zW3l8d+6B6mevmsY6Yq8xZct
         Z4rg==
X-Forwarded-Encrypted: i=1; AJvYcCXMfcuevAcbKtC1K3de3gMWdcbL5Wjwe+rzefE/3bilhB3e4sZ2NNXp6QtDwFS5X+fQ+geICHsFixojc4WM@vger.kernel.org, AJvYcCXrMdSGPQirmIh8B06NzNsgnQsxsKmGBao9qqO7S5FS6Yo5XJon7X0MrQC68NzSzPtTTs+Hngh3gVIL@vger.kernel.org
X-Gm-Message-State: AOJu0YxUqaFJPaJ3NFBqhi0yqX36VRGirIJ0NeDdlcjhjsnj8pgjSqkV
	XXlk7UYvIwBV07YfQnIey8P1Nda7LX8GJy51cPyjpYtUtS0zY8A/9BQr
X-Gm-Gg: ASbGncvjKiUiSR5t2GfkohWM4bv1Lb7pETTCQQDks0mD6hWONoW49HKVl+QEkpChxQF
	HGi7mtRsgX24yGQkmkACvLUxFQuQLl0Ykc+Oc6KN3QsZ2UA+osBxFjFAVqNxkBisIWTUBptfDrM
	IdOvFlquhMZXvvCTcKLK97LeGOGd1hhQXMqvi9pcrk+VPWk0BtQoc3XVlIbkhd1ylZw+MNPmopb
	Mq6aXa8EjxFcKyWKUqXGb1q+odrTz/+zPPtzndhc2PoevROVGNFtiAxY4btw6KG9GzA1k35y+GI
	4ZMBysU4xnl/f+/KSbMfgNfjwugZ120PRWNssvBmlXCGJMApnzos55j8TZ05vPkolMVfhLm6oCW
	nhiW4NhT9lt+89RdwSC+/RLhupNiyZkeuHqMrBYlXvkZKErOWOgDQm76FZZp5qA==
X-Google-Smtp-Source: AGHT+IHBJG67r/kDZ4Upx5Y0quX8DN3YKPXUSwlfg4vbbOomteWtJCOnlUp8dm4jLX5PITc0w0h/7w==
X-Received: by 2002:a05:6512:110f:b0:553:26f6:bbfd with SMTP id 2adb3069b0e04-553e3b992dcmr4753531e87.8.1750773193648;
        Tue, 24 Jun 2025 06:53:13 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:13 -0700 (PDT)
From: Alexey Romanov <romanov.alexey2000@gmail.com>
To: neil.armstrong@linaro.org,
	clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	khilman@baylibre.com,
	jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v12 07/22] crypto: amlogic - Move algs definition and cipher API to cipher.c
Date: Tue, 24 Jun 2025 16:51:59 +0300
Message-Id: <20250624135214.1355051-8-romanov.alexey2000@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Because that is proper place for them. In particular,
it takes less of exported symbol between compiling entities.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c |  98 +++++++++++++++--
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 110 ++++----------------
 drivers/crypto/amlogic/amlogic-gxl.h        |  14 +--
 3 files changed, 119 insertions(+), 103 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index dc0b100c5de2..bc3092a8a2c2 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -271,7 +271,7 @@ int meson_handle_cipher_request(struct crypto_engine *engine, void *areq)
 	return 0;
 }
 
-int meson_skdecrypt(struct skcipher_request *areq)
+static int meson_skdecrypt(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
@@ -289,7 +289,7 @@ int meson_skdecrypt(struct skcipher_request *areq)
 	return crypto_transfer_skcipher_request_to_engine(engine, areq);
 }
 
-int meson_skencrypt(struct skcipher_request *areq)
+static int meson_skencrypt(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
@@ -307,7 +307,7 @@ int meson_skencrypt(struct skcipher_request *areq)
 	return crypto_transfer_skcipher_request_to_engine(engine, areq);
 }
 
-int meson_cipher_init(struct crypto_tfm *tfm)
+static int meson_cipher_init(struct crypto_tfm *tfm)
 {
 	struct meson_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
 	struct meson_alg_template *algt;
@@ -333,7 +333,7 @@ int meson_cipher_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-void meson_cipher_exit(struct crypto_tfm *tfm)
+static void meson_cipher_exit(struct crypto_tfm *tfm)
 {
 	struct meson_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
 
@@ -341,8 +341,8 @@ void meson_cipher_exit(struct crypto_tfm *tfm)
 	crypto_free_skcipher(op->fallback_tfm);
 }
 
-int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
-		     unsigned int keylen)
+static int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			    unsigned int keylen)
 {
 	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct meson_dev *mc = op->mc;
@@ -369,3 +369,89 @@ int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	return crypto_skcipher_setkey(op->fallback_tfm, key, keylen);
 }
+
+static struct meson_alg_template algs[] = {
+{
+	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+	.blockmode = MESON_OPMODE_CBC,
+	.alg.skcipher.base = {
+		.base = {
+			.cra_name = "cbc(aes)",
+			.cra_driver_name = "cbc-aes-gxl",
+			.cra_priority = 400,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
+			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 0xf,
+			.cra_init = meson_cipher_init,
+			.cra_exit = meson_cipher_exit,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= meson_aes_setkey,
+		.encrypt	= meson_skencrypt,
+		.decrypt	= meson_skdecrypt,
+	},
+	.alg.skcipher.op = {
+		.do_one_request = meson_handle_cipher_request,
+	},
+},
+{
+	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+	.blockmode = MESON_OPMODE_ECB,
+	.alg.skcipher.base = {
+		.base = {
+			.cra_name = "ecb(aes)",
+			.cra_driver_name = "ecb-aes-gxl",
+			.cra_priority = 400,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
+			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 0xf,
+			.cra_init = meson_cipher_init,
+			.cra_exit = meson_cipher_exit,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.setkey		= meson_aes_setkey,
+		.encrypt	= meson_skencrypt,
+		.decrypt	= meson_skdecrypt,
+	},
+	.alg.skcipher.op = {
+		.do_one_request = meson_handle_cipher_request,
+	},
+},
+};
+
+int meson_cipher_register(struct meson_dev *mc)
+{
+	return meson_register_algs(mc, algs, ARRAY_SIZE(algs));
+}
+
+void meson_cipher_unregister(struct meson_dev *mc)
+{
+	meson_unregister_algs(mc, algs, ARRAY_SIZE(algs));
+}
+
+void meson_cipher_debugfs_show(struct seq_file *seq, void *v)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(algs); i++) {
+		seq_printf(seq, "%s %s %lu %lu\n",
+			   algs[i].alg.skcipher.base.base.cra_driver_name,
+			   algs[i].alg.skcipher.base.base.cra_name,
+#ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
+			   algs[i].stat_req, algs[i].stat_fb);
+#else
+			   0ul, 0ul);
+#endif
+	}
+}
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 9259ad0417d1..106d4ee2e5e9 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -64,66 +64,6 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static struct meson_alg_template mc_algs[] = {
-{
-	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.blockmode = MESON_OPMODE_CBC,
-	.alg.skcipher.base = {
-		.base = {
-			.cra_name = "cbc(aes)",
-			.cra_driver_name = "cbc-aes-gxl",
-			.cra_priority = 400,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-				CRYPTO_ALG_NEED_FALLBACK,
-			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
-			.cra_module = THIS_MODULE,
-			.cra_alignmask = 0xf,
-			.cra_init = meson_cipher_init,
-			.cra_exit = meson_cipher_exit,
-		},
-		.min_keysize	= AES_MIN_KEY_SIZE,
-		.max_keysize	= AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
-		.setkey		= meson_aes_setkey,
-		.encrypt	= meson_skencrypt,
-		.decrypt	= meson_skdecrypt,
-	},
-	.alg.skcipher.op = {
-		.do_one_request = meson_handle_cipher_request,
-	},
-},
-{
-	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.blockmode = MESON_OPMODE_ECB,
-	.alg.skcipher.base = {
-		.base = {
-			.cra_name = "ecb(aes)",
-			.cra_driver_name = "ecb-aes-gxl",
-			.cra_priority = 400,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-				CRYPTO_ALG_NEED_FALLBACK,
-			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
-			.cra_module = THIS_MODULE,
-			.cra_alignmask = 0xf,
-			.cra_init = meson_cipher_init,
-			.cra_exit = meson_cipher_exit,
-		},
-		.min_keysize	= AES_MIN_KEY_SIZE,
-		.max_keysize	= AES_MAX_KEY_SIZE,
-		.setkey		= meson_aes_setkey,
-		.encrypt	= meson_skencrypt,
-		.decrypt	= meson_skdecrypt,
-	},
-	.alg.skcipher.op = {
-		.do_one_request = meson_handle_cipher_request,
-	},
-},
-};
-
 static int meson_debugfs_show(struct seq_file *seq, void *v)
 {
 	struct meson_dev *mc __maybe_unused = seq->private;
@@ -137,20 +77,8 @@ static int meson_debugfs_show(struct seq_file *seq, void *v)
 			   0ul);
 #endif
 
-	for (i = 0; i < ARRAY_SIZE(mc_algs); i++) {
-		switch (mc_algs[i].type) {
-		case CRYPTO_ALG_TYPE_SKCIPHER:
-			seq_printf(seq, "%s %s %lu %lu\n",
-				   mc_algs[i].alg.skcipher.base.base.cra_driver_name,
-				   mc_algs[i].alg.skcipher.base.base.cra_name,
-#ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
-				   mc_algs[i].stat_req, mc_algs[i].stat_fb);
-#else
-				   0ul, 0ul);
-#endif
-			break;
-		}
-	}
+	meson_cipher_debugfs_show(seq, v);
+
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(meson_debugfs);
@@ -227,19 +155,20 @@ static int meson_allocate_chanlist(struct meson_dev *mc)
 	return err;
 }
 
-static int meson_register_algs(struct meson_dev *mc)
+int meson_register_algs(struct meson_dev *mc, struct meson_alg_template *algs,
+			unsigned int count)
 {
 	int err, i;
 
-	for (i = 0; i < ARRAY_SIZE(mc_algs); i++) {
-		mc_algs[i].mc = mc;
-		switch (mc_algs[i].type) {
+	for (i = 0; i < count; i++) {
+		algs[i].mc = mc;
+		switch (algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
-			err = crypto_engine_register_skcipher(&mc_algs[i].alg.skcipher);
+			err = crypto_engine_register_skcipher(&algs[i].alg.skcipher);
 			if (err) {
 				dev_err(mc->dev, "Fail to register %s\n",
-					mc_algs[i].alg.skcipher.base.base.cra_name);
-				mc_algs[i].mc = NULL;
+					algs[i].alg.skcipher.base.base.cra_name);
+				meson_unregister_algs(mc, algs, count);
 				return err;
 			}
 			break;
@@ -249,16 +178,17 @@ static int meson_register_algs(struct meson_dev *mc)
 	return 0;
 }
 
-static void meson_unregister_algs(struct meson_dev *mc)
+void meson_unregister_algs(struct meson_dev *mc, struct meson_alg_template *algs,
+			   unsigned int count)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(mc_algs); i++) {
-		if (!mc_algs[i].mc)
+	for (i = 0; i < count; i++) {
+		if (!algs[i].mc)
 			continue;
-		switch (mc_algs[i].type) {
+		switch (algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
-			crypto_engine_unregister_skcipher(&mc_algs[i].alg.skcipher);
+			crypto_engine_unregister_skcipher(&algs[i].alg.skcipher);
 			break;
 		}
 	}
@@ -288,9 +218,9 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	if (err)
 		goto error_flow;
 
-	err = meson_register_algs(mc);
+	err = meson_cipher_register(mc);
 	if (err)
-		goto error_alg;
+		goto error_flow;
 
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG)) {
 		struct dentry *dbgfs_dir;
@@ -304,8 +234,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	}
 
 	return 0;
-error_alg:
-	meson_unregister_algs(mc);
 error_flow:
 	meson_free_chanlist(mc, mc->flow_cnt - 1);
 	return err;
@@ -319,7 +247,7 @@ static void meson_crypto_remove(struct platform_device *pdev)
 	debugfs_remove_recursive(mc->dbgfs_dir);
 #endif
 
-	meson_unregister_algs(mc);
+	meson_cipher_unregister(mc);
 
 	meson_free_chanlist(mc, mc->flow_cnt - 1);
 }
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 0dde7662ae37..f0ccd28545aa 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -163,10 +163,12 @@ int meson_get_engine_number(struct meson_dev *mc);
 
 void meson_dma_start(struct meson_dev *mc, int flow);
 
-int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
-		     unsigned int keylen);
-int meson_cipher_init(struct crypto_tfm *tfm);
-void meson_cipher_exit(struct crypto_tfm *tfm);
-int meson_skdecrypt(struct skcipher_request *areq);
-int meson_skencrypt(struct skcipher_request *areq);
+int meson_register_algs(struct meson_dev *mc, struct meson_alg_template *algs,
+			unsigned int count);
+void meson_unregister_algs(struct meson_dev *mc, struct meson_alg_template *algs,
+			   unsigned int count);
+
+int meson_cipher_register(struct meson_dev *mc);
+void meson_cipher_unregister(struct meson_dev *mc);
+void meson_cipher_debugfs_show(struct seq_file *seq, void *v);
 int meson_handle_cipher_request(struct crypto_engine *engine, void *areq);
-- 
2.34.1

