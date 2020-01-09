Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB34C32771
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CA962075D
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:54:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="MO0NsqM6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgAIMyC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:54:02 -0500
Received: from mail-eopbgr700055.outbound.protection.outlook.com ([40.107.70.55]:17825
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728298AbgAIMyC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 07:54:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M085hAj2XNd1LpX0nD/noLIRZRBZ72SVxAhXS7eBUFAlOLRCzGAiE65F42iEqO69NafFvWBX9664HhM0tMUHuqk+rd0IlWryVETsnzsHWbqy36j8hTOPT28ZR5HmINi2QJ3Whg70K2BqrBBvcP9o70qtyjXJu/qYSXe8OgGuokHOFVQ1BitWgH8oPCBz3eQun+lKs/hU3LU/yUAeEI3XcJaMyXRcF6liXktUHqA3iL8Uc6pp1DAhFpHQcSwpc5xHcHeIcC1bVb4sHk/710YxszYMPw186fQFVIjIpV57dObiacuW3KBJm6uC8q8y+T6r2Tid2FTT1o/XsvD0mVKb5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzt6z37LUmHKiX8m4NstU6/t6IkCdPW/3DA26Qi3r6E=;
 b=FwSiu8zPbrtA1w4Dp9I8TQ/J3IS9NUP5/QNos0izzP0WCGfkVbmTJcUMjw3dB1I37xZNWDxA1LSK2B6rpoxEdKdxfU5aDpFlm8FDYEvFeglUnOMyIQG0444Fvdl8Zl9wikCZX7n4jdBmZXIT0/CZ4JiJlm468aq0pz6l8sZnIS4KIUWVYODwpDLuvkpq3Vmjq1yZmxns1/l3vxSsZ66c2RIpBkr6iWvC9sEdHZtU1ZuLmWehHW+b5v0cxQaJokfA2f35YlUPdX9s5mP88wdEFXNrP2W6w+MF3VzGjsg6grxhagyajzro4m6hcu94idlssS8ckmLBjPxdv5paxQHbww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzt6z37LUmHKiX8m4NstU6/t6IkCdPW/3DA26Qi3r6E=;
 b=MO0NsqM6oFGTBPZVB1xf9ut6HCgrlt6+1zJitC4s7JINmWeaN90idRATkc2W7M+FUaHgekJfMMZJ0zikwtWydQ+2H9SYdwAE7Ko5Qj0rQy0bJHw5XOgHYBvhh1S2Kr9CCDDcvVxfBFQX+t5c9oM7UrRyxH6lM1HAdw45SkyilgA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1206.namprd12.prod.outlook.com (10.168.166.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 9 Jan 2020 12:54:00 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2602.018; Thu, 9 Jan 2020
 12:54:00 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Jens Wiklander <jens.wiklander@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary R Hook <gary.hook@amd.com>, tee-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/5] tee: amdtee: print error message if tee not present
Date:   Thu,  9 Jan 2020 18:23:19 +0530
Message-Id: <00f01ee8cfd613f00153494d5b14a3061e6db760.1578572591.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
References: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::13) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from andbang5.amd.com (165.204.156.251) by MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Thu, 9 Jan 2020 12:53:57 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8eec08d1-5ba4-40d8-3a87-08d79502ff05
X-MS-TrafficTypeDiagnostic: CY4PR12MB1206:|CY4PR12MB1206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1206F7FECB03C6C611CEFCA8CF390@CY4PR12MB1206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:335;
X-Forefront-PRVS: 02778BF158
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(189003)(199004)(6486002)(478600001)(15650500001)(4326008)(5660300002)(26005)(2906002)(7696005)(110136005)(54906003)(4744005)(36756003)(6666004)(86362001)(52116002)(16526019)(66946007)(186003)(66556008)(66476007)(81156014)(8676002)(956004)(2616005)(81166006)(8936002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1206;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GHHdkpKLJhi7ZIbvXsJcRiUEcSl1uMxTX/SLQSxB28BlfGmM5gby1sKZ0e5eK5FfdKwuEuOG34xuB+YjwzmTGWRfgXh++bwgZrx8RPG7foIhzAip4OJzN9NAwTGJ9+EZVJubraNAan7zXoiwCrFqbeho2ML2nXMYRdgdlPJm4if3UDqmziJFvIEcA68L/vLMe5zqDqF3sbVVFn/MZrQb1xNs2z+1q/mooovV5rI/+Mn/cDs5PV6L/HUOOJ3ZXKxGGi3UDmXwm+OLzHt1k8rOxVKFQ/A7HatpZh5c0FW9/u6q8nIgI7ZOUghA7fqnZG0P5EpSgU8Qd+fy6lnxzWWTcR+MGxfNjA8yW4CYkYByRtL6rMTZDcSSyXDeibcXNg89Z+cQSh2PGqy45sazWFdWQrKqaRc/4o/ZSOaxyD62S7U34AYWPY65d8c/PN3+Dq8e
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eec08d1-5ba4-40d8-3a87-08d79502ff05
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 12:54:00.1278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhoBVF3w6vtJ8wVMESCiIAniuqecmlLZia9ex/uXDe2QTv04qIkWIbbdNAj1OamncwHfGZvD5ck9Y6F0CrsyTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1206
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If there is no TEE with which the driver can communicate, then
print an error message and return.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/tee/amdtee/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index b3f8235579f7..0840be03a3ab 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -440,8 +440,10 @@ static int __init amdtee_driver_init(void)
 	int rc;
 
 	rc = psp_check_tee_status();
-	if (rc)
-		goto err_fail;
+	if (rc) {
+		pr_err("amd-tee driver: tee not present\n");
+		return rc;
+	}
 
 	drv_data = kzalloc(sizeof(*drv_data), GFP_KERNEL);
 	if (IS_ERR(drv_data))
@@ -490,7 +492,6 @@ static int __init amdtee_driver_init(void)
 	kfree(drv_data);
 	drv_data = NULL;
 
-err_fail:
 	pr_err("amd-tee driver initialization failed\n");
 	return rc;
 }
-- 
2.17.1

