Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634C9364053
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292650; cv=none; b=BBwptwhR2QhyEZmfDsF7D7yGbhml3KmAK2+CbEjTDkXLTdytdP17rItjv3+bR8d+lArSYSFwVbYov2Oj2GAqyo9bwYRm328TzSowubhb1BiLYQYJkzMq6hXoMAs5mVjQIMJXRBt0gKzmtne1geYxVyGBbzk8V+G+lBCdC41iYog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292650; c=relaxed/simple;
	bh=1ScPq7p1jf0H6LDU94x90s34pusxvX/k/zYe2nKVLmA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ut4FBJm8yyrHhqSoVNc4/qZsFoVpss7B7Fuj6P8UW2Jozpy3T31/bxN7zG0fV5BLC8eBXPfSD+mJpwrJWrWhMn+J3rkheKnR2henfUJQn9LTjtK4A5TAy1WN1ftb1T/WhtvVx0atGkgU2mz3yE5Xf4C6Ylq/evtouybOhCd/42g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z1vrsWKc; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z1vrsWKc"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4891c569cb1so4827895e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292644; x=1779897444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gNOINsowG7WTZn4Wfd0Y0oRU0rQmWn1GPDfPM6W1f5A=;
        b=Z1vrsWKcgXoIOxipEZFJk4rzojZVlQmgKYJgCkBBqvGt3gIsWUMSFHACHOdK0JEDbq
         z66jcOmAsSE/iLfI3HZxM8Ogoq88epfxNs9DwDOmJ/O2NzM+UYdFtiPmkuGHDtJbW2df
         +nUobsmLFYOS/QmZI497wexqXqBsRMmjjevOvBtwfbpsBOXbdrH8cHUqS6FRfNVw+Q+0
         CqcgL9tPAHVoQot5rSZrjjvqPdFQxoTPAfRg2ROfr3Lb62e4AGwE6tOc9R+L+FEUyu1Z
         5r63eqvCwedF5Up2i5zwIvuAsBIlnsHqfC9EvxzILNd7sss3wP+7Tbtd2/TWIFITJPKj
         MA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292644; x=1779897444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gNOINsowG7WTZn4Wfd0Y0oRU0rQmWn1GPDfPM6W1f5A=;
        b=D1R7ly526zv8R9qG2JO+codl9KsxBwZJgqHxNos2VKwE0PJaE2D1cas+wu2pd0UqXU
         s8itHUY8k37jCu7/jzKjlN2JC629HZwpcgl7NUlSvJVSKQdnBrIVxkT4J526AVStKn85
         8PClGBPuVySi7dNXPjeCqRQ33rgXoypuz6TsfNNJa/eiImeIPDPpzNx+E6ZeY3a9pbQg
         WzhHUSCuzX0QUHSf7LoGB92xdlo5EZSGeif//Y7hWBOg+BjCVzWn239S0ZbKslHcy9NJ
         36Gxf7K6XfVigR44JzacbFA0nkYMhO0lWUlOsZnxwjR1D/CtiCHru/uBqBs/pnaMRRHg
         47Lg==
X-Gm-Message-State: AOJu0Yz4vVd/mQKeQhRg/OF58xf2fiDhiUyCd6ILXTjYyl1TJ99LT4HW
	93dC44WnwwgkHg/ZzKa1GIeTawg8x2ZKps7C6W81ondV0tKrOgAWiBWi
X-Gm-Gg: Acq92OFgSBnn3N/+8bCR7wCGTPVD905olt/ctAEcQddxfeN9d2wd5NgnH7QI+9GqCqc
	9GWOCLZH91EPoN0/DZXGAr3ftDtgE5Q2j3ASmAnsLrB8+vLpCb8Zo4ZwK/otcs7NqOlfj4S5/Df
	2IQQ8JGbhy1sErF2jiULUqH4vPKfXFX2wb+lGNTlh/PxQPB7heDQqjM3edkwBDQEswHhMfBTc01
	QCn4Ghq0WgH2djSfP1HN5NKl0EnCBpDDtnJYq1TsjAGe4Rn1dNcIb/PQ7XpncvxHkQC69cN093i
	UXWpAGGCPrvTyRNnK7+/SxX2VNzFSE5CBtZUzroa/ikhIxCk88tFqRYz7wNl0Oj6y5yD2wbVwJ5
	hnz6uTyghJ73quca8kXDVNPUGPFJfkQapgPQbVFGV+ena2occZLlDdzqdQ8WEd4/6juZqTJnYl2
	3VZhhYo+rIcf0TN8bVWGIIEeQ0XZEHsMG9u8zOYHyET9Vnc00Q5++6I8zrRLbrtjavpRF3eSXrp
	g==
X-Received: by 2002:a05:600c:4587:b0:48f:d410:605e with SMTP id 5b1f17b1804b1-48fe632143fmr188644315e9.7.1779292643905;
        Wed, 20 May 2026 08:57:23 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:23 -0700 (PDT)
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
Subject: [PATCH v3 09/12] crypto: atmel-i2c - implement capability-based client selection
Date: Wed, 20 May 2026 15:57:00 +0000
Message-Id: <20260520155703.23018-10-l.rubusch@gmail.com>
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

Extend the shared I2C client allocation interface to support feature-aware
hardware selection by introducing capability filtering.

Add a 'caps' mask to 'struct atmel_i2c_client_priv' alongside an
'atmel_i2c_capability' enum. The allocator now explicitly filters hardware
nodes by a requested capability bit while retaining the least-loaded device
load-balancing scheme.

Update the ECC driver to advertise ATMEL_CAP_ECDH configuration capability
during probe, and adapt the tfm context setup execution path to request
this specific capability variant. Initialize the bitmask field to zero
inside the SHA204A driver context for now.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     | 4 +++-
 drivers/crypto/atmel-i2c.c     | 6 +++++-
 drivers/crypto/atmel-i2c.h     | 8 +++++++-
 drivers/crypto/atmel-sha204a.c | 2 ++
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 19e9ee9c15e5..ec8535b1d4f8 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -210,7 +210,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	ctx->curve_id = ECC_CURVE_NIST_P256;
-	ctx->client = atmel_i2c_client_alloc();
+	ctx->client = atmel_i2c_client_alloc(ATMEL_CAP_ECDH);
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
 		return PTR_ERR(ctx->client);
@@ -283,6 +283,8 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	i2c_priv = i2c_get_clientdata(client);
 	i2c_priv->ready = false;
 
+	i2c_priv->caps = BIT(ATMEL_CAP_ECDH);
+
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
 		      &atmel_i2c_mgmt.i2c_client_list);
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index e10713a7bcfe..7ef62b40c353 100644
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
@@ -75,6 +75,10 @@ struct i2c_client *atmel_i2c_client_alloc(void)
 			    i2c_client_list_node) {
 		if (!i2c_priv->ready)
 			continue;
+
+		if (!(i2c_priv->caps & BIT(cap)))
+			continue;
+
 		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
 		if (tfm_cnt < min_tfm_cnt) {
 			min_tfm_cnt = tfm_cnt;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 6c2d86fd9068..636d21bd1348 100644
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
@@ -131,6 +135,7 @@ extern struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
  * @tfm_count           : number of active crypto transformations on i2c client
  * @hwrng               : hold the hardware generated rng
  * @ready               : hw client is ready to use
+ * @caps                : feature capability of the particular driver
  *
  * Reads and writes from/to the i2c client are sequential. The first byte
  * transmitted to the device is treated as the byte size. Any attempt to send
@@ -148,6 +153,7 @@ struct atmel_i2c_client_priv {
 	atomic_t tfm_count ____cacheline_aligned;
 	struct hwrng hwrng;
 	bool ready;
+	u32 caps;
 };
 
 /**
@@ -192,7 +198,7 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
-struct i2c_client *atmel_i2c_client_alloc(void);
+struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap);
 void atmel_i2c_client_free(struct i2c_client *client);
 
 void atmel_i2c_deactivate_client(struct atmel_i2c_client_priv *i2c_priv);
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 6e6ac4770416..3853d2b95449 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -173,6 +173,8 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 
+	i2c_priv->caps = 0;
+
 	memset(&i2c_priv->hwrng, 0, sizeof(i2c_priv->hwrng));
 
 	i2c_priv->hwrng.name = dev_name(&client->dev);
-- 
2.39.5

