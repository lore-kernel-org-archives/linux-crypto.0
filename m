Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCB53A6EF9
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625858; cv=none; b=VjP55VkRm82BQFwrn7iibs683A/QIex1oJ3CG3W9dLoGq2c/q4XhPOcqLLz0h4Xv1WngaifYiBh+qytJnl1fuWaCQLflEVlcuRdU+MY4+SibKIs44jtnRfZYzzyZvSBaunKGWhlIezvmNsKhk0RpWoON31Ka3aEuEfPxQHoyagQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625858; c=relaxed/simple;
	bh=B+3rCBiSJ9oF1h8AdWvcbGMayUZTFgBtT78aQ/951Ng=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hUtjlObNn7R+g5n6O5X1xldN9cCXa4NspyEudPJ140hb4L59GxSFbV+JnFSP/uQusrX7uE3Vusp5Ba3B68E3RGGrV1AHGP37GYrfohKHSd8dR18rgOezWMbx0eCaxHSYGRxDSuTe+AbsWDYpyyDwhLNuoGcbHRteLO702SC/5UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z6tkeNCV; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z6tkeNCV"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-452aacde862so451301f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625854; x=1779230654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Agx9kWGeXoYnLuy6T8nmbJ6vrFvM27r6/mvFennmg1w=;
        b=Z6tkeNCVQjRA7GCDBeIIVMcapPUmZGdVtDFwqbv9ncqq8E+2jChmXOxt9GoQJk+5wV
         hwKCP6wLQnLONDdqiUzD86xfk+30xdVJ1/KWYLd1VbdzDVa7Q5vZDTqlBNW4HGNVj/Zd
         aBiG2YcesqDeeN7deooBWqFgVQTnXABxOuxulF2KbvcOnkDbKsFIJtumdo68JujZLA4Z
         FOwKFfDLUbZPBIJWTZatWFWZAsoyvaMcD6zZY5wWmBmlCFYDRI6F3R5jPy/wStMoaOFv
         YAYRqX0bem/dqutcfW8F84wbe15B+3pxC400iqYwY5v82Mv+bfNFkxm6bQ81xczJHgAn
         FmGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625854; x=1779230654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Agx9kWGeXoYnLuy6T8nmbJ6vrFvM27r6/mvFennmg1w=;
        b=X5IsOuD1TPjiBDydTGQAb4fhHaYVfpwAjkMx3qVai+lZZNk9peTv3zt0vYym2D4c/I
         INSkW8sTQQjAdoLhSwWL/s4JEI4bZKRTNPUG5X5TKli1B7usUmgO/nwishcjK1V5Pw67
         M6AR2ipSSHjC9DiSWpZrgcpcZU9ALZsyfYg3CN95cJmUqNM2sDwbpN1H7MrMdhqCjN2g
         NDnA/ph1kEXi6exDldezzezo2iCagPEKc6od/1VuxBU0JPRLD42BpuJsAKTDtczsh2tM
         MeY6YiHF5Dq/Mmw8TrY0LfCz9LD3ahkBO5elFI6kofajF4LChy+WLmynGXjCBu6F1gXi
         tX/Q==
X-Gm-Message-State: AOJu0YwqNnp44gSgMRlhyypRGjOLzgUQMjjdQ2d6ef3i4SYhyyfKDYxc
	a6FJx5PBmIrfF3JweAfYNnBTH60dvpCzM0w6kLO8vzVAYQ2E/WiqVuAl
X-Gm-Gg: Acq92OHTgylKKE4z00/pjjuPt7fp5Ph34Rr5jGNzLjT5sridGmb4OnwLacDp4l5Ul23
	kssYr1wn3o8oY5to0sc6D07FyyoQ3fQWxuDZ45w6A65FifTCOt6c7FzMdVo+p/1k5l1kjua9IMw
	z50QtYFwsuKHLStoJH/1eKgmiVoAPQhGBJjeeIjUOgTMEDFybqDMyiNJHc+tzce66J/dT6Bb/0Q
	jb/uRtG9oFirpPSWDM2IxTNjeQgYwHlS02VaQEGCdfmNNv+X5NaBXdKYGKocXcBmAePQTE7AxAG
	Lghl3LNxB7UVNa1nbqgJS8+/R5ET/13iLzKOUCTrsgHz8coX+HV4n6mSh9B4VeFZZZnTs+y05Tb
	q5S5USEKnUF7MR73000UCPFTTvLGw9vXdYrTgnTZzPWccLchviaWimGxAqEQ9T4DhHSi31+h0Fv
	eYVO4o6x3eE96rvV35BD3aKFf8CrNrwOvc4Vt4lnNlmtLTuqkI3QZ+Bkze6mMRRRk=
X-Received: by 2002:a05:600c:1385:b0:48e:6db5:76e6 with SMTP id 5b1f17b1804b1-48fc99ede8emr4846485e9.2.1778625854276;
        Tue, 12 May 2026 15:44:14 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:13 -0700 (PDT)
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
Subject: [PATCH 06/12] crypto: atmel - move EEPROM access support into common i2c core
Date: Tue, 12 May 2026 22:43:43 +0000
Message-Id: <20260512224349.64621-7-l.rubusch@gmail.com>
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

Move EEPROM read support from atmel-sha204a and atmel-ecc into the
shared atmel-i2c core and provide a generic interface for accessing
EEPROM zones on compatible Atmel devices.

Introduce enum atmel_i2c_eeprom_zones together with per-device EEPROM
zone sizing in struct atmel_i2c_of_match_data. Add common helpers for
EEPROM readout and sysfs formatting, and convert existing OTP sysfs
handling to use the shared infrastructure.

This removes duplicated EEPROM access logic from individual drivers and
extends support to ECC devices. The common implementation supports
CONFIG, OTP, and DATA zones using device-specific layout information
supplied via match data tables.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     |  36 ++++++++
 drivers/crypto/atmel-i2c.c     | 153 +++++++++++++++++++++++++--------
 drivers/crypto/atmel-i2c.h     |  30 +++----
 drivers/crypto/atmel-sha204a.c |  65 ++++----------
 4 files changed, 186 insertions(+), 98 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 67fa5975fa7f..b5f2d44ec74c 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -23,6 +23,22 @@
 #include <crypto/kpp.h>
 #include "atmel-i2c.h"
 
+static ssize_t otp_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return atmel_i2c_eeprom_display(dev, attr, buf, ATMEL_EEPROM_OTP_ZONE);
+}
+static DEVICE_ATTR_RO(otp);
+
+static struct attribute *atmel_ecc508a_attrs[] = {
+	&dev_attr_otp.attr,
+	NULL
+};
+
+static const struct attribute_group atmel_ecc508a_groups = {
+	.name = "atecc508a",
+	.attrs = atmel_ecc508a_attrs,
+};
+
 /**
  * struct atmel_ecdh_ctx - transformation context
  * @client     : pointer to i2c client device
@@ -306,6 +322,18 @@ static int atmel_ecc_probe(struct i2c_client *client)
 		      &atmel_i2c_mgmt.i2c_client_list);
 	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
+	/* EEPROM read out */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		ret = -ENODEV;
+		goto err_list_del;
+	}
+
+	ret = sysfs_create_group(&client->dev.kobj, &atmel_ecc508a_groups);
+	if (ret) {
+		dev_err(&client->dev, "failed to register sysfs entry\n");
+		goto err_list_del;
+	}
+
 	/* register rng */
 	ret = atmel_i2c_register_rng(i2c_priv, &client->dev);
 	if (ret) {
@@ -326,6 +354,7 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	goto done;
 
 err_list_del:
+	sysfs_remove_group(&client->dev.kobj, &atmel_ecc508a_groups);
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_del(&i2c_priv->i2c_client_list_node);
 	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
@@ -361,6 +390,8 @@ static void atmel_ecc_remove(struct i2c_client *client)
 		kfree((void *)i2c_priv->hwrng.priv);
 		i2c_priv->hwrng.priv = 0;
 	}
+
+	sysfs_remove_group(&client->dev.kobj, &atmel_ecc508a_groups);
 }
 
 static const struct atmel_i2c_of_match_data atecc508a_match_data = {
@@ -371,6 +402,11 @@ static const struct atmel_i2c_of_match_data atecc508a_match_data = {
 		.max_exec_time_read = 1,
 		.max_exec_time_write = 42,
 	},
+	.eeprom_zone_size = {
+		[ATMEL_EEPROM_CONFIG_ZONE] = 128,
+		[ATMEL_EEPROM_OTP_ZONE] = 64,
+		[ATMEL_EEPROM_DATA_ZONE] = 1208
+	},
 };
 
 static const struct of_device_id atmel_ecc_dt_ids[] = {
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index d451017171d8..26863573a10f 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -21,6 +21,15 @@
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
+#define ATMEL_I2C_COMMAND			0x03 /* packet function */
+
+/* Command opcode */
+#define ATMEL_I2C_OPCODE_ECDH			0x43
+#define ATMEL_I2C_OPCODE_GENKEY			0x40
+#define ATMEL_I2C_OPCODE_READ			0x02
+#define ATMEL_I2C_OPCODE_RANDOM			0x1b
+#define ATMEL_I2C_OPCODE_WRITE			0x12
+
 struct atmel_i2c_client_mgmt atmel_i2c_mgmt = {
 	.i2c_list_lock = __SPIN_LOCK_UNLOCKED(atmel_i2c_mgmt.i2c_list_lock),
 	.i2c_client_list = LIST_HEAD_INIT(atmel_i2c_mgmt.i2c_client_list),
@@ -96,56 +105,55 @@ struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap)
 }
 EXPORT_SYMBOL(atmel_i2c_client_alloc);
 
-void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd,
-				    const struct atmel_i2c_max_exec_timings *timings)
+static int atmel_i2c_init_read_eeprom_cmd(struct atmel_i2c_cmd *cmd, u16 addr,
+					  enum atmel_i2c_eeprom_zones zone,
+					  const struct atmel_i2c_of_match_data *data)
 {
-	cmd->word_addr = COMMAND;
-	cmd->opcode = OPCODE_READ;
-	/*
-	 * Read the word from Configuration zone that contains the lock bytes
-	 * (UserExtra, Selector, LockValue, LockConfig).
-	 */
-	cmd->param1 = CONFIGURATION_ZONE;
-	cmd->param2 = cpu_to_le16(DEVICE_LOCK_ADDR);
-	cmd->count = READ_COUNT;
+	const struct atmel_i2c_max_exec_timings *timings = &data->timings;
+	size_t zone_size = data->eeprom_zone_size[zone];
+
+	if (addr > zone_size)
+		return -EINVAL;
+
+	cmd->word_addr = ATMEL_I2C_COMMAND;
+	cmd->opcode = ATMEL_I2C_OPCODE_READ;
+	cmd->param1 = zone;
+	cmd->param2 = cpu_to_le16(addr);
+	cmd->count = ATMEL_I2C_READ_COUNT;
 
 	atmel_i2c_checksum(cmd);
 
 	cmd->msecs = timings->max_exec_time_read;
-	cmd->rxsize = READ_RSP_SIZE;
+	cmd->rxsize = ATMEL_I2C_READ_RSP_SIZE;
+
+	return 0;
 }
-EXPORT_SYMBOL(atmel_i2c_init_read_config_cmd);
 
-int atmel_i2c_init_read_otp_cmd(struct atmel_i2c_cmd *cmd, u16 addr,
-				const struct atmel_i2c_max_exec_timings *timings)
+void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd,
+				    const struct atmel_i2c_max_exec_timings *timings)
 {
-	if (addr >= OTP_ZONE_SIZE / 4)
-		return -EINVAL;
-
-	cmd->word_addr = COMMAND;
-	cmd->opcode = OPCODE_READ;
+	cmd->word_addr = ATMEL_I2C_COMMAND;
+	cmd->opcode = ATMEL_I2C_OPCODE_READ;
 	/*
-	 * Read the word from OTP zone that may contain e.g. serial
-	 * numbers or similar if persistently pre-initialized and locked
+	 * Read the word from Configuration zone that contains the lock bytes
+	 * (UserExtra, Selector, LockValue, LockConfig).
 	 */
-	cmd->param1 = OTP_ZONE;
-	cmd->param2 = cpu_to_le16(addr);
-	cmd->count = READ_COUNT;
+	cmd->param1 = CONFIGURATION_ZONE;
+	cmd->param2 = cpu_to_le16(DEVICE_LOCK_ADDR);
+	cmd->count = ATMEL_I2C_READ_COUNT;
 
 	atmel_i2c_checksum(cmd);
 
 	cmd->msecs = timings->max_exec_time_read;
-	cmd->rxsize = READ_RSP_SIZE;
-
-	return 0;
+	cmd->rxsize = ATMEL_I2C_READ_RSP_SIZE;
 }
-EXPORT_SYMBOL(atmel_i2c_init_read_otp_cmd);
+EXPORT_SYMBOL(atmel_i2c_init_read_config_cmd);
 
 void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd,
 			       const struct atmel_i2c_max_exec_timings *timings)
 {
-	cmd->word_addr = COMMAND;
-	cmd->opcode = OPCODE_RANDOM;
+	cmd->word_addr = ATMEL_I2C_COMMAND;
+	cmd->opcode = ATMEL_I2C_OPCODE_RANDOM;
 	cmd->param1 = 0;
 	cmd->param2 = 0;
 	cmd->count = RANDOM_COUNT;
@@ -160,9 +168,9 @@ EXPORT_SYMBOL(atmel_i2c_init_random_cmd);
 void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid,
 			       const struct atmel_i2c_max_exec_timings *timings)
 {
-	cmd->word_addr = COMMAND;
+	cmd->word_addr = ATMEL_I2C_COMMAND;
 	cmd->count = GENKEY_COUNT;
-	cmd->opcode = OPCODE_GENKEY;
+	cmd->opcode = ATMEL_I2C_OPCODE_GENKEY;
 	cmd->param1 = GENKEY_MODE_PRIVATE;
 	/* a random private key will be generated and stored in slot keyID */
 	cmd->param2 = cpu_to_le16(keyid);
@@ -180,9 +188,9 @@ int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 {
 	size_t copied;
 
-	cmd->word_addr = COMMAND;
+	cmd->word_addr = ATMEL_I2C_COMMAND;
 	cmd->count = ECDH_COUNT;
-	cmd->opcode = OPCODE_ECDH;
+	cmd->opcode = ATMEL_I2C_OPCODE_ECDH;
 	cmd->param1 = ECDH_PREFIX_MODE;
 	/* private key slot */
 	cmd->param2 = cpu_to_le16(DATA_SLOT_2);
@@ -301,6 +309,81 @@ int atmel_i2c_register_rng(struct atmel_i2c_client_priv *i2c_priv,
 }
 EXPORT_SYMBOL(atmel_i2c_register_rng);
 
+static int atmel_i2c_eeprom_read(struct i2c_client *client, u16 addr,
+				 enum atmel_i2c_eeprom_zones zone, u8 *buf)
+{
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
+	struct atmel_i2c_cmd *cmd;
+	int ret = -1;
+
+	cmd = kmalloc_obj(*cmd);
+	if (!cmd)
+		return -ENOMEM;
+
+	ret = atmel_i2c_init_read_eeprom_cmd(cmd, addr, zone, data);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed, invalid eeprom address %04X\n",
+			addr);
+		goto err;
+	}
+
+	ret = atmel_i2c_send_receive(client, cmd);
+	if (ret)
+		goto err;
+
+	if (cmd->data[0] == 0xff) {
+		dev_err(&client->dev, "failed, device not ready\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	memcpy(buf, cmd->data + RSP_DATA_IDX, 4);
+
+err:
+	kfree(cmd);
+	return ret;
+}
+
+ssize_t atmel_i2c_eeprom_display(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf,
+				 enum atmel_i2c_eeprom_zones zone)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	const struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
+	const size_t *eeprom = data->eeprom_zone_size;
+	u16 block_addr;
+	u8 *eeprom_buf;
+	ssize_t len = 0;
+	int i, ret = 0;
+
+	eeprom_buf = kcalloc(eeprom[zone], sizeof(*eeprom_buf), GFP_KERNEL);
+	if (!eeprom_buf)
+		return -ENOMEM;
+
+	for (block_addr = 0; block_addr < eeprom[zone] / 4; block_addr++) {
+		ret = atmel_i2c_eeprom_read(client, block_addr, zone,
+					    eeprom_buf + block_addr * 4);
+		if (ret < 0) {
+			dev_err(dev, "failed to read %s zone\n",
+				zone == ATMEL_EEPROM_CONFIG_ZONE ? "CONFIG"
+				: (zone == ATMEL_EEPROM_OTP_ZONE ? "OTP" : "DATA"));
+			goto err;
+		}
+	}
+
+	for (i = 0; i < eeprom[zone]; i++)
+		len += sysfs_emit_at(buf, len, "%02X", eeprom_buf[i]);
+	len += sysfs_emit_at(buf, len, "\n");
+	ret = len;
+err:
+	kfree(eeprom_buf);
+	return ret;
+}
+EXPORT_SYMBOL(atmel_i2c_eeprom_display);
+
 /*
  * After wake and after execution of a command, there will be error, status, or
  * result bytes in the device's output register that can be retrieved by the
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 5f6c9ff0cf64..e30e0c417de2 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -12,7 +12,6 @@
 
 #define ATMEL_ECC_PRIORITY		300
 
-#define COMMAND				0x03 /* packet function */
 #define SLEEP_TOKEN			0x01
 #define WAKE_TOKEN_MAX_SIZE		8
 
@@ -30,7 +29,7 @@
 #define ECDH_RSP_SIZE			(32 + CMD_OVERHEAD_SIZE)
 #define GENKEY_RSP_SIZE			(ATMEL_ECC_PUBKEY_SIZE + \
 					 CMD_OVERHEAD_SIZE)
-#define READ_RSP_SIZE			(4 + CMD_OVERHEAD_SIZE)
+#define ATMEL_I2C_READ_RSP_SIZE		(4 + CMD_OVERHEAD_SIZE)
 #define RANDOM_RSP_SIZE			(32 + CMD_OVERHEAD_SIZE)
 #define MAX_RSP_SIZE			GENKEY_RSP_SIZE
 
@@ -57,6 +56,13 @@ struct atmel_i2c_cmd {
 	u16 rxsize;
 } __packed;
 
+/* Definitions for eeprom organization */
+enum atmel_i2c_eeprom_zones {
+	ATMEL_EEPROM_CONFIG_ZONE = 0,
+	ATMEL_EEPROM_OTP_ZONE = 1,
+	ATMEL_EEPROM_DATA_ZONE = 2,
+};
+
 struct atmel_i2c_max_exec_timings {
 	unsigned int max_exec_time_genkey;
 	unsigned int max_exec_time_ecdh;
@@ -68,6 +74,7 @@ struct atmel_i2c_max_exec_timings {
 struct atmel_i2c_of_match_data {
 	const unsigned short needs_legacy_hwrng;
 	struct atmel_i2c_max_exec_timings timings;
+	size_t eeprom_zone_size[3]; /* all atmel devices have three zones */
 };
 
 /* Status/Error codes */
@@ -77,10 +84,6 @@ struct atmel_i2c_of_match_data {
 
 /* Definitions for eeprom organization */
 #define CONFIGURATION_ZONE		0
-#define OTP_ZONE			1
-
-/* Definitions for eeprom zone sizes */
-#define OTP_ZONE_SIZE			64
 
 /* Definitions for Indexes common to all commands */
 #define RSP_DATA_IDX			1 /* buffer index of data in response */
@@ -101,14 +104,8 @@ struct atmel_i2c_of_match_data {
 /* Wake Low duration */
 #define TWLO_USEC			60
 
-/* Command opcode */
-#define OPCODE_ECDH			0x43
-#define OPCODE_GENKEY			0x40
-#define OPCODE_READ			0x02
-#define OPCODE_RANDOM			0x1b
-
 /* Definitions for the READ Command */
-#define READ_COUNT			7
+#define ATMEL_I2C_READ_COUNT		7
 
 /* Definitions for the RANDOM Command */
 #define RANDOM_COUNT			7
@@ -200,8 +197,6 @@ int atmel_i2c_send_receive(struct i2c_client *client, struct atmel_i2c_cmd *cmd)
 
 void atmel_i2c_init_read_config_cmd(struct atmel_i2c_cmd *cmd,
 				    const struct atmel_i2c_max_exec_timings *timings);
-int atmel_i2c_init_read_otp_cmd(struct atmel_i2c_cmd *cmd, u16 addr,
-				const struct atmel_i2c_max_exec_timings *timings);
 void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd,
 			       const struct atmel_i2c_max_exec_timings *timings);
 void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid,
@@ -212,6 +207,11 @@ int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 int atmel_i2c_register_rng(struct atmel_i2c_client_priv *i2c_priv,
 			   struct device *dev);
 
+ssize_t atmel_i2c_eeprom_display(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf,
+				 enum atmel_i2c_eeprom_zones zone);
+
 struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap);
 void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
 
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index ae24d8fbabf9..4f10e826e675 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -19,57 +19,10 @@
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
-static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u8 *otp)
-{
-	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
-	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
-	struct atmel_i2c_cmd cmd;
-	int ret;
-
-	ret = atmel_i2c_init_read_otp_cmd(&cmd, addr, &data->timings);
-	if (ret < 0) {
-		dev_err(&client->dev, "failed, invalid otp address %04X\n",
-			addr);
-		return ret;
-	}
-
-	ret = atmel_i2c_send_receive(client, &cmd);
-	if (ret < 0) {
-		dev_err(&client->dev, "failed to read otp at %04X\n", addr);
-		return ret;
-	}
-
-	if (cmd.data[0] == 0xff) {
-		dev_err(&client->dev, "failed, device not ready\n");
-		return -EIO;
-	}
-
-	memcpy(otp, cmd.data+1, 4);
-
-	return ret;
-}
-
 static ssize_t otp_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	u16 addr;
-	u8 otp[OTP_ZONE_SIZE];
-	struct i2c_client *client = to_i2c_client(dev);
-	ssize_t len = 0;
-	int i, ret;
-
-	for (addr = 0; addr < OTP_ZONE_SIZE / 4; addr++) {
-		ret = atmel_sha204a_otp_read(client, addr, otp + addr * 4);
-		if (ret < 0) {
-			dev_err(dev, "failed to read otp zone\n");
-			return ret;
-		}
-	}
-
-	for (i = 0; i < OTP_ZONE_SIZE; i++)
-		len += sysfs_emit_at(buf, len, "%02X", otp[i]);
-	len += sysfs_emit_at(buf, len, "\n");
-	return len;
+	return atmel_i2c_eeprom_display(dev, attr, buf, ATMEL_EEPROM_OTP_ZONE);
 }
 static DEVICE_ATTR_RO(otp);
 
@@ -110,6 +63,12 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 		      &atmel_i2c_mgmt.i2c_client_list);
 	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
+	/* EEPROM read out */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		ret = -ENODEV;
+		goto err_list_del;
+	}
+
 	ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
 	if (ret) {
 		dev_err(&client->dev, "failed to register sysfs entry\n");
@@ -157,6 +116,11 @@ static const struct atmel_i2c_of_match_data atsha204_match_data = {
 		.max_exec_time_read = 4,
 		.max_exec_time_write = 42,
 	},
+	.eeprom_zone_size = {
+		[ATMEL_EEPROM_CONFIG_ZONE] = 88,
+		[ATMEL_EEPROM_OTP_ZONE] = 64,
+		[ATMEL_EEPROM_DATA_ZONE] = 512
+	},
 	/*
 	 * According to review by Bill Cox [1], the ATSHA204 has very low entropy.
 	 * [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
@@ -171,6 +135,11 @@ static const struct atmel_i2c_of_match_data atsha204a_match_data = {
 		.max_exec_time_read = 4,
 		.max_exec_time_write = 42,
 	},
+	.eeprom_zone_size = {
+		[ATMEL_EEPROM_CONFIG_ZONE] = 88,
+		[ATMEL_EEPROM_OTP_ZONE] = 64,
+		[ATMEL_EEPROM_DATA_ZONE] = 512
+	},
 };
 
 static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
-- 
2.53.0

