Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A23AC282E3
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 16:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F67C2075D
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 16:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EAEiG0Sl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390733AbfEXQ1p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 12:27:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40745 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390668AbfEXQ1p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 12:27:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id t4so2355419wrx.7
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 09:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fEjtPdaBAqYRZI8UVsqNWtXwmYQF0pkPjODsBVdhtdo=;
        b=EAEiG0Slgf2dbGN1ZsAmwlM5Tw6BOTdlwNxgjGUJjZGjGBni+Sdfph0avf/Abgm9mT
         n5wtJEO5hw2Myhpzx6upQtWmbH0ERyZh548xHOu+Px9Dtlf8JfMBxR9ttiteYr3rbsZM
         zZ+lGgHGfvzQOt1nFnBYNhts8lWC3rwwbZb0l1dXNiZt3lt8sGXy463gfoFkQUQmtIjY
         cFKNC9uNUbeTRlM5fSu75uhD0Q1JzKWdV7gjXLbkdzHO5FEkX13F3RN5oqK3x7vgHakT
         EPpweoBzV0y/C0Hp4i/mno1z7lac7yQqZEfvU3EMzAMmFOqpEvzh/FDbJ7oNXjp2ezzO
         xBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fEjtPdaBAqYRZI8UVsqNWtXwmYQF0pkPjODsBVdhtdo=;
        b=eX7gVV1hUhNuV7aDjjAznkWrP6zJcUK1cWSr/ez1i1t6hYd5VxytSr6MV2adOqeTzJ
         wc31kr1qJQ+M8p1mn59urdtvX23opXuJ8RkbAp2I9pih7wWY/n/8+QHCZ5r83POzjc/2
         5lY1HLfQaWJ4HEQ4EFC+NLCY4s/W+XbW0370k9qXvU/4ul5Tf/Xnm58ckaXd8NLooIhd
         ApcUZJdDOGuLa12ZyqeionBOvHEDvH82aCXw8BK3JA+fESSjtbWVB/4nGsf2ZHE2nhe4
         QksrewFY8iYheiAZgnTEL82408uWewpS/XecWuBwZR7OPWPH3xF5ZK+xLyj8zPVgIwAg
         m3RQ==
X-Gm-Message-State: APjAAAVasmkRNlS0EoYAfGDNKcR3TfWhF6lzPdrcQx4Kop8oeK8iYGtu
        3Jvq1GeVz0dwkP0zDk4qRYMAWqQxofr+NZuG
X-Google-Smtp-Source: APXvYqwn97jtLkvQRpG+CAHXUBfIhALTlPkBLVQdKQffyzM73YAtjwSSH4BYWEQO5ZLXskCqZNlEEA==
X-Received: by 2002:a5d:68d2:: with SMTP id p18mr59634313wrw.56.1558715262003;
        Fri, 24 May 2019 09:27:42 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:2042:d8f2:ded8:fa95])
        by smtp.gmail.com with ESMTPSA id l6sm2200320wmi.24.2019.05.24.09.27.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 09:27:41 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 4/6] crypto: atmel-i2c: add support for SHA204A random number generator
Date:   Fri, 24 May 2019 18:26:49 +0200
Message-Id: <20190524162651.28189-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
References: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Linaro/96boards Secure96 mezzanine contains (among other things)
an Atmel SHA204A symmetric crypto processor. This chip implements a
number of different functionalities, but one that is highly useful
for many different 96boards platforms is the random number generator.

So let's implement a driver for the SHA204A, and for the time being,
implement support for the random number generator only.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/Kconfig         |  14 ++
 drivers/crypto/Makefile        |   1 +
 drivers/crypto/atmel-i2c.c     |  15 ++
 drivers/crypto/atmel-i2c.h     |  10 ++
 drivers/crypto/atmel-sha204a.c | 171 ++++++++++++++++++++
 5 files changed, 211 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ca7a5564e9ce..fe01a9905ab1 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -537,6 +537,20 @@ config CRYPTO_DEV_ATMEL_ECC
 	  To compile this driver as a module, choose M here: the module
 	  will be called atmel-ecc.
 
+config CRYPTO_DEV_ATMEL_SHA204A
+	tristate "Support for Microchip / Atmel SHA accelerator and RNG"
+	depends on I2C
+	select CRYPTO_DEV_ATMEL_I2C
+	select HW_RANDOM
+	help
+	  Microhip / Atmel SHA accelerator and RNG.
+	  Select this if you want to use the Microchip / Atmel SHA204A
+	  module as a random number generator. (Other functions of the
+	  chip are currently not exposed by this driver)
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called atmel-sha204a.
+
 config CRYPTO_DEV_CCP
 	bool "Support for AMD Secure Processor"
 	depends on ((X86 && PCI) || (ARM64 && (OF_ADDRESS || ACPI))) && HAS_IOMEM
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 394e84089924..afc4753b5d28 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA) += atmel-sha.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_I2C) += atmel-i2c.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_ECC) += atmel-ecc.o
+obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA204A) += atmel-sha204a.o
 obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += cavium/
 obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
 obj-$(CONFIG_CRYPTO_DEV_CCREE) += ccree/
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 5e099368d120..be49ab7f4338 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -58,6 +58,21 @@ void atmel_i2c_init_read_cmd(struct atmel_i2c_cmd *cmd)
 }
 EXPORT_SYMBOL(atmel_i2c_init_read_cmd);
 
+void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd)
+{
+	cmd->word_addr = COMMAND;
+	cmd->opcode = OPCODE_RANDOM;
+	cmd->param1 = 0;
+	cmd->param2 = 0;
+	cmd->count = RANDOM_COUNT;
+
+	atmel_i2c_checksum(cmd);
+
+	cmd->msecs = MAX_EXEC_TIME_RANDOM;
+	cmd->rxsize = RANDOM_RSP_SIZE;
+}
+EXPORT_SYMBOL(atmel_i2c_init_random_cmd);
+
 void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid)
 {
 	cmd->word_addr = COMMAND;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 82de5166acfa..c6bd43b78f33 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -7,6 +7,8 @@
 #ifndef __ATMEL_I2C_H__
 #define __ATMEL_I2C_H__
 
+#include <linux/hw_random.h>
+
 #define ATMEL_ECC_PRIORITY		300
 
 #define COMMAND				0x03 /* packet function */
@@ -28,6 +30,7 @@
 #define GENKEY_RSP_SIZE			(ATMEL_ECC_PUBKEY_SIZE + \
 					 CMD_OVERHEAD_SIZE)
 #define READ_RSP_SIZE			(4 + CMD_OVERHEAD_SIZE)
+#define RANDOM_RSP_SIZE			(32 + CMD_OVERHEAD_SIZE)
 #define MAX_RSP_SIZE			GENKEY_RSP_SIZE
 
 /**
@@ -96,15 +99,20 @@ static const struct {
 #define MAX_EXEC_TIME_ECDH		58
 #define MAX_EXEC_TIME_GENKEY		115
 #define MAX_EXEC_TIME_READ		1
+#define MAX_EXEC_TIME_RANDOM		50
 
 /* Command opcode */
 #define OPCODE_ECDH			0x43
 #define OPCODE_GENKEY			0x40
 #define OPCODE_READ			0x02
+#define OPCODE_RANDOM			0x1b
 
 /* Definitions for the READ Command */
 #define READ_COUNT			7
 
+/* Definitions for the RANDOM Command */
+#define RANDOM_COUNT			7
+
 /* Definitions for the GenKey Command */
 #define GENKEY_COUNT			7
 #define GENKEY_MODE_PRIVATE		0x04
@@ -142,6 +150,7 @@ struct atmel_i2c_client_priv {
 	u8 wake_token[WAKE_TOKEN_MAX_SIZE];
 	size_t wake_token_sz;
 	atomic_t tfm_count ____cacheline_aligned;
+	struct hwrng hwrng;
 };
 
 /**
@@ -179,6 +188,7 @@ void atmel_i2c_enqueue(struct atmel_i2c_work_data *work_data,
 int atmel_i2c_send_receive(struct i2c_client *client, struct atmel_i2c_cmd *cmd);
 
 void atmel_i2c_init_read_cmd(struct atmel_i2c_cmd *cmd);
+void atmel_i2c_init_random_cmd(struct atmel_i2c_cmd *cmd);
 void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
new file mode 100644
index 000000000000..ea0d2068ea4f
--- /dev/null
+++ b/drivers/crypto/atmel-sha204a.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Microchip / Atmel SHA204A (I2C) driver.
+ *
+ * Copyright (c) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include "atmel-i2c.h"
+
+static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
+				   void *areq, int status)
+{
+	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
+	struct hwrng *rng = areq;
+
+	if (status)
+		dev_warn_ratelimited(&i2c_priv->client->dev,
+				     "i2c transaction failed (%d)\n",
+				     status);
+
+	rng->priv = (unsigned long)work_data;
+	atomic_dec(&i2c_priv->tfm_count);
+}
+
+static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
+					      size_t max)
+{
+	struct atmel_i2c_client_priv *i2c_priv;
+	struct atmel_i2c_work_data *work_data;
+
+	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
+
+	/* keep maximum 1 asynchronous read in flight at any time */
+	if (!atomic_add_unless(&i2c_priv->tfm_count, 1, 1))
+		return 0;
+
+	if (rng->priv) {
+		work_data = (struct atmel_i2c_work_data *)rng->priv;
+		max = min(sizeof(work_data->cmd.data), max);
+		memcpy(data, &work_data->cmd.data, max);
+		rng->priv = 0;
+	} else {
+		work_data = kmalloc(sizeof(*work_data), GFP_ATOMIC);
+		if (!work_data)
+			return -ENOMEM;
+
+		work_data->ctx = i2c_priv;
+		work_data->client = i2c_priv->client;
+
+		max = 0;
+	}
+
+	atmel_i2c_init_random_cmd(&work_data->cmd);
+	atmel_i2c_enqueue(work_data, atmel_sha204a_rng_done, rng);
+
+	return max;
+}
+
+static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
+				  bool wait)
+{
+	struct atmel_i2c_client_priv *i2c_priv;
+	struct atmel_i2c_cmd cmd;
+	int ret;
+
+	if (!wait)
+		return atmel_sha204a_rng_read_nonblocking(rng, data, max);
+
+	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
+
+	atmel_i2c_init_random_cmd(&cmd);
+
+	ret = atmel_i2c_send_receive(i2c_priv->client, &cmd);
+	if (ret)
+		return ret;
+
+	max = min(sizeof(cmd.data), max);
+	memcpy(data, cmd.data, max);
+
+	return max;
+}
+
+static int atmel_sha204a_probe(struct i2c_client *client,
+			       const struct i2c_device_id *id)
+{
+	struct atmel_i2c_client_priv *i2c_priv;
+	int ret;
+
+	ret = atmel_i2c_probe(client, id);
+	if (ret)
+		return ret;
+
+	i2c_priv = i2c_get_clientdata(client);
+
+	memset(&i2c_priv->hwrng, 0, sizeof(i2c_priv->hwrng));
+
+	i2c_priv->hwrng.name = dev_name(&client->dev);
+	i2c_priv->hwrng.read = atmel_sha204a_rng_read;
+	i2c_priv->hwrng.quality = 1024;
+
+	ret = hwrng_register(&i2c_priv->hwrng);
+	if (ret)
+		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
+
+	return ret;
+}
+
+static int atmel_sha204a_remove(struct i2c_client *client)
+{
+	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
+
+	if (atomic_read(&i2c_priv->tfm_count)) {
+		dev_err(&client->dev, "Device is busy\n");
+		return -EBUSY;
+	}
+
+	if (i2c_priv->hwrng.priv)
+		kfree((void *)i2c_priv->hwrng.priv);
+	hwrng_unregister(&i2c_priv->hwrng);
+
+	return 0;
+}
+
+static const struct of_device_id atmel_sha204a_dt_ids[] = {
+	{ .compatible = "atmel,atsha204a", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
+
+static const struct i2c_device_id atmel_sha204a_id[] = {
+	{ "atsha204a", 0 },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);
+
+static struct i2c_driver atmel_sha204a_driver = {
+	.probe			= atmel_sha204a_probe,
+	.remove			= atmel_sha204a_remove,
+	.id_table		= atmel_sha204a_id,
+
+	.driver.name		= "atmel-sha204a",
+	.driver.of_match_table	= of_match_ptr(atmel_sha204a_dt_ids),
+};
+
+static int __init atmel_sha204a_init(void)
+{
+	return i2c_add_driver(&atmel_sha204a_driver);
+}
+
+static void __exit atmel_sha204a_exit(void)
+{
+	flush_scheduled_work();
+	i2c_del_driver(&atmel_sha204a_driver);
+}
+
+module_init(atmel_sha204a_init);
+module_exit(atmel_sha204a_exit);
+
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
-- 
2.20.1

