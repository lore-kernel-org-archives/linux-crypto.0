Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FD031ED80
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490922; cv=none; b=cXoaWkdRT+7tAw11HSsy69mS2ZoQTby3doBv9awBBU16UTyMs5WXBAOwF6mQAhNnlJfspQ7Q6NTEWt4ddfug3l9lsZ+draKuUi+u2x3F9ObstQdaNRMPSAcF1y8NqXhhhzStgoD95MhpfmxTJlUzOxQsHF+ZeeYjUUtMqpGD9pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490922; c=relaxed/simple;
	bh=y6gvHfSWjliLefCmgznPVVvqnmtLA4twQizeFJStDhY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MMJeW0eUGk7XRF3araYdckR537TyDvnFHN+zPilYVx0xagFSPyZXNjoR7ZdZjkEI5q1gBfm6IgtW7c0TWaCf6pBNLesihVfaBPI/IgPs4+7RuYd5afdCFS+bYYEUImlLzQ+Hz0YSq51DYjsxgRz1MbddakzBCNGZRq/2yNaBsIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZS3+Q6cW; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZS3+Q6cW"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-44c44af71f8so926731f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490911; x=1780095711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sANsrQm+/9rauufhu0v06B+xNWc+JsN4ukD6rF0U2uA=;
        b=ZS3+Q6cW5gHEIPk3HLSaVF/s83zyQ4OHoS0npkU436zTHNJVg8jd9MtK8A2lTjBHPd
         Flibtm69WpdK9Sq5LyjjklcupXZmudDVTT/fSow+zFvk/XSEGt+DRn6XpF7s3I2oOkoy
         LP6dSM8NIb6HLNUJmiORF4qnR6PHJ0uByrGR/OvCLAVo3Mxfko2+i5AHdlrfIBMvsNqw
         3gjtyLVZpA12xz/8dVfLj5e/1WLR12EAgI/eOOXZ2S8f6Hn65XIlm9arrIGSPA1y72h5
         V1q1/iQCCE+dEeFpqf7kLdGmnjzP2M3RsP03/gSq+q4zCJIm+h6VA+pDH/PyOUccPBTp
         B3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490911; x=1780095711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sANsrQm+/9rauufhu0v06B+xNWc+JsN4ukD6rF0U2uA=;
        b=Bz9SGS1VufYRC1kMPqlxHntsyO4Q6UJ1q29JQKJO+/XPDGpwOpEO0dieXWzGZYjVbX
         uOZ8IRVspo7kiuJ8zXF9xrFM34kDrXtKW+iTr6yXESfzA1zFvqHrEMQts0w+GXR2Q4RG
         z1UckmWpndTJLXserlZZvmFCiBOINx2zSAbeciw7fwzUCAfg7ph7K6DAT7HVG8KuOecg
         +YO0keuXtnvfer6OCQnAtKuXnF3e+VwBEPxqsLK9MTCqmuO3FLplAJG17DGCos72n6ec
         O1al5RzwjAvgFl3E8aJCaPgHej4tAlZF7fZT/XIE29UJ1erxwwKuCoc6M2Vh6ZtjftK3
         SLLA==
X-Gm-Message-State: AOJu0YzWugsMzq6RLWAf0Tc0W5aTWYn/VlQtreVaJGXgWiJOhsF5cCBn
	yp5ZHuFrBW4Bmwr1eSx/4b421f4EqF7OuEkM9ZqzHSil7P/NijqL0Pie
X-Gm-Gg: Acq92OHZsOuQeFFI0FbaUlnHpj6SpFj+WqPyRyCYzbfaTwphK9W5aB1ayd6FwFix4VO
	ld+fYeqp2Ps26hrlsZUFPtameYO8y5B2CBWObKkM/2iUxKYKpNX4Qcy4JmVr0KzKSFGChqcYIOE
	64MrnREYLM58tQdEh0s6a/jZiEKk+zGG2nqN0cVTMsah7sM5Hh3QirJr8D+pEIGCURYHRme5r2u
	K7yw8MJQQdGh9EQrHncYbg3bkrnBnXjGeSIME5WsBawW4RyQIeY6MG5FDKc0kGPXDUGEzjKdUDw
	iE2lnGupxI1UAOtHMWYVwf8niHX3xKnweKMMYwr9l8ZUhmoNbYgsV1fq+cGe6WWvjYRQ0zuuZTW
	h0LoexHX9G13VBeFXXKtpe2CGhJY4FBRavep7UUrgYo2sxHZ3XeuSYkg8efy7rO0vPr4XnzSKuj
	w7MxwNCLTdv3IAJDaUYuhZ3saw/WlcrUKIg2d+cRWxyygGxYeKgBxs/2Bu5h1Pxn6a6EwpkymID
	Q==
X-Received: by 2002:a05:600c:4fc7:b0:488:a797:f099 with SMTP id 5b1f17b1804b1-490428cb441mr41259825e9.3.1779490910803;
        Fri, 22 May 2026 16:01:50 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:50 -0700 (PDT)
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
Subject: [PATCH v4 08/12] crypto: atmel-ecc - switch to module_i2c_driver
Date: Fri, 22 May 2026 23:01:30 +0000
Message-Id: <20260522230134.32414-9-l.rubusch@gmail.com>
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
index e6d3e6574251..d2490693a198 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -442,18 +442,7 @@ static struct i2c_driver atmel_ecc_driver = {
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

