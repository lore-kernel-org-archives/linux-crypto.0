Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ED5356745
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292648; cv=none; b=WJOH+0BJLMSds2eVmFdh3y7/cxVAJNaxKhX7D/Kflp4plGPgeDcJMj7CnAvNUr6uUFQlrOK9UDX7m7yVWXcyXmFVq8nTccQJJBeR1mHiQh6sRIsQu8S9eYw8aHK4x7vxGj5HfFyjwvXb83nfGJ/q+C/AFC+SFJm86izpKSvvUgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292648; c=relaxed/simple;
	bh=iphzX9m1CPwM3v3yxFp5IFORgP6SOja+j8AN24Me+JQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g0FU3iAmLkalMLdQuO/NUS5ARP9EH1DYLNY0oELdOmmLxnT8OhZtqIsNnPjX5FbItUKNaCZpTlyqNQM42Q3APHBM1HeVk09BL3Qt7WPHnhD2x+Bf+y9qq/BtwUqAKlhLH15y2Rx5WrOD7Aa3FspgQKzQIhAAbUVM7d7KkFJ8tao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=khGwLebo; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khGwLebo"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48e69e60063so4651285e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292641; x=1779897441; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HmGPE3DNDSXOjHya8g4AmQk3m15oPbfzDvM3u2NfIRo=;
        b=khGwLeboWBj8aMPSunCUYEKd3oMWERFrchme2GJ7VxxnM6UwFWQD7NZqp0H6vvUgIf
         IqXgaevq4xEkcUgMvA+lrxGA+qezXCQ73lczVLcBMG5myPifjWvbBvxBvVxgtJ32UgzH
         tVhyUAUr9C8PkwRjULmehHMHSml8+ndYc2OXkTew9kqT2NBsD6o0WxkjnAmRUuUTO5Ht
         FpSbFdM/JETSbGxF3JHrgZA7tkFExtUxUErsdAi8307qtfC8G2CHI7FAFpuZlkIeJltM
         uEH+gBX3w/EJQlfglO/CGbWFkcyxppKaatWt26/7uJK1SecwWhF9lvVfgsQDyO6ntV74
         Ygmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292641; x=1779897441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HmGPE3DNDSXOjHya8g4AmQk3m15oPbfzDvM3u2NfIRo=;
        b=OxrUjA9hmrArUf+GfnoHlSsRMrAxVeXSBOZDjNDOS0JOuQh3Q2d7hCTS1AWzViXA0x
         iNc1SePm6DRrB+DAgq4HFi6n6TZA2+JQZjpIeKsY1CBnznwExwO+SYyC0A4E47C95RkB
         tHdKdaaugHWox6gqDIQrkLr45qdk4tK/KqzPqecpzGsBX4e+YM/JJmTOm7/Pu+N0KSBE
         FL4vWVv87m7vtn8/1z1K7MsP8dv0L/3D2pKEWrhlfKbzSisZe4swghLfdPDi6Td3W/oM
         7TWle3yb0V2UagW0e3viW+u5Y1psg9NbipX5yt19ButDQTj9uAZ+UNayzRaKMSakNiSN
         YpgA==
X-Gm-Message-State: AOJu0Yym4YjopHFqlgwwXPpalzrm/TeR4fUXX+1hp1q1cCZI6bWBRL4P
	wzHYLc9j0L1XmGXu3BgqEcYuC/JkEynDcJitFFGxy/tomHOp7+kfh+av
X-Gm-Gg: Acq92OEYo1Mcy8osuo48zlD0h2LIp6OckwDEve9r+qgUGaDwXwze74Xz5/BN1f6svg9
	ACIxsbJs5vxatTZknmtHAhKhzZ9B6jV8UaDGEm2XzI5E2+g4Iu4V1QotMULd/1pyTVumQWalHJS
	q2UQyXDFT82/Vm4fqP12ivukQNPnvs2ngKT8axR6tCcfNhqgEW+xdtjBjZdeslfnuf72RXmK3rz
	OsosyI+UWiKyFbwikSKcQwLQUmwhfeoiwhiRnqDJft2zpCN3g/EHyi5zKHAE84HnGxF/S1/9B/T
	2GDp8MG9dAyMRXmTe5xD3d8Os+eNCiAI9hBjFskX+H81dhI5rfnMdmowZkknCnev/5OKikMdQgi
	Rc9h0Oqnilq9ZisL7ltczokE5snZ8zdVyb9y8wU9YQKw3uyXJA8qcooJXItbWvDrpfvLk3CYclz
	eUgEptam3g98lSirQ5JVuqssUJwXnDjXhsd9YQR8mjPBEM51wJkk7uTqXjTXYrsOw=
X-Received: by 2002:a05:600c:198d:b0:489:6c28:dbb4 with SMTP id 5b1f17b1804b1-48fe62f7cbbmr206383235e9.5.1779292640788;
        Wed, 20 May 2026 08:57:20 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:20 -0700 (PDT)
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
Subject: [PATCH v3 07/12] crypto: atmel-ecc - switch to module_i2c_driver
Date: Wed, 20 May 2026 15:56:58 +0000
Message-Id: <20260520155703.23018-8-l.rubusch@gmail.com>
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

Remove custom boilerplate module configuration code and convert the module
init/exit paths to use the modern module_i2c_driver() helper macro.

This shortens and simplifies driver initialization. Custom structure setup
is no longer required here since management tracking context initialization
was already safely moved into the atmel-i2c core library module.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 433f40224be2..f166144febfe 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -397,18 +397,7 @@ static struct i2c_driver atmel_ecc_driver = {
 	.id_table	= atmel_ecc_id,
 };
 
-static int __init atmel_ecc_init(void)
-{
-	return i2c_add_driver(&atmel_ecc_driver);
-}
-
-static void __exit atmel_ecc_exit(void)
-{
-	i2c_del_driver(&atmel_ecc_driver);
-}
-
-module_init(atmel_ecc_init);
-module_exit(atmel_ecc_exit);
+module_i2c_driver(atmel_ecc_driver);
 
 MODULE_AUTHOR("Tudor Ambarus");
 MODULE_DESCRIPTION("Microchip / Atmel ECC (I2C) driver");
-- 
2.39.5

