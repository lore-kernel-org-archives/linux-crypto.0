Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FF6CA9EB9
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34EE921920
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="MnwVmv/c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404929AbfJWL1i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:27:38 -0400
Received: from mail-eopbgr790055.outbound.protection.outlook.com ([40.107.79.55]:22704
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404902AbfJWL1h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 07:27:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVag9j9vguD3bkdCnPRhNodx/dt4WQHFGenfcvqgt0frudJ7YrVVRATrOAn/5fkQ2ClLik9WCpwlsJNCCm6dKeioF3+K7DNkyYNHs1GUK8FWw/o3+6/szxo+gJQMRAOJeMUgDg0RrVT+h5o8Hl8HP2C80pvxV864CJ/yLWCwAa0bsh/TXI5FPGRWxFsJmM95Pu0jUFDH7uXyYo+QD/Xjeh8Ic50viVJtRSJTxbGtY6PwAkh/jiniUhtlT+XQ3+nNyRZlnhWaCSqXL31MQJqKJXXnrYgFqmNiSBe1MHR+vUVeZAFuzkffGssadevgrYarjgmLNjOUA2s7nFgmM1VRjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2h/yUTgNBqgXKhdse25tfjZq+0Tjdw5Vc9qkz5+aArs=;
 b=KvSAzM6oAwJLoDrryoSd6wBm2IOIMJVIU2i1zd/JEmVUzL3B51i693iFW7x86ht+Gm5AXqQiHa5vQh0zRj1MFjQr18I3QacbJcE7rqBInqhGuaviQNc3Cw3E03Ts7MITCVQvrR695gs40ZmvK3HMj/qYO8McooqWhnAIF/JxDbLLsgxoBCYVvcBuqzqEzJ+42ubOFENqpRDVoJ8KpGau4yLz/CCHRd/VNe6paZRzLrBk+A/Yo6Lgshks+RLon0lqF3IjgfIYMcpK3mZp45zD/G/wHO8x37hsBkAoy4nfyCh0o4wCbwKox85Vn1FOqK4D/+cW8R0+OeaFdGWFHEHvVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2h/yUTgNBqgXKhdse25tfjZq+0Tjdw5Vc9qkz5+aArs=;
 b=MnwVmv/cwqsDtWNwFSSbROxmqK/KgnDBjR/ubxCgJwayLwO2vDec/zRt05qc+4N97xK5f30Kf9YyNzmJfTS/N1lqfZXBNmSuhqF34yievYeGv8m56ytxaWaEpGW8GuPEMYR+9fP6SYWJzH+wXi16iJzv6bdAI/5C3VGnAamye6Q=
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1527.namprd12.prod.outlook.com (10.172.66.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 11:27:35 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1%11]) with mapi id 15.20.2387.019; Wed, 23 Oct
 2019 11:27:35 +0000
From:   "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Easow, Nimesh" <Nimesh.Easow@amd.com>,
        "Rangasamy, Devaraj" <Devaraj.Rangasamy@amd.com>
Subject: [RFC PATCH 3/5] crypto: ccp - move SEV vdata to a dedicated data
 structure
Thread-Topic: [RFC PATCH 3/5] crypto: ccp - move SEV vdata to a dedicated data
 structure
Thread-Index: AQHViZTe9o0ygMrtCUGzxWo3PjBc2A==
Date:   Wed, 23 Oct 2019 11:27:35 +0000
Message-ID: <66263a80e37bb54804208864fdce9187e8b6dcdf.1571817675.git.Rijo-john.Thomas@amd.com>
References: <cover.1571817675.git.Rijo-john.Thomas@amd.com>
In-Reply-To: <cover.1571817675.git.Rijo-john.Thomas@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::23) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.9.1
x-originating-ip: [165.204.156.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0316e6e3-a209-4121-c0a6-08d757ac006a
x-ms-traffictypediagnostic: CY4PR12MB1527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR12MB15270937BEA43137F520DFD3CF6B0@CY4PR12MB1527.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(476003)(81156014)(386003)(6486002)(6506007)(14454004)(446003)(11346002)(26005)(81166006)(305945005)(86362001)(5660300002)(186003)(102836004)(7736002)(50226002)(66946007)(6436002)(478600001)(316002)(6116002)(3846002)(99286004)(6512007)(71190400001)(25786009)(118296001)(71200400001)(8676002)(110136005)(54906003)(2906002)(8936002)(486006)(256004)(14444005)(66476007)(66556008)(64756008)(66066001)(2201001)(52116002)(76176011)(66446008)(36756003)(2501003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1527;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iXRzw2qnz1XAzHwUqE5FKNKt+meUoJt0U2xmtk208shntjTumA5t7B2x8lGtM6B/Gjo2UEuItofdUgcHuKgFFFR248y0HG+JjMpigRd26SsrJt0QOZtwyVB6s1Hqj/Isiyh2UR7UKqpQstQofgOnxD8mMnfxI4sMQoiloKB6PAboLXMlZZ9np5LCPMPL08yr7NXyfXErpY+vK31f2nZcZwLHamP8EEvZbXzOKSxACzYSyIpSztdZWxkFmCH/M9l8jG1tal5MrJMy06aYoOVMGBqEo80ER7NuUEJYSp5bXN42d5d9isvypo4Z9l31jVID/4KLehZVfM4t79ILNZRu/EQqyVybRsbCVbu7AlwXrZs400x0u8A5aK+t6HjVyfP1ed5sLjLo+ps1Y5gBErw2b/BGtQNLSU08ft7EULRs1MWVKC7CVSPROrVT92usfs/b
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0316e6e3-a209-4121-c0a6-08d757ac006a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 11:27:35.2860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TzMORZfIJo6OknO1tNoFZ/FFDGiRGgkXO216OCXeZw7BxxEoyLNuXx5wKq2FxGUkwBZMI373xtkfVk8Ld2SmZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1527
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PSP can support both SEV and TEE interface. Therefore, move
SEV specific registers to a dedicated data structure.
TEE interface specific registers will be added in a later
patch.

Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 17 ++++++++++++-----
 drivers/crypto/ccp/sev-dev.h |  2 ++
 drivers/crypto/ccp/sp-dev.h  |  6 +++++-
 drivers/crypto/ccp/sp-pci.c  | 16 ++++++++++++----
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 7e5e7b2..f546f8d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -65,7 +65,7 @@ static void sev_irq_handler(int irq, void *data, unsigned=
 int status)
 		return;

 	/* Check if it is SEV command completion: */
-	reg =3D ioread32(sev->io_regs + sev->psp->vdata->cmdresp_reg);
+	reg =3D ioread32(sev->io_regs + sev->vdata->cmdresp_reg);
 	if (reg & PSP_CMDRESP_RESP) {
 		sev->int_rcvd =3D 1;
 		wake_up(&sev->int_queue);
@@ -82,7 +82,7 @@ static int sev_wait_cmd_ioc(struct sev_device *sev,
 	if (!ret)
 		return -ETIMEDOUT;

-	*reg =3D ioread32(sev->io_regs + sev->psp->vdata->cmdresp_reg);
+	*reg =3D ioread32(sev->io_regs + sev->vdata->cmdresp_reg);

 	return 0;
 }
@@ -148,15 +148,15 @@ static int __sev_do_cmd_locked(int cmd, void *data, i=
nt *psp_ret)
 	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
 			     sev_cmd_buffer_len(cmd), false);

-	iowrite32(phys_lsb, sev->io_regs + psp->vdata->cmdbuff_addr_lo_reg);
-	iowrite32(phys_msb, sev->io_regs + psp->vdata->cmdbuff_addr_hi_reg);
+	iowrite32(phys_lsb, sev->io_regs + sev->vdata->cmdbuff_addr_lo_reg);
+	iowrite32(phys_msb, sev->io_regs + sev->vdata->cmdbuff_addr_hi_reg);

 	sev->int_rcvd =3D 0;

 	reg =3D cmd;
 	reg <<=3D SEV_CMDRESP_CMD_SHIFT;
 	reg |=3D SEV_CMDRESP_IOC;
-	iowrite32(reg, sev->io_regs + psp->vdata->cmdresp_reg);
+	iowrite32(reg, sev->io_regs + sev->vdata->cmdresp_reg);

 	/* wait for command completion */
 	ret =3D sev_wait_cmd_ioc(sev, &reg, psp_timeout);
@@ -934,6 +934,13 @@ int sev_dev_init(struct psp_device *psp)

 	sev->io_regs =3D psp->io_regs;

+	sev->vdata =3D (struct sev_vdata *)psp->vdata->sev;
+	if (!sev->vdata) {
+		ret =3D -ENODEV;
+		dev_err(dev, "sev: missing driver data\n");
+		goto e_err;
+	}
+
 	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);

 	ret =3D sev_misc_init(sev);
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 20d51c9..55cae86 100644
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
-static const struct psp_vdata pspv1 =3D {
+static const struct sev_vdata sevv1 =3D {
 	.cmdresp_reg		=3D 0x10580,
 	.cmdbuff_addr_lo_reg	=3D 0x105e0,
 	.cmdbuff_addr_hi_reg	=3D 0x105e4,
+};
+
+static const struct sev_vdata sevv2 =3D {
+	.cmdresp_reg		=3D 0x10980,
+	.cmdbuff_addr_lo_reg	=3D 0x109e0,
+	.cmdbuff_addr_hi_reg	=3D 0x109e4,
+};
+
+static const struct psp_vdata pspv1 =3D {
+	.sev			=3D &sevv1,
 	.feature_reg		=3D 0x105fc,
 	.inten_reg		=3D 0x10610,
 	.intsts_reg		=3D 0x10614,
 };

 static const struct psp_vdata pspv2 =3D {
-	.cmdresp_reg		=3D 0x10980,
-	.cmdbuff_addr_lo_reg	=3D 0x109e0,
-	.cmdbuff_addr_hi_reg	=3D 0x109e4,
+	.sev			=3D &sevv2,
 	.feature_reg		=3D 0x109fc,
 	.inten_reg		=3D 0x10690,
 	.intsts_reg		=3D 0x10694,
--
1.9.1

