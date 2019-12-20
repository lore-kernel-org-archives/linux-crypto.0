Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0952C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA40A20866
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n+/iXGZ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTTDQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 14:03:16 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39711 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTTDP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 14:03:15 -0500
Received: by mail-pf1-f196.google.com with SMTP id q10so5708400pfs.6
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2019 11:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ciyFGskHG1SVOrUGpNjo4zQNHcUJjfbyh0aLUktQAw=;
        b=n+/iXGZ4sP6q1qDCr0Gwoo69dsEa0uUX/hHwzace9UuAJtlSxHxI09fHFM1YQTed7v
         yjzv46o/PPE2a3iBo2+lUCdy6x2ZHP9tviCkbKAZ7Te1ByBHV6vXm6guum1xl6uXwF08
         bcnvPEYhZtNlJQgMirIl6U/oKA/Zm4UIK3CP80hFHyrYiiYDwhLT42N0bKbnlWsyR2F1
         01J1VOR8cZmZSekEkILvgf7wTSQyCIIuCO+7izRsNuvooQFRNUeF+m1T6a1Q/vt8J6gx
         cMbgeP+Zi3m65ZmPbm97h92IpbdmDCWLZffxu3YxDexrfi7VOTI3ADQNb9lUXsOcfMku
         G+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ciyFGskHG1SVOrUGpNjo4zQNHcUJjfbyh0aLUktQAw=;
        b=n+4CF8DClrGsmqW35gSARLQWz3p07BW/KN3l0OyzXU8C/V+jiOTIbMTDe3GVtRUC66
         LQzgCaCLd1+ThQEWFREidWcomMmR4jOMdT4QnZTyxvRHOv5bxAADOFZb4pMiPKFgB+Q/
         g/VGi9sfknHTbbaN+Bx+t9hY/w2Ko633i8jxCWLVKFPwiZ8a4xzWysoivPm+Z0o6BNiO
         CrIdeWnlUDaOiE9r+wTzEezNssv80mc5NgymFa4alulEypxuFPfLHVVH8WyT5X6hWAGE
         1upRrG/9tIaa0WT+njeF8kcxPRiqY4S1zi3y9DjIuptx4E1deGPunM02KBP2MgheRHkB
         e6HA==
X-Gm-Message-State: APjAAAW9vcXbjQOLWFWcFTRq2e7ugSB1jcLaOAjK/314VPhLLUgBIsQC
        ndAY24bXY434KOq4rKuNlGI=
X-Google-Smtp-Source: APXvYqy+QXK5x/06IasSUpWjwnbH7zXd2M7JVraxzIaEDjSCTRkIolMa4OhsjoQpXtJiIVe2VMp0fQ==
X-Received: by 2002:a63:504c:: with SMTP id q12mr16435236pgl.117.1576868594662;
        Fri, 20 Dec 2019 11:03:14 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id i4sm10833612pjw.28.2019.12.20.11.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 11:03:14 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH 6/6] crypto: qce - allow building only hashes/ciphers
Date:   Fri, 20 Dec 2019 16:02:18 -0300
Message-Id: <20191220190218.28884-7-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191220190218.28884-1-cotequeiroz@gmail.com>
References: <20191220190218.28884-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow the user to choose whether to build support for all algorithms
(default), hashes-only, or skciphers-only.

The QCE engine does not appear to scale as well as the CPU to handle
multiple crypto requests.  While the ipq40xx chips have 4-core CPUs, the
QCE handles only 2 requests in parallel.

Ipsec throughput seems to improve when disabling either family of
algorithms, sharing the load with the CPU.  Enabling skciphers-only
appears to work best.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>
---
 drivers/crypto/Kconfig      |  63 +++++++++-
 drivers/crypto/qce/Makefile |   7 +-
 drivers/crypto/qce/common.c | 244 +++++++++++++++++++-----------------
 drivers/crypto/qce/core.c   |   4 +
 4 files changed, 193 insertions(+), 125 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index d02e79ac81c0..73a80232e69e 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -618,6 +618,14 @@ config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
 	depends on ARCH_QCOM || COMPILE_TEST
 	depends on HAS_IOMEM
+	help
+	  This driver supports Qualcomm crypto engine accelerator
+	  hardware. To compile this driver as a module, choose M here. The
+	  module will be called qcrypto.
+
+config CRYPTO_DEV_QCE_SKCIPHER
+	bool
+	depends on CRYPTO_DEV_QCE
 	select CRYPTO_AES
 	select CRYPTO_LIB_DES
 	select CRYPTO_ECB
@@ -625,10 +633,57 @@ config CRYPTO_DEV_QCE
 	select CRYPTO_XTS
 	select CRYPTO_CTR
 	select CRYPTO_SKCIPHER
-	help
-	  This driver supports Qualcomm crypto engine accelerator
-	  hardware. To compile this driver as a module, choose M here. The
-	  module will be called qcrypto.
+
+config CRYPTO_DEV_QCE_SHA
+	bool
+	depends on CRYPTO_DEV_QCE
+
+choice
+	prompt "Algorithms enabled for QCE acceleration"
+	default CRYPTO_DEV_QCE_ENABLE_ALL
+	depends on CRYPTO_DEV_QCE
+	help
+	  This option allows to choose whether to build support for all algorihtms
+	  (default), hashes-only, or skciphers-only.
+
+	  The QCE engine does not appear to scale as well as the CPU to handle
+	  multiple crypto requests.  While the ipq40xx chips have 4-core CPUs, the
+	  QCE handles only 2 requests in parallel.
+
+	  Ipsec throughput seems to improve when disabling either family of
+	  algorithms, sharing the load with the CPU.  Enabling skciphers-only
+	  appears to work best.
+
+	config CRYPTO_DEV_QCE_ENABLE_ALL
+		bool "All supported algorithms"
+		select CRYPTO_DEV_QCE_SKCIPHER
+		select CRYPTO_DEV_QCE_SHA
+		help
+		  Enable all supported algorithms:
+			- AES (CBC, CTR, ECB, XTS)
+			- 3DES (CBC, ECB)
+			- DES (CBC, ECB)
+			- SHA1, HMAC-SHA1
+			- SHA256, HMAC-SHA256
+
+	config CRYPTO_DEV_QCE_ENABLE_SKCIPHER
+		bool "Symmetric-key ciphers only"
+		select CRYPTO_DEV_QCE_SKCIPHER
+		help
+		  Enable symmetric-key ciphers only:
+			- AES (CBC, CTR, ECB, XTS)
+			- 3DES (ECB, CBC)
+			- DES (ECB, CBC)
+
+	config CRYPTO_DEV_QCE_ENABLE_SHA
+		bool "Hash/HMAC only"
+		select CRYPTO_DEV_QCE_SHA
+		help
+		  Enable hashes/HMAC algorithms only:
+			- SHA1, HMAC-SHA1
+			- SHA256, HMAC-SHA256
+
+endchoice
 
 config CRYPTO_DEV_QCOM_RNG
 	tristate "Qualcomm Random Number Generator Driver"
diff --git a/drivers/crypto/qce/Makefile b/drivers/crypto/qce/Makefile
index 8caa04e1ec43..14ade8a7d664 100644
--- a/drivers/crypto/qce/Makefile
+++ b/drivers/crypto/qce/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_CRYPTO_DEV_QCE) += qcrypto.o
 qcrypto-objs := core.o \
 		common.o \
-		dma.o \
-		sha.o \
-		skcipher.o
+		dma.o
+
+qcrypto-$(CONFIG_CRYPTO_DEV_QCE_SHA) += sha.o
+qcrypto-$(CONFIG_CRYPTO_DEV_QCE_SKCIPHER) += skcipher.o
diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index da1188abc9ba..629e7f34dc09 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -45,52 +45,56 @@ qce_clear_array(struct qce_device *qce, u32 offset, unsigned int len)
 		qce_write(qce, offset + i * sizeof(u32), 0);
 }
 
-static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
+static u32 qce_config_reg(struct qce_device *qce, int little)
 {
-	u32 cfg = 0;
+	u32 beats = (qce->burst_size >> 3) - 1;
+	u32 pipe_pair = qce->pipe_pair_id;
+	u32 config;
 
-	if (IS_AES(flags)) {
-		if (aes_key_size == AES_KEYSIZE_128)
-			cfg |= ENCR_KEY_SZ_AES128 << ENCR_KEY_SZ_SHIFT;
-		else if (aes_key_size == AES_KEYSIZE_256)
-			cfg |= ENCR_KEY_SZ_AES256 << ENCR_KEY_SZ_SHIFT;
-	}
+	config = (beats << REQ_SIZE_SHIFT) & REQ_SIZE_MASK;
+	config |= BIT(MASK_DOUT_INTR_SHIFT) | BIT(MASK_DIN_INTR_SHIFT) |
+		  BIT(MASK_OP_DONE_INTR_SHIFT) | BIT(MASK_ERR_INTR_SHIFT);
+	config |= (pipe_pair << PIPE_SET_SELECT_SHIFT) & PIPE_SET_SELECT_MASK;
+	config &= ~HIGH_SPD_EN_N_SHIFT;
 
-	if (IS_AES(flags))
-		cfg |= ENCR_ALG_AES << ENCR_ALG_SHIFT;
-	else if (IS_DES(flags) || IS_3DES(flags))
-		cfg |= ENCR_ALG_DES << ENCR_ALG_SHIFT;
+	if (little)
+		config |= BIT(LITTLE_ENDIAN_MODE_SHIFT);
 
-	if (IS_DES(flags))
-		cfg |= ENCR_KEY_SZ_DES << ENCR_KEY_SZ_SHIFT;
+	return config;
+}
 
-	if (IS_3DES(flags))
-		cfg |= ENCR_KEY_SZ_3DES << ENCR_KEY_SZ_SHIFT;
+void qce_cpu_to_be32p_array(__be32 *dst, const u8 *src, unsigned int len)
+{
+	__be32 *d = dst;
+	const u8 *s = src;
+	unsigned int n;
 
-	switch (flags & QCE_MODE_MASK) {
-	case QCE_MODE_ECB:
-		cfg |= ENCR_MODE_ECB << ENCR_MODE_SHIFT;
-		break;
-	case QCE_MODE_CBC:
-		cfg |= ENCR_MODE_CBC << ENCR_MODE_SHIFT;
-		break;
-	case QCE_MODE_CTR:
-		cfg |= ENCR_MODE_CTR << ENCR_MODE_SHIFT;
-		break;
-	case QCE_MODE_XTS:
-		cfg |= ENCR_MODE_XTS << ENCR_MODE_SHIFT;
-		break;
-	case QCE_MODE_CCM:
-		cfg |= ENCR_MODE_CCM << ENCR_MODE_SHIFT;
-		cfg |= LAST_CCM_XFR << LAST_CCM_SHIFT;
-		break;
-	default:
-		return ~0;
+	n = len / sizeof(u32);
+	for (; n > 0; n--) {
+		*d = cpu_to_be32p((const __u32 *) s);
+		s += sizeof(__u32);
+		d++;
 	}
+}
 
-	return cfg;
+static void qce_setup_config(struct qce_device *qce)
+{
+	u32 config;
+
+	/* get big endianness */
+	config = qce_config_reg(qce, 0);
+
+	/* clear status */
+	qce_write(qce, REG_STATUS, 0);
+	qce_write(qce, REG_CONFIG, config);
+}
+
+static inline void qce_crypto_go(struct qce_device *qce)
+{
+	qce_write(qce, REG_GOPROC, BIT(GO_SHIFT) | BIT(RESULTS_DUMP_SHIFT));
 }
 
+#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
 static u32 qce_auth_cfg(unsigned long flags, u32 key_size)
 {
 	u32 cfg = 0;
@@ -137,88 +141,6 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size)
 	return cfg;
 }
 
-static u32 qce_config_reg(struct qce_device *qce, int little)
-{
-	u32 beats = (qce->burst_size >> 3) - 1;
-	u32 pipe_pair = qce->pipe_pair_id;
-	u32 config;
-
-	config = (beats << REQ_SIZE_SHIFT) & REQ_SIZE_MASK;
-	config |= BIT(MASK_DOUT_INTR_SHIFT) | BIT(MASK_DIN_INTR_SHIFT) |
-		  BIT(MASK_OP_DONE_INTR_SHIFT) | BIT(MASK_ERR_INTR_SHIFT);
-	config |= (pipe_pair << PIPE_SET_SELECT_SHIFT) & PIPE_SET_SELECT_MASK;
-	config &= ~HIGH_SPD_EN_N_SHIFT;
-
-	if (little)
-		config |= BIT(LITTLE_ENDIAN_MODE_SHIFT);
-
-	return config;
-}
-
-void qce_cpu_to_be32p_array(__be32 *dst, const u8 *src, unsigned int len)
-{
-	__be32 *d = dst;
-	const u8 *s = src;
-	unsigned int n;
-
-	n = len / sizeof(u32);
-	for (; n > 0; n--) {
-		*d = cpu_to_be32p((const __u32 *) s);
-		s += sizeof(__u32);
-		d++;
-	}
-}
-
-static void qce_xts_swapiv(__be32 *dst, const u8 *src, unsigned int ivsize)
-{
-	u8 swap[QCE_AES_IV_LENGTH];
-	u32 i, j;
-
-	if (ivsize > QCE_AES_IV_LENGTH)
-		return;
-
-	memset(swap, 0, QCE_AES_IV_LENGTH);
-
-	for (i = (QCE_AES_IV_LENGTH - ivsize), j = ivsize - 1;
-	     i < QCE_AES_IV_LENGTH; i++, j--)
-		swap[i] = src[j];
-
-	qce_cpu_to_be32p_array(dst, swap, QCE_AES_IV_LENGTH);
-}
-
-static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
-		       unsigned int enckeylen, unsigned int cryptlen)
-{
-	u32 xtskey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(u32)] = {0};
-	unsigned int xtsklen = enckeylen / (2 * sizeof(u32));
-	unsigned int xtsdusize;
-
-	qce_cpu_to_be32p_array((__be32 *)xtskey, enckey + enckeylen / 2,
-			       enckeylen / 2);
-	qce_write_array(qce, REG_ENCR_XTS_KEY0, xtskey, xtsklen);
-
-	/* xts du size 512B */
-	xtsdusize = min_t(u32, QCE_SECTOR_SIZE, cryptlen);
-	qce_write(qce, REG_ENCR_XTS_DU_SIZE, xtsdusize);
-}
-
-static void qce_setup_config(struct qce_device *qce)
-{
-	u32 config;
-
-	/* get big endianness */
-	config = qce_config_reg(qce, 0);
-
-	/* clear status */
-	qce_write(qce, REG_STATUS, 0);
-	qce_write(qce, REG_CONFIG, config);
-}
-
-static inline void qce_crypto_go(struct qce_device *qce)
-{
-	qce_write(qce, REG_GOPROC, BIT(GO_SHIFT) | BIT(RESULTS_DUMP_SHIFT));
-}
-
 static int qce_setup_regs_ahash(struct crypto_async_request *async_req,
 				u32 totallen, u32 offset)
 {
@@ -303,6 +225,87 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req,
 
 	return 0;
 }
+#endif
+
+#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
+static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
+{
+	u32 cfg = 0;
+
+	if (IS_AES(flags)) {
+		if (aes_key_size == AES_KEYSIZE_128)
+			cfg |= ENCR_KEY_SZ_AES128 << ENCR_KEY_SZ_SHIFT;
+		else if (aes_key_size == AES_KEYSIZE_256)
+			cfg |= ENCR_KEY_SZ_AES256 << ENCR_KEY_SZ_SHIFT;
+	}
+
+	if (IS_AES(flags))
+		cfg |= ENCR_ALG_AES << ENCR_ALG_SHIFT;
+	else if (IS_DES(flags) || IS_3DES(flags))
+		cfg |= ENCR_ALG_DES << ENCR_ALG_SHIFT;
+
+	if (IS_DES(flags))
+		cfg |= ENCR_KEY_SZ_DES << ENCR_KEY_SZ_SHIFT;
+
+	if (IS_3DES(flags))
+		cfg |= ENCR_KEY_SZ_3DES << ENCR_KEY_SZ_SHIFT;
+
+	switch (flags & QCE_MODE_MASK) {
+	case QCE_MODE_ECB:
+		cfg |= ENCR_MODE_ECB << ENCR_MODE_SHIFT;
+		break;
+	case QCE_MODE_CBC:
+		cfg |= ENCR_MODE_CBC << ENCR_MODE_SHIFT;
+		break;
+	case QCE_MODE_CTR:
+		cfg |= ENCR_MODE_CTR << ENCR_MODE_SHIFT;
+		break;
+	case QCE_MODE_XTS:
+		cfg |= ENCR_MODE_XTS << ENCR_MODE_SHIFT;
+		break;
+	case QCE_MODE_CCM:
+		cfg |= ENCR_MODE_CCM << ENCR_MODE_SHIFT;
+		cfg |= LAST_CCM_XFR << LAST_CCM_SHIFT;
+		break;
+	default:
+		return ~0;
+	}
+
+	return cfg;
+}
+
+static void qce_xts_swapiv(__be32 *dst, const u8 *src, unsigned int ivsize)
+{
+	u8 swap[QCE_AES_IV_LENGTH];
+	u32 i, j;
+
+	if (ivsize > QCE_AES_IV_LENGTH)
+		return;
+
+	memset(swap, 0, QCE_AES_IV_LENGTH);
+
+	for (i = (QCE_AES_IV_LENGTH - ivsize), j = ivsize - 1;
+	     i < QCE_AES_IV_LENGTH; i++, j--)
+		swap[i] = src[j];
+
+	qce_cpu_to_be32p_array(dst, swap, QCE_AES_IV_LENGTH);
+}
+
+static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
+		       unsigned int enckeylen, unsigned int cryptlen)
+{
+	u32 xtskey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(u32)] = {0};
+	unsigned int xtsklen = enckeylen / (2 * sizeof(u32));
+	unsigned int xtsdusize;
+
+	qce_cpu_to_be32p_array((__be32 *)xtskey, enckey + enckeylen / 2,
+			       enckeylen / 2);
+	qce_write_array(qce, REG_ENCR_XTS_KEY0, xtskey, xtsklen);
+
+	/* xts du size 512B */
+	xtsdusize = min_t(u32, QCE_SECTOR_SIZE, cryptlen);
+	qce_write(qce, REG_ENCR_XTS_DU_SIZE, xtsdusize);
+}
 
 static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
 				     u32 totallen, u32 offset)
@@ -384,15 +387,20 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
 
 	return 0;
 }
+#endif
 
 int qce_start(struct crypto_async_request *async_req, u32 type, u32 totallen,
 	      u32 offset)
 {
 	switch (type) {
+#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
 	case CRYPTO_ALG_TYPE_SKCIPHER:
 		return qce_setup_regs_skcipher(async_req, totallen, offset);
+#endif
+#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
 	case CRYPTO_ALG_TYPE_AHASH:
 		return qce_setup_regs_ahash(async_req, totallen, offset);
+#endif
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 0a44a6eeacf5..cb6d61eb7302 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -22,8 +22,12 @@
 #define QCE_QUEUE_LENGTH	1
 
 static const struct qce_algo_ops *qce_ops[] = {
+#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
 	&skcipher_ops,
+#endif
+#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
 	&ahash_ops,
+#endif
 };
 
 static void qce_unregister_algs(struct qce_device *qce)
