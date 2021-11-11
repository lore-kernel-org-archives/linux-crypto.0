Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455AFC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Nov 2021 16:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 226F86124D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Nov 2021 16:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhKKQtT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Nov 2021 11:49:19 -0500
Received: from mail-am6eur05on2099.outbound.protection.outlook.com ([40.107.22.99]:38144
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234280AbhKKQtS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Nov 2021 11:49:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+X5CTb5zOBWou9KY9bVZbi8HMvmClePD7ShSR1nQHdscaTGgIfzsigc5MaZwLU1jJtlLfadSiRUrw9uxyhrm1KfYMCS1LR123r5n4I2hiQZWg6EoYVgUGBEJPtxA0/QxtWs3lu0jWBPSnk/Ml/EKmJgMXZjRValyA3xVZdJkos4I3Yg15xY00TTfnin9dXHGbhkcE6xpEWWCI0e6elM9P0jbtMF+QiqVZFR91K/9Kyaqk8iGdVohgrGL04oeSQBbsVQ528pKz/2gnNjzyB9bxYHkRp7pUDkvOQkikDbwdFwxkxKtcrufPVUpzyZs9NjAdp/p2+jk3X16yP0z5BtkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCO1ZoGwkO+sqjE2EgZnQ3Yr+kN+J1spBiLwZFl82Js=;
 b=oOD5+2gDH4zOig4GpvSvnHjaoNWugQy6ZvNkwOq9kVrrc/TY6J89RE7iEVWAEWpQd5WWkYy/yRE0KbBj3ib3NjiwBrQVlL+CJcU+0LJAJTFz9DHSBAKEbMUTNjk4e9kjCaFI4/yTx9cB2ZULqp04eypPLmbeIwUQQ4BpFRdoIWsxMky5HUaFrpw7z1yyhKBNOkil95sh5VF7DpSaU+6VhwFxx0KNH+TebVW/bG/OkrtEK6LjzJARyOJ2VOM2w4NYL2NmETm1uKnf8quyAwrYymZycDJW4huEjbckSEBeU/+qLi6/D8zkD26ANZD0+TBcI1B/fdhfl5jMst9ASZ8bwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=leica-geosystems.com; dmarc=pass action=none
 header.from=leica-geosystems.com; dkim=pass header.d=leica-geosystems.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=leica-geosystems.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCO1ZoGwkO+sqjE2EgZnQ3Yr+kN+J1spBiLwZFl82Js=;
 b=Y4Bjp2yMOW6eIMGH1aprqKnd7naHzhqvlxI8juMXiv+w3u+Jmo5eA4NzLJLHO2vlocHiXjHQ5YYKqmZKmXo4xxKfx/7GsF4BBNnFkLvqg0b7qXkN0DfkYD+ghgp+0GGgBsUU6ufYBS38RPItDYxiGLg/o8B5pEWqLZvfSX2R/wc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=leica-geosystems.com;
Received: from VI1PR06MB3102.eurprd06.prod.outlook.com (2603:10a6:802:c::17)
 by VI1PR0601MB2430.eurprd06.prod.outlook.com (2603:10a6:801:7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Thu, 11 Nov
 2021 16:46:26 +0000
Received: from VI1PR06MB3102.eurprd06.prod.outlook.com
 ([fe80::5420:b387:e6b8:9e22]) by VI1PR06MB3102.eurprd06.prod.outlook.com
 ([fe80::5420:b387:e6b8:9e22%4]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 16:46:25 +0000
From:   Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
To:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, michael@walle.cc,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Subject: [PATCH v2 1/2] crypto: caam - convert to use capabilities
Date:   Thu, 11 Nov 2021 17:46:00 +0100
Message-Id: <20211111164601.13135-2-andrey.zhizhikin@leica-geosystems.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8d5238da-678b-476e-05eb-08d9a532cd14
X-MS-TrafficTypeDiagnostic: VI1PR0601MB2430:
X-Microsoft-Antispam-PRVS: <VI1PR0601MB2430A90B66E136EA57E7189DA6949@VI1PR0601MB2430.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5tVySBUjFE5Ts2V2saEUGXDoL6ZPa2qm4juEMlDzmqxvUO0Qiz7A723LBmnxy/9FMk5fkkHX+rCLbBw6Xe1qBTP1dO63duDPpRG8qf5RpY0vzhbdeDBqet1mZlAprLuFB9TD8ab4lQi0XPLWuuVyLjj5vSsxTQYL54nLZFeqV/Ox/QLrFahmj0qiZwqB8/7jW+qz28JbPM1ff5vSjkh8bqR1uEafpna2SQKpspJqevCjX7KIacSPTro9JwvMd7I6UbOoOssg/qf4X4poM1CH8z9JAU9wiiCV7y9/ehEjmO2Sc2pmFpUq0UL79Y461j19Ahv8ySzZNZhQ0OrpAT5FygxM03KgnFb1Nq3DevOiwS50tJKGMCrXr7JwBd2Q18uLELZx0dKHiVWoET/9AxgQZ296yuzeP18yxFIfZzFmkkO+fN5SRtBMwS7JfywMzV0ZE/gcPSopL6DHuqRu7HnbrcjZYpBI/ff9HSEyLwddrvpOHgWf76DexEXxQ8+ViumujCtY32v6FyNVEwk0Oy7wB2lwsmxuNx2yN3Fq0is22DOPO7+OdUn3zaxUuq88zz7lzb/M44/Z3Vvtny9Z4yHV1ruMD/+STfcZte+ymNiqb5DVszRo6D7jyTQlkyria2NPwb0Gv+It19Y/1txSDsiaBIoLDZ872tKxwMr7pmDYrnJG7eUGKxBaOgB1NdA4B4Oiqas9WO98ww/+UbPeBFHjIZeLk7TSl09ab3T3P8XDx1M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3102.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(2906002)(8676002)(66556008)(66476007)(6486002)(508600001)(44832011)(6666004)(2616005)(956004)(8936002)(4326008)(6512007)(52116002)(83380400001)(316002)(6506007)(5660300002)(26005)(86362001)(36756003)(38100700002)(38350700002)(107886003)(186003)(1076003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W7xr8hDgB9xMpOhzr876p12hSGtm+a+Jn7b9CkiF5H/LSOmH8mnAPugX5MQ9?=
 =?us-ascii?Q?SmrUpWJTUNa485tD46K+ciRDKOYf9P3GxECdjjlXNV+I8Zug787XKvdck5ub?=
 =?us-ascii?Q?eBgVmya7ERm4y/EyN1N7a5FmfLfczeAS2LP5yQiP8gc1HW6qEV747nUebNJJ?=
 =?us-ascii?Q?8OZlbSZmoXnPsnsO1njY7UQZhZlMfEjyU4XrkXZykEdDdhT89TOgPRykzSdh?=
 =?us-ascii?Q?yhMqRc62d6pDEmRwyBZuW4qD1E6IenwiSdSkv9hx01PqsTijOL+0MXjQ9p21?=
 =?us-ascii?Q?tkffjBUDBJOtS0sud0sS2hPzRWhpaMeeVaZWmdoa62L+ya4kcRSqE158np+i?=
 =?us-ascii?Q?BzWSQkBVEDcel4XDTL8m1ialbj2EaWXvaeK6fFaGVTwQVtIuW6ZzCzCaL1Of?=
 =?us-ascii?Q?LzDxXfF5MpHfS1Ya8hyh2hv2uMo4Om3c/2pNCZpVydFehS6i5Dj88cEfsa8A?=
 =?us-ascii?Q?o4ciNQnpeyCa06+KouhMt9EG7zca9DQbkn9ghn7ZullPCLjhmQVYkRp9d/+V?=
 =?us-ascii?Q?Ez/PMy/oaXAgO8TVg1SgqTZkdDtD8ZGWQJW7lF4/wyf4IxqAMgV51PNUQOJ1?=
 =?us-ascii?Q?ghASwiwpNi/H4+XTvFrbgegmWxJ7Iq2JEPFdAW6K0UzSQfl0ylon1v00eMMv?=
 =?us-ascii?Q?axTLDjaxKLPco0TqVEFu0+qn9vsy20aC+iTzsbZ4Lg6P0eDebJhlHcPFiH1t?=
 =?us-ascii?Q?0oUfYUEaFc9SjEYtBI8uHC7UKu4nSadLaJGGELgu+J/MoS1WkxkEShBpd7T5?=
 =?us-ascii?Q?ugloPoeETdo/k3A0LCHE6Jc4VX5G91ydWepUo3BbMwOXxsc2G6cZu2WxasrH?=
 =?us-ascii?Q?8dPlNVMilgeKOvuHhbAPKV0BlCbJP9QnFDsYw3THHTVhNzBlS1Yof0uMCIRZ?=
 =?us-ascii?Q?6qu78W3/T7yT7hA/AIrLoprXVd3KVRgxGCBmVbeQhvxkSk/St7v2ofBlQM86?=
 =?us-ascii?Q?Dt7PKouPraL5bx/5t687ZSa1OssFWegcye21a+3bay3cXaaZbDVRWh8LvlnH?=
 =?us-ascii?Q?w6fV7ALD7/YkWQhM96jzVAmGTg+5rxRmeLPxsVn69jRcxyvPGVBAWNH9cTJN?=
 =?us-ascii?Q?C0UuvHsgDiwlqvJE//4JAaJq23ndOB0DG2wtw+QU24QE2Nnq1YF/V4pzFtEL?=
 =?us-ascii?Q?ktTggEWEPb9JXPj6EymaSszsS4MFl5SVLcnrFpWYlgheHQs7+MTa1Cs4EtZZ?=
 =?us-ascii?Q?+1xecmcZs9koWQxmJy32Q7Tty5mtvh/Ri12bzllg5l4H4LhgaYoSrxlnRB9t?=
 =?us-ascii?Q?o6YiRgk1tYTrJDhwhcEPykFEc4CPeh2QiX/NTdr6LuRKIDOTP16eXhmzde87?=
 =?us-ascii?Q?5zgBWhOQ7Nv5WECf8JXA85L681ffF6xcJboftWpOwFH4w+o+yXe8zjQgGIDU?=
 =?us-ascii?Q?1AekSiMQ+NgR2/tEc6f+dKZpLtjlG1wg0x5kQm7CPKX3jfvdjTC45m/IvDed?=
 =?us-ascii?Q?1T3qxneI+5ZG54TZ/4gzILCKMMlTfxCgxYufLu3Q686jUOKUshHQ5lETToKx?=
 =?us-ascii?Q?x71XEdvKbRKMQQa3GPT114PVOJc4eq5cXJbp6HTIaa+KNIaqAa1fqbDPcRqQ?=
 =?us-ascii?Q?PbDrMMvu1SZ0RWi0q17sXomt3YDOzgl1NTU1JmP7cNOVuCVl9dwlSQazrTJi?=
 =?us-ascii?Q?PLMbhqBoQK7dUhU2g3OFroQHvtoMHoFF2T54MFGRV8STb+6Xe50Q5+VKUXfv?=
 =?us-ascii?Q?MSa0P8SsO4C+uvPs8tTH3mi4nH8=3D?=
X-OriginatorOrg: leica-geosystems.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5238da-678b-476e-05eb-08d9a532cd14
X-MS-Exchange-CrossTenant-AuthSource: VI1PR06MB3102.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 16:46:25.8474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1b16ab3e-b8f6-4fe3-9f3e-2db7fe549f6a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tthMUiJF6w3dcjhcJornRA7m9v8VheO7Tb11absN7nj0SiriUfQDoGSE5m+mfQVDzIfiiA4BH5D/F0FshU/FwENS4+dBIv+n0Jwz2s567k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0601MB2430
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CAAM driver contains several variables, which are used for indication
that ertail capabilities are detected during initial probing of the
device. They are defined as u8, but mainly used as boolean variables to
identify capabillities.

Clean-up all assorted variables, collect them into one bitfield value
which encodes capabilities as bit, and use them in the execution flow
instead.

Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
---
Changes in V2: No change, this patch is newly introduced

 drivers/crypto/caam/caamalg_qi.c |  2 +-
 drivers/crypto/caam/ctrl.c       | 49 ++++++++++++++++++--------------
 drivers/crypto/caam/intern.h     | 16 +++++------
 drivers/crypto/caam/regs.h       |  2 --
 4 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 189a7438b29c..372a319e8434 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2610,7 +2610,7 @@ int caam_qi_algapi_init(struct device *ctrldev)
 	bool registered = false;
 
 	/* Make sure this runs only on (DPAA 1.x) QI */
-	if (!priv->qi_present || caam_dpaa2)
+	if (!(priv->caam_caps | CAAM_CAPS_QI_PRESENT) || caam_dpaa2)
 		return 0;
 
 	/*
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb0..7a14a69d89c7 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -100,7 +100,7 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 	int i;
 
 
-	if (ctrlpriv->virt_en == 1 ||
+	if ((ctrlpriv->caam_caps & CAAM_CAPS_VIRT_ENABLED) ||
 	    /*
 	     * Apparently on i.MX8M{Q,M,N,P} it doesn't matter if virt_en == 1
 	     * and the following steps should be performed regardless
@@ -169,7 +169,7 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 	*status = rd_reg32(&deco->op_status_hi) &
 		  DECO_OP_STATUS_HI_ERR_MASK;
 
-	if (ctrlpriv->virt_en == 1)
+	if (ctrlpriv->caam_caps & CAAM_CAPS_VIRT_ENABLED)
 		clrsetbits_32(&ctrl->deco_rsr, DECORSR_JR0, 0);
 
 	/* Mark the DECO as free */
@@ -622,7 +622,6 @@ static int caam_probe(struct platform_device *pdev)
 	struct dentry *dfs_root;
 	u32 scfgr, comp_params;
 	u8 rng_vid;
-	int pg_size;
 	int BLOCK_OFFSET = 0;
 	bool pr_support = false;
 
@@ -666,11 +665,12 @@ static int caam_probe(struct platform_device *pdev)
 	else
 		caam_ptr_sz = sizeof(u32);
 	caam_dpaa2 = !!(comp_params & CTPR_MS_DPAA2);
-	ctrlpriv->qi_present = !!(comp_params & CTPR_MS_QI_MASK);
+	ctrlpriv->caam_caps |= (!!(comp_params & CTPR_MS_QI_MASK)) ?
+		CAAM_CAPS_QI_PRESENT : 0;
 
 #ifdef CONFIG_CAAM_QI
 	/* If (DPAA 1.x) QI present, check whether dependencies are available */
-	if (ctrlpriv->qi_present && !caam_dpaa2) {
+	if ((ctrlpriv->caam_caps & CAAM_CAPS_QI_PRESENT) && !caam_dpaa2) {
 		ret = qman_is_probed();
 		if (!ret) {
 			return -EPROBE_DEFER;
@@ -692,11 +692,14 @@ static int caam_probe(struct platform_device *pdev)
 	/* Allocating the BLOCK_OFFSET based on the supported page size on
 	 * the platform
 	 */
-	pg_size = (comp_params & CTPR_MS_PG_SZ_MASK) >> CTPR_MS_PG_SZ_SHIFT;
-	if (pg_size == 0)
-		BLOCK_OFFSET = PG_SIZE_4K;
+	ctrlpriv->caam_caps |=
+		(!!((comp_params & CTPR_MS_PG_SZ_MASK) >> CTPR_MS_PG_SZ_SHIFT)) ?
+		CAAM_CAPS_64K_PAGESIZE : 0;
+
+	if (ctrlpriv->caam_caps & CAAM_CAPS_64K_PAGESIZE)
+		BLOCK_OFFSET = SZ_64K;
 	else
-		BLOCK_OFFSET = PG_SIZE_64K;
+		BLOCK_OFFSET = SZ_4K;
 
 	ctrlpriv->ctrl = (struct caam_ctrl __iomem __force *)ctrl;
 	ctrlpriv->assure = (struct caam_assurance __iomem __force *)
@@ -711,11 +714,11 @@ static int caam_probe(struct platform_device *pdev)
 	/* Get the IRQ of the controller (for security violations only) */
 	ctrlpriv->secvio_irq = irq_of_parse_and_map(nprop, 0);
 	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-mc");
-	ctrlpriv->mc_en = !!np;
+	ctrlpriv->caam_caps |= (!!np) ? CAAM_CAPS_MC_ENABLED : 0;
 	of_node_put(np);
 
 #ifdef CONFIG_FSL_MC_BUS
-	if (ctrlpriv->mc_en) {
+	if (ctrlpriv->caam_caps & CAAM_CAPS_MC_ENABLED) {
 		struct fsl_mc_version *mc_version;
 
 		mc_version = fsl_mc_get_version();
@@ -732,7 +735,7 @@ static int caam_probe(struct platform_device *pdev)
 	 * In case of SoCs with Management Complex, MC f/w performs
 	 * the configuration.
 	 */
-	if (!ctrlpriv->mc_en)
+	if (!(ctrlpriv->caam_caps & CAAM_CAPS_MC_ENABLED))
 		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK,
 			      MCFGR_AWCACHE_CACH | MCFGR_AWCACHE_BUFF |
 			      MCFGR_WDENABLE | MCFGR_LARGE_BURST);
@@ -745,7 +748,6 @@ static int caam_probe(struct platform_device *pdev)
 	 */
 	scfgr = rd_reg32(&ctrl->scfgr);
 
-	ctrlpriv->virt_en = 0;
 	if (comp_params & CTPR_MS_VIRT_EN_INCL) {
 		/* VIRT_EN_INCL = 1 & VIRT_EN_POR = 1 or
 		 * VIRT_EN_INCL = 1 & VIRT_EN_POR = 0 & SCFGR_VIRT_EN = 1
@@ -753,14 +755,14 @@ static int caam_probe(struct platform_device *pdev)
 		if ((comp_params & CTPR_MS_VIRT_EN_POR) ||
 		    (!(comp_params & CTPR_MS_VIRT_EN_POR) &&
 		       (scfgr & SCFGR_VIRT_EN)))
-				ctrlpriv->virt_en = 1;
+			ctrlpriv->caam_caps |= CAAM_CAPS_VIRT_ENABLED;
 	} else {
 		/* VIRT_EN_INCL = 0 && VIRT_EN_POR_VALUE = 1 */
 		if (comp_params & CTPR_MS_VIRT_EN_POR)
-				ctrlpriv->virt_en = 1;
+			ctrlpriv->caam_caps |= CAAM_CAPS_VIRT_ENABLED;
 	}
 
-	if (ctrlpriv->virt_en == 1)
+	if (ctrlpriv->caam_caps & CAAM_CAPS_VIRT_ENABLED)
 		clrsetbits_32(&ctrl->jrstart, 0, JRSTART_JR0_START |
 			      JRSTART_JR1_START | JRSTART_JR2_START |
 			      JRSTART_JR3_START);
@@ -785,7 +787,7 @@ static int caam_probe(struct platform_device *pdev)
 	caam_debugfs_init(ctrlpriv, dfs_root);
 
 	/* Check to see if (DPAA 1.x) QI present. If so, enable */
-	if (ctrlpriv->qi_present && !caam_dpaa2) {
+	if ((ctrlpriv->caam_caps & CAAM_CAPS_QI_PRESENT) && !caam_dpaa2) {
 		ctrlpriv->qi = (struct caam_queue_if __iomem __force *)
 			       ((__force uint8_t *)ctrl +
 				 BLOCK_OFFSET * QI_BLOCK_NUMBER
@@ -810,12 +812,13 @@ static int caam_probe(struct platform_device *pdev)
 					     (ring + JR_BLOCK_NUMBER) *
 					      BLOCK_OFFSET
 					     );
-			ctrlpriv->total_jobrs++;
 			ring++;
+			ctrlpriv->caam_caps |= BIT(ring);
 		}
 
 	/* If no QI and no rings specified, quit and go home */
-	if ((!ctrlpriv->qi_present) && (!ctrlpriv->total_jobrs)) {
+	if (!(ctrlpriv->caam_caps & CAAM_CAPS_QI_PRESENT) &&
+	    (hweight_long(ctrlpriv->caam_caps & CAAM_CAPS_JOBRS_MASK) == 0)) {
 		dev_err(dev, "no queues configured, terminating\n");
 		return -ENOMEM;
 	}
@@ -832,7 +835,8 @@ static int caam_probe(struct platform_device *pdev)
 	 * already instantiated, do RNG instantiation
 	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.
 	 */
-	if (!(ctrlpriv->mc_en && pr_support) && rng_vid >= 4) {
+	if (!((ctrlpriv->caam_caps & CAAM_CAPS_MC_ENABLED) && pr_support) &&
+	    rng_vid >= 4) {
 		ctrlpriv->rng4_sh_init =
 			rd_reg32(&ctrl->r4tst[0].rdsta);
 		/*
@@ -900,8 +904,9 @@ static int caam_probe(struct platform_device *pdev)
 	/* Report "alive" for developer to see */
 	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
 		 ctrlpriv->era);
-	dev_info(dev, "job rings = %d, qi = %d\n",
-		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
+	dev_info(dev, "job rings = %ld, qi = %s\n",
+		 hweight_long(ctrlpriv->caam_caps & CAAM_CAPS_JOBRS_MASK),
+		 (ctrlpriv->caam_caps & CAAM_CAPS_QI_PRESENT) ? "yes" : "no");
 
 	ret = devm_of_platform_populate(dev);
 	if (ret)
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 7d45b21bd55a..37f0b93c7087 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -86,15 +86,15 @@ struct caam_drv_private {
 
 	struct iommu_domain *domain;
 
-	/*
-	 * Detected geometry block. Filled in from device tree if powerpc,
-	 * or from register-based version detection code
-	 */
-	u8 total_jobrs;		/* Total Job Rings in device */
-	u8 qi_present;		/* Nonzero if QI present in device */
-	u8 mc_en;		/* Nonzero if MC f/w is active */
+	unsigned long caam_caps; /* CAAM Module capabilities */
+
+#define CAAM_CAPS_QI_PRESENT	BIT(0)	/* Queue Manager interface (QI) implemented */
+#define CAAM_CAPS_JOBRS_MASK	GENMASK(15, 1)	/* Job Ring is available in NS World */
+#define CAAM_CAPS_MC_ENABLED	BIT(16)	/* Management Complex is enabled (F/W is active) */
+#define CAAM_CAPS_VIRT_ENABLED	BIT(17)	/* Virtualization enabled */
+#define CAAM_CAPS_64K_PAGESIZE	BIT(18)	/* CAAM register page size (64KB if set, 4KB if unset) */
+
 	int secvio_irq;		/* Security violation interrupt number */
-	int virt_en;		/* Virtualization enabled in CAAM */
 	int era;		/* CAAM Era (internal HW revision) */
 
 #define	RNG4_MAX_HANDLES 2
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 3738625c0250..186e76e6a3e7 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -1023,6 +1023,4 @@ struct caam_deco {
 #define ASSURE_BLOCK_NUMBER	6
 #define QI_BLOCK_NUMBER		7
 #define DECO_BLOCK_NUMBER	8
-#define PG_SIZE_4K		0x1000
-#define PG_SIZE_64K		0x10000
 #endif /* REGS_H */
-- 
2.25.1

