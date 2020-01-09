Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F5AC32771
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C06A62077B
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="P6s9RhZT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgAIMyA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:54:00 -0500
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:11563
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728298AbgAIMx7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 07:53:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nldS72QDxkSwowlvLLPwNsYb5p5OzOjHefz5T4lzjoNQKzyNLDRYUrKACnQqqEAzLDMhBHr6//Jm1wzzuPKOf7ehGjEK0ZwdXEBNqjksLNQrcEwGy8MticdvLivk2HXh/CormuQjMSLYEfESpyJkuMwPmCcFhkvlZuef/TIktsuoRJiJSD4Pr8ZSFYepV7lVEOjaM5Q8ZpHNrjUeZ1qi0D9RW6z8EKVdpF6dbmAXrH5Jl1w835vjD3SG2J0cXKnIZLmcoU+MLorttwvHkD2GOXCxqkrYBK7pA3vrnCzv9wq0NgBtmwBcRKK7UGgP/yhVZFQxYTTVGUtEE8Ylbb+K4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwLnvxQvL09QSekUQx4GqADuo3iuHwWaAQT24rStps8=;
 b=XSJGrfniOS+ZTY3J9gPt15mzd0kYPtMx/GpMnXQb226vBsIgiSDl+F1GkE9+J/kBhTCYQGAvzn5BD7m0bAwTPDa9l19FTMBMRSpPwUkDgHE6w+pfi0NjAwKc1GXVsEwLL5b6efVy7mI/uTi80znbAISz4EdWuw55YvcBL0WWvCVR14mYqBc8uOCLCEErU3bNupnLbfDsLEBKIz9TEbx+/9Xha8r/AeEZjL7aU0Px0V8er1EUYQ67i5Yn/qrYKp9TEb9PkzMY5J28+lxrh+K4O3SokQvf/4/bTpgZzPKF/1VIWq2P75DD95Rd3MhQHYVGJ8DkW7ihn5XegZoO9anx1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwLnvxQvL09QSekUQx4GqADuo3iuHwWaAQT24rStps8=;
 b=P6s9RhZT/qcf9vRKV+cQVSC529enPQ1+ophu5xSRQ/RodukqJPEVMRop8n+5ehTX1CT2PAAubye4Lnx2kra2SuYXpAB+eppoCyDAiZKIhPKebz6w5WoW3akHJq6qC8OaHiiL4/UuikCenBaCs1gJhrO+LuGct5RD+58EgHQzLVQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1206.namprd12.prod.outlook.com (10.168.166.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 9 Jan 2020 12:53:56 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2602.018; Thu, 9 Jan 2020
 12:53:56 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Jens Wiklander <jens.wiklander@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary R Hook <gary.hook@amd.com>, tee-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/5] tee: amdtee: remove unused variable initialization
Date:   Thu,  9 Jan 2020 18:23:18 +0530
Message-Id: <c0bcf36040cd57a1616692539a6c2743f476d25f.1578572591.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
References: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::13) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from andbang5.amd.com (165.204.156.251) by MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Thu, 9 Jan 2020 12:53:53 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d89837ff-e9d7-496c-dfea-08d79502fd1c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1206:|CY4PR12MB1206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB120694537C43BC87127FD8E7CF390@CY4PR12MB1206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-Forefront-PRVS: 02778BF158
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(189003)(199004)(6486002)(478600001)(4326008)(5660300002)(26005)(2906002)(7696005)(110136005)(54906003)(36756003)(6666004)(86362001)(52116002)(16526019)(66946007)(186003)(66556008)(66476007)(81156014)(8676002)(956004)(2616005)(81166006)(8936002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1206;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Whx4hWiBwmg0EynKjWM0lobJST34NcEw77KYIwAIKNOq+rESyv0cI/VYZo2F3JKE2I/qV5Ej2MJlsuF7IN4YwULECWsvAZ/6PaCSZH73tD/X/FbsBgKe50lRFy39B/3qrq+jpWsAkKcrn6FJjS4z8wwKoBs6kDFVUNnkuvKK1lWyelINDFqIqbQ28Qiv1y5ajrhmOi6ns/+Q4F4EZH4fVbXSvYEbGscIrwEScvtYfa03nLeWJy0+8Vak9IZtJEIvWqsAePs7vp2S8JxqRLjFzKfxF+MqaaofXWcQEKU7skgbC7QRGH2PuD5oWvdx88bZ6p8fDPaJklEvSfgo4N5rKACMYktiG26D/EPJ7MJE9Ckt1l2++CUNx/PVu2eqd0oCY4guQhxfAtjRbTrl/DObVx8mpvsU64+CVQkAmIMfRM/zTGMbPyiq/4z8s8OPQIFr
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89837ff-e9d7-496c-dfea-08d79502fd1c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 12:53:56.7094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JjzDjXMBcKxSqBWLEa/dCBxEvUtwFP6U5PCNEXfwhoEd1ai3Xa2C1FsYvfdsxkIA+7nBdJviEsjThiRQQck6cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1206
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove unused variable initialization from driver code.

If enabled as a compiler option, compiler may throw warning for
unused assignments.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/tee/amdtee/call.c | 14 +++++++-------
 drivers/tee/amdtee/core.c | 14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/tee/amdtee/call.c b/drivers/tee/amdtee/call.c
index 87ccad256686..096dd4d92d39 100644
--- a/drivers/tee/amdtee/call.c
+++ b/drivers/tee/amdtee/call.c
@@ -124,8 +124,8 @@ static int amd_params_to_tee_params(struct tee_param *tee, u32 count,
 int handle_unload_ta(u32 ta_handle)
 {
 	struct tee_cmd_unload_ta cmd = {0};
-	int ret = 0;
 	u32 status;
+	int ret;
 
 	if (!ta_handle)
 		return -EINVAL;
@@ -145,8 +145,8 @@ int handle_unload_ta(u32 ta_handle)
 int handle_close_session(u32 ta_handle, u32 info)
 {
 	struct tee_cmd_close_session cmd = {0};
-	int ret = 0;
 	u32 status;
+	int ret;
 
 	if (ta_handle == 0)
 		return -EINVAL;
@@ -167,8 +167,8 @@ int handle_close_session(u32 ta_handle, u32 info)
 void handle_unmap_shmem(u32 buf_id)
 {
 	struct tee_cmd_unmap_shared_mem cmd = {0};
-	int ret = 0;
 	u32 status;
+	int ret;
 
 	cmd.buf_id = buf_id;
 
@@ -183,7 +183,7 @@ int handle_invoke_cmd(struct tee_ioctl_invoke_arg *arg, u32 sinfo,
 		      struct tee_param *p)
 {
 	struct tee_cmd_invoke_cmd cmd = {0};
-	int ret = 0;
+	int ret;
 
 	if (!arg || (!p && arg->num_params))
 		return -EINVAL;
@@ -229,7 +229,7 @@ int handle_map_shmem(u32 count, struct shmem_desc *start, u32 *buf_id)
 {
 	struct tee_cmd_map_shared_mem *cmd;
 	phys_addr_t paddr;
-	int ret = 0, i;
+	int ret, i;
 	u32 status;
 
 	if (!count || !start || !buf_id)
@@ -294,7 +294,7 @@ int handle_open_session(struct tee_ioctl_open_session_arg *arg, u32 *info,
 			struct tee_param *p)
 {
 	struct tee_cmd_open_session cmd = {0};
-	int ret = 0;
+	int ret;
 
 	if (!arg || !info || (!p && arg->num_params))
 		return -EINVAL;
@@ -342,7 +342,7 @@ int handle_load_ta(void *data, u32 size, struct tee_ioctl_open_session_arg *arg)
 {
 	struct tee_cmd_load_ta cmd = {0};
 	phys_addr_t blob;
-	int ret = 0;
+	int ret;
 
 	if (size == 0 || !data || !arg)
 		return -EINVAL;
diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index 9d0cee1c837f..b3f8235579f7 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -50,7 +50,7 @@ static int amdtee_open(struct tee_context *ctx)
 
 static void release_session(struct amdtee_session *sess)
 {
-	int i = 0;
+	int i;
 
 	/* Close any open session */
 	for (i = 0; i < TEE_NUM_SESSIONS; ++i) {
@@ -173,7 +173,7 @@ static int copy_ta_binary(struct tee_context *ctx, void *ptr, void **ta,
 		u16 hi_ver;
 		u8 seq_n[8];
 	} *uuid = ptr;
-	int n = 0, rc = 0;
+	int n, rc = 0;
 
 	n = snprintf(fw_name, TA_PATH_MAX,
 		     "%s/%08x-%04x-%04x-%02x%02x%02x%02x%02x%02x%02x%02x.bin",
@@ -219,9 +219,9 @@ int amdtee_open_session(struct tee_context *ctx,
 	struct amdtee_context_data *ctxdata = ctx->data;
 	struct amdtee_session *sess = NULL;
 	u32 session_info;
-	void *ta = NULL;
 	size_t ta_size;
-	int rc = 0, i;
+	int rc, i;
+	void *ta;
 
 	if (arg->clnt_login != TEE_IOCTL_LOGIN_PUBLIC) {
 		pr_err("unsupported client login method\n");
@@ -368,8 +368,8 @@ int amdtee_map_shmem(struct tee_shm *shm)
 
 void amdtee_unmap_shmem(struct tee_shm *shm)
 {
+	struct amdtee_shm_data *shmnode;
 	u32 buf_id;
-	struct amdtee_shm_data *shmnode = NULL;
 
 	if (!shm)
 		return;
@@ -434,9 +434,9 @@ static const struct tee_desc amdtee_desc = {
 
 static int __init amdtee_driver_init(void)
 {
-	struct amdtee *amdtee = NULL;
 	struct tee_device *teedev;
-	struct tee_shm_pool *pool = ERR_PTR(-EINVAL);
+	struct tee_shm_pool *pool;
+	struct amdtee *amdtee;
 	int rc;
 
 	rc = psp_check_tee_status();
-- 
2.17.1

