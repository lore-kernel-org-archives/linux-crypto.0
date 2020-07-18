Return-Path: <SRS0=nnFP=A5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8B5C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Jul 2020 09:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D822020691
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Jul 2020 09:43:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="GBHW52qY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgGRJnh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Jul 2020 05:43:37 -0400
Received: from mail-eopbgr80092.outbound.protection.outlook.com ([40.107.8.92]:59875
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726191AbgGRJng (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Jul 2020 05:43:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBNCheOJNTTusBbac+1OFPMUrxBsKoG1a21OpPa2vHAAJETZuNhtGTVkB4BIUz37owBxv16h3OZuYBr2YC5Dr6Y1JSQcu2OaNyMlPr+no5GraENitYAmxmyiCRadxDl9CNT7pNIlt7cXwqzmzjeIqxRPSz82bfMsRyEjJQXoFVOFjNzCUnAsBclhHB+CZBijFENcFavYRenu7mKQsdMXhjA9avHXl44+kwF8hu0jcnko9rQIqbrw9SKtM7HEIg/WkABA72v9KctLeh8I68sNyq6jr4sRrPaV2uelH3+aQGHM8fp1XeQWdiAyR+a2i6C0FLWfYFpVyWZX5BjXzIFc7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpDV2jwUTd/jLJzAPNeI5LUcMzxNWSmFpMsoAtxmVVQ=;
 b=mAUg492B/H9mYNWBQ7Dyz+JdLzI9whGGZXlvQUvFFtaGbF5gJQo00iwHk++LR3HQFmU5Ohh3Cq4SJ4v4A3qYE3Agvo/Qd8jFLmCz39/0m7fxpSetrIzhDdyT+Nvetvg9uoX56sARN6tJpJ34MHkbGhgkTHUlEiL1gM2aQvDi6Dwu+BTMyRfv3MfhYROwVrz4Y+QB3tn9rsAKElyI2Ann6laAvRL3bFz2z8791htN+/bQ8+c1CtInq49YOLHDT+QmAxgnF8hYcY6PrntYIfIx1k9bKqYu+66ZmV7tvu0S69+MoY9meBDgxh8vJ1CuVEq/XZTNNjJYlS1VJrv1dSKQCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpDV2jwUTd/jLJzAPNeI5LUcMzxNWSmFpMsoAtxmVVQ=;
 b=GBHW52qY2qPLn/P1aYe/vhpiIVSrYYa63MgfVedYeqjQ+ri+nwBa+twzJL8mDg/mn30PrvPzBzVh7+gAV7oNJA4thDZteA4ClDDknEbAuO6rRNPpuVRa3sCSD4xPR2Qd3PXZ6dsGXpxU8eAo0xYV6ufhgFXc4a/JPpNMIywexLk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR05MB3396.eurprd05.prod.outlook.com
 (2603:10a6:205:5::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Sat, 18 Jul
 2020 09:43:32 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3174.027; Sat, 18 Jul
 2020 09:43:32 +0000
Date:   Sat, 18 Jul 2020 11:43:30 +0200
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, pvanleeuwen@rambus.com
Subject: [PATCH 1/1 v2] inside-secure irq balance
Message-ID: <20200718094330.omshxatmro4f2hys@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM3PR03CA0068.eurprd03.prod.outlook.com (2603:10a6:207:5::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Sat, 18 Jul 2020 09:43:32 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2b0e95d-15d9-4be9-a636-08d82aff08bc
X-MS-TrafficTypeDiagnostic: AM4PR05MB3396:
X-Microsoft-Antispam-PRVS: <AM4PR05MB339653B2461D4A3392C08AEDEF7D0@AM4PR05MB3396.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:53;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3nMKpwAK+cYBVpmqzVvUU5PoBPiRsX0/TBlsTt/TJ+sgCNgk0ngvx46Dy8Citr82HAOf6z8oDQZdtrF6xStqHoyGDDeV+k/qqTJRmF2i51VCD9I3s+6sDQtpEF5+iDQJPozt6uHbw4Y4RfMw0VKOhHGbp4ik5pECOg5dnGgSurN/IxFoOwyxC/Vj7l+7GBZSWGxV3N0w+iRYRJJUh4l8/Ptk9BfvuCHPqWYE7TUER1NncoeyWABeQer++v82qmRY6GIieQOBj94rk7NRiyDyB7WLBk8qXfRxfrFCGyCohsmAyQaj67Z+NLBhWeXOauvSyUraonzKBh5iiK3vHpXI4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39830400003)(366004)(346002)(956004)(4326008)(1076003)(6506007)(66476007)(66946007)(186003)(52116002)(9686003)(55016002)(16526019)(7696005)(26005)(86362001)(8936002)(2906002)(316002)(5660300002)(83380400001)(8676002)(66556008)(6916009)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LkXaBc303tuSdegqsFaLJ71zHNX9W+2nUwOnBg48MzSfcGNAHmt2Vp9r0+JTdlZyQO77sXcLNQDnTM/73w+YqCVLOotpkdNLcHFM7ZzwVGqbRwdZ+NFb7xnLWKEqHAdV9XTvaG7Av/8DLHaqO0VCsXlyzd93fovCc7qLqE0nCQxn0IdcU94NmYryDwjYUJanVjYu7ld0iUmiRZ0JH1eoqDKDjehTWHZFnNI3GzfWUp8QZnOcaMuNaBtLAinGtDl0FJ1+f+GQs7N4VCTbrGW68kXcMYgyCdWF3XcYMlA17IhJf8Rsy05A5A+81Q2VZkcI4D6UkJIpZy93saARyabbPsJzPvsKN2UO//MCpl0J5J7sVx7a8XzSm1PEh3X5QXkuHyTIIKKxaN2ZvcKh53z2ZvPQ2v1CZEEHfxJXJKchH1NDLUxcTmNk65OrVpNVwut7ip1BvKU3xoo5UreL8dYRBrjBUnetoWpsS8v6pNic1ZXg2imDlu9GOp/hfLXhpC0u
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b0e95d-15d9-4be9-a636-08d82aff08bc
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2020 09:43:32.6632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zyKnwGa7TppuCXHqzW0R/ExDEdkQsRkkzBDpZHMIjgEkqdu7j6cZKifleKWIRDxT5yei5MwU4JxXR3I6E4yC0LWVlOan7NwRvoLYYUhttuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3396
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Balance the irqs of the inside secure driver over all
available cpus.
Currently all interrupts are handled by the first CPU.

From my testing with IPSec AES-GCM 256
on my MCbin with 4 Cores I get a 50% speed increase:

Before the patch: 99.73 Kpps
With the patch: 151.25 Kpps

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
v2:
* use cpumask_local_spread and remove affinity on
  module remove

 drivers/crypto/inside-secure/safexcel.c | 13 +++++++++++--
 drivers/crypto/inside-secure/safexcel.h |  3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 2cb53fbae841..fb8e0d8732f8 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1135,11 +1135,12 @@ static irqreturn_t safexcel_irq_ring_thread(int irq, void *data)
 
 static int safexcel_request_ring_irq(void *pdev, int irqid,
 				     int is_pci_dev,
+				     int ring_id,
 				     irq_handler_t handler,
 				     irq_handler_t threaded_handler,
 				     struct safexcel_ring_irq_data *ring_irq_priv)
 {
-	int ret, irq;
+	int ret, irq, cpu;
 	struct device *dev;
 
 	if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
@@ -1177,6 +1178,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 		return ret;
 	}
 
+	// Set affinity
+	cpu = cpumask_local_spread(ring_id, -1);
+	irq_set_affinity_hint(irq, get_cpu_mask(cpu));
+
 	return irq;
 }
 
@@ -1611,6 +1616,7 @@ static int safexcel_probe_generic(void *pdev,
 		irq = safexcel_request_ring_irq(pdev,
 						EIP197_IRQ_NUMBER(i, is_pci_dev),
 						is_pci_dev,
+						i,
 						safexcel_irq_ring,
 						safexcel_irq_ring_thread,
 						ring_irq);
@@ -1619,6 +1625,7 @@ static int safexcel_probe_generic(void *pdev,
 			return irq;
 		}
 
+		priv->ring[i].irq = irq;
 		priv->ring[i].work_data.priv = priv;
 		priv->ring[i].work_data.ring = i;
 		INIT_WORK(&priv->ring[i].work_data.work,
@@ -1756,8 +1763,10 @@ static int safexcel_remove(struct platform_device *pdev)
 	clk_disable_unprepare(priv->reg_clk);
 	clk_disable_unprepare(priv->clk);
 
-	for (i = 0; i < priv->config.rings; i++)
+	for (i = 0; i < priv->config.rings; i++) {
+		irq_set_affinity_hint(priv->ring[i].irq, NULL);
 		destroy_workqueue(priv->ring[i].workqueue);
+	}
 
 	return 0;
 }
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 94016c505abb..7c5fe382d272 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -707,6 +707,9 @@ struct safexcel_ring {
 	 */
 	struct crypto_async_request *req;
 	struct crypto_async_request *backlog;
+
+	/* irq of this ring */
+	int irq;
 };
 
 /* EIP integration context flags */
-- 
2.20.1

