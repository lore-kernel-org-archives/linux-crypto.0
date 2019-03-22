Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5373BC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 02:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FDF921900
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 02:00:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ChnPKlkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfCVCAl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 22:00:41 -0400
Received: from mail-eopbgr00061.outbound.protection.outlook.com ([40.107.0.61]:26068
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727535AbfCVCAl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 22:00:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEgh6N0imG6rwGltZJIeFksqH71Fqs3/1ZJTDPlINXg=;
 b=ChnPKlkfOnOzZwe96D2tFzqkCj2T9J2BuhFikDs1vO0OHmhiK2b1QSuQdyVeeMSJC7WcpRsOe/zP3MKDqHvGm4HjC2MphCDNdyMDhAbU5ICvxG/2bj/DMufbESPUOsW/N2fINPX+2tQhFtFOWvEGR17JyDlY0xwYH4vnsY5yJzA=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4187.eurprd04.prod.outlook.com (52.135.130.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.16; Fri, 22 Mar 2019 02:00:36 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1730.013; Fri, 22 Mar 2019
 02:00:35 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v3 2/3] crypto: caam/jr -  Removed redundant vars from job
 ring private data
Thread-Topic: [PATCH v3 2/3] crypto: caam/jr -  Removed redundant vars from
 job ring private data
Thread-Index: AQHU4FMKMaY3C179wkGGTbaxpGbLpA==
Date:   Fri, 22 Mar 2019 02:00:35 +0000
Message-ID: <20190322015746.27395-3-vakul.garg@nxp.com>
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
x-ms-office365-filtering-correlation-id: 82511711-7dfe-4559-cb07-08d6ae6a2c8a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4187;
x-ms-traffictypediagnostic: DB7PR04MB4187:
x-microsoft-antispam-prvs: <DB7PR04MB4187447AF9E51F63CA0F00BA8B430@DB7PR04MB4187.eurprd04.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(446003)(86362001)(6436002)(81156014)(66066001)(97736004)(7736002)(99286004)(71190400001)(6116002)(8676002)(3846002)(4326008)(6486002)(2616005)(2501003)(476003)(81166006)(26005)(71200400001)(102836004)(52116002)(76176011)(486006)(54906003)(386003)(6506007)(316002)(110136005)(305945005)(14444005)(256004)(1076003)(2906002)(6512007)(44832011)(36756003)(25786009)(50226002)(53936002)(11346002)(478600001)(105586002)(106356001)(186003)(68736007)(5660300002)(14454004)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4187;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xrn04bvj5nMPzknlVF7SWxjqgbRUtIsg1eV6ZsIxH5d1T1QuzFEJzq2fgoDSKje+FA+ZYSrtWj7AOUDJHDxWWQ+K9EtJo7qcV5QEmT0Savphb87G52NkthbZIslYSeO4OZw8p+YiGPUfkiZj4lvY7h1xBLP3llBL4kipIrVRhLYMA94aPQcEWfMbQPD8+G0QTAYG82b0phVMJSrNmiyjpUjGfuJutKM/JfrnrCM8suIfQfyPiYQBqQ8Q/mKZPet+3dH8r+Zztf9LhTX2OqGJ8qJzJrCOZftUyJ3hMMw+mKrokRJrXFG5/4nPne0hwuJZ2TfEIeO/Xj1pBOp7SyeWSoWj55hOvipvP3I2olM5XPisbZje2AAoVvMCnfNe/skiu/hCHHYN7QQwTg/1gVAy6P6vAjWo+cdow5vWqQASMAE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82511711-7dfe-4559-cb07-08d6ae6a2c8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 02:00:35.9045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4187
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For each job ring, the variable 'ringsize' is initialised but never
used. Similarly variables 'inp_ring_write_index' and 'head' always track
the same value and instead of 'inp_ring_write_index', caam_jr_enqueue()
can use 'head' itself. Both these variables have been removed.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---
v2->v3:
Replaced inp_ring_read_index with inp_ring_write_index in commit msg.

 drivers/crypto/caam/intern.h | 2 --
 drivers/crypto/caam/jr.c     | 6 +-----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 48d62e020599..3392615dc91b 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -49,10 +49,8 @@ struct caam_drv_private_jr {
 	atomic_t tfm_count ____cacheline_aligned;
=20
 	/* Job ring info */
-	int ringsize;	/* Size of rings (assume input =3D output) */
 	struct caam_jrentry_info *entinfo;	/* Alloc'ed 1 per ring entry */
 	spinlock_t inplock ____cacheline_aligned; /* Input ring index lock */
-	int inp_ring_write_index;	/* Input index "tail" */
 	u32 inpring_avail;	/* Number of free entries in input ring */
 	int head;			/* entinfo (s/w ring) head index */
 	dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index d1021026f5b2..e95f82778fa1 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -358,7 +358,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	head_entry->cbkarg =3D areq;
 	head_entry->desc_addr_dma =3D desc_dma;
=20
-	jrp->inpring[jrp->inp_ring_write_index] =3D cpu_to_caam_dma(desc_dma);
+	jrp->inpring[head] =3D cpu_to_caam_dma(desc_dma);
=20
 	/*
 	 * Guarantee that the descriptor's DMA address has been written to
@@ -367,8 +367,6 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	 */
 	smp_wmb();
=20
-	jrp->inp_ring_write_index =3D (jrp->inp_ring_write_index + 1) &
-				    (JOBR_DEPTH - 1);
 	jrp->head =3D (head + 1) & (JOBR_DEPTH - 1);
=20
 	/*
@@ -434,7 +432,6 @@ static int caam_jr_init(struct device *dev)
 		jrp->entinfo[i].desc_addr_dma =3D !0;
=20
 	/* Setup rings */
-	jrp->inp_ring_write_index =3D 0;
 	jrp->out_ring_read_index =3D 0;
 	jrp->head =3D 0;
 	jrp->tail =3D 0;
@@ -444,7 +441,6 @@ static int caam_jr_init(struct device *dev)
 	wr_reg32(&jrp->rregs->inpring_size, JOBR_DEPTH);
 	wr_reg32(&jrp->rregs->outring_size, JOBR_DEPTH);
=20
-	jrp->ringsize =3D JOBR_DEPTH;
 	jrp->inpring_avail =3D JOBR_DEPTH;
=20
 	spin_lock_init(&jrp->inplock);
--=20
2.13.6

