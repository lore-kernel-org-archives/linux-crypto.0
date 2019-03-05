Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3A4C43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 17:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2851120842
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 17:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="MXI5XYHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbfCERuH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:50:07 -0500
Received: from mail-eopbgr140059.outbound.protection.outlook.com ([40.107.14.59]:60948
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730498AbfCERuG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 12:50:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7QpO/zaFVBSZF6d5lKSv+M1Bn3thdbFqFV4ejCgaHI=;
 b=MXI5XYHaXRCGDyQS7Oyve33S6UAz3EuadxTe5pD/mRYYLA38FOZQ2Nuj3f0opLDLhEed3guMK1KaZ61S/ontmEnbtBowhH/dggwKDVO7CkypORYd0uwhOSnBeCs9XmpcmbHXLFI8Rqvj351M0iT7UNQAk9NP1tVFolGPaRPBtIc=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4844.eurprd04.prod.outlook.com (20.176.233.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.18; Tue, 5 Mar 2019 17:49:23 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1643.019; Tue, 5 Mar 2019
 17:49:23 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v2] crypto: caam/jr - optimize job ring enqueue and dequeue
 operations
Thread-Topic: [PATCH v2] crypto: caam/jr - optimize job ring enqueue and
 dequeue operations
Thread-Index: AQHU03vEQbbgqu3gO0yrlyQvtwqCFA==
Date:   Tue, 5 Mar 2019 17:49:23 +0000
Message-ID: <20190305174648.8485-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BM1PR0101CA0014.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:18::24) To DB7PR04MB4252.eurprd04.prod.outlook.com
 (2603:10a6:5:27::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a252f4f4-d54c-4c4b-74f3-08d6a192e6d9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4844;
x-ms-traffictypediagnostic: DB7PR04MB4844:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;DB7PR04MB4844;23:HfC6rybcatc35gvqyJPYG+HWZiwpP1P629UGBLF?=
 =?iso-8859-1?Q?JZnEUL8QZ3Kgaj1IWYAKWND5QAWpOpyxWwsKo+CEV/5DljbE6JI8BnPJg7?=
 =?iso-8859-1?Q?0p8hkFMbhCdq+6LtU1hm1ad2/VmIhTRj5010ubT/SUs/nWhcNFYAmFcrgF?=
 =?iso-8859-1?Q?uu+eQjuRPiwSV2fdwGcQ8z222TEzeDPd8BLDZ6pSkcg27zJ0iuHlUp1wgq?=
 =?iso-8859-1?Q?/gfLlim9GzKGz1/3aqkHSF6sqvQgW4stKT2p5qdb2pVUXhRLeG2XjnzKlT?=
 =?iso-8859-1?Q?9cl0nbJZE8fV5rAutp9gQWMftfIMddySY8QO4cTYK+Uz2C2uuW5V2GXgzg?=
 =?iso-8859-1?Q?PnefKMgUQKvhcxgkx0OCOobuBAPy+WxujY0z6Ut3+gPb6dgQBvLloPCyYp?=
 =?iso-8859-1?Q?UdUATNMmwlzNYS3HxpNc5g2U2R9bdkYP2+M6qmWPvTFbiGhvT0lqGJjlmN?=
 =?iso-8859-1?Q?/TpfZXfK9LhxulXjkdCMyD1NEzvEca5kslGsxW6x32cxQ6LL2nXc3V5Trv?=
 =?iso-8859-1?Q?wFpwnxNM6hSZ5UYJavw+RuiSUyqBGzuiTKKslnEUnLx4E1Cj4zQ8CoDmKA?=
 =?iso-8859-1?Q?oBi2R2TlVsRjbI/kcCNoAbrFgRQwDSwzrvrsQ62Yofxhlo5ILmTyoWMs0B?=
 =?iso-8859-1?Q?4z7GyABbpveo5JgxQfSWV3Sf0FQripY1tTdVdICW/Ik3pNDoM+JTpWBr8M?=
 =?iso-8859-1?Q?X0ucqrMkSuAWdnqafM3e/gCeuyKZSxSva/g3qbi6+whEwVjjuZYGe/HD8m?=
 =?iso-8859-1?Q?pFHAKy3nSd6npsZulUbjU9ygvljd6KzHO20DTdUIAerjHgXoF11ce9j+Wl?=
 =?iso-8859-1?Q?qWESi/VAE5B08KdE+pdEx0/4MvfxO0u1qf9Za0cibTxF2JxZWJJJYgdSyN?=
 =?iso-8859-1?Q?c8t+HvFenpkLj+1nGlSIdTkrjZGnNRY1qYeQ3CQwTzKmYopXDpxkLMraMo?=
 =?iso-8859-1?Q?Rt1UsRZRtZbG65NEVYjEK2TCZGOzNvjriVGwgcJjuYv1a7xaWoFfSmPEMx?=
 =?iso-8859-1?Q?DtuIAUOd/KMkPVQ7AwhYIn6xWEyWIBZYheIskd6251TyL1YpyQ9AMYLAyy?=
 =?iso-8859-1?Q?TEEc4ekmNF157/evB7CxWFD1tOxjWqP4GHgNgTpMQ76H5lHAgz/zdnB2A7?=
 =?iso-8859-1?Q?CfHpN8c/AHIcAkX/Rj+q3v6yQbPaz7km/+uEp2aVjTAH/Du9Y3dt++QZp2?=
 =?iso-8859-1?Q?eKs+ucSO1RnrQnG9rPLiChVT+Qn51n1YF+GEi2HF4x9sFBpPoEJJSYKNFQ?=
 =?iso-8859-1?Q?QBjgaPeaZeoNvNcVVl97iCMdVkA6LOLCNntF5VuuUroD32yMgGyLgZFwZP?=
 =?iso-8859-1?Q?nU=3D?=
x-microsoft-antispam-prvs: <DB7PR04MB4844788DEF8B0CB69AE865338B720@DB7PR04MB4844.eurprd04.prod.outlook.com>
x-forefront-prvs: 0967749BC1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(39860400002)(136003)(396003)(189003)(199004)(6512007)(25786009)(52116002)(53936002)(8936002)(81156014)(7736002)(81166006)(476003)(86362001)(71190400001)(36756003)(5660300002)(186003)(71200400001)(54906003)(1076003)(44832011)(102836004)(2501003)(386003)(486006)(2616005)(316002)(99286004)(6506007)(26005)(50226002)(305945005)(478600001)(66066001)(97736004)(14454004)(6116002)(6916009)(5640700003)(68736007)(6486002)(4326008)(8676002)(6436002)(14444005)(256004)(2906002)(3846002)(106356001)(105586002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4844;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nzkHLrME9SWnAMafBf2gNIE4ldj3j9fOLEXGB4hK8G9fybsy1Fo4rN0IOQy5TuskbQPyAnL/EK9FQzvTtxvcp8C8/7VK9Ezuapycx+//ssJiBgBGLLlO0cFA3B/K0dxmIVDzNO65HwkpvUHCK/BUJMHLdfAEAaqNZI2hr8jvQVLfo+p+gW6VWysmGBXRZt1nNajVJKiHR5YvFvvm1ruys03SKiqv6CDEMXWcxjUer7CVAlU9L9yH/xkpYMsOPPa20CXn3arCwknKq9l3gLwCsriMOshqk038BOWzLjIy5IuNl+0bjBpExHFGq+Xj1/l9U80DGvgRL2Lu2uJMfO9Q0+bVdpo3WujKS/rqryyS14rW3KpCA7KQFxGU+MkTDz/q7MZF15jojSnATrD7YolCQd+3nDBIuTW8+9DfVplEXtQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a252f4f4-d54c-4c4b-74f3-08d6a192e6d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2019 17:49:21.6843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4844
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of reading job ring's occupancy registers for every req/rsp
enqueued/dequeued respectively, we read these registers once and store
them in memory. After completing a job enqueue/dequeue, we decrement
these values. When these values become zero, we refresh the snapshot of
job ring's occupancy registers. This eliminates need of expensive device
register read operations for every job enqueued and dequeued and hence
makes caam_jr_enqueue() and caam_jr_dequeue() faster.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---
Changes since v1:
	- Changed 'i/p' in comment to 'input'
	- Placed variable 'inpring_avail' near other enqueue related
	  variables.

 drivers/crypto/caam/intern.h |  1 +
 drivers/crypto/caam/jr.c     | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 5869ad58d497..30d5b6c5892f 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -53,6 +53,7 @@ struct caam_drv_private_jr {
 	struct caam_jrentry_info *entinfo;	/* Alloc'ed 1 per ring entry */
 	spinlock_t inplock ____cacheline_aligned; /* Input ring index lock */
 	int inp_ring_write_index;	/* Input index "tail" */
+	u32 inpring_avail;	/* Number of free entries in input ring */
 	int head;			/* entinfo (s/w ring) head index */
 	dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
 	spinlock_t outlock ____cacheline_aligned; /* Output ring index lock */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index d50085a03597..b9caa95755d1 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -170,8 +170,10 @@ static void caam_jr_dequeue(unsigned long devarg)
 	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
 	u32 *userdesc, userstatus;
 	void *userarg;
+	u32 outring_used =3D 0;
=20
-	while (rd_reg32(&jrp->rregs->outring_used)) {
+	while (outring_used ||
+	       (outring_used =3D rd_reg32(&jrp->rregs->outring_used))) {
=20
 		head =3D READ_ONCE(jrp->head);
=20
@@ -236,6 +238,7 @@ static void caam_jr_dequeue(unsigned long devarg)
=20
 		/* Finally, execute user's callback */
 		usercall(dev, userdesc, userstatus, userarg);
+		outring_used--;
 	}
=20
 	/* reenable / unmask IRQs */
@@ -345,7 +348,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	head =3D jrp->head;
 	tail =3D READ_ONCE(jrp->tail);
=20
-	if (!rd_reg32(&jrp->rregs->inpring_avail) ||
+	if (!jrp->inpring_avail ||
 	    CIRC_SPACE(head, tail, JOBR_DEPTH) <=3D 0) {
 		spin_unlock_bh(&jrp->inplock);
 		dma_unmap_single(dev, desc_dma, desc_size, DMA_TO_DEVICE);
@@ -380,6 +383,10 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
=20
 	wr_reg32(&jrp->rregs->inpring_jobadd, 1);
=20
+	jrp->inpring_avail--;
+	if (!jrp->inpring_avail)
+		jrp->inpring_avail =3D rd_reg32(&jrp->rregs->inpring_avail);
+
 	spin_unlock_bh(&jrp->inplock);
=20
 	return 0;
@@ -442,6 +449,7 @@ static int caam_jr_init(struct device *dev)
 	wr_reg32(&jrp->rregs->outring_size, JOBR_DEPTH);
=20
 	jrp->ringsize =3D JOBR_DEPTH;
+	jrp->inpring_avail =3D JOBR_DEPTH;
=20
 	spin_lock_init(&jrp->inplock);
 	spin_lock_init(&jrp->outlock);
--=20
2.13.6

