Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61273A5442
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625856; cv=none; b=p0wBhwAXNZlcE7blus04pAVb56Q3WKT+pFJxD6tyadHuBpZjCUEvrJX4yNYkMDkrxkAwM3QB/HwR2cg5D1AejxO5LprYvWotNHDhkAEwD0D/5zFuRf14FqBi8AkvAW1tzZ5MYu4aarHuQAhm45OJJT8VhxNylRtwkXVKsjhQbiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625856; c=relaxed/simple;
	bh=pLT1wgzVArxBbwkzGjXRSm1Fzalz9DXMwCB8xPgZFWY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sOInM1Viuigvwk8uHT9AWmenLNMUHS/GMs5KmdJYY9KYgjUx74oL2+lcpHq0kV4qKaEbk1Y0FHjZtTLFt1a4hTHqvBsN0X6JigsFMX5SJva9skQhsWzXHNzniVLlacZrDTqEd/UpkJg/qXj7KI9M8r9vg24KhKZcjptx4DEHyyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OJL+6ZUb; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OJL+6ZUb"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48910865133so5132105e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625852; x=1779230652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3oXj7PZ3++PLAjhiteExNTpYw5d8hkPXFmyLO00sz4=;
        b=OJL+6ZUbHCr8lK/4ftny2x4Fvm2AB91g0Rw90gRw93zu5PzfUvO8lKnopNQT4hY50o
         Ce/dt7zdLPYYxFofO54IoXI0lNvniQfOWgQwAPrEqoQ+QAmNTVCSw9UYPtPwdXbMMcC+
         E6DCHBbMzrENajotlZpWZochGG44iHypM5oufMxVk0HXx5PapkoK6axk4O8l6+xWQxPc
         IPX6/ugqluti3HNveWvYvmwJ774e6r+wXkd4FxbUIaD1BT3glLgtnw8e8ZFt6/tpyZX9
         vK/5BTWVaUhMe8D9Yy3uzYC4dA9TpUkGUcTaV3qhjF5J+uWTdkPWQFcyZR3NJUmwu+kF
         KB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625852; x=1779230652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b3oXj7PZ3++PLAjhiteExNTpYw5d8hkPXFmyLO00sz4=;
        b=auDzyuoUQH1KiRKiej3B/0e/l/h8s2Jrrji8kEu83SR8TYk9aywTvHYOU5k+ploLK3
         1zRC+NMwVQfFxC7lakLkkEuKMuTFV7gbjk4vAkItugeTusQBvORmoqfDmwdtebXHwfYH
         VMxTcf1uf2XGPsGMzXncbPWBa/qrDagRIF73Br6i2aXCVztm6W8/bJ9tyVT306+QVv6o
         q+oBm+PY+ApbnThJrAnzFLjvVOGjB5mMAM+uPUvixm1eLvICNQdKvS+Suls218SQqA6l
         /rQM0kwePtZoene/epEauc+PUImNQHVJvisbIXHB62nBQd9uTIuPUqL1VtjSMeszxE/0
         jrOw==
X-Gm-Message-State: AOJu0YxXwohwvvZgLqbuN8JvEv0Sp0jxyOY7NwYaaCNqcL/ddVqQjzQo
	HfMDxJ7uzk4ZDcmAshr9U8HTI29fi0rbvuBNKiCVLbjU8RcmsUIEjRat
X-Gm-Gg: Acq92OHtk0JhwQMauhFlez9eewWh7GhyJNV1ptCfGJLuwyqRE7umAHKEJCKo1ZL1ySJ
	LfJkWrmG6FiaHHrMKjZDi+c/qeNw/etK6oW9eZ6k3XEDjbZ8hkMXZLzEqNYGvg1Akk1KjkdipEl
	Q1ew1M7A7D/CRhdW3VDjXTz8ASaOkHe7HqvD/5i5lTbLxCw2a7EaP9wJNfSpHIM//ETlIk+STma
	M2X9zD9qWbTFuV4BIOxZ5V/r+ulEoC7WHzoOH0L9+Bvs6ZV/RFBkziUtuVEVKr1AhmbehsjjsXG
	FCPnGMPXZO5E4RdKkR3l5xF0OUawVnWJZMBbWMRCJOWHauA78DNrRMZ7ZVVSqBPpSWBl7vs46N1
	MU2NM713s5ybTEErLShoqOPsRwxkC6oE+I8xc80jALsH2EEZBEq4ccpxIcQxXh5pC+a94kVkgF+
	0yO65cd6gVD5srwSyMp2T0jy9IE90maysrSl7ECkGSIfZNcxATxrH+D+/7UsUN62M=
X-Received: by 2002:a05:600c:35c8:b0:48f:c8d4:487a with SMTP id 5b1f17b1804b1-48fc9a50b29mr4615355e9.8.1778625852236;
        Tue, 12 May 2026 15:44:12 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:11 -0700 (PDT)
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
Subject: [PATCH 04/12] crypto: atmel - add per-device timing and match-data driven configuration
Date: Tue, 12 May 2026 22:43:41 +0000
Message-Id: <20260512224349.64621-5-l.rubusch@gmail.com>
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

The ATSHA204(A) and ATECC device families define different maximum
command execution times in their datasheets. The current driver uses a
mixed set of timing constants, which can result in insufficient wait
times for some devices.

Introduce struct atmel_i2c_of_match_data to provide per-device timing
information through the device match tables. Store the match data in the
client private structure and pass the timing parameters to the command
initialization helpers instead of relying on global timing constants.

This allows the common atmel-i2c core to use device-specific command
timeouts for operations such as READ, RANDOM, GENKEY, and ECDH.

Also move the legacy hwrng quality information into the match data
structure to consolidate per-device configuration in a single place.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     | 32 +++++++++++++---
 drivers/crypto/atmel-i2c.c     | 29 ++++++++------
 drivers/crypto/atmel-i2c.h     | 36 ++++++++++++------
 drivers/crypto/atmel-sha204a.c | 69 ++++++++++++++++++++++++----------
 4 files changed, 120 insertions(+), 46 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 0dede3707b73..7793f7b4e97e 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -76,6 +76,8 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 				 unsigned int len)
 {
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(ctx->client);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
 	struct atmel_i2c_cmd *cmd;
 	void *public_key;
 	struct ecdh params;
@@ -112,7 +114,7 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 
 	ctx->do_fallback = false;
 
-	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2);
+	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2, &data->timings);
 
 	ret = atmel_i2c_send_receive(ctx->client, cmd);
 	if (ret)
@@ -164,6 +166,8 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(ctx->client);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
 	struct atmel_i2c_work_data *work_data;
 	gfp_t gfp;
 	int ret;
@@ -187,7 +191,7 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 	work_data->ctx = ctx;
 	work_data->client = ctx->client;
 
-	ret = atmel_i2c_init_ecdh_cmd(&work_data->cmd, req->src);
+	ret = atmel_i2c_init_ecdh_cmd(&work_data->cmd, req->src, &data->timings);
 	if (ret)
 		goto free_work_data;
 
@@ -278,14 +282,22 @@ static struct kpp_alg atmel_ecdh_nist_p256 = {
 static int atmel_ecc_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
+	const struct atmel_i2c_of_match_data *data;
 	int ret;
 
 	ret = atmel_i2c_probe(client);
 	if (ret)
 		goto done;
 
-	i2c_priv = i2c_get_clientdata(client);
+	data = device_get_match_data(&client->dev);
+	if (!data) {
+		dev_err(&client->dev, "no match data found via OF or ID table\n");
+		ret = -ENODEV;
+		goto done;
+	}
 
+	i2c_priv = i2c_get_clientdata(client);
+	i2c_priv->data = data;
 	i2c_priv->caps = BIT(ATMEL_CAP_ECDH);
 
 	/* add to client list */
@@ -339,9 +351,19 @@ static void atmel_ecc_remove(struct i2c_client *client)
 	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
 }
 
+static const struct atmel_i2c_of_match_data atecc508a_match_data = {
+	.timings = {
+		.max_exec_time_ecdh = 58,
+		.max_exec_time_genkey = 115,
+		.max_exec_time_random = 23,
+		.max_exec_time_read = 1,
+		.max_exec_time_write = 42,
+	},
+};
+
 static const struct of_device_id atmel_ecc_dt_ids[] = {
-	{ .compatible = "atmel,atecc508a", },
-	{ .compatible = "atmel,atecc608b", },
+	{ .compatible = "atmel,atecc508a", .data = &atecc508a_match_data, },
+	{ .compatible = "atmel,atecc608b", .data = &atecc508a_match_data, },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index b7ee2ec37531..7fa7cf9ab3c1 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -96,7 +96,8 @@ struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap)
 }
 EXPORT_SYMBOL(atmel_i2c_client_alloc);
 
-void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd)
+void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd,
+				    const struct atmel_i2c_max_exec_timings *timings)
 {
 	cmd->word_addr = COMMAND;
 	cmd->opcode = OPCODE_READ;
@@ -110,12 +111,13 @@ void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd)
 
 	atmel_i2c_checksum(cmd);
 
-	cmd->msecs = MAX_EXEC_TIME_READ;
+	cmd->msecs = timings->max_exec_time_read;
 	cmd->rxsize = READ_RSP_SIZE;
 }
 EXPORT_SYMBOL(atmel_i2c_init_read_config_cmd);
 
-int atmel_i2c_init_read_otp_cmd(struct atmel_i2c_cmd *cmd, u16 addr)
+int atmel_i2c_init_read_otp_cmd(struct atmel_i2c_cmd *cmd, u16 addr,
+				const struct atmel_i2c_max_exec_timings *timings)
 {
 	if (addr >= OTP_ZONE_SIZE / 4)
 		return -EINVAL;
@@ -132,14 +134,15 @@ int atmel_i2c_init_read_otp_cmd(struct atmel_i2c_cmd *cmd, u16 addr)
 
 	atmel_i2c_checksum(cmd);
 
-	cmd->msecs = MAX_EXEC_TIME_READ;
+	cmd->msecs = timings->max_exec_time_read;
 	cmd->rxsize = READ_RSP_SIZE;
 
 	return 0;
 }
 EXPORT_SYMBOL(atmel_i2c_init_read_otp_cmd);
 
-void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd)
+void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd,
+			       const struct atmel_i2c_max_exec_timings *timings)
 {
 	cmd->word_addr = COMMAND;
 	cmd->opcode = OPCODE_RANDOM;
@@ -149,12 +152,13 @@ void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd)
 
 	atmel_i2c_checksum(cmd);
 
-	cmd->msecs = MAX_EXEC_TIME_RANDOM;
+	cmd->msecs = timings->max_exec_time_random;
 	cmd->rxsize = RANDOM_RSP_SIZE;
 }
 EXPORT_SYMBOL(atmel_i2c_init_random_cmd);
 
-void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid)
+void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid,
+			       const struct atmel_i2c_max_exec_timings *timings)
 {
 	cmd->word_addr = COMMAND;
 	cmd->count = GENKEY_COUNT;
@@ -165,13 +169,14 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid)
 
 	atmel_i2c_checksum(cmd);
 
-	cmd->msecs = MAX_EXEC_TIME_GENKEY;
+	cmd->msecs = timings->max_exec_time_genkey;
 	cmd->rxsize = GENKEY_RSP_SIZE;
 }
 EXPORT_SYMBOL(atmel_i2c_init_genkey_cmd);
 
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
-			    struct scatterlist *pubkey)
+			    struct scatterlist *pubkey,
+			    const struct atmel_i2c_max_exec_timings *timings)
 {
 	size_t copied;
 
@@ -196,7 +201,7 @@ int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 
 	atmel_i2c_checksum(cmd);
 
-	cmd->msecs = MAX_EXEC_TIME_ECDH;
+	cmd->msecs = timings->max_exec_time_ecdh;
 	cmd->rxsize = ECDH_RSP_SIZE;
 
 	return 0;
@@ -363,6 +368,8 @@ static inline size_t atmel_i2c_wake_token_sz(u32 bus_clk_rate)
 
 static int device_sanity_check(struct i2c_client *client)
 {
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
 	struct atmel_i2c_cmd *cmd;
 	int ret;
 
@@ -370,7 +377,7 @@ static int device_sanity_check(struct i2c_client *client)
 	if (!cmd)
 		return -ENOMEM;
 
-	atmel_i2c_init_read_config_cmd(cmd);
+	atmel_i2c_init_read_config_cmd(cmd, &data->timings);
 
 	ret = atmel_i2c_send_receive(client, cmd);
 	if (ret)
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 70579b438256..5224a62c16c9 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -57,6 +57,19 @@ struct atmel_i2c_cmd {
 	u16 rxsize;
 } __packed;
 
+struct atmel_i2c_max_exec_timings {
+	unsigned int max_exec_time_genkey;
+	unsigned int max_exec_time_ecdh;
+	unsigned int max_exec_time_random;
+	unsigned int max_exec_time_read;
+	unsigned int max_exec_time_write;
+};
+
+struct atmel_i2c_of_match_data {
+	const unsigned short *legacy_hwrng;
+	struct atmel_i2c_max_exec_timings timings;
+};
+
 /* Status/Error codes */
 #define STATUS_SIZE			0x04
 #define STATUS_NOERR			0x00
@@ -88,12 +101,6 @@ struct atmel_i2c_cmd {
 /* Wake Low duration */
 #define TWLO_USEC			60
 
-/* Command execution time (milliseconds) */
-#define MAX_EXEC_TIME_ECDH		58
-#define MAX_EXEC_TIME_GENKEY		115
-#define MAX_EXEC_TIME_READ		1
-#define MAX_EXEC_TIME_RANDOM		50
-
 /* Command opcode */
 #define OPCODE_ECDH			0x43
 #define OPCODE_GENKEY			0x40
@@ -135,6 +142,7 @@ extern struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
  * @tfm_count           : number of active crypto transformations on i2c client
  * @hwrng               : hold the hardware generated rng
  * @caps                : feature capability of the particular driver
+ * @data                : preinitialized driver data
  *
  * Reads and writes from/to the i2c client are sequential. The first byte
  * transmitted to the device is treated as the byte size. Any attempt to send
@@ -152,6 +160,7 @@ struct atmel_i2c_client_priv {
 	atomic_t tfm_count ____cacheline_aligned;
 	struct hwrng hwrng;
 	u32 caps;
+	const struct atmel_i2c_of_match_data *data;
 };
 
 /**
@@ -189,12 +198,17 @@ void atmel_i2c_flush_queue(void);
 
 int atmel_i2c_send_receive(struct i2c_client *client, struct atmel_i2c_cmd *cmd);
 
-void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd);
-int atmel_i2c_init_read_otp_cmd(struct atmel_i2c_cmd *cmd, u16 addr);
-void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd);
-void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
+void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd,
+				    const struct atmel_i2c_max_exec_timings *timings);
+int atmel_i2c_init_read_otp_cmd(struct atmel_i2c_cmd *cmd, u16 addr,
+				const struct atmel_i2c_max_exec_timings *timings);
+void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd,
+			       const struct atmel_i2c_max_exec_timings *timings);
+void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid,
+			       const struct atmel_i2c_max_exec_timings *timings);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
-			    struct scatterlist *pubkey);
+			    struct scatterlist *pubkey,
+			    const struct atmel_i2c_max_exec_timings *timings);
 
 struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap);
 void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index ab758c9cd410..febf9891b167 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -40,14 +40,15 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 	atomic_dec(&i2c_priv->tfm_count);
 }
 
-static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
+static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *buf,
 					      size_t max)
 {
-	struct atmel_i2c_client_priv *i2c_priv;
+	struct atmel_i2c_client_priv *i2c_priv = container_of(rng,
+							      struct atmel_i2c_client_priv,
+							      hwrng);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
 	struct atmel_i2c_work_data *work_data;
 
-	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
-
 	/* keep maximum 1 asynchronous read in flight at any time */
 	if (!atomic_add_unless(&i2c_priv->tfm_count, 1, 1))
 		return 0;
@@ -55,7 +56,7 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
 		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
-		memcpy(data, &work_data->cmd.data[RSP_DATA_IDX], max);
+		memcpy(buf, &work_data->cmd.data[RSP_DATA_IDX], max);
 		rng->priv = 0;
 	} else {
 		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
@@ -69,42 +70,45 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 		max = 0;
 	}
 
-	atmel_i2c_init_random_cmd(&work_data->cmd);
+	atmel_i2c_init_random_cmd(&work_data->cmd, &data->timings);
 	atmel_i2c_enqueue(work_data, atmel_sha204a_rng_done, rng);
 
 	return max;
 }
 
-static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
+static int atmel_sha204a_rng_read(struct hwrng *rng, void *buf, size_t max,
 				  bool wait)
 {
-	struct atmel_i2c_client_priv *i2c_priv;
+	struct atmel_i2c_client_priv *i2c_priv = container_of(rng,
+							      struct atmel_i2c_client_priv,
+							      hwrng);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
 	struct atmel_i2c_cmd cmd;
 	int ret;
 
 	if (!wait)
-		return atmel_sha204a_rng_read_nonblocking(rng, data, max);
-
-	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
+		return atmel_sha204a_rng_read_nonblocking(rng, buf, max);
 
-	atmel_i2c_init_random_cmd(&cmd);
+	atmel_i2c_init_random_cmd(&cmd, &data->timings);
 
 	ret = atmel_i2c_send_receive(i2c_priv->client, &cmd);
 	if (ret)
 		return ret;
 
 	max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
-	memcpy(data, &cmd.data[RSP_DATA_IDX], max);
+	memcpy(buf, &cmd.data[RSP_DATA_IDX], max);
 
 	return max;
 }
 
 static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u8 *otp)
 {
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
 	struct atmel_i2c_cmd cmd;
 	int ret;
 
-	ret = atmel_i2c_init_read_otp_cmd(&cmd, addr);
+	ret = atmel_i2c_init_read_otp_cmd(&cmd, addr, &data->timings);
 	if (ret < 0) {
 		dev_err(&client->dev, "failed, invalid otp address %04X\n",
 			addr);
@@ -164,6 +168,7 @@ static const struct attribute_group atmel_sha204a_groups = {
 static int atmel_sha204a_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
+	const struct atmel_i2c_of_match_data *data;
 	const unsigned short *quality;
 	int ret;
 
@@ -171,8 +176,15 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 	if (ret)
 		goto done;
 
-	i2c_priv = i2c_get_clientdata(client);
+	data = device_get_match_data(&client->dev);
+	if (!data) {
+		dev_err(&client->dev, "no match data found via OF or ID table\n");
+		ret = -ENODEV;
+		goto done;
+	}
 
+	i2c_priv = i2c_get_clientdata(client);
+	i2c_priv->data = data;
 	i2c_priv->caps = 0;
 
 	/* add to client list */
@@ -187,7 +199,7 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 	i2c_priv->hwrng.name = dev_name(&client->dev);
 	i2c_priv->hwrng.read = atmel_sha204a_rng_read;
 
-	quality = i2c_get_match_data(client);
+	quality = i2c_priv->data->legacy_hwrng;
 	if (quality)
 		i2c_priv->hwrng.quality = *quality;
 
@@ -227,15 +239,34 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 	kfree((void *)i2c_priv->hwrng.priv);
 }
 
+static const struct atmel_i2c_of_match_data atsha204_match_data = {
+	.timings = {
+		.max_exec_time_genkey = 43,
+		.max_exec_time_random = 50,
+		.max_exec_time_read = 4,
+		.max_exec_time_write = 42,
+	},
+	.legacy_hwrng = &atsha204_quality,
+};
+
+static const struct atmel_i2c_of_match_data atsha204a_match_data = {
+	.timings = {
+		.max_exec_time_genkey = 43,
+		.max_exec_time_random = 50,
+		.max_exec_time_read = 4,
+		.max_exec_time_write = 42,
+	},
+};
+
 static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
-	{ .compatible = "atmel,atsha204", .data = &atsha204_quality },
-	{ .compatible = "atmel,atsha204a", },
+	{ .compatible = "atmel,atsha204", .data = &atsha204_match_data, },
+	{ .compatible = "atmel,atsha204a", .data = &atsha204a_match_data, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
 
 static const struct i2c_device_id atmel_sha204a_id[] = {
-	{ "atsha204", (kernel_ulong_t)&atsha204_quality },
+	{ "atsha204" },
 	{ "atsha204a" },
 	{ /* sentinel */ }
 };
-- 
2.53.0

