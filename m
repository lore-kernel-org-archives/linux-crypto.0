Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940F5C4332E
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 04:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76DB864F7D
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 04:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhCJEky (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 23:40:54 -0500
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:51296
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232199AbhCJEki (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 23:40:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+8L5NlwQUfGeNKWJ6Xa2/0VREx+ND9xfPouXZMi2fkokCd1OHtuVyWnZ7rHUCw72uAO1rDYkbf31tTCH05O6zEYk/mE3s7ZPCndOqiad4saK5Uvb9Y7u3FSOlmrh7XsGNn4dn7wJcCy7vwnxOc5vRVvDnnaliah2ypayZLMpoxkBOLH3AMfJX9gedE46Z1E+lyZLI2ukraCo8bYUDaoQF8Z9pAzCEL6mdK+4dv9XfPCVrf6IvkavukGP9v0KGxI1hOjBrltmU/erl6RpYHXNZAJOIcVHAPXJ76JkqIzftky9+h/mYZP+AdbOptKjLxNPY9rPFbcnZB/K5/EdFzQZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THybtUkGUS4Sll6Zhx0VQ1voNN3+HShjvLn1Pyre+Mk=;
 b=XkkEl+qYgUekpR42NxfR75pTozZtjTEtsViAqL3aokWCmuLYEM+tY3mR4G+JFe6WO2QuPdpynW+ioCqjJBcmUE9+wY0HLDNdqU4h4FHJTWYnEkUTvEBflN7NZXHI4U/lB/fVOJPvUZdFIQbJRF5l92LlPqHz71SV8VisEbEgbtAvQo+0RoHhsH69bsSr55GgEPt2f09EMBCz0GKLTm71QueTyJDwgmeojXR9XHMTKq7//XeseYxgGEI29T+KEKPxvxpWnbX4iMy7r+LJ6k4seTiwjHNjKzNRqxsqYoQiW7MJIqJZuNqIGLQk4Yi+rUEvygkxQAZ942YASsZ1n5HDpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THybtUkGUS4Sll6Zhx0VQ1voNN3+HShjvLn1Pyre+Mk=;
 b=i6gqcTTu9UQ5GCOVnCokSPatjS72n/nLEChG/FFdbc7fJYMS5JOOmbAGEPjdmVta2ULttv68xum1qFR68yE9H+mqHhmiPx95RwxoEj9mVkyPAAabs8WOkTfO6yMqeMUQv35wplgOZbOysgE28DaYKvFE9Ctvk1UkhuLOZK4oSIU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SN6PR12MB2846.namprd12.prod.outlook.com (2603:10b6:805:70::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 10 Mar
 2021 04:40:36 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3912.030; Wed, 10 Mar 2021
 04:40:36 +0000
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
Subject: [PATCH v2 2/2] crypto: ccp - fix command queuing to TEE ring buffer
Date:   Wed, 10 Mar 2021 10:10:01 +0530
Message-Id: <9844166d38b59d82e3d6c41401086d10dd38d77b.1615350846.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615350846.git.Rijo-john.Thomas@amd.com>
References: <cover.1615350846.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MA1PR0101CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::19) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MA1PR0101CA0009.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 04:40:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6edbc741-6b03-44c2-fbaf-08d8e37ea5f0
X-MS-TrafficTypeDiagnostic: SN6PR12MB2846:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB28467935084C589E343E508ECF919@SN6PR12MB2846.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKzP4m8OeowH58Syao0Br9mDXe7pDXnjJis7CeIRTQO5kKtkg3lT686ZD+AHcJvEWFcqeb8H8FEOfMT6xFHBYyLgnaSml+N8bkyOJzSCh4iZhWz9Nk8OK1HW2ubNyKXvZdD0d2Xj/ycdE5r48qprp67VnSaZ5ZQFIy9iYPi4wf/JpfE9VTRIpYR6VJ7VMUnBdmnywi1B68JVMXRq7lB1bA57kFXANkNu0LOf8jHRiTgpHzgMVAI/y0RHkjLEPSABROLB1xdNupwaYNuKgDNY2nSKfXehiDnhZp/hHDy987PFheJtX409Ywf1ccsMEwUksDrgVWDw27p5RXkb3BSHhE2aCKhBNZ/Ip80eaTVHaGo5CjLWNbHOoLRBZ31sekaEPLo4dtmXVCjuUVfiLpKG2DoK76JYf/LJGwMZphX9Vbb/4pL2FSNySeShB/iQZsVocj6aVIkaYAYWMaFwx5s7cD7nwQDuwP8JHc9v0mOQZiynF0Wtesh4+BoM8m6MPz3+Dj98TQDR34VvIT2qlRasPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(956004)(316002)(2616005)(66556008)(6486002)(6666004)(66476007)(2906002)(86362001)(36756003)(8936002)(66946007)(8676002)(83380400001)(52116002)(7696005)(26005)(4326008)(16526019)(110136005)(54906003)(478600001)(186003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CzRK82obBkRPiU7cUb/7suhlz7cd63XtAAO8M4hO5KVy38VeCtpRm2denc6j?=
 =?us-ascii?Q?MlFxfqO9M0pe+AxIXIukbWYXvEXBOc9cQ1y8hPP8q+K49QQ3JWh2ZiOSaD6v?=
 =?us-ascii?Q?tD/4J2WbLFVmEBnLpx+/U/uRbai8vF45tAGoAuyHqa7k4Y667cikpX8zMHZ9?=
 =?us-ascii?Q?YtSpmQne42uS3Yik20yGpK72wbY4QjU+cyUJKKLsqG9i4rXzkxhJyt+oEucI?=
 =?us-ascii?Q?vL8yjHrNvF0vseVQ2pC5WwDv5aNkX3thIOR0RBolXBv688r23ceO+CnRjouQ?=
 =?us-ascii?Q?Wvy2IKByzIHVYiEGiW6b5uu907tFipAe7JvUssnCeMZcDS7IoJs8ZpfCU0gs?=
 =?us-ascii?Q?7Vxm+C2IXQoXeH2fDtQhm8WGQmId4GKsIjJQ4KjKgejEz/vtFvgFcG1nG1RG?=
 =?us-ascii?Q?tzQMJ8124Qdvq7iqQ3VSfO8LvLKDUCn+jhaZePBQ/PQwEHYzua2UbIq5caQD?=
 =?us-ascii?Q?kAD42Y0B9o0kx7HSaqSkjH5UeKDgUbQTrR16q2rUzyKHLEXBSNflGI/8Q4t8?=
 =?us-ascii?Q?kNmUGQsMGJcUeo5IFTw8xc7u/PAG5IpenNKc0K2tL31aweIhoJ7InkYkd8tj?=
 =?us-ascii?Q?5/hKqWGuelE5nPCGK096E5zpgDcgmPA2TZqKT6o5y0RHX9ZVYZh/tcdkbX/0?=
 =?us-ascii?Q?lvoFZp7y3gcgXFd38Ao5o2SRy+xBphcC274HULC5MRwUDXDoJDn8KV6UEFsS?=
 =?us-ascii?Q?ytQF18Y0j0L6cyYbEV4QGPykxK4qQdN7zigrHQgC8jQJXoLccRJ79OOJdU22?=
 =?us-ascii?Q?BB2NpV/x0Jg7MzpuxPvJ6/6IoNzh9k7fnSgd0h5wR+CT1JGSVA1cYJnYDsvu?=
 =?us-ascii?Q?r6o6y4uZ0TsGax96RYmtIXoTubPovw7rC3jKMzsCxrmwdI6mGdBjO6wfURP/?=
 =?us-ascii?Q?RXff3MQbBaZJM7Yar7J7TGrf2PHRafFrTpbaIf232zPPyP0pYzIQmHwt3H15?=
 =?us-ascii?Q?BdKe+YYvti34f4TL3rASTRDg43Pf/D/Y8n9fgWYdOpqIAqPGYPH1DA3j9yiB?=
 =?us-ascii?Q?AdSPfLBhlqIfqki4G08h8ACcylnoeWTKUFAeumD9NCSP9W45hLDT+j3Xjcw+?=
 =?us-ascii?Q?zMVlll2iFTSlKuLJN5g1a5YAkc6vs9RmDBCJtZu7JiiyhOmJpq1lV8luKAO+?=
 =?us-ascii?Q?IxpPOJvBpueFSXWCDtfY4yai0HE8iGQP8jl1a9AkyFxmSwZjFvJ2v8M9hkg4?=
 =?us-ascii?Q?ax7zIgJi8RxgzDvB1hXbZTkGvKYU7aw5eSC1C6GRn+mU/FLpJEa5h9UH6oZ0?=
 =?us-ascii?Q?nqfqaK+C3xI0gUJAIcpADDeBZIIZUQ+TDgsCPwWssTEmx6ojVCxnAkCkOTFQ?=
 =?us-ascii?Q?XjZFk8C84+rgUfyHiFlxAzpY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edbc741-6b03-44c2-fbaf-08d8e37ea5f0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 04:40:36.5541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: emH2aigERIlbBUumK1G5+3El+yIHvj+RQ47uS1F1adXEZu1uux/1xtSFAQuBW6O/50FOJKPWYLETE2ZHLSLV/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2846
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
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/tee-dev.c | 49 +++++++++++++++++++++++++-----------
 drivers/crypto/ccp/tee-dev.h | 20 +++++++++++++--
 2 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 910b71df2aef..8cade4775115 100644
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
+	if (psp_dead == true) {
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

