Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5083F39F5
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292655; cv=none; b=cgp+XsOZTiSI2wKmNNBnD00tBCs4rT+wbzCnoIcvp8Nbt5vjskrqGwYArb742wPHNksYrLA8nlY2mKU9STTakjmX1COv8aG/kainjVUaf/lm98Cp0cof5PxKQQGL8Bofle/+70WqL/pwWDSXqHJbS5aIJRGfryMdt1SAorVGo7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292655; c=relaxed/simple;
	bh=uUS9mRgrX2d+D+VTeHIFS9Z4IesaOwUkL2DTLnHENXo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qcuS6/lZimN4WOMO7nl8owgsRRmGPnAx7qDtiX1J/k3t/xnBnETesuoyHAWK3Zvd6e1tFPms8JVQd7gQ09SHyzf+UwMDbuXF5+rRk7EiP2OyIVcM7L+LTt4c61i1NEBavmwlJa0/FbX3OlkjoFcme7w5dno378KVSUDa3OL3P0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izSdX38+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izSdX38+"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488ac04e13dso4569945e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292648; x=1779897448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGnzECxDEMQ5FPGNyBfs1beCyp7+eMuwQgokKJtVuYQ=;
        b=izSdX38+YHHPCH2kwyOUWcT2WuLqpxIWtzMMkqPceS8seUII974Y+F8SU1awEPNmXm
         gSB5yzVWNgtjU5pNheFQSRf2+A/EFqzHNN7jrDeCDSKRqxypsHj6L3k5p0+WNgX2pYm8
         DepWieSOI3SWmXeAWarjatz1eZGEnh5x6qLJ/BcCk9bnjml0L8Mqgs/zdvjQqcN+JlG/
         blLXGfpHKCGbDjcMuORMqOMD06Mw+A9eqxOGzByES6wy/9YP8qjND0/LL6g+flbdWo+o
         So+bqDDwkqUsCxOojd1ObDGLQuZJyJGDQud6Pw2I+P/YYhFQy4t7+MSjDA4bS5JFJymU
         ppKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292648; x=1779897448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iGnzECxDEMQ5FPGNyBfs1beCyp7+eMuwQgokKJtVuYQ=;
        b=LykxK29tfWOeTNYyb5Xo+l6dPggxl4VVg78WARAJKDNk6oc30ojUtNbzXsXXuM6C/h
         7VFHTCI/h59VeU/4g7IefwTL9Pbe8xDEp8p2C6Ap/8a6QawvSvfcV6CUyfk7m4tgAsed
         +jF9TFfeWJety8X24tPV+SzNsUhWp131AzjDACwdUIIETnFDyueJgOL0I1JGU/T5Zs2r
         GVzQcxIY2gK8ocpBJ2S9HkCxRfSpZP+iEmQ8ROwTXt3h9ye0s/gRrzaIeUP+a2iQUaVK
         r2xOHWeaDzwvapJNxTPymZku7snXsLPTzh4z+xflCz6YyprKbNQn9+x8URKBAeQN7zWs
         dgOQ==
X-Gm-Message-State: AOJu0YxVKDFCbeVgI5AktHkSslQK/ewgInM/hJgAqnhRI5sRO/ObrU9Y
	QJ5bfIBu/dXDYcz67gtaCcH40LJetmWKIpWvpUJQxWLz3JmIUjrxUKP3
X-Gm-Gg: Acq92OEvkJQB4hVpdb7pC+R2LIYcpcloyCvscvdc478FNvomIrU1KC6baaGYE2K1kHY
	RZqPOoCpZ0JBHOMjxngP0ODrfNP0cxTG8h8ppsErMxwtYgw/uBeV+rgdY2fHi6W/HtZXg/6Zwzp
	C+p8CYCqezqyWml1OhBVva/90qji+plfLF/OCvf4fkJpY7ckZVZ3ngqSfhsEZUSTqbGRnj4yjID
	FJEFE0H1Z24sQJKbPE59GXoupH3MTbH1R68mbWb2vi9l5IasHnxbuMejk8wtvSMVQfn+1Ew2JNR
	9OBxPlRwTNVu3M45NbQsk9ym5kA06I/tz7kkoKqBGRP1AnSkRpsSwkdw9bzxezc52x0CEN0nwNI
	N+zDTrJ02MtvopT0U20lv7ilqh4z1vCrFT/1Uo2ik1o+rewUJdRwPrGKsMTtbHpNqguwyC8whEp
	rkow194iE43dt1eMjDDOSQ6NQZ0gZ/NFpcNxYlzRoe6TI6daajdt+pV/N4ySI51CY=
X-Received: by 2002:a05:600c:4f8f:b0:486:f634:f2e with SMTP id 5b1f17b1804b1-48fe66423e1mr168105295e9.4.1779292647916;
        Wed, 20 May 2026 08:57:27 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:27 -0700 (PDT)
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
Subject: [PATCH v3 12/12] crypto: atmel-sha204a - switch to module_i2c_driver
Date: Wed, 20 May 2026 15:57:03 +0000
Message-Id: <20260520155703.23018-13-l.rubusch@gmail.com>
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

Replace explicit module init and exit boilerplate functions with the
module_i2c_driver() macro helper to simplify the driver registration
path.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index b51031ced7d1..41685b1df442 100644
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

