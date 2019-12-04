Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19038C43603
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 07:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8C8B20863
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 07:12:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="xIZ14m5g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfLDHMT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 02:12:19 -0500
Received: from mail-eopbgr680043.outbound.protection.outlook.com ([40.107.68.43]:59426
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbfLDHMS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 02:12:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jW5uoA+03Hm3yoC9j1cA5Zb1oMIsJc40kxuMGM0aXTTMFTxLt3qmv0T/e0EdtyQKGt7h4J6Z+62Tu8TKXEHfq6xDCMjbFSpvHdl5TFX5oIN0wLhQELGk0RR7Xfby4817AkNA4bRmL/2j1k9W8Mkh9/bp+cnPtgy0V/23CE1ZpIoZxKB0A/wthPLNH3xPQYAUewXOLCVnb7dfuHsUrG4VB/qB10pzVuL0nJrn3GA2zdgv+PzCjie5B83cwWLGequhV9KW3coxPUu6FcjGdFDj4VBzdX9fTRY3pab89gBJE2J0mhWYKl9z/JNx6cYC6yWpRqpM1MfpMt/T1xVl5XlpxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4XD5hAhqMgNiPoU6VxiBcvHcktkCvxlrCVD7SgPmow=;
 b=WyJserXtn+habpRdPKs8c2VBUE4K0zkvJXOuIVBzt8CA9xesqP6vYMdPgOx3LYW3UPOxRjCfDXoY7fpowboqRMTHYb3kjhK6kUzzPPMlc18ApXRf8put5mi3ybleVEtts3mKXfJByNsarks5urEifXRkXXl/I9Th/vuER1oUyXdYHqQ0BdaYcCjW5JAGhgIIEyey+ulfw3kY4wBHCIZlBORtC8s7/qNkG9pcsl40E0IDLF6BUDF79yc/WyUj6fZy+HBQU5eJ6kJe84h6vBe3O/ugVUyg4C0QESnQdZNK8ar52vEJuIL8WzJ4UhI4PuNqXvoWlog+oudzgopdbBp3xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4XD5hAhqMgNiPoU6VxiBcvHcktkCvxlrCVD7SgPmow=;
 b=xIZ14m5gKaUQAF/oAQCpkBZucL5WuXM24zSSrJVSMFQeDjs+tfGMJI1x6T1ga2hGWMXB39pWy389M8B04HEFedcNb48M5lluPQgDTdd1PURXh5rqHyNZNJs6wzyN/Boo6aSsSyYxoRpRIXNAhPuC5UIXcJ3W+NZXDZM8Vf0RDVI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1400.namprd12.prod.outlook.com (10.168.165.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 07:11:56 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2495.014; Wed, 4 Dec 2019
 07:11:56 +0000
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
Subject: [RFC PATCH v3 6/6] crypto: ccp - provide in-kernel API to submit TEE commands
Date:   Wed,  4 Dec 2019 11:49:03 +0530
Message-Id: <8bde26314458954e1f229f5c737063692744a6cc.1575438845.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
References: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0065.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::27) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 375a00a7-99ba-4dbe-13f7-08d778893ee2
X-MS-TrafficTypeDiagnostic: CY4PR12MB1400:|CY4PR12MB1400:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1400AE98FF28BCADC3D342D4CF5D0@CY4PR12MB1400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0241D5F98C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(2616005)(66556008)(2906002)(66476007)(50466002)(48376002)(478600001)(14454004)(50226002)(11346002)(36756003)(81156014)(26005)(54906003)(110136005)(81166006)(3846002)(66946007)(8936002)(446003)(8676002)(5660300002)(6486002)(6116002)(386003)(186003)(6436002)(4326008)(99286004)(25786009)(6506007)(14444005)(118296001)(76176011)(16586007)(316002)(86362001)(52116002)(7736002)(51416003)(6666004)(6512007)(305945005)(134885004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1400;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Gl3Zm7d7GxtLbjg9K6HJhmgD+S6Ui8PFPCATlesuLOlPDB52oeZsw8eAeyVeKQe597nD1BKgzL/7KRmBVfcT8w9+CmdIpZOZetwP1j45iqiW7yRE7cUp2Qc6kO2UI9QKt4Q+d1UBgLACf1kZBVahqKfxF0sOW8+APKElDSOuyZzJLOvJgDNeV2u/3mVXcFqVpTufuy0KPHPgbQN8W34UAjbSfLc0CRj6Xf8U7YTgKtFd8ZTqRr/KgfjAr4+RUAuTTN5lQKNpGJsvu2XLHTCHvt5LBcEesUTtRE4o1JvTBVsY9DZpcyySeUWsBvPfLd9ydYnZ5/Vw9wmcaMkbn6xeE6dPkQeWmsBcXur/yTEuNw06U/7G3JsS2hBykpsTvTW9QxjJQzihIZDfn2P68e00xdjxoq5NmNPcN0Hn5eIveX9hf5dF1CZ8JTN8J6mllIxikYEKYPm46QrcrCaaA0RI8eZuvCW3OuoLAcsglwQy836eU7QDjXamfq59WiKalbF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375a00a7-99ba-4dbe-13f7-08d778893ee2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2019 07:11:56.2898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdbMivMscJoJkI+OeRNNRPPeXbBwVYB0nT7WJGGTlcuT9gtMkCeuDeJ1EEjqggwVoQlR5wIvo2Fz7zpjvNlE6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1400
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

