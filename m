Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8EDC43603
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 07:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBC972073C
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 07:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="cdl/5cAO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfLDHMJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 02:12:09 -0500
Received: from mail-eopbgr680043.outbound.protection.outlook.com ([40.107.68.43]:59426
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbfLDHMI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 02:12:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPpwN5jidQ8QYDFtHJCKUQ6IZLh95QzWZLSInifdg8kuksjF50gs68gOpWyE2gg09xhehLxjWOWDtZXaY0dILdOcNNHKWvIxKl/vU2uRGK7Kb3EJsfpx9Lzo3HnRTH65r7Uu8uzaSVkhQ6f/l/aQMnUAD+sh5LG2HJUbtDa7andthb8nmojyEQrGIM/3H3bMeKWFbn55NruK4XRgJKYp38e1kh5xOtETp6qXhpKGfnlQbpkGfQ82DWvFsudjlTzUtSoaq6vrko8p61x19EL4m1vS9kZK9MhfDaOpNY9bSVvv9XmnNjx2TM/LeIIWV+GryWj13TZ17BtnkBrN23UFEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLipGE6X8uREktgkwJekUndCo2pr+VSpv1KArsZl2tM=;
 b=IY0Z9b6y0SsDVUZnnRKE1RBz78ooEL6jdljoMSGlRU7/3op/gTne/68FYD+LUujcyDy2hoqfPs4dSkyV8qXre4AhrkEg07ABX0VCbfhaZTxqNUZaIKMGFXaBXYVtSoPkEwYpqQSNf75RYtBqu7IV1dwU62Zp2PWoLWxlgBKuxbTOHf3/fXg3vNS4BO2lOb2l8+E+rU9gYmKW5piaSIl/7I+oq06G7lZtNPf0dFoRVL/idnbYvY9cp/71PzdcLNXSGUuqRJUNbqwMlykCB7w/z++SDPnmvpoVsnAhXm9qUjbaouqNGHQvFp6vTm5Im8MLgyvwHD9TlAmr+YXY6s+cmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLipGE6X8uREktgkwJekUndCo2pr+VSpv1KArsZl2tM=;
 b=cdl/5cAOZyouca6zWNG4v+3YJEGlimbwU0M8uowjlbgQflJA85u1VqUEKyRYR7h4036/U3IgQQOZM1is1NIK62vfU7Vpw2sONAnhoXlUqioOhjquRnQ0fDn6NjCnoHbKVcMN7zEGob79emgFiLQQgmx0G/w0VFYP50cV+4WWK6k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1400.namprd12.prod.outlook.com (10.168.165.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 07:11:45 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2495.014; Wed, 4 Dec 2019
 07:11:44 +0000
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
Subject: [RFC PATCH v3 3/6] crypto: ccp - move SEV vdata to a dedicated data structure
Date:   Wed,  4 Dec 2019 11:49:00 +0530
Message-Id: <f1ce9dbeb28ba2adfe9ad205d59f0a91fefd5a33.1575438845.git.Rijo-john.Thomas@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3cae8dce-876b-4337-bfde-08d778893826
X-MS-TrafficTypeDiagnostic: CY4PR12MB1400:|CY4PR12MB1400:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB140032530E11196CABDCC9E0CF5D0@CY4PR12MB1400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 0241D5F98C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(2616005)(66556008)(2906002)(66476007)(50466002)(48376002)(478600001)(14454004)(50226002)(11346002)(36756003)(81156014)(26005)(54906003)(110136005)(81166006)(3846002)(66946007)(8936002)(446003)(8676002)(5660300002)(6486002)(6116002)(386003)(186003)(6436002)(4326008)(99286004)(25786009)(6506007)(14444005)(118296001)(76176011)(16586007)(316002)(86362001)(52116002)(7736002)(51416003)(6666004)(6512007)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1400;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KsSjM21K7HUyY1IaLq9dKxdTlz8T8HB8LVviMsgS9lCNOfypI2plut5sjOMt1c8/9vGLbQB0UjllRIQf5AiNiSt9cYhYxpVaFztTx3KKHG1vD9sB7mcefJa2m5A7c4iWeYOtO+A+5BPahGnQKTAhWBENps/fmpVjNfSjIH0j5wYKyATETLqLf6Rv3zWL0RjiaWW9H5LmB1Wcgd2Gy/MZxpDo+3oOI329JtIJ7v2fDvOPIHKUhB6wlebCUdJEt93Ld3j66bX7YweI080LBCB4TGsLPaVAXt5F09vslrOmmUXuY2JgPEfSXcX0OUCJ7g839L2aHRMI1F6m0SOmqlxr4xbFEdGEhAbIAEjja6hpUMljg3sa/ZI0lJRJxyghC3/krL4EKIdT88+VCDJ6MuLh/hK3TGzq6EmqPnJ7aHGvwpK8WpF5a6FfYKUWIo87Ly2V
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cae8dce-876b-4337-bfde-08d778893826
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2019 07:11:44.8079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bujRD0uqSn5D5fOm9wITW+sJBu71tphTXPl86TQTiMJqmk6HeUOsdH7M7OR97a6Fjh+2Gu4EWz1hE9xeCQcB4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1400
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
index a608b52..e68fa48 100644
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
@@ -949,6 +949,13 @@ int sev_dev_init(struct psp_device *psp)
 
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
index 3d84ac3..dd5c4fe 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -40,6 +40,8 @@ struct sev_device {
 
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

