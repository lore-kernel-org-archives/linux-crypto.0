Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10600C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 02:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D264D218FE
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 02:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="PZu4dAXg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfCVCAj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 22:00:39 -0400
Received: from mail-eopbgr00061.outbound.protection.outlook.com ([40.107.0.61]:26068
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727634AbfCVCAj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 22:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XeHvvTjNsQRiwI7QWu+EFcUTDtW1FlqgCfi+0DngwBQ=;
 b=PZu4dAXgpExLyj50hOObZI6ewtxqJl0QNkzRY2W8kF2+LB3xuQpZQUVPklHJ1kbrDDMc7+jwXccGZxWKblV1OlB7bv95NJ8qCjRpthV5idZ/2DavUUVTSQwnJKfq3Xe+YL7JgjDdXP9aDVtw3oSSasdHCr3uQbX1+sM7IUOzKqE=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4187.eurprd04.prod.outlook.com (52.135.130.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.16; Fri, 22 Mar 2019 02:00:34 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1730.013; Fri, 22 Mar 2019
 02:00:34 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v3 1/3] crypto: caam/jr - Remove spinlock for output job ring
Thread-Topic: [PATCH v3 1/3] crypto: caam/jr - Remove spinlock for output job
 ring
Thread-Index: AQHU4FMJAfwFsHaPUEaSteo3gNdsOw==
Date:   Fri, 22 Mar 2019 02:00:34 +0000
Message-ID: <20190322015746.27395-2-vakul.garg@nxp.com>
References: <20190322015746.27395-1-vakul.garg@nxp.com>
In-Reply-To: <20190322015746.27395-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0113.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::29)
 To DB7PR04MB4252.eurprd04.prod.outlook.com (2603:10a6:5:27::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64dab7c6-ef65-43c0-f91c-08d6ae6a2ba6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4187;
x-ms-traffictypediagnostic: DB7PR04MB4187:
x-microsoft-antispam-prvs: <DB7PR04MB4187831FA17A32241FA7B1CF8B430@DB7PR04MB4187.eurprd04.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(446003)(86362001)(6436002)(81156014)(66066001)(97736004)(7736002)(99286004)(71190400001)(6116002)(8676002)(3846002)(4326008)(6486002)(2616005)(2501003)(476003)(81166006)(26005)(71200400001)(102836004)(52116002)(76176011)(486006)(54906003)(386003)(6506007)(316002)(110136005)(305945005)(14444005)(256004)(1076003)(2906002)(6512007)(44832011)(36756003)(25786009)(50226002)(53936002)(11346002)(478600001)(105586002)(106356001)(186003)(68736007)(5660300002)(14454004)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4187;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7+98KMY6+KBnrjMSVc6qkwiScP7WGucfM6tB9+PM2w40fGTUQ3SFGLelOXpz/Ni4bHiRSgUzOy/fqfzd9iCNI1U+WzyFWFIVKvsGeERX7BIqSJ1umbnm5/IMoRHxyx7EBZCgZWxLqkgnIzGX8F8/oXnFIVVXt99qbG1Iw4ki/yvDD2F+Y8nXETRJLaK9zb24/L/LO+Gm6lbEGxi7QnR2puQM97/fcMvwktK6zY+hK1ZDxxuXuM9+poBY6fJmsfyjOdcMaU3f84u0Go5AhzNLy2+cEnh2VbOsHhsrqdJbowte6qmQM3JuSaoOJm+pD2TQy/YctXBl7kpFSz4HySYzBR0pQhddctCPuF5st8itn/2PItIlzUQSYisRcM2WPK7F8lRHO4qiWrqxHT40HycGo0RaI0vipG9nAkwwNWAuRdI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64dab7c6-ef65-43c0-f91c-08d6ae6a2ba6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 02:00:34.3714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4187
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For each job ring pair, the output ring is processed exactly by one cpu
at a time under a tasklet context (one per ring). Therefore, there is no
need to protect a job ring's access & its private data structure using a
lock. Hence the lock can be removed.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
---
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

