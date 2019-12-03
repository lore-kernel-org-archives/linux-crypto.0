Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D0BC432C3
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 05:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 744F4206E0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 05:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="fs29p293"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfLCFco (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 00:32:44 -0500
Received: from mail-eopbgr680088.outbound.protection.outlook.com ([40.107.68.88]:46414
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727127AbfLCFcn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 00:32:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7+ohuDN6gaciM1qJKMpEIXrTWeyDCWxQo2tkT5p/xPKt6ZSGeOjKJ18W8GumYHA0OIxyA0hWW/TQfRLBlYoWxOVFxHfBlqZveY1aHmqIXjxnXBIg369mnoxpiaZq8OjX+Po0RVF7VUAev2LMklCFcbcywoTcw2C20bIUizA2ZUyWva8nXLVZEGAzq6yc1hI9yNtRgHf5wAYA8SzESCsALbmL/gNaA+HIVOuy3d+0Wdewp2EJkv3CfKJkUhT6kR98co4hUNGEywEPQWV0Jg+i03fza0NMfeJnwsDPRLR8Ou2/6kdNzRPk4DXXTScHtnkzbqljhwRZ5LsJY9PumT9Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4XD5hAhqMgNiPoU6VxiBcvHcktkCvxlrCVD7SgPmow=;
 b=HzBves84s1bb9O22Vw2TsQxKWcjVBsJONNuX31Yfp9rT/XbUcSiBtnEOp7/1/d0ed950hMEijDCzx56162/Xyd/8vq4xyrlEh0s85fWPZmgoF3BrYxBaSyNxSHu2KvxrQJ2+XmKnb8iy00ej9eZTVk//Hu2zFvhZM9j4RSrj5+e8RdGOGEFUQimSpw3H+tuKdj+jmsWwttBn5HUdNLFkQxLFRi1Rqs03rc6weDPyUImudxm26Ru9+HOFelAYpRS/aFFemf1pmpccIjy+ibJHE0vj5yIWj2am6adWdK8BPxI+O39VkZBVYOjYaDh7lk0k3ovhusiG2ODu2p06rKw6ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4XD5hAhqMgNiPoU6VxiBcvHcktkCvxlrCVD7SgPmow=;
 b=fs29p293GcZkAW2+UgCRB7ZL7nvZA58/XflbfwIXgU7MbQJGfgySoGesV0Shubw6L1Pc/fMEaK3fZOXi8C6T7a1MHQBQwyyXWDerAio7B1uSFcqDOPeBG7SKISa4bGBvG0Jdovf1ugt2GNSOpQUQjLs4TKS8UwGuuHarPZGI0RA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1719.namprd12.prod.outlook.com (10.175.80.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Tue, 3 Dec 2019 05:32:40 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2495.014; Tue, 3 Dec 2019
 05:32:40 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH v2 6/6] crypto: ccp - provide in-kernel API to submit TEE commands
Date:   Tue,  3 Dec 2019 10:09:21 +0530
Message-Id: <e599f6d4105ccd9ff2d18088ec78feacf89ca5fc.1575282249.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1575282249.git.Rijo-john.Thomas@amd.com>
References: <cover.1575282249.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0006.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::16) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: da97986d-4e35-4212-7072-08d777b23678
X-MS-TrafficTypeDiagnostic: CY4PR12MB1719:|CY4PR12MB1719:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1719EA2CCF8865F6434FD542CF420@CY4PR12MB1719.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 02408926C4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(305945005)(47776003)(2906002)(446003)(66066001)(7736002)(6116002)(3846002)(8676002)(6666004)(81156014)(81166006)(5660300002)(118296001)(66476007)(66556008)(66946007)(8936002)(6512007)(26005)(110136005)(16586007)(316002)(54906003)(99286004)(36756003)(11346002)(50226002)(6436002)(6486002)(4326008)(14454004)(25786009)(2616005)(14444005)(478600001)(6506007)(386003)(186003)(86362001)(50466002)(52116002)(48376002)(76176011)(51416003)(134885004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1719;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 85StoM7LjxrgEBC486uUvMnedMngLHHrMbDTUZl75gOQlS+aolCdAmEb/SFaoMIwB2POsD2jB7T7QQAZ2k7Zd1e55RmOubdWbOx0lftQUUC0UADpS9s+67l1x/CTzLAbqB0KyIBGpLP4GmK47+N4SXtO4TUon6xINnIKc7mSdGs7bKSaanqGRoMgB3oTXkSbaxV0fiVT7VLmK1B0SLFTD6HHsHZ6S69fQrPioO+Ap7fruXXAxCfIEH7+JdnwVbJtkmPq+h46EuDze0o7sknYbnwf9IQyCnVzLWbW3e66BW20D9eHyXPRC1swAHIvuZ/D4V0Hw78lc3U+YUQF8dGlzu4BzGHZz70z4V4pXkkSiQdkRk9YTGQE1f0mgUZDCcHZYqI+YBtdcKpLBPpkYF5dVekHZeufKmrbWMn++O15UaA0J9cnE1y0a4ASnNDudII0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da97986d-4e35-4212-7072-08d777b23678
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2019 05:32:40.2849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oucWGfBa2C55ZvtvW190C0VQYON1bkcld5TlTAMnb6X7s56IvDyOwQY11NHGEAxsX1pmEJ/slKCZOGTcuUzyXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1719
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend the functionality of AMD Secure Processor (SP) driver by
providing an in-kernel API to submit commands to TEE ring buffer for
processing by Trusted OS running on AMD Secure Processor.

Following TEE commands are supported by Trusted OS:

* TEE_CMD_ID_LOAD_TA : Load Trusted Application (TA) binary into
  TEE environment
* TEE_CMD_ID_UNLOAD_TA : Unload TA binary from TEE environment
* TEE_CMD_ID_OPEN_SESSION : Open session with loaded TA
* TEE_CMD_ID_CLOSE_SESSION : Close session with loaded TA
* TEE_CMD_ID_INVOKE_CMD : Invoke a command with loaded TA
* TEE_CMD_ID_MAP_SHARED_MEM : Map shared memory
* TEE_CMD_ID_UNMAP_SHARED_MEM : Unmap shared memory

Linux AMD-TEE driver will use this API to submit command buffers
for processing in Trusted Execution Environment. The AMD-TEE driver
shall be introduced in a separate patch.

Cc: Jens Wiklander <jens.wiklander@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/tee-dev.c | 126 +++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/tee-dev.h |   1 +
 include/linux/psp-tee.h      |  73 +++++++++++++++++++++++++
 3 files changed, 200 insertions(+)
 create mode 100644 include/linux/psp-tee.h

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index ccbc2ce..555c8a7 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/gfp.h>
 #include <linux/psp-sev.h>
+#include <linux/psp-tee.h>
 
 #include "psp-dev.h"
 #include "tee-dev.h"
@@ -38,6 +39,7 @@ static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
 	rb_mgr->ring_start = start_addr;
 	rb_mgr->ring_size = ring_size;
 	rb_mgr->ring_pa = __psp_pa(start_addr);
+	mutex_init(&rb_mgr->mutex);
 
 	return 0;
 }
@@ -55,6 +57,7 @@ static void tee_free_ring(struct psp_tee_device *tee)
 	rb_mgr->ring_start = NULL;
 	rb_mgr->ring_size = 0;
 	rb_mgr->ring_pa = 0;
+	mutex_destroy(&rb_mgr->mutex);
 }
 
 static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int timeout,
@@ -236,3 +239,126 @@ void tee_dev_destroy(struct psp_device *psp)
 
 	tee_destroy_ring(tee);
 }
+
+static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
+			  void *buf, size_t len, struct tee_ring_cmd **resp)
+{
+	struct tee_ring_cmd *cmd;
+	u32 rptr, wptr;
+	int nloop = 1000, ret = 0;
+
+	*resp = NULL;
+
+	mutex_lock(&tee->rb_mgr.mutex);
+
+	wptr = tee->rb_mgr.wptr;
+
+	/* Check if ring buffer is full */
+	do {
+		rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
+
+		if (!(wptr + sizeof(struct tee_ring_cmd) == rptr))
+			break;
+
+		dev_info(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u\n",
+			 rptr, wptr);
+
+		/* Wait if ring buffer is full */
+		mutex_unlock(&tee->rb_mgr.mutex);
+		schedule_timeout_interruptible(msecs_to_jiffies(10));
+		mutex_lock(&tee->rb_mgr.mutex);
+
+	} while (--nloop);
+
+	if (!nloop && (wptr + sizeof(struct tee_ring_cmd) == rptr)) {
+		dev_err(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u\n",
+			rptr, wptr);
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/* Pointer to empty data entry in ring buffer */
+	cmd = (struct tee_ring_cmd *)(tee->rb_mgr.ring_start + wptr);
+
+	/* Write command data into ring buffer */
+	cmd->cmd_id = cmd_id;
+	cmd->cmd_state = TEE_CMD_STATE_INIT;
+	memset(&cmd->buf[0], 0, sizeof(cmd->buf));
+	memcpy(&cmd->buf[0], buf, len);
+
+	/* Update local copy of write pointer */
+	tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
+	if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
+		tee->rb_mgr.wptr = 0;
+
+	/* Trigger interrupt to Trusted OS */
+	iowrite32(tee->rb_mgr.wptr, tee->io_regs + tee->vdata->ring_wptr_reg);
+
+	/* The response is provided by Trusted OS in same
+	 * location as submitted data entry within ring buffer.
+	 */
+	*resp = cmd;
+
+unlock:
+	mutex_unlock(&tee->rb_mgr.mutex);
+
+	return ret;
+}
+
+static int tee_wait_cmd_completion(struct psp_tee_device *tee,
+				   struct tee_ring_cmd *resp,
+				   unsigned int timeout)
+{
+	/* ~5ms sleep per loop => nloop = timeout * 200 */
+	int nloop = timeout * 200;
+
+	while (--nloop) {
+		if (resp->cmd_state == TEE_CMD_STATE_COMPLETED)
+			return 0;
+
+		usleep_range(5000, 5100);
+	}
+
+	dev_err(tee->dev, "tee: command 0x%x timed out, disabling PSP\n",
+		resp->cmd_id);
+
+	psp_dead = true;
+
+	return -ETIMEDOUT;
+}
+
+int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
+			u32 *status)
+{
+	struct psp_device *psp = psp_get_master_device();
+	struct psp_tee_device *tee;
+	struct tee_ring_cmd *resp;
+	int ret;
+
+	if (!buf || !status || !len || len > sizeof(resp->buf))
+		return -EINVAL;
+
+	*status = 0;
+
+	if (!psp || !psp->tee_data)
+		return -ENODEV;
+
+	if (psp_dead)
+		return -EBUSY;
+
+	tee = psp->tee_data;
+
+	ret = tee_submit_cmd(tee, cmd_id, buf, len, &resp);
+	if (ret)
+		return ret;
+
+	ret = tee_wait_cmd_completion(tee, resp, TEE_DEFAULT_TIMEOUT);
+	if (ret)
+		return ret;
+
+	memcpy(buf, &resp->buf[0], len);
+	*status = resp->status;
+
+	return 0;
+}
+EXPORT_SYMBOL(psp_tee_process_cmd);
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
index b3db0fc..f099601 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -54,6 +54,7 @@ struct tee_init_ring_cmd {
  * @wptr:        index to the last written entry in ring buffer
  */
 struct ring_buf_manager {
+	struct mutex mutex;	/* synchronizes access to ring buffer */
 	void *ring_start;
 	u32 ring_size;
 	phys_addr_t ring_pa;
diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
new file mode 100644
index 0000000..63bb221
--- /dev/null
+++ b/include/linux/psp-tee.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * AMD Trusted Execution Environment (TEE) interface
+ *
+ * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
+ *
+ * Copyright 2019 Advanced Micro Devices, Inc.
+ *
+ */
+
+#ifndef __PSP_TEE_H_
+#define __PSP_TEE_H_
+
+#include <linux/types.h>
+#include <linux/errno.h>
+
+/* This file defines the Trusted Execution Environment (TEE) interface commands
+ * and the API exported by AMD Secure Processor driver to communicate with
+ * AMD-TEE Trusted OS.
+ */
+
+/**
+ * enum tee_cmd_id - TEE Interface Command IDs
+ * @TEE_CMD_ID_LOAD_TA:          Load Trusted Application (TA) binary into
+ *                               TEE environment
+ * @TEE_CMD_ID_UNLOAD_TA:        Unload TA binary from TEE environment
+ * @TEE_CMD_ID_OPEN_SESSION:     Open session with loaded TA
+ * @TEE_CMD_ID_CLOSE_SESSION:    Close session with loaded TA
+ * @TEE_CMD_ID_INVOKE_CMD:       Invoke a command with loaded TA
+ * @TEE_CMD_ID_MAP_SHARED_MEM:   Map shared memory
+ * @TEE_CMD_ID_UNMAP_SHARED_MEM: Unmap shared memory
+ */
+enum tee_cmd_id {
+	TEE_CMD_ID_LOAD_TA = 1,
+	TEE_CMD_ID_UNLOAD_TA,
+	TEE_CMD_ID_OPEN_SESSION,
+	TEE_CMD_ID_CLOSE_SESSION,
+	TEE_CMD_ID_INVOKE_CMD,
+	TEE_CMD_ID_MAP_SHARED_MEM,
+	TEE_CMD_ID_UNMAP_SHARED_MEM,
+};
+
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+/**
+ * psp_tee_process_cmd() - Process command in Trusted Execution Environment
+ * @cmd_id:     TEE command ID (&enum tee_cmd_id)
+ * @buf:        Command buffer for TEE processing. On success, is updated
+ *              with the response
+ * @len:        Length of command buffer in bytes
+ * @status:     On success, holds the TEE command execution status
+ *
+ * This function submits a command to the Trusted OS for processing in the
+ * TEE environment and waits for a response or until the command times out.
+ *
+ * Returns:
+ * 0 if TEE successfully processed the command
+ * -%ENODEV    if PSP device not available
+ * -%EINVAL    if invalid input
+ * -%ETIMEDOUT if TEE command timed out
+ * -%EBUSY     if PSP device is not responsive
+ */
+int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
+			u32 *status);
+
+#else /* !CONFIG_CRYPTO_DEV_SP_PSP */
+
+static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
+				      size_t len, u32 *status)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_CRYPTO_DEV_SP_PSP */
+#endif /* __PSP_TEE_H_ */
-- 
1.9.1

