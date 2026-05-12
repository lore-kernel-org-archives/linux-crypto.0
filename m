Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EA63A4531
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625853; cv=none; b=jl3sYz3TO6RSzL+CC6dFgMsuG9HpDbPD8+0UeBLhsVg7uAYwrsW7akb8y0KEtdu7AyvcDKrkoRpEGJ4bRZsollvPf/e5HU0U27y3npy8edF/9CCXf5z/kR4qFJm8KSPp3QF/Hd+Xx2l/Xlh2O6rGqTfwE57K1GZpIwwQd07QDmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625853; c=relaxed/simple;
	bh=kTzGIg2ZKv2CEMnZnYfRwD9wOU2ZtpB5enjuLO9/y2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qSh/5ZCf+aJwP7poCqNLnXH/WxV06AEcYyIwnobU/BizknIm1fiGaolqJAqarmTpLSm9PQ2/hNnZwsmeJ8ROvsa/E8Wb4kXgIJyTibhcszrwSnXtCdib/RXke21FE0aJtx7oG7y113zyeSU5CE+tJ+LvnPFNHoYFCcEEt22awL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nHXDTv52; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHXDTv52"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891b02a0acso6258265e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625850; x=1779230650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9RwkhAyGo0F1Zzezeg5ARZljvoevw6uxnTcs7DFl6kQ=;
        b=nHXDTv52Gp3cpbf9N3St05Q+wD1k2c0X8te/gFpRNd3HvI+PA1y15p/Jo4iUPOZKhL
         JaD7IFHAAUBpNFeYYGIyCEkPZicigHhXakUEAqQwY5NFMEeLyFIp31h8hDf/9+J9hvEC
         MMq/aRqLFSxACvqVxscbcsbMZOcwf13yaQYRjyQ0axcJtWBYK4digHMtnFt9To2PpV/F
         c67VpO8s2nLX7pht25hL/x2BqXOflBWMO8VzXnjwwwC6hAAAf84SXTa8Jc1ki3LifCBm
         bfwSwpBk8zy3ZT053I+G0WuHdbE3SsSJtcgCqVEbe5UVH7R4JztC8S3VyCtjmfmGQqog
         EtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625850; x=1779230650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9RwkhAyGo0F1Zzezeg5ARZljvoevw6uxnTcs7DFl6kQ=;
        b=BMhqEgMrsYPWzTmjiVK8b1Qaj5Hrt4YVRXhno5yU+awmINeEMwLzAWmU8JhtswxZvn
         GOhuphs9Ymy64Jfw+u+uNvD0Z00f/GwgHuyP3DptdUc1Cp30Kaz0nb5qUe4wSHq4n8HG
         1dpOKFS3x5etMzhARi6a5+fuC7dNqo+7XKblcxSSGnXNd3PIhyBXeKv0L6eh5Lex5Jlb
         Tv1M/eHjCH2qt6b7psy2DMpSopboz5n0wxUQbvJFoM+RKnudPdubequBkYv2riQkpDWq
         Bf6KETnuPy7KI96dUoweVkTiMB0LQOiS5GEhD4Ry4evC6Fqphq8/+TExFvBrIf0pC8dk
         0BmQ==
X-Gm-Message-State: AOJu0Yz5SnD32aRNJyE2pyc9+s0NZxZQQKsCP0byCMojCvrYAvA/OPVU
	GF6oLsDOYpEFiPC16vuvUMq0CPWRSHi2ybCZQJbB65mgPv/R5Z7Va/xH
X-Gm-Gg: Acq92OGRgFgeye/kwtGTlB/S1J+5MUe+SobGt53KQLnXf4iBc3ccfM+CBuLqrcfERpb
	7X7crJeh4EKUt2EYY4mJfZXiK6zzi2eADfcySDscpCquY2kbjvDcK9q54kpLr/piZg0o8BE8NhL
	NSQgsrK37suu1r237Q237GfyyYkazCxUJxrLBeqj3pDwNturWcaQnghVWJHn7V3pMovV6j2VPmX
	GH/YpoZvm1K2DwZtXKLYfPMpSkRpkBokenam/bWvtCRK4ExyXZl/Iq1kesfM5KLmHcOKA5GfTvQ
	2s93MwbO4gn7a9WJrYQ0ltUDHLBFS7CQFEzTIZ4Lr725gsZ5vfb/5BBVkdJ9EP8OQqTJ4LXgdJY
	HXC9L0VeFB7g7aa6EJKXnTKxIgdcVAZZQvOMnMYE1RMyEm8CFzTgeXK/Hu/lVUABD0iSMffY1f8
	YWNb/ixr4rwO/QnS1ZMnZnZ9CmELjCXnA0gu3QFUW7k5q8NnDFEjx9p0zfgW2gLtA=
X-Received: by 2002:a05:600c:19ce:b0:488:a797:f099 with SMTP id 5b1f17b1804b1-48fc9a34585mr5290375e9.3.1778625849440;
        Tue, 12 May 2026 15:44:09 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:09 -0700 (PDT)
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
Subject: [PATCH 02/12] crypto: atmel - move capability-based client allocation into i2c core
Date: Tue, 12 May 2026 22:43:39 +0000
Message-Id: <20260512224349.64621-3-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260512224349.64621-1-l.rubusch@gmail.com>
References: <20260512224349.64621-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the i2c client allocation logic from atmel-ecc into the shared
atmel-i2c core and extend it to support capability-based client
selection.

Introduce enum atmel_i2c_capability and add capability flags to
struct atmel_i2c_client_priv. Devices now advertise their supported
features during probe, allowing atmel_i2c_client_alloc() to select a
compatible client from the shared i2c client list.

The allocation logic continues to balance crypto transformation usage
across devices by selecting the client with the lowest tfm_count, but
is no longer limited to ECC-capable devices.

This centralizes shared client management in the common atmel-i2c core
and prepares the infrastructure for additional shared crypto features
across compatible Atmel devices.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     | 39 +++-------------------------------
 drivers/crypto/atmel-i2c.c     | 39 ++++++++++++++++++++++++++++++++++
 drivers/crypto/atmel-i2c.h     |  7 ++++++
 drivers/crypto/atmel-sha204a.c |  2 ++
 4 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index cba4238735cc..c63d30947bd7 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -200,41 +200,6 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 	return ret;
 }
 
-static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
-{
-	struct atmel_i2c_client_priv *i2c_priv, *min_i2c_priv = NULL;
-	struct i2c_client *client = ERR_PTR(-ENODEV);
-	int min_tfm_cnt = INT_MAX;
-	int tfm_cnt;
-
-	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-
-	if (list_empty(&atmel_i2c_mgmt.i2c_client_list)) {
-		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
-		return ERR_PTR(-ENODEV);
-	}
-
-	list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
-			    i2c_client_list_node) {
-		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
-		if (tfm_cnt < min_tfm_cnt) {
-			min_tfm_cnt = tfm_cnt;
-			min_i2c_priv = i2c_priv;
-		}
-		if (!min_tfm_cnt)
-			break;
-	}
-
-	if (min_i2c_priv) {
-		atomic_inc(&min_i2c_priv->tfm_count);
-		client = min_i2c_priv->client;
-	}
-
-	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
-
-	return client;
-}
-
 static void atmel_ecc_i2c_client_free(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
@@ -249,7 +214,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	ctx->curve_id = ECC_CURVE_NIST_P256;
-	ctx->client = atmel_ecc_i2c_client_alloc();
+	ctx->client = atmel_i2c_client_alloc(ATMEL_CAP_ECDH);
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
 		return PTR_ERR(ctx->client);
@@ -321,6 +286,8 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 
+	i2c_priv->caps = BIT(ATMEL_CAP_ECDH);
+
 	/* add to client list */
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 861af52d7a88..b7ee2ec37531 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -57,6 +57,45 @@ static void atmel_i2c_checksum(struct atmel_i2c_cmd *cmd)
 	*__crc16 = cpu_to_le16(bitrev16(crc16(0, data, len)));
 }
 
+struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap)
+{
+	struct atmel_i2c_client_priv *i2c_priv, *min_i2c_priv = NULL;
+	struct i2c_client *client = ERR_PTR(-ENODEV);
+	int min_tfm_cnt = INT_MAX;
+	int tfm_cnt;
+
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+
+	if (list_empty(&atmel_i2c_mgmt.i2c_client_list)) {
+		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+		return ERR_PTR(-ENODEV);
+	}
+
+	list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
+			    i2c_client_list_node) {
+		if (!(i2c_priv->caps & BIT(cap)))
+			continue;
+
+		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
+		if (tfm_cnt < min_tfm_cnt) {
+			min_tfm_cnt = tfm_cnt;
+			min_i2c_priv = i2c_priv;
+		}
+		if (!min_tfm_cnt)
+			break;
+	}
+
+	if (min_i2c_priv) {
+		atomic_inc(&min_i2c_priv->tfm_count);
+		client = min_i2c_priv->client;
+	}
+
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+
+	return client;
+}
+EXPORT_SYMBOL(atmel_i2c_client_alloc);
+
 void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd)
 {
 	cmd->word_addr = COMMAND;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 43a0c1cfcd94..70579b438256 100644
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
@@ -190,6 +196,7 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
+struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap);
 void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
 
 #endif /* __ATMEL_I2C_H__ */
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index e6808c2bc891..ab758c9cd410 100644
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

