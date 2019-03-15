Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9C8C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 11:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB8E221872
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 11:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="sKNMut3f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfCOLZ1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 07:25:27 -0400
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:49846
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726785AbfCOLZ0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 07:25:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yyt8s5XyDG0XUfGrtaMNPtS4EDbc/BqXv2MOgpuC4oQ=;
 b=sKNMut3fVlkM7VuZ+QYLbbAmc7Cpf1hZxH9fZtCqd4jsMR26a2HZzzTGEkqfcCQmMWOt3elL2MidAjqyL9RmQba4xQZ9t/L3BI1k5sppQJ+syQdTn9+Iub5KeGvgE4mquXXrz2HtWTZjG7Lz0/NwpjShpxSsBU+r/973ombyXhk=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4428.eurprd04.prod.outlook.com (52.135.137.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Fri, 15 Mar 2019 11:25:21 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1709.011; Fri, 15 Mar 2019
 11:25:21 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v2 1/3] crypto: caam/jr - Remove spinlock for output job ring
Thread-Topic: [PATCH v2 1/3] crypto: caam/jr - Remove spinlock for output job
 ring
Thread-Index: AQHU2yHG2bCJl1Eqok6nb1aTIie/TQ==
Date:   Fri, 15 Mar 2019 11:25:21 +0000
Message-ID: <20190315112238.24337-2-vakul.garg@nxp.com>
References: <20190315112238.24337-1-vakul.garg@nxp.com>
In-Reply-To: <20190315112238.24337-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:e::28) To DB7PR04MB4252.eurprd04.prod.outlook.com
 (2603:10a6:5:27::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f99a3f97-8f1d-4d29-1d2b-08d6a938e90d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4428;
x-ms-traffictypediagnostic: DB7PR04MB4428:
x-microsoft-antispam-prvs: <DB7PR04MB44285CFFD29291BFB17F284B8B440@DB7PR04MB4428.eurprd04.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(199004)(189003)(6436002)(6486002)(8676002)(316002)(8936002)(81156014)(81166006)(2906002)(50226002)(66066001)(2501003)(86362001)(6512007)(486006)(1076003)(256004)(14444005)(2616005)(14454004)(11346002)(476003)(25786009)(44832011)(71190400001)(71200400001)(99286004)(76176011)(4326008)(36756003)(68736007)(478600001)(105586002)(52116002)(446003)(53936002)(97736004)(186003)(6506007)(54906003)(386003)(110136005)(26005)(102836004)(6116002)(305945005)(7736002)(5660300002)(3846002)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4428;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7s6r6C0pYvPmd8J1udaJmYWo/frHnqSI5Pxt4lxerERZHgEwQQUYOxKGoDIyGt89mjSboJBn0URq0slMtniCiGgImVPWQMJurntQ/ZhbXJSgPc4hGfQQJeSoH1bxP+Vquv24Z9Dj+QdgpQzV3PtGIafrfoqH4t4CKAphPJMoHMebPegI2u4VjJ07I7txiLKMKU4kLmWfDudAhSyOOcJxfPdTBGgAw/DXr2h8E2zjoE7YJ0vJkGp0BrRzSJqY3DZpUvpRxOp57PFO/0tqPF1g1grSFNxkPPMt4Iud/4rb5IEnmxAIm+/n8dCKWapf5yLDMw/Ze5gvVsrxS8iKzwvQ+WGCcJUH+AQqgNtgjQbO6B6PysPK1DRxMm0BvEWmGHAswiWbDWq6Rs7A8+pZSu0wdiS8Kx+8oUaA8bOY2Qc3OmE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f99a3f97-8f1d-4d29-1d2b-08d6a938e90d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 11:25:21.8441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4428
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For each job ring pair, the output ring is processed exactly by one cpu
at a time under a tasklet context (one per ring). Therefore, there is no
need to protect a job ring's access & its private data structure using a
lock. Hence the lock can be removed.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---
Changes since v1:
	- Corrected code comment as per Chris Spencer's suggestion

 drivers/crypto/caam/intern.h | 1 -
 drivers/crypto/caam/jr.c     | 7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 30d5b6c5892f..48d62e020599 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -56,7 +56,6 @@ struct caam_drv_private_jr {
 	u32 inpring_avail;	/* Number of free entries in input ring */
 	int head;			/* entinfo (s/w ring) head index */
 	dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
-	spinlock_t outlock ____cacheline_aligned; /* Output ring index lock */
 	int out_ring_read_index;	/* Output index "tail" */
 	int tail;			/* entinfo (s/w ring) tail index */
 	struct jr_outentry *outring;	/* Base of output ring, DMA-safe */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index b9caa95755d1..d1021026f5b2 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -177,8 +177,6 @@ static void caam_jr_dequeue(unsigned long devarg)
=20
 		head =3D READ_ONCE(jrp->head);
=20
-		spin_lock(&jrp->outlock);
-
 		sw_idx =3D tail =3D jrp->tail;
 		hw_idx =3D jrp->out_ring_read_index;
=20
@@ -201,7 +199,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 		/* mark completed, avoid matching on a recycled desc addr */
 		jrp->entinfo[sw_idx].desc_addr_dma =3D 0;
=20
-		/* Stash callback params for use outside of lock */
+		/* Stash callback params */
 		usercall =3D jrp->entinfo[sw_idx].callbk;
 		userarg =3D jrp->entinfo[sw_idx].cbkarg;
 		userdesc =3D jrp->entinfo[sw_idx].desc_addr_virt;
@@ -234,8 +232,6 @@ static void caam_jr_dequeue(unsigned long devarg)
 			jrp->tail =3D tail;
 		}
=20
-		spin_unlock(&jrp->outlock);
-
 		/* Finally, execute user's callback */
 		usercall(dev, userdesc, userstatus, userarg);
 		outring_used--;
@@ -452,7 +448,6 @@ static int caam_jr_init(struct device *dev)
 	jrp->inpring_avail =3D JOBR_DEPTH;
=20
 	spin_lock_init(&jrp->inplock);
-	spin_lock_init(&jrp->outlock);
=20
 	/* Select interrupt coalescing parameters */
 	clrsetbits_32(&jrp->rregs->rconfig_lo, 0, JOBR_INTC |
--=20
2.13.6

