Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DC01B6D1A
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 01:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780364774; cv=none; b=AgFaifEm/zvIQ1LDIVymwFYhsc1qJUs3qvnaCZHNLmyiwlMeaafVIouESPXP2JKdhF4r7EGZJk6CnUQldy7yCOK5oI6vzlKHlS4NrS2TMCnY7Y/fB1DdZycAtU3VdhzcOPjKCLgvL1WMPNaznHp811TYxN87IqDzqBGTUJPY3fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780364774; c=relaxed/simple;
	bh=IQs5IZ5NNl86+sSkd5aL5e9UTBxBuhDqL6rJdBGcQMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N2WgEc+RQb9Lv9tbIBot/OQ1CSFmL4Mzhsu1w8KYH51saPO4b1lELvRp96fdJNLxEMvpNIgqNp3ecO0kQtBNyYo+F75WTGhNcr3JHV/0DniN6peQlJm9JjZkRlFEYno0MczPsgYpfmB/IIM3cKIS0I0YbWXA1ZVYozurxj9h7MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bK74qrY2; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bK74qrY2"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2bea7176c72so87084765ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jun 2026 18:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780364772; x=1780969572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dTGVpdaFXGUQW3sQeSXtN3M02faeyWcv40oYea6YDJQ=;
        b=bK74qrY2uc7IbjYsNX1Dk3FaerTD6OR5hFGGQ1C2DW9gAYieY5xuWgSauUBxRofQaZ
         NmGo1uPREuRiNaNFFi5WhuQFo60+PJnT+KINm3ckPqYhvrtRdXSOmgbsUcVNVAtzuaFR
         A7SOruOCFiwxTUFUxGCUSeGUeq9bID9K0or7jHPYm/NqVmAor3RLeLMNjfc5Npv6WGLR
         kjWv7T+DC4sGsMnXrgengtUMgq0KpAaALmX68vI7l7XMpzMwKqZgtwMXuOIiL2ST0hKI
         yx5fFRhX5HfHI0OiCO5oqNN7dFDuWZdRLeIqiU+5peVMDg2GELnua93NPKVokmMWP1RL
         WgGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780364772; x=1780969572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTGVpdaFXGUQW3sQeSXtN3M02faeyWcv40oYea6YDJQ=;
        b=SwJoLxKlRLp3EZrfst1amUs9cNeziq6b1JwQ3ybELmciSLp/XZ25ByLGZuASZotC2Z
         +f+cZlaeULXyKqD6yQV9CtWTvkoWPrgCrHlJTxXVckBJWBkyOIbb9t4MZnGcmrcV3cMj
         TtJGnKUOFgrZkQ11KvrZvjam8YjO1UXsnVi3Rxqkb9z/lju5+1USl67KpioxVgRQ+8Xl
         2eFZinnBEiaod3BefvZu2hYXTnsTN8Av4wdwRNkZSrMgxz6V5Ck9GmFgo8B4gueEfQaY
         vR7NJn1xrpQBq+5RhbpaWlprhlZD2AZsLK2mGjfaSMWZFsq8V8ttEYV0gjNaJ2Kf9HH4
         KZ4g==
X-Gm-Message-State: AOJu0Yz9j4L1ul5ZxnWzazdHFfzLJledwqkMnmImGvql/oua3es4k++G
	QplKIHj6MDaAaGx1NPLE9T9J+zkNz8NlNl14e4MUDWJEmT+yetMYd7jjJ1K5/A==
X-Gm-Gg: Acq92OFJGPgspgLr16HZ1u4uLSVy6hN1XzhCtw5tCFiI/1R1iv0spYLyoPddu07rgCq
	6jv2r+jBssO2270CnVVdP/rJUvF05azpUnGop9JfF0nNwzxEEecmu6MIOc981tXy7ecNTEzNtBf
	74WJPn08v+UU8lKHMlbATz8ex9+9XdmBjitLM3szheCwPqEXeLNH5QM23q+Z+Sr3y5LFMETp7pA
	ENWX2YFwYQVwrY1MFIaraM4TH2xe/B104qcePoTXKTiBPgsq9IyZJFFhzYzoEG1ZXd0Yy6pUJgs
	pQtr11JPmDj2S2PM1HdO2jlXHb1lmyLPS+MjMUYfnUfAHYJrUl74nFIbszi81TXPSTLmt6sIG66
	Ep5jvUYSqcQFkR16j2dX/JGuFCYMy1XLqJYPcOvpXiKVFxiBPb+yQcMRFuGDRD60bxLL28B/6rJ
	0bKtFM/bjyLfWQN5KshgAtqtGrM6/BRdeD7wlyjR3R4OK2tssRaZHBt4ogpUZPTPfDfbTeU4d2C
	hC4E1a8N08x5u6npTcYzZs2pvhlB/gvU1YVy+J0GneG+FFzTCwIuUSG
X-Received: by 2002:a17:903:32ce:b0:2c0:c37d:dfc1 with SMTP id d9443c01a7336-2c0c37de0dfmr110086075ad.34.1780364772106;
        Mon, 01 Jun 2026 18:46:12 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239fd85dsm112273465ad.25.2026.06.01.18.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 18:46:11 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: amcc - check ppc4xx_trng_probe() return value
Date: Mon,  1 Jun 2026 18:45:53 -0700
Message-ID: <20260602014553.522044-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ppc4xx_trng_probe() can fail for several reasons (missing TRNG node,
iomap failure, allocation failure, hwrng registration failure). Change
its return type from void to int and propagate error codes back to the
caller in crypto4xx_probe() so that probe failures are handled properly.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c |  5 ++++-
 drivers/crypto/amcc/crypto4xx_trng.c | 12 ++++++------
 drivers/crypto/amcc/crypto4xx_trng.h |  6 +++---
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 0f1b2653769c..596a90af2c90 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1346,7 +1346,10 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	if (rc)
 		goto err_tasklet;
 
-	ppc4xx_trng_probe(core_dev);
+	rc = ppc4xx_trng_probe(core_dev);
+	if (rc)
+		goto err_tasklet;
+
 	return 0;
 
 err_tasklet:
diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
index 031dd2bf8598..f762f92dd03e 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.c
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -68,7 +68,7 @@ static const struct of_device_id ppc4xx_trng_match[] = {
 	{},
 };
 
-void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
+int ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 {
 	struct crypto4xx_device *dev = core_dev->dev;
 	struct device_node *trng = NULL;
@@ -79,17 +79,17 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 	trng = of_find_matching_node(NULL, ppc4xx_trng_match);
 	if (!trng || !of_device_is_available(trng)) {
 		of_node_put(trng);
-		return;
+		return -ENODEV;
 	}
 
 	dev->trng_base = devm_of_iomap(core_dev->device, trng, 0, NULL);
 	of_node_put(trng);
 	if (IS_ERR(dev->trng_base))
-		return;
+		return PTR_ERR(dev->trng_base);
 
 	rng = devm_kzalloc(core_dev->device, sizeof(*rng), GFP_KERNEL);
 	if (!rng)
-		return;
+		return -ENOMEM;
 
 	rng->name = KBUILD_MODNAME;
 	rng->data_present = ppc4xx_trng_data_present;
@@ -103,9 +103,9 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 		ppc4xx_trng_enable(dev, false);
 		dev_err(core_dev->device, "failed to register hwrng (%d).\n",
 			err);
-		return;
+		return err;
 	}
-	return;
+	return 0;
 }
 
 void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev)
diff --git a/drivers/crypto/amcc/crypto4xx_trng.h b/drivers/crypto/amcc/crypto4xx_trng.h
index 7356716274cb..7c6f426ab275 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.h
+++ b/drivers/crypto/amcc/crypto4xx_trng.h
@@ -13,11 +13,11 @@
 #define __CRYPTO4XX_TRNG_H__
 
 #ifdef CONFIG_HW_RANDOM_PPC4XX
-void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev);
+int ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev);
 void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev);
 #else
-static inline void ppc4xx_trng_probe(
-	struct crypto4xx_core_device *dev __maybe_unused) { }
+static inline int ppc4xx_trng_probe(
+	struct crypto4xx_core_device *dev __maybe_unused) { return -ENODEV; }
 static inline void ppc4xx_trng_remove(
 	struct crypto4xx_core_device *dev __maybe_unused) { }
 #endif
-- 
2.54.0

