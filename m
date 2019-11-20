Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA241C432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 770C120872
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:44:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="c/ivMim/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfKTHoi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 02:44:38 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:54372
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727976AbfKTHoh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 02:44:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hW8a1ONgMzTApV/hjhoRjRQrJv5C/cPsCqOc/57wHgD4dcfcQi5HWZ3Rru7/6AE2aETy/AdtDUVXdoac2oSUGyQEgTdq4OTzg28spaF/D+KhtCV2e+Sj1FWg9Pc8M+5XkSjW3Xoc/xGaAOFf1OyDRDCW79uNjDLQwvU/evyH3k7iaBTwe9EIlIDGAHzIqmlp7WWm1m60vicYUdR4Di6UjBVy8+r6EHAjeozru93AUdELSky4MP7iqiySu6xmkGKMzn5F74rYr5zdzEx/M6Pfi9tRUc6gtn7nTxCEh2ll0jwofWu1QPloDuqhA5CVf16i9HbCzMpa63Dr/VyYtYSMJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaJqHyzqWvO+qDqivon2KIeAbdsgS43QLof/VdszZTE=;
 b=AlP5CuSayMjM35wx619qjZh4eJR3wlt+UfC26+Q5SsNCRVCrIyc0KX+cqkXOQYVeUkXDj8VhgMD3mU18tpqzaRFZmltYj92UtCB2LuA6m5YPb1SargYUmBqzRW2uiIHKObRBY5hUi24PX+LwmcPX9NeNwzs/LBWr8NUSL+IN6Cb1dhV+asfnuS5tT4lIdu0iQ9BYtDmVLB3uWByDkHbwMkjG3knyIgUjxEpgp37HxUMsVRjfDilwfL3Jk6RjvqFEbDQ6aesAZrWHzRpV7BM2Q4tfkm7dncXzewV876W1gDYtAHWGvDOSMNTJLOSxAE/vgZ1eVw9sx2xRgqjoN5TdJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaJqHyzqWvO+qDqivon2KIeAbdsgS43QLof/VdszZTE=;
 b=c/ivMim/TRyog3PrTgMq4wRqrUNE9V1R/4+3pj98odwxMzsHsNgiWqMQ6hctdNogQc0ux1aaSx1cfSd+P8MNHcH6AN+jD4syBUGVFdxc5N6ckx/1z6yrrfbRv9NJG73OFsVwwyudjxdgZU9VE8mHFOR1j2Yq6oY6OcWnRRdBavc=
Received: from BN7PR02CA0018.namprd02.prod.outlook.com (2603:10b6:408:20::31)
 by SN6PR02MB4126.namprd02.prod.outlook.com (2603:10b6:805:2d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.16; Wed, 20 Nov
 2019 07:44:30 +0000
Received: from SN1NAM02FT004.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by BN7PR02CA0018.outlook.office365.com
 (2603:10b6:408:20::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17 via Frontend
 Transport; Wed, 20 Nov 2019 07:44:30 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT004.mail.protection.outlook.com (10.152.72.175) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2474.17
 via Frontend Transport; Wed, 20 Nov 2019 07:44:30 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iXKf7-0006HY-Oy; Tue, 19 Nov 2019 23:44:29 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iXKf2-0003nV-Jc; Tue, 19 Nov 2019 23:44:24 -0800
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iXKes-0003mF-Fa; Tue, 19 Nov 2019 23:44:14 -0800
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id C24F58600D; Wed, 20 Nov 2019 13:14:13 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan <mohand@xilinx.com>, Kalyani Akul <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V4 4/4] crypto: Add Xilinx AES driver
Date:   Wed, 20 Nov 2019 13:14:02 +0530
Message-Id: <1574235842-7930-5-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(189003)(199004)(476003)(81156014)(81166006)(2616005)(498600001)(50226002)(8676002)(446003)(42186006)(8936002)(16586007)(30864003)(50466002)(11346002)(103686004)(76176011)(2906002)(70586007)(44832011)(6666004)(356004)(305945005)(336012)(426003)(5660300002)(6266002)(4326008)(486006)(14444005)(106002)(450100002)(54906003)(36386004)(126002)(51416003)(48376002)(47776003)(70206006)(186003)(36756003)(107886003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB4126;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43096f28-bc26-421e-88e7-08d76d8d7a24
X-MS-TrafficTypeDiagnostic: SN6PR02MB4126:
X-Microsoft-Antispam-PRVS: <SN6PR02MB4126A72236D5E0DF062886CCAF4F0@SN6PR02MB4126.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:398;
X-Forefront-PRVS: 02272225C5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GMarR0Etn5ST8hBlC3vj8row4P4e2z+GWFqVHswKUvwqkKdgka0l0ZRMgYlBPN7C+P1EdYqlVO2POwMTueUx3b/wYD8tBFFV9Pob3sGbhP7BBDydjYYCxYTCp6QWunGdsOsVQNoCIzo6D1vRxPcDZlhYcQ/4yLDV7UzvmBKpetfrRsRmpkucq2GwzjiTY7dfO2B104pwKOb3yl+Yva7HAeCQIefWF/yt5xAKPyQfh/cQaCmy+rfp5ZJjyfqRW+MJRc627j5lMKFKamqrlmWaLsqkcJuHddIW4XPz4JQ0I6/QBFGgnFgLwLu1dH3dxsmJZeUdWzXOPW7ga0OdEkQ7wqoBaYbbQuKoUMCK3Zq3bIbbPRturTwKZz21na8+54xWwvcCN4Bzf5OHZJIiOeikcW6M/EJbku8YAIuErH698EVYTR0zcaozFNYro+FYPw+j
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2019 07:44:30.1404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43096f28-bc26-421e-88e7-08d76d8d7a24
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4126
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds AES driver support for the Xilinx ZynqMP SoC.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 drivers/crypto/Kconfig                 |  11 +
 drivers/crypto/Makefile                |   1 +
 drivers/crypto/xilinx/Makefile         |   3 +
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 469 +++++++++++++++++++++++++++++++++
 4 files changed, 484 insertions(+)
 create mode 100644 drivers/crypto/xilinx/Makefile
 create mode 100644 drivers/crypto/xilinx/zynqmp-aes-gcm.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1fb622f..8e7d3a9 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -696,6 +696,17 @@ config CRYPTO_DEV_ROCKCHIP
 	help
 	  This driver interfaces with the hardware crypto accelerator.
 	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
+config CRYPTO_DEV_ZYNQMP_AES
+	tristate "Support for Xilinx ZynqMP AES hw accelerator"
+	depends on ARCH_ZYNQMP || COMPILE_TEST
+	select CRYPTO_AES
+	select CRYPTO_ENGINE
+	select CRYPTO_AEAD
+	help
+	  Xilinx ZynqMP has AES-GCM engine used for symmetric key
+	  encryption and decryption. This driver interfaces with AES hw
+	  accelerator. Select this if you want to use the ZynqMP module
+	  for AES algorithms.
 
 config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index afc4753..50184377 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -47,4 +47,5 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
+obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += xilinx/
 obj-y += hisilicon/
diff --git a/drivers/crypto/xilinx/Makefile b/drivers/crypto/xilinx/Makefile
new file mode 100644
index 0000000..16bdda7
--- /dev/null
+++ b/drivers/crypto/xilinx/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += zynqmp-aes-gcm.o
+
diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
new file mode 100644
index 0000000..534105b
--- /dev/null
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -0,0 +1,469 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Xilinx ZynqMP AES Driver.
+ * Copyright (c) 2019 Xilinx Inc.
+ */
+
+#include <crypto/aes.h>
+#include <crypto/engine.h>
+#include <crypto/gcm.h>
+#include <crypto/internal/aead.h>
+#include <crypto/scatterwalk.h>
+
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+
+#include <linux/firmware/xlnx-zynqmp.h>
+
+#define DRIVER_NAME		"zynqmp-aes"
+#define ZYNQMP_DMA_BIT_MASK	32U
+
+#define ZYNQMP_AES_KEY_SIZE		AES_KEYSIZE_256
+#define ZYNQMP_AES_AUTH_SIZE		16U
+#define ZYNQMP_KEY_SRC_SEL_KEY_LEN	1U
+#define ZYNQMP_AES_BLK_SIZE		1U
+#define ZYNQMP_AES_MIN_INPUT_BLK_SIZE	4U
+#define ZYNQMP_AES_WORD_LEN		4U
+
+#define ZYNQMP_AES_GCM_TAG_MISMATCH_ERR		0x01
+#define ZYNQMP_AES_WRONG_KEY_SRC_ERR		0x13
+#define ZYNQMP_AES_PUF_NOT_PROGRAMMED		0xE300
+
+enum zynqmp_aead_op {
+	ZYNQMP_AES_DECRYPT = 0,
+	ZYNQMP_AES_ENCRYPT
+};
+
+enum zynqmp_aead_keysrc {
+	ZYNQMP_AES_KUP_KEY = 0,
+	ZYNQMP_AES_DEV_KEY,
+	ZYNQMP_AES_PUF_KEY
+};
+
+struct zynqmp_aead_drv_ctx {
+	union {
+		struct aead_alg aead;
+	} alg;
+	struct device *dev;
+	struct crypto_engine *engine;
+	const struct zynqmp_eemi_ops *eemi_ops;
+};
+
+struct zynqmp_aead_hw_req {
+	u64 src;
+	u64 iv;
+	u64 key;
+	u64 dst;
+	u64 size;
+	u64 op;
+	u64 keysrc;
+};
+
+struct zynqmp_aead_tfm_ctx {
+	struct crypto_engine_ctx engine_ctx;
+	struct device *dev;
+	u8 key[ZYNQMP_AES_KEY_SIZE];
+	u8 *iv;
+	u32 keylen;
+	u32 authsize;
+	enum zynqmp_aead_keysrc keysrc;
+	struct crypto_aead *fbk_cipher;
+};
+
+struct zynqmp_aead_req_ctx {
+	enum zynqmp_aead_op op;
+};
+
+static int zynqmp_aes_aead_cipher(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct device *dev = tfm_ctx->dev;
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct zynqmp_aead_hw_req *hwreq;
+	dma_addr_t dma_addr_data, dma_addr_hw_req;
+	unsigned int data_size;
+	unsigned int status;
+	size_t dma_size;
+	char *kbuf;
+	int err;
+
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
+
+	if (!drv_ctx->eemi_ops->aes)
+		return -ENOTSUPP;
+
+	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY)
+		dma_size = req->cryptlen + ZYNQMP_AES_KEY_SIZE
+			   + GCM_AES_IV_SIZE;
+	else
+		dma_size = req->cryptlen + GCM_AES_IV_SIZE;
+
+	kbuf = dma_alloc_coherent(dev, dma_size, &dma_addr_data, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	hwreq = dma_alloc_coherent(dev, sizeof(struct zynqmp_aead_hw_req),
+				   &dma_addr_hw_req, GFP_KERNEL);
+	if (!hwreq) {
+		dma_free_coherent(dev, dma_size, kbuf, dma_addr_data);
+		return -ENOMEM;
+	}
+
+	data_size = req->cryptlen;
+	scatterwalk_map_and_copy(kbuf, req->src, 0, req->cryptlen, 0);
+	memcpy(kbuf + data_size, req->iv, GCM_AES_IV_SIZE);
+
+	hwreq->src = dma_addr_data;
+	hwreq->dst = dma_addr_data;
+	hwreq->iv = hwreq->src + data_size;
+	hwreq->keysrc = tfm_ctx->keysrc;
+	hwreq->op = rq_ctx->op;
+
+	if (hwreq->op == ZYNQMP_AES_ENCRYPT)
+		hwreq->size = data_size;
+	else
+		hwreq->size = data_size - ZYNQMP_AES_AUTH_SIZE;
+
+	if (hwreq->keysrc == ZYNQMP_AES_KUP_KEY) {
+		memcpy(kbuf + data_size + GCM_AES_IV_SIZE,
+		       tfm_ctx->key, ZYNQMP_AES_KEY_SIZE);
+
+		hwreq->key = hwreq->src + data_size + GCM_AES_IV_SIZE;
+	} else {
+		hwreq->key = 0;
+	}
+
+	drv_ctx->eemi_ops->aes(dma_addr_hw_req, &status);
+
+	if (status) {
+		switch (status) {
+		case ZYNQMP_AES_GCM_TAG_MISMATCH_ERR:
+			dev_err(dev, "ERROR: Gcm Tag mismatch\n");
+			break;
+		case ZYNQMP_AES_WRONG_KEY_SRC_ERR:
+			dev_err(dev, "ERROR: Wrong KeySrc, enable secure mode\n");
+			break;
+		case ZYNQMP_AES_PUF_NOT_PROGRAMMED:
+			dev_err(dev, "ERROR: PUF is not registered\n");
+			break;
+		default:
+			dev_err(dev, "ERROR: Unknown error\n");
+			break;
+		}
+		err = -status;
+	} else {
+		if (hwreq->op == ZYNQMP_AES_ENCRYPT)
+			data_size = data_size + ZYNQMP_AES_AUTH_SIZE;
+		else
+			data_size = data_size - ZYNQMP_AES_AUTH_SIZE;
+
+		sg_copy_from_buffer(req->dst, sg_nents(req->dst),
+				    kbuf, data_size);
+		err = 0;
+	}
+
+	if (kbuf) {
+		memzero_explicit(kbuf, dma_size);
+		dma_free_coherent(dev, dma_size, kbuf, dma_addr_data);
+	}
+	if (hwreq) {
+		memzero_explicit(hwreq, sizeof(struct zynqmp_aead_hw_req));
+		dma_free_coherent(dev, sizeof(struct zynqmp_aead_hw_req),
+				  hwreq, dma_addr_hw_req);
+	}
+	return err;
+}
+
+static int zynqmp_fallback_check(struct zynqmp_aead_tfm_ctx *tfm_ctx,
+				 struct aead_request *req)
+{
+	int need_fallback = 0;
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+
+	if (tfm_ctx->authsize != ZYNQMP_AES_AUTH_SIZE)
+		need_fallback = 1;
+
+	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY &&
+	    tfm_ctx->keylen != ZYNQMP_AES_KEY_SIZE) {
+		need_fallback = 1;
+	}
+	if (req->assoclen != 0 ||
+	    req->cryptlen < ZYNQMP_AES_MIN_INPUT_BLK_SIZE) {
+		need_fallback = 1;
+	}
+	if ((req->cryptlen % ZYNQMP_AES_WORD_LEN) != 0)
+		need_fallback = 1;
+
+	if (rq_ctx->op == ZYNQMP_AES_DECRYPT &&
+	    req->cryptlen <= ZYNQMP_AES_AUTH_SIZE) {
+		need_fallback = 1;
+	}
+	return need_fallback;
+}
+
+static int zynqmp_handle_aes_req(struct crypto_engine *engine,
+				 void *req)
+{
+	struct aead_request *areq =
+				container_of(req, struct aead_request, base);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(areq);
+	struct aead_request *subreq = aead_request_ctx(req);
+	int need_fallback;
+	int err;
+
+	need_fallback = zynqmp_fallback_check(tfm_ctx, areq);
+
+	if (need_fallback) {
+		aead_request_set_tfm(subreq, tfm_ctx->fbk_cipher);
+
+		aead_request_set_callback(subreq, areq->base.flags,
+					  NULL, NULL);
+		aead_request_set_crypt(subreq, areq->src, areq->dst,
+				       areq->cryptlen, areq->iv);
+		aead_request_set_ad(subreq, areq->assoclen);
+		if (rq_ctx->op == ZYNQMP_AES_ENCRYPT)
+			err = crypto_aead_encrypt(subreq);
+		else
+			err = crypto_aead_decrypt(subreq);
+	} else {
+		err = zynqmp_aes_aead_cipher(areq);
+	}
+
+	crypto_finalize_aead_request(engine, areq, err);
+	return 0;
+}
+
+static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
+				  unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx =
+			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	unsigned char keysrc;
+	int err;
+
+	if (keylen == ZYNQMP_KEY_SRC_SEL_KEY_LEN) {
+		keysrc = *key;
+		if (keysrc == ZYNQMP_AES_KUP_KEY ||
+		    keysrc == ZYNQMP_AES_DEV_KEY ||
+		    keysrc == ZYNQMP_AES_PUF_KEY) {
+			tfm_ctx->keysrc = (enum zynqmp_aead_keysrc)keysrc;
+		} else {
+			tfm_ctx->keylen = keylen;
+		}
+	} else {
+		tfm_ctx->keylen = keylen;
+		if (keylen == ZYNQMP_AES_KEY_SIZE) {
+			tfm_ctx->keysrc = ZYNQMP_AES_KUP_KEY;
+			memcpy(tfm_ctx->key, key, keylen);
+		}
+	}
+
+	tfm_ctx->fbk_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	tfm_ctx->fbk_cipher->base.crt_flags |= (aead->base.crt_flags &
+					CRYPTO_TFM_REQ_MASK);
+
+	err = crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
+	if (err) {
+		aead->base.crt_flags &= ~CRYPTO_TFM_RES_MASK;
+		aead->base.crt_flags |=
+				(tfm_ctx->fbk_cipher->base.crt_flags &
+				 CRYPTO_TFM_RES_MASK);
+	}
+
+	return err;
+}
+
+static int zynqmp_aes_aead_setauthsize(struct crypto_aead *aead,
+				       unsigned int authsize)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx =
+			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+
+	tfm_ctx->authsize = authsize;
+	return crypto_aead_setauthsize(tfm_ctx->fbk_cipher, authsize);
+}
+
+static int zynqmp_aes_aead_encrypt(struct aead_request *req)
+{
+	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+
+	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
+
+	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
+}
+
+static int zynqmp_aes_aead_decrypt(struct aead_request *req)
+{
+	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+
+	rq_ctx->op = ZYNQMP_AES_DECRYPT;
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
+
+	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
+}
+
+static int zynqmp_aes_aead_init(struct crypto_aead *aead)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx =
+		(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct aead_alg *alg = crypto_aead_alg(aead);
+
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
+	tfm_ctx->dev = drv_ctx->dev;
+
+	tfm_ctx->engine_ctx.op.do_one_request = zynqmp_handle_aes_req;
+	tfm_ctx->engine_ctx.op.prepare_request = NULL;
+	tfm_ctx->engine_ctx.op.unprepare_request = NULL;
+
+	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->alg.aead.base.cra_name,
+						0,
+						CRYPTO_ALG_NEED_FALLBACK);
+
+	if (IS_ERR(tfm_ctx->fbk_cipher)) {
+		pr_err("%s() Error: failed to allocate fallback for %s\n",
+		       __func__, drv_ctx->alg.aead.base.cra_name);
+		return PTR_ERR(tfm_ctx->fbk_cipher);
+	}
+
+	crypto_aead_set_reqsize(aead,
+				max(sizeof(struct zynqmp_aead_req_ctx),
+				    sizeof(struct aead_request) +
+				    crypto_aead_reqsize(tfm_ctx->fbk_cipher)));
+	return 0;
+}
+
+static void zynqmp_aes_aead_exit(struct crypto_aead *aead)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx =
+			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
+
+	if (tfm_ctx->fbk_cipher) {
+		crypto_free_aead(tfm_ctx->fbk_cipher);
+		tfm_ctx->fbk_cipher = NULL;
+	}
+	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_aead_tfm_ctx));
+}
+
+static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
+	.alg.aead = {
+		.setkey		= zynqmp_aes_aead_setkey,
+		.setauthsize	= zynqmp_aes_aead_setauthsize,
+		.encrypt	= zynqmp_aes_aead_encrypt,
+		.decrypt	= zynqmp_aes_aead_decrypt,
+		.init		= zynqmp_aes_aead_init,
+		.exit		= zynqmp_aes_aead_exit,
+		.ivsize		= GCM_AES_IV_SIZE,
+		.maxauthsize	= ZYNQMP_AES_AUTH_SIZE,
+		.base = {
+		.cra_name		= "gcm(aes)",
+		.cra_driver_name	= "xilinx-zynqmp-aes-gcm",
+		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
+					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= ZYNQMP_AES_BLK_SIZE,
+		.cra_ctxsize		= sizeof(struct zynqmp_aead_tfm_ctx),
+		.cra_module		= THIS_MODULE,
+		}
+	}
+};
+
+static int zynqmp_aes_aead_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	int err = -1;
+
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	/* ZynqMp AES driver supports only one instance */
+	if (!aes_drv_ctx.dev)
+		aes_drv_ctx.dev = dev;
+
+	aes_drv_ctx.eemi_ops = zynqmp_pm_get_eemi_ops();
+	if (IS_ERR(aes_drv_ctx.eemi_ops)) {
+		dev_err(dev, "Failed to get ZynqMP EEMI interface\n");
+		return PTR_ERR(aes_drv_ctx.eemi_ops);
+	}
+
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(ZYNQMP_DMA_BIT_MASK));
+	if (err < 0) {
+		dev_err(dev, "No usable DMA configuration\n");
+		return err;
+	}
+
+	aes_drv_ctx.engine = crypto_engine_alloc_init(dev, 1);
+	if (!aes_drv_ctx.engine) {
+		dev_err(dev, "Cannot alloc AES engine\n");
+		err = -ENOMEM;
+		goto err_engine;
+	}
+
+	err = crypto_engine_start(aes_drv_ctx.engine);
+	if (err) {
+		dev_err(dev, "Cannot start AES engine\n");
+		goto err_engine;
+	}
+
+	err = crypto_register_aead(&aes_drv_ctx.alg.aead);
+	if (err < 0) {
+		dev_err(dev, "Failed to register AEAD alg.\n");
+		goto err_aead;
+	}
+	return 0;
+
+err_aead:
+	crypto_unregister_aead(&aes_drv_ctx.alg.aead);
+
+err_engine:
+	if (aes_drv_ctx.engine)
+		crypto_engine_exit(aes_drv_ctx.engine);
+
+	return err;
+}
+
+static int zynqmp_aes_aead_remove(struct platform_device *pdev)
+{
+	crypto_engine_exit(aes_drv_ctx.engine);
+	crypto_unregister_aead(&aes_drv_ctx.alg.aead);
+	return 0;
+}
+
+static const struct of_device_id zynqmp_aes_dt_ids[] = {
+	{ .compatible = "xlnx,zynqmp-aes" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, zynqmp_aes_dt_ids);
+
+static struct platform_driver zynqmp_aes_driver = {
+	.probe	= zynqmp_aes_aead_probe,
+	.remove = zynqmp_aes_aead_remove,
+	.driver = {
+		.name		= DRIVER_NAME,
+		.of_match_table = zynqmp_aes_dt_ids,
+	},
+};
+
+module_platform_driver(zynqmp_aes_driver);
+
+MODULE_LICENSE("GPL");
+
-- 
1.9.5

