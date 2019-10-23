Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37DCCA9EB7
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A22282084B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="jYQSBdtQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404902AbfJWL1r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:27:47 -0400
Received: from mail-eopbgr790071.outbound.protection.outlook.com ([40.107.79.71]:61984
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404968AbfJWL1q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 07:27:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRQugyGpVXWh/QajpAK0G7QR81UZF5bJDL260cAzniQOAcYjdifFEEfSGyE3CQuNLa5b8APkhJTXIzJn9DH9CowAhdQdcCPQSg0vTZAR8WlEpXKr2VxB4NMiN6ehjoGnmaSyF0DAZ+fZUAzjb9eFKjqPHv+VRCrdK3+UdRVqfEmy30LxaEc4a4foAsF8xMRT8CjyXBgTPb6X+YjGK+Nr4TaezE0iRmOEpH/VUrH6Mh+zQvnIuOqXFzad+M+ruuuwVbw54ail/Ub8Rsr1T1/7ObeuWQKpfZENHRFAk2FkC1vSLbNXu520wUk+eSl1jxmpzhdZOFbH736P+xbWu81uGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1M/eyI75T2OlisCTCvyIOJpY294RGR+9yzRj5wT6Xw=;
 b=IbMTHpC+6Fq0j1KE2xdrGHv+XWxW2fcctQJrLnegWb3hh2izowZ2volspMM2ZAbRpRxdkjPJtvRQE5dsX15cg3iUDyfUouI0X/fNNZvuuTORaghddd0BIImBFhAG9n6A3UwFgwzEEb93ENBzjZOibnJl7vgcdoIbqsyFOrw6kCxPpBmERCzfun74OIeiWgpX1DzE116mnHH5ZyScWEHW3Jf4NOR4qJUWbZIEApb7d3hQLOL1KbaCopgmpxVRRXroyTh2M0miiUOtqCX3CDuz4dUgz5iLfS0DLzvCgbDX1AyLUh2SJdP6GOi4j4VtUbSteLg+Wqw8NC9Ns2MVHYqTMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1M/eyI75T2OlisCTCvyIOJpY294RGR+9yzRj5wT6Xw=;
 b=jYQSBdtQcWab88Q0xFsrdoORuyZZFC5+6n4AZez/a3VX/ak+Lw8Yw4HOMNyJyItB0R+gubzkf1HFwIQmW/w5heupVY4nbJwXGD+tlGNynlBpDPjMI4jpA4UwqiqeOUeBSiTpAEoh7Q9oro8QTBeplVa0b/ko4VHdQpNX8WTAI8A=
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1527.namprd12.prod.outlook.com (10.172.66.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 11:27:42 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1%11]) with mapi id 15.20.2387.019; Wed, 23 Oct
 2019 11:27:42 +0000
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
Subject: [RFC PATCH 5/5] crypto: ccp - provide in-kernel API to submit TEE
 commands
Thread-Topic: [RFC PATCH 5/5] crypto: ccp - provide in-kernel API to submit
 TEE commands
Thread-Index: AQHViZTivvZoPE5JgkaXeLCZDP9mXQ==
Date:   Wed, 23 Oct 2019 11:27:42 +0000
Message-ID: <787652d4407eed4553e9ea06840563395b353f1d.1571817675.git.Rijo-john.Thomas@amd.com>
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
x-ms-office365-filtering-correlation-id: f17413b1-16ff-4cb7-299d-08d757ac04c4
x-ms-traffictypediagnostic: CY4PR12MB1527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR12MB1527050EA4390B04FD7AB6CACF6B0@CY4PR12MB1527.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(476003)(81156014)(386003)(6486002)(6506007)(14454004)(446003)(11346002)(26005)(81166006)(305945005)(86362001)(5660300002)(186003)(102836004)(7736002)(50226002)(66946007)(6436002)(478600001)(316002)(6116002)(3846002)(99286004)(6512007)(71190400001)(25786009)(118296001)(71200400001)(8676002)(110136005)(54906003)(2906002)(8936002)(486006)(256004)(14444005)(66476007)(66556008)(64756008)(66066001)(2201001)(52116002)(76176011)(66446008)(36756003)(2501003)(4326008)(134885004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1527;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QEsIA7qQVJtWu7jd7riFEii4NGLF1WyRhieqg/nyknsrl1j85/w5B25iuEGqf80R00nNRkpCHwEDsk9auR1l41j5aSaKfJhgZDA2TR0Pze/iE87hbiCI0FAh3Fpcgchixuv6cLhe/kyvIE5/Ca1pZVIcxl7qfJxAr8+hwvfaCvmI2Up0rYXII3SkCRsjSyehBeGvU2ccLPrT3F98FKT7areDIrl78xAAN1DIFkpriApn5laIxkoE29VfsVjzalLELS7F0Ty+gIS1bV9WmpZ7OcpzRiWIHYpbc1FuX8Rfzv1z35/ddUx/euheU5H18Q4/7N+2TD9X9qRwhlKQJiecZdPoLyYTMbMIKCOyFJ9bV0EP4HX9mZjxW5EiWFmKBosCdEez8EfmCGQGvijnSwZHCr72Mcx1aHbcICNBSMR+UzDSvN5+AcWpaFnojzQ5rs1x
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f17413b1-16ff-4cb7-299d-08d757ac04c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 11:27:42.3949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dCRIq2pCuU+MshiOIK2nFYlw5KPt188zr9sk5h2miqs8ON2ebRlj1mOjEO6eDWwLrDiXrIbGNxKzxwvVh28big==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1527
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend the functionality of AMD Secure Processor (SP) driver by
providing an in-kernel API to submit commands to TEE ring buffer for
processing by Trusted OS running on AMD Secure Processor.

Following TEE commands are supported by Trusted OS:

* TEE_CMD_ID_LOAD_TA : Load Trusted Application (TA) binary into
  TEE environment
* TEE_CMD_ID_UNLOAD_TA : Unload TA binary from TEE environment
* TEE_CMD_ID_OPEN_SESSION : Open session with loaded TA
* TEE_CMD_ID_CLOSE_SESSION : Close session with loaded TA
* TEE_CMD_ID_INVOKE_CMD : Invoke a command with loaded TA
* TEE_CMD_ID_MAP_SHARED_MEM : Map shared memory
* TEE_CMD_ID_UNMAP_SHARED_MEM : Unmap shared memory

Linux AMD-TEE driver will use this API to submit command buffers
for processing in Trusted Execution Environment. The AMD-TEE driver
shall be introduced in a separate patch.

Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
---
 drivers/crypto/ccp/tee-dev.c | 126 +++++++++++++++++++++++++++++++++++++++=
++++
 drivers/crypto/ccp/tee-dev.h |   1 +
 include/linux/psp-tee.h      |  72 +++++++++++++++++++++++++
 3 files changed, 199 insertions(+)
 create mode 100644 include/linux/psp-tee.h

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index b2b0215..d35b439 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/gfp.h>
 #include <linux/psp-sev.h>
+#include <linux/psp-tee.h>

 #include "psp-dev.h"
 #include "tee-dev.h"
@@ -37,6 +38,7 @@ static int tee_alloc_ring(struct psp_tee_device *tee, int=
 ring_size)
 	rb_mgr->ring_start =3D start_addr;
 	rb_mgr->ring_size =3D ring_size;
 	rb_mgr->ring_pa =3D __psp_pa(start_addr);
+	mutex_init(&rb_mgr->mutex);

 	return 0;
 }
@@ -54,6 +56,7 @@ static void tee_free_ring(struct psp_tee_device *tee)
 	rb_mgr->ring_start =3D NULL;
 	rb_mgr->ring_size =3D 0;
 	rb_mgr->ring_pa =3D 0;
+	mutex_destroy(&rb_mgr->mutex);
 }

 static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int time=
out,
@@ -235,3 +238,126 @@ void tee_dev_destroy(struct psp_device *psp)

 	tee_destroy_ring(tee);
 }
+
+static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_=
id,
+			  void *buf, size_t len, struct tee_ring_cmd **resp)
+{
+	struct tee_ring_cmd *cmd;
+	u32 rptr, wptr;
+	int nloop =3D 1000, ret =3D 0;
+
+	*resp =3D NULL;
+
+	mutex_lock(&tee->rb_mgr.mutex);
+
+	wptr =3D tee->rb_mgr.wptr;
+
+	/* Check if ring buffer is full */
+	do {
+		rptr =3D ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
+
+		if (!(wptr + sizeof(struct tee_ring_cmd) =3D=3D rptr))
+			break;
+
+		dev_info(tee->dev, "tee: ring buffer full. rptr =3D %u wptr =3D %u\n",
+			 rptr, wptr);
+
+		/* Wait if ring buffer is full */
+		mutex_unlock(&tee->rb_mgr.mutex);
+		schedule_timeout_interruptible(msecs_to_jiffies(10));
+		mutex_lock(&tee->rb_mgr.mutex);
+
+	} while (--nloop);
+
+	if (!nloop && (wptr + sizeof(struct tee_ring_cmd) =3D=3D rptr)) {
+		dev_err(tee->dev, "tee: ring buffer full. rptr =3D %u wptr =3D %u\n",
+			rptr, wptr);
+		ret =3D -EBUSY;
+		goto unlock;
+	}
+
+	/* Pointer to empty data entry in ring buffer */
+	cmd =3D (struct tee_ring_cmd *)(tee->rb_mgr.ring_start + wptr);
+
+	/* Write command data into ring buffer */
+	cmd->cmd_id =3D cmd_id;
+	cmd->cmd_state =3D TEE_CMD_STATE_INIT;
+	memset(&cmd->buf[0], 0, sizeof(cmd->buf));
+	memcpy(&cmd->buf[0], buf, len);
+
+	/* Update local copy of write pointer */
+	tee->rb_mgr.wptr +=3D sizeof(struct tee_ring_cmd);
+	if (tee->rb_mgr.wptr >=3D tee->rb_mgr.ring_size)
+		tee->rb_mgr.wptr =3D 0;
+
+	/* Trigger interrupt to Trusted OS */
+	iowrite32(tee->rb_mgr.wptr, tee->io_regs + tee->vdata->ring_wptr_reg);
+
+	/* The response is provided by Trusted OS in same
+	 * location as submitted data entry within ring buffer.
+	 */
+	*resp =3D cmd;
+
+unlock:
+	mutex_unlock(&tee->rb_mgr.mutex);
+
+	return ret;
+}
+
+static int tee_wait_cmd_completion(struct psp_tee_device *tee,
+				   struct tee_ring_cmd *resp,
+				   unsigned int timeout)
+{
+	/* ~5ms sleep per loop =3D> nloop =3D timeout * 200 */
+	int nloop =3D timeout * 200;
+
+	while (--nloop) {
+		if (resp->cmd_state =3D=3D TEE_CMD_STATE_COMPLETED)
+			return 0;
+
+		usleep_range(5000, 5100);
+	}
+
+	dev_err(tee->dev, "tee: command 0x%x timed out, disabling PSP\n",
+		resp->cmd_id);
+
+	psp_dead =3D true;
+
+	return -ETIMEDOUT;
+}
+
+int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
+			u32 *status)
+{
+	struct psp_device *psp =3D psp_get_master_device();
+	struct psp_tee_device *tee;
+	struct tee_ring_cmd *resp;
+	int ret;
+
+	if (!buf || !status || !len || len > sizeof(resp->buf))
+		return -EINVAL;
+
+	*status =3D 0;
+
+	if (!psp || !psp->tee_data)
+		return -ENODEV;
+
+	if (psp_dead)
+		return -EBUSY;
+
+	tee =3D psp->tee_data;
+
+	ret =3D tee_submit_cmd(tee, cmd_id, buf, len, &resp);
+	if (ret)
+		return ret;
+
+	ret =3D tee_wait_cmd_completion(tee, resp, TEE_DEFAULT_TIMEOUT);
+	if (ret)
+		return ret;
+
+	memcpy(buf, &resp->buf[0], len);
+	*status =3D resp->status;
+
+	return 0;
+}
+EXPORT_SYMBOL(psp_tee_process_cmd);
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
index 0d51a0a7..42d5021 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -53,6 +53,7 @@ struct tee_init_ring_cmd {
  * @wptr:        index to the last written entry in ring buffer
  */
 struct ring_buf_manager {
+	struct mutex mutex;	/* synchronizes access to ring buffer */
 	void *ring_start;
 	u32 ring_size;
 	phys_addr_t ring_pa;
diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
new file mode 100644
index 0000000..954a7ac
--- /dev/null
+++ b/include/linux/psp-tee.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * AMD Trusted Execution Environment (TEE) interface
+ *
+ * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
+ *
+ * Copyright 2019 Advanced Micro Devices, Inc.
+ *
+ */
+
+#ifndef __PSP_TEE_H_
+#define __PSP_TEE_H_
+
+#include <linux/types.h>
+
+/* This file defines the Trusted Execution Environment (TEE) interface com=
mands
+ * and the API exported by AMD Secure Processor driver to communicate with
+ * AMD-TEE Trusted OS.
+ */
+
+/**
+ * enum tee_cmd_id - TEE Interface Command IDs
+ * @TEE_CMD_ID_LOAD_TA:          Load Trusted Application (TA) binary into
+ *                               TEE environment
+ * @TEE_CMD_ID_UNLOAD_TA:        Unload TA binary from TEE environment
+ * @TEE_CMD_ID_OPEN_SESSION:     Open session with loaded TA
+ * @TEE_CMD_ID_CLOSE_SESSION:    Close session with loaded TA
+ * @TEE_CMD_ID_INVOKE_CMD:       Invoke a command with loaded TA
+ * @TEE_CMD_ID_MAP_SHARED_MEM:   Map shared memory
+ * @TEE_CMD_ID_UNMAP_SHARED_MEM: Unmap shared memory
+ */
+enum tee_cmd_id {
+	TEE_CMD_ID_LOAD_TA =3D 1,
+	TEE_CMD_ID_UNLOAD_TA,
+	TEE_CMD_ID_OPEN_SESSION,
+	TEE_CMD_ID_CLOSE_SESSION,
+	TEE_CMD_ID_INVOKE_CMD,
+	TEE_CMD_ID_MAP_SHARED_MEM,
+	TEE_CMD_ID_UNMAP_SHARED_MEM,
+};
+
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+/**
+ * psp_tee_process_cmd() - Process command in Trusted Execution Environmen=
t
+ * @cmd_id:     TEE command ID (&enum tee_cmd_id)
+ * @buf:        Command buffer for TEE processing. On success, is updated
+ *              with the response
+ * @len:        Length of command buffer in bytes
+ * @status:     On success, holds the TEE command execution status
+ *
+ * This function submits a command to the Trusted OS for processing in the
+ * TEE environment and waits for a response or until the command times out=
.
+ *
+ * Returns:
+ * 0 if TEE successfully processed the command
+ * -%ENODEV    if PSP device not available
+ * -%EINVAL    if invalid input
+ * -%ETIMEDOUT if TEE command timed out
+ * -%EBUSY     if PSP device is not responsive
+ */
+int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
+			u32 *status);
+
+#else /* !CONFIG_CRYPTO_DEV_SP_PSP */
+
+static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
+				      size_t len, u32 *status)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_CRYPTO_DEV_SP_PSP */
+#endif /* __PSP_TEE_H_ */
--
1.9.1

