Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C953769FC
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 07:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779260580; cv=none; b=IqcjLo8yyQ+lU5tdrsCezfGoOM1gXFhNabNm/zaP5LzfOBi0oMdRo6umNPFQ9d9vFA5vebT/CZ0r2vHM4qUOjOUMYiEiVPwM8Yewd7Xa7P4Gj8c+79QfVtwsK2wCxye6T21GkrOTY4ARTm0y2I47BAqZ5mIQs+V4UAWwtQPqjFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779260580; c=relaxed/simple;
	bh=6sHnZ7ZDkZwO/ELA32fLjOM2FmreNobcp5iTRFP1biI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WBJKhKmUMtX1DBUjI0MbnC3qhTkWCcigv0O2Mycjyhpq+EEHXJWJU91lEb2Lq5A56fZCeavRO1uwpJvRIpWAZBugx6gM377hiN121+PSgDKJzJrrLHJ/CC6uKFr/pHdKlw27oaoiYI5TegqAwnakOvhWt3hxPURr3jQwnlkCIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=fjNEB+Sv; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="fjNEB+Sv"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48ff4f8ef0dso50349895e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 00:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1779260578; x=1779865378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2r8ZfbeOANY+fmktsmJzHagukEdKQO9jPLOS0KSMVw=;
        b=fjNEB+Sv1u2fO116AP5zzL+wxmCfUsZkpysIPUk7h8ZloIBQCFe7nSHPVGusMXHJ4O
         xSv3xjnqQUzLd/TgblE5duO382/ZNCkWHY4wXFRFe4CPc3JmIXF79l1B0Ye9VWoLX1uG
         HcYxpvXvmpzBZiNjf/5mDsMfaj/Zln6XfH8r7FzBTUdh1VHVIepQQgkRgnTrgoroiw0e
         dQduNn3ebbuij/RS2H0MBIQCB5j/l5rCD3QVj/ZM4vkuut5NaMBJQvGLPwBRrldQzJND
         1ekYdIWAgXCBt871m5SlM8uveD1JzqlVomctzRHXuhrmIzfK/c53n1gKJK4R7l6EO+9J
         dCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779260578; x=1779865378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e2r8ZfbeOANY+fmktsmJzHagukEdKQO9jPLOS0KSMVw=;
        b=IQLQ00dP2rRjXXNb2ocKXv/a3AH8E2RX2vrm4D8dduUSVfxayc1FdxbsGBLrhaDp0i
         vZwt9A+ZAT/qW2q1EeqkuYmlgBrIwr41Q+zdMd7JI8WVi6ZL04m4Zll1i5ka8oeFR61G
         znBzRh5TEeRxZss+kktFl//j7n67H1Gfc+9ydw7CSMogBJLHvHzkEbk5KAAa8O78RGkK
         5XfT8eJb5YMap11HVy9CZf3VhjyH+q/8bNH+fEevhHmvRm/oOStN26Fg35wvK/YKtltG
         Z1qvgWjPKPnimOzZZ30tTPNRbWyKOq+taD1Ic8/bL7N/KCEdi76bDssuKvvO0CHJA+Yg
         K7Tg==
X-Forwarded-Encrypted: i=1; AFNElJ/qGFvQUKl2V0mo3pNGo083US1jEOj0JKyYDaGJbX3JuS3tHWRYgIx7mCKlM/TKq/nQBYcTW/mSXazPmgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEDPnIWdifDbFPqq1MpHhT07AfISvDTi458IKim+6s6Gazg30c
	O5n8TDFo3USa5R8ucjYoGTE/brmTChdpl1LzFcDDPDuvhgbGbhMN1rLaNKJFSmJC39U=
X-Gm-Gg: Acq92OH8X28hhmWWyd641Vh/seh4EbF7wJZ8d+TYt3HiyIpE5XSwV9LhvQ1Kmpxgs7d
	FJTxud4tX2g4NXg0YyXyCa2VL9j4ANqhoL4PMxHqxQkfAJBIIkmYfrOxnnnnotuUXXIHrjMKbJq
	O4/EpRVUKG1viQyaQCKLn1v7JfjlvNVTM/9eH+irNKj4aJY/N4QuLYLvuIxC/EgVZ0k/saMxiXv
	tlH2T+/VGvfcrlAZVSj0gItiYA3lZ+XK4dieTAI5d7pQCuJIcAiPf9Vwt9sT2S9PfuROpOF35WN
	yzC9rW3RUW5U13FAFl5TI+e4eFMJmsr6BOmjKVWdrJzrf47xRQa7w5gSiEikU6AlbSFSGMuCVzt
	WqgWP3ywsEBLa+9oK1reiMwivamrfUE2WqgJJoii6mOy6UDCLYfpRMML/YtR9B1m57EuioPwbET
	V2lqqdzuDAXDTDE8/C/YkPdMRf/PVIQT/q0AS13K+reCYTlEoGN10X/CLuSJ5AM3b6wtAYZ/MHw
	68su7svC/app14=
X-Received: by 2002:a05:600c:3f1b:b0:489:1c5f:3a9e with SMTP id 5b1f17b1804b1-48fe60e7fa1mr350925945e9.13.1779260577642;
        Wed, 20 May 2026 00:02:57 -0700 (PDT)
Received: from localhost (p200300f65f47db04a02ef40d8e5825ac.dip0.t-ipconnect.de. [2003:f6:5f47:db04:a02e:f40d:8e58:25ac])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4900c16c744sm209846985e9.3.2026.05.20.00.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 00:02:57 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] crypto: atmel-ecc - Use named initializers for struct i2c_device_id
Date: Wed, 20 May 2026 09:01:30 +0200
Message-ID:  <5711bd2d85ba402b7185f181971fd8a88e27b93e.1779260113.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1779260113.git.u.kleine-koenig@baylibre.com>
References: <cover.1779260113.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1113; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=6sHnZ7ZDkZwO/ELA32fLjOM2FmreNobcp5iTRFP1biI=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqDVxRwXjR/8wFPq0ijLyNy55GxgoYBTKHbOY36 ppHF0wfoeeJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCag1cUQAKCRCPgPtYfRL+ Tjf+B/9w8fF0Z+d/3nEoVS7IKcFvfRGIx8sDafLeNK2XmWasfB3mIYSs+Q5iDqoCDCQmt5ap200 nVoHFy/+28/LiJXCnGIOVK5XD0JOcu0mCfS/qfuMSAXhGDEGOIREPYW/jolkPOXyGwUDqzFw1tC GWIdDkF0xkXciXakvlhZ2BNqXIMlAMKwJLvLS5+DaGfR0ihqgCPJFfOtSObMOPCDIAziqCNe6MZ ajwne2qSW1SG57U/NDgfR1OemzWQLsIOaalbHlohvBZIFGrByCZsYv2ffEf51mrAsGKDIUgTa33 R53syq42tDq9MF8o4JWoQcy+PmSJZZDChKecHekAi21iduql
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

While being less compact, using named initializers allows to more easily
see which members of the structs are assigned which value without having
to lookup the declaration of the struct. And it's also more robust
against changes to the struct definition.

This patch doesn't modify the compiled array, only its representation in
source form benefits. The former was confirmed with x86 and arm64
builds.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/crypto/atmel-ecc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9660f6426a84..0ca02995a1de 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -376,8 +376,8 @@ static const struct of_device_id atmel_ecc_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
 
 static const struct i2c_device_id atmel_ecc_id[] = {
-	{ "atecc508a" },
-	{ "atecc608b" },
+	{ .name = "atecc508a" },
+	{ .name = "atecc608b" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
-- 
2.47.3

