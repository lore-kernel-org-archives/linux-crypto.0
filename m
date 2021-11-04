Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01718C433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 16:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D658261212
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 16:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhKDQYP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 12:24:15 -0400
Received: from mail-am6eur05on2098.outbound.protection.outlook.com ([40.107.22.98]:26849
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231419AbhKDQYP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 12:24:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/+qo0OybLRIiF6S/1nvYbJZt6Ojd54t/SUjcCthZ4fLFXt5H7aPWSbgekn/g2s3bfBof4IT5sUfZotrc7B1twl90Xb8Jl59rpq3Hzl0QqNrHs2mEwwPMSCCieht7YQktBwCsEbDomkVyKI4zqjTTS45PrURGuHo4/IyC3vh49uU8YukVeAX3y6c8tLcqwXSk2lhDfM8+Al6IneEupuOd1Dd/Zusn2GUoLj0o0snlWmqJSeh8o2YHj5GHnFDKsR6Iebh5GoYmALrq+ixe0o6KBYxmQ/M4JHYovb6Ssqo17rlV0WheN+mSefFAU4ybyEX4TKoyKrwoKNCs3glUJ0eTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVSJJWK/za4W1Kul68/8iQQ94gYgi9MDP1P18bYlg1A=;
 b=dwaYfMj2/BbhBBjUOVPo1FK0hhzMY1UEK67oHqOC/NCJFtWFOFydFD1V2FdSmrnDVNIIhOyixNN25IlDLDaHPvjgMQ5scJ8aUxSUlGS+72aK1YdwWMimcf1MlRprWpjC/1ujLV32kgCSkQR6Ks+/cEBtMQoqcELJ+Q3tkLJ49y3m8eepNFNdQ90fxagUlKEaMqExl2EnkXBM3s+Kbsx7VIrh24fe+SeIEfKDYZciU+R6JFXUMW5URFN5b3lyigsckRU9Yr9sbuutjjzyk17G6I1MhqiiCbO4Qe5tTQFs58NJjiKa3LXX3dC6Iao7g+erq20ecgfpJH/30StROwpU+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=leica-geosystems.com; dmarc=pass action=none
 header.from=leica-geosystems.com; dkim=pass header.d=leica-geosystems.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=leica-geosystems.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVSJJWK/za4W1Kul68/8iQQ94gYgi9MDP1P18bYlg1A=;
 b=mMPC4tErxHTA+N9WBuxHGrh0IeE4UGz047GqOOBCRwNaerV78UUGcbGL9R90BLLgyQzNiJ9GPu86OvFvnu5mqKNdbgsvzDMo/dB7VBWuxPxl+qV+WwSE/39NJRJiQBYoTm8v8YPR5QKoD6Z/aeOQSr8p/7rrgFUL14IeV/XpS8A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=leica-geosystems.com;
Received: from VI1PR06MB3102.eurprd06.prod.outlook.com (2603:10a6:802:c::17)
 by VI1PR06MB3103.eurprd06.prod.outlook.com (2603:10a6:802:5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 4 Nov
 2021 16:21:34 +0000
Received: from VI1PR06MB3102.eurprd06.prod.outlook.com
 ([fe80::5420:b387:e6b8:9e22]) by VI1PR06MB3102.eurprd06.prod.outlook.com
 ([fe80::5420:b387:e6b8:9e22%4]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 16:21:34 +0000
From:   Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
To:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, michael@walle.cc,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Subject: [PATCH] crypto: caam - check jr permissions before probing
Date:   Thu,  4 Nov 2021 16:21:14 +0000
Message-Id: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZRAP278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::15) To VI1PR06MB3102.eurprd06.prod.outlook.com
 (2603:10a6:802:c::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from aherlnxbspsrv02.lgs-net.com (193.8.40.112) by ZRAP278CA0005.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 16:21:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31bdc0e7-9938-4b17-0f7f-08d99faf2b35
X-MS-TrafficTypeDiagnostic: VI1PR06MB3103:
X-Microsoft-Antispam-PRVS: <VI1PR06MB3103A842DB3FF4AA704F125AA68D9@VI1PR06MB3103.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g5UmNT4E8qw1yUoAcRdsPjlx7p6MV2BLBwmCYRHYBC+3hU+V0ZMiTBk7aCPjOuVxnpl9qSK95Y5liBVcX4n/pj+wQwcCdcvW8r0834NhajzvSrgV4PLxrrONrmgsSsHwKInnKfN8NEdg3OBK/mUt5mclhO61vz2ljLNQ0/+YtpKPynWqCJ9pnGcDs+7iP7yXOKQ36Om/XtVP+N1AmeXGsQouv6s3n5FGlhs4ZBWi++f/2aWvw1/ni1V5RPWox+75ltsagH2uDxQMMkRC/puiabvoL0IaIIDHnKYm35AazYXmbUlqAHwrQLSuPSbjyc/1yRldAvqVNAK9YxvBmK9NnSwx9xLkf1Y/KsHhDrIYGz6S8b0pfkxrVeXbBiEkF0KzrF98eLwLk7psacgE+8xWZ1fskxtjmIepmf1IvlO7i4UjVIMAbRbXxbZSJcx10lvkXkZQCagCYp+/VlWulUYronA9ZqKZY0NvdAuLvTMa+2ySWTEa2R6VHs0NRzxQIor2MnYwhce+IvFetY2xNMVHzmb1sa1zdZ9PoUnfi8FUvV8ptcpmSy1G1DN0Gv3VMto+b5+sCYrJA1OFSZdhIdeXFiK83YFAWddS1IQm25Qa2w78GNR7MdI49ZpzfV+/Bp2BoKh6G3ADPfkTQMY8DcSGMvgl2r+ExV5Au/E5USCvbK0YHVbImPPOt5CuR5FeR37ZCTVzqKNyjo/c03CvoottXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3102.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(83380400001)(86362001)(38100700002)(38350700002)(26005)(66476007)(508600001)(956004)(6666004)(2616005)(2906002)(186003)(5660300002)(107886003)(36756003)(52116002)(66946007)(66556008)(44832011)(6506007)(4326008)(8936002)(1076003)(6486002)(8676002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JrmRjR1yaoN0nYZ/XIpnaIzsGGgGkICVaqe43TSKeK9TQTfMU/BuXCTasrh4?=
 =?us-ascii?Q?lKzMIc6RGtjEebyUGow8EAecYKJ0T4Kxea8zNo6ygbdIl01R4iV7hYGnA5en?=
 =?us-ascii?Q?0U8ZCvdxVAg49yi3XOwjIKHVkliDZMmd8c9BKXM8IeT0vnCv8wiErdxhBX7D?=
 =?us-ascii?Q?3BIEgg0Zh67hlxXmIEe5ooM7T5JIeJPEkAycJgQDw8LEljPb/5fXyJyZqiLC?=
 =?us-ascii?Q?isQKVaIOb2Ig1BUQDJbzH9kKz8yZ7wnTEdgDVQ4m78UzJ2CPqeLwodVun2IX?=
 =?us-ascii?Q?GDO58h1tah5qKwXkBGNa+188sS8WrvBLsxuTuoBLZ3hqCMu9txx18jBt2k4y?=
 =?us-ascii?Q?7ReEmnbDQ/Z/9RaEbO6NgsyKRmMh5NO87sRZqK1k/GgCkP00G/hmJSKW7Bwo?=
 =?us-ascii?Q?N+xiN+DDnRxfYK8Yyh+t63VVJpyunDK4kypr6IDyX/oBxMwCJourrJwR2fdZ?=
 =?us-ascii?Q?i8JfYPXWoVG96/IAYS7n7mYuNmLZRFhLdUx4TZijMkiV6X7arR/f5q2aNZQ3?=
 =?us-ascii?Q?1AwN9t4CEj9iUEN3p2c3+QDBlI4zZL+VVNrTSMvUeQbzvsBcE/cRQwHb74RW?=
 =?us-ascii?Q?UCa1CqoUTQgVBv9U9EPiVu9/S8L+Rw0bsuC9jLBuCVCLFjdtGMtSw3dMuijp?=
 =?us-ascii?Q?J7pFhigQSWaNaKQKXRl42d6x4BtjWjOtx9zHGbeHkiR7JM58dydG8V37APR3?=
 =?us-ascii?Q?UQuM6i2q9Qx8trSMvlUYZXm8VAKTGOvTCUzSbDvfTVHgceTe4k3CS7oDXOPL?=
 =?us-ascii?Q?KlnDzK5l/V3/QU1Ij3S+G+uJ7bK8LoapOOPs5KO+ncDLwedyew8tLJBOgEKm?=
 =?us-ascii?Q?iZOGF5CdkTQC2ZC29cesbzstKlrtkwe1MGnkXstd1GUDbUiAzIMIzbRWPSp5?=
 =?us-ascii?Q?Uq9MnsqYldRq+XpN7ckZDtJksYtlryPEixvpgFM4Kds9lGeZVaZU1QmzFECE?=
 =?us-ascii?Q?Tkjxf4l+jjOBcLye5+Xd+/IoWTOR6DuZ9g3X2MSnbExX/diTp2vRJdlaDhmv?=
 =?us-ascii?Q?aDndjQmme6fUhECCsL5iyiGz/m1FHgR3A97P/qJd6Y5xzc4sQM2whHJPa7Dn?=
 =?us-ascii?Q?HYxRyCMxOf7r+/42CFTOaaNqolx1q8lIyIYtEXSvV7sTuyJj+BO1YD2pWcej?=
 =?us-ascii?Q?29TRswAiCn23eMyh2m0bsSod4jAg/VSOyTMBvFSyr6St0pfQCpmpr13dqLXM?=
 =?us-ascii?Q?Rr3SY4Ool+bzArax1H9FJdIQgeuJhAFfIQzskbEUeIg2okazzCFy4xiZoBUb?=
 =?us-ascii?Q?2bU1Cs1daYjMxLRye+NzQzPwt6vxoAc71YV4gIPsmmjDSMNS+uzheqElW1oL?=
 =?us-ascii?Q?BzzpxHYEga7c7J9MNBmDWAzBAVPtX7DVJkd2CKRSRUJMmfKadC9xGellWZQM?=
 =?us-ascii?Q?H2nWrkNDMLODx6JNZPgSUMihflK0VbKMvymA54Q4mgjJFSI9JBXEF0MG7mzn?=
 =?us-ascii?Q?3hnJjF4k+BoIQLmA3T/7AC3Bkne0+kGW7GUu2yGyYcaWazUqDB6bj7oFx3PI?=
 =?us-ascii?Q?NSCoD+nFdl44oNwhlbgTxwydYEjAFVD9cFUrZk4lWt/1wNhphpEdluK1v0le?=
 =?us-ascii?Q?BT1BzsBkjgq8gRLSlE5TW2Kw19at+zd3DC42L13Aqx52Hl+r2Xq0zQgOmBzd?=
 =?us-ascii?Q?YnWxjB675ZFaI47w3L8F01drVIrFtLI6RE/3+nkiwxbPlPLv8gYQ4rQuB4Rc?=
 =?us-ascii?Q?gOhik1o2qz6C2UqCNFfagAhyX30=3D?=
X-OriginatorOrg: leica-geosystems.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31bdc0e7-9938-4b17-0f7f-08d99faf2b35
X-MS-Exchange-CrossTenant-AuthSource: VI1PR06MB3102.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 16:21:34.6514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1b16ab3e-b8f6-4fe3-9f3e-2db7fe549f6a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EvLcFfrujDabGh9Zi0YtO6gaVeKz244TqIu6/icsunJmyGijfra9SLe/vMms0E5eoZI7H7JfYIUnNxGTnCZnKfR3dvbzqTAZpPKKO/QPpoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB3103
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Job Rings can be set to be exclusively used by TrustZone which makes the
access to those rings only possible from Secure World. This access
separation is defined by setting bits in CAAM JRxDID_MS register. Once
reserved to be owned by TrustZone, this Job Ring becomes unavailable for
the Kernel. This reservation is performed early in the boot process,
even before the Kernel starts, which leads to unavailability of the HW
at the probing stage. Moreover, the reservation can be done for any Job
Ring and is not under control of the Kernel. The only condition that
remains is: at least one Job Ring should be made available for the NS
world.

Current implementation lists Job Rings as child nodes of CAAM driver,
and tries to perform probing on those regardless of whether JR HW is
accessible or not.

This leads to the following error while probing:
[    1.509894] caam 30900000.crypto: job rings = 3, qi = 0
[    1.525201] caam_jr 30901000.jr: failed to flush job ring 0
[    1.525214] caam_jr: probe of 30901000.jr failed with error -5

Implement a dynamic mechanism to identify which Job Ring is actually
marked as owned by TrustZone, and fail the probing of those child nodes
with -ENODEV.

Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
---
 drivers/crypto/caam/ctrl.c   | 18 ++++++++++++------
 drivers/crypto/caam/intern.h |  1 +
 drivers/crypto/caam/jr.c     | 17 +++++++++++++++++
 drivers/crypto/caam/regs.h   |  8 +++++---
 4 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb0..c48506a02340 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -805,12 +805,18 @@ static int caam_probe(struct platform_device *pdev)
 	for_each_available_child_of_node(nprop, np)
 		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
 		    of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
-			ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
-					     ((__force uint8_t *)ctrl +
-					     (ring + JR_BLOCK_NUMBER) *
-					      BLOCK_OFFSET
-					     );
-			ctrlpriv->total_jobrs++;
+			/* Check if the JR is not owned exclusively by TZ */
+			if (!((rd_reg32(&ctrl->jr_mid[ring].liodn_ms)) &
+				(MSTRID_LOCK_TZ_OWN | MSTRID_LOCK_PRIM_TZ))) {
+				ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
+						     ((__force uint8_t *)ctrl +
+						     (ring + JR_BLOCK_NUMBER) *
+						      BLOCK_OFFSET
+						     );
+				/* Indicate that this JR is available for NS */
+				ctrlpriv->jobr_ns_flags |= BIT(ring);
+				ctrlpriv->total_jobrs++;
+			}
 			ring++;
 		}
 
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 7d45b21bd55a..2919af55dbfe 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -91,6 +91,7 @@ struct caam_drv_private {
 	 * or from register-based version detection code
 	 */
 	u8 total_jobrs;		/* Total Job Rings in device */
+	u8 jobr_ns_flags;	/* Flags for each Job Ring if it is not owned by TZ*/
 	u8 qi_present;		/* Nonzero if QI present in device */
 	u8 mc_en;		/* Nonzero if MC f/w is active */
 	int secvio_irq;		/* Security violation interrupt number */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 7f2b1101f567..a260981e0843 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -511,10 +511,27 @@ static int caam_jr_probe(struct platform_device *pdev)
 	struct device_node *nprop;
 	struct caam_job_ring __iomem *ctrl;
 	struct caam_drv_private_jr *jrpriv;
+	struct caam_drv_private *caamctrlpriv;
 	static int total_jobrs;
 	struct resource *r;
 	int error;
 
+	/* Before we proceed with the JR device probing, verify
+	 * that the job ring itself is available to Non-Secure world.
+	 * If the JR is owned exclusively by TZ - we should not even
+	 * process it further.
+	 */
+	caamctrlpriv = dev_get_drvdata(pdev->dev.parent);
+	if (!(caamctrlpriv->jobr_ns_flags & BIT(total_jobrs))) {
+		/* This job ring is marked to be exclusively used by TZ,
+		 * do not proceed with probing as the HW block is inaccessible.
+		 * Increment total seen JR devices since it is used as the index
+		 * into verification and fail probing for this node.
+		 */
+		total_jobrs++;
+		return -ENODEV;
+	}
+
 	jrdev = &pdev->dev;
 	jrpriv = devm_kzalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
 	if (!jrpriv)
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 3738625c0250..8ade617f9e65 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -445,10 +445,12 @@ struct caam_perfmon {
 };
 
 /* LIODN programming for DMA configuration */
-#define MSTRID_LOCK_LIODN	0x80000000
-#define MSTRID_LOCK_MAKETRUSTED	0x00010000	/* only for JR masterid */
+#define MSTRID_LOCK_LIODN		BIT(31)
+#define MSTRID_LOCK_MAKETRUSTED	BIT(16)	/* only for JR: masterid */
+#define MSTRID_LOCK_TZ_OWN		BIT(15)	/* only for JR: owned by TZ */
+#define MSTRID_LOCK_PRIM_TZ		BIT(4)	/* only for JR: Primary TZ */
 
-#define MSTRID_LIODN_MASK	0x0fff
+#define MSTRID_LIODN_MASK		GENMASK(11, 0)
 struct masterid {
 	u32 liodn_ms;	/* lock and make-trusted control bits */
 	u32 liodn_ls;	/* LIODN for non-sequence and seq access */

base-commit: 8a796a1dfca2780321755033a74bca2bbe651680
-- 
2.25.1

