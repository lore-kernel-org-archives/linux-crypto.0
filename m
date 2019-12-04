Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FC6C43603
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 07:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 485072086D
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 07:12:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="Xhv8lg75"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfLDHMO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 02:12:14 -0500
Received: from mail-eopbgr680043.outbound.protection.outlook.com ([40.107.68.43]:59426
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727307AbfLDHML (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 02:12:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mf9dhc/4OWSLDOFk/b/E0qMAqM93VJ2bUwVWyzZ/+Y0qb/Ljt7TvhjksARFGW041EKU6qkKhDbodyS4v6Qa1lEhpHkcmzeB4A+VTHPSvrSyaHF3V3nVt90H0hauM3Qh8roWRhb0LYVRodPCidmdXlF/9+ybsk6Rd5iQ98/av1P2LbawXv7H3buO5yYsBE8Dk/oSVy7jSScl+iu3zmFYWdd82146tfNTYw+HTuwDtT5HFXJLkdsMDN0d2MCjZBe02WgQxDH2xzaONEcslVCJxBB+ookp7qgNVgWDMONhwyPh4g0zn4TsFa401YqrVuUIrhTQxwbA7o8t1rIV2ZfTWIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnAiw7g3v04HWn3G+BPKHKgTcmNcjDd10XpybQlzZGQ=;
 b=NNvq5Ygv8U4V+bASRBixfoVVLqp0eA12QKeuOsZPbK7J3fcM6osF/vAAfJ9X5l8IAFwgwK4uKtEpNEFW5ZpdYlJyjY1Fo9bZJe+u1dWLln353DahQMhvSInBBh5E3Ng7iwYMLfeUePNVMoX6ezpfeiTKftH0MxnNF8J0A0Q9cJ/3WgGUlpVxl24hwJEoaMatxKp2butktxQdRYV22BXbCdbO16KsekjK6EWeYLNUaP/8FWoQWkdApLg0lI+COB1MrEmu8+zmLlUQKshsDascpI7kj+es743R5AisA12xStDy1sSR+2mnxBhwphZCzGiqhLabLiXoex80S8HEit7RQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnAiw7g3v04HWn3G+BPKHKgTcmNcjDd10XpybQlzZGQ=;
 b=Xhv8lg75ZzshUQgsevmUvRwHX2cG2ZNapediWi60wHtctitAv71hOfoiGSDsHyjrAThLtFmdEMR4p1I8L/hqQHz4XVR37RwORuuUGvaljHyANbAbJ8R2Tt12ZynzlFz7/lcogtgo4zQYQ0KAbQ/Ds5+2jctqXn+zm/76LeA0j9c=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1400.namprd12.prod.outlook.com (10.168.165.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 07:11:48 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2495.014; Wed, 4 Dec 2019
 07:11:48 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH v3 4/6] crypto: ccp - check whether PSP supports SEV or TEE before initialization
Date:   Wed,  4 Dec 2019 11:49:01 +0530
Message-Id: <6a7be399d095373d2677440ff1fef406f97bf0d0.1575438845.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
References: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0065.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::27) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 841953a6-dd65-4871-5c99-08d778893a66
X-MS-TrafficTypeDiagnostic: CY4PR12MB1400:|CY4PR12MB1400:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB14003207F959818E6319C25FCF5D0@CY4PR12MB1400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0241D5F98C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(2616005)(66556008)(2906002)(66476007)(50466002)(48376002)(478600001)(14454004)(50226002)(11346002)(36756003)(81156014)(26005)(54906003)(110136005)(81166006)(3846002)(66946007)(8936002)(446003)(8676002)(5660300002)(6486002)(6116002)(386003)(186003)(6436002)(4326008)(99286004)(25786009)(6506007)(14444005)(118296001)(76176011)(16586007)(316002)(86362001)(52116002)(7736002)(51416003)(6666004)(6512007)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1400;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fg2BtF++/cW2XsqE5I3O4NSxz7pRMMc7XbxKdMbue6ely1gVLfLKxdI2XGJW2kmUNdWE68vIL9QsthQyS4VJjrCyGlPGv9/3p2sAjgiDcQoY9TBqJCrvJgD7sg59adUf7okaN2+b1OrSfca1YXiQMHleYI4Ylhsk+0efAyGCpGY6aAcv1v9vVNGxFzw2FpqLXazd1TOhlEGG53yPyBOk/oDX3sXj1IWhHqGuoQfCLDme98HATOPFDz0scjBpJVl/cAfdTrG8UtMv1gvMsM0BXlGx+eg/1clrMZv8tN9R+YAxj7ukiGhkLuExgYF4n8A6qROetil54oI/BASqYkdPD/9Fa0zCQtFL68GRSXQI7B3aTOOy2edX280/SQJpNS+ZoQcAE9poBrcCrNkWV3tGLY7/sV0Lgq+5sqIqJ70rePiZK2zvzcqsWAvNklS+atOK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841953a6-dd65-4871-5c99-08d778893a66
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2019 07:11:48.5922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dR3MxSywOgvdajB22cgP5bpAjjUdI9tx8A3JQuOgB1ZxHxCq8wSSKKZh3Y1mwGwg0ryH/S7WPxE515XFPDLKTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1400
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Read PSP feature register to check for TEE (Trusted Execution Environment)
support.

If neither SEV nor TEE is supported by PSP, then skip PSP initialization.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Jens Wiklander <jens.wiklander@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 46 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 2cd7a5e..3bedf72 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -53,7 +53,7 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int psp_check_sev_support(struct psp_device *psp)
+static unsigned int psp_get_capability(struct psp_device *psp)
 {
 	unsigned int val = ioread32(psp->io_regs + psp->vdata->feature_reg);
 
@@ -66,11 +66,17 @@ static int psp_check_sev_support(struct psp_device *psp)
 	 */
 	if (val == 0xffffffff) {
 		dev_notice(psp->dev, "psp: unable to access the device: you might be running a broken BIOS.\n");
-		return -ENODEV;
+		return 0;
 	}
 
-	if (!(val & 1)) {
-		/* Device does not support the SEV feature */
+	return val;
+}
+
+static int psp_check_sev_support(struct psp_device *psp,
+				 unsigned int capability)
+{
+	/* Check if device supports SEV feature */
+	if (!(capability & 1)) {
 		dev_dbg(psp->dev, "psp does not support SEV\n");
 		return -ENODEV;
 	}
@@ -78,10 +84,36 @@ static int psp_check_sev_support(struct psp_device *psp)
 	return 0;
 }
 
+static int psp_check_tee_support(struct psp_device *psp,
+				 unsigned int capability)
+{
+	/* Check if device supports TEE feature */
+	if (!(capability & 2)) {
+		dev_dbg(psp->dev, "psp does not support TEE\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int psp_check_support(struct psp_device *psp,
+			     unsigned int capability)
+{
+	int sev_support = psp_check_sev_support(psp, capability);
+	int tee_support = psp_check_tee_support(psp, capability);
+
+	/* Return error if device neither supports SEV nor TEE */
+	if (sev_support && tee_support)
+		return -ENODEV;
+
+	return 0;
+}
+
 int psp_dev_init(struct sp_device *sp)
 {
 	struct device *dev = sp->dev;
 	struct psp_device *psp;
+	unsigned int capability;
 	int ret;
 
 	ret = -ENOMEM;
@@ -100,7 +132,11 @@ int psp_dev_init(struct sp_device *sp)
 
 	psp->io_regs = sp->io_map;
 
-	ret = psp_check_sev_support(psp);
+	capability = psp_get_capability(psp);
+	if (!capability)
+		goto e_disable;
+
+	ret = psp_check_support(psp, capability);
 	if (ret)
 		goto e_disable;
 
-- 
1.9.1

