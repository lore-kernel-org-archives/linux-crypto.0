Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C145C3F2C6
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 13:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCC8D20675
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 13:57:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="Qn/dIOkd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgCCN54 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 08:57:56 -0500
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:6067
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727121AbgCCN54 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 08:57:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMjSFjtr8usF4aVVsXnWw0PjcNQC406OheZCZUryAzvgR0Zi/XNI44auGC3hEkTqp8wiSdYxYGbUtDS/ND3mwPJ5UX4CJu1JD9FI7q6rFaEUMNuos0ltGuPXRS+ffFyiyKLJun9kJwvYTCiQYuqGLt7REMv0iPzyo0U3qNMH9ffTTZupsPKPS+ACf4q8HMxiUrSNd7MIV0Lml2eDC0vhXKFjWOX3Vy320SsmRfupdUK2ieqPUn2wtLA4sFE09b/v+UaYeLbL1KqM6NeSiA+DSnQaZcLsj31Yiu6Cae8ZiHYnLyq7mu2LQRLyNw4uEtb+m6/w6hGevwujj1b8cNNiKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJWKSBT/aIMsiaHAo7Xx1K4koZvC1HU6IjSKPPkAzPc=;
 b=YRIhMhCRXBt4rZQlQNjI1p7F/n7VKo1L5Jfuhe4q/0QrYtGNuiQxPiqmWVfVFQplbgsrgw7MCAgDOoqb8awYtUG2pIT+/311aDVFOp1vtKDkfS1/0nO/4+SJtWikAjVLYC65qbOqLqlhIJ2CXMAz/ojXTIO6zf7snHrpcReKTWkIC2tdwPyWaDaPd/uRegzYjAnSNUz701iWG7svtxF8uB8chqrsGxoD0JgCRRsS+h5Q2S5r8AC142dr9W5G1atPtYQT3SbrDVSGm1RPUmUVzGy3yh3EaelT0J939Cv5uHhKymrnofYdmYnM7LIusIsWM+6mnweiZAW416hSKKAeow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJWKSBT/aIMsiaHAo7Xx1K4koZvC1HU6IjSKPPkAzPc=;
 b=Qn/dIOkdChYTk6CQsRiayZFxY4H1DwbtoLvNCW+ciBrOcMkM1lY/s+Q2pZ7TJHDezH6/MqcO/Kd3TQ206Nd1C3jWX9w1e9gxV+he5ovz6s932+KzvB92VrX5RgtOWywAdtDihJS3dSjT1WQ+XFKmTl3x8H0ZJ2eqsl0aRm9oQ8Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=John.Allen@amd.com; 
Received: from SN1PR12MB2448.namprd12.prod.outlook.com (2603:10b6:802:28::23)
 by SN1PR12MB2349.namprd12.prod.outlook.com (2603:10b6:802:2a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Tue, 3 Mar
 2020 13:57:53 +0000
Received: from SN1PR12MB2448.namprd12.prod.outlook.com
 ([fe80::4064:dc7:d9b9:1f64]) by SN1PR12MB2448.namprd12.prod.outlook.com
 ([fe80::4064:dc7:d9b9:1f64%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 13:57:53 +0000
From:   John Allen <john.allen@amd.com>
To:     linux-crypto@vger.kernel.org
Cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, brijesh.singh@amd.com, bp@suse.de,
        linux-kernel@vger.kernel.org, John Allen <john.allen@amd.com>
Subject: [PATCH 1/2] crypto/ccp: Cleanup misc_dev on sev_exit()
Date:   Tue,  3 Mar 2020 07:57:23 -0600
Message-Id: <20200303135724.14060-2-john.allen@amd.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303135724.14060-1-john.allen@amd.com>
References: <20200303135724.14060-1-john.allen@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0060.namprd07.prod.outlook.com
 (2603:10b6:4:ad::25) To SN1PR12MB2448.namprd12.prod.outlook.com
 (2603:10b6:802:28::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mojo.amd.com (165.204.77.1) by DM5PR07CA0060.namprd07.prod.outlook.com (2603:10b6:4:ad::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Tue, 3 Mar 2020 13:57:52 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8c4501bd-b91b-441c-d26e-08d7bf7ade3a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2349:|SN1PR12MB2349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB234983338C8D48C957D754169AE40@SN1PR12MB2349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(189003)(199004)(316002)(478600001)(2616005)(956004)(8936002)(81166006)(81156014)(6916009)(8676002)(86362001)(44832011)(36756003)(26005)(186003)(16526019)(6486002)(6666004)(1076003)(66946007)(66476007)(4326008)(5660300002)(2906002)(52116002)(7696005)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2349;H:SN1PR12MB2448.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KGdzdEGEtuQlPs+2+3mgryrakLi/xNL285XmpE2EQRLT1NkjJv3Il0331yGlJi72+xiz4f3COy3ar64q9/kFGcNOc04FB4Tu4hYbrDYUI2FjeqfA3gSUp6+rITq1gkeStlm5ifp+LKcInvHJqIxW1kxMkaBMzXOWjoGKKT1u+I9TMGjUF5zDbecRbqQzukIafzS+SU4HFwwIihMrm46oqzqeFd0+MmYRoINnprGdtv9Pwb0EtCgXiuCLbeeJH89w7gm1IDjZirhAr7vmQy1WxkzzfmG0s7jZFgyhzEiGPJkdT56XVvOvOjPeuB1pc23Pkfr6OESja7pUv2ojlLg+cZJvz05gZSFVAt/LgEU2iQIvAgFjFC2W5CGAOK2eimU5EVF9J/JvvJbPKYyihtUanmhgD19Gwu8J79NwS0Z5NCnx2LVtT9clVFfm7CtBYNjh
X-MS-Exchange-AntiSpam-MessageData: bnf2N+2dWdY9fBPDqT1ogUmwceCEGw4WEnWGpsqcPxmIicKPzTDpLGwjer9OvomBMD6IPfEc7lG9L1gKl17+IT1HxOhO5bgixroBNwnfj3KlMXB+SVACiTu2bkTi+rOPbk+dY2ktUAralCANinr+iw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c4501bd-b91b-441c-d26e-08d7bf7ade3a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 13:57:53.5174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qqi3NomNjbJMU7wPxAZB1oEQCZGdTubCLDQzRmOlUMqVm5Oq9RkS2t+ir7WRvIIR+ZsJCGXyDoL4tzH9SFPlxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2349
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Explicitly free and clear misc_dev in sev_exit(). Since devm_kzalloc()
associates misc_dev with the first device that gets probed, change from
devm_kzalloc() to kzalloc() and explicitly free memory in sev_exit() as
the first device probed is not guaranteed to be the last device released.
To ensure that the variable gets properly set to NULL, remove the local
definition of misc_dev.

Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
Signed-off-by: John Allen <john.allen@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e467860f797d..aa591dae067c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -896,9 +896,9 @@ EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
 static void sev_exit(struct kref *ref)
 {
-	struct sev_misc_dev *misc_dev = container_of(ref, struct sev_misc_dev, refcount);
-
 	misc_deregister(&misc_dev->misc);
+	kfree(misc_dev);
+	misc_dev = NULL;
 }
 
 static int sev_misc_init(struct sev_device *sev)
@@ -916,7 +916,7 @@ static int sev_misc_init(struct sev_device *sev)
 	if (!misc_dev) {
 		struct miscdevice *misc;
 
-		misc_dev = devm_kzalloc(dev, sizeof(*misc_dev), GFP_KERNEL);
+		misc_dev = kzalloc(sizeof(*misc_dev), GFP_KERNEL);
 		if (!misc_dev)
 			return -ENOMEM;
 
-- 
2.18.2

