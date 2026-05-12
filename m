Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BA23AA4E3
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625865; cv=none; b=sgerC9sONc6gOO4ZxFGkoVxtuC8mSJubBJpG5YrYkzgi+Hzq4ZrbPYRGurFTaRT53+82/oo+yeRZPZC0GLGzPftq2erlOZINumFryQp2K3qEGpcMxaptZwyJh7ud68kLvhpUQjTvjB2PuKwoRC8jB9m53ydDWeDcHc/iujSoERY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625865; c=relaxed/simple;
	bh=eJKjVKHt8qyfrn8BR6FKrg/GzhN3MUN2y8T19uNxbS4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bg1OIhHXXmn44CznxT2Jv8Ps7L2Q8iC0+/+ZkEvI34B+gqrJEuom9PAMTEyFt5CedfwC1CuQcJIIJR4mYsxMo7udtUJug9Zo5Q+GuDMDGpB5iYPh5ktInIm/TFDzRckNWuudHvDGF330K7ACVdDO62wzvM2HOZuCqmb6YbBW4wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mbepZS4Q; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbepZS4Q"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4493cf2f982so373949f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625860; x=1779230660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XN/bCwjdleUaVQ6snEpRjLv37bWsbUXevhTIRdq6VYs=;
        b=mbepZS4QYTNkIIphnrCKV0FPRCXHcBChdvaehUdaYnnX30Ic5y57d1pardALy9ln/2
         CIUwIDmLyMFqnhSVJrd8QTCWkVpasxFIG3RjYPd+aaoobcgz6pNzpP1tUVaZjkSG5CmI
         4DLLd+ztuJpXIV2w+lSChS8w+XtAeYeMVudPDO2oyKioggg8oA5NrO2ZmTEeGzX14XKT
         cZzXKbmpvMOWnVQPHuVjkxERU9syRSoMMqLO/1xGYAKnwOlxhAl+01+0pQ8EcFmVKDOp
         iUHJUX1OJamV1z26ZrbdHSQa3YypXr7Sz39S6bQCmkX0MpJxxe1LPLHZo5zhde8+LAvD
         DlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625860; x=1779230660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XN/bCwjdleUaVQ6snEpRjLv37bWsbUXevhTIRdq6VYs=;
        b=X0tR/eVtEPems4ECqOdr9Ulnrif+M4jYuXPOEB2sn/UbJSZI+bGznPfXEXBRN8Muh5
         8UPTEE4BcVSWUcuWninj4v5+h94bMVDkfnmMGnwHw1SPZ6AipK0BaD2rv8W0AYO93TEY
         ZRXmvbmFqfrTQlOXVlTS+RzMqQunsgLiuNkkS/2RD6rgbl7RXLRKzDibNYv51U6fxzI4
         Y33Lf7ZBmOSBlRo0ArGaW61JDb2JlrGyvXrp2cefbVcCT6vP3WSx6YNzYJdNJ4eM+kGd
         di29qEbP+awV7HrSNoUpaC7XxeyD3IP0zFMZhjDeI1WSRsIeVpAXRKaXmmaU+dglsarW
         ti4A==
X-Gm-Message-State: AOJu0YzuPRLz9W8hlhJPGXK+S3PA1tfLROawGwhMkRhCBgE5CXhZdNom
	pHKytqmG1rUE05cxITf5aq/iOOSmn8rg5pH6G7alD0nSmCE0AIu38lGz
X-Gm-Gg: Acq92OGlowwhpHxl0sA1Qu48Liynbn42mukmM1Ak4otmIWSlSiQ7EY9DedNyldlPVJv
	PEx1Jc/ntB4yFXn2fscT3TLqDdULnOiXuks9kmg4lHL7D47gozitln19rBTwxszvUJEIoobsaD0
	haDaWEfl5mnRVIIZcuLgRuI7nfIrFfzPkQAcgPzbyGPH0u5fIfONm4c/WIddwbrLATlfX1aCL5B
	PIrXwqZM0W+EeTza4bKjfOWNKTdEisXxBd3FmlH7a7MTNt/DnLXDfo8WMpeU2TELLeve1/6DWhE
	u8z5onzN+6p47YxA6smrSdRbbO9gFVMO7Hz7NDNxnNi/RD/BzzvtUqW2Ox/Ub8rkSr8iSDf6Fyj
	5RBcQay9LWhA+4ZVmU7wUHOJ2U3uQJbexAkNpdS2rCnPrXE02563+kQNDZVJQK+lS6GgVwAwfRi
	iNqm/QGMimI83Dch/3NsUr0fdB8AgXCgIEY1gr2aFR/bZWPOrOIN2YUj9+zaqWBnQ=
X-Received: by 2002:a05:600c:19ce:b0:48a:58e1:6cf7 with SMTP id 5b1f17b1804b1-48fc9a362f9mr4060715e9.4.1778625860150;
        Tue, 12 May 2026 15:44:20 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:19 -0700 (PDT)
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
Subject: [PATCH 12/12] crypto: atmel - add SHA256 ahash support
Date: Tue, 12 May 2026 22:43:49 +0000
Message-Id: <20260512224349.64621-13-l.rubusch@gmail.com>
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

Add SHA256 ahash support for ATSHA204A and ECC based devices using
the hardware SHA engine provided by the Atmel secure element devices.

Implement common SHA256 request handling in the atmel-i2c core driver,
including init, update, final, finup, digest, export and import
operations. Scatterlist input is processed using the crypto hash
walker.

ATSHA204A devices require software-side SHA256 padding according to
FIPS 180-4 before submitting the final data blocks to the device.
Newer ECC devices instead support a dedicated SHA final command which
performs padding internally in hardware. For these devices, the final
block length is passed through the command parameter field.

The SHA engine requires a strict multi-command transaction sequence:
SHA INIT, followed by one or more SHA COMPUTE operations and, on ECC
devices, a terminating SHA FINAL operation. The device SHA context is
lost if the device enters sleep mode or if unrelated commands are
interleaved during the sequence.

To support these hardware requirements, split the existing
send/receive helper into a low-level transfer helper and a higher
level wrapper handling wakeup, sleep and locking. SHA operations keep
the device awake and hold the i2c client lock across the complete hash
transaction until the final digest has been retrieved.

Register the SHA256 ahash algorithm in both atmel-sha204a and
atmel-ecc drivers and add capability based client allocation for SHA
operations.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     |  50 +++++-
 drivers/crypto/atmel-i2c.c     | 273 +++++++++++++++++++++++++++++++--
 drivers/crypto/atmel-i2c.h     |  40 +++++
 drivers/crypto/atmel-sha204a.c |  55 ++++++-
 4 files changed, 407 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index ed8c0ce5562b..aacf9e8add7a 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -19,10 +19,50 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <crypto/internal/kpp.h>
+#include <crypto/internal/hash.h>
 #include <crypto/ecdh.h>
 #include <crypto/kpp.h>
+#include <crypto/sha2.h>
 #include "atmel-i2c.h"
 
+static int atmel_ecc_sha_init_tfm(struct crypto_tfm *tfm)
+{
+	struct atmel_i2c_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->client = atmel_i2c_client_alloc(ATMEL_CAP_SHA);
+	if (IS_ERR(ctx->client)) {
+		pr_err("tfm - i2c_client binding failed\n");
+		return PTR_ERR(ctx->client);
+	}
+
+	return 0;
+}
+
+static struct ahash_alg atmel_ecc_sha = {
+	.init = atmel_i2c_sha_init,
+	.update	= atmel_i2c_sha_update,
+	.final = atmel_i2c_sha_final,
+	.finup = atmel_i2c_sha_finup,
+	.digest	= atmel_i2c_sha_digest,
+	.export = atmel_i2c_sha_export,
+	.import = atmel_i2c_sha_import,
+	.halg = {
+		.digestsize = SHA256_DIGEST_SIZE,
+		.statesize = sizeof(struct atmel_i2c_sha_reqctx),
+		.base = {
+			.cra_name		= "sha256",
+			.cra_driver_name	= "atmel-sha256",
+			.cra_init		= atmel_ecc_sha_init_tfm,
+			.cra_priority		= ATMEL_I2C_PRIORITY,
+			.cra_flags		= CRYPTO_ALG_TYPE_AHASH,
+			.cra_blocksize		= SHA256_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct atmel_i2c_sha_ctx),
+			.cra_reqsize		= sizeof(struct atmel_i2c_sha_reqctx),
+			.cra_module		= THIS_MODULE,
+		}
+	}
+};
+
 static ssize_t config_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	return atmel_i2c_eeprom_display(dev, attr, buf, ATMEL_EEPROM_CONFIG_ZONE);
@@ -321,7 +361,7 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 	i2c_priv->data = data;
-	i2c_priv->caps = BIT(ATMEL_CAP_ECDH);
+	i2c_priv->caps = BIT(ATMEL_CAP_ECDH) | BIT(ATMEL_CAP_SHA);
 
 	ret = atmel_i2c_device_sanity_check(client);
 	if (ret) {
@@ -364,6 +404,12 @@ static int atmel_ecc_probe(struct i2c_client *client)
 		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
 	}
 
+	ret = crypto_register_ahash(&atmel_ecc_sha);
+	if (ret) {
+		dev_err(&client->dev, "SHA256 registration failed\n");
+		goto err_list_del;
+	}
+
 	goto done;
 
 err_list_del:
@@ -392,6 +438,7 @@ static void atmel_ecc_remove(struct i2c_client *client)
 	atmel_i2c_flush_queue();
 
 	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
+	crypto_unregister_ahash(&atmel_ecc_sha);
 
 	if (i2c_priv->hwrng.priv) {
 		kfree((void *)i2c_priv->hwrng.priv);
@@ -405,6 +452,7 @@ static const struct atmel_i2c_of_match_data atecc508a_match_data = {
 		.max_exec_time_genkey = 115,
 		.max_exec_time_random = 23,
 		.max_exec_time_read = 1,
+		.max_exec_time_sha = 9,
 		.max_exec_time_write = 42,
 	},
 	.eeprom_zone_size = {
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 53aba2f4bedb..cbdc8c0e5aca 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -19,6 +19,10 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <crypto/hash.h>
+#include <crypto/sha2.h>
+#include <crypto/internal/hash.h>
+
 #include "atmel-i2c.h"
 
 #define ATMEL_I2C_COMMAND		0x03 /* packet function */
@@ -49,12 +53,17 @@
 #define ATMEL_I2C_ECDH_RSP_SIZE		(32 + ATMEL_I2C_RSP_OVERHEAD_SIZE)
 #define ATMEL_I2C_ECDH_PREFIX_MODE	0x00
 
+/* Definitions for the SHA Command */
+#define ATMEL_I2C_SHA_RSP_SIZE		(ATMEL_I2C_RSP_OVERHEAD_SIZE + \
+					SHA256_DIGEST_SIZE)
+
 /* Command opcode */
 #define ATMEL_I2C_OPCODE_ECDH		0x43
 #define ATMEL_I2C_OPCODE_GENKEY		0x40
 #define ATMEL_I2C_OPCODE_READ		0x02
 #define ATMEL_I2C_OPCODE_RANDOM		0x1b
 #define ATMEL_I2C_OPCODE_WRITE		0x12
+#define ATMEL_I2C_OPCODE_SHA		0x47
 
 /*
  * Wake High delay to data communication (microseconds). SDA should be stable
@@ -244,6 +253,43 @@ int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 }
 EXPORT_SYMBOL(atmel_i2c_init_ecdh_cmd);
 
+int atmel_i2c_init_sha_cmd(struct atmel_i2c_cmd *cmd,
+			   u8 *challenge, size_t len,
+			   enum atmel_i2c_sha_engine_cmd sha_engine_cmd,
+			   const struct atmel_i2c_max_exec_timings *timings)
+{
+	cmd->word_addr = ATMEL_I2C_COMMAND;
+	cmd->opcode = ATMEL_I2C_OPCODE_SHA;
+	cmd->param1 = sha_engine_cmd;
+
+	cmd->param2 = cpu_to_le16(0);
+	/*
+	 * Starting with the bigger ECCs, the device learned how to do SHA256
+	 * padding (FIPS 180-4). Since SHA UPDATE always consumes 64B (SHA256
+	 * block size), the only length needed to communicate is the number of
+	 * used bytes in the final block. For the Atmel ECC series, this is
+	 * passed in the param2.
+	 */
+	if (sha_engine_cmd == atmel_sha_ecc_end)
+		cmd->param2 = cpu_to_le16(len);
+
+	cmd->count = ATMEL_I2C_COUNT_OVERHEAD_SIZE;
+	if (sha_engine_cmd == atmel_sha_init) {
+		memset(cmd->data, 0, sizeof(cmd->data));
+	} else {
+		memcpy(cmd->data, challenge, len);
+		cmd->count += len;
+	}
+
+	atmel_i2c_checksum(cmd);
+
+	cmd->msecs = timings->max_exec_time_sha;
+	cmd->rxsize = atmel_i2c_sha_rsp_size[sha_engine_cmd];
+
+	return 0;
+}
+EXPORT_SYMBOL(atmel_i2c_init_sha_cmd);
+
 static void atmel_i2c_rng_done(struct atmel_i2c_work_data *work_data,
 			       void *areq, int status)
 {
@@ -492,21 +538,15 @@ static int atmel_i2c_sleep(struct i2c_client *client)
  * counter other than to put the device into sleep or idle mode and then
  * wake it up again.
  */
-int atmel_i2c_send_receive(struct i2c_client *client, struct atmel_i2c_cmd *cmd)
+static int _atmel_i2c_send_receive(struct i2c_client *client,
+				   struct atmel_i2c_cmd *cmd)
 {
-	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 	int ret;
 
-	mutex_lock(&i2c_priv->lock);
-
-	ret = atmel_i2c_wakeup(client);
-	if (ret)
-		goto err;
-
 	/* send the command */
 	ret = i2c_master_send(client, (u8 *)cmd, cmd->count + ATMEL_I2C_ADDR_SIZE);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	/* delay the appropriate amount of time for command to execute */
 	msleep(cmd->msecs);
@@ -514,6 +554,24 @@ int atmel_i2c_send_receive(struct i2c_client *client, struct atmel_i2c_cmd *cmd)
 	/* receive the response */
 	ret = i2c_master_recv(client, cmd->data, cmd->rxsize);
 	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int atmel_i2c_send_receive(struct i2c_client *client, struct atmel_i2c_cmd *cmd)
+{
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
+	int ret;
+
+	mutex_lock(&i2c_priv->lock);
+
+	ret = atmel_i2c_wakeup(client);
+	if (ret)
+		goto err;
+
+	ret = _atmel_i2c_send_receive(client, cmd);
+	if (ret)
 		goto err;
 
 	/* put the device into low-power mode */
@@ -529,6 +587,203 @@ int atmel_i2c_send_receive(struct i2c_client *client, struct atmel_i2c_cmd *cmd)
 }
 EXPORT_SYMBOL(atmel_i2c_send_receive);
 
+int atmel_i2c_sha_init(struct ahash_request *req)
+{
+	struct atmel_i2c_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct atmel_i2c_sha_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(ctx->client);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
+	struct atmel_i2c_cmd *cmd;
+	int ret;
+
+	rctx->bufcnt = 0;
+	rctx->total = 0;
+	rctx->ctx = i2c_get_clientdata(ctx->client);
+
+	cmd = kmalloc_obj(*cmd);
+	if (!cmd)
+		return -ENOMEM;
+
+	/* SHA init */
+	ret = atmel_i2c_init_sha_cmd(cmd, NULL, 0, atmel_sha_init, &data->timings);
+	if (ret)
+		goto err_free;
+
+	mutex_lock(&i2c_priv->lock);
+
+	ret = atmel_i2c_wakeup(ctx->client);
+	if (ret)
+		goto err;
+
+	ret = _atmel_i2c_send_receive(ctx->client, cmd);
+	if (ret)
+		goto err;
+
+	/* we keep the lock hold until error out or _sha_final() is called */
+	return 0;
+err:
+	mutex_unlock(&i2c_priv->lock);
+err_free:
+	kfree_sensitive(cmd);
+	return ret;
+}
+EXPORT_SYMBOL(atmel_i2c_sha_init);
+
+int atmel_i2c_sha_update(struct ahash_request *req)
+{
+	struct atmel_i2c_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct atmel_i2c_sha_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(ctx->client);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
+	struct atmel_i2c_cmd *cmd;
+	struct crypto_hash_walk walk;
+	int nbytes, take, copied = 0;
+	const u8 *pdata;
+	int ret;
+
+	rctx->total += req->nbytes;
+
+	cmd = kmalloc_obj(*cmd);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto err_nomem;
+	}
+
+	/*
+	 * Note, we are actively holding the i2c_priv->lock while the SHA engine
+	 * operates. This covers init, update and final steps.
+	 */
+	nbytes = crypto_hash_walk_first(req, &walk);
+	for (; nbytes > 0; nbytes = crypto_hash_walk_done(&walk, copied)) {
+		copied = nbytes;
+		pdata = walk.data;
+		while (copied > 0) {
+			take = min(copied, SHA256_BLOCK_SIZE - rctx->bufcnt);
+
+			memcpy(rctx->buffer + rctx->bufcnt, pdata, take);
+			pdata += take;
+			copied -= take;
+			rctx->bufcnt += take;
+			if (rctx->bufcnt == SHA256_BLOCK_SIZE) {
+				ret = atmel_i2c_init_sha_cmd(cmd, rctx->buffer,
+							     SHA256_BLOCK_SIZE,
+							     atmel_sha_compute,
+							     &data->timings);
+				if (ret)
+					goto err;
+
+				ret = _atmel_i2c_send_receive(ctx->client, cmd);
+				if (ret)
+					goto err;
+
+				rctx->bufcnt = 0;
+			}
+		}
+	}
+
+	kfree_sensitive(cmd);
+	return 0;
+err:
+	kfree_sensitive(cmd);
+err_nomem:
+	mutex_unlock(&i2c_priv->lock);
+	return ret;
+}
+EXPORT_SYMBOL(atmel_i2c_sha_update);
+
+int atmel_i2c_sha_final(struct ahash_request *req)
+{
+	struct atmel_i2c_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct atmel_i2c_sha_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(ctx->client);
+	const struct atmel_i2c_of_match_data *data = i2c_priv->data;
+	struct atmel_i2c_cmd *cmd;
+	u8 final_blocks[2 * SHA256_BLOCK_SIZE];
+	u32 total_pad;
+	__be64 bits;
+	int i, ret = 0;
+
+	cmd = kmalloc_obj(*cmd);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto err_nomem;
+	}
+
+	if (data->needs_sha_padding) {
+		/*
+		 * Determine if padding fits in current block or needs another,
+		 * SHA256 needs 8 bytes for length at the end of a 64-byte block.
+		 */
+		memset(final_blocks, 0, sizeof(final_blocks));
+		memcpy(final_blocks, rctx->buffer, rctx->bufcnt);
+		final_blocks[rctx->bufcnt] = 0x80; /* pad bit */
+		total_pad = SHA256_BLOCK_SIZE * (rctx->bufcnt < 56 ? 1 : 2);
+		bits = cpu_to_be64((u64)rctx->total << 3); /* needs num of bits */
+		memcpy(final_blocks + total_pad - 8, &bits, 8);
+		for (i = 0; i < total_pad; i += SHA256_BLOCK_SIZE) {
+			ret = atmel_i2c_init_sha_cmd(cmd, final_blocks + i,
+						     SHA256_BLOCK_SIZE,
+						     atmel_sha_compute, &data->timings);
+			if (ret)
+				goto err_or_done;
+
+			ret = _atmel_i2c_send_receive(ctx->client, cmd);
+			if (ret)
+				goto err_or_done;
+		}
+	} else {
+		ret = atmel_i2c_init_sha_cmd(cmd, rctx->buffer, rctx->bufcnt,
+					     atmel_sha_ecc_end, &data->timings);
+		if (ret)
+			goto err_or_done;
+
+		ret = _atmel_i2c_send_receive(ctx->client, cmd);
+		if (ret)
+			goto err_or_done;
+	}
+
+	memcpy(req->result, &cmd->data[ATMEL_I2C_RSP_DATA_IDX],
+	       SHA256_DIGEST_SIZE);
+
+	/* Sleep returns a positive int on success, API requires 0 on success */
+	ret = atmel_i2c_sleep(ctx->client);
+	if (ret < 0)
+		goto err_or_done;
+	ret = 0;
+err_or_done:
+	kfree_sensitive(cmd);
+err_nomem:
+	mutex_unlock(&i2c_priv->lock);
+	return ret;
+}
+EXPORT_SYMBOL(atmel_i2c_sha_final);
+
+int atmel_i2c_sha_finup(struct ahash_request *req)
+{
+	return atmel_i2c_sha_update(req) ? : atmel_i2c_sha_final(req);
+}
+EXPORT_SYMBOL(atmel_i2c_sha_finup);
+
+int atmel_i2c_sha_digest(struct ahash_request *req)
+{
+	return atmel_i2c_sha_init(req) ? : atmel_i2c_sha_finup(req);
+}
+EXPORT_SYMBOL(atmel_i2c_sha_digest);
+
+int atmel_i2c_sha_export(struct ahash_request *req, void *out)
+{
+	memcpy(out, ahash_request_ctx(req), sizeof(struct atmel_i2c_sha_reqctx));
+	return 0;
+}
+EXPORT_SYMBOL(atmel_i2c_sha_export);
+
+int atmel_i2c_sha_import(struct ahash_request *req, const void *in)
+{
+	memcpy(ahash_request_ctx(req), in, sizeof(struct atmel_i2c_sha_reqctx));
+	return 0;
+}
+EXPORT_SYMBOL(atmel_i2c_sha_import);
+
 static void atmel_i2c_work_handler(struct work_struct *work)
 {
 	struct atmel_i2c_work_data *work_data =
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 20afe2da4f8d..e0021d4ea686 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -7,8 +7,11 @@
 #ifndef __ATMEL_I2C_H__
 #define __ATMEL_I2C_H__
 
+#include <linux/device.h>
+#include <crypto/internal/hash.h>
 #include <linux/hw_random.h>
 #include <linux/types.h>
+#include <crypto/sha2.h>
 
 #define ATMEL_I2C_PRIORITY		300
 
@@ -79,11 +82,13 @@ struct atmel_i2c_max_exec_timings {
 	unsigned int max_exec_time_ecdh;
 	unsigned int max_exec_time_random;
 	unsigned int max_exec_time_read;
+	unsigned int max_exec_time_sha;
 	unsigned int max_exec_time_write;
 };
 
 struct atmel_i2c_of_match_data {
 	const unsigned short needs_legacy_hwrng;
+	const unsigned short needs_sha_padding;
 	struct atmel_i2c_max_exec_timings timings;
 	size_t eeprom_zone_size[3]; /* all atmel devices have three zones */
 };
@@ -91,6 +96,30 @@ struct atmel_i2c_of_match_data {
 /* Used for binding tfm objects to i2c clients. */
 enum atmel_i2c_capability {
 	ATMEL_CAP_ECDH = 0,
+	ATMEL_CAP_SHA,
+};
+
+enum atmel_i2c_sha_engine_cmd {
+	atmel_sha_init = 0,
+	atmel_sha_compute,
+	atmel_sha_ecc_end,
+};
+
+size_t atmel_i2c_sha_rsp_size[] = {
+	[atmel_sha_init] = ATMEL_I2C_STATUS_RSP_SIZE,
+	[atmel_sha_compute] = SHA256_DIGEST_SIZE + ATMEL_I2C_RSP_OVERHEAD_SIZE,
+	[atmel_sha_ecc_end] = SHA256_DIGEST_SIZE + ATMEL_I2C_RSP_OVERHEAD_SIZE,
+};
+
+struct atmel_i2c_sha_ctx {
+	struct i2c_client *client;
+};
+
+struct atmel_i2c_sha_reqctx {
+	u8 buffer[SHA256_BLOCK_SIZE];
+	size_t bufcnt;
+	size_t total; /* size of full input, needed for padding */
+	struct atmel_i2c_client_priv *ctx;
 };
 
 struct atmel_i2c_client_mgmt {
@@ -172,9 +201,20 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid,
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey,
 			    const struct atmel_i2c_max_exec_timings *timings);
+int atmel_i2c_init_sha_cmd(struct atmel_i2c_cmd *cmd, u8 *challenge, size_t len,
+			   enum atmel_i2c_sha_engine_cmd sha_engine_cmd,
+			   const struct atmel_i2c_max_exec_timings *timings);
 int atmel_i2c_register_rng(struct atmel_i2c_client_priv *i2c_priv,
 			   struct device *dev);
 
+int atmel_i2c_sha_init(struct ahash_request *req);
+int atmel_i2c_sha_update(struct ahash_request *req);
+int atmel_i2c_sha_final(struct ahash_request *req);
+int atmel_i2c_sha_finup(struct ahash_request *req);
+int atmel_i2c_sha_digest(struct ahash_request *req);
+int atmel_i2c_sha_export(struct ahash_request *req, void *out);
+int atmel_i2c_sha_import(struct ahash_request *req, const void *in);
+
 int atmel_i2c_device_sanity_check(struct i2c_client *client);
 
 ssize_t atmel_i2c_eeprom_display(struct device *dev,
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 6a41024ae40d..74535480edeb 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -17,8 +17,48 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/workqueue.h>
+#include <crypto/sha2.h>
+
 #include "atmel-i2c.h"
 
+static int atmel_sha204a_sha_init_tfm(struct crypto_tfm *tfm)
+{
+	struct atmel_i2c_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->client = atmel_i2c_client_alloc(ATMEL_CAP_SHA);
+	if (IS_ERR(ctx->client)) {
+		pr_err("tfm - i2c_client binding failed\n");
+		return PTR_ERR(ctx->client);
+	}
+
+	return 0;
+}
+
+static struct ahash_alg atmel_sha204a_sha = {
+	.init = atmel_i2c_sha_init,
+	.update	= atmel_i2c_sha_update,
+	.final = atmel_i2c_sha_final,
+	.finup = atmel_i2c_sha_finup,
+	.digest	= atmel_i2c_sha_digest,
+	.export = atmel_i2c_sha_export,
+	.import = atmel_i2c_sha_import,
+	.halg = {
+		.digestsize = SHA256_DIGEST_SIZE,
+		.statesize = sizeof(struct atmel_i2c_sha_reqctx),
+		.base = {
+			.cra_name		= "sha256",
+			.cra_driver_name	= "atmel-sha256",
+			.cra_init		= atmel_sha204a_sha_init_tfm,
+			.cra_priority		= ATMEL_I2C_PRIORITY,
+			.cra_flags		= CRYPTO_ALG_TYPE_AHASH,
+			.cra_blocksize		= SHA256_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct atmel_i2c_sha_ctx),
+			.cra_reqsize		= sizeof(struct atmel_i2c_sha_reqctx),
+			.cra_module		= THIS_MODULE,
+		}
+	}
+};
+
 static ssize_t config_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	return atmel_i2c_eeprom_display(dev, attr, buf, ATMEL_EEPROM_CONFIG_ZONE);
@@ -62,7 +102,7 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 	i2c_priv->data = data;
-	i2c_priv->caps = 0;
+	i2c_priv->caps = BIT(ATMEL_CAP_SHA);
 
 	ret = atmel_i2c_device_sanity_check(client);
 	if (ret) {
@@ -95,6 +135,13 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 		goto err_list_del;
 	}
 
+	/* register algorithms */
+	ret = crypto_register_ahash(&atmel_sha204a_sha);
+	if (ret) {
+		dev_err(&client->dev, "SHA256 registration failed\n");
+		goto err_list_del;
+	}
+
 	goto done;
 
 err_list_del:
@@ -119,6 +166,8 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
 	atmel_i2c_flush_queue();
 
+	crypto_unregister_ahash(&atmel_sha204a_sha);
+
 	if (i2c_priv->hwrng.priv) {
 		kfree((void *)i2c_priv->hwrng.priv);
 		i2c_priv->hwrng.priv = 0;
@@ -130,6 +179,7 @@ static const struct atmel_i2c_of_match_data atsha204_match_data = {
 		.max_exec_time_genkey = 43,
 		.max_exec_time_random = 50,
 		.max_exec_time_read = 4,
+		.max_exec_time_sha = 22,
 		.max_exec_time_write = 42,
 	},
 	.eeprom_zone_size = {
@@ -142,6 +192,7 @@ static const struct atmel_i2c_of_match_data atsha204_match_data = {
 	 * [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
 	 */
 	.needs_legacy_hwrng = 1,
+	.needs_sha_padding = 1,
 };
 
 static const struct atmel_i2c_of_match_data atsha204a_match_data = {
@@ -149,6 +200,7 @@ static const struct atmel_i2c_of_match_data atsha204a_match_data = {
 		.max_exec_time_genkey = 43,
 		.max_exec_time_random = 50,
 		.max_exec_time_read = 4,
+		.max_exec_time_sha = 22,
 		.max_exec_time_write = 42,
 	},
 	.eeprom_zone_size = {
@@ -156,6 +208,7 @@ static const struct atmel_i2c_of_match_data atsha204a_match_data = {
 		[ATMEL_EEPROM_OTP_ZONE] = 64,
 		[ATMEL_EEPROM_DATA_ZONE] = 512
 	},
+	.needs_sha_padding = 1,
 };
 
 static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
-- 
2.53.0

