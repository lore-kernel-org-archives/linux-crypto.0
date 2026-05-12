Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBE13A9637
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625863; cv=none; b=hU1DmFhvuCIyu7/n7BxVSq4Uj2398rck9cxmHBk2gYWV5E+l9N+ZWQ36y7jTYtlDrhJZMngh7J279X5zas/b1NzMttLysisVgbIeFGONqwMlOi1nw7TlDl5qEsXKan6KZY5jlwR5MeWpxABxOQuqAB8BPkcTONwmYB1Xpf8TXDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625863; c=relaxed/simple;
	bh=ceyEeOtngEw+ZbyYquQDBLoFGjfTeN3o0bWOHhDN1IY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nTqMWqFWtUdVVL+xxyuDeHRf2oXLvrrnDRgGc2DVmSQfsnQzdruM7oAZ7o4GqvcQc2twM4il3RUu0sLzX3G5JkjFl6m3JKnTLVwoD+vXetURdq1Rig+fOAdTCpPPqigwXq3KV1iLin7cb6/ELQNYfwlozR0X6I17U1SFwmJeex8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hUCcAmyT; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUCcAmyT"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4462f8d2488so334723f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625859; x=1779230659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UPGTYowpPc1Ox/XtvXiBTJJQvGISnFodKgzhMsesERc=;
        b=hUCcAmyTQ/q9aDshH3jLvt+7FuNe0lEW7rcHLq9GJ4n+baGJ6ZknkYPAdKAt9tHETV
         GDId5KToBJxfds+YZwb9cwT+87oVdqi2Qf+/0XcTeAp9/p+Pp43zcc9dEgWV/yEFuLPP
         Cv+5Sc2EkV21Z9SFsWa0y/oYJaurvhi1GefI2SWIhN+xe6jz3kJyJTxBUZDxtl73t84x
         BnjVLtwRLWVS+2es9ftCjig2QNwhdBbkGs9UIR8TP/3iK0+ZquhSNzUTYXtCqTuG3Mkm
         NOEbqzgETHsYXoS2HH5UsjPQKyIBeQnBWFJdSPPsfLM1ym7jsRCi6p9C87QY/6W9hAjZ
         5fJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625859; x=1779230659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UPGTYowpPc1Ox/XtvXiBTJJQvGISnFodKgzhMsesERc=;
        b=F3KM3t3I70z8/gEIMgC2iZUDivmTudEJ/kKxdtC1MrWow+TQOsze7VhJ4UO2Fb0OFj
         8lkyR7g6pLTJKtpIAeKTAqYZsJvsgnqpzXCPZVyc163gBmDpBIseCGJHpiyNz9aaWno2
         W3h+bYBctzp2YJcnYCWPpywbz8MyhsT4MKa+tV9AZ9oBCf7I/vE6p7SFtk8Ly+/Raltc
         C5o6LF6a0dSrMuGqdMwNkcaX29IgvD4a0n80sraMq1C3uRqBnJ5mBW8GXN4OBKFSkcUJ
         MsRQXAMWhsvYe5SrCGBybZ6vo7AP0bH67VtgwImC51RPC8k0iSZTNQ7kaQRpEJ9lTS2K
         hKVA==
X-Gm-Message-State: AOJu0YxMwZnxOeqCofqOtUNSkkIutFPx47v30alLj6JyBifEcYHhVgUG
	6K8c6vz4DqhTQ00WkjXoKaT9IWHHn2vmou0PUSKyQiYB0XGNiL8apZqc
X-Gm-Gg: Acq92OHAbjFiwcttCEZtO8DAUibL+VvWd+DpbjkPmS4NMrzWntYrFmTnoSloJZWQ36c
	bnJC6iZVd6ntmNw/uTEzoGTfbWZjO0B+wl+RgH3hlzVVozlMdhTKw6lD7HltBBvxGYH+nLlSzrU
	tQ3T0YkAJiXSxahbYPVR4JIy8xFd49izyIAVehktF4QvXjK57APBbRjP3lyoiHApq0g5qU+LDpD
	f/79KLuUDyKMgPMJxfwikLVKVUToMGO1r5yEmqbI3QjFPUeDV/CCNuv4xYBsywTqWmCgA8eXnhy
	nJ3fsAYM7PgQwz2fUFu7tRiNS25/rliAbsFepcp8nR62gzAH4YCkYTcx23wrXbNNEiBATWbJkqG
	C/fPA8vYYjWb1SxXKdQ+2H9QVgr9ApzXOJKq2IUUJ4hcUbk/0+Io9+s9oitzATN+ojuz3LDVs3/
	Bv+SbwAl8k3IsNKTfXnjA9n3MZJs84CqP1rBxdX1tlTM08l602gQ+xakm866nRpx4QAZR6mYxcg
	A==
X-Received: by 2002:a05:600c:c4b7:b0:48f:c8dd:f91 with SMTP id 5b1f17b1804b1-48fc9a493a1mr3694165e9.6.1778625859137;
        Tue, 12 May 2026 15:44:19 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:18 -0700 (PDT)
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
Subject: [PATCH 11/12] crypto: atmel - refactor and localize driver constants
Date: Tue, 12 May 2026 22:43:48 +0000
Message-Id: <20260512224349.64621-12-l.rubusch@gmail.com>
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

After refactoring the client drivers to use the shared atmel-i2c core,
many constants and definitions no longer need global visibility.

Move command definitions, timing constants, status codes and related
helpers from the public header into the local compile unit of the core
driver where possible.

As part of this cleanup, rename macros and constants to use consistent
ATMEL_I2C_* naming and align them with common kernel driver conventions.
Also replace remaining hardcoded values with named constants throughout
the driver.

This is a preparatory cleanup and does not change functionality.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c |   4 +-
 drivers/crypto/atmel-i2c.c | 115 +++++++++++++++++++++++++------------
 drivers/crypto/atmel-i2c.h |  76 +++++++++---------------
 3 files changed, 108 insertions(+), 87 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9ad6d42b6eef..ed8c0ce5562b 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -137,7 +137,7 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 
 	ctx->do_fallback = false;
 
-	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2, &data->timings);
+	atmel_i2c_init_genkey_cmd(cmd, ATMEL_I2C_ECDH_SLOT_DEFAULT, &data->timings);
 
 	ret = atmel_i2c_send_receive(ctx->client, cmd);
 	if (ret)
@@ -296,7 +296,7 @@ static struct kpp_alg atmel_ecdh_nist_p256 = {
 		.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 		.cra_name = "ecdh-nist-p256",
 		.cra_driver_name = "atmel-ecdh",
-		.cra_priority = ATMEL_ECC_PRIORITY,
+		.cra_priority = ATMEL_I2C_PRIORITY,
 		.cra_module = THIS_MODULE,
 		.cra_ctxsize = sizeof(struct atmel_ecdh_ctx),
 	},
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 0ec2d768a763..53aba2f4bedb 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -21,19 +21,62 @@
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
-#define ATMEL_I2C_COMMAND			0x03 /* packet function */
+#define ATMEL_I2C_COMMAND		0x03 /* packet function */
+#define ATMEL_I2C_SLEEP_TOKEN		0x01
 
 /* Definitions for the device lock state */
-#define ATMEL_I2C_DEVICE_LOCK_ADDR		0x15
-#define ATMEL_I2C_LOCK_VALUE_IDX		(ATMEL_I2C_RSP_DATA_IDX + 2)
-#define ATMEL_I2C_LOCK_CONFIG_IDX		(ATMEL_I2C_RSP_DATA_IDX + 3)
+#define ATMEL_I2C_DEVICE_LOCK_ADDR	0x15
+#define ATMEL_I2C_LOCK_VALUE_IDX	(ATMEL_I2C_RSP_DATA_IDX + 2)
+#define ATMEL_I2C_LOCK_CONFIG_IDX	(ATMEL_I2C_RSP_DATA_IDX + 3)
+
+/* Definitions for the READ Command */
+#define ATMEL_I2C_READ_COUNT		ATMEL_I2C_COUNT_OVERHEAD_SIZE
+#define ATMEL_I2C_READ_RSP_SIZE		(4 + ATMEL_I2C_RSP_OVERHEAD_SIZE)
+
+/* Definitions for the RANDOM Command */
+#define ATMEL_I2C_RANDOM_COUNT		ATMEL_I2C_COUNT_OVERHEAD_SIZE
+#define ATMEL_I2C_RNG_BLOCK_SIZE	32
+#define ATMEL_I2C_RANDOM_RSP_SIZE	(ATMEL_I2C_RNG_BLOCK_SIZE + \
+					ATMEL_I2C_RSP_OVERHEAD_SIZE)
+#define ATMEL_I2C_RANDOM_COUNT		ATMEL_I2C_COUNT_OVERHEAD_SIZE
+
+/* Definitions for the GenKey Command */
+#define ATMEL_I2C_GENKEY_COUNT		ATMEL_I2C_COUNT_OVERHEAD_SIZE
+#define ATMEL_I2C_GENKEY_MODE_PRIVATE	0x04
+
+/* Definitions for the ECDH Command */
+#define ATMEL_I2C_ECDH_COUNT		71
+#define ATMEL_I2C_ECDH_RSP_SIZE		(32 + ATMEL_I2C_RSP_OVERHEAD_SIZE)
+#define ATMEL_I2C_ECDH_PREFIX_MODE	0x00
 
 /* Command opcode */
-#define ATMEL_I2C_OPCODE_ECDH			0x43
-#define ATMEL_I2C_OPCODE_GENKEY			0x40
-#define ATMEL_I2C_OPCODE_READ			0x02
-#define ATMEL_I2C_OPCODE_RANDOM			0x1b
-#define ATMEL_I2C_OPCODE_WRITE			0x12
+#define ATMEL_I2C_OPCODE_ECDH		0x43
+#define ATMEL_I2C_OPCODE_GENKEY		0x40
+#define ATMEL_I2C_OPCODE_READ		0x02
+#define ATMEL_I2C_OPCODE_RANDOM		0x1b
+#define ATMEL_I2C_OPCODE_WRITE		0x12
+
+/*
+ * Wake High delay to data communication (microseconds). SDA should be stable
+ * high for this entire duration.
+ */
+#define ATMEL_I2C_TWHI_MIN		1500
+#define ATMEL_I2C_TWHI_MAX		1550
+
+/* Wake Low duration */
+#define ATMEL_I2C_TWLO_USEC		60
+
+/* Status/Error codes */
+enum atmel_i2c_error_codes {
+	ATMEL_STATUS_OK_NOERR = 0x00,            /* success */
+	ATMEL_STATUS_CHECKMAC_OR_VERIFY_MISCOMPARE = 0x01,
+	ATMEL_STATUS_PARSE_ERROR = 0x03,
+	ATMEL_STATUS_ECC_FAULT = 0x05,
+	ATMEL_STATUS_EXECUTION_FAULT = 0x0F,
+	ATMEL_STATUS_OK_WAKE_SUCCESSFULL = 0x11, /* success */
+	ATMEL_STATUS_WATCHDOG_EXPIRE = 0xEE,
+	ATMEL_STATUS_CRC_ERROR = 0xFF,
+};
 
 struct atmel_i2c_client_mgmt atmel_i2c_mgmt = {
 	.i2c_list_lock = __SPIN_LOCK_UNLOCKED(atmel_i2c_mgmt.i2c_list_lock),
@@ -45,12 +88,12 @@ static const struct {
 	u8 value;
 	const char *error_text;
 } error_list[] = {
-	{ 0x01, "CheckMac or Verify miscompare" },
-	{ 0x03, "Parse Error" },
-	{ 0x05, "ECC Fault" },
-	{ 0x0F, "Execution Error" },
-	{ 0xEE, "Watchdog about to expire" },
-	{ 0xFF, "CRC or other communication error" },
+	{ ATMEL_STATUS_CHECKMAC_OR_VERIFY_MISCOMPARE, "CheckMac or Verify miscompare" },
+	{ ATMEL_STATUS_PARSE_ERROR, "Parse Error" },
+	{ ATMEL_STATUS_ECC_FAULT, "ECC Fault" },
+	{ ATMEL_STATUS_EXECUTION_FAULT, "Execution Error" },
+	{ ATMEL_STATUS_WATCHDOG_EXPIRE, "Watchdog about to expire" },
+	{ ATMEL_STATUS_CRC_ERROR, "CRC or other communication error" },
 };
 
 /**
@@ -65,7 +108,7 @@ static const struct {
 static void atmel_i2c_checksum(struct atmel_i2c_cmd *cmd)
 {
 	u8 *data = &cmd->count;
-	size_t len = cmd->count - CRC_SIZE;
+	size_t len = cmd->count - ATMEL_I2C_CRC_SIZE;
 	__le16 *__crc16 = (__le16 *)(data + len);
 
 	*__crc16 = cpu_to_le16(bitrev16(crc16(0, data, len)));
@@ -141,12 +184,12 @@ void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd,
 	cmd->opcode = ATMEL_I2C_OPCODE_RANDOM;
 	cmd->param1 = 0;
 	cmd->param2 = 0;
-	cmd->count = RANDOM_COUNT;
+	cmd->count = ATMEL_I2C_RANDOM_COUNT;
 
 	atmel_i2c_checksum(cmd);
 
 	cmd->msecs = timings->max_exec_time_random;
-	cmd->rxsize = RANDOM_RSP_SIZE;
+	cmd->rxsize = ATMEL_I2C_RANDOM_RSP_SIZE;
 }
 EXPORT_SYMBOL(atmel_i2c_init_random_cmd);
 
@@ -154,16 +197,16 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid,
 			       const struct atmel_i2c_max_exec_timings *timings)
 {
 	cmd->word_addr = ATMEL_I2C_COMMAND;
-	cmd->count = GENKEY_COUNT;
+	cmd->count = ATMEL_I2C_GENKEY_COUNT;
 	cmd->opcode = ATMEL_I2C_OPCODE_GENKEY;
-	cmd->param1 = GENKEY_MODE_PRIVATE;
+	cmd->param1 = ATMEL_I2C_GENKEY_MODE_PRIVATE;
 	/* a random private key will be generated and stored in slot keyID */
 	cmd->param2 = cpu_to_le16(keyid);
 
 	atmel_i2c_checksum(cmd);
 
 	cmd->msecs = timings->max_exec_time_genkey;
-	cmd->rxsize = GENKEY_RSP_SIZE;
+	cmd->rxsize = ATMEL_I2C_GENKEY_RSP_SIZE;
 }
 EXPORT_SYMBOL(atmel_i2c_init_genkey_cmd);
 
@@ -174,11 +217,11 @@ int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 	size_t copied;
 
 	cmd->word_addr = ATMEL_I2C_COMMAND;
-	cmd->count = ECDH_COUNT;
+	cmd->count = ATMEL_I2C_ECDH_COUNT;
 	cmd->opcode = ATMEL_I2C_OPCODE_ECDH;
-	cmd->param1 = ECDH_PREFIX_MODE;
+	cmd->param1 = ATMEL_I2C_ECDH_PREFIX_MODE;
 	/* private key slot */
-	cmd->param2 = cpu_to_le16(DATA_SLOT_2);
+	cmd->param2 = cpu_to_le16(ATMEL_I2C_ECDH_SLOT_DEFAULT);
 
 	/*
 	 * The device only supports NIST P256 ECC keys. The public key size will
@@ -195,7 +238,7 @@ int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 	atmel_i2c_checksum(cmd);
 
 	cmd->msecs = timings->max_exec_time_ecdh;
-	cmd->rxsize = ECDH_RSP_SIZE;
+	cmd->rxsize = ATMEL_I2C_ECDH_RSP_SIZE;
 
 	return 0;
 }
@@ -231,7 +274,7 @@ static int atmel_i2c_rng_read_nonblocking(struct hwrng *rng, void *buf,
 
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
-		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+		max = min(ATMEL_I2C_RANDOM_RSP_SIZE - ATMEL_I2C_RSP_OVERHEAD_SIZE, max);
 		memcpy(buf, &work_data->cmd.data[ATMEL_I2C_RSP_DATA_IDX], max);
 		rng->priv = 0;
 	} else {
@@ -271,7 +314,7 @@ static int atmel_i2c_rng_read(struct hwrng *rng, void *buf, size_t max,
 	if (ret)
 		return ret;
 
-	max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+	max = min(ATMEL_I2C_RANDOM_RSP_SIZE - ATMEL_I2C_RSP_OVERHEAD_SIZE, max);
 	memcpy(buf, &cmd.data[ATMEL_I2C_RSP_DATA_IDX], max);
 
 	return max;
@@ -323,7 +366,7 @@ static int atmel_i2c_eeprom_read(struct i2c_client *client, u16 addr,
 		goto err;
 	}
 
-	memcpy(buf, cmd->data + ATMEL_I2C_RSP_DATA_IDX, 4);
+	memcpy(buf, cmd->data + ATMEL_I2C_RSP_DATA_IDX, ATMEL_I2C_STATUS_RSP_SIZE);
 
 err:
 	kfree(cmd);
@@ -381,10 +424,10 @@ static int atmel_i2c_status(struct device *dev, u8 *status)
 	int i;
 	u8 err_id = status[1];
 
-	if (*status != STATUS_SIZE)
+	if (*status != ATMEL_I2C_STATUS_RSP_SIZE)
 		return 0;
 
-	if (err_id == STATUS_WAKE_SUCCESSFUL || err_id == STATUS_NOERR)
+	if (err_id == ATMEL_STATUS_OK_WAKE_SUCCESSFULL || err_id == ATMEL_STATUS_OK_NOERR)
 		return 0;
 
 	for (i = 0; i < err_list_len; i++)
@@ -403,7 +446,7 @@ static int atmel_i2c_status(struct device *dev, u8 *status)
 static int atmel_i2c_wakeup(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
-	u8 status[STATUS_RSP_SIZE];
+	u8 status[ATMEL_I2C_STATUS_RSP_SIZE];
 	int ret;
 
 	/*
@@ -418,9 +461,9 @@ static int atmel_i2c_wakeup(struct i2c_client *client)
 	 * Wait to wake the device. Typical execution times for ecdh and genkey
 	 * are around tens of milliseconds. Delta is chosen to 50 microseconds.
 	 */
-	usleep_range(TWHI_MIN, TWHI_MAX);
+	usleep_range(ATMEL_I2C_TWHI_MIN, ATMEL_I2C_TWHI_MAX);
 
-	ret = i2c_master_recv(client, status, STATUS_SIZE);
+	ret = i2c_master_recv(client, status, ATMEL_I2C_STATUS_RSP_SIZE);
 	if (ret < 0)
 		return ret;
 
@@ -429,7 +472,7 @@ static int atmel_i2c_wakeup(struct i2c_client *client)
 
 static int atmel_i2c_sleep(struct i2c_client *client)
 {
-	u8 sleep = SLEEP_TOKEN;
+	u8 sleep = ATMEL_I2C_SLEEP_TOKEN;
 
 	return i2c_master_send(client, &sleep, 1);
 }
@@ -461,7 +504,7 @@ int atmel_i2c_send_receive(struct i2c_client *client, struct atmel_i2c_cmd *cmd)
 		goto err;
 
 	/* send the command */
-	ret = i2c_master_send(client, (u8 *)cmd, cmd->count + WORD_ADDR_SIZE);
+	ret = i2c_master_send(client, (u8 *)cmd, cmd->count + ATMEL_I2C_ADDR_SIZE);
 	if (ret < 0)
 		goto err;
 
@@ -521,7 +564,7 @@ EXPORT_SYMBOL(atmel_i2c_flush_queue);
 
 static inline size_t atmel_i2c_wake_token_sz(u32 bus_clk_rate)
 {
-	u32 no_of_bits = DIV_ROUND_UP(TWLO_USEC * bus_clk_rate, USEC_PER_SEC);
+	u32 no_of_bits = DIV_ROUND_UP(ATMEL_I2C_TWLO_USEC * bus_clk_rate, USEC_PER_SEC);
 
 	/* return the size of the wake_token in bytes */
 	return DIV_ROUND_UP(no_of_bits, 8);
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 2f76e107340e..20afe2da4f8d 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -10,28 +10,39 @@
 #include <linux/hw_random.h>
 #include <linux/types.h>
 
-#define ATMEL_ECC_PRIORITY		300
+#define ATMEL_I2C_PRIORITY		300
 
-#define SLEEP_TOKEN			0x01
-#define WAKE_TOKEN_MAX_SIZE		8
+#define ATMEL_I2C_WAKE_TOKEN_MAX_SIZE	8
 
 /* Definitions of Data and Command sizes */
-#define WORD_ADDR_SIZE			1
-#define COUNT_SIZE			1
-#define CRC_SIZE			2
-#define CMD_OVERHEAD_SIZE		(COUNT_SIZE + CRC_SIZE)
+#define ATMEL_I2C_ADDR_SIZE		1
+#define ATMEL_I2C_OPCODE_SIZE		1
+#define ATMEL_I2C_COUNT_SIZE		1
+#define ATMEL_I2C_PARAM1_SIZE		1
+#define ATMEL_I2C_PARAM2_SIZE		2
+#define ATMEL_I2C_CRC_SIZE		2
+
+#define ATMEL_I2C_RSP_OVERHEAD_SIZE	(ATMEL_I2C_COUNT_SIZE + \
+					ATMEL_I2C_CRC_SIZE)
+#define ATMEL_I2C_COUNT_OVERHEAD_SIZE	(ATMEL_I2C_OPCODE_SIZE + \
+					ATMEL_I2C_COUNT_SIZE + \
+					ATMEL_I2C_PARAM1_SIZE + \
+					ATMEL_I2C_PARAM2_SIZE + \
+					ATMEL_I2C_CRC_SIZE)
+
+/* Definitions for the status Command */
+#define ATMEL_I2C_STATUS_RSP_SIZE	4
 
 /* size in bytes of the n prime */
 #define ATMEL_ECC_NIST_P256_N_SIZE	32
 #define ATMEL_ECC_PUBKEY_SIZE		(2 * ATMEL_ECC_NIST_P256_N_SIZE)
+#define ATMEL_I2C_GENKEY_RSP_SIZE	(ATMEL_ECC_PUBKEY_SIZE + \
+					 ATMEL_I2C_RSP_OVERHEAD_SIZE)
+#define ATMEL_I2C_MAX_RSP_SIZE		ATMEL_I2C_GENKEY_RSP_SIZE
 
-#define STATUS_RSP_SIZE			4
-#define ECDH_RSP_SIZE			(32 + CMD_OVERHEAD_SIZE)
-#define GENKEY_RSP_SIZE			(ATMEL_ECC_PUBKEY_SIZE + \
-					 CMD_OVERHEAD_SIZE)
-#define ATMEL_I2C_READ_RSP_SIZE		(4 + CMD_OVERHEAD_SIZE)
-#define RANDOM_RSP_SIZE			(32 + CMD_OVERHEAD_SIZE)
-#define MAX_RSP_SIZE			GENKEY_RSP_SIZE
+/* Definitions for Indexes common to all commands */
+#define ATMEL_I2C_RSP_DATA_IDX		1 /* buffer index of data in response */
+#define ATMEL_I2C_ECDH_SLOT_DEFAULT	2
 
 /**
  * atmel_i2c_cmd - structure used for communicating with the device.
@@ -51,7 +62,7 @@ struct atmel_i2c_cmd {
 	u8 opcode;
 	u8 param1;
 	__le16 param2;
-	u8 data[MAX_RSP_SIZE];
+	u8 data[ATMEL_I2C_MAX_RSP_SIZE];
 	u8 msecs;
 	u16 rxsize;
 } __packed;
@@ -77,39 +88,6 @@ struct atmel_i2c_of_match_data {
 	size_t eeprom_zone_size[3]; /* all atmel devices have three zones */
 };
 
-/* Status/Error codes */
-#define STATUS_SIZE			0x04
-#define STATUS_NOERR			0x00
-#define STATUS_WAKE_SUCCESSFUL		0x11
-
-/* Definitions for Indexes common to all commands */
-#define ATMEL_I2C_RSP_DATA_IDX		1 /* buffer index of data in response */
-#define DATA_SLOT_2			2 /* used for ECDH private key */
-
-/*
- * Wake High delay to data communication (microseconds). SDA should be stable
- * high for this entire duration.
- */
-#define TWHI_MIN			1500
-#define TWHI_MAX			1550
-
-/* Wake Low duration */
-#define TWLO_USEC			60
-
-/* Definitions for the READ Command */
-#define ATMEL_I2C_READ_COUNT		7
-
-/* Definitions for the RANDOM Command */
-#define RANDOM_COUNT			7
-
-/* Definitions for the GenKey Command */
-#define GENKEY_COUNT			7
-#define GENKEY_MODE_PRIVATE		0x04
-
-/* Definitions for the ECDH Command */
-#define ECDH_COUNT			71
-#define ECDH_PREFIX_MODE		0x00
-
 /* Used for binding tfm objects to i2c clients. */
 enum atmel_i2c_capability {
 	ATMEL_CAP_ECDH = 0,
@@ -144,7 +122,7 @@ struct atmel_i2c_client_priv {
 	struct i2c_client *client;
 	struct list_head i2c_client_list_node;
 	struct mutex lock;
-	u8 wake_token[WAKE_TOKEN_MAX_SIZE];
+	u8 wake_token[ATMEL_I2C_WAKE_TOKEN_MAX_SIZE];
 	size_t wake_token_sz;
 	atomic_t tfm_count ____cacheline_aligned;
 	struct hwrng hwrng;
-- 
2.53.0

