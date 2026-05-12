Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25893A785E
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625861; cv=none; b=ZE2jXO5tK1B7jIq9gMxzJcRi3sKEzwKCFcUnYDWaef3oYtSwIOSPzJy4sMs3mfFAt9SBc5A673fVfVTA4MEAbQKApBBOFbcKVUmTHF9N6kf7J+UgU5J7C8Y94NZS0QQ7eMIYTYAea9YBYK9NDEgH7tIJdT5KdGgua6bmPfUkOIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625861; c=relaxed/simple;
	bh=+tAodrGc85aAkcl5jIPb86A/c/K86nen8bhICVysBBU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kuPSDM6IIqYTdbGjGLq0rBUFLLDknV0faM4K0Lt9yHqcuO8PGFO3kISj+huv1+0ti/vnoOHW/UgVPSTr1szZQug7ESbwZX0F3hUI1h/QbpxZloOA4dQR1SEmAK54VaG4jrmUQjXv609C3huQl6nU6sKWE3ETf+2AXK/3bMzrgzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7q9d6o6; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7q9d6o6"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-44b729aa7c5so468868f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625857; x=1779230657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQMP+CsFbE9KP3qAcxLaIg4zkOxpF/EIB64y6avymrk=;
        b=f7q9d6o6xF/0PBHgwXStn4URnaiIhHJSswMKhySSvRBK7HY86uVKm9sGMYr2sS1jQr
         EbDxSb5AHLGPRE1h4dq6qAMlzHD61gD134+NRABfMjaRtOpCTL4gwvCnx2nNdVMuezQE
         oW24qRiRipSioL5QC3oqYi4ZMnEfkd6uH/Ru/sJOPqiS48OsyNoIi4ya94cUj6bJ+7t0
         9UhWJOvXkK6YCnu61ydsEKHCXOxlZuZi9T1Gfs9LebBreWIBN2BpQn83TxAr8NAtHI0X
         GbWNH9viN6OOkqybZVHh9JaHNrAP08BxsbgbtbHmWaH7i+mVD49x5kc83n3QTLclNxxH
         BF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625857; x=1779230657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CQMP+CsFbE9KP3qAcxLaIg4zkOxpF/EIB64y6avymrk=;
        b=Jm29Yly5d9f1ZA0x7+obrcqss3nrLfe//TrY7uywETaL+fLaPOpX5ajBdfyRmvbVEi
         vzcNDH+uhOqb9bSbhkjYXJ3cvXBZDlH8Lc5417a5GUaqwQXMhQqmye6ImKizxjk1CWPh
         GzQXLim7nz/znxNOr3c8HQlLKoSwbCksgbZbKXeISxrcfCHjuUllQQiWu9WtU6xXi5H7
         pSW1+JuXkM9TV9tU3Zj87u1AK2DclFaCY+UG0le56+Mmv6dJotizVUTPw52WGxCUGRcO
         XLdMm3DVbep6L1L2/jBlqnC8AtL/Tr8+WqQZ7FGFoacQ5GZW+HrnPy/r4eGXOOlC89W4
         XdTg==
X-Gm-Message-State: AOJu0YzFOWeiUFEzJcGhZBy6G4QVeaIR+7TUE7aGJvGeP7aR0/DjIRrY
	AXO/nDHgFHWrfbfpKA98h6GexpH1RqOG0BOIZ4HdhDhyfvI2U8E6WqiA
X-Gm-Gg: Acq92OG1tnqiGLvEHERndLTc3IcCb/XO/ch/ygiR69iiYNMi0L1T2Fq095ISXDc65OG
	v8PaObqDr3Tqmw3+BmyOSBUW3+lkKYvnyvQhUD9WR+fr8TwUEW+0g95ksuNWP0N3Wgvez5wWNBw
	Y/x/IJfqqhk9bBmior/64Rrk5vwsaOXx7FNhN1kh1nglJTNemASfV2gu2afGRJIbuUslhix7Vit
	xogoGgbPGt7A78Sk8T9p02yRKgkjybAS6g1+Tm+56ghV76w7rmmCd+ymgwAPTeqc8awyg4SZzL8
	V23Bm8pFipmxlBu8DTBaRthgH+90B8EW+sMFw6IMouoWtbe4VlifbLM1AMVrdfU9gkgUYDkv2eb
	q7iFSg38fiYDz/XQF8LIPxEla38b1hruBW/mb1JoRJqXHsfC7Jv313dlK4Le/wP3exThwHR/m0Y
	QOwDvplx94FNgZpIJYxCFvzBpEKN8OQAbEekUBdX81rtAFLWw0xZBXHKlkaNRqWQExEa689FX12
	A==
X-Received: by 2002:a05:600c:4e8c:b0:489:6c28:dbc9 with SMTP id 5b1f17b1804b1-48fc9a45602mr4727125e9.7.1778625857153;
        Tue, 12 May 2026 15:44:17 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:16 -0700 (PDT)
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
Subject: [PATCH 09/12] crypto: atmel - check client data in remove callbacks
Date: Tue, 12 May 2026 22:43:46 +0000
Message-Id: <20260512224349.64621-10-l.rubusch@gmail.com>
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

Check the i2c client private data pointer in the remove callbacks of
the Atmel ECC and SHA204A drivers before accessing driver state.
Move sysfs group removal ahead of the NULL check so cleanup can still
proceed even if client data is unavailable. Also downgrade the
busy-device warning in the ECC remove path from dev_emerg() to
dev_warn().

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     | 20 ++++++--------------
 drivers/crypto/atmel-sha204a.c |  7 +++++--
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index f6d1a9694d63..9ad6d42b6eef 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -380,19 +380,13 @@ static void atmel_ecc_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	/* Return EBUSY if i2c client already allocated. */
-	if (atomic_read(&i2c_priv->tfm_count)) {
-		/*
-		 * After we return here, the memory backing the device is freed.
-		 * That happens no matter what the return value of this function
-		 * is because in the Linux device model there is no error
-		 * handling for unbinding a driver.
-		 * If there is still some action pending, it probably involves
-		 * accessing the freed memory.
-		 */
-		dev_emerg(&client->dev, "Device is busy, expect memory corruption.\n");
+	sysfs_remove_group(&client->dev.kobj, &atmel_ecc508a_groups);
+
+	if (!i2c_priv)
 		return;
-	}
+
+	if (atomic_read(&i2c_priv->tfm_count))
+		dev_warn(&client->dev, "Device is busy, remove it anyhow\n");
 
 	atmel_i2c_unregister_client(i2c_priv);
 	atmel_i2c_flush_queue();
@@ -403,8 +397,6 @@ static void atmel_ecc_remove(struct i2c_client *client)
 		kfree((void *)i2c_priv->hwrng.priv);
 		i2c_priv->hwrng.priv = 0;
 	}
-
-	sysfs_remove_group(&client->dev.kobj, &atmel_ecc508a_groups);
 }
 
 static const struct atmel_i2c_of_match_data atecc508a_match_data = {
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 88726f6ef87c..6a41024ae40d 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -111,6 +111,11 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
+	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
+
+	if (!i2c_priv)
+		return;
+
 	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
 	atmel_i2c_flush_queue();
 
@@ -118,8 +123,6 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 		kfree((void *)i2c_priv->hwrng.priv);
 		i2c_priv->hwrng.priv = 0;
 	}
-
-	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 }
 
 static const struct atmel_i2c_of_match_data atsha204_match_data = {
-- 
2.53.0

