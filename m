Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C48383;
	Fri, 13 Dec 2024 14:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098904; cv=none; b=nY4EzlpFupEZnaBZPXqEdvTINorAcTZPBXLaU8YsqWGBd8ALhysclMn5eQlFXTVWwIN34+i75Qe6RNEhlLwHN99acG2vcOhcISfkCTeVutHS0l+4/xuRwdLZxa6T2UFaMbm/GV5Fe4iIxNQN4vqqmsiHyGNj50Q+zhKDBhB/iXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098904; c=relaxed/simple;
	bh=bAxKcNa2bho3I+kO6nrHA4pK2Jom8E/BotBICrdllQo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8+0lmYNpeICoUhUSQOlJ0FpO9NcSQtpq8z+Cra7aHxNp/5FIMzaOSkJFDjt3w4eNMPqYuwboFL2YDPIZehUZSBDdVJB6dxYozZZtQzlbescEPOketDg+ZDknGBNNqKGL0w6NiRIG1NJqYFrKrSsTPtNccHnCokQIQoYDcr3iwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=sCMGbfhd; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="sCMGbfhd"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id BA6E1120016;
	Fri, 13 Dec 2024 17:08:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru BA6E1120016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1734098895;
	bh=PLbOl6vfaRcS4Zx5JgW50G+KOKQnPem8uZTZjmoFfbY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=sCMGbfhdugOBIzbInXGneE2xEXGcf6koznuxbJbYUoBbITi93Jd+MAMUQqk1k+kPt
	 6/Wo+KH+UC3vTjYOi8xxDjPr4gS/l1Dn4Oaig0H/O1Fme5FExsE+nGnZ10eZU/Zy1i
	 4vRnnHaM6uWHaFk0SFfytruE5P7PAaeHW8iOB67dLrTJEZ/w3Dh6iCZUEXVR47JtrP
	 HaxshXq8mH6uqd7/t/ggMl/FhD1T9TlSbhxE3/MQEciTCYYn9t8hX2ouIeoSMMTyXf
	 osmf/vCZeeIUCtOdWZ+/KSV3DX1AwgBd8hhaLMF6hfjVK1Jc7qDdEdtYkYFVbNKXa3
	 Z1bfRQ1YwgGPg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 13 Dec 2024 17:08:15 +0300 (MSK)
From: Alexey Romanov <avromanov@salutedevices.com>
To: <neil.armstrong@linaro.org>, <clabbe@baylibre.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <krzk+dt@kernel.org>,
	<conor+dt@kernel.org>, <khilman@baylibre.com>, <jbrunet@baylibre.com>,
	<martin.blumenstingl@googlemail.com>, <vadim.fedorenko@linux.dev>
CC: <linux-crypto@vger.kernel.org>, <linux-amlogic@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kernel@salutedevices.com>, "Alexey
 Romanov" <avromanov@salutedevices.com>
Subject: [PATCH v11 07/22] crypto: amlogic - Move algs definition and cipher API to cipher.c
Date: Fri, 13 Dec 2024 17:07:40 +0300
Message-ID: <20241213140755.1298323-8-avromanov@salutedevices.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241213140755.1298323-1-avromanov@salutedevices.com>
References: <20241213140755.1298323-1-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-a-m1.sberdevices.ru (172.24.196.116) To
 p-i-exch-a-m1.sberdevices.ru (172.24.196.116)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 189823 [Dec 13 2024]
X-KSMG-AntiSpam-Version: 6.1.1.7
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 47 0.3.47 57010b355d009055a5b6c34e0385c69b21a4e07f, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/12/13 12:33:00 #26873825
X-KSMG-AntiVirus-Status: Clean, skipped

Because that is proper place for them. In particular,
it takes less of exported symbol between compiling entities.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
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

