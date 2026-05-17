Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396613CCFBD
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041224; cv=none; b=DQwD4y4cUtwBKjoyiwqFStw4/shIzhYTnZV0fyHOc/ZdFp4lylaMUk+5JSVR00eHaEQS2w0JVwEW1Z1bErL6LY2xw6FlmPVCq5GmPCB9uoHa9f32mi0MRy4F8Rc7sZw3tqqvQeriGOcmlvnF1qT8W4Ha0vGNmpdT5B/qT/Jg9Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041224; c=relaxed/simple;
	bh=HbqgJ+mU2YTcjIqMr596sW7K8qRkkeNvXVPaJb7xj4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f6tVX1bduyO0OIxdg+W7LWdW3ZYmgp9bLPRgYnuWO6x4V9qdBMIFhtE+pgNa4m0EOkjRmeiOtANlTY8xAaILPRwYbJxURC33hs8UsH9FGDU4OKwDkMWfaOnTBekdsrwKd3MrUyN9QpYA5DtVODFE37giB31vNhPzI42SzYPwt1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WOY5QV7w; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WOY5QV7w"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891c569cb1so1767535e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041218; x=1779646018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2Lga/xnkIfsYMx9TVpbPnWyf/7tiVX1IsmYkQiqC5k=;
        b=WOY5QV7wWYJp4EcGpv0ddG7oJ/yabrcd4s9/73eV2EHHOXykRrble3n/0XTTmvAddQ
         C9x9+XvNFIeyHlTnO/oVNs9BWLudgAfIbCvJpFQPgqJyhwGMZO1WzDGFl6yrPNd6eDCB
         39AJrrBsACUMrHxC396TjT9mV/ZBtdxG+kNldS+l2ODt/wnsQbZM+59EYjAcE19MqEL0
         JlDCZpu4OSi0VfWdpU2qYCPjyu04ViYdU7oK42TLwTmd97A43LEimJG25EeZty+bpp0U
         9V0i1vzYTPldnGlZ+S0XmTSMVMuLeNEwjtdPrr65znlM400HAgBnJyQlYUKL7UqTzoDX
         PSiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041218; x=1779646018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k2Lga/xnkIfsYMx9TVpbPnWyf/7tiVX1IsmYkQiqC5k=;
        b=FoGeV+qt4yowc9JP+p2JImDtCiabkEPRsuPsO4sSIQsszYBOTlk9IWlBuxpFVxIKzN
         4uDBy8YyodME5R+79XXqS0W0aoqeWfc/qG2lndZuqHNPGPs7KOaJdYpD/BWp2ERBRHYj
         lt1EEaltz/IeLED9YGxldCMflTE0fMvSVu7NSmIq1RJmI3osOxjEj+bNlvfjmJnPUJJa
         XkUFhKz9p8ZGMYGeJ7KQ2YCfZ5bfqHIv+Pr+kKEODGIizr+SmRu2yb5BcqI8PMXCaQ/i
         Atm259uHcYxRk7/li18mNs6YoK1jPtm9Y61rmLcfMkPOc5r/jWOpN4CQqWXXKRfZ1RIH
         0E4A==
X-Gm-Message-State: AOJu0YxLswY8dHDHE7prrqIVJAUw08fEMuo+c86KLAX+myLtKE97ELsu
	ILLcWsFtZfpZHgx5j2flC2zveLyGKnp7nAbwp+h6se++aUZt1t1Z5CYl
X-Gm-Gg: Acq92OFY2cQa/A9gCHYi7ZIi8BlHKyScgoZI9yHkgPGO+uk7wQrHbAD3L/dMwhuMaai
	OxZiHpqdYaKkdT8sah3sWHP6lS4MvtJV9aWSSQsEPxrwQY+fsW0RT7RSPQQ8Ud3/pHcJUAXhxct
	HCma2lz0PICHhaFGqLjoGXtHh8UHqU/o2EI1QiHscpB6rlzaE/xQjp7g5WQCkJZUx4+Vh3kO/Xx
	V91JHgrSWQXcsdy/TPHpy9TuVtLU4GR0CVQ43tTJvvN1hOHOqdxdkpAJoj2ivsiPSYf8Y0twvJc
	aeHxycMQRwpZH8dEDk7DjrPvoZEmsNKAjLqRXmk76BYk8pm7wJLkvzk8nbAQhDua8T70KBud/jg
	mGkEHd9ey317RZOy3DCI79tVKRU2c9Ih9fS5rbJz4D6FkdM97O59wEd//HrOROZjo/Ec3Q1G3N7
	aNKgXSQg3t8Au3WIQjCSjyPoDwhqrdMIOfIk5kkICcaGH6d/wLp8KzsFbXOmsN4GHAlLbngET/V
	Q==
X-Received: by 2002:a05:6000:1845:b0:456:3af2:852e with SMTP id ffacd0b85a97d-45e5c5ab792mr8453561f8f.1.1779041217551;
        Sun, 17 May 2026 11:06:57 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:57 -0700 (PDT)
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
Subject: [PATCH 10/12] crypto: atmel-sha204a - guard remove path against missing client data
Date: Sun, 17 May 2026 18:06:37 +0000
Message-Id: <20260517180639.9657-12-l.rubusch@gmail.com>
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

Retrieve the I2C client private data in atmel_sha204a_remove() only
after sysfs cleanup and add a NULL check before continuing device
teardown.

This prevents dereferencing invalid or partially initialized client
state during driver removal and makes the teardown path more robust
against inconsistent probe/remove sequences.

No functional change intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 613ed5e7b3f6..923e462ff6b0 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -213,7 +213,11 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 
 static void atmel_sha204a_remove(struct i2c_client *client)
 {
-	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
+	struct atmel_i2c_client_priv *i2c_priv;
+
+	i2c_priv = i2c_get_clientdata(client);
+	if (WARN_ON(!i2c_priv))
+		return;
 
 	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
 
-- 
2.53.0

