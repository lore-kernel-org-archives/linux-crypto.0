Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8EBAC433E6
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 08:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89F68652B2
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 08:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhCIIM2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 03:12:28 -0500
Received: from mail-co1nam11on2085.outbound.protection.outlook.com ([40.107.220.85]:10145
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229495AbhCIILz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 03:11:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n958C4z7UY73+daJHKXr0zkk4QDImeIEmfliKFdjvgR7eTFxODtF1NjsIJkZbjH34fx8WEJvjbjdszDs5eSLT2LPy0l+yhMVoCHabw97b9qqljTzLZFfONzkLjzu3dHvyv9vvF0ecNNxqh+e1Hwt491W/ylu7MwDqDeLM1QUiDDiH/Nx4elLNzlgnJP5yCr1mc1IJfhVU2PhCZnCHH2saGAgpZ7EENg7oYUR7w34IentcsyEl+sa4IG+7KPh3SSpfRYHfEyr0P4ZYL2cNW70TRQ5Txc9ctTQy2gJ0RovrEEwYH8ujTAn8IiRQsgkZUXpcZ+GTfx8ePIR5KhEJs8EIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nkk+qdW11f0f4aSsFCWK9rI3hsy5kHayc8Qs0kBNQs=;
 b=d4qTnLSTCVnbQH558/E/ap3il1y2EKP63NgtNEgsFh6FfDShdvcx+aqdG2ad7nKg4VIgGHXWiJEH2xS5QEkPUnV1dKyZRNGMwH6cS/z29QE91jyCTAkWl2Oc2dD31mmIsJfKkPW5OaTDp0BIMN79I9C+Y5cyNyRQCeQmTlezowrlAzfUIaLAj5YeRXoOzI2XwL+GDFuzzND5SwqnmM1TxHT4fDjEszBKiig0K2XDE5ws+6Lxf2fiJpiOpbiNgyQr+/5ko7Nn0bLsofQg+3Gu2qRBuy9DiVYMJd7Sbn06efmW/LZz9scTiOsKtWd+Jwi5zRaQoESUMoVCCmNoHa3j8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nkk+qdW11f0f4aSsFCWK9rI3hsy5kHayc8Qs0kBNQs=;
 b=CMEwOAp/hAbYlJz1vHx8h0PnSOvqmRSfnG+4J1l2/lWKCEEpZPAhZpBXxCD4QqFoBozl5Kb471iaWn20MtsHBdjCn0EjzZGetUEMafs556OL0VNGl9te6yb2wq4MHWG2hr4dnQa8OFE3CaRn1doScAsYU5EedUjgeIi+38cb1Wc=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SA0PR12MB4397.namprd12.prod.outlook.com (2603:10b6:806:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Tue, 9 Mar
 2021 08:11:53 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 08:11:53 +0000
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
Subject: [PATCH 2/3] crypto: ccp - fix command queuing to TEE ring buffer
Date:   Tue,  9 Mar 2021 13:41:12 +0530
Message-Id: <14a55bca9454ce2d7e1a549176ade1367cb3084b.1615276206.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615276206.git.Rijo-john.Thomas@amd.com>
References: <cover.1615276206.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MA1PR0101CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::30) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MA1PR0101CA0068.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:11:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f34af3c-b3d8-4f81-44a8-08d8e2d2ff7c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4397:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43976DC610DB00AACFD02A6ECF929@SA0PR12MB4397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k2ZnY97JWcKjY8a323l7mK/Xysx6KfaLofArknjV1rbxNv91W7W5NxHeLqTovLmYgKnRIvY73adPbJTMtEaaRFD8PLsPoOx9+9+/uW0lDvZxZYvnJYJOulIDOOrTnlNs6Enp88pQ7IeP1HHbXfEzqgC4WoiEeiJeKk/n/lnyn7sZVtpiLhJGwdc3ESZBxDnt0vITFHLzYuepeBKn+czhV8iMsi+Pq3TA+AYWtwM2d20hLsEkM1kFDE1WVXXZ5ukOCVT3WiWsCcYpiS/RgP+afUExT23Xmy5DiId7FhS5DtzgnGm8DCVqUdCkvroqbRGN/kcA95bMOQ9YYi+gJMydaUYZPUk4pZcv5vh4j1+RcNX9newKXBf7IucJLNGwT5CRs9fQGdiLS83xY5KOFZS+QBVo6UltF2Gti9WlDAEy6Zw8POh4G9ZpoWdpN0ymuJCJwC63chl6uZ7g/Edjp5drIomTDHod9ErmLIkT7H+QYwFXEwC2z7IO9YtCD37Sm8gt96+lgUFRe+Jyz5OMqZpEwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(66476007)(8936002)(5660300002)(4326008)(66556008)(2616005)(956004)(316002)(54906003)(26005)(2906002)(6666004)(8676002)(110136005)(6486002)(83380400001)(66946007)(36756003)(86362001)(186003)(478600001)(16526019)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2IFvbUVjyheaw1GCdpMPc6CfaiH4iQNsv5WKbc58DTT3m5thgEq+N4ZF4/o6?=
 =?us-ascii?Q?7Xq691LLJMD7eI3KNb8TYAFgRfcf2FPj/ik+w2NnH2ekdLoSkMe3abLrIJyF?=
 =?us-ascii?Q?HNT3iCBQzXF0SL6eTBqJHy/mhsSu8ZRfPNedX42K5fqD8tYIg7u5Spgrx//s?=
 =?us-ascii?Q?+5gUB3tfPZPd46m6Vc8cTeAsYYbQHlFEVL7CffVQJ+WfEWj1m9F1TdP0LL5M?=
 =?us-ascii?Q?aeCwRBFy8dNon6DqzgTS82u2rIBUY5TuiLdD5yno42SSKQ4Mp1EfGuKBfpoU?=
 =?us-ascii?Q?31dsAr4l4LxbvFCWVskUYRAZUVEIs3c8k47a1UoBJFNOIM6FmG7Rp//0bQiY?=
 =?us-ascii?Q?e2b+JxL2/9FKkuMXQRI8tVoji2Qi2r28vFNMiO7xh+gIC5NwB2XPxdewP/VU?=
 =?us-ascii?Q?5g4pOpDO1sCUGiRSd45jaFj9KfNaFnZ6tqJvdT1uDgRCx2jYneulUxaN03k9?=
 =?us-ascii?Q?gspQVH01Az66Avveylf6sIV9vaNooFar4KTADtJD5fT8c/XBaqEbDskRsfbQ?=
 =?us-ascii?Q?MoxGHQTWDelyms7rYGO6cBSAVrW4XUuf7iLvOXdjToXL73xOzW08CxXqdVFd?=
 =?us-ascii?Q?5w6xghSLMA/JUZ5GkGe5lK51NKUaM85k1UKmmacVjzBXPLej8w0TdsI4NH0y?=
 =?us-ascii?Q?fZ97jNHpakgKTbOxrz2ISTpnyWpteKChHpxteCMxwy0mk6YkIUu16N4JUH/e?=
 =?us-ascii?Q?wzra49391QNAWzO8MalUwAniuur8ooayNJ2pUmevTY/8NKHI5axTGw5H9lJT?=
 =?us-ascii?Q?un20Z9LmMI3GuvtCathHwbB8EcSaaem/mE6QhhHGC84q9bh32VJFkbTEO4Wt?=
 =?us-ascii?Q?CV+rXUgcnYDdFrhCMMxDtI8LnhoxtdxOG3qDBCnV3S7qSSU6jGewSUdXC724?=
 =?us-ascii?Q?5lIg08JKjY9TPHpsgzE7gZyZsC3meVz1CfbQRi8lUX96+Xl5+V+fUPYWaTgu?=
 =?us-ascii?Q?lFfHCHNsRWXUZuiVEyE9Pri+38j/c4cA4CXVi5cxTEb4Tj7sGNgn4OCGw3dH?=
 =?us-ascii?Q?8SJIiA4nF5AgvsJ49fSAPILzh2CSxbEvRqZGqsoDYXFJYf/b47SlsXojE+wk?=
 =?us-ascii?Q?4f37ZH673R8LT18KjG/MExbiKATVb0lXA+6IKS6r6hRwU1t+vouI9f8uo8B+?=
 =?us-ascii?Q?wW8E3UqhiWPXK4AHd8E5viBe9p49MG7O4zng+g5rZ7j1GiX50SUE6p/qiVvF?=
 =?us-ascii?Q?6f6O03+Q9wkRYjzg88AgUnQZ9f7xMPGrho2ZMD7x8Vjb7dlut7WA/7rSThVl?=
 =?us-ascii?Q?dTMXeeTyQfSmeSaCOlH7BYDsUGs8RtvaD4p1qa2p0oxbAVfXU0UqkK5+4SK0?=
 =?us-ascii?Q?8ZNIr9bPXIeWbIzQBvOouXAD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f34af3c-b3d8-4f81-44a8-08d8e2d2ff7c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:11:53.5036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L8x2Pf0BbAzyU2ovX3e8vCgym5CH01J8sIB3Za/b/UVAm+7cWkribswcn+Tzp1PXhBOOmzHQbIWEfOI3VTvsaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4397
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
 drivers/crypto/ccp/tee-dev.h | 18 ++++++++++++-
 2 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index fe18a92d51ad..1aa264815028 100644
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
index f09960112115..dbeb7d289acb 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
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

