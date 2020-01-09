Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918F0C33CA1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 674772077B
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:54:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="uC/vT64M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgAIMyG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:54:06 -0500
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:22209
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728298AbgAIMyG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 07:54:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOISwu7MpOi7F7FPPgK52PbjHEexUqpe5acfuM+2zimTnm6s15fyS8h2fIt/lKeh3z0FtmuyDWJ/76k+WGAD2SXDEbCmHT7ywAEWY2ATYlP5FjlHiIuiIVzRUV+SaZdZBF7TRYpCGlUD1axoxm9TAHYQfARIZpGWeRyTIKZqCwUvRkoDrCv6JhORhRgoWB7C1Y78KT0o6OzvFeA4oJCCScA93Grddn48tDOe6PFwGVMj2c4dI+tZ7z4cRE61og1U9aLTiaPvwY+MIJ1eojLisCqF6z8gSGVczEOsv4vymzeCiARkEE+ViLjWh9+okZBAVUJG/mcX0CjZmgdwf8Vztg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o11z9D94Tr2WkQuzV/QR7ecnjbYedWC7rreWuEiZq/A=;
 b=hexU4NanRJXBI8uRZ/m5G5fiSg32OvtKld3/DXCePQD+os1xAUsopF1guAafYMfLaSvlevz9/SxJGLb9WvBkBC2wij12dhBd/8EGGf+dm2kWnqKf3yg6hi0cUnPCltl2MZN7srm7pKSFwX1Hevw/1UhqgfHGxaF5VBb6z/YAQQvq3O7TbKEhYRt26MqtkjptAsGmL6FNDk2hO9AECBVh7Kn0oc4byThnq+WFpIqeUZisqfUCmz6rLuzYOJYstWk9cAFrH9w9YtdZWXJ06sK6072BF7Od1EfAAEYCeHH7RFt7RQdUX/VcCHxQ3L3ttBUBlfd/d8mjeiOeCWu8eLphsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o11z9D94Tr2WkQuzV/QR7ecnjbYedWC7rreWuEiZq/A=;
 b=uC/vT64MlrZun206ineTrkRaeOB02kFWCjpQp8S3SHletpnnZ0Lr1K2YmSk2Sa3+JOg2H57sy+FmnSwSarDVdTd7Fh/rLmBMMao1IQpTnX0YNcrzvoUdPHCGqCcJHTV3TQr0SFbzoWndPEOcfhL0fpfDsUptxGXAmP48L1xazPU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1704.namprd12.prod.outlook.com (10.175.60.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Thu, 9 Jan 2020 12:54:03 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2602.018; Thu, 9 Jan 2020
 12:54:03 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Jens Wiklander <jens.wiklander@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary R Hook <gary.hook@amd.com>, tee-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3/5] tee: amdtee: skip tee_device_unregister if tee_device_alloc fails
Date:   Thu,  9 Jan 2020 18:23:20 +0530
Message-Id: <845049bc920b6873f58f3e8d04514248e73f77c9.1578572591.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
References: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::13) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from andbang5.amd.com (165.204.156.251) by MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Thu, 9 Jan 2020 12:54:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9ce7c0c-d239-4cba-e694-08d795030106
X-MS-TrafficTypeDiagnostic: CY4PR12MB1704:|CY4PR12MB1704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB17046DB884D4EC9F60C136C5CF390@CY4PR12MB1704.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:392;
X-Forefront-PRVS: 02778BF158
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(199004)(189003)(5660300002)(36756003)(8936002)(52116002)(7696005)(316002)(54906003)(110136005)(81166006)(8676002)(81156014)(4326008)(478600001)(66946007)(956004)(66476007)(66556008)(2906002)(16526019)(186003)(26005)(2616005)(6486002)(86362001)(4744005)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1704;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zi9hnFLolLciLunQmNz++m0Px8YY6OV1WC5S1aKcYS0n2EeMtDBfAlRAnP98ZWrPArOmar6KChwpyLP/rD2TOVuwPHR3US84KDTp16VXKj30do6z91Ki20LoZCOLvOEcTn2dQ083zXlslfDWmVgERme2sPK1sL+iJ0wG7+treGBWfz/JHVSSjfYPJ77Fzkzgi6pVJ3jNPvbWNuf/Ie3eBAeTT7AmV6fNiZSQO+edUoSpeR4yU6SgTHU/Kz4Pz8kr60RZi+KJbK0e26uCFlr1c55009OdOwGBwj9/+YCAA4urgVpuACFtmRnZWTB/aw/yORPKcwZb6iJ+UcPtBxQp5An+ymVY9/IlaprLLRr3dgcnfOv3wa+L1cH0D3PYb1HmYf8leBiGjbbj92yy41aueppwoklwlc0o1Me5pGkCAoanD0qe+YsTuGMXNgOEe1ye
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ce7c0c-d239-4cba-e694-08d795030106
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 12:54:03.4852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxzwrU31ZM8/5pTXS8PcqR0FAiYO/WRq2U4VcETDcBCj9NNLpvKx0j/rs2k9a+CoFpuaChk1XAVYk3pd9rApiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1704
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, if tee_device_alloc() fails, then tee_device_unregister()
is a no-op. Therefore, skip the function call to tee_device_unregister() by
introducing a new goto label 'err_free_pool'.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/tee/amdtee/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index 0840be03a3ab..c657b9728eae 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -465,7 +465,7 @@ static int __init amdtee_driver_init(void)
 	teedev = tee_device_alloc(&amdtee_desc, NULL, pool, amdtee);
 	if (IS_ERR(teedev)) {
 		rc = PTR_ERR(teedev);
-		goto err;
+		goto err_free_pool;
 	}
 	amdtee->teedev = teedev;
 
@@ -482,6 +482,8 @@ static int __init amdtee_driver_init(void)
 
 err:
 	tee_device_unregister(amdtee->teedev);
+
+err_free_pool:
 	if (pool)
 		tee_shm_pool_free(pool);
 
-- 
2.17.1

