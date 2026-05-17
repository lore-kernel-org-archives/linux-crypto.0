Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462B22E7621
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041210; cv=none; b=DcFMH5aquxz57D28kFwjT3LRjFouW3dS/WOWucnq2Fm+LVxNqoGr+F0C867FdLu7WNeOLqPFUHPaucYOiciqRzYsDHmo+YpxeOevpNVnL3IFUD7f9MJeQ/NoBl6s48gmPdv54lmeIifzXJHj0wWATzz3Z1ak3lLWEISPQLP1uQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041210; c=relaxed/simple;
	bh=q9vahDLeF0paWqfekbQjBqfdEH/373Mc1f3Pd2pMUUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dTYvEvOccacrEkZPD1pH7Kn7f8Lazi+R7KUZGN8aiDil3zcWPGYjSm6jrGHxs+tgsI8qpusv8lV5+VWsWwKTdhJtbyR5HRMmPeCsVm1jlemdim3PBo7/HrvPTDcvX1HHr2WyqZoyXELCF1qXt+DPQf9AGRj1hfb2hFa/dl2HkK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qvNUMt+V; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qvNUMt+V"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48fde2f2d61so2892715e9.3
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041208; x=1779646008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UnEz4kb5yNtR6Ed+ZspZs0azXccaDtFZKA7zrYYeQpw=;
        b=qvNUMt+V6o2pPzgY7CCODkWCDvdzRKq+HJtFK3Np+JjgoGln3kZV/a9iYeL9dfjn7b
         1fssLoZ1vcKgedZhs6raVDTwx54GX9VzBpPabFehFIUBc2HnEWQjoJVG9NpwqzRyuh0h
         VVVAqKD0ecoc3CB5hIdc+Lo3R5E2wmFB7wzHhuRLCEKY/8RJ4sKjHnMVgOzk/8MaE9KC
         pE1+PZ4R6rLHugDXk1T6cc4sniwrduA2RWjDHQ+EbRMrC70tw32RLAOm561UBZ7lnr9B
         FLDoutzfFFQRMmtKLCW/+/17W5INK/033/w0BzzRc5ARl0IhVhFzXpKA7L3gmcI9xAiQ
         wD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041208; x=1779646008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UnEz4kb5yNtR6Ed+ZspZs0azXccaDtFZKA7zrYYeQpw=;
        b=BJLBTTiiEQHq1ngAhyIxKC2QSmVIg3zH0meb+7Wj2vCxIRC79iPEqE3O1gt5q5w20U
         ex+3/4Eylul58jMCkYCIq14pnuAdzquVUrtkRLtZC0YKobNGeCA/Qhd2OAalhixZ6k82
         XnF//trbw1Kuab2pf5tBOoXMl6RB8RrVvQ4s3I+WFdyg8ImSlYyT9C1/9Laun8LVy3FE
         pozUr4+lOporelcFh9nweyMvhd1wx5qerolvq3Z1lm7BAaV9a9XK/qSnOWnjKTjqkuD1
         N4ZAb16s/KZsyOGbVX6C6CpO/GgeBYckVvMtF1E1YhABCOazhwt62Fh7ZRsnGBueMyUX
         vW+g==
X-Gm-Message-State: AOJu0YyE7SdLTjrLzTJ4H2lTezN/JqYtqtmMUKSNkb7xMyOXF54Bg7IG
	rssGnl7bUDR4YlNiXp7kAkNTRpw+fOtu2PjTHcCJuqlu+Tz/e7IQC6Pu
X-Gm-Gg: Acq92OGG9uEFuSGmPJBRRNC0xKwSyajqfX+s/Whk+um0n6im/d+2v19X6VxAOxyOf49
	OGdZ/1ZgdKBHpc19i9bLnIMOxo+cBej1p4wzd/se2qMG4CrfSWpVza8BSMhEvgEV4nodZdO8i3G
	q8zOk/wruUXQU5JOlRsxS39YaNbIXwfeIOBYmthbE/vGThenZzKFqu4I0txdsDRKnhWKFuJtawH
	SG2jwqOG24dLH0JY8MFz+wPmiOQzwPp8tV18VyrYT+Y7poxhOTZlOmG28BxDSYb5jQSL6FicWk3
	WxGLxj3Z0dBZ9XYZOdgJtijz0ls+FIv4Srd9grZ288OnVsS7mS53T3Y3nxIGJ1HceQbj+gk/CJw
	5nuPxo2U74bl5V3riqHxggda0DOV4eiHpMwgNKfieddB73IJUessufpGbLILmy+t+HDVEghmm/q
	TsK/TWfhcXpbgDvoJ1TMkFyC+dGelBheIOdHB+K3xKBqFg9dJeIwadlh2owi/dXEM=
X-Received: by 2002:a05:6000:29cf:b0:452:db27:b3ca with SMTP id ffacd0b85a97d-45e5c60a590mr5430759f8f.7.1779041206655;
        Sun, 17 May 2026 11:06:46 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:46 -0700 (PDT)
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
Subject: [PATCH] crypto: atmel - add capability-based I2C client selection
Date: Sun, 17 May 2026 18:06:27 +0000
Message-Id: <20260517180639.9657-2-l.rubusch@gmail.com>
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

Add capability filtering to the I2C client allocator to support
feature-aware selection of hardware clients.

Each client now exposes supported features via a capability mask. The
allocator selects only clients matching the requested capability and still
prefers the least-loaded device.

ECC marks ECDH support during probe and requests matching clients during
tfm setup. SHA204A exposes no capabilities for now.

This is preparatory work for upcoming features that will extend hardware
usage beyond a single algorithm type.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     | 4 +++-
 drivers/crypto/atmel-i2c.c     | 5 ++++-
 drivers/crypto/atmel-i2c.h     | 8 +++++++-
 drivers/crypto/atmel-sha204a.c | 2 ++
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index f877f236552f..0eeee9ae6c48 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -214,7 +214,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	ctx->curve_id = ECC_CURVE_NIST_P256;
-	ctx->client = atmel_i2c_client_alloc();
+	ctx->client = atmel_i2c_client_alloc(ATMEL_CAP_ECDH);
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
 		return PTR_ERR(ctx->client);
@@ -286,6 +286,8 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 
+	i2c_priv->caps = BIT(ATMEL_CAP_ECDH);
+
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
 		      &atmel_i2c_mgmt.i2c_client_list);
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 4beab68997c4..b7ee2ec37531 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -57,7 +57,7 @@ static void atmel_i2c_checksum(struct atmel_i2c_cmd *cmd)
 	*__crc16 = cpu_to_le16(bitrev16(crc16(0, data, len)));
 }
 
-struct i2c_client *atmel_i2c_client_alloc(void)
+struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap)
 {
 	struct atmel_i2c_client_priv *i2c_priv, *min_i2c_priv = NULL;
 	struct i2c_client *client = ERR_PTR(-ENODEV);
@@ -73,6 +73,9 @@ struct i2c_client *atmel_i2c_client_alloc(void)
 
 	list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
 			    i2c_client_list_node) {
+		if (!(i2c_priv->caps & BIT(cap)))
+			continue;
+
 		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
 		if (tfm_cnt < min_tfm_cnt) {
 			min_tfm_cnt = tfm_cnt;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index ba5a860011c8..70579b438256 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -115,6 +115,10 @@ struct atmel_i2c_cmd {
 #define ECDH_PREFIX_MODE		0x00
 
 /* Used for binding tfm objects to i2c clients. */
+enum atmel_i2c_capability {
+	ATMEL_CAP_ECDH = 0,
+};
+
 struct atmel_i2c_client_mgmt {
 	struct list_head i2c_client_list;
 	spinlock_t i2c_list_lock;
@@ -130,6 +134,7 @@ extern struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
  * @wake_token_sz       : size in bytes of the wake_token
  * @tfm_count           : number of active crypto transformations on i2c client
  * @hwrng               : hold the hardware generated rng
+ * @caps                : feature capability of the particular driver
  *
  * Reads and writes from/to the i2c client are sequential. The first byte
  * transmitted to the device is treated as the byte size. Any attempt to send
@@ -146,6 +151,7 @@ struct atmel_i2c_client_priv {
 	size_t wake_token_sz;
 	atomic_t tfm_count ____cacheline_aligned;
 	struct hwrng hwrng;
+	u32 caps;
 };
 
 /**
@@ -190,7 +196,7 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
-struct i2c_client *atmel_i2c_client_alloc(void);
+struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap);
 void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
 
 #endif /* __ATMEL_I2C_H__ */
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 923e462ff6b0..1a28c6434669 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -173,6 +173,8 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 
+	i2c_priv->caps = 0;
+
 	/* add to client list */
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
-- 
2.53.0

