Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3188A3CBE96
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041224; cv=none; b=Pu8IsbJ3Qcr3hyso9t8TCS4/5RHBX0nvX0UR2rPaDs7LcJx+TLc79Q9v3mMKV2o6viBKjN5bkk6UdqPoJTU+SqCjao8pwP2UHNuizNC3jhnqd3I16hdNcFUNUas5u+ONqxJSh1yH6KRzphmooFUKtZ5tb9QFlhnvGvb6ncsPiv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041224; c=relaxed/simple;
	bh=PNmZ4TxWwBgQRqU2ayeKsYRSbfY5FFOto4MK3NHO6z0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UJ0bsYDXd3HWvaTsz4XaLAb+z82E2jhGs90AQd/4RLBC7klqLy6GsVp+s4VdB1EsQPtioqnLy20ftVTXleU384vWHFZUQ8+kf0HL5D3+w3urBiZXUKREVs3WWIcrCo013J86brrkrW/2BzeOjZt36Yi0pur9yMO8FCbNS+C1C24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8kuwWTc; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8kuwWTc"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488a8f97f6bso3337785e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041215; x=1779646015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZVKXrkAaVKO/vkAKRUgA7JaIQeAJzwGUI/xuakH4Lc=;
        b=e8kuwWTcZwccj0jD4T+7HgNiJOYRUI5kLQ+5qR58+Zs/0ZRHN70/Zw0apgU1rXUXLk
         /zwbgSN66vxI3/6kl7+2Y3QSQy2W33DThHDpqeoen2l8kzQg70zyQEf1S0dvCHAdHq2G
         XNwRmN6jL10kBJY+bxRywD5BKRxHJ8n3nZYl7jN41tLZwCt8Ks4xMAAv8qUegsIwWhak
         3ZixZdG/DpWQ9NSRL5v2vkkuKD36VJNvcmKojvE2Imz0PDV69IvaUv4JOzMEZQBxRtKV
         0oguF3cKkgKZwVVaZlPgijMkzTaoi/U33R2rJ7DIqN5aQ+LgL3tc8xRJ/iETpzGhtY3H
         +89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041215; x=1779646015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pZVKXrkAaVKO/vkAKRUgA7JaIQeAJzwGUI/xuakH4Lc=;
        b=iD6ReYLaG07VX+2mwpYwRzRkiru30syb4XNsjMBl8nkFSOaTJLMxc+I0ooCKCE+dpg
         XA1sXdwYMBMbakBDJ5zY+kCVQVaLc9lrLcgAF5Il3YwyTLC9OXGSR9oIauqE5lmkybMb
         0nnNye3JTvUYlT9Yw5TlKEsm03XwJReNzGvazmjKP44zKLjLM2GMACPybDH1LMFqX5HS
         RRLgUC1MxBurLbatT8GHZZh6pCX0srRoZyW2BHAM120pGesw1guEXqx4YV8GnEjPLdQ1
         xgRG7JXm5hvBX3/PQ6nhs6P8tC7Y4rBgGvk3Hfp0RHotoLDxxrljbFPz92GsQ3sBcJBh
         G01Q==
X-Gm-Message-State: AOJu0YzUSJ/5XqLWuS93TD79oHKMETDEVErVIFQ9wGyGEyOGhAatbEw2
	KvMykay/PGWe51v+1mavE8rOBvGfGevn53Rnq9PGjKY1/pOT8ulyDl6g
X-Gm-Gg: Acq92OHj7rseEEsvQZ2Xo0TR3UBf73XsnDMmJm9O7oFwjtGT1R5nnDGH1y/l9RnH8IW
	u6MQbdy/bWV4v/I7msSotSwPWAnAWRLs1nVPHsjjvtgoqbU0hwaZjQ8a7K1iVWub9Inb/zHuQ1Q
	CkzHj8qn6sNeYbPAEZFrA8LxWKRb2tbew22HyCdozywPJJw3LKd8bniP6k5zC2qx9k0XmeuLt98
	CVV2ZclNrE2lcgCZiNv9Lj7muS47B+T4wd2SNBBdIdk8NBjBpj1NBTuNEAU5K/BCta+uIRp6DWu
	OjaewE41Aq8r6XWSCiquFdHkOviN4cuqT321L2YXXL26wzfdl+GiFiK++Vwjk4skz1tvuvO/ztE
	eNBPBOHH3scrGyQM3yLU19NtsfE+/aRigbAkumBTkOz6M7KRTYThQva1nH5qrYC6Nt9lmYrVJm2
	WXDvuZh5WPlEE1yzcP3Kcq2GguUzJix622hbsl2u69PnxRuM3OXfu2ZG6DmPXP/v0rXybbw+Rd+
	w==
X-Received: by 2002:a05:600c:1f8c:b0:488:abe9:86 with SMTP id 5b1f17b1804b1-48fe631817cmr83409915e9.7.1779041215510;
        Sun, 17 May 2026 11:06:55 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:55 -0700 (PDT)
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
Subject: [PATCH 08/12] crypto: atmel-ecc - switch to module_i2c_driver
Date: Sun, 17 May 2026 18:06:35 +0000
Message-Id: <20260517180639.9657-10-l.rubusch@gmail.com>
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

Replace custom module init/exit functions with module_i2c_driver() for
simplified driver registration.

Initialization of the shared I2C client management structure is handled by
the core driver and no longer performed in the ECC module init path.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index e5dd77008b97..dcfc09d24497 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -392,21 +392,7 @@ static struct i2c_driver atmel_ecc_driver = {
 	.id_table	= atmel_ecc_id,
 };
 
-static int __init atmel_ecc_init(void)
-{
-	spin_lock_init(&atmel_i2c_mgmt.i2c_list_lock);
-	INIT_LIST_HEAD(&atmel_i2c_mgmt.i2c_client_list);
-	return i2c_add_driver(&atmel_ecc_driver);
-}
-
-static void __exit atmel_ecc_exit(void)
-{
-	atmel_i2c_flush_queue();
-	i2c_del_driver(&atmel_ecc_driver);
-}
-
-module_init(atmel_ecc_init);
-module_exit(atmel_ecc_exit);
+module_i2c_driver(atmel_ecc_driver);
 
 MODULE_AUTHOR("Tudor Ambarus");
 MODULE_DESCRIPTION("Microchip / Atmel ECC (I2C) driver");
-- 
2.53.0

