Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78549C11F67
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 18:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59B2B61410
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 18:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhGAS7Z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jul 2021 14:59:25 -0400
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:26413
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232626AbhGAS7Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jul 2021 14:59:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMbPyVU97C/SauLt0jNoTCYwGtIpVrUdBwmnzV1kNBLjQ9jEFtrqWHW2vGnvEEpylh17bbQl0QyrSPgIvTRLc3NUMOM+Ib+Ed/MRo7jRU20PFHwDu8mGli3mB1A3hBBSxp02L27nl6GUQ+rpRjJ8Zknrq5qK8LGVLDgIqTXeBLpWtDqOtjl7MA3HGmu3N3rubXmr4coEk4oskVh6nGXNJ8RnJ5aBTWJ2rMq3F8/YB4CLPsi1ovrEDo+DTesdBZdBoZJ2JJ7CUoB9m92BH4Ay/phVelx62xAZ6C5slYouxxsMdOEA+7uAp3VvFSqIAC7WF72yW+AMe6CUsGPCxk4+1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsY2HK1AjF8B0pLFtfaWenBEdRI/3UDtpvdK/k+UvMQ=;
 b=TUcnOz34j+5oDYrQr8zpLq/+Tll2Xw5KEPxDxEF99gQQScdQwRlWPSijstuw3LqCdyvMGXaBih05A/7w2MKvGBV8T/2TetScRng28KKgb1dQjzVUiF4Zw6j5DttRmFfAYFjmX1NwJPrqEcmbxvW/uQwmNy4jZ3mI2LCGlJBB/BULRam1wVafka7RR/rmG+XSFKqY9LylRC+PFeaZs4rLx1pSYX2U0rQsI8BhqUvXMG4AsoAIJ9kvjwLjylRs8XFfwd7hC7SF0pkGylgpcdL7lcymFn/ds9mXRfXaepeh0NDx7+bcH7sRP01WCsbm1rLzM0Bb9TZ92DRecNX++p6vuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsY2HK1AjF8B0pLFtfaWenBEdRI/3UDtpvdK/k+UvMQ=;
 b=iiwlQB+4AdBdiNLg2BIHsspKUdxEvjq60SFfiPaa4ov0amW7Xw1LZFXCvMH1fp1RkFke+sv0isSOHuG87HZ5bSNZGm4+/F0H9f/+Hz5XoeIdmEX/2wqc7slHEvub/XsBOwPUoRROSVWH0tl0ywVbhIbXkjpIhGUY0c9p6EQBze0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4618.eurprd03.prod.outlook.com (2603:10a6:10:18::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Thu, 1 Jul
 2021 18:56:50 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b%5]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 18:56:50 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Richard Weinberger <richard@nod.at>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 1/2] crypto: mxs-dcp: Check for DMA mapping errors
Date:   Thu,  1 Jul 2021 14:56:37 -0400
Message-Id: <20210701185638.3437487-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210701185638.3437487-1-sean.anderson@seco.com>
References: <20210701185638.3437487-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [50.195.82.171]
X-ClientProxiedBy: MN2PR15CA0050.namprd15.prod.outlook.com
 (2603:10b6:208:237::19) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR15CA0050.namprd15.prod.outlook.com (2603:10b6:208:237::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Thu, 1 Jul 2021 18:56:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fb42a70-6398-4b8b-5fb0-08d93cc1fc3b
X-MS-TrafficTypeDiagnostic: DB7PR03MB4618:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR03MB461888D3E4064A13D6C03A2296009@DB7PR03MB4618.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M7m25XE1ZQUhpNLI4FYC4eZ3JVcRyMKoa0xJh5go9jtpw/xp1rxiegHS9uSzH+EwC2lDKYsuqHoPxWEHLEUEKyH0ibpAdQuzbLK9imrXUo4SpW5FEzpDpykvXjSgqEe/uhFhDipvPS6sKqqy+oaE9hvIh+wMThPnlTuNXJGPrxM59EIYFclq3vUr8EfUVssSEm1OHJcknGFMQ3ZN/qE2d6HFqsdhFhCT9JCUPl12uFvilIfCgElHQcoYZ8fsCwPPVmA83480v+VbVo/IiDNS+XgkioppYUsux8a6wwwTEFPO+ubIqXYdCJJZMJgA3tL6NwtCcAd8cwgW0ZIi2Pfqg9d7RnVveFR39MmT5EVyjLKrGdjHDh8XcfRS4sHU+xAwUYS/AM52Q0iTdIKiEMNKN8FFCNmx5CXRmIBCgQ5sGAhJiTx10x+TC4X1P+I/0hzwUZzU4yEoNF+GVb9YNJODbDoRhIxFiOHRKw94j+xzAfsbGZ/D1wZ4ZDhYNEMQH/4roQF4D8O+rLFVW8A1wbm9hxFd1lTKVccB8K0raX8zTC96jL2O1863gGW7lhTQIqqhfvFoEJWqYhoNP1ljy0jP27VFRoUS5t7GxymEUyUuo5x5kI1Hi9lDp4C4/7iZZBrUoAmUkO+zaD3hA4Wv9xzvDCCYkaM+41OdTtpnHEdI7f0YmkwSU+y49tOzZZcISNZmJAwv5t7GCI66Gsq8FFa6gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(39830400003)(396003)(54906003)(6486002)(110136005)(6666004)(316002)(8676002)(66556008)(38350700002)(83380400001)(38100700002)(956004)(6506007)(66476007)(186003)(26005)(66946007)(16526019)(2616005)(478600001)(86362001)(2906002)(8936002)(1076003)(4326008)(5660300002)(6512007)(52116002)(44832011)(36756003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JukDehaCacuDGCkppdNz1zsGbUGQbNuENVkq/V0YAb3BFzsleYMZvDVSYrec?=
 =?us-ascii?Q?4wH+RX/6Yo8/sezHrn98wA+WH5AC7NYfxqD5+Q0X3LSMU49LshP7c3JmOVOf?=
 =?us-ascii?Q?nHx2yjVzxpQ1GvXAgPaKK8vO5Lsr2FWzutv/FhMFL5rm8iuyE+9sc41PfkEC?=
 =?us-ascii?Q?mEZEo6A2lWHRl8mUKkzU2ht6iU8M9xrIHiw0Qt8iBBAGSEM4lF3IgEoBCAH6?=
 =?us-ascii?Q?DRTznSNDYJPIJmWvOFsqDGMna+MevGFDsyig/RPo44zhQ1c9xhPDgkjdoBqN?=
 =?us-ascii?Q?bH5mbO8CRMgCrb+pLuwn2leH1k6dohlUshk6Bn0YvxjhDnCQnlA1QEtzMrAy?=
 =?us-ascii?Q?C/GCpvomlDbW0DKpfsQhVIvLNMU4rTyyR4GZQHNQ1NryVVAiFXDzDdXH9Ft+?=
 =?us-ascii?Q?6k0gdk7774XAKHSSY5Wk/YvpInyCyCx21Yss2ICq6GzCEfwzyCccrbe8jv3z?=
 =?us-ascii?Q?kgu3rfXq5fs8AAL2pyFy+JFKjGwbxSg/onX3u3kgOopE2hJMQleR6mxIbsOP?=
 =?us-ascii?Q?GmCrEMzV8ob/wwK63WEU2Dhcg8UQKo9gXvIw8VcTeAoNc07+Y2OCpc1927wo?=
 =?us-ascii?Q?t/9iNB9jftIJ5FMZSrSni63Q2y3gFIAvcY+88p01hy8UE7onOBdy1apQBrS1?=
 =?us-ascii?Q?fu3+eatmcAkT9/1Godwx8M845KjsPE+Jc2mBmJirA3PKmBV68voC5m03hQ3L?=
 =?us-ascii?Q?pdp4ICK9ZRirD/ISLlhqtVEgOxbVKMKBCLlyVz6aEcRBlUQ6b5SwGreCbpjb?=
 =?us-ascii?Q?WxOWxh+JcK8wS4LPyErpE5ZwlmiaTMSIUMQ2T5BzzcInkBzhCqCgxET5fihR?=
 =?us-ascii?Q?tw1wz/c+ZeRjdqS8CklqwpEbk++zfGHiwOxjY863Ea6p6wKwfVHG4taECixv?=
 =?us-ascii?Q?q6hVkoChPdJtKz7mn+bQVy+NQRthqwhrZE/rHxc5QaXQwEzFvSN84mwnxC6i?=
 =?us-ascii?Q?hx0tVwfaR0llwXvE6o1seLCPj2iXiNMbuJLqZ5X6FtS6jzbIFi+N73PLGbK9?=
 =?us-ascii?Q?qL4U2GxEPSMFlKkyIizIbToAdi/rF5VkvHB3qNEX64+fDzCtxave3w98zDqw?=
 =?us-ascii?Q?lCVqKZR7cFRplUGm2hXZ43i3KXVP8/eULmHqjsXZsnG5a/jWZI9JFn5tCDUN?=
 =?us-ascii?Q?t+Mz80OP26JkgPOHV10Raj9j9FvHrIrLHeLBF1fOtdcJMdzBDKOGZaCyo3kh?=
 =?us-ascii?Q?evsWFA76aEYHcy7AvY0SgKyGxk2NNjelUDHgYrh81kK3vwxfxr+SDGOrKWy/?=
 =?us-ascii?Q?fFRyo6FkrzJLYst0IEbAZ3g4Tdji8Ahn+SEE/SRxSh4FeE3QZWZP3qCpI20c?=
 =?us-ascii?Q?rXJ+TDW7ZpzbPHqfxNqPipd4?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb42a70-6398-4b8b-5fb0-08d93cc1fc3b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 18:56:50.9079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4a5hcidcNPrUQxLD9K9Wx5zmhsoxiKDEd4gcJiOimSJM2uaLphNy7ojMl6bhcEofUBMsbGFgnufGxDpSKolfcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4618
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After calling dma_map_single(), we must also call dma_mapping_error().
This fixes the following warning when compiling with CONFIG_DMA_API_DEBUG:

[  311.241478] WARNING: CPU: 0 PID: 428 at kernel/dma/debug.c:1027 check_unmap+0x79c/0x96c
[  311.249547] DMA-API: mxs-dcp 2280000.crypto: device driver failed to check map error[device address=0x00000000860cb080] [size=32 bytes] [mapped as single]

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/crypto/mxs-dcp.c | 45 +++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d6a7784d2988..f397cc5bf102 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -170,15 +170,19 @@ static struct dcp *global_sdcp;
 
 static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 {
+	int dma_err;
 	struct dcp *sdcp = global_sdcp;
 	const int chan = actx->chan;
 	uint32_t stat;
 	unsigned long ret;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
-
 	dma_addr_t desc_phys = dma_map_single(sdcp->dev, desc, sizeof(*desc),
 					      DMA_TO_DEVICE);
 
+	dma_err = dma_mapping_error(sdcp->dev, desc_phys);
+	if (dma_err)
+		return dma_err;
+
 	reinit_completion(&sdcp->completion[chan]);
 
 	/* Clear status register. */
@@ -216,18 +220,29 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 			   struct skcipher_request *req, int init)
 {
+	dma_addr_t key_phys, src_phys, dst_phys;
 	struct dcp *sdcp = global_sdcp;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	int ret;
 
-	dma_addr_t key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
-					     2 * AES_KEYSIZE_128,
-					     DMA_TO_DEVICE);
-	dma_addr_t src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
-					     DCP_BUF_SZ, DMA_TO_DEVICE);
-	dma_addr_t dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
-					     DCP_BUF_SZ, DMA_FROM_DEVICE);
+	key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
+				  2 * AES_KEYSIZE_128, DMA_TO_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, key_phys);
+	if (ret)
+		return ret;
+
+	src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
+				  DCP_BUF_SZ, DMA_TO_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, src_phys);
+	if (ret)
+		goto err_src;
+
+	dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
+				  DCP_BUF_SZ, DMA_FROM_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, dst_phys);
+	if (ret)
+		goto err_dst;
 
 	if (actx->fill % AES_BLOCK_SIZE) {
 		dev_err(sdcp->dev, "Invalid block size!\n");
@@ -265,10 +280,12 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 	ret = mxs_dcp_start_dma(actx);
 
 aes_done_run:
+	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
+err_dst:
+	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
+err_src:
 	dma_unmap_single(sdcp->dev, key_phys, 2 * AES_KEYSIZE_128,
 			 DMA_TO_DEVICE);
-	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
-	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
 
 	return ret;
 }
@@ -557,6 +574,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	dma_addr_t buf_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_in_buf,
 					     DCP_BUF_SZ, DMA_TO_DEVICE);
 
+	ret = dma_mapping_error(sdcp->dev, buf_phys);
+	if (ret)
+		return ret;
+
 	/* Fill in the DMA descriptor. */
 	desc->control0 = MXS_DCP_CONTROL0_DECR_SEMAPHORE |
 		    MXS_DCP_CONTROL0_INTERRUPT |
@@ -589,6 +610,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	if (rctx->fini) {
 		digest_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_out_buf,
 					     DCP_SHA_PAY_SZ, DMA_FROM_DEVICE);
+		ret = dma_mapping_error(sdcp->dev, digest_phys);
+		if (ret)
+			goto done_run;
+
 		desc->control0 |= MXS_DCP_CONTROL0_HASH_TERM;
 		desc->payload = digest_phys;
 	}
-- 
2.25.1

