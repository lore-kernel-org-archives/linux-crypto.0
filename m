Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02ECC33CA2
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 861562077B
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:54:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="c7ZKXeus"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgAIMyJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:54:09 -0500
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:49857
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728298AbgAIMyJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 07:54:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmYHsDzchA1y4uKjmdvtmOYly+WdoaU/x34xRQYR+ieWQfJERevvovKQUMpyvhtEzLwaXNfNfOCYL23VFyIyABnDPjuTFWfSagKMIgOwqh4yw3B5aym1jnisRiw9NK3AZl4uEFlKgEyg67bIHdaQ+MLNxcOkniRpIpV8vUztfPg6ohdLyzojFgAHpkwjyNLIWZlUfYWCKp/yp0Q7vkTSdeXTkB92ELnpD4lAAtYQodqErzupQBWhFqIeKeTMNRZnibcLSCTUZp3xB093+ZqJrbzLVxPlfEp8GisKgZ5FYZ8oD52t4i/MyZVGeSn6VkexvR6kcsDen4T+cPuVRA3TOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCssjBtZ4QoftqFul9RHxc4tmk9S/kMnLRP+byqKOlo=;
 b=Tnx+x/0NcLhpJNhqfZABZZIQ0awJQdpN+1sYQ788iAKsV2Mhg2YmLFiuraxJI5TpUAx+2nnPJvbOGtjA8PtWbuSyx45Dw7lJKKyD1uKLmJbk21slDApT+tXP2Rgqh6rCCBnvr2sB3MSc7kSWbrQ2hNlgb/o5wmiRGxSq5OUA4f6WAcq1irTZdGMyUDahs7ZMITxUDMtuVDv9SDNazZJxRjVspk9M8R9RaQEV8YorfCw2mOF9HPo2nXBaX3y775IhQ5tTsHLMUPkv8k9QzIqoi7bQEgdyxCb2CB+V3+Bcii2sTU78/8g8xEq+wNelfNz7SpgLTkXdmo7LhXOysPnHRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCssjBtZ4QoftqFul9RHxc4tmk9S/kMnLRP+byqKOlo=;
 b=c7ZKXeus6+rzxsQOSbwqBMPfRY6Dp7KFdAbFAmMwn4RClqQ2cdsm62EVNGdr5IqHAIcKn2l305pES9HFnuIEPd8aH65DZvoGYIpig/7XH1VPk6P5pA/H2/zo5TTxK+f87sGQne9Pnkzhx9CbeakVZKwxP499fevi7uT5OoU93DE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1704.namprd12.prod.outlook.com (10.175.60.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Thu, 9 Jan 2020 12:54:07 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2602.018; Thu, 9 Jan 2020
 12:54:07 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Jens Wiklander <jens.wiklander@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary R Hook <gary.hook@amd.com>, tee-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4/5] tee: amdtee: rename err label to err_device_unregister
Date:   Thu,  9 Jan 2020 18:23:21 +0530
Message-Id: <433e3acdf28ca06dc39bb1636c56431657b42da2.1578572591.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
References: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::13) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from andbang5.amd.com (165.204.156.251) by MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Thu, 9 Jan 2020 12:54:03 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9be49e86-ddcd-4007-18aa-08d795030313
X-MS-TrafficTypeDiagnostic: CY4PR12MB1704:|CY4PR12MB1704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1704E5F7E98F9ECDFCFC2C30CF390@CY4PR12MB1704.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 02778BF158
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(199004)(189003)(5660300002)(36756003)(8936002)(52116002)(7696005)(316002)(54906003)(110136005)(81166006)(8676002)(81156014)(4326008)(478600001)(66946007)(956004)(66476007)(66556008)(2906002)(16526019)(186003)(26005)(2616005)(6486002)(86362001)(4744005)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1704;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7eZA+cNbhYAA+WC47fcTV1O3n6v+W4dZFPMPu+9rEJsRfthBCbBgvc3jUm+e+YrZ2/qx5MUnuQPLewcdNO29uG0Vhhtdv/2zs1BLESbyBjRONOfMCl0jAbaDWV7RON9YP37NVBNDfA/EMg0jGThpJJerAHcoO2ch2r0dAz9euUKIWAPg2wnrV4qvRTN6wEJBaR1ZurnOHWFWQRuFk+WFn33avqWu+Q2Q7HN1RypTxyv7WtbneUB+67FuJOJKbZG3Qy6nGK5YC1Wx/rxRXaHS8KN9KlARRx+x6v7g5yrceCGbkSorDTJTB8sUbf2KzpUbSQA34A/bZpCOjI0FlmMOOqCeZjBnsechb3Hgj04zpRZyVqksZgTxVUffiqqt+9+CIJV8+G0+JCfo63Bd59uuiVE8M8cDQekjj9MI0DJ3MxJrEr6M1qvWjawHe6/KgQnV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be49e86-ddcd-4007-18aa-08d795030313
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 12:54:06.9296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGc+lAOGPJ1OQL2i949wsi5+P3IpmkZonXk+e833HM9bPS8EhTr1d8nj1g0PO7RxhOXcrsP6tPMUbGnzmZ5xsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1704
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rename err label to err_device_unregister for better
readability.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/tee/amdtee/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index c657b9728eae..45402844b669 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -471,7 +471,7 @@ static int __init amdtee_driver_init(void)
 
 	rc = tee_device_register(amdtee->teedev);
 	if (rc)
-		goto err;
+		goto err_device_unregister;
 
 	amdtee->pool = pool;
 
@@ -480,7 +480,7 @@ static int __init amdtee_driver_init(void)
 	pr_info("amd-tee driver initialization successful\n");
 	return 0;
 
-err:
+err_device_unregister:
 	tee_device_unregister(amdtee->teedev);
 
 err_free_pool:
-- 
2.17.1

