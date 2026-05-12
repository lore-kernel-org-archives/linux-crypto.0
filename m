Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1D03A4510
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625859; cv=none; b=tiFRBP6+GwfobJBH0l3oWB59aNyRALqmKwvnUsHNIQd7B0p7EMSU+TujNPD451MgROG2lVgemIWPiur49MRLy/kz3ZZMU0i2RvVFDsK1i6felvga6VWl0cLk3cpiX0M4pSjxDqPwX/yN/flFIVuzUvGJ7j2frgiIuBx4eDRM7ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625859; c=relaxed/simple;
	bh=t5T0Hhkj/aVb8XuVjne5yDC88G7QnzRDuV8meaJZ9n4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gReyUhdD61iuQyLT728K9RBgJwyK33s6nEexhqodoDsjgFVNvb8THStPiCd1TrG47xXkmipkYBAItUAoWDjkn+Vl3rDkDomdKKE+GF+cmtF2SA1824/EkSwz4dDe3p4qFxxnoC612IlsOHHEzPeSjSr/takZM+LchzEXa6wH0nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K+Phiic+; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+Phiic+"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891b02a0acso6258565e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625856; x=1779230656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wdncnFqQOgUiVSEOFhs+0L3Uf5+UCLHNWz3msC+HnSs=;
        b=K+Phiic+B6gYIUdlBZ58g8732fY/U1zEikvie7QUlf7p44vgjtwLh55ApK7AmG762d
         urhAB9JlrG7/RSvlwmUNuWyhzuafHL3kERQmAAp8Dnyf6zvLOKDagPcGUhjboUA61FFB
         ZTko86FcX3CeWgmyMTe59cw9zgjCfZkTGGqLwBPERqmeCW1biTOs6pU4eqQwg7WlsSC1
         lt4x6bkYnzbKWc4LpJQUrCpQlgrpFKTaV+JhDl2l+HCborO2rBpV/Y8/j6cA8Sgc0Dq9
         Rq+oINIupQPOyCCY8pT7qt6HVwlMAJL449fgVByBT5mx0xNqdj9kgSEsss9P+j3SRq3Z
         gqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625856; x=1779230656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wdncnFqQOgUiVSEOFhs+0L3Uf5+UCLHNWz3msC+HnSs=;
        b=JxE+Kijt/crwX8CY16nf/iG7+PUxGS/by1/R5DikWddlGuA+3RPBX543z/iyaGjixC
         7wAoxHcTxuXKiVcF39rQDb5njF2C8hb8TCBDgQw9So5xeoP8rIoYEy3+prR6GcWc/aWF
         dvKXA3Ju3H/O1NqnoFeWxFS9z+o/TxHSjMqS5NU6jzOjgoM9EGCk0c1Fw5wGP77Y3JR2
         giuwNSTCv5Ai7U13NtvMHGD54ihzd9qel26NJ+1xVbLmGikbgw89oDoN9uCQs383Caq4
         Z6rC7Z7DkrKiGMNrJKspDSa1+P/wtt9r+egnx+S8EG1dk8sMUFNcNlVvz4sLLIpx67Ia
         q4TA==
X-Gm-Message-State: AOJu0YwhnNWa+LJV0GK8tVRPzSL1kmQX/FdyqXzMQm1ZauzGpfYfoxYP
	oosrm2oKzTRmeFWlbjmYlVVlpRzZsVk0GVm5Xv66oPHfUNE9brwGewsK
X-Gm-Gg: Acq92OF4acLYaYP0rkyg9lOP5GdyOaBzwAGP1VCIOG7MKUEy80j+IGFBMlCOj4zbUUY
	ahClPnMtPcIfZ97ervjw3zvM1z9PjSwXPdxgEIop8Ha4XhOdVyKa3xYIuWbNrtNB8BNfHdU8RQd
	4uDojAM7YkqDxfqDqB4J1bpi9zxugg4fXAFtDLcKjJzGn7VvUbOaDiCXhqTkshWbIUO+erxOYfa
	vqsvkegN/REVMSLAVRr/k0bwFjWeUlZIGWPfAHbNMMvQ/oKDDHkiCrR/gvaASZx99UgQaKZOcL5
	C8dp6XirBSLX/abNBrIunqg6ppJrTdGQjn/NTUxMtH2S9Gbl+VXn4ziF7XqcQUj2efEUwXdsOH0
	juSuofev3wpDOgQLhTJaEaZ7OB3g6WbR09aYl5RNviCbF4/HKVk8WnTEAEWbECkuIC5P96HrGUL
	THIZ6kKoQrjwz5Os2kgLyiQg8uiej+1ZcWnp+WBKGwxEEOr5EnKeoyBSzMG8EHpIQ=
X-Received: by 2002:a05:600c:4447:b0:489:1dc6:d6e with SMTP id 5b1f17b1804b1-48fc9a04fa7mr4375945e9.1.1778625856210;
        Tue, 12 May 2026 15:44:16 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:15 -0700 (PDT)
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
Subject: [PATCH 08/12] crypto: atmel - move device sanity check to core driver
Date: Tue, 12 May 2026 22:43:45 +0000
Message-Id: <20260512224349.64621-9-l.rubusch@gmail.com>
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

Move the device sanity check implementation into the shared Atmel
I2C core driver and reuse the generic EEPROM access helpers for
reading the CONFIG zone lock state.

This removes duplicate CONFIG zone handling and consolidates common
response index and lock state definitions under the Atmel I2C core
namespace.

Update both SHA204A and ECC drivers to invoke the shared sanity
check helper during probe.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     | 10 ++++++--
 drivers/crypto/atmel-i2c.c     | 43 ++++++++++++----------------------
 drivers/crypto/atmel-i2c.h     | 14 +++--------
 drivers/crypto/atmel-sha204a.c |  6 +++++
 4 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index f08fdf284b60..f6d1a9694d63 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -81,7 +81,7 @@ static void atmel_ecdh_done(struct atmel_i2c_work_data *work_data, void *areq,
 
 	/* copy the shared secret */
 	copied = sg_copy_from_buffer(req->dst, sg_nents_for_len(req->dst, n_sz),
-				     &cmd->data[RSP_DATA_IDX], n_sz);
+				     &cmd->data[ATMEL_I2C_RSP_DATA_IDX], n_sz);
 	if (copied != n_sz)
 		status = -EINVAL;
 
@@ -144,7 +144,7 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 		goto free_public_key;
 
 	/* save the public key */
-	memcpy(public_key, &cmd->data[RSP_DATA_IDX], ATMEL_ECC_PUBKEY_SIZE);
+	memcpy(public_key, &cmd->data[ATMEL_I2C_RSP_DATA_IDX], ATMEL_ECC_PUBKEY_SIZE);
 	ctx->public_key = public_key;
 
 	kfree(cmd);
@@ -323,6 +323,12 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	i2c_priv->data = data;
 	i2c_priv->caps = BIT(ATMEL_CAP_ECDH);
 
+	ret = atmel_i2c_device_sanity_check(client);
+	if (ret) {
+		dev_err(&client->dev, "failed to read EEPROM, is hardware attached?\n");
+		goto done;
+	}
+
 	/* add to client list */
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 26863573a10f..50b6bce478d2 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -23,6 +23,11 @@
 
 #define ATMEL_I2C_COMMAND			0x03 /* packet function */
 
+/* Definitions for the device lock state */
+#define ATMEL_I2C_DEVICE_LOCK_ADDR		0x15
+#define ATMEL_I2C_LOCK_VALUE_IDX		(ATMEL_I2C_RSP_DATA_IDX + 2)
+#define ATMEL_I2C_LOCK_CONFIG_IDX		(ATMEL_I2C_RSP_DATA_IDX + 3)
+
 /* Command opcode */
 #define ATMEL_I2C_OPCODE_ECDH			0x43
 #define ATMEL_I2C_OPCODE_GENKEY			0x40
@@ -129,26 +134,6 @@ static int atmel_i2c_init_read_eeprom_cmd(struct atmel_i2c_cmd *cmd, u16 addr,
 	return 0;
 }
 
-void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd,
-				    const struct atmel_i2c_max_exec_timings *timings)
-{
-	cmd->word_addr = ATMEL_I2C_COMMAND;
-	cmd->opcode = ATMEL_I2C_OPCODE_READ;
-	/*
-	 * Read the word from Configuration zone that contains the lock bytes
-	 * (UserExtra, Selector, LockValue, LockConfig).
-	 */
-	cmd->param1 = CONFIGURATION_ZONE;
-	cmd->param2 = cpu_to_le16(DEVICE_LOCK_ADDR);
-	cmd->count = ATMEL_I2C_READ_COUNT;
-
-	atmel_i2c_checksum(cmd);
-
-	cmd->msecs = timings->max_exec_time_read;
-	cmd->rxsize = ATMEL_I2C_READ_RSP_SIZE;
-}
-EXPORT_SYMBOL(atmel_i2c_init_read_config_cmd);
-
 void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd,
 			       const struct atmel_i2c_max_exec_timings *timings)
 {
@@ -247,7 +232,7 @@ static int atmel_i2c_rng_read_nonblocking(struct hwrng *rng, void *buf,
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
 		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
-		memcpy(buf, &work_data->cmd.data[RSP_DATA_IDX], max);
+		memcpy(buf, &work_data->cmd.data[ATMEL_I2C_RSP_DATA_IDX], max);
 		rng->priv = 0;
 	} else {
 		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
@@ -287,7 +272,7 @@ static int atmel_i2c_rng_read(struct hwrng *rng, void *buf, size_t max,
 		return ret;
 
 	max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
-	memcpy(buf, &cmd.data[RSP_DATA_IDX], max);
+	memcpy(buf, &cmd.data[ATMEL_I2C_RSP_DATA_IDX], max);
 
 	return max;
 }
@@ -338,7 +323,7 @@ static int atmel_i2c_eeprom_read(struct i2c_client *client, u16 addr,
 		goto err;
 	}
 
-	memcpy(buf, cmd->data + RSP_DATA_IDX, 4);
+	memcpy(buf, cmd->data + ATMEL_I2C_RSP_DATA_IDX, 4);
 
 err:
 	kfree(cmd);
@@ -542,7 +527,7 @@ static inline size_t atmel_i2c_wake_token_sz(u32 bus_clk_rate)
 	return DIV_ROUND_UP(no_of_bits, 8);
 }
 
-static int device_sanity_check(struct i2c_client *client)
+int atmel_i2c_device_sanity_check(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
@@ -553,7 +538,8 @@ static int device_sanity_check(struct i2c_client *client)
 	if (!cmd)
 		return -ENOMEM;
 
-	atmel_i2c_init_read_config_cmd(cmd, &data->timings);
+	atmel_i2c_init_read_eeprom_cmd(cmd, ATMEL_I2C_DEVICE_LOCK_ADDR,
+				       ATMEL_EEPROM_CONFIG_ZONE, data);
 
 	ret = atmel_i2c_send_receive(client, cmd);
 	if (ret)
@@ -565,8 +551,8 @@ static int device_sanity_check(struct i2c_client *client)
 	 * Failure to lock these zones may permit modification of any secret
 	 * keys and may lead to other security problems.
 	 */
-	if (cmd->data[LOCK_CONFIG_IDX] || cmd->data[LOCK_VALUE_IDX]) {
-		dev_err(&client->dev, "Configuration or Data and OTP zones are unlocked!\n");
+	if (cmd->data[ATMEL_I2C_LOCK_CONFIG_IDX] || cmd->data[ATMEL_I2C_LOCK_VALUE_IDX]) {
+		dev_err(&client->dev, "Config, Data and OTP zones are unlocked!\n");
 		ret = -ENOTSUPP;
 	}
 
@@ -575,6 +561,7 @@ static int device_sanity_check(struct i2c_client *client)
 	kfree(cmd);
 	return ret;
 }
+EXPORT_SYMBOL(atmel_i2c_device_sanity_check);
 
 void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv)
 {
@@ -633,7 +620,7 @@ int atmel_i2c_probe(struct i2c_client *client)
 
 	i2c_set_clientdata(client, i2c_priv);
 
-	return device_sanity_check(client);
+	return 0;
 }
 EXPORT_SYMBOL(atmel_i2c_probe);
 
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index e30e0c417de2..2f76e107340e 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -82,18 +82,10 @@ struct atmel_i2c_of_match_data {
 #define STATUS_NOERR			0x00
 #define STATUS_WAKE_SUCCESSFUL		0x11
 
-/* Definitions for eeprom organization */
-#define CONFIGURATION_ZONE		0
-
 /* Definitions for Indexes common to all commands */
-#define RSP_DATA_IDX			1 /* buffer index of data in response */
+#define ATMEL_I2C_RSP_DATA_IDX		1 /* buffer index of data in response */
 #define DATA_SLOT_2			2 /* used for ECDH private key */
 
-/* Definitions for the device lock state */
-#define DEVICE_LOCK_ADDR		0x15
-#define LOCK_VALUE_IDX			(RSP_DATA_IDX + 2)
-#define LOCK_CONFIG_IDX			(RSP_DATA_IDX + 3)
-
 /*
  * Wake High delay to data communication (microseconds). SDA should be stable
  * high for this entire duration.
@@ -195,8 +187,6 @@ void atmel_i2c_flush_queue(void);
 
 int atmel_i2c_send_receive(struct i2c_client *client, struct atmel_i2c_cmd *cmd);
 
-void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd,
-				    const struct atmel_i2c_max_exec_timings *timings);
 void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd,
 			       const struct atmel_i2c_max_exec_timings *timings);
 void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid,
@@ -207,6 +197,8 @@ int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 int atmel_i2c_register_rng(struct atmel_i2c_client_priv *i2c_priv,
 			   struct device *dev);
 
+int atmel_i2c_device_sanity_check(struct i2c_client *client);
+
 ssize_t atmel_i2c_eeprom_display(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf,
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 341554b7b7a2..88726f6ef87c 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -64,6 +64,12 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 	i2c_priv->data = data;
 	i2c_priv->caps = 0;
 
+	ret = atmel_i2c_device_sanity_check(client);
+	if (ret) {
+		dev_err(&client->dev, "failed to read EEPROM, is hardware attached?\n");
+		goto done;
+	}
+
 	/* add to client list */
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
-- 
2.53.0

