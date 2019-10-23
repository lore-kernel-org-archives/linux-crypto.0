Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 509F1CA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E32F12084B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="r4XQ7vKi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404864AbfJWL1e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:27:34 -0400
Received: from mail-eopbgr790072.outbound.protection.outlook.com ([40.107.79.72]:4704
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732149AbfJWL1d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 07:27:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONmSLROzSWK1FZeVmUthJQgRcx5toPaaC+qHp2a5N7cNJvWL+t0EGMYMQ0E+yMbmomui2W4CFEKRDg6GHYramJYFu1SiMts1bkbgY4WdgZ6KrWqkYwBrnicl6Kno2sIjcbzNY7WZsIwfQObc3v3+McsrZDyQv2lgkqlDy2s9ZH2i60VSnTxX3t8301syhch+fRpBs2+umsT+XqwwUcOx2luF8BH5kh3/VqFk75UKnlHK+yRekGW2eYZGS5UR9VwFnRSWo/iGdhihnY1hLAkpJHvjwxSUpGQ9y9s+0qwFUR36eXm6M1CVMTwBNjXzKxy9zd+zJU8Iok7fREx6GwVbxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSUxVR6m7rnb6cOuhA4FZG3lLtC8UCLDDdyOALuHhDk=;
 b=cXQmXmgz/2eI4bUjwt70GmQgTxT3HcINmnFLaawP18i4WMLKErK2XoRLI/bli9rhKcJh14sOvAd2h66D7TxHkl3x27Y8Etu/Idf1wVSEMYGQJTwFzdFv2J+hAzwIyIqNQ+Tq2X/ZfJWyGmtGf8kggyiaJNbZInGrVuIIsp5ECk1MblAqT4eAvuRrcWQco4DcYRu5MS+ehQtJeSyGgscIcI63lBQyHx9RmMDIBm2xSsh4KxnF8I4//ob5p3M7eGQKMYEYZsh0a89Hx7sErakR2BKyc/FxkzD57XAe1Xx9j0RXyewQ4RduQN6sAixgtAp5QC2ZaoX64Rpa1GTXiwOyrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSUxVR6m7rnb6cOuhA4FZG3lLtC8UCLDDdyOALuHhDk=;
 b=r4XQ7vKi+pVZL9GKa/oD/RXxCWjoWzqWq23ySNG+TVxB+659fuvaEa+LDlBFTnvKDHUBL4L9e/BjDXA54f2WOmJSmq9pH2siUCA0nb423HO3kuf4HMuxh4+xkU7g21ea22wDcBbd8QK/4dYfsF3xSnMpuvsZYtzCWSFmJwnKpuo=
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1527.namprd12.prod.outlook.com (10.172.66.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 11:27:28 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1%11]) with mapi id 15.20.2387.019; Wed, 23 Oct
 2019 11:27:28 +0000
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
Subject: [RFC PATCH 1/5] crypto: ccp - rename psp-dev files to sev-dev
Thread-Topic: [RFC PATCH 1/5] crypto: ccp - rename psp-dev files to sev-dev
Thread-Index: AQHViZTaeW4oDnl060iTQZKgrU1ykw==
Date:   Wed, 23 Oct 2019 11:27:28 +0000
Message-ID: <119557a5db5cc55c0e88f1543c0fabf0c820cb92.1571817675.git.Rijo-john.Thomas@amd.com>
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
x-ms-office365-filtering-correlation-id: 11bf142f-ad72-416a-e1e8-08d757abfc22
x-ms-traffictypediagnostic: CY4PR12MB1527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR12MB15272870A97C87708762547CCF6B0@CY4PR12MB1527.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(476003)(81156014)(386003)(6486002)(6506007)(14454004)(446003)(11346002)(26005)(81166006)(305945005)(86362001)(5660300002)(186003)(102836004)(7736002)(50226002)(30864003)(66946007)(6436002)(478600001)(316002)(6116002)(3846002)(99286004)(6512007)(71190400001)(25786009)(118296001)(71200400001)(8676002)(110136005)(54906003)(2906002)(8936002)(486006)(256004)(14444005)(66476007)(66556008)(64756008)(66066001)(2201001)(52116002)(76176011)(66446008)(36756003)(2501003)(4326008)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1527;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RRbcyP1uuCWygHXtw9BNXoT0H42WUkPlXRoDf+I4W9LMTvqWYZCoLe4LImp7u7KsPfvrkqIJco4+x38jqhcqlzFkoYaXUYB95ipV6sOHhpb3z77Jgz+7rVK1F24yvapAdJYEmrWPLI9Bd7Om3xu5K0GYgQtv/uNpS92XzHjIr7VGkt0F9GTMBPVjc8KBNvJlrSxcpOPhzn6dWTQMYrgYcUDV4GJGpSdvaV5Q31wkbl5HK8ovlak3Y78mikwVI3g72p0mlt6jkri2uNVAdasufS/pr/zqzGKS6tXV3V/V8VgomsbaU4AnBbDZTeI1/umykR5yHv+mjBiB1K5K8H2XmPlxk7gVkoTtBLgWyww23lgpM1slnxaxCwubfMIqUy2Iby/andNDWqAoVq6iD7VEM9a+CINfO8efgtpfo/TaqxMf2kqdLdyMR5BDD0jTSXOv
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11bf142f-ad72-416a-e1e8-08d757abfc22
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 11:27:28.3830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SaS1YB5Xfzs6ki1d/e6SJBMFYP1bD5vJPqwObbJOSlJw4m8maecAuzkdxkRneIAciUIOsd4toyRTfT84XcOvkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1527
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a preliminary patch for creating a generic PSP device driver
file, which will have support for both SEV and TEE (Trusted Execution
Environment) interface.

This patch does not introduce any new functionality, but simply renames
psp-dev.c and psp-dev.h files to sev-dev.c and sev-dev.h files
respectively.

Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
---
 drivers/crypto/ccp/Makefile  |    2 +-
 drivers/crypto/ccp/psp-dev.c | 1087 --------------------------------------=
----
 drivers/crypto/ccp/psp-dev.h |   66 ---
 drivers/crypto/ccp/sev-dev.c | 1087 ++++++++++++++++++++++++++++++++++++++=
++++
 drivers/crypto/ccp/sev-dev.h |   66 +++
 drivers/crypto/ccp/sp-pci.c  |    2 +-
 6 files changed, 1155 insertions(+), 1155 deletions(-)
 delete mode 100644 drivers/crypto/ccp/psp-dev.c
 delete mode 100644 drivers/crypto/ccp/psp-dev.h
 create mode 100644 drivers/crypto/ccp/sev-dev.c
 create mode 100644 drivers/crypto/ccp/sev-dev.h

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 6b86f1e..9dafcf2 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -8,7 +8,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) +=3D ccp-dev.o \
 	    ccp-dmaengine.o
 ccp-$(CONFIG_CRYPTO_DEV_CCP_DEBUGFS) +=3D ccp-debugfs.o
 ccp-$(CONFIG_PCI) +=3D sp-pci.o
-ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) +=3D psp-dev.o
+ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) +=3D sev-dev.o

 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) +=3D ccp-crypto.o
 ccp-crypto-objs :=3D ccp-crypto-main.o \
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
deleted file mode 100644
index 6b17d17..0000000
--- a/drivers/crypto/ccp/psp-dev.c
+++ /dev/null
@@ -1,1087 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * AMD Platform Security Processor (PSP) interface
- *
- * Copyright (C) 2016,2018 Advanced Micro Devices, Inc.
- *
- * Author: Brijesh Singh <brijesh.singh@amd.com>
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/kthread.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/spinlock_types.h>
-#include <linux/types.h>
-#include <linux/mutex.h>
-#include <linux/delay.h>
-#include <linux/hw_random.h>
-#include <linux/ccp.h>
-#include <linux/firmware.h>
-
-#include "sp-dev.h"
-#include "psp-dev.h"
-
-#define DEVICE_NAME		"sev"
-#define SEV_FW_FILE		"amd/sev.fw"
-#define SEV_FW_NAME_SIZE	64
-
-static DEFINE_MUTEX(sev_cmd_mutex);
-static struct sev_misc_dev *misc_dev;
-static struct psp_device *psp_master;
-
-static int psp_cmd_timeout =3D 100;
-module_param(psp_cmd_timeout, int, 0644);
-MODULE_PARM_DESC(psp_cmd_timeout, " default timeout value, in seconds, for=
 PSP commands");
-
-static int psp_probe_timeout =3D 5;
-module_param(psp_probe_timeout, int, 0644);
-MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, d=
uring PSP device probe");
-
-static bool psp_dead;
-static int psp_timeout;
-
-static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
-{
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
-
-	psp->dev =3D dev;
-	psp->sp =3D sp;
-
-	snprintf(psp->name, sizeof(psp->name), "psp-%u", sp->ord);
-
-	return psp;
-}
-
-static irqreturn_t psp_irq_handler(int irq, void *data)
-{
-	struct psp_device *psp =3D data;
-	unsigned int status;
-	int reg;
-
-	/* Read the interrupt status: */
-	status =3D ioread32(psp->io_regs + psp->vdata->intsts_reg);
-
-	/* Check if it is command completion: */
-	if (!(status & PSP_CMD_COMPLETE))
-		goto done;
-
-	/* Check if it is SEV command completion: */
-	reg =3D ioread32(psp->io_regs + psp->vdata->cmdresp_reg);
-	if (reg & PSP_CMDRESP_RESP) {
-		psp->sev_int_rcvd =3D 1;
-		wake_up(&psp->sev_int_queue);
-	}
-
-done:
-	/* Clear the interrupt status by writing the same value we read. */
-	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
-
-	return IRQ_HANDLED;
-}
-
-static int sev_wait_cmd_ioc(struct psp_device *psp,
-			    unsigned int *reg, unsigned int timeout)
-{
-	int ret;
-
-	ret =3D wait_event_timeout(psp->sev_int_queue,
-			psp->sev_int_rcvd, timeout * HZ);
-	if (!ret)
-		return -ETIMEDOUT;
-
-	*reg =3D ioread32(psp->io_regs + psp->vdata->cmdresp_reg);
-
-	return 0;
-}
-
-static int sev_cmd_buffer_len(int cmd)
-{
-	switch (cmd) {
-	case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
-	case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_user_data_status)=
;
-	case SEV_CMD_PEK_CSR:			return sizeof(struct sev_data_pek_csr);
-	case SEV_CMD_PEK_CERT_IMPORT:		return sizeof(struct sev_data_pek_cert_imp=
ort);
-	case SEV_CMD_PDH_CERT_EXPORT:		return sizeof(struct sev_data_pdh_cert_exp=
ort);
-	case SEV_CMD_LAUNCH_START:		return sizeof(struct sev_data_launch_start);
-	case SEV_CMD_LAUNCH_UPDATE_DATA:	return sizeof(struct sev_data_launch_upd=
ate_data);
-	case SEV_CMD_LAUNCH_UPDATE_VMSA:	return sizeof(struct sev_data_launch_upd=
ate_vmsa);
-	case SEV_CMD_LAUNCH_FINISH:		return sizeof(struct sev_data_launch_finish)=
;
-	case SEV_CMD_LAUNCH_MEASURE:		return sizeof(struct sev_data_launch_measur=
e);
-	case SEV_CMD_ACTIVATE:			return sizeof(struct sev_data_activate);
-	case SEV_CMD_DEACTIVATE:		return sizeof(struct sev_data_deactivate);
-	case SEV_CMD_DECOMMISSION:		return sizeof(struct sev_data_decommission);
-	case SEV_CMD_GUEST_STATUS:		return sizeof(struct sev_data_guest_status);
-	case SEV_CMD_DBG_DECRYPT:		return sizeof(struct sev_data_dbg);
-	case SEV_CMD_DBG_ENCRYPT:		return sizeof(struct sev_data_dbg);
-	case SEV_CMD_SEND_START:		return sizeof(struct sev_data_send_start);
-	case SEV_CMD_SEND_UPDATE_DATA:		return sizeof(struct sev_data_send_update=
_data);
-	case SEV_CMD_SEND_UPDATE_VMSA:		return sizeof(struct sev_data_send_update=
_vmsa);
-	case SEV_CMD_SEND_FINISH:		return sizeof(struct sev_data_send_finish);
-	case SEV_CMD_RECEIVE_START:		return sizeof(struct sev_data_receive_start)=
;
-	case SEV_CMD_RECEIVE_FINISH:		return sizeof(struct sev_data_receive_finis=
h);
-	case SEV_CMD_RECEIVE_UPDATE_DATA:	return sizeof(struct sev_data_receive_u=
pdate_data);
-	case SEV_CMD_RECEIVE_UPDATE_VMSA:	return sizeof(struct sev_data_receive_u=
pdate_vmsa);
-	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_s=
ecret);
-	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_f=
irmware);
-	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
-	default:				return 0;
-	}
-
-	return 0;
-}
-
-static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
-{
-	struct psp_device *psp =3D psp_master;
-	unsigned int phys_lsb, phys_msb;
-	unsigned int reg, ret =3D 0;
-
-	if (!psp)
-		return -ENODEV;
-
-	if (psp_dead)
-		return -EBUSY;
-
-	/* Get the physical address of the command buffer */
-	phys_lsb =3D data ? lower_32_bits(__psp_pa(data)) : 0;
-	phys_msb =3D data ? upper_32_bits(__psp_pa(data)) : 0;
-
-	dev_dbg(psp->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
-		cmd, phys_msb, phys_lsb, psp_timeout);
-
-	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
-			     sev_cmd_buffer_len(cmd), false);
-
-	iowrite32(phys_lsb, psp->io_regs + psp->vdata->cmdbuff_addr_lo_reg);
-	iowrite32(phys_msb, psp->io_regs + psp->vdata->cmdbuff_addr_hi_reg);
-
-	psp->sev_int_rcvd =3D 0;
-
-	reg =3D cmd;
-	reg <<=3D PSP_CMDRESP_CMD_SHIFT;
-	reg |=3D PSP_CMDRESP_IOC;
-	iowrite32(reg, psp->io_regs + psp->vdata->cmdresp_reg);
-
-	/* wait for command completion */
-	ret =3D sev_wait_cmd_ioc(psp, &reg, psp_timeout);
-	if (ret) {
-		if (psp_ret)
-			*psp_ret =3D 0;
-
-		dev_err(psp->dev, "sev command %#x timed out, disabling PSP \n", cmd);
-		psp_dead =3D true;
-
-		return ret;
-	}
-
-	psp_timeout =3D psp_cmd_timeout;
-
-	if (psp_ret)
-		*psp_ret =3D reg & PSP_CMDRESP_ERR_MASK;
-
-	if (reg & PSP_CMDRESP_ERR_MASK) {
-		dev_dbg(psp->dev, "sev command %#x failed (%#010x)\n",
-			cmd, reg & PSP_CMDRESP_ERR_MASK);
-		ret =3D -EIO;
-	}
-
-	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
-			     sev_cmd_buffer_len(cmd), false);
-
-	return ret;
-}
-
-static int sev_do_cmd(int cmd, void *data, int *psp_ret)
-{
-	int rc;
-
-	mutex_lock(&sev_cmd_mutex);
-	rc =3D __sev_do_cmd_locked(cmd, data, psp_ret);
-	mutex_unlock(&sev_cmd_mutex);
-
-	return rc;
-}
-
-static int __sev_platform_init_locked(int *error)
-{
-	struct psp_device *psp =3D psp_master;
-	int rc =3D 0;
-
-	if (!psp)
-		return -ENODEV;
-
-	if (psp->sev_state =3D=3D SEV_STATE_INIT)
-		return 0;
-
-	rc =3D __sev_do_cmd_locked(SEV_CMD_INIT, &psp->init_cmd_buf, error);
-	if (rc)
-		return rc;
-
-	psp->sev_state =3D SEV_STATE_INIT;
-	dev_dbg(psp->dev, "SEV firmware initialized\n");
-
-	return rc;
-}
-
-int sev_platform_init(int *error)
-{
-	int rc;
-
-	mutex_lock(&sev_cmd_mutex);
-	rc =3D __sev_platform_init_locked(error);
-	mutex_unlock(&sev_cmd_mutex);
-
-	return rc;
-}
-EXPORT_SYMBOL_GPL(sev_platform_init);
-
-static int __sev_platform_shutdown_locked(int *error)
-{
-	int ret;
-
-	ret =3D __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
-	if (ret)
-		return ret;
-
-	psp_master->sev_state =3D SEV_STATE_UNINIT;
-	dev_dbg(psp_master->dev, "SEV firmware shutdown\n");
-
-	return ret;
-}
-
-static int sev_platform_shutdown(int *error)
-{
-	int rc;
-
-	mutex_lock(&sev_cmd_mutex);
-	rc =3D __sev_platform_shutdown_locked(NULL);
-	mutex_unlock(&sev_cmd_mutex);
-
-	return rc;
-}
-
-static int sev_get_platform_state(int *state, int *error)
-{
-	int rc;
-
-	rc =3D __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS,
-				 &psp_master->status_cmd_buf, error);
-	if (rc)
-		return rc;
-
-	*state =3D psp_master->status_cmd_buf.state;
-	return rc;
-}
-
-static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
-{
-	int state, rc;
-
-	/*
-	 * The SEV spec requires that FACTORY_RESET must be issued in
-	 * UNINIT state. Before we go further lets check if any guest is
-	 * active.
-	 *
-	 * If FW is in WORKING state then deny the request otherwise issue
-	 * SHUTDOWN command do INIT -> UNINIT before issuing the FACTORY_RESET.
-	 *
-	 */
-	rc =3D sev_get_platform_state(&state, &argp->error);
-	if (rc)
-		return rc;
-
-	if (state =3D=3D SEV_STATE_WORKING)
-		return -EBUSY;
-
-	if (state =3D=3D SEV_STATE_INIT) {
-		rc =3D __sev_platform_shutdown_locked(&argp->error);
-		if (rc)
-			return rc;
-	}
-
-	return __sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, NULL, &argp->error);
-}
-
-static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
-{
-	struct sev_user_data_status *data =3D &psp_master->status_cmd_buf;
-	int ret;
-
-	ret =3D __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
-	if (ret)
-		return ret;
-
-	if (copy_to_user((void __user *)argp->data, data, sizeof(*data)))
-		ret =3D -EFAULT;
-
-	return ret;
-}
-
-static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
-{
-	int rc;
-
-	if (psp_master->sev_state =3D=3D SEV_STATE_UNINIT) {
-		rc =3D __sev_platform_init_locked(&argp->error);
-		if (rc)
-			return rc;
-	}
-
-	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
-}
-
-static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
-{
-	struct sev_user_data_pek_csr input;
-	struct sev_data_pek_csr *data;
-	void *blob =3D NULL;
-	int ret;
-
-	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
-		return -EFAULT;
-
-	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	/* userspace wants to query CSR length */
-	if (!input.address || !input.length)
-		goto cmd;
-
-	/* allocate a physically contiguous buffer to store the CSR blob */
-	if (!access_ok(input.address, input.length) ||
-	    input.length > SEV_FW_BLOB_MAX_SIZE) {
-		ret =3D -EFAULT;
-		goto e_free;
-	}
-
-	blob =3D kmalloc(input.length, GFP_KERNEL);
-	if (!blob) {
-		ret =3D -ENOMEM;
-		goto e_free;
-	}
-
-	data->address =3D __psp_pa(blob);
-	data->len =3D input.length;
-
-cmd:
-	if (psp_master->sev_state =3D=3D SEV_STATE_UNINIT) {
-		ret =3D __sev_platform_init_locked(&argp->error);
-		if (ret)
-			goto e_free_blob;
-	}
-
-	ret =3D __sev_do_cmd_locked(SEV_CMD_PEK_CSR, data, &argp->error);
-
-	 /* If we query the CSR length, FW responded with expected data. */
-	input.length =3D data->len;
-
-	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
-		ret =3D -EFAULT;
-		goto e_free_blob;
-	}
-
-	if (blob) {
-		if (copy_to_user((void __user *)input.address, blob, input.length))
-			ret =3D -EFAULT;
-	}
-
-e_free_blob:
-	kfree(blob);
-e_free:
-	kfree(data);
-	return ret;
-}
-
-void *psp_copy_user_blob(u64 __user uaddr, u32 len)
-{
-	if (!uaddr || !len)
-		return ERR_PTR(-EINVAL);
-
-	/* verify that blob length does not exceed our limit */
-	if (len > SEV_FW_BLOB_MAX_SIZE)
-		return ERR_PTR(-EINVAL);
-
-	return memdup_user((void __user *)(uintptr_t)uaddr, len);
-}
-EXPORT_SYMBOL_GPL(psp_copy_user_blob);
-
-static int sev_get_api_version(void)
-{
-	struct sev_user_data_status *status;
-	int error =3D 0, ret;
-
-	status =3D &psp_master->status_cmd_buf;
-	ret =3D sev_platform_status(status, &error);
-	if (ret) {
-		dev_err(psp_master->dev,
-			"SEV: failed to get status. Error: %#x\n", error);
-		return 1;
-	}
-
-	psp_master->api_major =3D status->api_major;
-	psp_master->api_minor =3D status->api_minor;
-	psp_master->build =3D status->build;
-	psp_master->sev_state =3D status->state;
-
-	return 0;
-}
-
-static int sev_get_firmware(struct device *dev,
-			    const struct firmware **firmware)
-{
-	char fw_name_specific[SEV_FW_NAME_SIZE];
-	char fw_name_subset[SEV_FW_NAME_SIZE];
-
-	snprintf(fw_name_specific, sizeof(fw_name_specific),
-		 "amd/amd_sev_fam%.2xh_model%.2xh.sbin",
-		 boot_cpu_data.x86, boot_cpu_data.x86_model);
-
-	snprintf(fw_name_subset, sizeof(fw_name_subset),
-		 "amd/amd_sev_fam%.2xh_model%.1xxh.sbin",
-		 boot_cpu_data.x86, (boot_cpu_data.x86_model & 0xf0) >> 4);
-
-	/* Check for SEV FW for a particular model.
-	 * Ex. amd_sev_fam17h_model00h.sbin for Family 17h Model 00h
-	 *
-	 * or
-	 *
-	 * Check for SEV FW common to a subset of models.
-	 * Ex. amd_sev_fam17h_model0xh.sbin for
-	 *     Family 17h Model 00h -- Family 17h Model 0Fh
-	 *
-	 * or
-	 *
-	 * Fall-back to using generic name: sev.fw
-	 */
-	if ((firmware_request_nowarn(firmware, fw_name_specific, dev) >=3D 0) ||
-	    (firmware_request_nowarn(firmware, fw_name_subset, dev) >=3D 0) ||
-	    (firmware_request_nowarn(firmware, SEV_FW_FILE, dev) >=3D 0))
-		return 0;
-
-	return -ENOENT;
-}
-
-/* Don't fail if SEV FW couldn't be updated. Continue with existing SEV FW=
 */
-static int sev_update_firmware(struct device *dev)
-{
-	struct sev_data_download_firmware *data;
-	const struct firmware *firmware;
-	int ret, error, order;
-	struct page *p;
-	u64 data_size;
-
-	if (sev_get_firmware(dev, &firmware) =3D=3D -ENOENT) {
-		dev_dbg(dev, "No SEV firmware file present\n");
-		return -1;
-	}
-
-	/*
-	 * SEV FW expects the physical address given to it to be 32
-	 * byte aligned. Memory allocated has structure placed at the
-	 * beginning followed by the firmware being passed to the SEV
-	 * FW. Allocate enough memory for data structure + alignment
-	 * padding + SEV FW.
-	 */
-	data_size =3D ALIGN(sizeof(struct sev_data_download_firmware), 32);
-
-	order =3D get_order(firmware->size + data_size);
-	p =3D alloc_pages(GFP_KERNEL, order);
-	if (!p) {
-		ret =3D -1;
-		goto fw_err;
-	}
-
-	/*
-	 * Copy firmware data to a kernel allocated contiguous
-	 * memory region.
-	 */
-	data =3D page_address(p);
-	memcpy(page_address(p) + data_size, firmware->data, firmware->size);
-
-	data->address =3D __psp_pa(page_address(p) + data_size);
-	data->len =3D firmware->size;
-
-	ret =3D sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
-	if (ret)
-		dev_dbg(dev, "Failed to update SEV firmware: %#x\n", error);
-	else
-		dev_info(dev, "SEV firmware update successful\n");
-
-	__free_pages(p, order);
-
-fw_err:
-	release_firmware(firmware);
-
-	return ret;
-}
-
-static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
-{
-	struct sev_user_data_pek_cert_import input;
-	struct sev_data_pek_cert_import *data;
-	void *pek_blob, *oca_blob;
-	int ret;
-
-	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
-		return -EFAULT;
-
-	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	/* copy PEK certificate blobs from userspace */
-	pek_blob =3D psp_copy_user_blob(input.pek_cert_address, input.pek_cert_le=
n);
-	if (IS_ERR(pek_blob)) {
-		ret =3D PTR_ERR(pek_blob);
-		goto e_free;
-	}
-
-	data->pek_cert_address =3D __psp_pa(pek_blob);
-	data->pek_cert_len =3D input.pek_cert_len;
-
-	/* copy PEK certificate blobs from userspace */
-	oca_blob =3D psp_copy_user_blob(input.oca_cert_address, input.oca_cert_le=
n);
-	if (IS_ERR(oca_blob)) {
-		ret =3D PTR_ERR(oca_blob);
-		goto e_free_pek;
-	}
-
-	data->oca_cert_address =3D __psp_pa(oca_blob);
-	data->oca_cert_len =3D input.oca_cert_len;
-
-	/* If platform is not in INIT state then transition it to INIT */
-	if (psp_master->sev_state !=3D SEV_STATE_INIT) {
-		ret =3D __sev_platform_init_locked(&argp->error);
-		if (ret)
-			goto e_free_oca;
-	}
-
-	ret =3D __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
-
-e_free_oca:
-	kfree(oca_blob);
-e_free_pek:
-	kfree(pek_blob);
-e_free:
-	kfree(data);
-	return ret;
-}
-
-static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
-{
-	struct sev_user_data_get_id2 input;
-	struct sev_data_get_id *data;
-	void *id_blob =3D NULL;
-	int ret;
-
-	/* SEV GET_ID is available from SEV API v0.16 and up */
-	if (!sev_version_greater_or_equal(0, 16))
-		return -ENOTSUPP;
-
-	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
-		return -EFAULT;
-
-	/* Check if we have write access to the userspace buffer */
-	if (input.address &&
-	    input.length &&
-	    !access_ok(input.address, input.length))
-		return -EFAULT;
-
-	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	if (input.address && input.length) {
-		id_blob =3D kmalloc(input.length, GFP_KERNEL);
-		if (!id_blob) {
-			kfree(data);
-			return -ENOMEM;
-		}
-
-		data->address =3D __psp_pa(id_blob);
-		data->len =3D input.length;
-	}
-
-	ret =3D __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
-
-	/*
-	 * Firmware will return the length of the ID value (either the minimum
-	 * required length or the actual length written), return it to the user.
-	 */
-	input.length =3D data->len;
-
-	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
-		ret =3D -EFAULT;
-		goto e_free;
-	}
-
-	if (id_blob) {
-		if (copy_to_user((void __user *)input.address,
-				 id_blob, data->len)) {
-			ret =3D -EFAULT;
-			goto e_free;
-		}
-	}
-
-e_free:
-	kfree(id_blob);
-	kfree(data);
-
-	return ret;
-}
-
-static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
-{
-	struct sev_data_get_id *data;
-	u64 data_size, user_size;
-	void *id_blob, *mem;
-	int ret;
-
-	/* SEV GET_ID available from SEV API v0.16 and up */
-	if (!sev_version_greater_or_equal(0, 16))
-		return -ENOTSUPP;
-
-	/* SEV FW expects the buffer it fills with the ID to be
-	 * 8-byte aligned. Memory allocated should be enough to
-	 * hold data structure + alignment padding + memory
-	 * where SEV FW writes the ID.
-	 */
-	data_size =3D ALIGN(sizeof(struct sev_data_get_id), 8);
-	user_size =3D sizeof(struct sev_user_data_get_id);
-
-	mem =3D kzalloc(data_size + user_size, GFP_KERNEL);
-	if (!mem)
-		return -ENOMEM;
-
-	data =3D mem;
-	id_blob =3D mem + data_size;
-
-	data->address =3D __psp_pa(id_blob);
-	data->len =3D user_size;
-
-	ret =3D __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
-	if (!ret) {
-		if (copy_to_user((void __user *)argp->data, id_blob, data->len))
-			ret =3D -EFAULT;
-	}
-
-	kfree(mem);
-
-	return ret;
-}
-
-static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
-{
-	struct sev_user_data_pdh_cert_export input;
-	void *pdh_blob =3D NULL, *cert_blob =3D NULL;
-	struct sev_data_pdh_cert_export *data;
-	int ret;
-
-	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
-		return -EFAULT;
-
-	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	/* Userspace wants to query the certificate length. */
-	if (!input.pdh_cert_address ||
-	    !input.pdh_cert_len ||
-	    !input.cert_chain_address)
-		goto cmd;
-
-	/* Allocate a physically contiguous buffer to store the PDH blob. */
-	if ((input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) ||
-	    !access_ok(input.pdh_cert_address, input.pdh_cert_len)) {
-		ret =3D -EFAULT;
-		goto e_free;
-	}
-
-	/* Allocate a physically contiguous buffer to store the cert chain blob. =
*/
-	if ((input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) ||
-	    !access_ok(input.cert_chain_address, input.cert_chain_len)) {
-		ret =3D -EFAULT;
-		goto e_free;
-	}
-
-	pdh_blob =3D kmalloc(input.pdh_cert_len, GFP_KERNEL);
-	if (!pdh_blob) {
-		ret =3D -ENOMEM;
-		goto e_free;
-	}
-
-	data->pdh_cert_address =3D __psp_pa(pdh_blob);
-	data->pdh_cert_len =3D input.pdh_cert_len;
-
-	cert_blob =3D kmalloc(input.cert_chain_len, GFP_KERNEL);
-	if (!cert_blob) {
-		ret =3D -ENOMEM;
-		goto e_free_pdh;
-	}
-
-	data->cert_chain_address =3D __psp_pa(cert_blob);
-	data->cert_chain_len =3D input.cert_chain_len;
-
-cmd:
-	/* If platform is not in INIT state then transition it to INIT. */
-	if (psp_master->sev_state !=3D SEV_STATE_INIT) {
-		ret =3D __sev_platform_init_locked(&argp->error);
-		if (ret)
-			goto e_free_cert;
-	}
-
-	ret =3D __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
-
-	/* If we query the length, FW responded with expected data. */
-	input.cert_chain_len =3D data->cert_chain_len;
-	input.pdh_cert_len =3D data->pdh_cert_len;
-
-	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
-		ret =3D -EFAULT;
-		goto e_free_cert;
-	}
-
-	if (pdh_blob) {
-		if (copy_to_user((void __user *)input.pdh_cert_address,
-				 pdh_blob, input.pdh_cert_len)) {
-			ret =3D -EFAULT;
-			goto e_free_cert;
-		}
-	}
-
-	if (cert_blob) {
-		if (copy_to_user((void __user *)input.cert_chain_address,
-				 cert_blob, input.cert_chain_len))
-			ret =3D -EFAULT;
-	}
-
-e_free_cert:
-	kfree(cert_blob);
-e_free_pdh:
-	kfree(pdh_blob);
-e_free:
-	kfree(data);
-	return ret;
-}
-
-static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long=
 arg)
-{
-	void __user *argp =3D (void __user *)arg;
-	struct sev_issue_cmd input;
-	int ret =3D -EFAULT;
-
-	if (!psp_master)
-		return -ENODEV;
-
-	if (ioctl !=3D SEV_ISSUE_CMD)
-		return -EINVAL;
-
-	if (copy_from_user(&input, argp, sizeof(struct sev_issue_cmd)))
-		return -EFAULT;
-
-	if (input.cmd > SEV_MAX)
-		return -EINVAL;
-
-	mutex_lock(&sev_cmd_mutex);
-
-	switch (input.cmd) {
-
-	case SEV_FACTORY_RESET:
-		ret =3D sev_ioctl_do_reset(&input);
-		break;
-	case SEV_PLATFORM_STATUS:
-		ret =3D sev_ioctl_do_platform_status(&input);
-		break;
-	case SEV_PEK_GEN:
-		ret =3D sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input);
-		break;
-	case SEV_PDH_GEN:
-		ret =3D sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input);
-		break;
-	case SEV_PEK_CSR:
-		ret =3D sev_ioctl_do_pek_csr(&input);
-		break;
-	case SEV_PEK_CERT_IMPORT:
-		ret =3D sev_ioctl_do_pek_import(&input);
-		break;
-	case SEV_PDH_CERT_EXPORT:
-		ret =3D sev_ioctl_do_pdh_export(&input);
-		break;
-	case SEV_GET_ID:
-		pr_warn_once("SEV_GET_ID command is deprecated, use SEV_GET_ID2\n");
-		ret =3D sev_ioctl_do_get_id(&input);
-		break;
-	case SEV_GET_ID2:
-		ret =3D sev_ioctl_do_get_id2(&input);
-		break;
-	default:
-		ret =3D -EINVAL;
-		goto out;
-	}
-
-	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
-		ret =3D -EFAULT;
-out:
-	mutex_unlock(&sev_cmd_mutex);
-
-	return ret;
-}
-
-static const struct file_operations sev_fops =3D {
-	.owner	=3D THIS_MODULE,
-	.unlocked_ioctl =3D sev_ioctl,
-};
-
-int sev_platform_status(struct sev_user_data_status *data, int *error)
-{
-	return sev_do_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
-}
-EXPORT_SYMBOL_GPL(sev_platform_status);
-
-int sev_guest_deactivate(struct sev_data_deactivate *data, int *error)
-{
-	return sev_do_cmd(SEV_CMD_DEACTIVATE, data, error);
-}
-EXPORT_SYMBOL_GPL(sev_guest_deactivate);
-
-int sev_guest_activate(struct sev_data_activate *data, int *error)
-{
-	return sev_do_cmd(SEV_CMD_ACTIVATE, data, error);
-}
-EXPORT_SYMBOL_GPL(sev_guest_activate);
-
-int sev_guest_decommission(struct sev_data_decommission *data, int *error)
-{
-	return sev_do_cmd(SEV_CMD_DECOMMISSION, data, error);
-}
-EXPORT_SYMBOL_GPL(sev_guest_decommission);
-
-int sev_guest_df_flush(int *error)
-{
-	return sev_do_cmd(SEV_CMD_DF_FLUSH, NULL, error);
-}
-EXPORT_SYMBOL_GPL(sev_guest_df_flush);
-
-static void sev_exit(struct kref *ref)
-{
-	struct sev_misc_dev *misc_dev =3D container_of(ref, struct sev_misc_dev, =
refcount);
-
-	misc_deregister(&misc_dev->misc);
-}
-
-static int sev_misc_init(struct psp_device *psp)
-{
-	struct device *dev =3D psp->dev;
-	int ret;
-
-	/*
-	 * SEV feature support can be detected on multiple devices but the SEV
-	 * FW commands must be issued on the master. During probe, we do not
-	 * know the master hence we create /dev/sev on the first device probe.
-	 * sev_do_cmd() finds the right master device to which to issue the
-	 * command to the firmware.
-	 */
-	if (!misc_dev) {
-		struct miscdevice *misc;
-
-		misc_dev =3D devm_kzalloc(dev, sizeof(*misc_dev), GFP_KERNEL);
-		if (!misc_dev)
-			return -ENOMEM;
-
-		misc =3D &misc_dev->misc;
-		misc->minor =3D MISC_DYNAMIC_MINOR;
-		misc->name =3D DEVICE_NAME;
-		misc->fops =3D &sev_fops;
-
-		ret =3D misc_register(misc);
-		if (ret)
-			return ret;
-
-		kref_init(&misc_dev->refcount);
-	} else {
-		kref_get(&misc_dev->refcount);
-	}
-
-	init_waitqueue_head(&psp->sev_int_queue);
-	psp->sev_misc =3D misc_dev;
-	dev_dbg(dev, "registered SEV device\n");
-
-	return 0;
-}
-
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
-{
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
-
-	psp->vdata =3D (struct psp_vdata *)sp->dev_vdata->psp_vdata;
-	if (!psp->vdata) {
-		ret =3D -ENODEV;
-		dev_err(dev, "missing driver data\n");
-		goto e_err;
-	}
-
-	psp->io_regs =3D sp->io_map;
-
-	ret =3D psp_check_sev_support(psp);
-	if (ret)
-		goto e_disable;
-
-	/* Disable and clear interrupts until ready */
-	iowrite32(0, psp->io_regs + psp->vdata->inten_reg);
-	iowrite32(-1, psp->io_regs + psp->vdata->intsts_reg);
-
-	/* Request an irq */
-	ret =3D sp_request_psp_irq(psp->sp, psp_irq_handler, psp->name, psp);
-	if (ret) {
-		dev_err(dev, "psp: unable to allocate an IRQ\n");
-		goto e_err;
-	}
-
-	ret =3D sev_misc_init(psp);
-	if (ret)
-		goto e_irq;
-
-	if (sp->set_psp_master_device)
-		sp->set_psp_master_device(sp);
-
-	/* Enable interrupt */
-	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
-
-	dev_notice(dev, "psp enabled\n");
-
-	return 0;
-
-e_irq:
-	sp_free_psp_irq(psp->sp, psp);
-e_err:
-	sp->psp_data =3D NULL;
-
-	dev_notice(dev, "psp initialization failed\n");
-
-	return ret;
-
-e_disable:
-	sp->psp_data =3D NULL;
-
-	return ret;
-}
-
-void psp_dev_destroy(struct sp_device *sp)
-{
-	struct psp_device *psp =3D sp->psp_data;
-
-	if (!psp)
-		return;
-
-	if (psp->sev_misc)
-		kref_put(&misc_dev->refcount, sev_exit);
-
-	sp_free_psp_irq(sp, psp);
-}
-
-int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
-				void *data, int *error)
-{
-	if (!filep || filep->f_op !=3D &sev_fops)
-		return -EBADF;
-
-	return  sev_do_cmd(cmd, data, error);
-}
-EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
-
-void psp_pci_init(void)
-{
-	struct sp_device *sp;
-	int error, rc;
-
-	sp =3D sp_get_psp_master_device();
-	if (!sp)
-		return;
-
-	psp_master =3D sp->psp_data;
-
-	psp_timeout =3D psp_probe_timeout;
-
-	if (sev_get_api_version())
-		goto err;
-
-	/*
-	 * If platform is not in UNINIT state then firmware upgrade and/or
-	 * platform INIT command will fail. These command require UNINIT state.
-	 *
-	 * In a normal boot we should never run into case where the firmware
-	 * is not in UNINIT state on boot. But in case of kexec boot, a reboot
-	 * may not go through a typical shutdown sequence and may leave the
-	 * firmware in INIT or WORKING state.
-	 */
-
-	if (psp_master->sev_state !=3D SEV_STATE_UNINIT) {
-		sev_platform_shutdown(NULL);
-		psp_master->sev_state =3D SEV_STATE_UNINIT;
-	}
-
-	if (sev_version_greater_or_equal(0, 15) &&
-	    sev_update_firmware(psp_master->dev) =3D=3D 0)
-		sev_get_api_version();
-
-	/* Initialize the platform */
-	rc =3D sev_platform_init(&error);
-	if (rc) {
-		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
-		return;
-	}
-
-	dev_info(sp->dev, "SEV API:%d.%d build:%d\n", psp_master->api_major,
-		 psp_master->api_minor, psp_master->build);
-
-	return;
-
-err:
-	psp_master =3D NULL;
-}
-
-void psp_pci_exit(void)
-{
-	if (!psp_master)
-		return;
-
-	sev_platform_shutdown(NULL);
-}
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
deleted file mode 100644
index 82a084f..0000000
--- a/drivers/crypto/ccp/psp-dev.h
+++ /dev/null
@@ -1,66 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * AMD Platform Security Processor (PSP) interface driver
- *
- * Copyright (C) 2017-2018 Advanced Micro Devices, Inc.
- *
- * Author: Brijesh Singh <brijesh.singh@amd.com>
- */
-
-#ifndef __PSP_DEV_H__
-#define __PSP_DEV_H__
-
-#include <linux/device.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
-#include <linux/list.h>
-#include <linux/wait.h>
-#include <linux/dmapool.h>
-#include <linux/hw_random.h>
-#include <linux/bitops.h>
-#include <linux/interrupt.h>
-#include <linux/irqreturn.h>
-#include <linux/dmaengine.h>
-#include <linux/psp-sev.h>
-#include <linux/miscdevice.h>
-
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
-
-struct sev_misc_dev {
-	struct kref refcount;
-	struct miscdevice misc;
-};
-
-struct psp_device {
-	struct list_head entry;
-
-	struct psp_vdata *vdata;
-	char name[MAX_PSP_NAME_LEN];
-
-	struct device *dev;
-	struct sp_device *sp;
-
-	void __iomem *io_regs;
-
-	int sev_state;
-	unsigned int sev_int_rcvd;
-	wait_queue_head_t sev_int_queue;
-	struct sev_misc_dev *sev_misc;
-	struct sev_user_data_status status_cmd_buf;
-	struct sev_data_init init_cmd_buf;
-
-	u8 api_major;
-	u8 api_minor;
-	u8 build;
-};
-
-#endif /* __PSP_DEV_H */
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
new file mode 100644
index 0000000..77841a8
--- /dev/null
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -0,0 +1,1087 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Secure Encrypted Virtualization (SEV) interface
+ *
+ * Copyright (C) 2016,2019 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/spinlock_types.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/hw_random.h>
+#include <linux/ccp.h>
+#include <linux/firmware.h>
+
+#include "sp-dev.h"
+#include "sev-dev.h"
+
+#define DEVICE_NAME		"sev"
+#define SEV_FW_FILE		"amd/sev.fw"
+#define SEV_FW_NAME_SIZE	64
+
+static DEFINE_MUTEX(sev_cmd_mutex);
+static struct sev_misc_dev *misc_dev;
+static struct psp_device *psp_master;
+
+static int psp_cmd_timeout =3D 100;
+module_param(psp_cmd_timeout, int, 0644);
+MODULE_PARM_DESC(psp_cmd_timeout, " default timeout value, in seconds, for=
 PSP commands");
+
+static int psp_probe_timeout =3D 5;
+module_param(psp_probe_timeout, int, 0644);
+MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, d=
uring PSP device probe");
+
+static bool psp_dead;
+static int psp_timeout;
+
+static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
+{
+	if (psp_master->api_major > maj)
+		return true;
+	if (psp_master->api_major =3D=3D maj && psp_master->api_minor >=3D min)
+		return true;
+	return false;
+}
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
+	int reg;
+
+	/* Read the interrupt status: */
+	status =3D ioread32(psp->io_regs + psp->vdata->intsts_reg);
+
+	/* Check if it is command completion: */
+	if (!(status & PSP_CMD_COMPLETE))
+		goto done;
+
+	/* Check if it is SEV command completion: */
+	reg =3D ioread32(psp->io_regs + psp->vdata->cmdresp_reg);
+	if (reg & PSP_CMDRESP_RESP) {
+		psp->sev_int_rcvd =3D 1;
+		wake_up(&psp->sev_int_queue);
+	}
+
+done:
+	/* Clear the interrupt status by writing the same value we read. */
+	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
+
+	return IRQ_HANDLED;
+}
+
+static int sev_wait_cmd_ioc(struct psp_device *psp,
+			    unsigned int *reg, unsigned int timeout)
+{
+	int ret;
+
+	ret =3D wait_event_timeout(psp->sev_int_queue,
+			psp->sev_int_rcvd, timeout * HZ);
+	if (!ret)
+		return -ETIMEDOUT;
+
+	*reg =3D ioread32(psp->io_regs + psp->vdata->cmdresp_reg);
+
+	return 0;
+}
+
+static int sev_cmd_buffer_len(int cmd)
+{
+	switch (cmd) {
+	case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
+	case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_user_data_status)=
;
+	case SEV_CMD_PEK_CSR:			return sizeof(struct sev_data_pek_csr);
+	case SEV_CMD_PEK_CERT_IMPORT:		return sizeof(struct sev_data_pek_cert_imp=
ort);
+	case SEV_CMD_PDH_CERT_EXPORT:		return sizeof(struct sev_data_pdh_cert_exp=
ort);
+	case SEV_CMD_LAUNCH_START:		return sizeof(struct sev_data_launch_start);
+	case SEV_CMD_LAUNCH_UPDATE_DATA:	return sizeof(struct sev_data_launch_upd=
ate_data);
+	case SEV_CMD_LAUNCH_UPDATE_VMSA:	return sizeof(struct sev_data_launch_upd=
ate_vmsa);
+	case SEV_CMD_LAUNCH_FINISH:		return sizeof(struct sev_data_launch_finish)=
;
+	case SEV_CMD_LAUNCH_MEASURE:		return sizeof(struct sev_data_launch_measur=
e);
+	case SEV_CMD_ACTIVATE:			return sizeof(struct sev_data_activate);
+	case SEV_CMD_DEACTIVATE:		return sizeof(struct sev_data_deactivate);
+	case SEV_CMD_DECOMMISSION:		return sizeof(struct sev_data_decommission);
+	case SEV_CMD_GUEST_STATUS:		return sizeof(struct sev_data_guest_status);
+	case SEV_CMD_DBG_DECRYPT:		return sizeof(struct sev_data_dbg);
+	case SEV_CMD_DBG_ENCRYPT:		return sizeof(struct sev_data_dbg);
+	case SEV_CMD_SEND_START:		return sizeof(struct sev_data_send_start);
+	case SEV_CMD_SEND_UPDATE_DATA:		return sizeof(struct sev_data_send_update=
_data);
+	case SEV_CMD_SEND_UPDATE_VMSA:		return sizeof(struct sev_data_send_update=
_vmsa);
+	case SEV_CMD_SEND_FINISH:		return sizeof(struct sev_data_send_finish);
+	case SEV_CMD_RECEIVE_START:		return sizeof(struct sev_data_receive_start)=
;
+	case SEV_CMD_RECEIVE_FINISH:		return sizeof(struct sev_data_receive_finis=
h);
+	case SEV_CMD_RECEIVE_UPDATE_DATA:	return sizeof(struct sev_data_receive_u=
pdate_data);
+	case SEV_CMD_RECEIVE_UPDATE_VMSA:	return sizeof(struct sev_data_receive_u=
pdate_vmsa);
+	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_s=
ecret);
+	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_f=
irmware);
+	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
+	default:				return 0;
+	}
+
+	return 0;
+}
+
+static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
+{
+	struct psp_device *psp =3D psp_master;
+	unsigned int phys_lsb, phys_msb;
+	unsigned int reg, ret =3D 0;
+
+	if (!psp)
+		return -ENODEV;
+
+	if (psp_dead)
+		return -EBUSY;
+
+	/* Get the physical address of the command buffer */
+	phys_lsb =3D data ? lower_32_bits(__psp_pa(data)) : 0;
+	phys_msb =3D data ? upper_32_bits(__psp_pa(data)) : 0;
+
+	dev_dbg(psp->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
+		cmd, phys_msb, phys_lsb, psp_timeout);
+
+	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
+			     sev_cmd_buffer_len(cmd), false);
+
+	iowrite32(phys_lsb, psp->io_regs + psp->vdata->cmdbuff_addr_lo_reg);
+	iowrite32(phys_msb, psp->io_regs + psp->vdata->cmdbuff_addr_hi_reg);
+
+	psp->sev_int_rcvd =3D 0;
+
+	reg =3D cmd;
+	reg <<=3D PSP_CMDRESP_CMD_SHIFT;
+	reg |=3D PSP_CMDRESP_IOC;
+	iowrite32(reg, psp->io_regs + psp->vdata->cmdresp_reg);
+
+	/* wait for command completion */
+	ret =3D sev_wait_cmd_ioc(psp, &reg, psp_timeout);
+	if (ret) {
+		if (psp_ret)
+			*psp_ret =3D 0;
+
+		dev_err(psp->dev, "sev command %#x timed out, disabling PSP \n", cmd);
+		psp_dead =3D true;
+
+		return ret;
+	}
+
+	psp_timeout =3D psp_cmd_timeout;
+
+	if (psp_ret)
+		*psp_ret =3D reg & PSP_CMDRESP_ERR_MASK;
+
+	if (reg & PSP_CMDRESP_ERR_MASK) {
+		dev_dbg(psp->dev, "sev command %#x failed (%#010x)\n",
+			cmd, reg & PSP_CMDRESP_ERR_MASK);
+		ret =3D -EIO;
+	}
+
+	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
+			     sev_cmd_buffer_len(cmd), false);
+
+	return ret;
+}
+
+static int sev_do_cmd(int cmd, void *data, int *psp_ret)
+{
+	int rc;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc =3D __sev_do_cmd_locked(cmd, data, psp_ret);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+
+static int __sev_platform_init_locked(int *error)
+{
+	struct psp_device *psp =3D psp_master;
+	int rc =3D 0;
+
+	if (!psp)
+		return -ENODEV;
+
+	if (psp->sev_state =3D=3D SEV_STATE_INIT)
+		return 0;
+
+	rc =3D __sev_do_cmd_locked(SEV_CMD_INIT, &psp->init_cmd_buf, error);
+	if (rc)
+		return rc;
+
+	psp->sev_state =3D SEV_STATE_INIT;
+	dev_dbg(psp->dev, "SEV firmware initialized\n");
+
+	return rc;
+}
+
+int sev_platform_init(int *error)
+{
+	int rc;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc =3D __sev_platform_init_locked(error);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sev_platform_init);
+
+static int __sev_platform_shutdown_locked(int *error)
+{
+	int ret;
+
+	ret =3D __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
+	if (ret)
+		return ret;
+
+	psp_master->sev_state =3D SEV_STATE_UNINIT;
+	dev_dbg(psp_master->dev, "SEV firmware shutdown\n");
+
+	return ret;
+}
+
+static int sev_platform_shutdown(int *error)
+{
+	int rc;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc =3D __sev_platform_shutdown_locked(NULL);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+
+static int sev_get_platform_state(int *state, int *error)
+{
+	int rc;
+
+	rc =3D __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS,
+				 &psp_master->status_cmd_buf, error);
+	if (rc)
+		return rc;
+
+	*state =3D psp_master->status_cmd_buf.state;
+	return rc;
+}
+
+static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
+{
+	int state, rc;
+
+	/*
+	 * The SEV spec requires that FACTORY_RESET must be issued in
+	 * UNINIT state. Before we go further lets check if any guest is
+	 * active.
+	 *
+	 * If FW is in WORKING state then deny the request otherwise issue
+	 * SHUTDOWN command do INIT -> UNINIT before issuing the FACTORY_RESET.
+	 *
+	 */
+	rc =3D sev_get_platform_state(&state, &argp->error);
+	if (rc)
+		return rc;
+
+	if (state =3D=3D SEV_STATE_WORKING)
+		return -EBUSY;
+
+	if (state =3D=3D SEV_STATE_INIT) {
+		rc =3D __sev_platform_shutdown_locked(&argp->error);
+		if (rc)
+			return rc;
+	}
+
+	return __sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, NULL, &argp->error);
+}
+
+static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_status *data =3D &psp_master->status_cmd_buf;
+	int ret;
+
+	ret =3D __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
+	if (ret)
+		return ret;
+
+	if (copy_to_user((void __user *)argp->data, data, sizeof(*data)))
+		ret =3D -EFAULT;
+
+	return ret;
+}
+
+static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
+{
+	int rc;
+
+	if (psp_master->sev_state =3D=3D SEV_STATE_UNINIT) {
+		rc =3D __sev_platform_init_locked(&argp->error);
+		if (rc)
+			return rc;
+	}
+
+	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
+}
+
+static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pek_csr input;
+	struct sev_data_pek_csr *data;
+	void *blob =3D NULL;
+	int ret;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* userspace wants to query CSR length */
+	if (!input.address || !input.length)
+		goto cmd;
+
+	/* allocate a physically contiguous buffer to store the CSR blob */
+	if (!access_ok(input.address, input.length) ||
+	    input.length > SEV_FW_BLOB_MAX_SIZE) {
+		ret =3D -EFAULT;
+		goto e_free;
+	}
+
+	blob =3D kmalloc(input.length, GFP_KERNEL);
+	if (!blob) {
+		ret =3D -ENOMEM;
+		goto e_free;
+	}
+
+	data->address =3D __psp_pa(blob);
+	data->len =3D input.length;
+
+cmd:
+	if (psp_master->sev_state =3D=3D SEV_STATE_UNINIT) {
+		ret =3D __sev_platform_init_locked(&argp->error);
+		if (ret)
+			goto e_free_blob;
+	}
+
+	ret =3D __sev_do_cmd_locked(SEV_CMD_PEK_CSR, data, &argp->error);
+
+	 /* If we query the CSR length, FW responded with expected data. */
+	input.length =3D data->len;
+
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
+		ret =3D -EFAULT;
+		goto e_free_blob;
+	}
+
+	if (blob) {
+		if (copy_to_user((void __user *)input.address, blob, input.length))
+			ret =3D -EFAULT;
+	}
+
+e_free_blob:
+	kfree(blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
+void *psp_copy_user_blob(u64 __user uaddr, u32 len)
+{
+	if (!uaddr || !len)
+		return ERR_PTR(-EINVAL);
+
+	/* verify that blob length does not exceed our limit */
+	if (len > SEV_FW_BLOB_MAX_SIZE)
+		return ERR_PTR(-EINVAL);
+
+	return memdup_user((void __user *)(uintptr_t)uaddr, len);
+}
+EXPORT_SYMBOL_GPL(psp_copy_user_blob);
+
+static int sev_get_api_version(void)
+{
+	struct sev_user_data_status *status;
+	int error =3D 0, ret;
+
+	status =3D &psp_master->status_cmd_buf;
+	ret =3D sev_platform_status(status, &error);
+	if (ret) {
+		dev_err(psp_master->dev,
+			"SEV: failed to get status. Error: %#x\n", error);
+		return 1;
+	}
+
+	psp_master->api_major =3D status->api_major;
+	psp_master->api_minor =3D status->api_minor;
+	psp_master->build =3D status->build;
+	psp_master->sev_state =3D status->state;
+
+	return 0;
+}
+
+static int sev_get_firmware(struct device *dev,
+			    const struct firmware **firmware)
+{
+	char fw_name_specific[SEV_FW_NAME_SIZE];
+	char fw_name_subset[SEV_FW_NAME_SIZE];
+
+	snprintf(fw_name_specific, sizeof(fw_name_specific),
+		 "amd/amd_sev_fam%.2xh_model%.2xh.sbin",
+		 boot_cpu_data.x86, boot_cpu_data.x86_model);
+
+	snprintf(fw_name_subset, sizeof(fw_name_subset),
+		 "amd/amd_sev_fam%.2xh_model%.1xxh.sbin",
+		 boot_cpu_data.x86, (boot_cpu_data.x86_model & 0xf0) >> 4);
+
+	/* Check for SEV FW for a particular model.
+	 * Ex. amd_sev_fam17h_model00h.sbin for Family 17h Model 00h
+	 *
+	 * or
+	 *
+	 * Check for SEV FW common to a subset of models.
+	 * Ex. amd_sev_fam17h_model0xh.sbin for
+	 *     Family 17h Model 00h -- Family 17h Model 0Fh
+	 *
+	 * or
+	 *
+	 * Fall-back to using generic name: sev.fw
+	 */
+	if ((firmware_request_nowarn(firmware, fw_name_specific, dev) >=3D 0) ||
+	    (firmware_request_nowarn(firmware, fw_name_subset, dev) >=3D 0) ||
+	    (firmware_request_nowarn(firmware, SEV_FW_FILE, dev) >=3D 0))
+		return 0;
+
+	return -ENOENT;
+}
+
+/* Don't fail if SEV FW couldn't be updated. Continue with existing SEV FW=
 */
+static int sev_update_firmware(struct device *dev)
+{
+	struct sev_data_download_firmware *data;
+	const struct firmware *firmware;
+	int ret, error, order;
+	struct page *p;
+	u64 data_size;
+
+	if (sev_get_firmware(dev, &firmware) =3D=3D -ENOENT) {
+		dev_dbg(dev, "No SEV firmware file present\n");
+		return -1;
+	}
+
+	/*
+	 * SEV FW expects the physical address given to it to be 32
+	 * byte aligned. Memory allocated has structure placed at the
+	 * beginning followed by the firmware being passed to the SEV
+	 * FW. Allocate enough memory for data structure + alignment
+	 * padding + SEV FW.
+	 */
+	data_size =3D ALIGN(sizeof(struct sev_data_download_firmware), 32);
+
+	order =3D get_order(firmware->size + data_size);
+	p =3D alloc_pages(GFP_KERNEL, order);
+	if (!p) {
+		ret =3D -1;
+		goto fw_err;
+	}
+
+	/*
+	 * Copy firmware data to a kernel allocated contiguous
+	 * memory region.
+	 */
+	data =3D page_address(p);
+	memcpy(page_address(p) + data_size, firmware->data, firmware->size);
+
+	data->address =3D __psp_pa(page_address(p) + data_size);
+	data->len =3D firmware->size;
+
+	ret =3D sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
+	if (ret)
+		dev_dbg(dev, "Failed to update SEV firmware: %#x\n", error);
+	else
+		dev_info(dev, "SEV firmware update successful\n");
+
+	__free_pages(p, order);
+
+fw_err:
+	release_firmware(firmware);
+
+	return ret;
+}
+
+static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pek_cert_import input;
+	struct sev_data_pek_cert_import *data;
+	void *pek_blob, *oca_blob;
+	int ret;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* copy PEK certificate blobs from userspace */
+	pek_blob =3D psp_copy_user_blob(input.pek_cert_address, input.pek_cert_le=
n);
+	if (IS_ERR(pek_blob)) {
+		ret =3D PTR_ERR(pek_blob);
+		goto e_free;
+	}
+
+	data->pek_cert_address =3D __psp_pa(pek_blob);
+	data->pek_cert_len =3D input.pek_cert_len;
+
+	/* copy PEK certificate blobs from userspace */
+	oca_blob =3D psp_copy_user_blob(input.oca_cert_address, input.oca_cert_le=
n);
+	if (IS_ERR(oca_blob)) {
+		ret =3D PTR_ERR(oca_blob);
+		goto e_free_pek;
+	}
+
+	data->oca_cert_address =3D __psp_pa(oca_blob);
+	data->oca_cert_len =3D input.oca_cert_len;
+
+	/* If platform is not in INIT state then transition it to INIT */
+	if (psp_master->sev_state !=3D SEV_STATE_INIT) {
+		ret =3D __sev_platform_init_locked(&argp->error);
+		if (ret)
+			goto e_free_oca;
+	}
+
+	ret =3D __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
+
+e_free_oca:
+	kfree(oca_blob);
+e_free_pek:
+	kfree(pek_blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
+static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_get_id2 input;
+	struct sev_data_get_id *data;
+	void *id_blob =3D NULL;
+	int ret;
+
+	/* SEV GET_ID is available from SEV API v0.16 and up */
+	if (!sev_version_greater_or_equal(0, 16))
+		return -ENOTSUPP;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	/* Check if we have write access to the userspace buffer */
+	if (input.address &&
+	    input.length &&
+	    !access_ok(input.address, input.length))
+		return -EFAULT;
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (input.address && input.length) {
+		id_blob =3D kmalloc(input.length, GFP_KERNEL);
+		if (!id_blob) {
+			kfree(data);
+			return -ENOMEM;
+		}
+
+		data->address =3D __psp_pa(id_blob);
+		data->len =3D input.length;
+	}
+
+	ret =3D __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
+
+	/*
+	 * Firmware will return the length of the ID value (either the minimum
+	 * required length or the actual length written), return it to the user.
+	 */
+	input.length =3D data->len;
+
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
+		ret =3D -EFAULT;
+		goto e_free;
+	}
+
+	if (id_blob) {
+		if (copy_to_user((void __user *)input.address,
+				 id_blob, data->len)) {
+			ret =3D -EFAULT;
+			goto e_free;
+		}
+	}
+
+e_free:
+	kfree(id_blob);
+	kfree(data);
+
+	return ret;
+}
+
+static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
+{
+	struct sev_data_get_id *data;
+	u64 data_size, user_size;
+	void *id_blob, *mem;
+	int ret;
+
+	/* SEV GET_ID available from SEV API v0.16 and up */
+	if (!sev_version_greater_or_equal(0, 16))
+		return -ENOTSUPP;
+
+	/* SEV FW expects the buffer it fills with the ID to be
+	 * 8-byte aligned. Memory allocated should be enough to
+	 * hold data structure + alignment padding + memory
+	 * where SEV FW writes the ID.
+	 */
+	data_size =3D ALIGN(sizeof(struct sev_data_get_id), 8);
+	user_size =3D sizeof(struct sev_user_data_get_id);
+
+	mem =3D kzalloc(data_size + user_size, GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+
+	data =3D mem;
+	id_blob =3D mem + data_size;
+
+	data->address =3D __psp_pa(id_blob);
+	data->len =3D user_size;
+
+	ret =3D __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
+	if (!ret) {
+		if (copy_to_user((void __user *)argp->data, id_blob, data->len))
+			ret =3D -EFAULT;
+	}
+
+	kfree(mem);
+
+	return ret;
+}
+
+static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pdh_cert_export input;
+	void *pdh_blob =3D NULL, *cert_blob =3D NULL;
+	struct sev_data_pdh_cert_export *data;
+	int ret;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* Userspace wants to query the certificate length. */
+	if (!input.pdh_cert_address ||
+	    !input.pdh_cert_len ||
+	    !input.cert_chain_address)
+		goto cmd;
+
+	/* Allocate a physically contiguous buffer to store the PDH blob. */
+	if ((input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) ||
+	    !access_ok(input.pdh_cert_address, input.pdh_cert_len)) {
+		ret =3D -EFAULT;
+		goto e_free;
+	}
+
+	/* Allocate a physically contiguous buffer to store the cert chain blob. =
*/
+	if ((input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) ||
+	    !access_ok(input.cert_chain_address, input.cert_chain_len)) {
+		ret =3D -EFAULT;
+		goto e_free;
+	}
+
+	pdh_blob =3D kmalloc(input.pdh_cert_len, GFP_KERNEL);
+	if (!pdh_blob) {
+		ret =3D -ENOMEM;
+		goto e_free;
+	}
+
+	data->pdh_cert_address =3D __psp_pa(pdh_blob);
+	data->pdh_cert_len =3D input.pdh_cert_len;
+
+	cert_blob =3D kmalloc(input.cert_chain_len, GFP_KERNEL);
+	if (!cert_blob) {
+		ret =3D -ENOMEM;
+		goto e_free_pdh;
+	}
+
+	data->cert_chain_address =3D __psp_pa(cert_blob);
+	data->cert_chain_len =3D input.cert_chain_len;
+
+cmd:
+	/* If platform is not in INIT state then transition it to INIT. */
+	if (psp_master->sev_state !=3D SEV_STATE_INIT) {
+		ret =3D __sev_platform_init_locked(&argp->error);
+		if (ret)
+			goto e_free_cert;
+	}
+
+	ret =3D __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
+
+	/* If we query the length, FW responded with expected data. */
+	input.cert_chain_len =3D data->cert_chain_len;
+	input.pdh_cert_len =3D data->pdh_cert_len;
+
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
+		ret =3D -EFAULT;
+		goto e_free_cert;
+	}
+
+	if (pdh_blob) {
+		if (copy_to_user((void __user *)input.pdh_cert_address,
+				 pdh_blob, input.pdh_cert_len)) {
+			ret =3D -EFAULT;
+			goto e_free_cert;
+		}
+	}
+
+	if (cert_blob) {
+		if (copy_to_user((void __user *)input.cert_chain_address,
+				 cert_blob, input.cert_chain_len))
+			ret =3D -EFAULT;
+	}
+
+e_free_cert:
+	kfree(cert_blob);
+e_free_pdh:
+	kfree(pdh_blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
+static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long=
 arg)
+{
+	void __user *argp =3D (void __user *)arg;
+	struct sev_issue_cmd input;
+	int ret =3D -EFAULT;
+
+	if (!psp_master)
+		return -ENODEV;
+
+	if (ioctl !=3D SEV_ISSUE_CMD)
+		return -EINVAL;
+
+	if (copy_from_user(&input, argp, sizeof(struct sev_issue_cmd)))
+		return -EFAULT;
+
+	if (input.cmd > SEV_MAX)
+		return -EINVAL;
+
+	mutex_lock(&sev_cmd_mutex);
+
+	switch (input.cmd) {
+
+	case SEV_FACTORY_RESET:
+		ret =3D sev_ioctl_do_reset(&input);
+		break;
+	case SEV_PLATFORM_STATUS:
+		ret =3D sev_ioctl_do_platform_status(&input);
+		break;
+	case SEV_PEK_GEN:
+		ret =3D sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input);
+		break;
+	case SEV_PDH_GEN:
+		ret =3D sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input);
+		break;
+	case SEV_PEK_CSR:
+		ret =3D sev_ioctl_do_pek_csr(&input);
+		break;
+	case SEV_PEK_CERT_IMPORT:
+		ret =3D sev_ioctl_do_pek_import(&input);
+		break;
+	case SEV_PDH_CERT_EXPORT:
+		ret =3D sev_ioctl_do_pdh_export(&input);
+		break;
+	case SEV_GET_ID:
+		pr_warn_once("SEV_GET_ID command is deprecated, use SEV_GET_ID2\n");
+		ret =3D sev_ioctl_do_get_id(&input);
+		break;
+	case SEV_GET_ID2:
+		ret =3D sev_ioctl_do_get_id2(&input);
+		break;
+	default:
+		ret =3D -EINVAL;
+		goto out;
+	}
+
+	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
+		ret =3D -EFAULT;
+out:
+	mutex_unlock(&sev_cmd_mutex);
+
+	return ret;
+}
+
+static const struct file_operations sev_fops =3D {
+	.owner	=3D THIS_MODULE,
+	.unlocked_ioctl =3D sev_ioctl,
+};
+
+int sev_platform_status(struct sev_user_data_status *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_platform_status);
+
+int sev_guest_deactivate(struct sev_data_deactivate *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_DEACTIVATE, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_deactivate);
+
+int sev_guest_activate(struct sev_data_activate *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_ACTIVATE, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_activate);
+
+int sev_guest_decommission(struct sev_data_decommission *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_DECOMMISSION, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_decommission);
+
+int sev_guest_df_flush(int *error)
+{
+	return sev_do_cmd(SEV_CMD_DF_FLUSH, NULL, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_df_flush);
+
+static void sev_exit(struct kref *ref)
+{
+	struct sev_misc_dev *misc_dev =3D container_of(ref, struct sev_misc_dev, =
refcount);
+
+	misc_deregister(&misc_dev->misc);
+}
+
+static int sev_misc_init(struct psp_device *psp)
+{
+	struct device *dev =3D psp->dev;
+	int ret;
+
+	/*
+	 * SEV feature support can be detected on multiple devices but the SEV
+	 * FW commands must be issued on the master. During probe, we do not
+	 * know the master hence we create /dev/sev on the first device probe.
+	 * sev_do_cmd() finds the right master device to which to issue the
+	 * command to the firmware.
+	 */
+	if (!misc_dev) {
+		struct miscdevice *misc;
+
+		misc_dev =3D devm_kzalloc(dev, sizeof(*misc_dev), GFP_KERNEL);
+		if (!misc_dev)
+			return -ENOMEM;
+
+		misc =3D &misc_dev->misc;
+		misc->minor =3D MISC_DYNAMIC_MINOR;
+		misc->name =3D DEVICE_NAME;
+		misc->fops =3D &sev_fops;
+
+		ret =3D misc_register(misc);
+		if (ret)
+			return ret;
+
+		kref_init(&misc_dev->refcount);
+	} else {
+		kref_get(&misc_dev->refcount);
+	}
+
+	init_waitqueue_head(&psp->sev_int_queue);
+	psp->sev_misc =3D misc_dev;
+	dev_dbg(dev, "registered SEV device\n");
+
+	return 0;
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
+	ret =3D sev_misc_init(psp);
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
+	if (psp->sev_misc)
+		kref_put(&misc_dev->refcount, sev_exit);
+
+	sp_free_psp_irq(sp, psp);
+}
+
+int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
+				void *data, int *error)
+{
+	if (!filep || filep->f_op !=3D &sev_fops)
+		return -EBADF;
+
+	return  sev_do_cmd(cmd, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
+
+void psp_pci_init(void)
+{
+	struct sp_device *sp;
+	int error, rc;
+
+	sp =3D sp_get_psp_master_device();
+	if (!sp)
+		return;
+
+	psp_master =3D sp->psp_data;
+
+	psp_timeout =3D psp_probe_timeout;
+
+	if (sev_get_api_version())
+		goto err;
+
+	/*
+	 * If platform is not in UNINIT state then firmware upgrade and/or
+	 * platform INIT command will fail. These command require UNINIT state.
+	 *
+	 * In a normal boot we should never run into case where the firmware
+	 * is not in UNINIT state on boot. But in case of kexec boot, a reboot
+	 * may not go through a typical shutdown sequence and may leave the
+	 * firmware in INIT or WORKING state.
+	 */
+
+	if (psp_master->sev_state !=3D SEV_STATE_UNINIT) {
+		sev_platform_shutdown(NULL);
+		psp_master->sev_state =3D SEV_STATE_UNINIT;
+	}
+
+	if (sev_version_greater_or_equal(0, 15) &&
+	    sev_update_firmware(psp_master->dev) =3D=3D 0)
+		sev_get_api_version();
+
+	/* Initialize the platform */
+	rc =3D sev_platform_init(&error);
+	if (rc) {
+		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
+		return;
+	}
+
+	dev_info(sp->dev, "SEV API:%d.%d build:%d\n", psp_master->api_major,
+		 psp_master->api_minor, psp_master->build);
+
+	return;
+
+err:
+	psp_master =3D NULL;
+}
+
+void psp_pci_exit(void)
+{
+	if (!psp_master)
+		return;
+
+	sev_platform_shutdown(NULL);
+}
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
new file mode 100644
index 0000000..2ca1a01
--- /dev/null
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AMD Secure Encrypted Virtualization (SEV) interface
+ *
+ * Copyright (C) 2017-2019 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#ifndef __SEV_DEV_H__
+#define __SEV_DEV_H__
+
+#include <linux/device.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/dmapool.h>
+#include <linux/hw_random.h>
+#include <linux/bitops.h>
+#include <linux/interrupt.h>
+#include <linux/irqreturn.h>
+#include <linux/dmaengine.h>
+#include <linux/psp-sev.h>
+#include <linux/miscdevice.h>
+
+#include "sp-dev.h"
+
+#define PSP_CMD_COMPLETE		BIT(1)
+
+#define PSP_CMDRESP_CMD_SHIFT		16
+#define PSP_CMDRESP_IOC			BIT(0)
+#define PSP_CMDRESP_RESP		BIT(31)
+#define PSP_CMDRESP_ERR_MASK		0xffff
+
+#define MAX_PSP_NAME_LEN		16
+
+struct sev_misc_dev {
+	struct kref refcount;
+	struct miscdevice misc;
+};
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
+	int sev_state;
+	unsigned int sev_int_rcvd;
+	wait_queue_head_t sev_int_queue;
+	struct sev_misc_dev *sev_misc;
+	struct sev_user_data_status status_cmd_buf;
+	struct sev_data_init init_cmd_buf;
+
+	u8 api_major;
+	u8 api_minor;
+	u8 build;
+};
+
+#endif /* __SEV_DEV_H */
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index b29d2e6..473cf14 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -22,7 +22,7 @@
 #include <linux/ccp.h>

 #include "ccp-dev.h"
-#include "psp-dev.h"
+#include "sev-dev.h"

 #define MSIX_VECTORS			2

--
1.9.1

