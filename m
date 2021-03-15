Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 687D5C433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Mar 2021 08:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 272EC64E86
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Mar 2021 08:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhCOI0g (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Mar 2021 04:26:36 -0400
Received: from mail-mw2nam10on2045.outbound.protection.outlook.com ([40.107.94.45]:65533
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229939AbhCOI0F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Mar 2021 04:26:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpIQC1venCzFLUADKDu1k7RmC2PrmNVLFERte1XmElpQ9eCJvV1oZuioMv6LvSEYFW2DDrizOgWWLr17ExNvIj4Kog+1gFU07+OjvG1A7t5U0HUZzBG4SmkdSbKRnNTdepggHrneJDF/0cAtBrklYXRP0GGWfnchAKrBUu6fXo0YOc3O3yOI17H+DeDgSh5QLJkS9NJIlMol8VZrZ9Qrg56IuoKBoodBML9g+5tDw86JWECUDnFfWLH4YbzbGhi0PGHMEMDnvQsouGCFEv6C/YSYa/hZqI9wqSxll8+h3+EE6VE9DAgNUmu2RTazTmvq9o3gR/e5CnbBhd8IQ1ze6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTgStv9c69oJI3ADGYnRQVD1TKyF811+Mao7jtwHIf4=;
 b=io8SmK5J33FZ8vbGbkKK0+yTL/QnndLL+tbNubX0Of0UXscGBVB2sl0GewWxSaXujEZzKyJYuEKckRZ9BWc43ahVJn6xho/eRXhYXaUa+Gtrl+lb0t7L9ex4tY+4ghjoy5dns1zZFeP6/YUNXVfrkFPGlpO4IYKu7GyQN4OVyme2v09WlhPQIKYJoIiiX6dacThmxOMGiMtTpFItrLzUs62DXd8RB7plidd8dh5iCDeFLxJZICoICwapmfxT6RjgPf8Lb13FFOga8A7Vi/2HHDcUaG2UQ5S0Y5Iyc370rz+MIBdSEIRLTSZTuRj0LbY2Agb+oPl7XvrVG8VqfTDSEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTgStv9c69oJI3ADGYnRQVD1TKyF811+Mao7jtwHIf4=;
 b=LmNp5i47Opr8WILBaJDGOMPZab+zCgVD20EwUM8pK+RHonmuNves069CxeBhAairwvfMaa4ii2a1desehfjK5IVSewOHCBoJJvsRDnlLtGtrHgjywQN81FJElW3nFW7oM6WtXqk94N//pYUBNrlj1OAPz+cKZJSUZMEjpsrNbQ4=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SA0PR12MB4368.namprd12.prod.outlook.com (2603:10b6:806:9f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 08:26:03 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 08:26:03 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Mythri Pandeshwara krishna <mythri.pandeshwarakrishna@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 2/2] crypto: ccp - fix command queuing to TEE ring buffer
Date:   Mon, 15 Mar 2021 13:55:29 +0530
Message-Id: <41af2b74a8743479597d52ebe991976a03189942.1615796554.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615796554.git.Rijo-john.Thomas@amd.com>
References: <cover.1615796554.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::19) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MAXPR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 08:25:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 96b7db8a-0e69-4c95-90e8-08d8e78bf872
X-MS-TrafficTypeDiagnostic: SA0PR12MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43689DAB1CC399901F76FED5CF6C9@SA0PR12MB4368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hyq5a3EFHyBg8AJr/Ln8Ik5TEA/q0b54avxltvzK0AtoQleJ4QjIYSND1VkSOyVmIsAt9OsiV8qAxJSwGJP+n4q4oTmndPduMOMmcz8OaJRst7RwpS8JfDq2lfObrVFSsJ47SqAgqfI0KemnT3kzTEDwsU5FLSZnI/Q3KlPbKJhnoyYF4gJxaaj+Oi5qVw6ZzJzz6puymd0mcjJrbCMSL4syyr/mPZB+lei4zV9GapXt2aweTpP0wjWbFwr0A4iqk/4tv0fiK09KPs4iHQj+WGSqqCKGAjhSoiXSryTAyklx9MIPg8qSjz3NJv1HKDjWiL0s7e059DFcTppryfeNFWKx8RN+3q74NWDecozxwjGds4IQ+KeztsGKZpj3FmBPqu3LInZYEM8w5wMdGIrIA3VIT1T5Q9rMRq59R3x6N8YY5iyeXH3h8ya2cuVyh8PqYpt+Q+1R0Hq8XUC4+dhNuN5P55gcwAR2Cen7pDtvxtlRxzifTlEAWSpkZ7x73kTj1ExbZkA/IpHHCiBew7JYfkcZILnS/a32UdGfIt5N1ANWJLbnVzyQMPeiEUx6hR5o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(36756003)(52116002)(8676002)(4326008)(7696005)(83380400001)(2906002)(478600001)(8936002)(54906003)(86362001)(6486002)(26005)(110136005)(186003)(5660300002)(66556008)(66476007)(6666004)(316002)(956004)(16526019)(66946007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?E7Ziw4N2RqK1Q5P1plQkPmNoQWY/Dma3PXGwswvJ8sf+qC6Yy0yXKPaGGDI9?=
 =?us-ascii?Q?wIinqvs2xQpor/CQSgktq6oOA2vGkjIm7a748en4BwUHahdL2GRoQogVY87o?=
 =?us-ascii?Q?aal4N7rvIMarFlfZAcKLEITDHaICVFtt1PxzfZ7vi+CcY42FOKbb7Ib0NmeW?=
 =?us-ascii?Q?e7d6LaozIV9SaEHSmEGqPKMRC8SP32X7sUOIBe7tUiuqYVFse3NDO4wYrumA?=
 =?us-ascii?Q?6+gEkTC+zRAEmzYjms1xMROOWFWbdFaYnp74/3GSiMQPE6yJMBs5MmGkUPij?=
 =?us-ascii?Q?beNYzCduns1/nkzIuafZbwDZyXSeyVnBHpe7QMo1XcoDESY7cGw8SlH2cirv?=
 =?us-ascii?Q?FeU805idUWwCxMxRZmTQ3xv/AXmEYIMzxGHDFcQi1FaEhco4rtlsUtGpH0r8?=
 =?us-ascii?Q?fKuaiYhANa3d3YIc2+4EPdsiuv8a0MZlgAou15T0jkPjjaltD8oIi5Z0O7em?=
 =?us-ascii?Q?JSgdppLmVFcy+eZ1s8B+6F2iqQC67+x1ShKh8IzpqFiyUPi1lDYS5KDOum78?=
 =?us-ascii?Q?8UkIW0IN/PavJ5mRh1HfNEf6p5nOCzTnfCxLvRvf10uA/yZu54vSF31BQGIa?=
 =?us-ascii?Q?YBIopnNT/1rGJ5uoQxRdhx+BbcxQIfrDY52m/2URzOL2PXAMiS+u+TXuqs8L?=
 =?us-ascii?Q?LdvbK4K+fKi+FSZQfg/sRCNS38VMr/TgO1T4FydXNNinQ9YQuF1jv2Y2UBs1?=
 =?us-ascii?Q?M5R0IN8KILIdnbsLfWhcG0Tv9cIOvFaQI+tYVgTZe07P7ltTn8+jSGwCCOrn?=
 =?us-ascii?Q?XwecHgOqxiZoWXWdVNYp4ebP+Sqv+KZt1uk6gZpCyaIfCkwjojrpuGB/+Sz3?=
 =?us-ascii?Q?aaI+T4uVP9yg60EkXkpUCVXJFnnFPFpotbk/bPY20mcr/GFLYUvgwyPadFMk?=
 =?us-ascii?Q?bimGvU9pW8OXBCbRmep+oxFKLblKD6j1lcAWwLdq608OM9da3RnApzM5UMUT?=
 =?us-ascii?Q?OhGSZYceWtBG9KME1YNisLzmBEhCuylSLqlEQD084h0azJqULohLHSuhsf6S?=
 =?us-ascii?Q?iyAGXWZiep7cx2GBRl0J7v9o2U1qGJ7cwvWlabAV8fkSl3d/V0Z8YcGAR9xN?=
 =?us-ascii?Q?5j61CNiqXeid9UF9QJaVHVZc7v4qODtfLi71mTKRQ4CB6WlcULfBiq9zXVXu?=
 =?us-ascii?Q?TU4Fj6H3gEyt7zKEoIKCEzPVBOC43ZUI0O0jLaSbr2Yczv6uwR0Bhdn+taKj?=
 =?us-ascii?Q?W/ileNhXqKvIoSB/OaO8BzcA+WhcGRMuC1YDKIeCkH6sopUWGR+YLzrHZoZv?=
 =?us-ascii?Q?WMIvOWVr9qeiI9OFf5Ns5iBhehul2wfWDIfLhyKOosOOFwpPIvpzesvSUpNY?=
 =?us-ascii?Q?KOYGIU8AEhNXYreLajIgavEL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b7db8a-0e69-4c95-90e8-08d8e78bf872
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 08:26:03.1541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nlWLwp5nvaz3ym5/4X65stKh4epPM3Zp38o12aF/QG7yv4GLmEkyQuQjN40rc8Rctq8KzhgLppJXK1liS+NuRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4368
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Multiple threads or clients can submit a command to the TEE ring
buffer. This patch helps to synchronize command submission to the
ring.

One thread shall write a command to a TEE ring buffer entry only if:

 - Trusted OS has notified that the TEE command for the given entry
   has been processed and driver has copied the TEE response into
   client buffer.

 - The command entry is empty and can be written into.

After a command has been written to the TEE ring buffer, the global
wptr (mutex protected) shall be incremented for use by next client.

If PSP became unresponsive while processing TEE request from a
client, then further command submission to queue will be disabled.

Fixes: 33960acccfbd (crypto: ccp - add TEE support for Raven Ridge)
Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/tee-dev.c | 49 +++++++++++++++++++++++++-----------
 drivers/crypto/ccp/tee-dev.h | 20 +++++++++++++--
 2 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 910b71df2aef..5c9d47f3be37 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -36,6 +36,7 @@ static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
 	if (!start_addr)
 		return -ENOMEM;
 
+	memset(start_addr, 0x0, ring_size);
 	rb_mgr->ring_start = start_addr;
 	rb_mgr->ring_size = ring_size;
 	rb_mgr->ring_pa = __psp_pa(start_addr);
@@ -244,41 +245,54 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
 			  void *buf, size_t len, struct tee_ring_cmd **resp)
 {
 	struct tee_ring_cmd *cmd;
-	u32 rptr, wptr;
 	int nloop = 1000, ret = 0;
+	u32 rptr;
 
 	*resp = NULL;
 
 	mutex_lock(&tee->rb_mgr.mutex);
 
-	wptr = tee->rb_mgr.wptr;
-
-	/* Check if ring buffer is full */
+	/* Loop until empty entry found in ring buffer */
 	do {
+		/* Get pointer to ring buffer command entry */
+		cmd = (struct tee_ring_cmd *)
+			(tee->rb_mgr.ring_start + tee->rb_mgr.wptr);
+
 		rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
 
-		if (!(wptr + sizeof(struct tee_ring_cmd) == rptr))
+		/* Check if ring buffer is full or command entry is waiting
+		 * for response from TEE
+		 */
+		if (!(tee->rb_mgr.wptr + sizeof(struct tee_ring_cmd) == rptr ||
+		      cmd->flag == CMD_WAITING_FOR_RESPONSE))
 			break;
 
-		dev_info(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u\n",
-			 rptr, wptr);
+		dev_dbg(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u\n",
+			rptr, tee->rb_mgr.wptr);
 
-		/* Wait if ring buffer is full */
+		/* Wait if ring buffer is full or TEE is processing data */
 		mutex_unlock(&tee->rb_mgr.mutex);
 		schedule_timeout_interruptible(msecs_to_jiffies(10));
 		mutex_lock(&tee->rb_mgr.mutex);
 
 	} while (--nloop);
 
-	if (!nloop && (wptr + sizeof(struct tee_ring_cmd) == rptr)) {
-		dev_err(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u\n",
-			rptr, wptr);
+	if (!nloop &&
+	    (tee->rb_mgr.wptr + sizeof(struct tee_ring_cmd) == rptr ||
+	     cmd->flag == CMD_WAITING_FOR_RESPONSE)) {
+		dev_err(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u response flag %u\n",
+			rptr, tee->rb_mgr.wptr, cmd->flag);
 		ret = -EBUSY;
 		goto unlock;
 	}
 
-	/* Pointer to empty data entry in ring buffer */
-	cmd = (struct tee_ring_cmd *)(tee->rb_mgr.ring_start + wptr);
+	/* Do not submit command if PSP got disabled while processing any
+	 * command in another thread
+	 */
+	if (psp_dead) {
+		ret = -EBUSY;
+		goto unlock;
+	}
 
 	/* Write command data into ring buffer */
 	cmd->cmd_id = cmd_id;
@@ -286,6 +300,9 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
 	memset(&cmd->buf[0], 0, sizeof(cmd->buf));
 	memcpy(&cmd->buf[0], buf, len);
 
+	/* Indicate driver is waiting for response */
+	cmd->flag = CMD_WAITING_FOR_RESPONSE;
+
 	/* Update local copy of write pointer */
 	tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
 	if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
@@ -353,12 +370,16 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
 		return ret;
 
 	ret = tee_wait_cmd_completion(tee, resp, TEE_DEFAULT_TIMEOUT);
-	if (ret)
+	if (ret) {
+		resp->flag = CMD_RESPONSE_TIMEDOUT;
 		return ret;
+	}
 
 	memcpy(buf, &resp->buf[0], len);
 	*status = resp->status;
 
+	resp->flag = CMD_RESPONSE_COPIED;
+
 	return 0;
 }
 EXPORT_SYMBOL(psp_tee_process_cmd);
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
index f09960112115..49d26158b71e 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: MIT */
 /*
- * Copyright 2019 Advanced Micro Devices, Inc.
+ * Copyright (C) 2019,2021 Advanced Micro Devices, Inc.
  *
  * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
  * Author: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
@@ -18,7 +18,7 @@
 #include <linux/mutex.h>
 
 #define TEE_DEFAULT_TIMEOUT		10
-#define MAX_BUFFER_SIZE			992
+#define MAX_BUFFER_SIZE			988
 
 /**
  * enum tee_ring_cmd_id - TEE interface commands for ring buffer configuration
@@ -81,6 +81,20 @@ enum tee_cmd_state {
 	TEE_CMD_STATE_COMPLETED,
 };
 
+/**
+ * enum cmd_resp_state - TEE command's response status maintained by driver
+ * @CMD_RESPONSE_INVALID:      initial state when no command is written to ring
+ * @CMD_WAITING_FOR_RESPONSE:  driver waiting for response from TEE
+ * @CMD_RESPONSE_TIMEDOUT:     failed to get response from TEE
+ * @CMD_RESPONSE_COPIED:       driver has copied response from TEE
+ */
+enum cmd_resp_state {
+	CMD_RESPONSE_INVALID,
+	CMD_WAITING_FOR_RESPONSE,
+	CMD_RESPONSE_TIMEDOUT,
+	CMD_RESPONSE_COPIED,
+};
+
 /**
  * struct tee_ring_cmd - Structure of the command buffer in TEE ring
  * @cmd_id:      refers to &enum tee_cmd_id. Command id for the ring buffer
@@ -91,6 +105,7 @@ enum tee_cmd_state {
  * @pdata:       private data (currently unused)
  * @res1:        reserved region
  * @buf:         TEE command specific buffer
+ * @flag:	 refers to &enum cmd_resp_state
  */
 struct tee_ring_cmd {
 	u32 cmd_id;
@@ -100,6 +115,7 @@ struct tee_ring_cmd {
 	u64 pdata;
 	u32 res1[2];
 	u8 buf[MAX_BUFFER_SIZE];
+	u32 flag;
 
 	/* Total size: 1024 bytes */
 } __packed;
-- 
2.17.1

