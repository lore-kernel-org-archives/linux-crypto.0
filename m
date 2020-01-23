Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8EDC2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD7B024683
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="oUB43KQf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAWLMV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 06:12:21 -0500
Received: from mail-bn7nam10on2074.outbound.protection.outlook.com ([40.107.92.74]:26342
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbgAWLMV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 06:12:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HK6fYo23h1KPhhqkGv7B7JewkHxVR0NxjyQDpE06jLM9bSP6+GcYnPJ3cy0aoDVhFl833+f7Pp+pc4gGHWaZsUCVRtdTtyyzNVummltm03U86h0YLu1mDcHxmc6SfbZ5uBXSyDElEMXE3WTBGP9k+Ilkkw2Xw9460228swxeK4PRJjk+0KSrAcs/pRGur5z5bujv4QD+Okfj4obiryYA9HDa/fZ7zcB3twPcvWUT4oO5Vg0zw1MCZF7QTMrzqHE2MQeKiw1hWxdcfTdJQmMxNyuB6YUaeyNAevdxn8XsX6GgJaClMHdkX2NAK56PxaYMqICWAllB6Qd4d/s1QwwtHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ueyletyDUvX1fgn5iwSNDIdOYyQ0ydBiCaei+0fRcs=;
 b=DlEui61DfCW4IjcgLktfa5MF3bFeHktHN+7Bu2SENWQomdni1K9hVXeHtiZIh/iTh+VcftNUbiLLMU9d656iOjlFWQEEKr/WzcAW0FSYjPthCr1FLMqFA1M21q+qeZ43P8R2x91hbw7tff/1xfaVs1LNnU8XyJzt4M9k41ESlcSqeiHIBGmQAPcvTBTPFJ9NNtiikJmCg7VmHk90zOzoVNiiEHGpI841IfNIU8mkn637YG0Wv7uyVEJWfkAK5Z51ykcbiYZvYvWV9b74EMNKb99lxZIp9fZEJHq2eZz6uAuuL0ylBEovWW3EAZCtxwElsu0y4hmyGjHNexTcHDu+xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ueyletyDUvX1fgn5iwSNDIdOYyQ0ydBiCaei+0fRcs=;
 b=oUB43KQfuIoPAIY1k8lsEQdIXa3ro/gIWHvQSdP28aGvvqQINaCxmJikw5Ns10HtZsCSDgYH93lr05MeGX4JSYSnGZkTfGrbil9sXfNaCuRWS3tN3Odq6cyEP3JXQIE90oYmSFD7osPLM5Qc0qXfBghuMmEMPlOOOvtKAbkl7W8=
Received: from SN4PR0201CA0036.namprd02.prod.outlook.com
 (2603:10b6:803:2e::22) by CY4PR02MB2710.namprd02.prod.outlook.com
 (2603:10b6:903:11c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.23; Thu, 23 Jan
 2020 11:12:14 +0000
Received: from CY1NAM02FT059.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::202) by SN4PR0201CA0036.outlook.office365.com
 (2603:10b6:803:2e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend
 Transport; Thu, 23 Jan 2020 11:12:14 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT059.mail.protection.outlook.com (10.152.74.211) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Thu, 23 Jan 2020 11:12:13 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iuaPF-0007hd-06; Thu, 23 Jan 2020 03:12:13 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iuaP9-0007cp-Sg; Thu, 23 Jan 2020 03:12:07 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iuaP8-0007cR-79; Thu, 23 Jan 2020 03:12:06 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 198FE800C1; Thu, 23 Jan 2020 16:41:26 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net, monstr@seznam.cz,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        git-dev <git-dev@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>,
        Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>
Subject: [PATCH V5 3/4] crypto: Add Xilinx AES driver
Date:   Thu, 23 Jan 2020 16:41:16 +0530
Message-Id: <1579777877-10553-4-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1579777877-10553-1-git-send-email-kalyani.akula@xilinx.com>
References: <1579777877-10553-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(136003)(346002)(199004)(189003)(478600001)(81166006)(44832011)(36756003)(316002)(42186006)(2616005)(8936002)(81156014)(5660300002)(4326008)(54906003)(2906002)(107886003)(6266002)(336012)(30864003)(426003)(70586007)(70206006)(26005)(186003)(6666004)(356004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR02MB2710;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15f3311d-d3b3-45d3-60c6-08d79ff51987
X-MS-TrafficTypeDiagnostic: CY4PR02MB2710:
X-Microsoft-Antispam-PRVS: <CY4PR02MB2710CEACA8C3CDA1331B5C1CAF0F0@CY4PR02MB2710.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-Forefront-PRVS: 029174C036
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UqJ4pB40uw5rxifJmFLUz0dqE6+AWQ0SONQLlSehU10MUmg29N8wT7zFxRDqHHv3pNt0OQ/oKYgA++gNwJrMEOttaw9id54taCxA5e2lqYwtAwd0Ri52t1JUWdN48jIm2MHI/QX3o4Ek9FXYIWSWbxCDdfD1Ir0vEEysJZsc81MYn386tRZPOsa9WVHdAHKkg4/2NCJo512Aa6wg2RxNvImqaxsQXbFoSwQpzHYrg9IiNj7sn2gT3FGqMYFoUCWABCN14pEVxzihQpHaQ7SEvabN+pvp868ezQd9KWVVZ2x0tDhefXtfEg8c+Jt5dhhe32CLWHwJE+yHPcATgIZpEX1krx80Ooclwr/Ns6gFdSt9oxtbj/2kB01oQU3rOpnMfS7KpuS0f/1zaswr+7+diks9J83xNfe35arWLty9IXrTz/SpfJKSOqBDiG/tcYn5
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2020 11:12:13.7743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15f3311d-d3b3-45d3-60c6-08d79ff51987
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB2710
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds AES driver support for the Xilinx ZynqMP SoC.

Signed-off-by: Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>
Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---

V5 Changes:
- Replaced ARCH_ZYNQMP with ZYNQMP_FIRMWARE in Kconfig
- Removed extra new lines. 
- Moved crypto: Add Xilinx AES driver patch from 4/4 to 3/4.
- Updated Signed-off-by sequence.

V4 Changes :
- Addressed review comments.

V3 Changes :
- Added software fallback in cases where Hardware doesn't have
  the capability to handle the request.
- Removed use of global variable for storing the driver data.

V2 Changes :
- Converted RFC PATCH to PATCH
- Removed ALG_SET_KEY_TYPE that was added to support keytype
  attribute. Taken using setkey interface.
- Removed deprecated BLKCIPHER in Kconfig
- Erased Key/IV from the buffer.
- Renamed zynqmp-aes driver to zynqmp-aes-gcm.
- Addressed few other review comments


 drivers/crypto/Kconfig                 |  12 +
 drivers/crypto/Makefile                |   1 +
 drivers/crypto/xilinx/Makefile         |   2 +
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 466 +++++++++++++++++++++++++++++++++
 4 files changed, 481 insertions(+)
 create mode 100644 drivers/crypto/xilinx/Makefile
 create mode 100644 drivers/crypto/xilinx/zynqmp-aes-gcm.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 91eb768..f41e4eb 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -676,6 +676,18 @@ config CRYPTO_DEV_ROCKCHIP
 	  This driver interfaces with the hardware crypto accelerator.
 	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
 
+config CRYPTO_DEV_ZYNQMP_AES
+	tristate "Support for Xilinx ZynqMP AES hw accelerator"
+	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
+	select CRYPTO_AES
+	select CRYPTO_ENGINE
+	select CRYPTO_AEAD
+	help
+	  Xilinx ZynqMP has AES-GCM engine used for symmetric key
+	  encryption and decryption. This driver interfaces with AES hw
+	  accelerator. Select this if you want to use the ZynqMP module
+	  for AES algorithms.
+
 config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 40229d4..d505d16 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -47,5 +47,6 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
+obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += xilinx/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
diff --git a/drivers/crypto/xilinx/Makefile b/drivers/crypto/xilinx/Makefile
new file mode 100644
index 0000000..534e32d
--- /dev/null
+++ b/drivers/crypto/xilinx/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += zynqmp-aes-gcm.o
diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
new file mode 100644
index 0000000..ca82da5
--- /dev/null
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -0,0 +1,466 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Xilinx ZynqMP AES Driver.
+ * Copyright (c) 2020 Xilinx Inc.
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
+	int err;
+
+	/* ZynqMP AES driver supports only one instance */
+	if (!aes_drv_ctx.dev)
+		aes_drv_ctx.dev = dev;
+	else
+		return -ENODEV;
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
+
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
+		.name		= "zynqmp-aes",
+		.of_match_table = zynqmp_aes_dt_ids,
+	},
+};
+
+module_platform_driver(zynqmp_aes_driver);
+MODULE_LICENSE("GPL");
-- 
1.9.5

