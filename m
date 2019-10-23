Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274BFCA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA91121920
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="tunmKl/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404974AbfJWL1p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:27:45 -0400
Received: from mail-eopbgr790071.outbound.protection.outlook.com ([40.107.79.71]:61984
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404902AbfJWL1o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 07:27:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jefpKoFgrZu3zMBBuLFnPlrtvDuIRWMX2NvYKDccxe7Dj4BYmndaKEwAIAW7BDJRmAMOQ5ZdANq7hnohpxaXvBq8fj9rsNfvOzBD+z3X8T/L/xG1CQGvHe05mqloYF4KwfWd499NjhqLhjqiINJzwx1+GUAxwMwMt1SNbqLDuVndwThs1bAFiG/IWAyWHviVr2xk1rXD/nVfl+8E0V5pgZmaErTWIbXaCwjeaPjB7FcO+TzlHPCzGJtoggXj7LznDgm9owNVGsleUYqu6svgBOshBLjrmY1INO1GBCb/a39RKDsh1ZHqVEd3bQBW7icAD2/P4jnf2Kq1EJneHLGNIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TA0plC+6MtxCz31n6EiEJT15upn1HB1sVcUVi2u2+B8=;
 b=LZ047GSYw+sGH7m1wYBwXTP+0bb4QzkjcStZF8DEEji13uA5WqxEq0NoN/LeSbMtVxUSr3oQNMYWU0XRYmIeTliZApouQjVJFYzpYxPN+GridI+8Q5SEWQY4vIO8KNC32ihThcB6dF+HlwLcBjBndmvjiArUjzE2UfxLwmGXcYc5/4RWeIU/wAXedRV8jHbFMKOyF26R6GoUnOiFz8+0/qNG2PkyJCcHa1z/PzKK143sOioZrXMbXWnbqf6P07ZlJiV6kyXMuZgHDpq3f94GDGGB3PR2QfOMFzm1q9rPcy5SgY6geFLJ0jf/Hd4/qOniJ2BH1NddoRxAFcjyT4FNOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TA0plC+6MtxCz31n6EiEJT15upn1HB1sVcUVi2u2+B8=;
 b=tunmKl/gl9S2OOu72xSlMaojNBlC2UD7ovhY8OO7IXE2+vdqOjD1Gr7/z1wC+VUiKUhh34J1edvo/yqmfmE8CMS2OkAdtLmdNnHPdhrXF3Rz4Qj1NEFHhxy5r+Au7zrdPFZcZHXEsLwyWAVdnFmQKS90QowyDE8sV3P7j98451k=
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1527.namprd12.prod.outlook.com (10.172.66.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 11:27:38 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1%11]) with mapi id 15.20.2387.019; Wed, 23 Oct
 2019 11:27:38 +0000
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
Subject: [RFC PATCH 4/5] crypto: ccp - add TEE support for Raven Ridge
Thread-Topic: [RFC PATCH 4/5] crypto: ccp - add TEE support for Raven Ridge
Thread-Index: AQHViZTg9eqHn35qKESqitjerHscEA==
Date:   Wed, 23 Oct 2019 11:27:38 +0000
Message-ID: <fba6bc3fe8ec3d163f5e37e54046f412cd6435b5.1571817675.git.Rijo-john.Thomas@amd.com>
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
x-ms-office365-filtering-correlation-id: 7af98289-aa9a-4d22-bb57-08d757ac0280
x-ms-traffictypediagnostic: CY4PR12MB1527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR12MB1527E89EA3B63F06299FEC0ECF6B0@CY4PR12MB1527.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(476003)(81156014)(386003)(6486002)(6506007)(14454004)(446003)(11346002)(26005)(81166006)(305945005)(86362001)(5660300002)(186003)(102836004)(7736002)(50226002)(30864003)(66946007)(6436002)(478600001)(316002)(6116002)(3846002)(99286004)(6512007)(71190400001)(25786009)(118296001)(71200400001)(8676002)(110136005)(54906003)(2906002)(8936002)(486006)(256004)(14444005)(66476007)(66556008)(64756008)(66066001)(2201001)(52116002)(76176011)(66446008)(36756003)(2501003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1527;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tbOLcIEvmqaOt61gJNmqi5yXOphl/9odqmlVX/cgB/0Wa42DTYZTsR1ibSnmugLyiSVmO6t45clTN5S8LwoytSi1E8CO4hhKG/9Owu/GjjWFFGxm+hIq6lPDGQHzuFA0NxoF1qzBZjgTmomYoV5SmPqj5JujByZQeSW2FjZA03sitBPSVsgNOZSI0Kw8Xw2Oyn68HiF5J7qyFMJXFH62n3nZmDdMCZ8a+wQ3VNEhGc+gX5yNiJXwE9YPdRV98iIKBofnWwgccOpzQHwTsYGsf3GfAEe64/qlMAFasFaX8NTmbEolUOGDFSJtlgh4RVSf8oroVbbu2au1PM8KOmVTy8dxUMYo2mejU2Cv/hvF6T9sKBJ2hNWqU8u7/s313efyyhx9h2rBZPgLN8wipzMD6HbmuzuEg61ZmDYtK8tdoA0K/GB6GjkCYlNCHUFFDaRX
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af98289-aa9a-4d22-bb57-08d757ac0280
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 11:27:38.5866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lKtdWqgk8s9hCMOJtsmG3IVkNCm1cR0/vVuguIJL66Ha50U+8ItggZ8JJ/zLh9L2IKp4vUEkX6S/SO+/+oysRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1527
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adds a PCI device entry for Raven Ridge. Raven Ridge is an APU with a
dedicated AMD Secure Processor having Trusted Execution Environment (TEE)
support. The TEE provides a secure environment for running Trusted
Applications (TAs) which implement security-sensitive parts of a feature.

This patch configures AMD Secure Processor's TEE interface by initializing
a ring buffer (shared memory between Rich OS and Trusted OS) which can hold
multiple command buffer entries. The TEE interface is facilitated by a set
of CPU to PSP mailbox registers.

The next patch will address how commands are submitted to the ring buffer.

Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
---
 drivers/crypto/ccp/Makefile  |   3 +-
 drivers/crypto/ccp/psp-dev.c |  74 +++++++++++++-
 drivers/crypto/ccp/psp-dev.h |   8 ++
 drivers/crypto/ccp/sp-dev.h  |  11 +-
 drivers/crypto/ccp/sp-pci.c  |  27 ++++-
 drivers/crypto/ccp/tee-dev.c | 237 +++++++++++++++++++++++++++++++++++++++=
++++
 drivers/crypto/ccp/tee-dev.h | 108 ++++++++++++++++++++
 7 files changed, 461 insertions(+), 7 deletions(-)
 create mode 100644 drivers/crypto/ccp/tee-dev.c
 create mode 100644 drivers/crypto/ccp/tee-dev.h

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 3b29ea4..db362fe 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -9,7 +9,8 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) +=3D ccp-dev.o \
 ccp-$(CONFIG_CRYPTO_DEV_CCP_DEBUGFS) +=3D ccp-debugfs.o
 ccp-$(CONFIG_PCI) +=3D sp-pci.o
 ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) +=3D psp-dev.o \
-                                   sev-dev.o
+                                   sev-dev.o \
+                                   tee-dev.o

 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) +=3D ccp-crypto.o
 ccp-crypto-objs :=3D ccp-crypto-main.o \
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index ef8affa..90bcd5f 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -13,6 +13,7 @@
 #include "sp-dev.h"
 #include "psp-dev.h"
 #include "sev-dev.h"
+#include "tee-dev.h"

 struct psp_device *psp_master;

@@ -45,6 +46,9 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
 	if (status) {
 		if (psp->sev_irq_handler)
 			psp->sev_irq_handler(irq, psp->sev_irq_data, status);
+
+		if (psp->tee_irq_handler)
+			psp->tee_irq_handler(irq, psp->tee_irq_data, status);
 	}

 	/* Clear the interrupt status by writing the same value we read. */
@@ -53,10 +57,11 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }

-static int psp_check_sev_support(struct psp_device *psp)
+static int psp_check_sev_support(struct psp_device *psp,
+				 unsigned int capability)
 {
 	/* Check if device supports SEV feature */
-	if (!(ioread32(psp->io_regs + psp->vdata->feature_reg) & 1)) {
+	if (!(capability & 1)) {
 		dev_dbg(psp->dev, "psp does not support SEV\n");
 		return -ENODEV;
 	}
@@ -64,10 +69,54 @@ static int psp_check_sev_support(struct psp_device *psp=
)
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
+static int psp_check_support(struct psp_device *psp, unsigned int capabili=
ty)
+{
+	int sev_support =3D psp_check_sev_support(psp, capability);
+	int tee_support =3D psp_check_tee_support(psp, capability);
+
+	/* Check if device supprts SEV and TEE feature */
+	if (sev_support && tee_support)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int psp_init(struct psp_device *psp, unsigned int capability)
+{
+	int ret;
+
+	if (!psp_check_sev_support(psp, capability)) {
+		ret =3D sev_dev_init(psp);
+		if (ret)
+			return ret;
+	}
+
+	if (!psp_check_tee_support(psp, capability)) {
+		ret =3D tee_dev_init(psp);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 int psp_dev_init(struct sp_device *sp)
 {
 	struct device *dev =3D sp->dev;
 	struct psp_device *psp;
+	unsigned int capability;
 	int ret;

 	ret =3D -ENOMEM;
@@ -86,7 +135,10 @@ int psp_dev_init(struct sp_device *sp)

 	psp->io_regs =3D sp->io_map;

-	ret =3D psp_check_sev_support(psp);
+	/* Read the feature register to get the PSP capability */
+	capability =3D ioread32(psp->io_regs + psp->vdata->feature_reg);
+
+	ret =3D psp_check_support(psp, capability);
 	if (ret)
 		goto e_disable;

@@ -101,7 +153,7 @@ int psp_dev_init(struct sp_device *sp)
 		goto e_err;
 	}

-	ret =3D sev_dev_init(psp);
+	ret =3D psp_init(psp, capability);
 	if (ret)
 		goto e_irq;

@@ -139,6 +191,8 @@ void psp_dev_destroy(struct sp_device *sp)

 	sev_dev_destroy(psp);

+	tee_dev_destroy(psp);
+
 	sp_free_psp_irq(sp, psp);
 }

@@ -154,6 +208,18 @@ void psp_clear_sev_irq_handler(struct psp_device *psp)
 	psp_set_sev_irq_handler(psp, NULL, NULL);
 }

+void psp_set_tee_irq_handler(struct psp_device *psp, psp_irq_handler_t han=
dler,
+			     void *data)
+{
+	psp->tee_irq_data =3D data;
+	psp->tee_irq_handler =3D handler;
+}
+
+void psp_clear_tee_irq_handler(struct psp_device *psp)
+{
+	psp_set_tee_irq_handler(psp, NULL, NULL);
+}
+
 struct psp_device *psp_get_master_device(void)
 {
 	struct sp_device *sp =3D sp_get_psp_master_device();
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index 7c014ac..ef38e41 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -40,13 +40,21 @@ struct psp_device {
 	psp_irq_handler_t sev_irq_handler;
 	void *sev_irq_data;

+	psp_irq_handler_t tee_irq_handler;
+	void *tee_irq_data;
+
 	void *sev_data;
+	void *tee_data;
 };

 void psp_set_sev_irq_handler(struct psp_device *psp, psp_irq_handler_t han=
dler,
 			     void *data);
 void psp_clear_sev_irq_handler(struct psp_device *psp);

+void psp_set_tee_irq_handler(struct psp_device *psp, psp_irq_handler_t han=
dler,
+			     void *data);
+void psp_clear_tee_irq_handler(struct psp_device *psp);
+
 struct psp_device *psp_get_master_device(void);

 #endif /* __PSP_DEV_H */
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 0394c75..4235946 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -2,7 +2,7 @@
 /*
  * AMD Secure Processor driver
  *
- * Copyright (C) 2017-2018 Advanced Micro Devices, Inc.
+ * Copyright (C) 2017-2019 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  * Author: Gary R Hook <gary.hook@amd.com>
@@ -45,8 +45,17 @@ struct sev_vdata {
 	const unsigned int cmdbuff_addr_hi_reg;
 };

+struct tee_vdata {
+	const unsigned int cmdresp_reg;
+	const unsigned int cmdbuff_addr_lo_reg;
+	const unsigned int cmdbuff_addr_hi_reg;
+	const unsigned int ring_wptr_reg;
+	const unsigned int ring_rptr_reg;
+};
+
 struct psp_vdata {
 	const struct sev_vdata *sev;
+	const struct tee_vdata *tee;
 	const unsigned int feature_reg;
 	const unsigned int inten_reg;
 	const unsigned int intsts_reg;
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 733693d..56c1f61 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -2,7 +2,7 @@
 /*
  * AMD Secure Processor device driver
  *
- * Copyright (C) 2013,2018 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2019 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  * Author: Gary R Hook <gary.hook@amd.com>
@@ -274,6 +274,14 @@ static int sp_pci_resume(struct pci_dev *pdev)
 	.cmdbuff_addr_hi_reg	=3D 0x109e4,
 };

+static const struct tee_vdata teev1 =3D {
+	.cmdresp_reg		=3D 0x10544,
+	.cmdbuff_addr_lo_reg	=3D 0x10548,
+	.cmdbuff_addr_hi_reg	=3D 0x1054c,
+	.ring_wptr_reg          =3D 0x10550,
+	.ring_rptr_reg          =3D 0x10554,
+};
+
 static const struct psp_vdata pspv1 =3D {
 	.sev			=3D &sevv1,
 	.feature_reg		=3D 0x105fc,
@@ -287,6 +295,13 @@ static int sp_pci_resume(struct pci_dev *pdev)
 	.inten_reg		=3D 0x10690,
 	.intsts_reg		=3D 0x10694,
 };
+
+static const struct psp_vdata pspv3 =3D {
+	.tee			=3D &teev1,
+	.feature_reg		=3D 0x109fc,
+	.inten_reg		=3D 0x10690,
+	.intsts_reg		=3D 0x10694,
+};
 #endif

 static const struct sp_dev_vdata dev_vdata[] =3D {
@@ -320,12 +335,22 @@ static int sp_pci_resume(struct pci_dev *pdev)
 		.psp_vdata =3D &pspv2,
 #endif
 	},
+	{	/* 4 */
+		.bar =3D 2,
+#ifdef CONFIG_CRYPTO_DEV_SP_CCP
+		.ccp_vdata =3D &ccpv5a,
+#endif
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+		.psp_vdata =3D &pspv3,
+#endif
+	},
 };
 static const struct pci_device_id sp_pci_table[] =3D {
 	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&dev_vdata[0] },
 	{ PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&dev_vdata[1] },
 	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
 	{ PCI_VDEVICE(AMD, 0x1486), (kernel_ulong_t)&dev_vdata[3] },
+	{ PCI_VDEVICE(AMD, 0x15DF), (kernel_ulong_t)&dev_vdata[4] },
 	/* Last entry must be zero */
 	{ 0, }
 };
diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
new file mode 100644
index 0000000..b2b0215
--- /dev/null
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: MIT
+/*
+ * AMD Trusted Execution Environment (TEE) interface
+ *
+ * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
+ *
+ * Copyright 2019 Advanced Micro Devices, Inc.
+ */
+
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/gfp.h>
+#include <linux/psp-sev.h>
+
+#include "psp-dev.h"
+#include "tee-dev.h"
+
+static bool psp_dead;
+
+static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
+{
+	struct ring_buf_manager *rb_mgr =3D &tee->rb_mgr;
+	void *start_addr;
+
+	if (!ring_size)
+		return -EINVAL;
+
+	/* We need actual physical address instead of DMA address, since
+	 * Trusted OS running on AMD Secure Processor will map this region
+	 */
+	start_addr =3D (void *)__get_free_pages(GFP_KERNEL, get_order(ring_size))=
;
+	if (!start_addr)
+		return -ENOMEM;
+
+	rb_mgr->ring_start =3D start_addr;
+	rb_mgr->ring_size =3D ring_size;
+	rb_mgr->ring_pa =3D __psp_pa(start_addr);
+
+	return 0;
+}
+
+static void tee_free_ring(struct psp_tee_device *tee)
+{
+	struct ring_buf_manager *rb_mgr =3D &tee->rb_mgr;
+
+	if (!rb_mgr->ring_start)
+		return;
+
+	free_pages((unsigned long)rb_mgr->ring_start,
+		   get_order(rb_mgr->ring_size));
+
+	rb_mgr->ring_start =3D NULL;
+	rb_mgr->ring_size =3D 0;
+	rb_mgr->ring_pa =3D 0;
+}
+
+static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int time=
out,
+			     unsigned int *reg)
+{
+	/* ~10ms sleep per loop =3D> nloop =3D timeout * 100 */
+	int nloop =3D timeout * 100;
+
+	while (--nloop) {
+		*reg =3D ioread32(tee->io_regs + tee->vdata->cmdresp_reg);
+		if (*reg & PSP_CMDRESP_RESP)
+			return 0;
+
+		usleep_range(10000, 10100);
+	}
+
+	dev_err(tee->dev, "tee: command timed out, disabling PSP\n");
+	psp_dead =3D true;
+
+	return -ETIMEDOUT;
+}
+
+static
+struct tee_init_ring_cmd *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
+{
+	struct tee_init_ring_cmd *cmd;
+
+	cmd =3D kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return NULL;
+
+	cmd->hi_addr =3D upper_32_bits(tee->rb_mgr.ring_pa);
+	cmd->low_addr =3D lower_32_bits(tee->rb_mgr.ring_pa);
+	cmd->size =3D tee->rb_mgr.ring_size;
+
+	dev_dbg(tee->dev, "tee: ring address: high =3D 0x%x low =3D 0x%x size =3D=
 %u\n",
+		cmd->hi_addr, cmd->low_addr, cmd->size);
+
+	return cmd;
+}
+
+static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
+{
+	kfree(cmd);
+}
+
+static int tee_init_ring(struct psp_tee_device *tee)
+{
+	int ring_size =3D MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
+	struct tee_init_ring_cmd *cmd;
+	phys_addr_t cmd_buffer;
+	unsigned int reg;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct tee_ring_cmd) !=3D 1024);
+
+	ret =3D tee_alloc_ring(tee, ring_size);
+	if (ret) {
+		dev_err(tee->dev, "tee: ring allocation failed %d\n", ret);
+		return ret;
+	}
+
+	tee->rb_mgr.wptr =3D 0;
+
+	cmd =3D tee_alloc_cmd_buffer(tee);
+	if (!cmd) {
+		tee_free_ring(tee);
+		return -ENOMEM;
+	}
+
+	cmd_buffer =3D __psp_pa((void *)cmd);
+
+	/* Send command buffer details to Trusted OS by writing to
+	 * CPU-PSP message registers
+	 */
+
+	iowrite32(lower_32_bits(cmd_buffer),
+		  tee->io_regs + tee->vdata->cmdbuff_addr_lo_reg);
+	iowrite32(upper_32_bits(cmd_buffer),
+		  tee->io_regs + tee->vdata->cmdbuff_addr_hi_reg);
+	iowrite32(TEE_RING_INIT_CMD,
+		  tee->io_regs + tee->vdata->cmdresp_reg);
+
+	ret =3D tee_wait_cmd_poll(tee, TEE_DEFAULT_TIMEOUT, &reg);
+	if (ret) {
+		dev_err(tee->dev, "tee: ring init command timed out\n");
+		tee_free_ring(tee);
+		goto free_buf;
+	}
+
+	if (reg & PSP_CMDRESP_ERR_MASK) {
+		dev_err(tee->dev, "tee: ring init command failed (%#010x)\n",
+			reg & PSP_CMDRESP_ERR_MASK);
+		tee_free_ring(tee);
+		ret =3D -EIO;
+	}
+
+free_buf:
+	tee_free_cmd_buffer(cmd);
+
+	return ret;
+}
+
+static void tee_destroy_ring(struct psp_tee_device *tee)
+{
+	unsigned int reg;
+	int ret;
+
+	if (!tee->rb_mgr.ring_start)
+		return;
+
+	if (psp_dead)
+		goto free_ring;
+
+	iowrite32(TEE_RING_DESTROY_CMD,
+		  tee->io_regs + tee->vdata->cmdresp_reg);
+
+	ret =3D tee_wait_cmd_poll(tee, TEE_DEFAULT_TIMEOUT, &reg);
+	if (ret) {
+		dev_err(tee->dev, "tee: ring destroy command timed out\n");
+	} else if (reg & PSP_CMDRESP_ERR_MASK) {
+		dev_err(tee->dev, "tee: ring destroy command failed (%#010x)\n",
+			reg & PSP_CMDRESP_ERR_MASK);
+	}
+
+free_ring:
+	tee_free_ring(tee);
+}
+
+int tee_dev_init(struct psp_device *psp)
+{
+	struct device *dev =3D psp->dev;
+	struct psp_tee_device *tee;
+	int ret;
+
+	ret =3D -ENOMEM;
+	tee =3D devm_kzalloc(dev, sizeof(*tee), GFP_KERNEL);
+	if (!tee)
+		goto e_err;
+
+	psp->tee_data =3D tee;
+
+	tee->dev =3D dev;
+	tee->psp =3D psp;
+
+	tee->io_regs =3D psp->io_regs;
+
+	tee->vdata =3D (struct tee_vdata *)psp->vdata->tee;
+	if (!tee->vdata) {
+		ret =3D -ENODEV;
+		dev_err(dev, "tee: missing driver data\n");
+		goto e_err;
+	}
+
+	ret =3D tee_init_ring(tee);
+	if (ret) {
+		dev_err(dev, "tee: failed to init ring buffer\n");
+		goto e_err;
+	}
+
+	dev_notice(dev, "tee enabled\n");
+
+	return 0;
+
+e_err:
+	psp->tee_data =3D NULL;
+
+	dev_notice(dev, "tee initialization failed\n");
+
+	return ret;
+}
+
+void tee_dev_destroy(struct psp_device *psp)
+{
+	struct psp_tee_device *tee =3D psp->tee_data;
+
+	if (!tee)
+		return;
+
+	tee_destroy_ring(tee);
+}
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
new file mode 100644
index 0000000..0d51a0a7
--- /dev/null
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -0,0 +1,108 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright 2019 Advanced Micro Devices, Inc.
+ *
+ * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
+ *
+ */
+
+/* This file describes the TEE communication interface between host and AM=
D
+ * Secure Processor
+ */
+
+#ifndef __TEE_DEV_H__
+#define __TEE_DEV_H__
+
+#include <linux/device.h>
+#include <linux/mutex.h>
+
+#define TEE_DEFAULT_TIMEOUT		10
+#define MAX_BUFFER_SIZE			992
+
+/**
+ * enum tee_ring_cmd_id - TEE interface commands for ring buffer configura=
tion
+ * @TEE_RING_INIT_CMD:		Initialize ring buffer
+ * @TEE_RING_DESTROY_CMD:	Destroy ring buffer
+ * @TEE_RING_MAX_CMD:		Maximum command id
+ */
+enum tee_ring_cmd_id {
+	TEE_RING_INIT_CMD		=3D 0x00010000,
+	TEE_RING_DESTROY_CMD		=3D 0x00020000,
+	TEE_RING_MAX_CMD		=3D 0x000F0000,
+};
+
+/**
+ * struct tee_init_ring_cmd - Command to init TEE ring buffer
+ * @low_addr:  bits [31:0] of the physical address of ring buffer
+ * @hi_addr:   bits [63:32] of the physical address of ring buffer
+ * @size:      size of ring buffer in bytes
+ */
+struct tee_init_ring_cmd {
+	u32 low_addr;
+	u32 hi_addr;
+	u32 size;
+};
+
+#define MAX_RING_BUFFER_ENTRIES		32
+
+/**
+ * struct ring_buf_manager - Helper structure to manage ring buffer.
+ * @ring_start:  starting address of ring buffer
+ * @ring_size:   size of ring buffer in bytes
+ * @ring_pa:     physical address of ring buffer
+ * @wptr:        index to the last written entry in ring buffer
+ */
+struct ring_buf_manager {
+	void *ring_start;
+	u32 ring_size;
+	phys_addr_t ring_pa;
+	u32 wptr;
+};
+
+struct psp_tee_device {
+	struct device *dev;
+	struct psp_device *psp;
+	void __iomem *io_regs;
+	struct tee_vdata *vdata;
+	struct ring_buf_manager rb_mgr;
+};
+
+/**
+ * enum tee_cmd_state - TEE command states for the ring buffer interface
+ * @TEE_CMD_STATE_INIT:      initial state of command when sent from host
+ * @TEE_CMD_STATE_PROCESS:   command being processed by TEE environment
+ * @TEE_CMD_STATE_COMPLETED: command processing completed
+ */
+enum tee_cmd_state {
+	TEE_CMD_STATE_INIT,
+	TEE_CMD_STATE_PROCESS,
+	TEE_CMD_STATE_COMPLETED,
+};
+
+/**
+ * struct tee_ring_cmd - Structure of the command buffer in TEE ring
+ * @cmd_id:      refers to &enum tee_cmd_id. Command id for the ring buffe=
r
+ *               interface
+ * @cmd_state:   refers to &enum tee_cmd_state
+ * @status:      status of TEE command execution
+ * @res0:        reserved region
+ * @pdata:       private data (currently unused)
+ * @res1:        reserved region
+ * @buf:         TEE command specific buffer
+ */
+struct tee_ring_cmd {
+	u32 cmd_id;
+	u32 cmd_state;
+	u32 status;
+	u32 res0[1];
+	u64 pdata;
+	u32 res1[2];
+	u8 buf[MAX_BUFFER_SIZE];
+
+	/* Total size: 1024 bytes */
+} __packed;
+
+int tee_dev_init(struct psp_device *psp);
+void tee_dev_destroy(struct psp_device *psp);
+
+#endif /* __TEE_DEV_H__ */
--
1.9.1

