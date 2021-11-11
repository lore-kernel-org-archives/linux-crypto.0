Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5A7C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Nov 2021 16:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE2D361002
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Nov 2021 16:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhKKQuB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Nov 2021 11:50:01 -0500
Received: from mail-db8eur05on2090.outbound.protection.outlook.com ([40.107.20.90]:29792
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234318AbhKKQtT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Nov 2021 11:49:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmrSTHN4pIn23I9/kadB+0QPgl8WPKWrsmeqlrasi9m8gi68LB6Qo0kzmEEmd52BoKJiCBiRoWm3egM61OZ3qqeJ+uBQJUmdspaTQUyCxYBGwc9eyd0PLYpGFlF7P2eJI2YhjBWuQDfyam00cdLgAQtEWoJEbsOD+kTGXJ64IIEkTlblCRvyJhVegvwkeDD3F6Ncs66hGmKLkMqfbEyXMLVuUevS4xhUsrSQvJF06eJPJOYwzxUTFQby/Xq4s/MWJrjqxSf9wmpZbs9YqlDt6oQMWsA1FFcWcqqTq/c2btLnfF5z4uQj5SoRn7mm06jr317r4+A1v/a7NdREp7ar3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s12BQplFlN+J3aM57hteezdrxKf9TtjI33nGUKvLyB4=;
 b=j9bnXmQpkZ/rYfJ9xhC5MgTT0Il4qe14VJc6wdIq4owH8cBydL5Pb7TJNW7YPLrIbHosb04tcYSDrII+kMfWrYlPrfk3uee0jpcII7z7gd+bMAugdVkziFz2DyGt0yKPwX6LWt/Fq3fPn+KxfZb/4IlAEjiRWL+mR9O1YmOzyr1r7aDsPUOeY1Ulc9sS5TlXJKZkRT6flwsjUPdOycunO0lZKkg4b904raxW0WUvpo6F7zEEG3kAinIl3DsDj3T0fqitYCbMMNLyqwiaAobb+I8hgZAM0RkwzkaXYlJdu8lKj2FyjPyeIIjRgj+HHtIgNJ4TRb9KT04xZPl32VkgPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=leica-geosystems.com; dmarc=pass action=none
 header.from=leica-geosystems.com; dkim=pass header.d=leica-geosystems.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=leica-geosystems.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s12BQplFlN+J3aM57hteezdrxKf9TtjI33nGUKvLyB4=;
 b=kKE6XfdTdwEPP01IWTWPZumwLrEp6+1+6KNHrKsNUrExoOQQEreevd93jzAejkgmyq/wNVRTusiNKm/pJSKiZl2UuWYZT3qPegxTpKUEQNA7NHp21wq1XcNZIz9dwc6w/GQu5oqSL+gqtMFHfMSeF9AP+iesvWxzwtcY6YDjaBc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=leica-geosystems.com;
Received: from VI1PR06MB3102.eurprd06.prod.outlook.com (2603:10a6:802:c::17)
 by VI1PR0602MB3712.eurprd06.prod.outlook.com (2603:10a6:803:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Thu, 11 Nov
 2021 16:46:26 +0000
Received: from VI1PR06MB3102.eurprd06.prod.outlook.com
 ([fe80::5420:b387:e6b8:9e22]) by VI1PR06MB3102.eurprd06.prod.outlook.com
 ([fe80::5420:b387:e6b8:9e22%4]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 16:46:26 +0000
From:   Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
To:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, michael@walle.cc,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Subject: [PATCH v2 2/2] crypto: caam - check jr permissions before probing
Date:   Thu, 11 Nov 2021 17:46:01 +0100
Message-Id: <20211111164601.13135-3-andrey.zhizhikin@leica-geosystems.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211111164601.13135-1-andrey.zhizhikin@leica-geosystems.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-1-andrey.zhizhikin@leica-geosystems.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0166.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::13) To VI1PR06MB3102.eurprd06.prod.outlook.com
 (2603:10a6:802:c::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GEO-HfyyrYQLnZo.lgs-net.com (193.8.40.112) by ZR0P278CA0166.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:45::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16 via Frontend Transport; Thu, 11 Nov 2021 16:46:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 017f5b81-d5d1-45f9-5bb0-08d9a532cd5f
X-MS-TrafficTypeDiagnostic: VI1PR0602MB3712:
X-Microsoft-Antispam-PRVS: <VI1PR0602MB37128E40610114AA9C7D05F8A6949@VI1PR0602MB3712.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bw2mDj7T62DE+CvdL+sywW/SQ4La9fuh40sW/2zwMzSt8ANlT7f9jw2sR3VwVqzILwVkT2btiGAj8UeJBSZeo/h7453cq4a5z67oFZP3tWX//tzp2sJX9fMi8gdWIXb3/deQXP80TnTy5mVOLAfF+Mrn+0dlHGaCNN2o7mnEhwFbEAJQXz3FORPVBAzJx8V5+xI5PvRh4XlqIqexLhlOKA8kwA3K//HI3N6RhQXvrbKOAV5be2MBd8hDE8kRkWr36UIvm0BYB9sapW22mXn3YuQSZJNJNOUmW8Hns0ku3Vxju1g/cmfGuerg9I+og7Cs612o6O858rgNUnioBgRuyBwhaPVt711FxKdqU1M+ScKXoDye0k24foLJFgU23Gmm2zjVErkAmjlJBsriHMT61hEZEUiWj+vUhCB2YANeIST8YikSivYQzA9cOl3bPM2z+TmLl5diFqMm/LZ/xepa4ovSZFTF4yS2qkjG9qhuupN/1cRbFvLClx7Bx7I1jOc0tSh5E4ZoPVWQqIQSNZSpnJ8sg/1kI7+sYMNgTCH5p+XKbgjNOaOavsqjLdEwrtA9iahbcFrEAowhYPaxJbv1NMprABnDBL6AxrIEyaIs+4qV7685Zqtnd2YjAeYPGpwtHOy9qOqWGuxDTd2MkLlCRSSc6JONgQwNxp3un2xQscmf+kuuRBXoLnT+xr1QFco3VXLObiSDXL3LFbfqCmDL5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3102.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(38350700002)(107886003)(5660300002)(44832011)(38100700002)(1076003)(6512007)(83380400001)(2906002)(36756003)(186003)(6666004)(26005)(8676002)(52116002)(956004)(66476007)(316002)(66946007)(4326008)(8936002)(2616005)(86362001)(66556008)(6486002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k0Fa2KmsCkbY9dGELeReLho5SKjtUc1nGoX7nCyCdQlEKAO3jDT7QVAEVSA/?=
 =?us-ascii?Q?It6iW9tvw1y/8Fq/GGR8xOBj1ZCMka6N1AbFJyUIb9UuMjXIMkTlLJMO3zkw?=
 =?us-ascii?Q?xCG6PycoqjYFzirH7Ehgb0knSvplyBK6/0FPLrSZKrPWut2kt1AdsHFn5DD+?=
 =?us-ascii?Q?X9UxG3eYQsYYRFr3rh//yqJ5lR7u2gnMNI7AUwOjG0DcpkqEiMx1fOYDjRb0?=
 =?us-ascii?Q?EUsAbxr6oMyvL7eiJ8zJoyGvr+0C+Mc9a9TGHfLBkvEDvBAbnOqcBgn9gZ8d?=
 =?us-ascii?Q?Jn2j7ESan5zMJz5seMa30CXiWwUU1vyXOnrsaDb1RFbua2/Nx8d09yQHrYW1?=
 =?us-ascii?Q?zSjEH2AaSBmg9wdEIgIiIEPDTfgUSl7px4L2ZbS9UYGttswhR9Bf86owQhaZ?=
 =?us-ascii?Q?vq0LAmzTGqU3Te08amp7Veo5Kcr9+1ElxusJn1KaOjSnlToW7Hi8g2x+ORyY?=
 =?us-ascii?Q?Nk5ZYmLxUF/EgYWuhDhR5Alro+kBt+nMAA23BZRiQvRPVEQs0HF4Z/zSB1Z8?=
 =?us-ascii?Q?ETEgMyyx7h7tGXEv4mkQUfSMp+B7eXXwa9/bRW4W313HKesY6CmIqtn6VYFC?=
 =?us-ascii?Q?kWqgg/8Z7D5QL5W26gZ3D7lYIIkYyYiOEoS0r5lvyHGh6hnh6N3SYuydCjan?=
 =?us-ascii?Q?/hzVmIkC3rlr/AJo0Z4zVYfwFuspLnATYxtS0rq/YpSaNUMohyqYKM9hBLtX?=
 =?us-ascii?Q?9wPK6Zamd9zwbeTmTEw0x+aJDEwJN80O1YxWEC/210TJd7BrNip/+alIolv7?=
 =?us-ascii?Q?xcTaczsXG45EBBUb7M5WFtUwxETSpRge/QxTlaNyuPlo9u4AvwD180UWclyk?=
 =?us-ascii?Q?Uc85xczigDGYjhvBXvgkc7s9b6Zkh+aK2Q5g2oNlNboug8C42j1MEPlMlUu+?=
 =?us-ascii?Q?AOX0IHusQ1WysZSW09YwVWYDVUGE9UEeZYDMU5O1gGCewUGpe4kT9S9ntPCu?=
 =?us-ascii?Q?F8VCKH/nvQEHS7GpH9edVM3uC030dHf2LETlp1q/4QyowG7dtX3lH5qUzMib?=
 =?us-ascii?Q?hqRBV8+5oteZ/Kp0IcGCgRRl6WGEVIBfPIgAs3uQ9lHBUvS//adaAfAnvuY4?=
 =?us-ascii?Q?o0eM+71nVO71WSefFhUinVEsxQwPdG0+qSuI53llnj39ZfoJ/l9EwULliiSV?=
 =?us-ascii?Q?2228TnVklcqpdrZ5jJH1xco+vA9bRIrkHAa6NGFnG+NlMnqYACF0iy9R0g9e?=
 =?us-ascii?Q?PUcSqL/z/YTjYTPkZWIL+xz+r38SZylhwRwe15PqsTrsjI3gKLuAN+5PDyK+?=
 =?us-ascii?Q?JVg+mdogcIPBbJGapHD62+Wuo1oWi2pueE7smXuLqAdCYNJChIf7P8zQ/+rP?=
 =?us-ascii?Q?BbKr2ALcqGU7u9/gvx0+jtWMP9gs+zvd0gN3vvfW8isnOAsF8On3by7xoQM2?=
 =?us-ascii?Q?9RuWaQ1kMvCBi0t2nkrDxv4jK3Tb4jCCMxbhpz1ef5oljhfdUM5E+LdGqCkJ?=
 =?us-ascii?Q?/HKmlzvwNMS/dx5B6i/1mz19Q8eo86/QMmwLXl0rBSZURDkOFx2NPJXEjUz/?=
 =?us-ascii?Q?KeAx6aLFB28ysnoAgXrfGcG7EZDqsIhjp6SH8POJNyVSt0UVFAiRMwcPyofB?=
 =?us-ascii?Q?U3aG1lbVHWGYIkrl4yUwluseD7K1SIj3SoUATKrqebgxYJu2Bd7zB1NhGiSm?=
 =?us-ascii?Q?urehPCmAUqcCXHEVGVKlcvQCc59m062z+DVgVOI0gijFsGdgK1tp527Y5Y10?=
 =?us-ascii?Q?LdKWOeKyEGyHrgcfZ/r6bnKbwTU=3D?=
X-OriginatorOrg: leica-geosystems.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 017f5b81-d5d1-45f9-5bb0-08d9a532cd5f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR06MB3102.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 16:46:26.3611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1b16ab3e-b8f6-4fe3-9f3e-2db7fe549f6a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0bLjauggplqTgugiLjVwTUJCFfJ751gVlWDYS/BWdaETRhiFfXIrQDEIHnHHJ7AFC8/g2LpUVUPNtYta3IOQjVWNYnKpOwvaOdJgrM5LYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0602MB3712
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
Ring and is not under control of the Kernel.

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

If the Job Ring is released from the Secure World at the later stage,
then bind can be performed, which would check the Ring availability and
proceed with probing if the Ring is released.

Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
---
Changes in V2:
- Create and export new method in CAAM control driver to verify JR
  validity based on the address supplied.
- Re-work the logic JR driver to call CAAM control method instead of bit
  verification. This ensures the actual information retrival from CAAM
  module during JR probe.
- Clean-up of internal static job indexes used during probing, new
  indexing is performed based on the address supplied in DTB node.

 drivers/crypto/caam/ctrl.c   | 63 ++++++++++++++++++++++++++++++------
 drivers/crypto/caam/intern.h |  2 ++
 drivers/crypto/caam/jr.c     | 33 ++++++++++++++++---
 drivers/crypto/caam/regs.h   |  7 ++--
 4 files changed, 87 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 7a14a69d89c7..ffe233f2c4ef 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -79,6 +79,42 @@ static void build_deinstantiation_desc(u32 *desc, int handle)
 	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
 }
 
+/*
+ * caam_ctrl_check_jr_perm - check if the job ring can be accessed
+ *				from Non-Secure World.
+ * @ctrldev - pointer to CAAM control device
+ * @ring_addr - input address of Job Ring, which access should be verified
+ *
+ * Return: - 0 if Job Ring is available in NS World
+ *	    - 1 if Job Ring is reserved in the Secure World
+ */
+inline int caam_ctrl_check_jr_perm(struct device *ctrldev, u32 ring_addr)
+{
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
+	struct caam_ctrl __iomem *ctrl = ctrlpriv->ctrl;
+	u32 ring_id;
+
+	ring_id = ring_addr >>
+		((ctrlpriv->caam_caps & CAAM_CAPS_64K_PAGESIZE) ?
+		16 : 12);
+	/*
+	 * Check if the JR is not owned exclusively by TZ,
+	 * and update capabilities bitmap to indicate that
+	 * the Job Ring is available.
+	 * Note: Ring index is 0-based in the register map
+	 */
+	if (!((rd_reg32(&ctrl->jr_mid[ring_id - 1].liodn_ms)) &
+		MSTRID_LOCK_TZ_OWN)) {
+		ctrlpriv->caam_caps |= BIT(ring_id);
+		return 0;
+	}
+
+	/* Job Ring is reserved, clear bit if is was set before */
+	ctrlpriv->caam_caps &= ~BIT(ring_id);
+	return 1;
+}
+EXPORT_SYMBOL(caam_ctrl_check_jr_perm);
+
 /*
  * run_descriptor_deco0 - runs a descriptor on DECO0, under direct control of
  *			  the software (no JR/QI used).
@@ -612,7 +648,7 @@ static bool check_version(struct fsl_mc_version *mc_version, u32 major,
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
-	int ret, ring, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
+	int ret, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
 	u64 caam_id;
 	const struct soc_device_attribute *imx_soc_match;
 	struct device *dev;
@@ -803,20 +839,27 @@ static int caam_probe(struct platform_device *pdev)
 #endif
 	}
 
-	ring = 0;
 	for_each_available_child_of_node(nprop, np)
 		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
 		    of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
-			ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
-					     ((__force uint8_t *)ctrl +
-					     (ring + JR_BLOCK_NUMBER) *
-					      BLOCK_OFFSET
-					     );
-			ring++;
-			ctrlpriv->caam_caps |= BIT(ring);
+			u32 ring_id;
+			/*
+			 * Get register page to see the start address of CB
+			 * This is used to index into the bitmap of available
+			 * job rings and indicate if it is available in NS world.
+			 */
+			ret = of_property_read_u32(np, "reg", &ring_id);
+			if (ret) {
+				dev_err(dev, "failed to get register address for jobr\n");
+				continue;
+			}
+			caam_ctrl_check_jr_perm(dev, ring_id);
 		}
 
-	/* If no QI and no rings specified, quit and go home */
+	/*
+	 * If no QI, no rings specified or no rings available for NS -
+	 * quit and go home
+	 */
 	if (!(ctrlpriv->caam_caps & CAAM_CAPS_QI_PRESENT) &&
 	    (hweight_long(ctrlpriv->caam_caps & CAAM_CAPS_JOBRS_MASK) == 0)) {
 		dev_err(dev, "no queues configured, terminating\n");
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 37f0b93c7087..8d6a0cff556a 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -115,6 +115,8 @@ struct caam_drv_private {
 #endif
 };
 
+inline int caam_ctrl_check_jr_perm(struct device *ctrldev, u32 ring_addr);
+
 #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 
 int caam_algapi_init(struct device *dev);
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 7f2b1101f567..e1bc1ce5515e 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -90,7 +90,7 @@ static int caam_reset_hw_jr(struct device *dev)
 
 	if ((rd_reg32(&jrp->rregs->jrintstatus) & JRINT_ERR_HALT_MASK) !=
 	    JRINT_ERR_HALT_COMPLETE || timeout == 0) {
-		dev_err(dev, "failed to flush job ring %d\n", jrp->ridx);
+		dev_err(dev, "failed to flush job ring %x\n", jrp->ridx);
 		return -EIO;
 	}
 
@@ -101,7 +101,7 @@ static int caam_reset_hw_jr(struct device *dev)
 		cpu_relax();
 
 	if (timeout == 0) {
-		dev_err(dev, "failed to reset job ring %d\n", jrp->ridx);
+		dev_err(dev, "failed to reset job ring %x\n", jrp->ridx);
 		return -EIO;
 	}
 
@@ -489,7 +489,7 @@ static int caam_jr_init(struct device *dev)
 	error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARED,
 				 dev_name(dev), dev);
 	if (error) {
-		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
+		dev_err(dev, "can't connect JobR %x interrupt (%d)\n",
 			jrp->ridx, jrp->irq);
 		tasklet_kill(&jrp->irqtask);
 	}
@@ -511,10 +511,33 @@ static int caam_jr_probe(struct platform_device *pdev)
 	struct device_node *nprop;
 	struct caam_job_ring __iomem *ctrl;
 	struct caam_drv_private_jr *jrpriv;
-	static int total_jobrs;
+	u32 ring_addr;
 	struct resource *r;
 	int error;
 
+	/*
+	 * Get register page to see the start address of CB.
+	 * Job Rings have their respective input base addresses
+	 * defined in the register IRBAR_JRx. This address is
+	 * present in the DT node and is aligned to the page
+	 * size defined at CAAM compile time.
+	 */
+	if (of_property_read_u32(pdev->dev.of_node, "reg", &ring_addr)) {
+		dev_err(&pdev->dev, "failed to get register address for jobr\n");
+		return -ENOMEM;
+	}
+
+	if (caam_ctrl_check_jr_perm(pdev->dev.parent, ring_addr)) {
+		/*
+		 * This job ring is marked to be exclusively used by TZ,
+		 * do not proceed with probing as the HW block is inaccessible.
+		 * Defer this device probing for later, it might be released
+		 * into NS world.
+		 */
+		dev_info(&pdev->dev, "job ring is reserved in secure world\n");
+		return -ENODEV;
+	}
+
 	jrdev = &pdev->dev;
 	jrpriv = devm_kzalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
 	if (!jrpriv)
@@ -523,7 +546,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 	dev_set_drvdata(jrdev, jrpriv);
 
 	/* save ring identity relative to detection */
-	jrpriv->ridx = total_jobrs++;
+	jrpriv->ridx = ring_addr;
 
 	nprop = pdev->dev.of_node;
 	/* Get configuration properties from device tree */
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 186e76e6a3e7..c4e8574bc570 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -445,10 +445,11 @@ struct caam_perfmon {
 };
 
 /* LIODN programming for DMA configuration */
-#define MSTRID_LOCK_LIODN	0x80000000
-#define MSTRID_LOCK_MAKETRUSTED	0x00010000	/* only for JR masterid */
+#define MSTRID_LOCK_LIODN		BIT(31)
+#define MSTRID_LOCK_MAKETRUSTED	BIT(16)	/* only for JR: masterid */
+#define MSTRID_LOCK_TZ_OWN		BIT(15)	/* only for JR: owned by TZ */
 
-#define MSTRID_LIODN_MASK	0x0fff
+#define MSTRID_LIODN_MASK		GENMASK(11, 0)
 struct masterid {
 	u32 liodn_ms;	/* lock and make-trusted control bits */
 	u32 liodn_ls;	/* LIODN for non-sequence and seq access */
-- 
2.25.1

