Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A22CC432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 05:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E10EF20726
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 05:32:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="mWiwb/7t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLCFcy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 00:32:54 -0500
Received: from mail-eopbgr800057.outbound.protection.outlook.com ([40.107.80.57]:10304
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727044AbfLCFck (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 00:32:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evrI8h+hajCoiyrQgifrzfU57+KV+pFeSW76GA9L91jxYANi4fdkok970/h4xkvMjhLZDIogOUL1iVP2Wn+tW1ZNpgg2YeEw8ISs/5dI154YnL67HKGrWBjUCJuZU42OHdKrGjhoAI8tmjIp+jKGm+VGFgMkjGtQWdngU4Uph21kgfxoPOd1p8ycuSX+T4bZqesxw66/os6C1WKf6bpkvyV0XlhPRWzjgLYLs3KHoGzRenfw9b7x7V0jjTf1Qq3jbC7XjanMmYaZIg9iy9xP6B4X/2Z9pAM1ISzHpQzg6xOTWhRzRX69pATlGM0rwMRaGZFgcBzraHIWOlwJEhhz2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJHGGLuOWyMGN44N0vmISzbjuaHH1aMpsKdMq9cRTgo=;
 b=IxlGX05IwrWYbVKDjzdDlP8sg2hpsxNlYSuPdmY1n6UajdKgBOw1YfIz5imnlo1ZGXJH2OhlDuMKD/3AhDrjauOEEx9qQhbXIxH9fgY2OZA82s90ucatzvxIlJ8Yv29PBwb7nJaF5BeR0HY7/2FyQE6CWssmQJG5+O6hjpCsKoR0E1OmX/+lFUYCWTmSXo4F9E5m1hgFaw4R8WG/nQ8kxnS/COP5ACve7b/8nmC03hm8vfCFbo3eUf4F1bGwnTF6bUT4XD4XjlObUextLE/NJmc5qOQQPCl6iQ8Y6dawjJ0/clKme50/yRKefvHmrLEn7eMYNXoTriN+aHilOcPF1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJHGGLuOWyMGN44N0vmISzbjuaHH1aMpsKdMq9cRTgo=;
 b=mWiwb/7t2jgVEAbnKN8hTB9+llGQ3CrT9yuyt+RrPqyrC2MibLEC8aIE8nkMcuVJyQNPX7io4IRb60w9bC6k2Ux3K0A9sDhRMaxYOkMLz4Zz/SWRtCHTY4VXHTBF7wB43bmKX+EfZxCFMpKaMScp4dDd/PM8CqS5ixoVVbTaGmE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1430.namprd12.prod.outlook.com (10.168.167.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Tue, 3 Dec 2019 05:32:28 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2495.014; Tue, 3 Dec 2019
 05:32:28 +0000
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
Subject: [RFC PATCH v2 3/6] crypto: ccp - move SEV vdata to a dedicated data structure
Date:   Tue,  3 Dec 2019 10:09:18 +0530
Message-Id: <59470a43465aa3d535e3617a9a932085fb5ec53d.1575282249.git.Rijo-john.Thomas@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4e09344f-209e-40c5-b305-08d777b22f95
X-MS-TrafficTypeDiagnostic: CY4PR12MB1430:|CY4PR12MB1430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB14301B02B08472C74782551ECF420@CY4PR12MB1430.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 02408926C4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(81156014)(3846002)(50226002)(52116002)(305945005)(11346002)(2616005)(186003)(316002)(110136005)(6486002)(16586007)(26005)(48376002)(66556008)(66476007)(66946007)(54906003)(14444005)(5660300002)(6666004)(478600001)(14454004)(36756003)(51416003)(8676002)(8936002)(50466002)(99286004)(386003)(6436002)(446003)(25786009)(6506007)(76176011)(7736002)(118296001)(47776003)(6116002)(86362001)(6512007)(2906002)(66066001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1430;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5A8OKqqMo/gnZlHsrZmPRRVWEF/OttM659p/k7lRPVxAuMvCxcvoAdcUjSnJL8OLbGCHljCCf40rnM4Z1CiYvAFAXrWTo0p7d5ez350UU0KvfyLpWBH1GVdGR4cRwdzPZZ3VF/duz0PUCiDNWxpVoCWnsTkyN8Z+pPdh+IpkpWf8mSOIuRSQRUxSA1H/F0Dw4GkoIjL2Dglp4nYKc6Vy5e/wcx2n9jBFjcho9K2d1QpWyhkmCWVbzIUi2w77efxkcrCrzm52AcPHje/LxFM1ZfowlXqiYASCqwjollQG08qMvDKQVUHDGpnyzz5X/inh/tHvkE7aGalVB6kQeAwROrQt5qvqaVG76OVfoIfO6nPeLaxEwB8lUxlN/lYm1EMRcs7JEg5iOy8r5/malvUlg4wdLOG8kTLWuKLhYKnyM6O1mYGwboZGJYHGdSC2ykjc
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e09344f-209e-40c5-b305-08d777b22f95
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2019 05:32:28.9005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ccBA0ngHbES/4WD5K5jJcGYq6peAeLQDUuuchLBQqNeyBBf8l8i+sKb8tQPfl3eYZ3ed/H/zEgYgHbIMFGtsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1430
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PSP can support both SEV and TEE interface. Therefore, move
SEV specific registers to a dedicated data structure.
TEE interface specific registers will be added in a later
patch.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Jens Wiklander <jens.wiklander@linaro.org>
Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 17 ++++++++++++-----
 drivers/crypto/ccp/sev-dev.h |  2 ++
 drivers/crypto/ccp/sp-dev.h  |  6 +++++-
 drivers/crypto/ccp/sp-pci.c  | 16 ++++++++++++----
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ec595e6..a5bcbd5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -65,7 +65,7 @@ static void sev_irq_handler(int irq, void *data, unsigned int status)
 		return;
 
 	/* Check if it is SEV command completion: */
-	reg = ioread32(sev->io_regs + sev->psp->vdata->cmdresp_reg);
+	reg = ioread32(sev->io_regs + sev->vdata->cmdresp_reg);
 	if (reg & PSP_CMDRESP_RESP) {
 		sev->int_rcvd = 1;
 		wake_up(&sev->int_queue);
@@ -82,7 +82,7 @@ static int sev_wait_cmd_ioc(struct sev_device *sev,
 	if (!ret)
 		return -ETIMEDOUT;
 
-	*reg = ioread32(sev->io_regs + sev->psp->vdata->cmdresp_reg);
+	*reg = ioread32(sev->io_regs + sev->vdata->cmdresp_reg);
 
 	return 0;
 }
@@ -148,15 +148,15 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
 			     sev_cmd_buffer_len(cmd), false);
 
-	iowrite32(phys_lsb, sev->io_regs + psp->vdata->cmdbuff_addr_lo_reg);
-	iowrite32(phys_msb, sev->io_regs + psp->vdata->cmdbuff_addr_hi_reg);
+	iowrite32(phys_lsb, sev->io_regs + sev->vdata->cmdbuff_addr_lo_reg);
+	iowrite32(phys_msb, sev->io_regs + sev->vdata->cmdbuff_addr_hi_reg);
 
 	sev->int_rcvd = 0;
 
 	reg = cmd;
 	reg <<= SEV_CMDRESP_CMD_SHIFT;
 	reg |= SEV_CMDRESP_IOC;
-	iowrite32(reg, sev->io_regs + psp->vdata->cmdresp_reg);
+	iowrite32(reg, sev->io_regs + sev->vdata->cmdresp_reg);
 
 	/* wait for command completion */
 	ret = sev_wait_cmd_ioc(sev, &reg, psp_timeout);
@@ -934,6 +934,13 @@ int sev_dev_init(struct psp_device *psp)
 
 	sev->io_regs = psp->io_regs;
 
+	sev->vdata = (struct sev_vdata *)psp->vdata->sev;
+	if (!sev->vdata) {
+		ret = -ENODEV;
+		dev_err(dev, "sev: missing driver data\n");
+		goto e_err;
+	}
+
 	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);
 
 	ret = sev_misc_init(sev);
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index d54fce1..bec0ba31 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -39,6 +39,8 @@ struct sev_device {
 
 	void __iomem *io_regs;
 
+	struct sev_vdata *vdata;
+
 	int state;
 	unsigned int int_rcvd;
 	wait_queue_head_t int_queue;
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 53c1256..0394c75 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -39,10 +39,14 @@ struct ccp_vdata {
 	const unsigned int rsamax;
 };
 
-struct psp_vdata {
+struct sev_vdata {
 	const unsigned int cmdresp_reg;
 	const unsigned int cmdbuff_addr_lo_reg;
 	const unsigned int cmdbuff_addr_hi_reg;
+};
+
+struct psp_vdata {
+	const struct sev_vdata *sev;
 	const unsigned int feature_reg;
 	const unsigned int inten_reg;
 	const unsigned int intsts_reg;
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index b29d2e6..733693d 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -262,19 +262,27 @@ static int sp_pci_resume(struct pci_dev *pdev)
 #endif
 
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
-static const struct psp_vdata pspv1 = {
+static const struct sev_vdata sevv1 = {
 	.cmdresp_reg		= 0x10580,
 	.cmdbuff_addr_lo_reg	= 0x105e0,
 	.cmdbuff_addr_hi_reg	= 0x105e4,
+};
+
+static const struct sev_vdata sevv2 = {
+	.cmdresp_reg		= 0x10980,
+	.cmdbuff_addr_lo_reg	= 0x109e0,
+	.cmdbuff_addr_hi_reg	= 0x109e4,
+};
+
+static const struct psp_vdata pspv1 = {
+	.sev			= &sevv1,
 	.feature_reg		= 0x105fc,
 	.inten_reg		= 0x10610,
 	.intsts_reg		= 0x10614,
 };
 
 static const struct psp_vdata pspv2 = {
-	.cmdresp_reg		= 0x10980,
-	.cmdbuff_addr_lo_reg	= 0x109e0,
-	.cmdbuff_addr_hi_reg	= 0x109e4,
+	.sev			= &sevv2,
 	.feature_reg		= 0x109fc,
 	.inten_reg		= 0x10690,
 	.intsts_reg		= 0x10694,
-- 
1.9.1

