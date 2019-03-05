Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6FBC4360F
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 07:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D01B2082C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 07:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZvZWpcXQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfCEHBC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 02:01:02 -0500
Received: from mail-eopbgr30065.outbound.protection.outlook.com ([40.107.3.65]:38400
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727065AbfCEHBC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 02:01:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ft+5G+uWYqJCwEmRiZ4FHQS1qT0mGZX/UKwSjDlp8Go=;
 b=ZvZWpcXQcnr0byDtB6Cm7u5o0msH959UFWGduSun+iJproXOOzbVDcXTb9QvTkRC4/6VqhHaRZTcdf6Ks745Mv0ay91yq3o5v5js03IoPD9/s3ujZazhJI0rnl921Wtmx9lGdF4ExnRLdJ9Zq7sVk9OraNc6jTzGejVU1sCqIlo=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4937.eurprd04.prod.outlook.com (20.176.234.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.17; Tue, 5 Mar 2019 07:00:58 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1643.019; Tue, 5 Mar 2019
 07:00:58 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH] crypto: caam/jr - optimize job ring enqueue and dequeue
 operations
Thread-Topic: [PATCH] crypto: caam/jr - optimize job ring enqueue and dequeue
 operations
Thread-Index: AQHU0yEvYfnJy4m6QkW0mfkgeeAyJw==
Date:   Tue, 5 Mar 2019 07:00:58 +0000
Message-ID: <20190305065820.13072-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BM1PR0101CA0027.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::13) To DB7PR04MB4252.eurprd04.prod.outlook.com
 (2603:10a6:5:27::26)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdbeacdb-4245-4a12-165a-08d6a138519f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4937;
x-ms-traffictypediagnostic: DB7PR04MB4937:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;DB7PR04MB4937;23:zrDBcSVetaFTf/1rfgKT4cs4kPir9zaGS2S1Khg?=
 =?iso-8859-1?Q?vgSiDD28i+I3UN0u47UOaNajxQUQkBNgMrDNWjbKUupNNxDDl5Y33ZVd5k?=
 =?iso-8859-1?Q?cSCIYFzvkiXZsjrJnxM5Bo0mpA0Urb/sqehHfPAOiYH9RSHNBaKR00VznF?=
 =?iso-8859-1?Q?eHk10kMA4DsWTvAY2s14JzevjEC1gs9sXmLfPodOnpxxykQJI3u8Uu4FBT?=
 =?iso-8859-1?Q?TwXZnQS6yxq2lgw+XfzVkbbpUO9IUbfrBT1gVy1JPz1vcdsnTekZmDrWYv?=
 =?iso-8859-1?Q?RjZbPTbQ5GrcZt639nBAudgyx1gPWW35+jMczRiO7xoWaW+LqVzBub9olD?=
 =?iso-8859-1?Q?eJSRZpjz/aCT43rr2e7YCcw6TZ77/if0ZgYXNR//2RmzMmC9xPrHjQan/l?=
 =?iso-8859-1?Q?mmlJkmMUhJnFWKQLKYCYIOcFju2UF5T3jEYi2in94PIAUspGP0d2sTSYI/?=
 =?iso-8859-1?Q?lwd/Xju5BUWthmDt1lhoxUgZQkOZzQrhm9FnYES2DW/2PuqnYaIOjLP+qN?=
 =?iso-8859-1?Q?1RLa+8LNvE5sBU1P25zbhz4ZeYXJKJjUftlSCi3rshJ2VQiR3afcuutiMR?=
 =?iso-8859-1?Q?QeOnbJnCzWOWD8MBAW4YD508TFIy7IVHD8fYTIHFeNqkAs3Budxc61rk7Z?=
 =?iso-8859-1?Q?2a34hfJ0Rd5FNLkn+QGxBF5cjuWF8LB48JPmRkj9U/PeiVznhFx8mKTX2e?=
 =?iso-8859-1?Q?88Jk9n08M5WCZ5D/8JA0SwJjvRWyn989jpdUpD0eDfDoWlSi16l+uvItMg?=
 =?iso-8859-1?Q?hD70B8F1hRKAEjLWwLx9SxufQfNMCVwyeWuBoF4bJnrzLwe9TcPClpQW3s?=
 =?iso-8859-1?Q?99MRxWX4du22egNRwnZbbxxYX0JdTVp9yciMNW/ktMGVv/s0yguVHhGEJp?=
 =?iso-8859-1?Q?WUsKObGkBw30YnV4qE3VsE+DLyhmHrdTvfCms9dY5zHwxIY1NaWia19agL?=
 =?iso-8859-1?Q?22ij9VLaNPZhf6gWIRkvnhrOwY2ZW1VRGRPLtUwa0iuFu5jBBeehAcajNZ?=
 =?iso-8859-1?Q?2CcyX5B98umg1cyEdr2h76N1Gn8pq7E8nbY//rPT4y3Op0f+7x7auX0umm?=
 =?iso-8859-1?Q?K8K2qFEqfYY97GSTE+gsCSfriUG+seFdW5BF4uylmtFvY3wRiVFuBfVWM1?=
 =?iso-8859-1?Q?1PbviICNY2FnSw3sq7Wx/Nzhqjgk01MqPCD4kFy6MfSaodxgtUnPoQgqxx?=
 =?iso-8859-1?Q?lpHu4A6h5aknsJ5+DtlBtnk7RaqDSz9waSVpQgq0aeMqpXqhGGzibgz6+9?=
 =?iso-8859-1?Q?ozRM7X2XecX1N+OZiRr8EewV3s6jnIM0oiy1TZmTteJuHz8RrhJ7LI3Zad?=
 =?iso-8859-1?Q?VDFa9wl+ycFhV/09ZXadh5e?=
x-microsoft-antispam-prvs: <DB7PR04MB4937738C3A1089A2133AD0348B720@DB7PR04MB4937.eurprd04.prod.outlook.com>
x-forefront-prvs: 0967749BC1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(376002)(366004)(396003)(189003)(199004)(6116002)(6506007)(52116002)(86362001)(6916009)(36756003)(2906002)(99286004)(14454004)(478600001)(97736004)(81156014)(305945005)(7736002)(66066001)(4326008)(81166006)(386003)(3846002)(25786009)(256004)(14444005)(8676002)(68736007)(106356001)(105586002)(6486002)(2351001)(71200400001)(71190400001)(6436002)(6512007)(5640700003)(2501003)(50226002)(316002)(8936002)(54906003)(186003)(44832011)(53936002)(1076003)(2616005)(102836004)(476003)(486006)(26005)(6346003)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4937;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: h0KK0gLBToxwUhEFshu/qe9tc/SMp1XvAWE/8zJnqIZ5lgXpa/I56ahTlZsdzNfQRNaBFpbXJ+VSkpzPRjD6mAgdXVHmVwBiwPy99VXTyLwVypHDYCG7lSM8xS2v2USQHKD7woOlSpU9C8j0hOnZWkiQx1x4/huaTghg+OGsOO7phvG3W2emLb1r0217GstqMIwzGzPGiP8wcXg4Jx5SnIbhXrSHehK5OZcOlAinltJiYPZR9R4aGZS0g4P8kw4f+2dra8YXCWY9+ZzZXqBZcaoXHzcQBpDC3rFRUOs4bS+NN3s1+ep9pQyP6D4AJiYdlCMKS2dUQXX2QlBxjF5mTMvmbGDW3iPSjTdPoSAD+Fp1sVTOUm2WPolBl7NT1RqbpXLlUpbLSGV2mYYtYEH0c/rKR7l+EjfXvZJYrk4/03g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbeacdb-4245-4a12-165a-08d6a138519f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2019 07:00:55.6158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4937
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
 drivers/crypto/caam/intern.h |  1 +
 drivers/crypto/caam/jr.c     | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 5869ad58d497..b6d96e2ecf4c 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -59,6 +59,7 @@ struct caam_drv_private_jr {
 	int out_ring_read_index;	/* Output index "tail" */
 	int tail;			/* entinfo (s/w ring) tail index */
 	struct jr_outentry *outring;	/* Base of output ring, DMA-safe */
+	u32 inpring_avail;		/* Number of free entries in i/p ring*/
 };
=20
 /*
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

