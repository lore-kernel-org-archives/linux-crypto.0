Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6491C2D0C3
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 06:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E2BB20CC7
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 06:19:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="C4XdxFc7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfL0GT6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 01:19:58 -0500
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:35118
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfL0GT6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 01:19:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfoEaSlKKMp9qw1q2LdKecpzNkLGrzdTX+/5x2DydxS4K9dohl9yPKFyXlKoGpqmOhCv0zgSfcsumKftNWpQWPc+Eo1QlflFr0mtneSqyq1P5j0yuIeQfFa2IbeJ1AS+JIMNOOmpEoNJdDMJ4oO6A3r35JgIk6qXwTqLJG7M9dvYWbEvm6tOLd9hTtUWVWwMSqFIwaZAAG0GyQj/OQzcpgbIaqGrAjGvB6Sz9tURqCtUpWeU7cVzTmkQ1q9GBqekA5eQLHuFRhHQYtB4DVKRznAS43KzNuUaSE7qyV6Wj7Xgrking/q92n6MvPCyrHU2UvaS8ixjaCv0rfEHjGzaIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVxp5Lr18nKG2Neebwv2HAv0aIcWxS3P6ponrcFHiEY=;
 b=f51QVcLCwlptVFim17sHeuxR+pw3bN56QMwl+k7V6j+CK68VcaTCZnV6mr2Ew+Ba671GxWX4dcxRRxXfA3tbX3l71INNJB7Uo+Be89JDdhto0zIA5N1h8M9Xz6ROvPBqZ+6KrTStXvki/R0dpIvTA9lWRz+5GDoTbm2UgGXJdV4ZI2XS/fANfHX71EqFrKQ/ztmb6WIyFUZSCZ12JPj61SrUH3jJw6YUcDdAgFDE+bT4iwrEV9byfWm+DBzSvmcAdiIOfboNg23mZw2nPmnAq25XHnkC6EyzrTKT/9e1j7MmowY0rhfUEevWc96twAT45htNCEL35wr7tfxwehBMOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVxp5Lr18nKG2Neebwv2HAv0aIcWxS3P6ponrcFHiEY=;
 b=C4XdxFc7JOK89v6An6UywgfCdBWzicO9sUzH4i7BRNfDTDM7xVfl4hwHQNaOdVUr5bfOltvAMEsd6RXK0VNJYyoQaJJADzNeqbfp76xaBGCGn/vJPpiDskzlk1N+7JpPDIk07jTyVNiSPdkvyMaTyOP0cwvcvJlCOq6Ug1d1mn8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1366.namprd12.prod.outlook.com (10.168.168.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 06:19:55 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 06:19:55 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tee-dev@lists.linaro.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
Subject: [PATCH 1/4] tee: allow compilation of tee subsystem for AMD CPUs
Date:   Fri, 27 Dec 2019 10:54:00 +0530
Message-Id: <515ebade213492080b97ed6426c82a0fe22c03ab.1577423898.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
References: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::32) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from andbang1.amd.com (165.204.156.251) by MA1PR0101CA0022.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2581.11 via Frontend Transport; Fri, 27 Dec 2019 06:19:51 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2f5effb5-f0c0-4e45-2ce8-08d78a94ca34
X-MS-TrafficTypeDiagnostic: CY4PR12MB1366:|CY4PR12MB1366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB13661CD563B190A501CB74B1CF2A0@CY4PR12MB1366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-Forefront-PRVS: 0264FEA5C3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(189003)(199004)(81166006)(110136005)(316002)(8676002)(66556008)(478600001)(6486002)(66946007)(5660300002)(186003)(26005)(8936002)(2906002)(81156014)(54906003)(66476007)(4744005)(956004)(4326008)(86362001)(2616005)(6666004)(52116002)(16526019)(7696005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1366;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64Y6p/KUikjaVDOMofLOHJtMxZ0VghUthflLXUS3OYptFA0LXeTrmhbAO4i+4VPBNXt9jKuPc81QJPW1UVCmZ0h8WL3kSYYnyWIJ0v9KPdG/ecdmzBrKIUOZvHW2X7JVfc9S1gp2dkrk3XSpJbrMQRrXJq8ufX4mSEAOp0ZNk+/v8hxo/96j0KxnOXZ7PueB/bw3uTh7tCbrHX5XFztxs6bIQPIez9J3HyKd/yZ69T7u6VqWUX99t4HfmSsRnfZ2DNHJ62VRWg/Yw+HkEvWAJSlp8t/VjPG5nTirhnchk6rHHQ6AtxldOqzqPcFWiRu7AxvC2CVmZoMtugofObaeEv/bc7c7hSJusBCtJ3Kt0yGMPECI0wqnDEfzuuFVt6lFrQuLY5AaxyEd7F1xTOv+3w6QrZE5bpn7DscH1ds7OoZ2oFdL0geToViZ1H6DjYuH
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5effb5-f0c0-4e45-2ce8-08d78a94ca34
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2019 06:19:55.4771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: viRhhGRGPZD5BDXoP+A0eljRqskK12XYRtwl1nAKdibSw+ov05/Rh52QwGpXX0OFFBNbryfQb4rhno6C4py0Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1366
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow compilation of tee subsystem for AMD's CPUs which have a dedicated
AMD Secure Processor for Trusted Execution Environment (TEE).

Acked-by: Jens Wiklander <jens.wiklander@linaro.org>
Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/tee/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tee/Kconfig b/drivers/tee/Kconfig
index 676ffcb..4f3197d 100644
--- a/drivers/tee/Kconfig
+++ b/drivers/tee/Kconfig
@@ -2,7 +2,7 @@
 # Generic Trusted Execution Environment Configuration
 config TEE
 	tristate "Trusted Execution Environment support"
-	depends on HAVE_ARM_SMCCC || COMPILE_TEST
+	depends on HAVE_ARM_SMCCC || COMPILE_TEST || CPU_SUP_AMD
 	select DMA_SHARED_BUFFER
 	select GENERIC_ALLOCATOR
 	help
-- 
1.9.1

