Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3670BC43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 18:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECFA62082C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 18:03:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ewZ4B3Bc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfCESDT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:03:19 -0500
Received: from mail-eopbgr40082.outbound.protection.outlook.com ([40.107.4.82]:46144
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726535AbfCESDS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 13:03:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H76g2M6oY+wmFbs/sUCA+hAoY+3Sot4mOE9wtycnoqE=;
 b=ewZ4B3BcH8CPic6Fnkd3r542zCVrnupRMdJKBjIoZNwYusg1TE4aoTmbpElrWBWlF8Yy2ob9BU1oDZJ0iMVpNO8HUvrer571OnFQ405/nKtCMk2zh85H2DiWUdXXjd6vH8sgSBLj61QCrHekIH+U4WPnLaPUjd8BLRVgQfPPfhk=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB5564.eurprd04.prod.outlook.com (20.178.106.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.19; Tue, 5 Mar 2019 18:03:15 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1643.019; Tue, 5 Mar 2019
 18:03:14 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v3] crypto: caam/jr - optimize job ring enqueue and dequeue
 operations
Thread-Topic: [PATCH v3] crypto: caam/jr - optimize job ring enqueue and
 dequeue operations
Thread-Index: AQHU0320NnCLOY5LjU20asmkOTCJWg==
Date:   Tue, 5 Mar 2019 18:03:14 +0000
Message-ID: <20190305180040.8860-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BM1PR01CA0120.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:40::14) To DB7PR04MB4252.eurprd04.prod.outlook.com
 (2603:10a6:5:27::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 622805de-b34f-4d9b-a408-08d6a194d690
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB5564;
x-ms-traffictypediagnostic: DB7PR04MB5564:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;DB7PR04MB5564;23:EV7v5weOaTQq5xgdtGMyuy0O5Y0pXBNGbO6Jsj9?=
 =?iso-8859-1?Q?18uBL0TF2bV2NqjNG47E8cxkhyWrDZJje2LyGbfu4EJLXGyv6OBXJD+lfD?=
 =?iso-8859-1?Q?MjQFEOobWwP8WfiGj6Z8abAr0CUzGaRMzrG263BziZ6mmWuQ1aDFr4m2+h?=
 =?iso-8859-1?Q?VuaSgdzzoaXskGX82nis4OOJQkQ670yRKQcMa8KEcdGjFo28fzzd6hJtR0?=
 =?iso-8859-1?Q?6Fbi8P4eEvYjd4lzaxsCp1KqdSwpW7oi0StRBTCe9w9ofpPxomhc1fYpK9?=
 =?iso-8859-1?Q?RcwUf9Rf0GrTd21IWqx/uRsn5qlKGjYh/GjTdpFuWvMIYpQcfCjiPL5ZMa?=
 =?iso-8859-1?Q?a/z/V1Xp0+/V0DnvSBSHIOwPMb/Bzi3v/fQdPe0tt5XuwI2EEkT9I5SlTq?=
 =?iso-8859-1?Q?h7Af97gMmTNFwdNbOVZc9Himk1JdiRyyN1tTLLMLLtgSuUe98BPklx7ozS?=
 =?iso-8859-1?Q?kFf6Nn8xWLTcg9BtXYj1R3q+MijCHKl+st1pGE70RH6ReWqT/zexn70trt?=
 =?iso-8859-1?Q?PSzZ05zpqz7EwoyffZXIKju5njZt+WmiFJaJv2TpE9OWXsZZVivWLX4sSA?=
 =?iso-8859-1?Q?fhTD/SZtddAvDG+n5aB8BWUBwuseQr2iEkNe+cLtehvhayzGSdL91Gikdz?=
 =?iso-8859-1?Q?bETTlKO+bMuj7/o1qLy9937yxNdLCceCGpvfJFZpbyaw7JwH5gi6rNjFAp?=
 =?iso-8859-1?Q?QzyhVS6+WFneq6HV/fBRVdTh20dqjVP1uijF3BN9CC0CmhQpGbcNcuMiXX?=
 =?iso-8859-1?Q?z4II4P5Q4uLJJlU6WzMpSSjCzytzlmXljG/cWlSTM1oikKOuTE5CCeS3gD?=
 =?iso-8859-1?Q?bhTs87wnfz1y1iIfOXEPOe+pxgrSngAPE8A90XcRugahiUpXDML+2wXQNZ?=
 =?iso-8859-1?Q?fTZKzxgGhJ4HbtY4kWwqvXbZgaQcemKA+a2MMg0xTXeKaYfIVQ6s+in1sr?=
 =?iso-8859-1?Q?tGIwFRjpmBVMu6e5oKk9aMo4JBTitMQVT95CZyS5IHfWQWWkkEwoqyOhyW?=
 =?iso-8859-1?Q?HitSDOk8ZbjWP7O9OxJOaLMAANXHK0j5G8EKBtDLY/Z/gvR1FpMxGLLLlD?=
 =?iso-8859-1?Q?JiD9EiDuDfZbY8JVwecmfuR3Y5wYZ3FtzcMT87idM0PxXZ51DvPpT6kq1r?=
 =?iso-8859-1?Q?qzzRScywYNq0Dhnyrm9Rc0ntvVP0dzvqSnm4miApPo5r0WsiqDkW1E2pig?=
 =?iso-8859-1?Q?JEDca1vUGal+U5j/lvFiYXqfWogGMLTjW5ViPC7vX5OX3yrxn7tOYCQrwM?=
 =?iso-8859-1?Q?pmPgWvuOoUbY1bv+uznkQTS9bhw0wB3ebbllDgJVqe0C/uS1s5Ydjog1lZ?=
 =?iso-8859-1?Q?qQ=3D?=
x-microsoft-antispam-prvs: <DB7PR04MB5564572DD198AAD629C3F5388B720@DB7PR04MB5564.eurprd04.prod.outlook.com>
x-forefront-prvs: 0967749BC1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(376002)(346002)(136003)(189003)(199004)(66066001)(71190400001)(6916009)(71200400001)(97736004)(4326008)(186003)(53936002)(2351001)(6436002)(8936002)(6116002)(5660300002)(3846002)(86362001)(52116002)(476003)(5640700003)(14444005)(26005)(2906002)(44832011)(486006)(478600001)(316002)(99286004)(2616005)(54906003)(25786009)(50226002)(7736002)(1076003)(6512007)(305945005)(6506007)(8676002)(2501003)(105586002)(81156014)(81166006)(256004)(14454004)(36756003)(106356001)(102836004)(386003)(6486002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5564;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9OfBnFuRXh+AjWqr09fNubUeD2ZrFGdoNUoJAX6keca+J38z6HVKOSUNgzN8aO7tfD26fQa+zQz0Yb8R57VqciD69jkYDDKL1qe1pw2pr9jc5SvwXx8Fk0k9XBtOUp9c4XGwF02SDIi15CK5S/BwcU2m80OIRebq6JS95SXXLXFfTPhphCCXQw8XBedAljKWv3To0e/qGoZJPiwcdWZ6chbNsv0l8cbAINMgRr2FTFwFYXGAf/eyjmNEeq7k/7uCx7vVXRgp/OH7Ajq5+Df3IUAK6irTr3GnBO06FnVijEuH4S8g3jwrcYLma9DD5tkZKzDPu7zF5Vi7aPSan0N/AjdPKMU7b/CLTXzeAqKlZfIyGBuy7CjxJ4a5NwVi1lmXbtsDfzDxM8H49TaBfEfCVMUksgrv6K1KfdexxpmOufI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 622805de-b34f-4d9b-a408-08d6a194d690
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2019 18:03:13.3730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5564
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
makes caam_jr_enqueue() and caam_jr_dequeue() faster. The performance of
kernel ipsec improved by about 6% on ls1028 (for frame size 408 bytes).

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---

Changes since v2:
	- Added magnitude of performance improvement in commit log.

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

