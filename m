Return-Path: <SRS0=IjeW=3U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE3AC2D0DB
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jan 2020 14:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 388D120707
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jan 2020 14:16:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="o+nCQbGW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgAaOQC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jan 2020 09:16:02 -0500
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:9378
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728730AbgAaOQC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jan 2020 09:16:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RboftnTD4gkY6DRdlhRw2CUvB7CysPV45Ev4LpN3nHrNx4HTu8ZgpR4HyW59/sU/k3YGRAOlzdUpLNUvLHJJMsLFRLYCSmAT8pFPea/kNPdvQ2FvZMa8yyjiaKyrUcJ8q8hStiMWYGit86UMTsOYflLGhl9NHvW4OLLA0uCZOOTlWP8IERw/MUSBz1kyu7fXJZN+Do2f2ygZXh85XSeCN7dbumEvO6Yna/e9cV2ZdwK1pcBbnSHf5F0+MUlqVE9Zb7SMJUdVvQmKJUPzz9cOtcorIyhwH/S0Oek/VmE2MkNxLBdpYD8eZoB4bOH2sl5R5e7FFN6e7W+k6pKqDzOGAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/c4OTTCI6lGKKCrA0XUvafmIc4kd3nYG+KZbpaV7v8I=;
 b=Hul32XRV5CRZ+Kgn1meQPlw8B6eUqmxl34lblOty6XHZ2AScWAiG1RxdgqDdvhwRWr6aavcz9kWiwNFWD1yUFG7NGVJ+YOnn8qJqy8I6Ts+XR6bRIGICnoi/Z2BZaPV8NFlsKZJsqvpXhGcHmRb1EFGv1x0afrCUgUx7+tU9j4EuhmZBVjRenbkWyL9E3jrt8j46rQhtw/6R6RmbszsxXzKRl99f85juZLb7nQS0hgQsmYdfEhtlUvVzz9VFmY81CjtFPaSh0OHarVRzYyloLIRJcC0eXMu9dzTbJCsxh5t11Jf2zYTjadKDnx1F4jmdt0NJfsJ01URqKe4e2uQpfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/c4OTTCI6lGKKCrA0XUvafmIc4kd3nYG+KZbpaV7v8I=;
 b=o+nCQbGWPVQmFmjXvSoFEgushsyZKlYb9UzeSe2N+D9Hnz53xN0wc8n9hrLqRqQpqSBNGuR0roeoHsaH3HuypOVFbH68u57LsZgsmvEYLSmyMyguAko0s9B/k5dMA8ZU5ZMcQYwbHh2mhSpwa9RrUPC6pMV6UhRpAtyvEnl8puA=
Received: from VI1PR04MB6031.eurprd04.prod.outlook.com (20.179.28.145) by
 VI1PR04MB5328.eurprd04.prod.outlook.com (20.177.50.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.26; Fri, 31 Jan 2020 14:15:56 +0000
Received: from VI1PR04MB6031.eurprd04.prod.outlook.com
 ([fe80::3471:11cb:7be8:d1dc]) by VI1PR04MB6031.eurprd04.prod.outlook.com
 ([fe80::3471:11cb:7be8:d1dc%6]) with mapi id 15.20.2665.027; Fri, 31 Jan 2020
 14:15:56 +0000
Received: from ubuntu16VB.ea.freescale.net (212.146.100.6) by AM5PR0202CA0010.eurprd02.prod.outlook.com (2603:10a6:203:69::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2665.22 via Frontend Transport; Fri, 31 Jan 2020 14:15:55 +0000
From:   Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: caam/qi - optimize frame queue cleanup
Thread-Topic: [PATCH] crypto: caam/qi - optimize frame queue cleanup
Thread-Index: AQHV2ED0kruhWvne9kajdpPmzr8twQ==
Date:   Fri, 31 Jan 2020 14:15:56 +0000
Message-ID: <1580480151-1299-1-git-send-email-valentin.ciocoi@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: AM5PR0202CA0010.eurprd02.prod.outlook.com
 (2603:10a6:203:69::20) To VI1PR04MB6031.eurprd04.prod.outlook.com
 (2603:10a6:803:102::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=valentin.ciocoi@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1df08a81-a1b4-410f-3f78-08d7a6581682
x-ms-traffictypediagnostic: VI1PR04MB5328:|VI1PR04MB5328:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB532863D91C579A3F1F79BBD2FE070@VI1PR04MB5328.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 029976C540
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(189003)(199004)(81166006)(81156014)(316002)(8936002)(2616005)(71200400001)(8676002)(36756003)(64756008)(4326008)(66946007)(66446008)(110136005)(956004)(66556008)(6636002)(66476007)(6506007)(26005)(2906002)(5660300002)(186003)(52116002)(6512007)(16526019)(6486002)(478600001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5328;H:VI1PR04MB6031.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MDRYvc44rmiYqlqJCglQKQRnFKSZLjmDIG98NcuFmfBt1W3lUz9EtL+iSmm6E/RmEx/FTx1GXaoGFHPNTWHb/ju1IDCgt34LFP5SlN0Zex2lF8+/ZrRWjEOa5iq5Eqgee/3PRZ1q5dkHOuSfsJxL8LLmxCbjdnZIpqFg0F7nCr7ZOxCi7irplWuIMuA+HJqMvSSmtFQoVMBEyiQwh9mbycmOfKPVQFi/YoxYUjAIPKrKM6Cg9VzT4+dLwRzswhptk1TCUZbXAzmPSkpk9/yTqwn16xryfUSxW+P2y7nxNZORS1uOo3SyFILEKfvRxXC95VsM7ykF85/viMkR33tTkV+J9Smtd1rD4+LAGBy3OiGz0D7l8Mi0pmk5k0H7QtUA5fiPbJ5p0FVP0KWiK6qYyZ3gPpS37yE8KMeiJRhiL1mZq9htVnNtqeb7T2jaafdH
x-ms-exchange-antispam-messagedata: o4x9Tskr88Pk7IeyW+/PHuBXEjVlzJZrh7yesPnyND5LirgcaETGoZSj5ZJR8Wjpisgpk25dg2m93xECQPTt+eDAWrU7rFvWAlP4LlMSEMeh+t34VbOjXRk6ye1sovpLAe4AQq1GnGXGJFWyDDqcFA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df08a81-a1b4-410f-3f78-08d7a6581682
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2020 14:15:56.2891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AdUgkwhx+Suo48fxVGAFm20ZXevXonGdOrMuoi2bBMZA3IzxM9bk76LjnOxqzVXog2O3a9gthMvuLIn5Ygdnrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5328
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add reference counter incremented for each frame enqueued in CAAM
and replace unconditional sleep in empty_caam_fq() with polling the
reference counter.

When CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy boot time on LS1043A
platform with this optimization decreases from ~1100s to ~11s.

Signed-off-by: Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
---
 drivers/crypto/caam/qi.c | 60 +++++++++++++++++++++++++++++++-------------=
----
 drivers/crypto/caam/qi.h |  4 +++-
 2 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index dacf2fa..b390b93 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -4,7 +4,7 @@
  * Queue Interface backend functionality
  *
  * Copyright 2013-2016 Freescale Semiconductor, Inc.
- * Copyright 2016-2017, 2019 NXP
+ * Copyright 2016-2017, 2019-2020 NXP
  */
=20
 #include <linux/cpumask.h>
@@ -124,8 +124,10 @@ int caam_qi_enqueue(struct device *qidev, struct caam_=
drv_req *req)
=20
 	do {
 		ret =3D qman_enqueue(req->drv_ctx->req_fq, &fd);
-		if (likely(!ret))
+		if (likely(!ret)) {
+			refcount_inc(&req->drv_ctx->refcnt);
 			return 0;
+		}
=20
 		if (ret !=3D -EBUSY)
 			break;
@@ -148,11 +150,6 @@ static void caam_fq_ern_cb(struct qman_portal *qm, str=
uct qman_fq *fq,
=20
 	fd =3D &msg->ern.fd;
=20
-	if (qm_fd_get_format(fd) !=3D qm_fd_compound) {
-		dev_err(qidev, "Non-compound FD from CAAM\n");
-		return;
-	}
-
 	drv_req =3D caam_iova_to_virt(priv->domain, qm_fd_addr_get64(fd));
 	if (!drv_req) {
 		dev_err(qidev,
@@ -160,6 +157,13 @@ static void caam_fq_ern_cb(struct qman_portal *qm, str=
uct qman_fq *fq,
 		return;
 	}
=20
+	refcount_dec(&drv_req->drv_ctx->refcnt);
+
+	if (qm_fd_get_format(fd) !=3D qm_fd_compound) {
+		dev_err(qidev, "Non-compound FD from CAAM\n");
+		return;
+	}
+
 	dma_unmap_single(drv_req->drv_ctx->qidev, qm_fd_addr(fd),
 			 sizeof(drv_req->fd_sgt), DMA_BIDIRECTIONAL);
=20
@@ -287,9 +291,10 @@ static int kill_fq(struct device *qidev, struct qman_f=
q *fq)
 	return ret;
 }
=20
-static int empty_caam_fq(struct qman_fq *fq)
+static int empty_caam_fq(struct qman_fq *fq, struct caam_drv_ctx *drv_ctx)
 {
 	int ret;
+	int retries =3D 10;
 	struct qm_mcr_queryfq_np np;
=20
 	/* Wait till the older CAAM FQ get empty */
@@ -304,11 +309,18 @@ static int empty_caam_fq(struct qman_fq *fq)
 		msleep(20);
 	} while (1);
=20
-	/*
-	 * Give extra time for pending jobs from this FQ in holding tanks
-	 * to get processed
-	 */
-	msleep(20);
+	/* Wait until pending jobs from this FQ are processed by CAAM */
+	do {
+		if (refcount_read(&drv_ctx->refcnt) =3D=3D 1)
+			break;
+
+		msleep(20);
+	} while (--retries);
+
+	if (!retries)
+		dev_warn_once(drv_ctx->qidev, "%d frames from FQID %u still pending in C=
AAM\n",
+			      refcount_read(&drv_ctx->refcnt), fq->fqid);
+
 	return 0;
 }
=20
@@ -340,7 +352,7 @@ int caam_drv_ctx_update(struct caam_drv_ctx *drv_ctx, u=
32 *sh_desc)
 	drv_ctx->req_fq =3D new_fq;
=20
 	/* Empty and remove the older FQ */
-	ret =3D empty_caam_fq(old_fq);
+	ret =3D empty_caam_fq(old_fq, drv_ctx);
 	if (ret) {
 		dev_err(qidev, "Old CAAM FQ empty failed: %d\n", ret);
=20
@@ -453,6 +465,9 @@ struct caam_drv_ctx *caam_drv_ctx_init(struct device *q=
idev,
 		return ERR_PTR(-ENOMEM);
 	}
=20
+	/* init reference counter used to track references to request FQ */
+	refcount_set(&drv_ctx->refcnt, 1);
+
 	drv_ctx->qidev =3D qidev;
 	return drv_ctx;
 }
@@ -571,6 +586,16 @@ static enum qman_cb_dqrr_result caam_rsp_fq_dqrr_cb(st=
ruct qman_portal *p,
 		return qman_cb_dqrr_stop;
=20
 	fd =3D &dqrr->fd;
+
+	drv_req =3D caam_iova_to_virt(priv->domain, qm_fd_addr_get64(fd));
+	if (unlikely(!drv_req)) {
+		dev_err(qidev,
+			"Can't find original request for caam response\n");
+		return qman_cb_dqrr_consume;
+	}
+
+	refcount_dec(&drv_req->drv_ctx->refcnt);
+
 	status =3D be32_to_cpu(fd->status);
 	if (unlikely(status)) {
 		u32 ssrc =3D status & JRSTA_SSRC_MASK;
@@ -588,13 +613,6 @@ static enum qman_cb_dqrr_result caam_rsp_fq_dqrr_cb(st=
ruct qman_portal *p,
 		return qman_cb_dqrr_consume;
 	}
=20
-	drv_req =3D caam_iova_to_virt(priv->domain, qm_fd_addr_get64(fd));
-	if (unlikely(!drv_req)) {
-		dev_err(qidev,
-			"Can't find original request for caam response\n");
-		return qman_cb_dqrr_consume;
-	}
-
 	dma_unmap_single(drv_req->drv_ctx->qidev, qm_fd_addr(fd),
 			 sizeof(drv_req->fd_sgt), DMA_BIDIRECTIONAL);
=20
diff --git a/drivers/crypto/caam/qi.h b/drivers/crypto/caam/qi.h
index 8489589..5894f16 100644
--- a/drivers/crypto/caam/qi.h
+++ b/drivers/crypto/caam/qi.h
@@ -3,7 +3,7 @@
  * Public definitions for the CAAM/QI (Queue Interface) backend.
  *
  * Copyright 2013-2016 Freescale Semiconductor, Inc.
- * Copyright 2016-2017 NXP
+ * Copyright 2016-2017, 2020 NXP
  */
=20
 #ifndef __QI_H__
@@ -52,6 +52,7 @@ enum optype {
  * @context_a: shared descriptor dma address
  * @req_fq: to-CAAM request frame queue
  * @rsp_fq: from-CAAM response frame queue
+ * @refcnt: reference counter incremented for each frame enqueued in to-CA=
AM FQ
  * @cpu: cpu on which to receive CAAM response
  * @op_type: operation type
  * @qidev: device pointer for CAAM/QI backend
@@ -62,6 +63,7 @@ struct caam_drv_ctx {
 	dma_addr_t context_a;
 	struct qman_fq *req_fq;
 	struct qman_fq *rsp_fq;
+	refcount_t refcnt;
 	int cpu;
 	enum optype op_type;
 	struct device *qidev;
--=20
2.7.4

