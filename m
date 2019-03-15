Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CC3C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA0142077B
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:05:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IF8Va/1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfCOEF2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:05:28 -0400
Received: from mail-eopbgr50078.outbound.protection.outlook.com ([40.107.5.78]:60967
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726493AbfCOEF2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 00:05:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnKdr36yzArkIYrIxiRZtmx0p8ItthHxRxhkRs2c+hY=;
 b=IF8Va/1MgSMv+123Vq5NegX70XTvA00FTRrudgtglEnXS+yT7U8ougRttFT/CMDpMPT2a+f8b98fZE0d8RpC+Y4gCIiUhVgsGDqs9Wf9Or2iTcX8ieSUTcBd4nETI1vhSDYyA6I/PgncHF34mnQ/rb9skufg6jb5AVtiSppbaNg=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4716.eurprd04.prod.outlook.com (20.176.233.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Fri, 15 Mar 2019 04:05:24 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1709.011; Fri, 15 Mar 2019
 04:05:24 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH 2/3] crypto: caam/jr - Remove redundant vars from job ring
 private data
Thread-Topic: [PATCH 2/3] crypto: caam/jr - Remove redundant vars from job
 ring private data
Thread-Index: AQHU2uRQPQjC6sa45keuXp3BdD5hjw==
Date:   Fri, 15 Mar 2019 04:05:24 +0000
Message-ID: <20190315040239.24705-3-vakul.garg@nxp.com>
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
x-ms-office365-filtering-correlation-id: 973d9df7-740a-4dc2-0961-08d6a8fb731d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4716;
x-ms-traffictypediagnostic: DB7PR04MB4716:
x-microsoft-antispam-prvs: <DB7PR04MB471675E48F24B7780379C6F08B440@DB7PR04MB4716.eurprd04.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(97736004)(8676002)(105586002)(476003)(36756003)(44832011)(71190400001)(2616005)(52116002)(316002)(386003)(76176011)(4326008)(106356001)(486006)(110136005)(54906003)(71200400001)(102836004)(6506007)(25786009)(81156014)(81166006)(478600001)(7736002)(2906002)(14454004)(66066001)(2501003)(68736007)(14444005)(256004)(1076003)(99286004)(6116002)(53936002)(5660300002)(11346002)(305945005)(86362001)(8936002)(186003)(50226002)(6512007)(6436002)(3846002)(446003)(26005)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4716;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YxOB8tK2+gEVK8vwXSFGhBbeSLLAHvXun5gu1DmTNjhX04pEDXauxZlzYA3myuTQ3/toV905gflw3ldt9NVMF2zwXvOK1/owdth12RDfy7RpxKiLOv2XYfv/ZRb8rJxscGcqxEKGi6DhnGW+YNKkQjWEf4Eu21iBfJxIHCG9VNHung7qtnImvaalMmgOvUxhAJ1xc7kLmqkLlY7eROmf1ep356JA5VdDeoDlNh8kWMbr3Zm1b3gFIfp9EC/IZXumYoRsHlxzctTtGt2Y5C7wpg5di3A0txyU2GRLMTiqprRdQ8TKtATEJUOYNUnn2ahWO8Rg10zJYCHd3HQ0UJk66d3JzjJMZWcJOR/oxeBAT3YesL1yqQ/1bvTdGkOtfAJFq+XhOC8FcRzIjPGrzJzfU2qqXiIvOr/i4TnboeBysOY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 973d9df7-740a-4dc2-0961-08d6a8fb731d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 04:05:24.3806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For each job ring, the variable 'ringsize' is initialised but never
used. Similarly variables 'inp_ring_read_index' and 'head' always track
the same value and instead of 'inp_ring_read_index', caam_jr_enqueue()
can use 'head' itself. Both these variables have been removed.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---
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
index 89de7297d099..02f02fa996da 100644
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

