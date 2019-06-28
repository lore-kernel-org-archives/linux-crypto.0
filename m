Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129A3C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B69B820659
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="a99iszDj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfF1E1o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 00:27:44 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:58824 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfF1E1l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 00:27:41 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RUoR020827;
        Thu, 27 Jun 2019 23:27:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561696050;
        bh=FehHwOOdVMctdOago5xa8n5T2ZOnQCMHDR1SFCGPe6U=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=a99iszDjM67s5LcpsnEV5HQzZGo2Awhb7LASw1uJ5Eklo22iBhlFYBYUnCLDjCR/h
         WOwkFLWU1GSTesWhbD8CV530riWCrDTvITmMjGwBwP+/yspQRQAhr80dm4sDkA0pl5
         NKDHDbjAjz4WWqGQjYalGTujg0wZIUccrkAN7oNQ=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S4RUYK021516
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Jun 2019 23:27:30 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 27
 Jun 2019 23:27:29 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 27 Jun 2019 23:27:29 -0500
Received: from a0393675ula.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RKPM062595;
        Thu, 27 Jun 2019 23:27:27 -0500
From:   Keerthy <j-keerthy@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <j-keerthy@ti.com>, <linux-crypto@vger.kernel.org>, <nm@ti.com>
Subject: [RESEND PATCH 02/10] crypto: sa2ul: Add crypto driver
Date:   Fri, 28 Jun 2019 09:57:37 +0530
Message-ID: <20190628042745.28455-3-j-keerthy@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628042745.28455-1-j-keerthy@ti.com>
References: <20190628042745.28455-1-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Security Accelerator (SA2_UL) subsystem provides hardware
cryptographic acceleration for the following use cases:
• Encryption and authentication for secure boot
• Encryption and authentication of content in applications
  requiring DRM (digital rights management) and
  content/asset protection
The device includes one instantiation of SA2_UL named SA2_UL0

SA2_UL supports the following cryptographic industry standards to enable data authentication, data
integrity and data confidentiality.

Crypto function library for software acceleration
o AES operation
o 3DES operation
o SHA1 operation
o MD5 operation
o SHA2 – 224, 256, 384, 512 operation

Authentication supported via following hardware cores
o SHA1
o MD5
o SHA2 -224
o SHA2-256
o SHA2-384
o SHA2-512

Patch adds a basic crypto driver and currently supports AES
in cbc mode for both encryption and decryption.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/crypto/Kconfig  |   17 +
 drivers/crypto/Makefile |    1 +
 drivers/crypto/sa2ul.c  | 1151 +++++++++++++++++++++++++++++++++++++++
 drivers/crypto/sa2ul.h  |  384 +++++++++++++
 4 files changed, 1553 insertions(+)
 create mode 100644 drivers/crypto/sa2ul.c
 create mode 100644 drivers/crypto/sa2ul.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 603413f28fa3..b9a3fa026c74 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -785,4 +785,21 @@ config CRYPTO_DEV_CCREE
 
 source "drivers/crypto/hisilicon/Kconfig"
 
+config CRYPTO_DEV_SA2UL
+	tristate "Support for TI security accelerator"
+	depends on ARCH_K3 || COMPILE_TEST
+	select ARM64_CRYPTO
+	select CRYPTO_AES
+	select CRYPTO_AES_ARM64
+	select CRYPTO_SHA1
+	select CRYPTO_MD5
+	select CRYPTO_ALGAPI
+	select CRYPTO_AUTHENC
+	select HW_RANDOM
+	default m if ARCH_K3
+	help
+	  Keystone devices include a security accelerator engine that may be
+	  used for crypto offload.  Select this if you want to use hardware
+	  acceleration for cryptographic algorithms on these devices.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index afc4753b5d28..300d31fd24db 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -47,4 +47,5 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
+obj-$(CONFIG_CRYPTO_DEV_SA2UL) += sa2ul.o
 obj-y += hisilicon/
diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
new file mode 100644
index 000000000000..64bdf6b2b879
--- /dev/null
+++ b/drivers/crypto/sa2ul.c
@@ -0,0 +1,1151 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AM6 SA2UL crypto accelerator driver
+ *
+ * Copyright (C) 2018 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Authors:	Keerthy
+ *              Vitaly Andrianov
+ */
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/dmapool.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/dmaengine.h>
+#include <linux/cryptohash.h>
+#include <linux/mod_devicetable.h>
+
+#include <crypto/authenc.h>
+#include <crypto/des.h>
+#include <crypto/internal/aead.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
+
+#include "sa2ul.h"
+
+/* Byte offset for key in encryption security context */
+#define SC_ENC_KEY_OFFSET (1 + 27 + 4)
+/* Byte offset for Aux-1 in encryption security context */
+#define SC_ENC_AUX1_OFFSET (1 + 27 + 4 + 32)
+
+#define SA_CMDL_UPD_ENC         0x0001
+#define SA_CMDL_UPD_AUTH        0x0002
+#define SA_CMDL_UPD_ENC_IV      0x0004
+#define SA_CMDL_UPD_AUTH_IV     0x0008
+#define SA_CMDL_UPD_AUX_KEY     0x0010
+
+#define SA_AUTH_SUBKEY_LEN	16
+#define SA_CMDL_PAYLOAD_LENGTH_MASK	0xFFFF
+#define SA_CMDL_SOP_BYPASS_LEN_MASK	0xFF000000
+
+#define MODE_CONTROL_BYTES	27
+#define SA_HASH_PROCESSING	0
+#define SA_CRYPTO_PROCESSING	0
+#define SA_UPLOAD_HASH_TO_TLR	BIT(6)
+
+#define SA_SW0_FLAGS_MASK	0xF0000
+#define SA_SW0_CMDL_INFO_MASK	0x1F00000
+#define SA_SW0_CMDL_PRESENT	BIT(4)
+#define SA_SW0_ENG_ID_MASK	0x3E000000
+#define SA_SW0_DEST_INFO_PRESENT	BIT(30)
+#define SA_SW2_EGRESS_LENGTH		0xFF000000
+
+#define SHA256_DIGEST_WORDS    8
+/* Make 32-bit word from 4 bytes */
+#define SA_MK_U32(b0, b1, b2, b3) (((b0) << 24) | ((b1) << 16) | \
+				   ((b2) << 8) | (b3))
+
+/* size of SCCTL structure in bytes */
+#define SA_SCCTL_SZ 16
+
+/* Max Authentication tag size */
+#define SA_MAX_AUTH_TAG_SZ 64
+
+#define PRIV_ID	0x1
+#define PRIV	0x1
+
+static struct device *sa_k3_dev;
+
+/**
+ * struct sa_cmdl_cfg - Command label configuration descriptor
+ * @enc1st: If the iteration needs encryption before authentication
+ * @aalg: authentication algorithm ID
+ * @enc_eng_id: Encryption Engine ID supported by the SA hardware
+ * @auth_eng_id: authentication Engine ID
+ * @iv_size: Initialization Vector size
+ * @akey: Authentication key
+ * @akey_len: Authentication key length
+ */
+struct sa_cmdl_cfg {
+	int enc1st;
+	int aalg;
+	u8 enc_eng_id;
+	u8 auth_eng_id;
+	u8 iv_size;
+	const u8 *akey;
+	u16 akey_len;
+	u16 auth_subkey_len;
+};
+
+/**
+ * struct algo_data - Crypto algorithm specific data
+ * @enc_eng: Encryption engine info structure
+ * @auth_eng: Authentication engine info structure
+ * @auth_ctrl: Authentication control word
+ * @hash_size: Size of Digest
+ * @ealg_id: Encryption Algorithm ID
+ * @aalg_id: Authentication algorithm ID
+ * @mci_enc: Mode Control Instruction for Encryption algorithm
+ * @mci_dec: Mode Control Instruction for Decryption
+ * @inv_key: Whether the encryption algorithm demands key inversion
+ * @keyed_mac: Whether the Authentication algorithm has Key
+ * @prep_iopad: Function pointer to generate intermediate ipad/opad
+ */
+struct algo_data {
+	struct sa_eng_info enc_eng;
+	struct sa_eng_info auth_eng;
+	u8 auth_ctrl;
+	u8 hash_size;
+	u8 ealg_id;
+	u8 aalg_id;
+	u8 *mci_enc;
+	u8 *mci_dec;
+	bool inv_key;
+	bool keyed_mac;
+	void (*prep_iopad)(const u8 *key, u16 key_sz, u32 *ipad, u32 *opad);
+};
+
+/**
+ * struct sa_alg_tmpl: A generic template encompassing crypto/aead algorithms
+ * @alg: A union of aead/crypto algorithm type.
+ * @registered: Flag indicating if the crypto algorithm is already registered
+ */
+struct sa_alg_tmpl {
+	u32 type;		/* CRYPTO_ALG_TYPE from <linux/crypto.h> */
+	union {
+		struct crypto_alg crypto;
+		struct aead_alg aead;
+	} alg;
+	int registered;
+};
+
+/**
+ * struct sa_rx_data: RX Packet miscellaneous data place holder
+ * @req: crypto request data pointer
+ * @ddev: DMA device pointer
+ * @tx_in: dma_async_tx_descriptor pointer for rx channel
+ * @enc: Flag indicating either encryption or decryption
+ */
+struct sa_rx_data {
+	void *req;
+	struct device *ddev;
+	struct dma_async_tx_descriptor *tx_in;
+	u8 enc;
+};
+
+/*
+ * Mode Control Instructions for various Key lengths 128, 192, 256
+ * For CBC (Cipher Block Chaining) mode for encryption
+ */
+static u8 mci_cbc_enc_array[3][MODE_CONTROL_BYTES] = {
+	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x0a, 0xaa, 0x4b, 0x7e, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x4a, 0xaa, 0x4b, 0x7e, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x8a, 0xaa, 0x4b, 0x7e, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+};
+
+/*
+ * Mode Control Instructions for various Key lengths 128, 192, 256
+ * For CBC (Cipher Block Chaining) mode for decryption
+ */
+static u8 mci_cbc_dec_array[3][MODE_CONTROL_BYTES] = {
+	{	0x31, 0x00, 0x00, 0x80, 0x8a, 0xca, 0x98, 0xf4, 0x40, 0xc0,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+	{	0x31, 0x00, 0x00, 0x84, 0x8a, 0xca, 0x98, 0xf4, 0x40, 0xc0,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+	{	0x31, 0x00, 0x00, 0x88, 0x8a, 0xca, 0x98, 0xf4, 0x40, 0xc0,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+};
+
+/*
+ * Perform 16 byte or 128 bit swizzling
+ * The SA2UL Expects the security context to
+ * be in little Endian and the bus width is 128 bits or 16 bytes
+ * Hence swap 16 bytes at a time from higher to lower address
+ */
+static void sa_swiz_128(u8 *in, u16 len)
+{
+	u8 data[16];
+	int i, j;
+
+	for (i = 0; i < len; i += 16) {
+		memcpy(data, &in[i], 16);
+		for (j = 0; j < 16; j++)
+			in[i + j] = data[15 - j];
+	}
+}
+
+/* Derive the inverse key used in AES-CBC decryption operation */
+static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz)
+{
+	struct crypto_aes_ctx ctx;
+	int key_pos;
+
+	if (crypto_aes_expand_key(&ctx, key, key_sz)) {
+		pr_err("%s: bad key len(%d)\n", __func__, key_sz);
+		return -EINVAL;
+	}
+
+	/* Based crypto_aes_expand_key logic */
+	switch (key_sz) {
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+		key_pos = key_sz + 24;
+		break;
+
+	case AES_KEYSIZE_256:
+		key_pos = key_sz + 24 - 4;
+		break;
+
+	default:
+		pr_err("%s: bad key len(%d)\n", __func__, key_sz);
+		return -EINVAL;
+	}
+
+	memcpy(inv_key, &ctx.key_enc[key_pos], key_sz);
+	return 0;
+}
+
+/* Set Security context for the encryption engine */
+static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
+			 u16 aad_len, u8 enc, u8 *sc_buf)
+{
+	const u8 *mci = NULL;
+
+	/* Set Encryption mode selector to crypto processing */
+	sc_buf[0] = SA_CRYPTO_PROCESSING;
+
+	if (enc)
+		mci = ad->mci_enc;
+	else
+		mci = ad->mci_dec;
+	/* Set the mode control instructions in security context */
+	if (mci)
+		memcpy(&sc_buf[1], mci, MODE_CONTROL_BYTES);
+
+	/* For AES-CBC decryption get the inverse key */
+	if (ad->inv_key && !enc) {
+		if (sa_aes_inv_key(&sc_buf[SC_ENC_KEY_OFFSET], key, key_sz))
+			return -EINVAL;
+	/* For all other cases: key is used */
+	} else {
+		memcpy(&sc_buf[SC_ENC_KEY_OFFSET], key, key_sz);
+	}
+
+	return 0;
+}
+
+/* Set Security context for the authentication engine */
+static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
+			   u8 *sc_buf)
+{
+	u32 ipad[64], opad[64];
+
+	/* Set Authentication mode selector to hash processing */
+	sc_buf[0] = SA_HASH_PROCESSING;
+	/* Auth SW ctrl word: bit[6]=1 (upload computed hash to TLR section) */
+	sc_buf[1] = SA_UPLOAD_HASH_TO_TLR;
+	sc_buf[1] |= ad->auth_ctrl;
+
+	/* Copy the keys or ipad/opad */
+	if (ad->keyed_mac) {
+		ad->prep_iopad(key, key_sz, ipad, opad);
+		/* Copy ipad to AuthKey */
+		memcpy(&sc_buf[32], ipad, ad->hash_size);
+		/* Copy opad to Aux-1 */
+		memcpy(&sc_buf[64], opad, ad->hash_size);
+	}
+}
+
+static inline void sa_copy_iv(u32 *out, const u8 *iv, bool size16)
+{
+	int j;
+
+	for (j = 0; j < ((size16) ? 4 : 2); j++) {
+		*out = cpu_to_be32(*((u32 *)iv));
+		iv += 4;
+		out++;
+	}
+}
+
+/* Format general command label */
+static int sa_format_cmdl_gen(struct sa_cmdl_cfg *cfg, u8 *cmdl,
+			      struct sa_cmdl_upd_info *upd_info)
+{
+	u8 enc_offset = 0, auth_offset = 0, total = 0;
+	u8 enc_next_eng = SA_ENG_ID_OUTPORT2;
+	u8 auth_next_eng = SA_ENG_ID_OUTPORT2;
+	u32 *word_ptr = (u32 *)cmdl;
+	int i;
+
+	/* Clear the command label */
+	memzero_explicit(cmdl, (SA_MAX_CMDL_WORDS * sizeof(u32)));
+
+	/* Iniialize the command update structure */
+	memzero_explicit(upd_info, sizeof(*upd_info));
+
+	if (cfg->enc1st) {
+		if (cfg->enc_eng_id != SA_ENG_ID_NONE)
+			auth_offset = SA_CMDL_HEADER_SIZE_BYTES;
+
+		if (cfg->iv_size)
+			auth_offset += cfg->iv_size;
+
+		if (cfg->auth_eng_id != SA_ENG_ID_NONE)
+			enc_next_eng = cfg->auth_eng_id;
+		else
+			enc_next_eng = SA_ENG_ID_OUTPORT2;
+	} else {
+		if (cfg->auth_eng_id != SA_ENG_ID_NONE)
+			enc_offset = SA_CMDL_HEADER_SIZE_BYTES;
+
+		if (cfg->auth_subkey_len)
+			enc_offset += cfg->auth_subkey_len;
+
+		if (cfg->enc_eng_id != SA_ENG_ID_NONE)
+			auth_next_eng = cfg->enc_eng_id;
+		else
+			auth_next_eng = SA_ENG_ID_OUTPORT2;
+	}
+
+	if (cfg->enc_eng_id != SA_ENG_ID_NONE) {
+		upd_info->flags |= SA_CMDL_UPD_ENC;
+		upd_info->enc_size.index = enc_offset >> 2;
+		upd_info->enc_offset.index = upd_info->enc_size.index + 1;
+		/* Encryption command label */
+		cmdl[enc_offset + SA_CMDL_OFFSET_NESC] = enc_next_eng;
+
+		/* Encryption modes requiring IV */
+		if (cfg->iv_size) {
+			upd_info->flags |= SA_CMDL_UPD_ENC_IV;
+			upd_info->enc_iv.index =
+				(enc_offset + SA_CMDL_HEADER_SIZE_BYTES) >> 2;
+			upd_info->enc_iv.size = cfg->iv_size;
+
+			cmdl[enc_offset + SA_CMDL_OFFSET_LABEL_LEN] =
+				SA_CMDL_HEADER_SIZE_BYTES + cfg->iv_size;
+
+			cmdl[enc_offset + SA_CMDL_OFFSET_OPTION_CTRL1] =
+				(SA_CTX_ENC_AUX2_OFFSET | (cfg->iv_size >> 3));
+			enc_offset += SA_CMDL_HEADER_SIZE_BYTES + cfg->iv_size;
+		} else {
+			cmdl[enc_offset + SA_CMDL_OFFSET_LABEL_LEN] =
+						SA_CMDL_HEADER_SIZE_BYTES;
+			enc_offset += SA_CMDL_HEADER_SIZE_BYTES;
+		}
+	}
+
+	if (cfg->auth_eng_id != SA_ENG_ID_NONE) {
+		upd_info->flags |= SA_CMDL_UPD_AUTH;
+		upd_info->auth_size.index = auth_offset >> 2;
+		upd_info->auth_offset.index = upd_info->auth_size.index + 1;
+		cmdl[auth_offset + SA_CMDL_OFFSET_NESC] = auth_next_eng;
+
+		/* Algorithm with subkeys */
+		if (cfg->aalg == SA_AALG_ID_AES_XCBC ||
+		    cfg->aalg == SA_AALG_ID_CMAC) {
+			upd_info->flags |= SA_CMDL_UPD_AUX_KEY;
+			upd_info->aux_key_info.index =
+				(auth_offset + SA_CMDL_HEADER_SIZE_BYTES) >> 2;
+			cmdl[auth_offset + SA_CMDL_OFFSET_LABEL_LEN] =
+						SA_CMDL_HEADER_SIZE_BYTES +
+							cfg->auth_subkey_len;
+			cmdl[auth_offset + SA_CMDL_OFFSET_OPTION_CTRL1] =
+						(SA_CTX_ENC_AUX1_OFFSET |
+						(cfg->auth_subkey_len  >> 3));
+
+			auth_offset += SA_CMDL_HEADER_SIZE_BYTES +
+							cfg->auth_subkey_len;
+		} else {
+			cmdl[auth_offset + SA_CMDL_OFFSET_LABEL_LEN] =
+						SA_CMDL_HEADER_SIZE_BYTES;
+			auth_offset += SA_CMDL_HEADER_SIZE_BYTES;
+		}
+	}
+
+	if (cfg->enc1st)
+		total = auth_offset;
+	else
+		total = enc_offset;
+
+	total = roundup(total, 8);
+
+	for (i = 0; i < total / 4; i++)
+		word_ptr[i] = be32_to_cpu(word_ptr[i]);
+
+	return total;
+}
+
+/* Update Command label */
+static inline void
+sa_update_cmdl(struct device *dev, u8 enc_offset, u16 enc_size, u8 *enc_iv,
+	       u8 auth_offset, u16 auth_size, u8 *auth_iv, u8 aad_size,
+	       u8 *aad, struct sa_cmdl_upd_info *upd_info, u32 *cmdl)
+{
+	int i = 0, j;
+
+	if (upd_info->submode != SA_MODE_GEN) {
+		dev_err(dev, "unsupported mode(%d)\n", upd_info->submode);
+		return;
+	}
+
+	if (likely(upd_info->flags & SA_CMDL_UPD_ENC)) {
+		cmdl[upd_info->enc_size.index] &= ~SA_CMDL_PAYLOAD_LENGTH_MASK;
+		cmdl[upd_info->enc_size.index] |= enc_size;
+		cmdl[upd_info->enc_offset.index] &=
+						~SA_CMDL_SOP_BYPASS_LEN_MASK;
+		cmdl[upd_info->enc_offset.index] |=
+			((u32)enc_offset << __ffs(SA_CMDL_SOP_BYPASS_LEN_MASK));
+
+		if (likely(upd_info->flags & SA_CMDL_UPD_ENC_IV)) {
+			u32 *data = &cmdl[upd_info->enc_iv.index];
+
+			for (j = 0; i < upd_info->enc_iv.size; i += 4, j++) {
+				data[j] = cpu_to_be32(*((u32 *)enc_iv));
+				enc_iv += 4;
+			}
+		}
+	}
+
+	if (likely(upd_info->flags & SA_CMDL_UPD_AUTH)) {
+		cmdl[upd_info->auth_size.index] &= ~SA_CMDL_PAYLOAD_LENGTH_MASK;
+		cmdl[upd_info->auth_size.index] |= auth_size;
+		cmdl[upd_info->auth_offset.index] &=
+						~SA_CMDL_SOP_BYPASS_LEN_MASK;
+		cmdl[upd_info->auth_offset.index] |= ((u32)auth_offset <<
+					__ffs(SA_CMDL_SOP_BYPASS_LEN_MASK));
+		if (upd_info->flags & SA_CMDL_UPD_AUTH_IV) {
+			sa_copy_iv(&cmdl[upd_info->auth_iv.index], auth_iv,
+				   (upd_info->auth_iv.size > 8));
+		}
+
+		if (upd_info->flags & SA_CMDL_UPD_AUX_KEY) {
+			int offset = (auth_size & 0xF) ? 4 : 0;
+
+			memcpy(&cmdl[upd_info->aux_key_info.index],
+			       &upd_info->aux_key[offset], 16);
+		}
+	}
+}
+
+/* Format SWINFO words to be sent to SA */
+static
+void sa_set_swinfo(u8 eng_id, u16 sc_id, dma_addr_t sc_phys,
+		   u8 cmdl_present, u8 cmdl_offset, u8 flags,
+		   u8 hash_size, u32 *swinfo)
+{
+	swinfo[0] = sc_id;
+	swinfo[0] |= (flags << __ffs(SA_SW0_FLAGS_MASK));
+	if (likely(cmdl_present))
+		swinfo[0] |= ((cmdl_offset | SA_SW0_CMDL_PRESENT) <<
+						__ffs(SA_SW0_CMDL_INFO_MASK));
+	swinfo[0] |= (eng_id << __ffs(SA_SW0_ENG_ID_MASK));
+
+	swinfo[0] |= SA_SW0_DEST_INFO_PRESENT;
+	swinfo[1] = (u32)(sc_phys & 0xFFFFFFFFULL);
+	swinfo[2] = (u32)((sc_phys & 0xFFFFFFFF00000000ULL) >> 32);
+	swinfo[2] |= (hash_size << __ffs(SA_SW2_EGRESS_LENGTH));
+}
+
+/* Dump the security context */
+static void sa_dump_sc(u8 *buf, dma_addr_t dma_addr)
+{
+#ifdef DEBUG
+	dev_info(sa_k3_dev, "Security context dump:: 0x%pad\n", &dma_addr);
+	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
+		       16, 1, buf, SA_CTX_MAX_SZ, false);
+#endif
+}
+
+static
+int sa_init_sc(struct sa_ctx_info *ctx, const u8 *enc_key,
+	       u16 enc_key_sz, const u8 *auth_key, u16 auth_key_sz,
+	       struct algo_data *ad, u8 enc, u32 *swinfo, bool auth_req)
+{
+	int use_enc = 0;
+	int enc_sc_offset, auth_sc_offset;
+	u8 *sc_buf = ctx->sc;
+	u16 sc_id = ctx->sc_id;
+	u16 aad_len = 0;	/* Currently not supporting AEAD algo */
+	u8 first_engine;
+
+	memzero_explicit(sc_buf, SA_CTX_MAX_SZ);
+
+	if (ad->auth_eng.eng_id <= SA_ENG_ID_EM2 || !auth_req)
+		use_enc = 1;
+
+	/* Determine the order of encryption & Authentication contexts */
+	if (enc || !use_enc) {
+		if (auth_req) {
+			enc_sc_offset = SA_CTX_PHP_PE_CTX_SZ;
+			auth_sc_offset = enc_sc_offset + ad->enc_eng.sc_size;
+		} else {
+			enc_sc_offset = SA_CTX_PHP_PE_CTX_SZ;
+		}
+	} else {
+		auth_sc_offset = SA_CTX_PHP_PE_CTX_SZ;
+		enc_sc_offset = auth_sc_offset + ad->auth_eng.sc_size;
+	}
+
+	/* SCCTL Owner info: 0=host, 1=CP_ACE */
+	sc_buf[SA_CTX_SCCTL_OWNER_OFFSET] = 0;
+	/* SCCTL F/E control */
+	if (auth_req)
+		sc_buf[1] = SA_SCCTL_FE_AUTH_ENC;
+	else
+		sc_buf[1] = SA_SCCTL_FE_ENC;
+	memcpy(&sc_buf[2], &sc_id, 2);
+	sc_buf[4] = 0x0;
+	sc_buf[5] = PRIV_ID;
+	sc_buf[6] = PRIV;
+	sc_buf[7] = 0x0;
+
+	/* Initialize the rest of PHP context */
+	memzero_explicit(sc_buf + SA_SCCTL_SZ, SA_CTX_PHP_PE_CTX_SZ -
+			 SA_SCCTL_SZ);
+
+	/* Prepare context for encryption engine */
+	if (ad->enc_eng.sc_size) {
+		if (sa_set_sc_enc(ad, enc_key, enc_key_sz, aad_len,
+				  enc, &sc_buf[enc_sc_offset]))
+			return -EINVAL;
+	}
+
+	/* Prepare context for authentication engine */
+	if (ad->auth_eng.sc_size) {
+		if (use_enc) {
+			if (sa_set_sc_enc(ad, auth_key, auth_key_sz,
+					  aad_len, 0, &sc_buf[auth_sc_offset]))
+				return -EINVAL;
+		} else {
+			sa_set_sc_auth(ad, auth_key, auth_key_sz,
+				       &sc_buf[auth_sc_offset]);
+		}
+	}
+
+	/* Set the ownership of context to CP_ACE */
+	sc_buf[SA_CTX_SCCTL_OWNER_OFFSET] = 0x80;
+
+	/* swizzle the security context */
+	sa_swiz_128(sc_buf, SA_CTX_MAX_SZ);
+	/* Setup SWINFO */
+	if (!auth_req)
+		first_engine = ad->enc_eng.eng_id;
+	else
+		first_engine = enc ? ad->enc_eng.eng_id : ad->auth_eng.eng_id;
+
+	if (auth_req) {
+		if (!ad->hash_size)
+			return -EINVAL;
+		/* Round up the tag size to multiple of 4 */
+		ad->hash_size = roundup(ad->hash_size, 8);
+	}
+
+	sa_set_swinfo(first_engine, ctx->sc_id, ctx->sc_phys, 1, 0,
+		      SA_SW_INFO_FLAG_EVICT, ad->hash_size, swinfo);
+
+	sa_dump_sc(sc_buf, ctx->sc_phys);
+
+	return 0;
+}
+
+/* Free the per direction context memory */
+static void sa_free_ctx_info(struct sa_ctx_info *ctx,
+			     struct sa_crypto_data *data)
+{
+	unsigned long bn;
+
+	bn = ctx->sc_id - data->sc_id_start;
+	spin_lock(&data->scid_lock);
+	__clear_bit(bn, data->ctx_bm);
+	data->sc_id--;
+	spin_unlock(&data->scid_lock);
+
+	if (ctx->sc) {
+		dma_pool_free(data->sc_pool, ctx->sc, ctx->sc_phys);
+		ctx->sc = NULL;
+	}
+}
+
+static int sa_init_ctx_info(struct sa_ctx_info *ctx,
+			    struct sa_crypto_data *data)
+{
+	unsigned long bn;
+	int err;
+
+	spin_lock(&data->scid_lock);
+	bn = find_first_zero_bit(data->ctx_bm, SA_MAX_NUM_CTX);
+	__set_bit(bn, data->ctx_bm);
+	data->sc_id++;
+	spin_unlock(&data->scid_lock);
+
+	ctx->sc_id = (u16)(data->sc_id_start + bn);
+
+	ctx->sc = dma_pool_alloc(data->sc_pool, GFP_KERNEL, &ctx->sc_phys);
+	if (!ctx->sc) {
+		dev_err(&data->pdev->dev, "Failed to allocate SC memory\n");
+		err = -ENOMEM;
+		goto scid_rollback;
+	}
+
+	return 0;
+
+scid_rollback:
+	spin_lock(&data->scid_lock);
+	__clear_bit(bn, data->ctx_bm);
+	data->sc_id--;
+	spin_unlock(&data->scid_lock);
+
+	return err;
+}
+
+static void sa_aes_cra_exit(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
+
+	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
+		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
+		ctx->dec.sc_id, &ctx->dec.sc_phys);
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_ABLKCIPHER)
+	    == CRYPTO_ALG_TYPE_ABLKCIPHER) {
+		sa_free_ctx_info(&ctx->enc, data);
+		sa_free_ctx_info(&ctx->dec, data);
+	}
+}
+
+static int sa_aes_cra_init(struct crypto_tfm *tfm)
+{
+	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
+	int ret;
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_ABLKCIPHER) {
+		memzero_explicit(ctx, sizeof(*ctx));
+		ctx->dev_data = data;
+
+		ret = sa_init_ctx_info(&ctx->enc, data);
+		if (ret)
+			return ret;
+		ret = sa_init_ctx_info(&ctx->dec, data);
+		if (ret) {
+			sa_free_ctx_info(&ctx->enc, data);
+			return ret;
+		}
+	}
+
+	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
+		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
+		ctx->dec.sc_id, &ctx->dec.sc_phys);
+	return 0;
+}
+
+static int sa_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+			 unsigned int keylen, struct algo_data *ad)
+{
+	struct sa_tfm_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+
+	const char *cra_name;
+	int cmdl_len;
+	struct sa_cmdl_cfg cfg;
+
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 &&
+	    keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
+	cra_name = crypto_tfm_alg_name(&tfm->base);
+
+	memzero_explicit(&cfg, sizeof(cfg));
+	cfg.enc1st = 1;
+	cfg.enc_eng_id = ad->enc_eng.eng_id;
+	cfg.iv_size = crypto_ablkcipher_ivsize(tfm);
+	cfg.auth_eng_id = SA_ENG_ID_NONE;
+	cfg.auth_subkey_len = 0;
+
+	/* Setup Encryption Security Context & Command label template */
+	if (sa_init_sc(&ctx->enc, key, keylen,
+		       NULL, 0, ad, 1, &ctx->enc.epib[1], false))
+		goto badkey;
+
+	cmdl_len = sa_format_cmdl_gen(&cfg,
+				      (u8 *)ctx->enc.cmdl,
+				      &ctx->enc.cmdl_upd_info);
+	if (cmdl_len <= 0 || (cmdl_len > SA_MAX_CMDL_WORDS * sizeof(u32)))
+		goto badkey;
+
+	ctx->enc.cmdl_size = cmdl_len;
+
+	/* Setup Decryption Security Context & Command label template */
+	if (sa_init_sc(&ctx->dec, key, keylen,
+		       NULL, 0, ad, 0, &ctx->dec.epib[1], false))
+		goto badkey;
+
+	cfg.enc1st = 0;
+	cfg.enc_eng_id = ad->enc_eng.eng_id;
+	cfg.auth_eng_id = SA_ENG_ID_NONE;
+	cfg.auth_subkey_len = 0;
+	cmdl_len = sa_format_cmdl_gen(&cfg, (u8 *)ctx->dec.cmdl,
+				      &ctx->dec.cmdl_upd_info);
+
+	if (cmdl_len <= 0 || (cmdl_len > SA_MAX_CMDL_WORDS * sizeof(u32)))
+		goto badkey;
+
+	ctx->dec.cmdl_size = cmdl_len;
+
+	kfree(ad);
+
+	return 0;
+
+badkey:
+	dev_err(sa_k3_dev, "%s: badkey\n", __func__);
+	return -EINVAL;
+}
+
+static int sa_aes_cbc_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+			     unsigned int keylen)
+{
+	struct algo_data *ad = kzalloc(sizeof(*ad), GFP_KERNEL);
+	/* Convert the key size (16/24/32) to the key size index (0/1/2) */
+	int key_idx = (keylen >> 3) - 2;
+
+	ad->enc_eng.eng_id = SA_ENG_ID_EM1;
+	ad->enc_eng.sc_size = SA_CTX_ENC_TYPE1_SZ;
+	ad->auth_eng.eng_id = SA_ENG_ID_NONE;
+	ad->auth_eng.sc_size = 0;
+	ad->mci_enc = mci_cbc_enc_array[key_idx];
+	ad->mci_dec = mci_cbc_dec_array[key_idx];
+	ad->inv_key = true;
+	ad->ealg_id = SA_EALG_ID_AES_CBC;
+	ad->aalg_id = SA_AALG_ID_NONE;
+
+	return sa_aes_setkey(tfm, key, keylen, ad);
+}
+
+static void sa_aes_dma_in_callback(void *data)
+{
+	struct sa_rx_data *rxd = (struct sa_rx_data *)data;
+	struct ablkcipher_request *req = (struct ablkcipher_request *)rxd->req;
+
+	int sglen = sg_nents_for_len(req->dst, req->nbytes);
+
+	kfree(rxd);
+
+	dma_unmap_sg(sa_k3_dev, req->src, sglen, DMA_TO_DEVICE);
+	if (req->src != req->dst)
+		dma_unmap_sg(rxd->ddev, req->dst, sglen, DMA_FROM_DEVICE);
+
+	ablkcipher_request_complete(req, 0);
+}
+
+static void
+sa_prepare_tx_desc(u32 *mdptr, u32 pslen, u32 *psdata, u32 epiblen, u32 *epib)
+{
+	u32 *out, *in;
+	int i;
+
+	for (out = mdptr, in = epib, i = 0; i < epiblen / sizeof(u32); i++)
+		*out++ = *in++;
+
+	mdptr[4] = (0xFFFF << 16);
+	for (out = &mdptr[5], in = psdata, i = 0;
+	     i < pslen / sizeof(u32); i++)
+		*out++ = *in++;
+}
+
+static int sa_aes_run(struct ablkcipher_request *req, u8 *iv, int enc)
+{
+	struct sa_tfm_ctx *ctx =
+	    crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+	struct sa_ctx_info *sa_ctx = enc ? &ctx->enc : &ctx->dec;
+	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
+	struct sa_dma_req_ctx req_ctx;
+	struct dma_async_tx_descriptor *tx_in, *tx_out;
+	struct sa_rx_data *rxd;
+	u8 enc_offset;
+	int sg_nents, dst_nents;
+	int psdata_offset;
+	u8 auth_offset = 0;
+	u8 *auth_iv = NULL;
+	u8 *aad = NULL;
+	u8 aad_len = 0;
+	u16 enc_len;
+	u16 auth_len = 0;
+	u32 req_type;
+	u32 *mdptr;
+	size_t pl, ml;
+
+	struct device *ddev;
+	struct dma_chan *dma_rx;
+	gfp_t flags;
+
+	flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		GFP_KERNEL : GFP_ATOMIC;
+
+	enc_offset = 0x0;
+	enc_len = req->nbytes;
+
+	if (enc_len >= 256)
+		dma_rx = pdata->dma_rx2;
+	else
+		dma_rx = pdata->dma_rx1;
+
+	/* Allocate descriptor & submit packet */
+	sg_nents = sg_nents_for_len(req->src, enc_len);
+	dst_nents = sg_nents_for_len(req->dst, enc_len);
+
+	memcpy(req_ctx.cmdl, sa_ctx->cmdl, sa_ctx->cmdl_size);
+
+	/* Update Command Label */
+	sa_update_cmdl(sa_k3_dev, enc_offset, enc_len,
+		       iv, auth_offset, auth_len,
+		       auth_iv, aad_len, aad,
+		       &sa_ctx->cmdl_upd_info, req_ctx.cmdl);
+
+	/*
+	 * Last 2 words in PSDATA will have the crypto alg type &
+	 * crypto request pointer
+	 */
+	req_type = CRYPTO_ALG_TYPE_ABLKCIPHER;
+	if (enc)
+		req_type |= (SA_REQ_SUBTYPE_ENC << SA_REQ_SUBTYPE_SHIFT);
+	else
+		req_type |= (SA_REQ_SUBTYPE_DEC << SA_REQ_SUBTYPE_SHIFT);
+
+	psdata_offset = sa_ctx->cmdl_size / sizeof(u32);
+	req_ctx.cmdl[psdata_offset++] = req_type;
+
+	ddev = dma_rx->device->dev;
+	/* map the packet */
+	req_ctx.src = req->src;
+	req_ctx.src_nents = dma_map_sg(sa_k3_dev, req->src, sg_nents,
+				       DMA_TO_DEVICE);
+	if (req->src != req->dst)
+		dst_nents = dma_map_sg(ddev, req->dst, sg_nents,
+				       DMA_FROM_DEVICE);
+	else
+		dst_nents = req_ctx.src_nents;
+
+	if (unlikely(req_ctx.src_nents != sg_nents)) {
+		dev_warn_ratelimited(sa_k3_dev, "failed to map tx pkt\n");
+		return -EIO;
+	}
+
+	req_ctx.dev_data = pdata;
+	req_ctx.pkt = true;
+
+	dma_sync_sg_for_device(pdata->dev, req->src, req_ctx.src_nents,
+			       DMA_TO_DEVICE);
+
+	tx_in = dmaengine_prep_slave_sg(dma_rx, req->dst, dst_nents,
+					DMA_DEV_TO_MEM,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!tx_in) {
+		dev_err(pdata->dev, "IN prep_slave_sg() failed\n");
+		return -EINVAL;
+	}
+
+	rxd = kzalloc(sizeof(*rxd), GFP_KERNEL);
+	rxd->req = (void *)req;
+	rxd->ddev = ddev;
+
+	/* IN */
+	tx_in->callback = sa_aes_dma_in_callback;
+	tx_in->callback_param = rxd;
+
+	tx_out = dmaengine_prep_slave_sg(pdata->dma_tx, req->src,
+					 req_ctx.src_nents, DMA_MEM_TO_DEV,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!tx_out) {
+		dev_err(pdata->dev, "OUT prep_slave_sg() failed\n");
+		return -EINVAL;
+	}
+
+	mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(tx_out, &pl, &ml);
+
+	sa_prepare_tx_desc(mdptr, (sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS *
+			   sizeof(u32))), req_ctx.cmdl,
+			   sizeof(sa_ctx->epib), sa_ctx->epib);
+
+	ml = sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS * sizeof(u32));
+	dmaengine_desc_set_metadata_len(tx_out, 44);
+
+	dmaengine_submit(tx_out);
+	dmaengine_submit(tx_in);
+
+	dma_async_issue_pending(dma_rx);
+	dma_async_issue_pending(pdata->dma_tx);
+
+	return -EINPROGRESS;
+}
+
+static int sa_aes_cbc_encrypt(struct ablkcipher_request *req)
+{
+	return sa_aes_run(req, req->info, 1);
+}
+
+static int sa_aes_cbc_decrypt(struct ablkcipher_request *req)
+{
+	return sa_aes_run(req, req->info, 0);
+}
+
+static struct sa_alg_tmpl sa_algs[] = {
+	{.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "cbc(aes)",
+			.cra_driver_name = "cbc-aes-sa2ul",
+			.cra_priority = 30000,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sa_tfm_ctx),
+			.cra_alignmask = 0,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_module = THIS_MODULE,
+			.cra_init = sa_aes_cra_init,
+			.cra_exit = sa_aes_cra_exit,
+			.cra_u.ablkcipher = {
+					     .min_keysize = AES_MIN_KEY_SIZE,
+					     .max_keysize = AES_MAX_KEY_SIZE,
+					     .ivsize = AES_BLOCK_SIZE,
+					     .setkey = sa_aes_cbc_setkey,
+					     .encrypt = sa_aes_cbc_encrypt,
+					     .decrypt = sa_aes_cbc_decrypt,
+					}
+			}
+	},
+};
+
+/* Register the algorithms in crypto framework */
+void sa_register_algos(const struct device *dev)
+{
+	char *alg_name;
+	u32 type;
+	int i, err, num_algs = ARRAY_SIZE(sa_algs);
+
+	for (i = 0; i < num_algs; i++) {
+		type = sa_algs[i].type;
+		if (type == CRYPTO_ALG_TYPE_AEAD) {
+			alg_name = sa_algs[i].alg.aead.base.cra_name;
+			err = crypto_register_aead(&sa_algs[i].alg.aead);
+		} else if (type == CRYPTO_ALG_TYPE_ABLKCIPHER) {
+			alg_name = sa_algs[i].alg.crypto.cra_name;
+			err = crypto_register_alg(&sa_algs[i].alg.crypto);
+		} else {
+			dev_err(dev,
+				"un-supported crypto algorithm (%d)",
+				sa_algs[i].type);
+			continue;
+		}
+
+		if (err)
+			dev_err(dev, "Failed to register '%s'\n", alg_name);
+		else
+			sa_algs[i].registered = 1;
+	}
+}
+
+/* Unregister the algorithms in crypto framework */
+void sa_unregister_algos(const struct device *dev)
+{
+	char *alg_name;
+	u32 type;
+	int i, err = 0, num_algs = ARRAY_SIZE(sa_algs);
+
+	for (i = 0; i < num_algs; i++) {
+		type = sa_algs[i].type;
+		if (type == CRYPTO_ALG_TYPE_AEAD) {
+			alg_name = sa_algs[i].alg.aead.base.cra_name;
+			crypto_unregister_aead(&sa_algs[i].alg.aead);
+		} else {
+			alg_name = sa_algs[i].alg.crypto.cra_name;
+			err = crypto_unregister_alg(&sa_algs[i].alg.crypto);
+		}
+
+		sa_algs[i].registered = 0;
+	}
+}
+
+static int sa_init_mem(struct sa_crypto_data *dev_data)
+{
+	struct device *dev = &dev_data->pdev->dev;
+	/* Setup dma pool for security context buffers */
+	dev_data->sc_pool = dma_pool_create("keystone-sc", dev,
+					    SA_CTX_MAX_SZ, 64, 0);
+	if (!dev_data->sc_pool) {
+		dev_err(dev, "Failed to create dma pool");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int sa_dma_init(struct sa_crypto_data *dd)
+{
+	int ret;
+	struct dma_slave_config cfg;
+
+	dd->dma_rx1 = NULL;
+	dd->dma_tx = NULL;
+	dd->dma_rx2 = NULL;
+
+	ret = dma_coerce_mask_and_coherent(dd->dev, DMA_BIT_MASK(48));
+	if (ret)
+		return ret;
+
+	dd->dma_rx1 = dma_request_chan(dd->dev, "rx1");
+	if (IS_ERR(dd->dma_rx1)) {
+		if (PTR_ERR(dd->dma_rx1) != -EPROBE_DEFER)
+			dev_err(dd->dev, "Unable to request rx1 DMA channel\n");
+		return PTR_ERR(dd->dma_rx1);
+	}
+
+	dd->dma_rx2 = dma_request_chan(dd->dev, "rx2");
+	if (IS_ERR(dd->dma_rx2)) {
+		dma_release_channel(dd->dma_rx1);
+		if (PTR_ERR(dd->dma_rx1) != -EPROBE_DEFER)
+			dev_err(dd->dev, "Unable to request rx2 DMA channel\n");
+		return PTR_ERR(dd->dma_rx2);
+	}
+
+	dd->dma_tx = dma_request_chan(dd->dev, "tx");
+	if (IS_ERR(dd->dma_tx)) {
+		if (PTR_ERR(dd->dma_rx1) != -EPROBE_DEFER)
+			dev_err(dd->dev, "Unable to request tx DMA channel\n");
+		ret = PTR_ERR(dd->dma_tx);
+		goto err_dma_tx;
+	}
+
+	memzero_explicit(&cfg, sizeof(cfg));
+
+	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	cfg.src_maxburst = 4;
+	cfg.dst_maxburst = 4;
+
+	ret = dmaengine_slave_config(dd->dma_rx1, &cfg);
+	if (ret) {
+		dev_err(dd->dev, "can't configure IN dmaengine slave: %d\n",
+			ret);
+		return ret;
+	}
+
+	ret = dmaengine_slave_config(dd->dma_rx2, &cfg);
+	if (ret) {
+		dev_err(dd->dev, "can't configure IN dmaengine slave: %d\n",
+			ret);
+		return ret;
+	}
+
+	ret = dmaengine_slave_config(dd->dma_tx, &cfg);
+	if (ret) {
+		dev_err(dd->dev, "can't configure OUT dmaengine slave: %d\n",
+			ret);
+		return ret;
+	}
+
+	return 0;
+
+err_dma_tx:
+	dma_release_channel(dd->dma_rx1);
+	dma_release_channel(dd->dma_rx2);
+
+	return ret;
+}
+
+static int sa_ul_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	static void __iomem *saul_base;
+	struct sa_crypto_data *dev_data;
+	u32 val;
+	int ret;
+
+	dev_data = devm_kzalloc(dev, sizeof(*dev_data), GFP_KERNEL);
+	if (!dev_data)
+		return -ENOMEM;
+
+	sa_k3_dev = dev;
+	dev_data->dev = dev;
+	dev_data->pdev = pdev;
+	platform_set_drvdata(pdev, dev_data);
+	dev_set_drvdata(sa_k3_dev, dev_data);
+
+	sa_init_mem(dev_data);
+	ret = sa_dma_init(dev_data);
+	if (ret)
+		return ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	saul_base = devm_ioremap_resource(dev, res);
+
+	val = SA_EEC_ENCSS_EN | SA_EEC_AUTHSS_EN | SA_EEC_CTXCACH_EN |
+	    SA_EEC_CPPI_PORT_IN_EN | SA_EEC_CPPI_PORT_OUT_EN | SA_EEC_TRNG_EN;
+
+	writel_relaxed(val, saul_base + SA_ENGINE_ENABLE_CONTROL);
+
+	sa_register_algos(dev);
+
+	return 0;
+}
+
+static int sa_ul_remove(struct platform_device *pdev)
+{
+	struct sa_crypto_data *dev_data = platform_get_drvdata(pdev);
+
+	sa_unregister_algos(&pdev->dev);
+
+	dma_release_channel(dev_data->dma_rx2);
+	dma_release_channel(dev_data->dma_rx1);
+	dma_release_channel(dev_data->dma_tx);
+
+	dma_pool_destroy(dev_data->sc_pool);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static const struct of_device_id of_match[] = {
+	{.compatible = "ti,sa2ul-crypto",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_match);
+
+static struct platform_driver sa_ul_driver = {
+	.probe = sa_ul_probe,
+	.remove = sa_ul_remove,
+	.driver = {
+		   .name = "saul-crypto",
+		   .of_match_table = of_match,
+		   },
+};
+module_platform_driver(sa_ul_driver);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
new file mode 100644
index 000000000000..caf3c88dcf2b
--- /dev/null
+++ b/drivers/crypto/sa2ul.h
@@ -0,0 +1,384 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AM6 SA2UL crypto accelerator driver
+ *
+ * Copyright (C) 2018 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Authors:	Keerthy
+ *              Vitaly Andrianov
+ */
+
+#ifndef _K3_SA2UL_
+#define _K3_SA2UL_
+
+#include <linux/interrupt.h>
+#include <linux/skbuff.h>
+#include <linux/hw_random.h>
+#include <crypto/aes.h>
+
+#define SA_ENGINE_ENABLE_CONTROL	0x1000
+
+struct sa_tfm_ctx;
+/*
+ * SA_ENGINE_ENABLE_CONTROL register bits
+ */
+#define SA_EEC_ENCSS_EN			0x00000001
+#define SA_EEC_AUTHSS_EN		0x00000002
+#define SA_EEC_TRNG_EN			0x00000008
+#define SA_EEC_PKA_EN			0x00000010
+#define SA_EEC_CTXCACH_EN		0x00000080
+#define SA_EEC_CPPI_PORT_IN_EN		0x00000200
+#define SA_EEC_CPPI_PORT_OUT_EN		0x00000800
+
+/*
+ * Encoding used to identify the typo of crypto operation
+ * performed on the packet when the packet is returned
+ * by SA
+ */
+#define SA_REQ_SUBTYPE_ENC	0x0001
+#define SA_REQ_SUBTYPE_DEC	0x0002
+#define SA_REQ_SUBTYPE_SHIFT	16
+#define SA_REQ_SUBTYPE_MASK	0xffff
+
+/* Number of 32 bit words in EPIB  */
+#define SA_DMA_NUM_EPIB_WORDS   4
+
+/* Number of 32 bit words in PS data  */
+#define SA_DMA_NUM_PS_WORDS     16
+#define NKEY_SZ			3
+#define MCI_SZ			27
+
+/*
+ * Maximum number of simultaeneous security contexts
+ * supported by the driver
+ */
+#define SA_MAX_NUM_CTX	512
+
+/*
+ * Assumption: CTX size is multiple of 32
+ */
+#define SA_CTX_SIZE_TO_DMA_SIZE(ctx_sz) \
+		((ctx_sz) ? ((ctx_sz) / 32 - 1) : 0)
+
+#define SA_CTX_ENC_KEY_OFFSET   32
+#define SA_CTX_ENC_AUX1_OFFSET  64
+#define SA_CTX_ENC_AUX2_OFFSET  96
+#define SA_CTX_ENC_AUX3_OFFSET  112
+#define SA_CTX_ENC_AUX4_OFFSET  128
+
+/* Next Engine Select code in CP_ACE */
+#define SA_ENG_ID_EM1   2       /* Enc/Dec engine with AES/DEC core */
+#define SA_ENG_ID_EM2   3       /* Encryption/Decryption enginefor pass 2 */
+#define SA_ENG_ID_AM1   4       /* Auth. engine with SHA1/MD5/SHA2 core */
+#define SA_ENG_ID_AM2   5       /*  Authentication engine for pass 2 */
+#define SA_ENG_ID_OUTPORT2 20   /*  Egress module 2  */
+#define SA_ENG_ID_NONE  0xff
+
+/*
+ * Command Label Definitions
+ */
+#define SA_CMDL_OFFSET_NESC           0      /* Next Engine Select Code */
+#define SA_CMDL_OFFSET_LABEL_LEN      1      /* Engine Command Label Length */
+/* 16-bit Length of Data to be processed */
+#define SA_CMDL_OFFSET_DATA_LEN       2
+#define SA_CMDL_OFFSET_DATA_OFFSET    4      /* Stat Data Offset */
+#define SA_CMDL_OFFSET_OPTION_CTRL1   5      /* Option Control Byte 1 */
+#define SA_CMDL_OFFSET_OPTION_CTRL2   6      /* Option Control Byte 2 */
+#define SA_CMDL_OFFSET_OPTION_CTRL3   7      /* Option Control Byte 3 */
+#define SA_CMDL_OFFSET_OPTION_BYTE    8
+
+#define SA_CMDL_HEADER_SIZE_BYTES	8
+
+#define SA_CMDL_OPTION_BYTES_MAX_SIZE     72
+#define SA_CMDL_MAX_SIZE_BYTES (SA_CMDL_HEADER_SIZE_BYTES + \
+				SA_CMDL_OPTION_BYTES_MAX_SIZE)
+
+/* SWINFO word-0 flags */
+#define SA_SW_INFO_FLAG_EVICT   0x0001
+#define SA_SW_INFO_FLAG_TEAR    0x0002
+#define SA_SW_INFO_FLAG_NOPD    0x0004
+
+/*
+ * This type represents the various packet types to be processed
+ * by the PHP engine in SA.
+ * It is used to identify the corresponding PHP processing function.
+ */
+#define SA_CTX_PE_PKT_TYPE_3GPP_AIR    0    /* 3GPP Air Cipher */
+#define SA_CTX_PE_PKT_TYPE_SRTP        1    /* SRTP */
+#define SA_CTX_PE_PKT_TYPE_IPSEC_AH    2    /* IPSec Authentication Header */
+/* IPSec Encapsulating Security Payload */
+#define SA_CTX_PE_PKT_TYPE_IPSEC_ESP   3
+/* Indicates that it is in data mode, It may not be used by PHP */
+#define SA_CTX_PE_PKT_TYPE_NONE        4
+#define SA_CTX_ENC_TYPE1_SZ     64      /* Encryption SC with Key only */
+#define SA_CTX_ENC_TYPE2_SZ     96      /* Encryption SC with Key and Aux1 */
+
+#define SA_CTX_AUTH_TYPE1_SZ    64      /* Auth SC with Key only */
+#define SA_CTX_AUTH_TYPE2_SZ    96      /* Auth SC with Key and Aux1 */
+/* Size of security context for PHP engine */
+#define SA_CTX_PHP_PE_CTX_SZ    64
+
+#define SA_CTX_MAX_SZ (64 + SA_CTX_ENC_TYPE2_SZ + SA_CTX_AUTH_TYPE2_SZ)
+
+/*
+ * Encoding of F/E control in SCCTL
+ *  Bit 0-1: Fetch PHP Bytes
+ *  Bit 2-3: Fetch Encryption/Air Ciphering Bytes
+ *  Bit 4-5: Fetch Authentication Bytes or Encr pass 2
+ *  Bit 6-7: Evict PHP Bytes
+ *
+ *  where   00 = 0 bytes
+ *          01 = 64 bytes
+ *          10 = 96 bytes
+ *          11 = 128 bytes
+ */
+#define SA_CTX_DMA_SIZE_0       0
+#define SA_CTX_DMA_SIZE_64      1
+#define SA_CTX_DMA_SIZE_96      2
+#define SA_CTX_DMA_SIZE_128     3
+
+/*
+ * Byte offset of the owner word in SCCTL
+ * in the security context
+ */
+#define SA_CTX_SCCTL_OWNER_OFFSET 0
+
+#define SA_CTX_ENC_KEY_OFFSET   32
+#define SA_CTX_ENC_AUX1_OFFSET  64
+#define SA_CTX_ENC_AUX2_OFFSET  96
+#define SA_CTX_ENC_AUX3_OFFSET  112
+#define SA_CTX_ENC_AUX4_OFFSET  128
+
+#define SA_SCCTL_FE_AUTH_ENC	0x65
+#define SA_SCCTL_FE_ENC		0x8D
+
+#define SA_ALIGN_MASK		(sizeof(u32) - 1)
+#define SA_ALIGNED		__aligned(32)
+
+/**
+ * struct sa_crypto_data - Crypto driver instance data
+ * @pdev: Platform device pointer
+ * @sc_pool: security context pool
+ * @dev: Device pointer
+ * @scid_lock: secure context ID lock
+ * @sc_id_start: starting index for SC ID
+ * @sc_id_end: Ending index for SC ID
+ * @sc_id: Security Context ID
+ * @ctx_bm: Bitmap to keep track of Security context ID's
+ * @ctx: SA tfm context pointer
+ * @dma_rx1: Pointer to DMA rx channel for sizes < 256 Bytes
+ * @dma_rx2: Pointer to DMA rx channel for sizes > 256 Bytes
+ * @dma_tx: Pointer to DMA TX channel
+ */
+struct sa_crypto_data {
+	struct platform_device	*pdev;
+	struct dma_pool		*sc_pool;
+	struct device *dev;
+	spinlock_t	scid_lock; /* lock for SC-ID allocation */
+	/* Security context data */
+	u16		sc_id_start;
+	u16		sc_id_end;
+	u16		sc_id;
+	unsigned long	ctx_bm[DIV_ROUND_UP(SA_MAX_NUM_CTX,
+				BITS_PER_LONG)];
+	struct sa_tfm_ctx	*ctx;
+	struct dma_chan		*dma_rx1;
+	struct dma_chan		*dma_rx2;
+	struct dma_chan		*dma_tx;
+};
+
+/**
+ * struct sa_cmdl_param_info: Command label parameters info
+ * @index: Index of the parameter in the command label format
+ * @offset: the offset of the parameter
+ * @size: Size of the parameter
+ */
+struct sa_cmdl_param_info {
+	u16	index;
+	u16	offset;
+	u16	size;
+};
+
+/* Maximum length of Auxiliary data in 32bit words */
+#define SA_MAX_AUX_DATA_WORDS	8
+
+/**
+ * struct sa_cmdl_upd_info: Command label updation info
+ * @flags: flags in command label
+ * @submode: Encryption submodes
+ * @enc_size: Size of first pass encryption size
+ * @enc_size2: Size of second pass encryption size
+ * @enc_offset: Encryption payload offset in the packet
+ * @enc_iv: Encryption initialization vector for pass2
+ * @enc_iv2: Encryption initialization vector for pass2
+ * @aad: Associated data
+ * @payload: Payload info
+ * @auth_size: Authentication size for pass 1
+ * @auth_size2: Authentication size for pass 2
+ * @auth_offset: Authentication payload offset
+ * @auth_iv: Authentication initialization vector
+ * @aux_key_info: Authentication aux key information
+ * @aux_key: Aux key for authentication
+ */
+struct sa_cmdl_upd_info {
+	u16	flags;
+	u16	submode;
+	struct sa_cmdl_param_info	enc_size;
+	struct sa_cmdl_param_info	enc_size2;
+	struct sa_cmdl_param_info	enc_offset;
+	struct sa_cmdl_param_info	enc_iv;
+	struct sa_cmdl_param_info	enc_iv2;
+	struct sa_cmdl_param_info	aad;
+	struct sa_cmdl_param_info	payload;
+	struct sa_cmdl_param_info	auth_size;
+	struct sa_cmdl_param_info	auth_size2;
+	struct sa_cmdl_param_info	auth_offset;
+	struct sa_cmdl_param_info	auth_iv;
+	struct sa_cmdl_param_info	aux_key_info;
+	u32				aux_key[SA_MAX_AUX_DATA_WORDS];
+};
+
+/*
+ * Number of 32bit words appended after the command label
+ * in PSDATA to identify the crypto request context.
+ * word-0: Request type
+ * word-1: pointer to request
+ */
+#define SA_PSDATA_CTX_WORDS 4
+
+/* Maximum size of Command label in 32 words */
+#define SA_MAX_CMDL_WORDS (SA_DMA_NUM_PS_WORDS - SA_PSDATA_CTX_WORDS)
+
+/**
+ * struct sa_ctx_info: SA context information
+ * @sc: Pointer to security context
+ * @sc_phys: Security context physical address that is passed on to SA2UL
+ * @cmdl_size: Command label size
+ * @cmdl: Command label for a particular iteration
+ * @cmdl_upd_info: structure holding command label updation info
+ * @epib: Extended protocol information block words
+ */
+struct sa_ctx_info {
+	u8		*sc;
+	dma_addr_t	sc_phys;
+	u16		sc_id;
+	u16		cmdl_size;
+	u32		cmdl[SA_MAX_CMDL_WORDS];
+	struct sa_cmdl_upd_info cmdl_upd_info;
+	/* Store Auxiliary data such as K2/K3 subkeys in AES-XCBC */
+	u32		epib[SA_DMA_NUM_EPIB_WORDS];
+};
+
+struct sa_sham_hmac_ctx {
+	struct crypto_shash	*shash;
+	u8			ipad[SHA512_BLOCK_SIZE] SA_ALIGNED;
+	u8			opad[SHA512_BLOCK_SIZE] SA_ALIGNED;
+};
+
+/**
+ * struct sa_tfm_ctx: TFM context structure
+ * @dev_data: struct sa_crypto_data pointer
+ * @enc: struct sa_ctx_info for encryption
+ * @dec: struct sa_ctx_info for decryption
+ * @auth: struct sa_ctx_info for authentication
+ * @keylen: encrption/decryption keylength
+ * @key: encryption key
+ * @shash: software hash crypto_hash
+ * @authkey: authentication key
+ */
+struct sa_tfm_ctx {
+	struct sa_crypto_data *dev_data;
+	struct sa_ctx_info enc;
+	struct sa_ctx_info dec;
+	struct sa_ctx_info auth;
+	int keylen;
+	u32 key[AES_KEYSIZE_256 / sizeof(u32)];
+	struct sa_sham_hmac_ctx base[0];
+	struct crypto_shash	*shash;
+	u8 authkey[SHA512_BLOCK_SIZE];
+};
+
+/**
+ * struct sa_dma_req_ctx: Structure used for tx dma request
+ * @dev_data: struct sa_crypto_data pointer
+ * @cmdl: Complete command label with psdata and epib included
+ * @src: source payload scatterlist pointer
+ * @src_nents: Number of nodes in source scatterlist
+ * @pkt: packet dma
+ */
+struct sa_dma_req_ctx {
+	struct sa_crypto_data *dev_data;
+	u32		cmdl[SA_MAX_CMDL_WORDS + SA_PSDATA_CTX_WORDS];
+	struct scatterlist *src;
+	unsigned int	src_nents;
+	bool		pkt;
+};
+
+enum sa_submode {
+	SA_MODE_GEN = 0,
+	SA_MODE_CCM,
+	SA_MODE_GCM,
+	SA_MODE_GMAC
+};
+
+/* Encryption algorithms */
+enum sa_ealg_id {
+	SA_EALG_ID_NONE = 0,        /* No encryption */
+	SA_EALG_ID_NULL,            /* NULL encryption */
+	SA_EALG_ID_AES_CTR,         /* AES Counter mode */
+	SA_EALG_ID_AES_F8,          /* AES F8 mode */
+	SA_EALG_ID_AES_CBC,         /* AES CBC mode */
+	SA_EALG_ID_DES_CBC,         /* DES CBC mode */
+	SA_EALG_ID_3DES_CBC,        /* 3DES CBC mode */
+	SA_EALG_ID_CCM,             /* Counter with CBC-MAC mode */
+	SA_EALG_ID_GCM,             /* Galois Counter mode */
+	SA_EALG_ID_AES_ECB,
+	SA_EALG_ID_LAST
+};
+
+/* Authentication algorithms */
+enum sa_aalg_id {
+	SA_AALG_ID_NONE = 0,      /* No Authentication  */
+	SA_AALG_ID_NULL = SA_EALG_ID_LAST, /* NULL Authentication  */
+	SA_AALG_ID_MD5,           /* MD5 mode */
+	SA_AALG_ID_SHA1,          /* SHA1 mode */
+	SA_AALG_ID_SHA2_224,      /* 224-bit SHA2 mode */
+	SA_AALG_ID_SHA2_256,      /* 256-bit SHA2 mode */
+	SA_AALG_ID_HMAC_MD5,      /* HMAC with MD5 mode */
+	SA_AALG_ID_HMAC_SHA1,     /* HMAC with SHA1 mode */
+	SA_AALG_ID_HMAC_SHA2_224, /* HMAC with 224-bit SHA2 mode */
+	SA_AALG_ID_HMAC_SHA2_256, /* HMAC with 256-bit SHA2 mode */
+	SA_AALG_ID_GMAC,          /* Galois Message Auth. Code mode */
+	SA_AALG_ID_CMAC,          /* Cipher-based Mes. Auth. Code mode */
+	SA_AALG_ID_CBC_MAC,       /* Cipher Block Chaining */
+	SA_AALG_ID_AES_XCBC       /* AES Extended Cipher Block Chaining */
+};
+
+/*
+ * Mode control engine algorithms used to index the
+ * mode control instruction tables
+ */
+enum sa_eng_algo_id {
+	SA_ENG_ALGO_ECB = 0,
+	SA_ENG_ALGO_CBC,
+	SA_ENG_ALGO_CFB,
+	SA_ENG_ALGO_OFB,
+	SA_ENG_ALGO_CTR,
+	SA_ENG_ALGO_F8,
+	SA_ENG_ALGO_F8F9,
+	SA_ENG_ALGO_GCM,
+	SA_ENG_ALGO_GMAC,
+	SA_ENG_ALGO_CCM,
+	SA_ENG_ALGO_CMAC,
+	SA_ENG_ALGO_CBCMAC,
+	SA_NUM_ENG_ALGOS
+};
+
+struct sa_eng_info {
+	u8	eng_id;
+	u16	sc_size;
+};
+
+extern struct device *sa_ks2_dev;
+
+#endif /* _K3_SA2UL_ */
-- 
2.17.1

