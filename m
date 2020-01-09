Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC2AC32771
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A51E72080D
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="pbcP2qUh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgAIMyQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:54:16 -0500
Received: from mail-co1nam11on2042.outbound.protection.outlook.com ([40.107.220.42]:21793
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729398AbgAIMyQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 07:54:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOIKHl0fxExfvqtwwAt8OGlLuLGja/LQgDWzuEP026Brc/iph0FRUmlV5rVg/FwX/IszhXXxinKbTW3xKrNWWwwbibpVNiDsGAoF6hhXMGjrMHQAbirhe3K0/3dZddE1xVOZDDf/tLGKoW83zbI+G/uQ0cFVaozr9VOh/J1v1JfxVpU3ajValogPsrefRZ+b5b5Bz5KBbgYj8LiJowrjHIsVu+7LNmAhMcNkwMiEkyEUx6SCdOI3z+KpqnTsxV4mWd7RYwGb6zLgrIVHfz2MudD5TQP7vpUYUgV8pb9A4LV/4k+hLKAe5PPk7uxZA4pJAgoVE+TtX+hS6R7hN8JmvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sg97gArTgOc7dUrMMIfy6m1FxUr73enY54GrLZ9SeYw=;
 b=I9FURVoO+UQF44EXXDyWMbTXHn0W1GZKTBtzxwIt9ujPpgAt3nt+FCrLoQmax+RfYKSMguE7zFaIHf19HkPRF0WSlaJfLgfeyV2y+5sr5ewKO/O3WrSppAgty5ucB+L/mEBJrPPXxB4mGf8QOMZQSQc84a3uxbR5QG1i3oHuPRyr1qhjrN2psZn99r7FlN3QVMmU0qsZDf8/z/aThvw5OfbebjHZQGXBzj5HKXyWQ3PmJwWJHFDonRggINmGrlI40FvleA974yyZwZZXDSnXCQea0qlruHSISUdngb246pbS+MKywRMZiKhhJu7yf/gVuOujLTpdKxPQtvIgs9IUFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sg97gArTgOc7dUrMMIfy6m1FxUr73enY54GrLZ9SeYw=;
 b=pbcP2qUhyDBE9x35Uroa0kud8XPnDJyNQlav/eUDWIJ0is5H0vzpVNj3bbr1fgO82e4WsTQKf453emk7Igwtyid41V9qas/yQP2vUygbRhTvga+6A2awMirBQyoZk5veYwkynjsAM0QjWu/N2ZhrACPN3BTStBgHf7gP6rXCb68=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1783.namprd12.prod.outlook.com (10.175.62.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.13; Thu, 9 Jan 2020 12:54:10 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2602.018; Thu, 9 Jan 2020
 12:54:10 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Jens Wiklander <jens.wiklander@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary R Hook <gary.hook@amd.com>, tee-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5/5] tee: amdtee: remove redundant NULL check for pool
Date:   Thu,  9 Jan 2020 18:23:22 +0530
Message-Id: <abf8683e312983a0bc8b0405677fd43f27f6104b.1578572591.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
References: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::13) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from andbang5.amd.com (165.204.156.251) by MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Thu, 9 Jan 2020 12:54:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d3b74ab-24ae-43d0-20cd-08d795030518
X-MS-TrafficTypeDiagnostic: CY4PR12MB1783:|CY4PR12MB1783:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB17832379BB36147EAA0AEE61CF390@CY4PR12MB1783.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 02778BF158
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(199004)(189003)(478600001)(86362001)(7696005)(4326008)(52116002)(956004)(2616005)(8936002)(2906002)(81166006)(81156014)(8676002)(6486002)(16526019)(66946007)(66556008)(316002)(36756003)(54906003)(110136005)(186003)(4744005)(26005)(6666004)(5660300002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1783;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ovc31xGf0wn77h2Gsn6VDLgSB7N1Dm2qqsRqq02E5CnWctVRjMERAgrzkj1Iy7RCjGEu8Fx6au1GPYnTO+sub36npAs2itfHMHlf8YiD4+vGI34xncEIRjJneDocsDca/5azKynnnPCACPtGMmi9YW/TjyzCRfMHOkWHJzkA4j6yf5SOycQb8I0YdtwibxTYXj9I+NgDbFiJoXVDSVxKJlCCMG36N+vAAwThvyaTeE4ZJD3HYhvCb+odAvBzeFHoiA+rHKlOSiKSz5zymbjMCYqjfEecAVsjyjhyXqBQsaknQWwJbewlw9RCNpWk93DgfjCEUyhtIV8hQ548vm1UVtlVi/E744a7jf3wtEqIJmNbaUfUI0iXjC83/LWoFnSayUsPq3PnyWLeAxMu/AGh7qcetdLVb37xxKLCr+ks+/jNUzlkjtDMjCYaH8Ic/4ag
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d3b74ab-24ae-43d0-20cd-08d795030518
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 12:54:10.3030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ibViy1iNZ8ER1JhucIiEXqNdSxCt6nFqDQbehc2f+2igR8rcF8Bq8LX/hhthUaRC5eKj7I3VEVIAesmmaIhAAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1783
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove NULL check for pool variable, since in the current
code path it is guaranteed to be non-NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/tee/amdtee/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index 45402844b669..be8937eb5d43 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -484,8 +484,7 @@ static int __init amdtee_driver_init(void)
 	tee_device_unregister(amdtee->teedev);
 
 err_free_pool:
-	if (pool)
-		tee_shm_pool_free(pool);
+	tee_shm_pool_free(pool);
 
 err_kfree_amdtee:
 	kfree(amdtee);
-- 
2.17.1

