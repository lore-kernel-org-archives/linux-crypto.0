Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AFDCA9EBB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF4A621920
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="RyadOLvD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404901AbfJWL1g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:27:36 -0400
Received: from mail-eopbgr790072.outbound.protection.outlook.com ([40.107.79.72]:4704
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404774AbfJWL1e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 07:27:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoLdbaJrhGp/KYImiQFR/y94L79XDwTQbMqeuDT7934z4khqOKmcFBrVE6dBg6ZHb83fmrhmxFOnuVPeFEcLf7GTU5mLpgefBqjbM4P7plkuYn6QAQDS1H4urAd58ouHNtUOyZt3xdcrJaNSsylcHioeIcN1c08ZpYblgWTIwjuYJGWgTRmPW16rnPPDL9op5u0SCM6ufJEP4OW5dYyeEtti0eU4Bmt/MnS6HJrgUqpa2KTxHwtLwuN9km/RuHAa7LbqA2zFKOBLxs2hLNpnHr6iR3mKLJHEUO4TDkGrYB4/Oq19fvhxOGR8Qjs9szch700Bi0gfO22+Ilj150eY9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12ngRSlw7+Q9WSL8aSsHROQl50zTNSW0iDqNlYuPExE=;
 b=BBK/9+9uf6lnm5nYJ/mY8eVIYIc/n5TWWBvceTUgbikXWM3cqRoWB6pAP9g3va6rP9sxC+Qk1qQqjF5MoewdKOQC3mdpjCkaZ/4mk0XIqaeFf9L6Y5GhR9js7JX0jbMlQmzBekwAU4K3WchxRnGtJ05eiL3XpLvtP69aPmu6ZE+guH9NL7rk6MK5aKOX3sBOGW51XBIPZuhYlMJzsVohl+PJDIywFbAHdnPPJoZkcwXSrDdS5hnJc8jzSiYCKCqh2Bxo93OLhH/Ppqw9O842FD8emj0VddkR7keBBOM9l8KfiGAz3SOcclqZxgOxfxRIsY+2yCY1RXJbjEydYUwjww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12ngRSlw7+Q9WSL8aSsHROQl50zTNSW0iDqNlYuPExE=;
 b=RyadOLvDRheDvcsS00w06P6P+LNic6XIxqpKmgv0ao9Mp+yTd7VbhW/Q06Yh8h3/RFVnD9MuLh44kTGhh2nPCNw1Gyfg/8RxDg865KLi4Qm0a/MyETgNIsSxLMe4Z1bXtUSp5Xwi74hpARIUf1R2NHoy8KrONljRo1fgd+iRW+g=
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1527.namprd12.prod.outlook.com (10.172.66.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 11:27:32 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1%11]) with mapi id 15.20.2387.019; Wed, 23 Oct
 2019 11:27:32 +0000
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
Subject: [RFC PATCH 2/5] crypto: ccp - create a generic psp-dev file
Thread-Topic: [RFC PATCH 2/5] crypto: ccp - create a generic psp-dev file
Thread-Index: AQHViZTc6fWaOGTVW02vnPq8c4Bwyw==
Date:   Wed, 23 Oct 2019 11:27:31 +0000
Message-ID: <5a8f90f4c6c0e941a37e7abdb935da6205c6b3b0.1571817675.git.Rijo-john.Thomas@amd.com>
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
x-ms-office365-filtering-correlation-id: 520331c7-e206-4914-6ebe-08d757abfe61
x-ms-traffictypediagnostic: CY4PR12MB1527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR12MB15272466C7336A7F9615BF42CF6B0@CY4PR12MB1527.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:378;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(476003)(81156014)(386003)(6486002)(6506007)(14454004)(446003)(11346002)(26005)(81166006)(305945005)(86362001)(5660300002)(186003)(102836004)(7736002)(50226002)(30864003)(66946007)(6436002)(478600001)(316002)(6116002)(3846002)(99286004)(6512007)(71190400001)(25786009)(118296001)(71200400001)(8676002)(110136005)(54906003)(2906002)(8936002)(486006)(256004)(14444005)(66476007)(66556008)(64756008)(66066001)(2201001)(52116002)(76176011)(66446008)(36756003)(2501003)(4326008)(41533002)(579004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1527;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fSgceTKIHH3Rt18f24pzF/zYfIo4l2H97zMWGL5bdFhgsK1VY3zah+WFprO28UR6SgRTP5cYaQ6RXI856aPd+i8OUf7jK6IKvytkGq9cMaX0p3UKhhzn7+PKCwVVd8MwZRJ3oLbtHmddP2/yGAjvDimXmkwDWag5ZfHhChrkIra3J5Ota7oSbjL6ZQM5JkVJwkPeT4V3y17YMLkgALXrxTWCdONp/kCSfxbgfCZPUN7pSvQiqR9RNHVqYbBKBTrDrTkXEq6vLAq0cGjAEiHlxla30Pyh753q5yRBfKYgMfFberkp6P8AuAhZzH5SV52I2c6EKzrHaVz6VnizqkVp2vfcfguDnnTMMgievW3U1aj8Sm22ag0dHVJ1gd5op7+xE8okRnbKtub7bgW8CVq2NvoVFv/ESBHPNrmfNbPL0N6t8hx6ajVgHp9d2ws9nuZq
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 520331c7-e206-4914-6ebe-08d757abfe61
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 11:27:31.7895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mGaHPQytS1ylj5d7hIQthgRAHxeMgLaT/QUx/TqAmt48rcA4spG/SDTFNPVPrddYvncNZZJwHewwVG3srBHTEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1527
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The PSP (Platform Security Processor) provides support for key management
commands in Secure Encrypted Virtualization (SEV) mode, along with
software-based Trusted Execution Environment (TEE) to enable third-party
Trusted Applications.

Therefore, introduce psp-dev.c and psp-dev.h files, which can invoke
SEV (or TEE) initialization based on platform feature support.

TEE interface support will be introduced in a later patch.

Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
---
 drivers/crypto/ccp/Makefile  |   3 +-
 drivers/crypto/ccp/psp-dev.c | 180 ++++++++++++++++++++++++++++++
 drivers/crypto/ccp/psp-dev.h |  52 +++++++++
 drivers/crypto/ccp/sev-dev.c | 257 +++++++++++++++++----------------------=
----
 drivers/crypto/ccp/sev-dev.h |  36 +++---
 drivers/crypto/ccp/sp-pci.c  |   2 +-
 6 files changed, 352 insertions(+), 178 deletions(-)
 create mode 100644 drivers/crypto/ccp/psp-dev.c
 create mode 100644 drivers/crypto/ccp/psp-dev.h

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 9dafcf2..3b29ea4 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -8,7 +8,8 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) +=3D ccp-dev.o \
 	    ccp-dmaengine.o
 ccp-$(CONFIG_CRYPTO_DEV_CCP_DEBUGFS) +=3D ccp-debugfs.o
 ccp-$(CONFIG_PCI) +=3D sp-pci.o
-ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) +=3D sev-dev.o
+ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) +=3D psp-dev.o \
+                                   sev-dev.o

 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) +=3D ccp-crypto.o
 ccp-crypto-objs :=3D ccp-crypto-main.o \
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
new file mode 100644
index 0000000..ef8affa
--- /dev/null
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Platform Security Processor (PSP) interface
+ *
+ * Copyright (C) 2016,2019 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/irqreturn.h>
+
+#include "sp-dev.h"
+#include "psp-dev.h"
+#include "sev-dev.h"
+
+struct psp_device *psp_master;
+
+static struct psp_device *psp_alloc_struct(struct sp_device *sp)
+{
+	struct device *dev =3D sp->dev;
+	struct psp_device *psp;
+
+	psp =3D devm_kzalloc(dev, sizeof(*psp), GFP_KERNEL);
+	if (!psp)
+		return NULL;
+
+	psp->dev =3D dev;
+	psp->sp =3D sp;
+
+	snprintf(psp->name, sizeof(psp->name), "psp-%u", sp->ord);
+
+	return psp;
+}
+
+static irqreturn_t psp_irq_handler(int irq, void *data)
+{
+	struct psp_device *psp =3D data;
+	unsigned int status;
+
+	/* Read the interrupt status: */
+	status =3D ioread32(psp->io_regs + psp->vdata->intsts_reg);
+
+	/* invoke subdevice interrupt handlers */
+	if (status) {
+		if (psp->sev_irq_handler)
+			psp->sev_irq_handler(irq, psp->sev_irq_data, status);
+	}
+
+	/* Clear the interrupt status by writing the same value we read. */
+	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
+
+	return IRQ_HANDLED;
+}
+
+static int psp_check_sev_support(struct psp_device *psp)
+{
+	/* Check if device supports SEV feature */
+	if (!(ioread32(psp->io_regs + psp->vdata->feature_reg) & 1)) {
+		dev_dbg(psp->dev, "psp does not support SEV\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+int psp_dev_init(struct sp_device *sp)
+{
+	struct device *dev =3D sp->dev;
+	struct psp_device *psp;
+	int ret;
+
+	ret =3D -ENOMEM;
+	psp =3D psp_alloc_struct(sp);
+	if (!psp)
+		goto e_err;
+
+	sp->psp_data =3D psp;
+
+	psp->vdata =3D (struct psp_vdata *)sp->dev_vdata->psp_vdata;
+	if (!psp->vdata) {
+		ret =3D -ENODEV;
+		dev_err(dev, "missing driver data\n");
+		goto e_err;
+	}
+
+	psp->io_regs =3D sp->io_map;
+
+	ret =3D psp_check_sev_support(psp);
+	if (ret)
+		goto e_disable;
+
+	/* Disable and clear interrupts until ready */
+	iowrite32(0, psp->io_regs + psp->vdata->inten_reg);
+	iowrite32(-1, psp->io_regs + psp->vdata->intsts_reg);
+
+	/* Request an irq */
+	ret =3D sp_request_psp_irq(psp->sp, psp_irq_handler, psp->name, psp);
+	if (ret) {
+		dev_err(dev, "psp: unable to allocate an IRQ\n");
+		goto e_err;
+	}
+
+	ret =3D sev_dev_init(psp);
+	if (ret)
+		goto e_irq;
+
+	if (sp->set_psp_master_device)
+		sp->set_psp_master_device(sp);
+
+	/* Enable interrupt */
+	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
+
+	dev_notice(dev, "psp enabled\n");
+
+	return 0;
+
+e_irq:
+	sp_free_psp_irq(psp->sp, psp);
+e_err:
+	sp->psp_data =3D NULL;
+
+	dev_notice(dev, "psp initialization failed\n");
+
+	return ret;
+
+e_disable:
+	sp->psp_data =3D NULL;
+
+	return ret;
+}
+
+void psp_dev_destroy(struct sp_device *sp)
+{
+	struct psp_device *psp =3D sp->psp_data;
+
+	if (!psp)
+		return;
+
+	sev_dev_destroy(psp);
+
+	sp_free_psp_irq(sp, psp);
+}
+
+void psp_set_sev_irq_handler(struct psp_device *psp, psp_irq_handler_t han=
dler,
+			     void *data)
+{
+	psp->sev_irq_data =3D data;
+	psp->sev_irq_handler =3D handler;
+}
+
+void psp_clear_sev_irq_handler(struct psp_device *psp)
+{
+	psp_set_sev_irq_handler(psp, NULL, NULL);
+}
+
+struct psp_device *psp_get_master_device(void)
+{
+	struct sp_device *sp =3D sp_get_psp_master_device();
+
+	return sp ? sp->psp_data : NULL;
+}
+
+void psp_pci_init(void)
+{
+	psp_master =3D psp_get_master_device();
+
+	if (!psp_master)
+		return;
+
+	sev_pci_init();
+}
+
+void psp_pci_exit(void)
+{
+	if (!psp_master)
+		return;
+
+	sev_pci_exit();
+}
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
new file mode 100644
index 0000000..7c014ac
--- /dev/null
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AMD Platform Security Processor (PSP) interface driver
+ *
+ * Copyright (C) 2017-2019 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#ifndef __PSP_DEV_H__
+#define __PSP_DEV_H__
+
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/bits.h>
+#include <linux/interrupt.h>
+
+#include "sp-dev.h"
+
+#define PSP_CMDRESP_RESP		BIT(31)
+#define PSP_CMDRESP_ERR_MASK		0xffff
+
+#define MAX_PSP_NAME_LEN		16
+
+extern struct psp_device *psp_master;
+
+typedef void (*psp_irq_handler_t)(int, void *, unsigned int);
+
+struct psp_device {
+	struct list_head entry;
+
+	struct psp_vdata *vdata;
+	char name[MAX_PSP_NAME_LEN];
+
+	struct device *dev;
+	struct sp_device *sp;
+
+	void __iomem *io_regs;
+
+	psp_irq_handler_t sev_irq_handler;
+	void *sev_irq_data;
+
+	void *sev_data;
+};
+
+void psp_set_sev_irq_handler(struct psp_device *psp, psp_irq_handler_t han=
dler,
+			     void *data);
+void psp_clear_sev_irq_handler(struct psp_device *psp);
+
+struct psp_device *psp_get_master_device(void);
+
+#endif /* __PSP_DEV_H */
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 77841a8..7e5e7b2 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -21,7 +21,7 @@
 #include <linux/ccp.h>
 #include <linux/firmware.h>

-#include "sp-dev.h"
+#include "psp-dev.h"
 #include "sev-dev.h"

 #define DEVICE_NAME		"sev"
@@ -30,7 +30,6 @@

 static DEFINE_MUTEX(sev_cmd_mutex);
 static struct sev_misc_dev *misc_dev;
-static struct psp_device *psp_master;

 static int psp_cmd_timeout =3D 100;
 module_param(psp_cmd_timeout, int, 0644);
@@ -45,68 +44,45 @@

 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
-	if (psp_master->api_major > maj)
-		return true;
-	if (psp_master->api_major =3D=3D maj && psp_master->api_minor >=3D min)
-		return true;
-	return false;
-}
-
-static struct psp_device *psp_alloc_struct(struct sp_device *sp)
-{
-	struct device *dev =3D sp->dev;
-	struct psp_device *psp;
-
-	psp =3D devm_kzalloc(dev, sizeof(*psp), GFP_KERNEL);
-	if (!psp)
-		return NULL;
+	struct sev_device *sev =3D psp_master->sev_data;

-	psp->dev =3D dev;
-	psp->sp =3D sp;
+	if (sev->api_major > maj)
+		return true;

-	snprintf(psp->name, sizeof(psp->name), "psp-%u", sp->ord);
+	if (sev->api_major =3D=3D maj && sev->api_minor >=3D min)
+		return true;

-	return psp;
+	return false;
 }

-static irqreturn_t psp_irq_handler(int irq, void *data)
+static void sev_irq_handler(int irq, void *data, unsigned int status)
 {
-	struct psp_device *psp =3D data;
-	unsigned int status;
+	struct sev_device *sev =3D data;
 	int reg;

-	/* Read the interrupt status: */
-	status =3D ioread32(psp->io_regs + psp->vdata->intsts_reg);
-
 	/* Check if it is command completion: */
-	if (!(status & PSP_CMD_COMPLETE))
-		goto done;
+	if (!(status & SEV_CMD_COMPLETE))
+		return;

 	/* Check if it is SEV command completion: */
-	reg =3D ioread32(psp->io_regs + psp->vdata->cmdresp_reg);
+	reg =3D ioread32(sev->io_regs + sev->psp->vdata->cmdresp_reg);
 	if (reg & PSP_CMDRESP_RESP) {
-		psp->sev_int_rcvd =3D 1;
-		wake_up(&psp->sev_int_queue);
+		sev->int_rcvd =3D 1;
+		wake_up(&sev->int_queue);
 	}
-
-done:
-	/* Clear the interrupt status by writing the same value we read. */
-	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
-
-	return IRQ_HANDLED;
 }

-static int sev_wait_cmd_ioc(struct psp_device *psp,
+static int sev_wait_cmd_ioc(struct sev_device *sev,
 			    unsigned int *reg, unsigned int timeout)
 {
 	int ret;

-	ret =3D wait_event_timeout(psp->sev_int_queue,
-			psp->sev_int_rcvd, timeout * HZ);
+	ret =3D wait_event_timeout(sev->int_queue,
+			sev->int_rcvd, timeout * HZ);
 	if (!ret)
 		return -ETIMEDOUT;

-	*reg =3D ioread32(psp->io_regs + psp->vdata->cmdresp_reg);
+	*reg =3D ioread32(sev->io_regs + sev->psp->vdata->cmdresp_reg);

 	return 0;
 }
@@ -150,42 +126,45 @@ static int sev_cmd_buffer_len(int cmd)
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct psp_device *psp =3D psp_master;
+	struct sev_device *sev;
 	unsigned int phys_lsb, phys_msb;
 	unsigned int reg, ret =3D 0;

-	if (!psp)
+	if (!psp || !psp->sev_data)
 		return -ENODEV;

 	if (psp_dead)
 		return -EBUSY;

+	sev =3D psp->sev_data;
+
 	/* Get the physical address of the command buffer */
 	phys_lsb =3D data ? lower_32_bits(__psp_pa(data)) : 0;
 	phys_msb =3D data ? upper_32_bits(__psp_pa(data)) : 0;

-	dev_dbg(psp->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
+	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
 		cmd, phys_msb, phys_lsb, psp_timeout);

 	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
 			     sev_cmd_buffer_len(cmd), false);

-	iowrite32(phys_lsb, psp->io_regs + psp->vdata->cmdbuff_addr_lo_reg);
-	iowrite32(phys_msb, psp->io_regs + psp->vdata->cmdbuff_addr_hi_reg);
+	iowrite32(phys_lsb, sev->io_regs + psp->vdata->cmdbuff_addr_lo_reg);
+	iowrite32(phys_msb, sev->io_regs + psp->vdata->cmdbuff_addr_hi_reg);

-	psp->sev_int_rcvd =3D 0;
+	sev->int_rcvd =3D 0;

 	reg =3D cmd;
-	reg <<=3D PSP_CMDRESP_CMD_SHIFT;
-	reg |=3D PSP_CMDRESP_IOC;
-	iowrite32(reg, psp->io_regs + psp->vdata->cmdresp_reg);
+	reg <<=3D SEV_CMDRESP_CMD_SHIFT;
+	reg |=3D SEV_CMDRESP_IOC;
+	iowrite32(reg, sev->io_regs + psp->vdata->cmdresp_reg);

 	/* wait for command completion */
-	ret =3D sev_wait_cmd_ioc(psp, &reg, psp_timeout);
+	ret =3D sev_wait_cmd_ioc(sev, &reg, psp_timeout);
 	if (ret) {
 		if (psp_ret)
 			*psp_ret =3D 0;

-		dev_err(psp->dev, "sev command %#x timed out, disabling PSP \n", cmd);
+		dev_err(sev->dev, "sev command %#x timed out, disabling PSP\n", cmd);
 		psp_dead =3D true;

 		return ret;
@@ -197,7 +176,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int=
 *psp_ret)
 		*psp_ret =3D reg & PSP_CMDRESP_ERR_MASK;

 	if (reg & PSP_CMDRESP_ERR_MASK) {
-		dev_dbg(psp->dev, "sev command %#x failed (%#010x)\n",
+		dev_dbg(sev->dev, "sev command %#x failed (%#010x)\n",
 			cmd, reg & PSP_CMDRESP_ERR_MASK);
 		ret =3D -EIO;
 	}
@@ -222,20 +201,23 @@ static int sev_do_cmd(int cmd, void *data, int *psp_r=
et)
 static int __sev_platform_init_locked(int *error)
 {
 	struct psp_device *psp =3D psp_master;
+	struct sev_device *sev;
 	int rc =3D 0;

-	if (!psp)
+	if (!psp || !psp->sev_data)
 		return -ENODEV;

-	if (psp->sev_state =3D=3D SEV_STATE_INIT)
+	sev =3D psp->sev_data;
+
+	if (sev->state =3D=3D SEV_STATE_INIT)
 		return 0;

-	rc =3D __sev_do_cmd_locked(SEV_CMD_INIT, &psp->init_cmd_buf, error);
+	rc =3D __sev_do_cmd_locked(SEV_CMD_INIT, &sev->init_cmd_buf, error);
 	if (rc)
 		return rc;

-	psp->sev_state =3D SEV_STATE_INIT;
-	dev_dbg(psp->dev, "SEV firmware initialized\n");
+	sev->state =3D SEV_STATE_INIT;
+	dev_dbg(sev->dev, "SEV firmware initialized\n");

 	return rc;
 }
@@ -254,14 +236,15 @@ int sev_platform_init(int *error)

 static int __sev_platform_shutdown_locked(int *error)
 {
+	struct sev_device *sev =3D psp_master->sev_data;
 	int ret;

 	ret =3D __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
 	if (ret)
 		return ret;

-	psp_master->sev_state =3D SEV_STATE_UNINIT;
-	dev_dbg(psp_master->dev, "SEV firmware shutdown\n");
+	sev->state =3D SEV_STATE_UNINIT;
+	dev_dbg(sev->dev, "SEV firmware shutdown\n");

 	return ret;
 }
@@ -279,14 +262,15 @@ static int sev_platform_shutdown(int *error)

 static int sev_get_platform_state(int *state, int *error)
 {
+	struct sev_device *sev =3D psp_master->sev_data;
 	int rc;

 	rc =3D __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS,
-				 &psp_master->status_cmd_buf, error);
+				 &sev->status_cmd_buf, error);
 	if (rc)
 		return rc;

-	*state =3D psp_master->status_cmd_buf.state;
+	*state =3D sev->status_cmd_buf.state;
 	return rc;
 }

@@ -321,7 +305,8 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *arg=
p)

 static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 {
-	struct sev_user_data_status *data =3D &psp_master->status_cmd_buf;
+	struct sev_device *sev =3D psp_master->sev_data;
+	struct sev_user_data_status *data =3D &sev->status_cmd_buf;
 	int ret;

 	ret =3D __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
@@ -336,9 +321,10 @@ static int sev_ioctl_do_platform_status(struct sev_iss=
ue_cmd *argp)

 static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
 {
+	struct sev_device *sev =3D psp_master->sev_data;
 	int rc;

-	if (psp_master->sev_state =3D=3D SEV_STATE_UNINIT) {
+	if (sev->state =3D=3D SEV_STATE_UNINIT) {
 		rc =3D __sev_platform_init_locked(&argp->error);
 		if (rc)
 			return rc;
@@ -349,6 +335,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev=
_issue_cmd *argp)

 static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
 {
+	struct sev_device *sev =3D psp_master->sev_data;
 	struct sev_user_data_pek_csr input;
 	struct sev_data_pek_csr *data;
 	void *blob =3D NULL;
@@ -382,7 +369,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *a=
rgp)
 	data->len =3D input.length;

 cmd:
-	if (psp_master->sev_state =3D=3D SEV_STATE_UNINIT) {
+	if (sev->state =3D=3D SEV_STATE_UNINIT) {
 		ret =3D __sev_platform_init_locked(&argp->error);
 		if (ret)
 			goto e_free_blob;
@@ -425,21 +412,22 @@ void *psp_copy_user_blob(u64 __user uaddr, u32 len)

 static int sev_get_api_version(void)
 {
+	struct sev_device *sev =3D psp_master->sev_data;
 	struct sev_user_data_status *status;
 	int error =3D 0, ret;

-	status =3D &psp_master->status_cmd_buf;
+	status =3D &sev->status_cmd_buf;
 	ret =3D sev_platform_status(status, &error);
 	if (ret) {
-		dev_err(psp_master->dev,
+		dev_err(sev->dev,
 			"SEV: failed to get status. Error: %#x\n", error);
 		return 1;
 	}

-	psp_master->api_major =3D status->api_major;
-	psp_master->api_minor =3D status->api_minor;
-	psp_master->build =3D status->build;
-	psp_master->sev_state =3D status->state;
+	sev->api_major =3D status->api_major;
+	sev->api_minor =3D status->api_minor;
+	sev->build =3D status->build;
+	sev->state =3D status->state;

 	return 0;
 }
@@ -535,6 +523,7 @@ static int sev_update_firmware(struct device *dev)

 static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
 {
+	struct sev_device *sev =3D psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
 	struct sev_data_pek_cert_import *data;
 	void *pek_blob, *oca_blob;
@@ -568,7 +557,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd=
 *argp)
 	data->oca_cert_len =3D input.oca_cert_len;

 	/* If platform is not in INIT state then transition it to INIT */
-	if (psp_master->sev_state !=3D SEV_STATE_INIT) {
+	if (sev->state !=3D SEV_STATE_INIT) {
 		ret =3D __sev_platform_init_locked(&argp->error);
 		if (ret)
 			goto e_free_oca;
@@ -690,6 +679,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *ar=
gp)

 static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
 {
+	struct sev_device *sev =3D psp_master->sev_data;
 	struct sev_user_data_pdh_cert_export input;
 	void *pdh_blob =3D NULL, *cert_blob =3D NULL;
 	struct sev_data_pdh_cert_export *data;
@@ -742,7 +732,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd=
 *argp)

 cmd:
 	/* If platform is not in INIT state then transition it to INIT. */
-	if (psp_master->sev_state !=3D SEV_STATE_INIT) {
+	if (sev->state !=3D SEV_STATE_INIT) {
 		ret =3D __sev_platform_init_locked(&argp->error);
 		if (ret)
 			goto e_free_cert;
@@ -788,7 +778,7 @@ static long sev_ioctl(struct file *file, unsigned int i=
octl, unsigned long arg)
 	struct sev_issue_cmd input;
 	int ret =3D -EFAULT;

-	if (!psp_master)
+	if (!psp_master || !psp_master->sev_data)
 		return -ENODEV;

 	if (ioctl !=3D SEV_ISSUE_CMD)
@@ -887,9 +877,9 @@ static void sev_exit(struct kref *ref)
 	misc_deregister(&misc_dev->misc);
 }

-static int sev_misc_init(struct psp_device *psp)
+static int sev_misc_init(struct sev_device *sev)
 {
-	struct device *dev =3D psp->dev;
+	struct device *dev =3D sev->dev;
 	int ret;

 	/*
@@ -920,101 +910,61 @@ static int sev_misc_init(struct psp_device *psp)
 		kref_get(&misc_dev->refcount);
 	}

-	init_waitqueue_head(&psp->sev_int_queue);
-	psp->sev_misc =3D misc_dev;
+	init_waitqueue_head(&sev->int_queue);
+	sev->misc =3D misc_dev;
 	dev_dbg(dev, "registered SEV device\n");

 	return 0;
 }

-static int psp_check_sev_support(struct psp_device *psp)
-{
-	/* Check if device supports SEV feature */
-	if (!(ioread32(psp->io_regs + psp->vdata->feature_reg) & 1)) {
-		dev_dbg(psp->dev, "psp does not support SEV\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-int psp_dev_init(struct sp_device *sp)
+int sev_dev_init(struct psp_device *psp)
 {
-	struct device *dev =3D sp->dev;
-	struct psp_device *psp;
-	int ret;
-
-	ret =3D -ENOMEM;
-	psp =3D psp_alloc_struct(sp);
-	if (!psp)
-		goto e_err;
-
-	sp->psp_data =3D psp;
+	struct device *dev =3D psp->dev;
+	struct sev_device *sev;
+	int ret =3D -ENOMEM;

-	psp->vdata =3D (struct psp_vdata *)sp->dev_vdata->psp_vdata;
-	if (!psp->vdata) {
-		ret =3D -ENODEV;
-		dev_err(dev, "missing driver data\n");
+	sev =3D devm_kzalloc(dev, sizeof(*sev), GFP_KERNEL);
+	if (!sev)
 		goto e_err;
-	}

-	psp->io_regs =3D sp->io_map;
+	psp->sev_data =3D sev;

-	ret =3D psp_check_sev_support(psp);
-	if (ret)
-		goto e_disable;
+	sev->dev =3D dev;
+	sev->psp =3D psp;

-	/* Disable and clear interrupts until ready */
-	iowrite32(0, psp->io_regs + psp->vdata->inten_reg);
-	iowrite32(-1, psp->io_regs + psp->vdata->intsts_reg);
+	sev->io_regs =3D psp->io_regs;

-	/* Request an irq */
-	ret =3D sp_request_psp_irq(psp->sp, psp_irq_handler, psp->name, psp);
-	if (ret) {
-		dev_err(dev, "psp: unable to allocate an IRQ\n");
-		goto e_err;
-	}
+	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);

-	ret =3D sev_misc_init(psp);
+	ret =3D sev_misc_init(sev);
 	if (ret)
 		goto e_irq;

-	if (sp->set_psp_master_device)
-		sp->set_psp_master_device(sp);
-
-	/* Enable interrupt */
-	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
-
-	dev_notice(dev, "psp enabled\n");
+	dev_notice(dev, "sev enabled\n");

 	return 0;

 e_irq:
-	sp_free_psp_irq(psp->sp, psp);
+	psp_clear_sev_irq_handler(psp);
 e_err:
-	sp->psp_data =3D NULL;
+	psp->sev_data =3D NULL;

-	dev_notice(dev, "psp initialization failed\n");
-
-	return ret;
-
-e_disable:
-	sp->psp_data =3D NULL;
+	dev_notice(dev, "sev initialization failed\n");

 	return ret;
 }

-void psp_dev_destroy(struct sp_device *sp)
+void sev_dev_destroy(struct psp_device *psp)
 {
-	struct psp_device *psp =3D sp->psp_data;
+	struct sev_device *sev =3D psp->sev_data;

-	if (!psp)
+	if (!sev)
 		return;

-	if (psp->sev_misc)
+	if (sev->misc)
 		kref_put(&misc_dev->refcount, sev_exit);

-	sp_free_psp_irq(sp, psp);
+	psp_clear_sev_irq_handler(psp);
 }

 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
@@ -1023,21 +973,18 @@ int sev_issue_cmd_external_user(struct file *filep, =
unsigned int cmd,
 	if (!filep || filep->f_op !=3D &sev_fops)
 		return -EBADF;

-	return  sev_do_cmd(cmd, data, error);
+	return sev_do_cmd(cmd, data, error);
 }
 EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);

-void psp_pci_init(void)
+void sev_pci_init(void)
 {
-	struct sp_device *sp;
+	struct sev_device *sev =3D psp_master->sev_data;
 	int error, rc;

-	sp =3D sp_get_psp_master_device();
-	if (!sp)
+	if (!sev)
 		return;

-	psp_master =3D sp->psp_data;
-
 	psp_timeout =3D psp_probe_timeout;

 	if (sev_get_api_version())
@@ -1053,34 +1000,34 @@ void psp_pci_init(void)
 	 * firmware in INIT or WORKING state.
 	 */

-	if (psp_master->sev_state !=3D SEV_STATE_UNINIT) {
+	if (sev->state !=3D SEV_STATE_UNINIT) {
 		sev_platform_shutdown(NULL);
-		psp_master->sev_state =3D SEV_STATE_UNINIT;
+		sev->state =3D SEV_STATE_UNINIT;
 	}

 	if (sev_version_greater_or_equal(0, 15) &&
-	    sev_update_firmware(psp_master->dev) =3D=3D 0)
+	    sev_update_firmware(sev->dev) =3D=3D 0)
 		sev_get_api_version();

 	/* Initialize the platform */
 	rc =3D sev_platform_init(&error);
 	if (rc) {
-		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
+		dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
 		return;
 	}

-	dev_info(sp->dev, "SEV API:%d.%d build:%d\n", psp_master->api_major,
-		 psp_master->api_minor, psp_master->build);
+	dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
+		 sev->api_minor, sev->build);

 	return;

 err:
-	psp_master =3D NULL;
+	psp_master->sev_data =3D NULL;
 }

-void psp_pci_exit(void)
+void sev_pci_exit(void)
 {
-	if (!psp_master)
+	if (!psp_master->sev_data)
 		return;

 	sev_platform_shutdown(NULL);
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 2ca1a01..20d51c9 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -24,37 +24,25 @@
 #include <linux/psp-sev.h>
 #include <linux/miscdevice.h>

-#include "sp-dev.h"
-
-#define PSP_CMD_COMPLETE		BIT(1)
-
-#define PSP_CMDRESP_CMD_SHIFT		16
-#define PSP_CMDRESP_IOC			BIT(0)
-#define PSP_CMDRESP_RESP		BIT(31)
-#define PSP_CMDRESP_ERR_MASK		0xffff
-
-#define MAX_PSP_NAME_LEN		16
+#define SEV_CMD_COMPLETE		BIT(1)
+#define SEV_CMDRESP_CMD_SHIFT		16
+#define SEV_CMDRESP_IOC			BIT(0)

 struct sev_misc_dev {
 	struct kref refcount;
 	struct miscdevice misc;
 };

-struct psp_device {
-	struct list_head entry;
-
-	struct psp_vdata *vdata;
-	char name[MAX_PSP_NAME_LEN];
-
+struct sev_device {
 	struct device *dev;
-	struct sp_device *sp;
+	struct psp_device *psp;

 	void __iomem *io_regs;

-	int sev_state;
-	unsigned int sev_int_rcvd;
-	wait_queue_head_t sev_int_queue;
-	struct sev_misc_dev *sev_misc;
+	int state;
+	unsigned int int_rcvd;
+	wait_queue_head_t int_queue;
+	struct sev_misc_dev *misc;
 	struct sev_user_data_status status_cmd_buf;
 	struct sev_data_init init_cmd_buf;

@@ -63,4 +51,10 @@ struct psp_device {
 	u8 build;
 };

+int sev_dev_init(struct psp_device *psp);
+void sev_dev_destroy(struct psp_device *psp);
+
+void sev_pci_init(void);
+void sev_pci_exit(void);
+
 #endif /* __SEV_DEV_H */
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 473cf14..b29d2e6 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -22,7 +22,7 @@
 #include <linux/ccp.h>

 #include "ccp-dev.h"
-#include "sev-dev.h"
+#include "psp-dev.h"

 #define MSIX_VECTORS			2

--
1.9.1

