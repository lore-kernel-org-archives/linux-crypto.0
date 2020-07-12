Return-Path: <SRS0=9w58=AX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBB3C433E5
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 22:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0930F20672
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 22:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgGLWF7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jul 2020 18:05:59 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48372 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbgGLWF7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jul 2020 18:05:59 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DB8B41A0B1D;
        Mon, 13 Jul 2020 00:05:54 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CD5B41A0D0D;
        Mon, 13 Jul 2020 00:05:54 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6E95E204BE;
        Mon, 13 Jul 2020 00:05:54 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 1/2] crypto: caam - add tag object functionality
Date:   Mon, 13 Jul 2020 01:05:35 +0300
Message-Id: <1594591536-531-2-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A tag object represents the metadata (or simply a header/configuration)
and the actual data (e.g. black key) obtained from hardware.
Add functionality to tag an object with metadata:
- validate metadata: check tag object header;
- retrieve metadata: get tag object header configuration, black key
configuration or tag object data.

This API expects that the object (the actual data) from a tag object
to be a buffer (defined by address and size).

Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/Kconfig      |   9 +++
 drivers/crypto/caam/Makefile     |   1 +
 drivers/crypto/caam/desc.h       |   4 +-
 drivers/crypto/caam/tag_object.c | 129 +++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/tag_object.h |  99 ++++++++++++++++++++++++++++++
 5 files changed, 241 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/caam/tag_object.c
 create mode 100644 drivers/crypto/caam/tag_object.h

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index bc35aa0..73368d8 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -149,6 +149,15 @@ config CRYPTO_DEV_FSL_CAAM_RNG_API
 	  Selecting this will register the SEC4 hardware rng to
 	  the hw_random API for supplying the kernel entropy pool.
 
+config CRYPTO_DEV_FSL_CAAM_TK_API
+	bool "Register tagged key cryptography implementations with Crypto API"
+	depends on CRYPTO_DEV_FSL_CAAM_CRYPTO_API
+	help
+	  Selecting this will register algorithms supporting tagged key.
+
+	  Tagged keys are keys that contain metadata indicating what
+	  they are and how to handle them.
+
 endif # CRYPTO_DEV_FSL_CAAM_JR
 
 endif # CRYPTO_DEV_FSL_CAAM
diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 68d5cc0..192a88e 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC) += caamhash_desc.o
 
 caam-y := ctrl.o
 caam_jr-y := jr.o key_gen.o
+caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API) += tag_object.o
 caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
 caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += caamalg_qi.o
 caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API) += caamhash.o
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index e134709..3001a8d 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -152,7 +152,7 @@
  * with the TDKEK if TK is set
  */
 #define KEY_ENC			0x00400000
-
+#define KEY_ENC_OFFSET		22
 /*
  * No Write Back - Do not allow key to be FIFO STOREd
  */
@@ -162,11 +162,13 @@
  * Enhanced Encryption of Key
  */
 #define KEY_EKT			0x00100000
+#define KEY_EKT_OFFSET		20
 
 /*
  * Encrypted with Trusted Key
  */
 #define KEY_TK			0x00008000
+#define KEY_TK_OFFSET		15
 
 /*
  * KDEST - Key Destination: 0 - class key register,
diff --git a/drivers/crypto/caam/tag_object.c b/drivers/crypto/caam/tag_object.c
new file mode 100644
index 00000000..55f41e9
--- /dev/null
+++ b/drivers/crypto/caam/tag_object.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/*
+ * Copyright 2018-2020 NXP
+ */
+
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+
+#include "tag_object.h"
+#include "desc.h"
+
+/**
+ * is_black_key -	Check if the tag object header is a black key
+ * @header:		The tag object header configuration
+ *
+ * Return:		True if is a black key, false otherwise
+ */
+bool is_black_key(const struct header_conf *header)
+{
+	u32 type = header->type;
+	/* Check type and color bitfields from tag object type */
+	return (type & (BIT(TAG_OBJ_COLOR_OFFSET) |
+			BIT(TAG_OBJ_TYPE_OFFSET))) == BIT(TAG_OBJ_COLOR_OFFSET);
+}
+EXPORT_SYMBOL(is_black_key);
+
+/**
+ * is_valid_header_conf - Check if the header configuration is valid
+ * @header:		The header configuration
+ *
+ * Return:		True if the header of the tag object configuration,
+ *			has the TAG_OBJECT_MAGIC number and a valid type,
+ *			false otherwise
+ */
+bool is_valid_header_conf(const struct header_conf *header)
+{
+	return (header->_magic_number == TAG_OBJECT_MAGIC);
+}
+
+/**
+ * get_tag_object_header_conf - Retrieve the address of tag object
+ *				header configuration
+ * @buffer:			Buffer containing the tag object
+ * @size:			The size of buffer
+ * @header:			Returned tag object header configuration
+ *
+ * Return:			'0' on success, error code otherwise
+ */
+int get_tag_object_header_conf(const void *buffer, size_t size,
+			       struct header_conf **header)
+{
+	bool valid;
+
+	/* Retrieve the tag object */
+	struct tagged_object *tag_obj = (struct tagged_object *)buffer;
+
+	/* Check if one can retrieve the tag object header configuration */
+	if (size < TAG_OVERHEAD_SIZE)
+		return -EINVAL;
+
+	/* Check tag object header configuration */
+	valid = is_valid_header_conf(&tag_obj->header);
+
+	/* Retrieve the tag object header configuration address */
+	*header = &tag_obj->header;
+
+	return valid ? 0 : -EINVAL;
+}
+EXPORT_SYMBOL(get_tag_object_header_conf);
+
+/**
+ * get_key_conf -	Retrieve the key configuration,
+ *			meaning the length of the black key and
+ *			the KEY command parameters needed for CAAM
+ * @header:		The tag object header configuration
+ * @real_len:		Key length
+ * @load_param:		Load parameters for KEY command:
+ *			- indicator for encrypted keys: plaintext or black
+ *			- indicator for encryption mode: AES-ECB or AES-CCM
+ *			- indicator for encryption keys: JDKEK or TDKEK
+ */
+void get_key_conf(const struct header_conf *header,
+		  u32 *real_len, u32 *load_param)
+{
+	*real_len = header->real_len;
+	/* Based on the color of the key, set key encryption bit (ENC) */
+	*load_param = ((header->type >> TAG_OBJ_COLOR_OFFSET) &
+		       TAG_OBJ_COLOR_MASK) << KEY_ENC_OFFSET;
+	/*
+	 * For red keys, the TK and EKT bits are ignored.
+	 * So we set them anyway, to be valid when the key is black.
+	 */
+	*load_param |= ((header->type >> TAG_OBJ_TK_OFFSET) &
+			 TAG_OBJ_TK_MASK) << KEY_TK_OFFSET;
+	*load_param |= ((header->type >> TAG_OBJ_EKT_OFFSET) &
+			 TAG_OBJ_EKT_MASK) << KEY_EKT_OFFSET;
+}
+EXPORT_SYMBOL(get_key_conf);
+
+/**
+ * get_tagged_data -	Retrieve the address of the data and size
+ *			of the tagged object
+ * @tagged_object:		Pointer to tag object
+ * @tagged_object_size:		The tagged object size
+ * @data:			Returned the address of the data from
+ *				the tagged object
+ * @data_size:			Returned the size of the data from the
+ *				tagged object
+ *
+ * Return:			'0' on success, error code otherwise
+ */
+int get_tagged_data(const void *tagged_object, size_t tagged_object_size,
+		    const void **data, u32 *data_size)
+{
+	/* Retrieve the tag object */
+	struct tagged_object *tag_obj = (struct tagged_object *)tagged_object;
+	/* Check if one can retrieve the data from the tagged object */
+	if (tagged_object_size < TAG_OVERHEAD_SIZE)
+		return -EINVAL;
+
+	/* Retrieve the address of the data/object from the tagged object */
+	*data = &tag_obj->object;
+	/* Retrieve the size of the data from the tagged object */
+	*data_size = tagged_object_size - TAG_OVERHEAD_SIZE;
+
+	return 0;
+}
+EXPORT_SYMBOL(get_tagged_data);
diff --git a/drivers/crypto/caam/tag_object.h b/drivers/crypto/caam/tag_object.h
new file mode 100644
index 00000000..9950c02
--- /dev/null
+++ b/drivers/crypto/caam/tag_object.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/*
+ * Copyright 2018-2020 NXP
+ */
+
+#ifndef _TAG_OBJECT_H_
+#define _TAG_OBJECT_H_
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+
+/**
+ * Magic number to identify the tag object structure
+ * 0x54 = 'T'
+ * 0x61 = 'a'
+ * 0x67 = 'g'
+ * 0x4f = 'O'
+ */
+#define TAG_OBJECT_MAGIC	0x5461674f
+#define TAG_MIN_SIZE		(2 * sizeof(struct header_conf))
+#define TAG_OVERHEAD_SIZE	sizeof(struct header_conf)
+
+/*
+ * Tag object type is a bitfield:
+ *
+ * EKT:	Encrypted Key Type (AES-ECB or AES-CCM)
+ * TK:	Trusted Key (use Job Descriptor Key Encryption Key (JDKEK)
+ *	or Trusted Descriptor Key Encryption Key (TDKEK) to
+ *	decrypt the key to be loaded into a Key Register).
+ *
+ *| Denomination | Security state | Memory  | EKT | TK    | Type | Color |
+ *| ------------ | -------------- | ------- | --- | ----- | ---- | ----- |
+ *| bit(s)       | 5-6            | 4       | 3   | 2     | 1    | 0     |
+ *| option 0     | non-secure     | general | ECB | JDKEK | key  | red   |
+ *| option 1     | secure         | secure  | CCM | TDKEK | blob | black |
+ *| option 2     | trusted        |         |     |       |      |       |
+ *
+ * CAAM supports two different Black Key encapsulation schemes,
+ * one intended for quick decryption (uses AES-ECB encryption),
+ * and another intended for high assurance (uses AES-CCM encryption).
+ *
+ * CAAM implements both Trusted and normal (non-Trusted) Black Keys,
+ * which are encrypted with different key-encryption keys.
+ * Both Trusted and normal Descriptors are allowed to encrypt or decrypt
+ * normal Black Keys, but only Trusted Descriptors are allowed to
+ * encrypt or decrypt Trusted Black Keys.
+ */
+#define TAG_OBJ_COLOR_OFFSET		0
+#define TAG_OBJ_COLOR_MASK		0x1
+#define TAG_OBJ_TYPE_OFFSET		1
+#define TAG_OBJ_TK_OFFSET		2
+#define TAG_OBJ_TK_MASK			0x1
+#define TAG_OBJ_EKT_OFFSET		3
+#define TAG_OBJ_EKT_MASK		0x1
+#define TAG_OBJ_MEM_OFFSET		4
+#define TAG_OBJ_SEC_STATE_OFFSET	5
+
+/**
+ * struct header_conf - Header configuration structure, which represents
+ *			the metadata (or simply a header) applied to the
+ *			actual data (e.g. black key)
+ * @_magic_number     : A magic number to identify the structure
+ * @version           : The version of the data contained (e.g. tag object)
+ * @type              : The type of data contained (e.g. black key, blob, etc.)
+ * @real_len          : Length of the object to be loaded by CAAM
+ */
+struct header_conf {
+	u32 _magic_number;
+	u32 version;
+	u32 type;
+	u32 real_len;
+};
+
+/**
+ * struct tagged_object - Tag object structure, which represents the metadata
+ *                        (or simply a header) and the actual data
+ *                        (e.g. black key) obtained from hardware
+ * @tag                 : The configuration of the data (e.g. header)
+ * @object              : The actual data (e.g. black key)
+ */
+struct tagged_object {
+	struct header_conf header;
+	char object;
+};
+
+bool is_black_key(const struct header_conf * const header);
+
+bool is_valid_header_conf(const struct header_conf *header);
+
+int get_tag_object_header_conf(const void *buffer, size_t buffer_size,
+			       struct header_conf **header);
+
+void get_key_conf(const struct header_conf *header,
+		  u32 *real_len, u32 *load_param);
+
+int get_tagged_data(const void *buffer, size_t buffer_size,
+		    const void **data, u32 *data_size);
+
+#endif /* _TAG_OBJECT_H_ */
-- 
2.1.0

