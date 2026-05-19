Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41893C342B
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223715; cv=none; b=BtkzMKIFl47CeaWemqHT+qV1iFR/sXBJvAaHOz4RpvzWWj5dWohMrWeilxqdkMfuyu2YHi345srNGtz5wXBUzkBX+XQxxBN/ayzWUmvbbZQnHij+wmQ+Lt0QJlMt9Ok/+BM44+uryRgs+SL8z8QrxlY7I8q2f4JVHqRu1UD/bbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223715; c=relaxed/simple;
	bh=XMfcMq6rOzpfpas4yxMb/mzY/1QxzkR88p4GpeyFGgo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HWIZtLCoBXkaDg0z4GzRdNetB0OPygv/9rILkhKOuTj3q2oWGpYtNbv/IoJcqeT0Kss6gjWqIxDCmfmwtJRc3zq0jtbcEcIwy8t6ZKq9I+C1/WhunUnvMlUucFDIr7do6Xni5zx0OxXXPPwSban9qm/gcUJ+dmQ1xCCgYP9uruA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e76ZOV3d; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e76ZOV3d"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4462f8d2488so257938f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223701; x=1779828501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/yTt0exYCuTu7jCoMn14Ieq943zuwmtiBW2wGq9ojPY=;
        b=e76ZOV3dkDe95sVQmOMbnf/TTwTMbEc5F1k7+OjZswwJBvu0NIKc3ofalThlyO8RmD
         rc5Zs81G2i85OY+bvy0lh4WXhIhBUgnKPr4fvaGMT7wCQHtTGCmvPwpGpEIZCoOJeLUx
         cWPZIxZPG4ByCoOhEMjcA+zV9OSimLTyu/co07JfAiP5F3ZQknWCw9a7wL2JAhKe/uAZ
         1ZsisZPyzJS3ZHWY6E0jYcJkwRJs8MsHkz0STs7wHgldLSsZGtjbMLEdPH8YihNBVim7
         4mumjBwevTZdBl0DB+GNsag7M/3ZaPo9DVsSEkCtMmjfus9/IPqJrZdqDzU9cfiuiVmQ
         jWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223701; x=1779828501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/yTt0exYCuTu7jCoMn14Ieq943zuwmtiBW2wGq9ojPY=;
        b=gP9Rya6gYF9lpA5modB999IJWHZOgezf3/l6NY7eL5/lCw67Fmo7L4ifsmkhkN6RVs
         dzh+Yzwikpi5A+dFKaYdcM+w8Ib6ilX/iIF8+OaFPfzs5VN4JR5dGby8+XrJl/0PbZfu
         gJUptZHKc0o6kdpY7KEac3kgXFwkhv9wD2zlepbms6ffFa8UKOr0uinMp9UacRnqFprh
         cdL4BMm1X2oXP13Eua3GOG1/vkzNwYl0jO8ZY3Q8fh5o4AAgQuAmYI3KvbF52Jt1EPcF
         Ty7D4YPVOBDKBr+k0MNiHy9W4AYGXwGFTEMLcrRRgB5XNu/ml5aM51AUoboKMWYB6EcX
         jdZg==
X-Gm-Message-State: AOJu0Yx/rTa7XFgEHrsLkc6jp09+9teWxx0ex5gzv8eO6XnBsT6mOJeK
	p2qjN7cPWIfz+WLT0RYxDUP3ztqUTUX1okJBOo7q2wZUJnlfCZn6W+oW
X-Gm-Gg: Acq92OGRHJzPwTebDBxEJHwh6lXcsJQysrnwmtPj6QRcuJ+32b0BaCeeF2Ap0FaO1JO
	tEZwSPLoTgrpQfJzJbnDcJA3Wq5R/PJIqfKyucPynBTXF5MNBRO/69xhFZtU77p+6PBYY7GqNg+
	n2cfvcFyXlpA+6fI+sGI8FVhTTudERdfkXkAGtaQEFXVgDAjz6/qMQT7wOVQIGCfH09CdZMBKPk
	fDK8txmuOg30KRyu1Czqah+eruWtl/n25R4bYwsJgbjCQPr73zlamNCiNAMZopmQt/z/mzxN2cL
	OemMi/TxSFYQWiZnFOCp7wU6+5EjGcjDrZ85qrivx6kGl+XJA5oirER+c/1UVGvdUV1n308kYXm
	smAPb3CTrcOHHPtzFJQwPsxj3GN6z8CTr7CLXmM+kz3vrwPLzdOCqS5FQX/tmYDfixnkJ8xJqP0
	+OeSt+qQk/YQiSnsMf5N7Kd1DWuyPEIca8LAKw2dJrHr5f3F0p88aqvRtmv9A4uJjlKIeRRvkyo
	A==
X-Received: by 2002:a05:600c:4fd4:b0:48d:1021:e5d1 with SMTP id 5b1f17b1804b1-48fe61f717emr143199075e9.3.1779223701114;
        Tue, 19 May 2026 13:48:21 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4dac000sm356457755e9.0.2026.05.19.13.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 13:48:20 -0700 (PDT)
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
Subject: [PATCH v2 12/12] crypto: atmel-sha204a - switch to module_i2c_driver
Date: Tue, 19 May 2026 20:48:03 +0000
Message-Id: <20260519204803.17034-13-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260519204803.17034-1-l.rubusch@gmail.com>
References: <20260519204803.17034-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace custom module init/exit functions with module_i2c_driver() for
driver registration.

Update remove path to unregister the client from the shared I2C management
list before flushing pending work and cleaning up sysfs and hwrng
resources.

No functional change intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 3d29543032cc..c65630a989a5 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -257,18 +257,7 @@ static struct i2c_driver atmel_sha204a_driver = {
 	.driver.of_match_table	= atmel_sha204a_dt_ids,
 };
 
-static int __init atmel_sha204a_init(void)
-{
-	return i2c_add_driver(&atmel_sha204a_driver);
-}
-
-static void __exit atmel_sha204a_exit(void)
-{
-	i2c_del_driver(&atmel_sha204a_driver);
-}
-
-module_init(atmel_sha204a_init);
-module_exit(atmel_sha204a_exit);
+module_i2c_driver(atmel_sha204a_driver);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_DESCRIPTION("Microchip / Atmel SHA204A (I2C) driver");
-- 
2.39.5

