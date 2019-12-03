Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3A0C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 05:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7B9B206E0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 05:32:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="xMDDzfWP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfLCFcj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 00:32:39 -0500
Received: from mail-eopbgr680088.outbound.protection.outlook.com ([40.107.68.88]:46414
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726480AbfLCFcg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 00:32:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAY5DmlhfxesM00I2fjGr/u27WKgEEH4cHmbOejXIVH1r8Lqf951OYmTOkLhEP/E9BcLt039ZG51BGFi02fVC3/j4mlXmMUGjvMapY9Ixi+BOB6V+e1VxPv2511m/8UcAmToSDsNLOqNddXytquiVSUSrZtX5dw2NxcCYPijbMT/1xYvaXpElZBtALTSx8b2BdPGwldoEM5b0RK23FAvsqLh0oc8CrbX3EvXCrUtG6wRBThRKpUCs3tn79T/aDUAMqDErm4UfSFM/MceHHS26slBbShwBZz/xUqd8neiYRnzGVlyegmZ4zYjcjnFGMTuTFDS7FWimxwQ+r7VpijLhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnAiw7g3v04HWn3G+BPKHKgTcmNcjDd10XpybQlzZGQ=;
 b=FXSP10RNpjQ4ws79h1bfRQyNksk1nYdOTicqKDiVpdmpz+Tg4DRx4pCKm8bFYSmZnIGiyAELQXEar428BWHvee4G4NuGBtdD8v4tcBXTXz5LIEYY/CRZuOxo2fpNqz5nDBXM0BEI0Iz0WeYD511cTQplkJeX1ieKeDidYQJKTSvoSKM2nFLTnEys4o2cw/pjYfie+x3sua0dVpRQ7cvy+0/oUs9PPDY3HUznMPze6BTsUZt6Bc58imjVwYWJUfBoqdCpgOQFIq8DPKKmo6BKTVt81EBX7E/BUAdxlZ+rsf3PmjOfxmiChLhyyrWmO6Rc+YCGEhNtRpUwj6l/HqXzyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnAiw7g3v04HWn3G+BPKHKgTcmNcjDd10XpybQlzZGQ=;
 b=xMDDzfWPJJSsVmBTtRGgDNNO+INDs18/vxbjIjeInNXFGM0+R622642LojqAyFs1JqGGoALfn7x+UgvYzXWP/pxGrLK/Yk+IinSI0c2eDcti3BhluKZAEliPT34N8/uwdxkvOjRteY32x4kXnDhoyQ7St+/gOPB1G72VpP3LyDw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1719.namprd12.prod.outlook.com (10.175.80.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Tue, 3 Dec 2019 05:32:33 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2495.014; Tue, 3 Dec 2019
 05:32:32 +0000
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
Subject: [RFC PATCH v2 4/6] crypto: ccp - check whether PSP supports SEV or TEE before initialization
Date:   Tue,  3 Dec 2019 10:09:19 +0530
Message-Id: <da76e7d2d096b0fa3c11947bd414e18c87eb3591.1575282249.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1575282249.git.Rijo-john.Thomas@amd.com>
References: <cover.1575282249.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0006.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::16) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 46d4f49a-5501-4442-5c75-08d777b231fe
X-MS-TrafficTypeDiagnostic: CY4PR12MB1719:|CY4PR12MB1719:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB17191D9AA5062AC0C830A6DDCF420@CY4PR12MB1719.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 02408926C4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(305945005)(47776003)(2906002)(446003)(66066001)(7736002)(6116002)(3846002)(8676002)(6666004)(81156014)(81166006)(5660300002)(118296001)(66476007)(66556008)(66946007)(8936002)(6512007)(26005)(110136005)(16586007)(316002)(54906003)(99286004)(36756003)(11346002)(50226002)(6436002)(6486002)(4326008)(14454004)(25786009)(2616005)(14444005)(478600001)(6506007)(386003)(186003)(86362001)(50466002)(52116002)(48376002)(76176011)(51416003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1719;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MzE13XCusuUJzgIEfE8Oa8lLgYeBMlxIHk03hmE/tUvVODTwccPi5GPE5m7zAsz2ozaaK3zSGogafb6JGMADJKePIGKSyjgJ1t4/05GRbhH63QJ8FWhSTH9vZgT9zMuwFzkOgghF70WD8uso0g3rmutKb2dIL727zdH/coOkfizjemC72L1kr9B76L1XOsQYrXggmi5GIR5qMzly2XpKWPCAvP2IvNWdIF775BUZFZDe2w9B/NA/q3cFW/47M+GFtvqO+nYIpnTwxnRGOBUYjyHQgcLyBUzHkUfEBS1kuLWhXjBTFb+oe7yWBpw5NsydzVuFyymHepiPCwqnVnV2k4YYWU6/zbAFNAnQbS2dq3X8vC/XGiXuD6oXU0YLnkssbRSTzV451BzamA51l/LJ9R00o9OJGukFcXtHtoBKv6cx4OwVLWd+G3pdBLPUPDAH
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d4f49a-5501-4442-5c75-08d777b231fe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2019 05:32:32.8239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v9Qudi0laCnJu/0NM+hZ6ib4Yp+P2qrYjoMNRhqLPUC/op1DC/e6/Ktd1Mo90nIGx3cnTC9Up0JwKEslQH0LKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1719
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

