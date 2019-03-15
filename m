Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD29C4360F
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 822FE2077B
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:05:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="NPBVWQr1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfCOEFZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:05:25 -0400
Received: from mail-eopbgr50078.outbound.protection.outlook.com ([40.107.5.78]:60967
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726462AbfCOEFZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 00:05:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hoxQFvkovbFLnOx+pEOrNNXr3MVtH2gZkYBR3yIDBgY=;
 b=NPBVWQr1XriyJA2oVrA8kIUu+lwaYq9AaA4eUZPV6SvPJuat4S41SPWIvxC5y3TBlM2I8ZTltioCqplOp8WxwO2HUnfx+aBol5LxaXvxuPSZ58Qy3/oZZShCIoX4Ak8siY5Spyk+Zgt5hghM2gz47PCuc6FYqZvlPnQgzx9+Di8=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4716.eurprd04.prod.outlook.com (20.176.233.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Fri, 15 Mar 2019 04:05:22 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1709.011; Fri, 15 Mar 2019
 04:05:22 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH 1/3] crypto: caam/jr - Remove spinlock for output job ring
Thread-Topic: [PATCH 1/3] crypto: caam/jr - Remove spinlock for output job
 ring
Thread-Index: AQHU2uRPul9h7cTAM0qkye+2AiaphQ==
Date:   Fri, 15 Mar 2019 04:05:22 +0000
Message-ID: <20190315040239.24705-2-vakul.garg@nxp.com>
References: <20190315040239.24705-1-vakul.garg@nxp.com>
In-Reply-To: <20190315040239.24705-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::23) To DB7PR04MB4252.eurprd04.prod.outlook.com
 (2603:10a6:5:27::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c40b78c-64db-43fc-1d77-08d6a8fb723c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4716;
x-ms-traffictypediagnostic: DB7PR04MB4716:
x-microsoft-antispam-prvs: <DB7PR04MB4716762B92E2D28E9F3E7E1B8B440@DB7PR04MB4716.eurprd04.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(97736004)(8676002)(105586002)(476003)(36756003)(44832011)(71190400001)(2616005)(52116002)(316002)(386003)(76176011)(4326008)(106356001)(486006)(110136005)(54906003)(71200400001)(102836004)(6506007)(25786009)(81156014)(81166006)(478600001)(7736002)(2906002)(14454004)(66066001)(2501003)(68736007)(14444005)(256004)(1076003)(99286004)(6116002)(53936002)(5660300002)(11346002)(305945005)(86362001)(8936002)(186003)(50226002)(6512007)(6436002)(3846002)(446003)(26005)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4716;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r34/GZ8dyPiaXLkvO6iVtZCzaBqRzg+UAUn3KazX064FBUIVGDKIfQ35WJPXqAwL6Yq/PtE2x9RBknSd+GmYngJmCimnUGOiDBVltjsR0l0fPzbzaqKOjTb6HO1bpYdRXk2m+xri9r03IkWIySnEKMx1oTx6NGVgcQcTQtBpcxoZvFFdlC9VsGuodvs2e5s+9nn4KhJQYQmgkkfsD2xqGPqgSFzat1wka7eYgrgAnRJcZ1v8L2A4fl9R+Mv8bMyEmUxPl1iyVb4YHp9tXm+A6SgH2IXHke05cK+fKo4ajtuLcxsZHEO/zeybw5OZ2PB8MzkR3vfjLExWPu12xWGbeE4CdEAFCIcmT4Z/Thr638DJs6KzcXDcZ74dbGLrTWQ2cA61eA8dP40GZhxzd8YK6NDCZZCRqEMyi7VCTXXdlww=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c40b78c-64db-43fc-1d77-08d6a8fb723c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 04:05:22.9336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4716
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
 drivers/crypto/caam/intern.h | 1 -
 drivers/crypto/caam/jr.c     | 5 -----
 2 files changed, 6 deletions(-)

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
index b9caa95755d1..89de7297d099 100644
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

