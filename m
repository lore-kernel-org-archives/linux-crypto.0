Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32563CB8FF
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041228; cv=none; b=mkbrk4LJbTHLeD+u6H8QWj7wbdhmmkCPCEx57l9W3ukr5UsV+x4+Hr+LxTpoIxxdaF5k4uC5HL+42zBSTj49Fb85WO+bHcKrJVkbxSPZdqlMEiFZaADN02zlJyv8ey8Ei6KTLYvNHNBxZIyLwhCrb178C9NlenjwFHfYW6GNfYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041228; c=relaxed/simple;
	bh=q9vahDLeF0paWqfekbQjBqfdEH/373Mc1f3Pd2pMUUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lmOIgeVc38Ojd6CGYN6nDsyLSa7E/ioGg5QQXQqWSOjPrsRd8ae8k7XYAOl16dLqEkULgw9WuIwkQ6k9zNUGZ7dobulDGfReDLe0CTOdKvioyRJjKqa97ZgiQMKyg1Kyj51d52CxU3Nk+0Nevhc1ZsIpnrmEqmxNDpG1nWvfsAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dKuh9FhI; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dKuh9FhI"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48fe6629235so1840675e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041220; x=1779646020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UnEz4kb5yNtR6Ed+ZspZs0azXccaDtFZKA7zrYYeQpw=;
        b=dKuh9FhIzz4XizwKw+FsPfOH3Br6zOu+c8EYdmVrxGFV/JkVWv8GECL75gA1MbXoqk
         wiiuT02KBR4McjN9nw76hkYaXSfS0ZK+Q8QKWSSnN8ZJ8Y9LyDuBhfha7PoFOQErVXE9
         2GtyJI863PkYH08upvx0FTM2hkxh84s/Z5EwgsuN3O466uaM0pzjjlpPQxEV4RLWsVUa
         xpfqAFJC61EzYwoi3XXHgGnHW5164fUtQ1nAniTBlwEv3e0po/N7ulchDv8WYmErReMx
         j93YqN6MFMNXOCAm0JE1jZB2JTh5oJmnDFaYpfOhQGNfqYhcIA0My9ebGfoj/UjKKdz2
         cF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041220; x=1779646020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UnEz4kb5yNtR6Ed+ZspZs0azXccaDtFZKA7zrYYeQpw=;
        b=X36+atWoKM2QEgNzM9EQME87XHGsobWtEsN7Znku9jUBeP2Q6OXpxLxzrQJLeLwzqh
         CxofQEs1f3dAWFPkdSz2Q1LzIQb0/T12kfB9ntZpNqj/GAcIAN8O6nOh+JVm9xInG7Ge
         lUQVuLxsb3UJ9wRTBBMk5iwHbASyuhklQ3KknCSLDm9eR+SGsoghp1aPSPUp2Boo/DT1
         jtYjwGVtLglNykXlOUeFz+Z7ucKh6bKGW1CWxPMtU3RXkpzAUFdwxQRoElhjBEhg9xPK
         AgilDcapRUB55Bm2ngGv0swCCxbKiK5e+RfvT3bBYCc6hrepNtpa0iXR5KwiyOZILgBs
         FmYg==
X-Gm-Message-State: AOJu0YwPD+80hbEOxkD6mYZ3yaolCSIkHlu/CnpTtVQG2jMhTkF+2hcv
	AeH2u4AI93EIN8QTLRF28+wjAWRpuAaF4s1U4h8gunkuOtaY2DOBUCUB
X-Gm-Gg: Acq92OGyh9IeZxTJ2KeW9ZYkQoi4TzsZ+K1uFlKyUvklLyZ1kQbvcuy6KDg21sZGheI
	joh1bI8SeSg8w29rqvSj+2S2Dp0bBngqHjeJHEpYievQPT078vQOmRC+lh9MESaSVtVRP0s0Tl0
	vxqq3063TVhTjYPD9d3/nL/t+QaIjA7PVjXDxTCW//Zc6mzBPdWx4wN/RCESqM/iNKxqU3K0VW5
	SiRAHq44q3kMEBN9jN0ukX+z+nH9deb8feyThQdD9bFsFJ0WN3yzTUIySBT3FPF5gR5vAHKkfhP
	ZFxUrTSaEtUXy/AhRGpkNWecB1/91jDNqwbH64b+qT7Jq+bVkz2Y0HvpVFtZQzg4PCbCcSzr+pJ
	bxDdQqxgdg+EZh7n6ltTN2wci9DEdQhz8RvNpRbPbs49u16DOJEdQnmo/w4TnxYBvssjW8RlzG3
	STYzB6EY412IiMSXzFbKNrsxxNJOgcQAHYfamO5JJ2qQUp6LXyEpHSt46aQwroLwI=
X-Received: by 2002:a05:600c:a48:b0:489:e696:127d with SMTP id 5b1f17b1804b1-48fe63022e8mr80058775e9.5.1779041220235;
        Sun, 17 May 2026 11:07:00 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:59 -0700 (PDT)
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
Subject: [PATCH 12/12] crypto: atmel - add capability-based I2C client selection
Date: Sun, 17 May 2026 18:06:39 +0000
Message-Id: <20260517180639.9657-14-l.rubusch@gmail.com>
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

