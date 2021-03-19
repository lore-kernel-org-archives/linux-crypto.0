Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229B5C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 00:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6CA364F1F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 00:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhCSAYF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 20:24:05 -0400
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:11429
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231365AbhCSAXm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 20:23:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AM6dn8xQmgD3Vh03AuchpTgZbiiVN6rqmNC3c0P28HsxoAqC8T5PFewBdCT4y0kUWdGAixveHf10ArJPGEVE49hjVB7cJEgUMSa1XLU+iUJNleE0UQm9lrszcFc/DX2tRdZIOh2+zq5ZoSDZw/5hcY9nVRMa/flyc//EGpjnNDsdE9zBgBzqs3jJ4yNrJhntcgqrqdxy622SA2NYtMt0MLFNs/0qpzpBezUbrXDTGwUNChTEI1f9bIvorkbiADRAKG9UII3BEt2b0z55YMspx0SfIq9TEYLWr00ZnBi022M0FirHi8MPOoH6PnbA3/6NVhBkLg1WgepqDswMKTr/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o61QROWbW6s6oKN1oMGH8vDGJBWyCF9dJmvBUxxchwQ=;
 b=BmWAIaoyr0qihiiy7tHyW4kvLuBCtuRYU2RmOZIXuuoZqrI9tA+n/eNJZX2KVK1QS1jen7F0cjdPK8T8xKM/ijm1YEne6QANmxo1VvTMsbjEUC9mCN+fP6KK6vMaGzdl4UbnGAMAmSBb0qjTzQtopYDtjZ0gjbpLEUB9WFN0yd6qnIbQoMXGRmu0Sga0/HQkpdkGJfmUr2WRoDTCiCLhElpi93KnJB1UMT5LQ6KZ1gsA9RFTZoXQLeObr7wkKKTt7Ri0KqvMWdX9Z+G+4Tog8lNfpISxIEazxGFvUBegob2oG4TLvu+Pgh1L4gfmBsSuU3cLIq3lK+lB3VeHI9SmVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o61QROWbW6s6oKN1oMGH8vDGJBWyCF9dJmvBUxxchwQ=;
 b=W5/spevbwmwXBWaDA+60TlsygYnvrXFYEMMHoGrSTKuCdybvSnyQidoWdFpQ7fvT4FghbIdW2ZvGe+1UC3FoF1aytBBm+CV9CD6QX72kUwTQzXZl5jvEv7slTLFArWbIPKv+DvjfiQKhNbbviiTKx4sbKE0STsM2n0YSm1zLWwc=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR04MB6301.eurprd04.prod.outlook.com (2603:10a6:803:f1::19)
 by VI1PR04MB4942.eurprd04.prod.outlook.com (2603:10a6:803:59::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 19 Mar
 2021 00:23:36 +0000
Received: from VI1PR04MB6301.eurprd04.prod.outlook.com
 ([fe80::94cd:765d:2b27:7733]) by VI1PR04MB6301.eurprd04.prod.outlook.com
 ([fe80::94cd:765d:2b27:7733%3]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 00:23:36 +0000
From:   "Dragos Rosioru (OSS)" <dragos.rosioru@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     Marek Vasut <marex@denx.de>, Horia Geanta <horia.geanta@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/1] crypto: dcp - add power management support
Date:   Fri, 19 Mar 2021 02:22:57 +0200
Message-Id: <1616113377-24703-2-git-send-email-dragos.rosioru@oss.nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616113377-24703-1-git-send-email-dragos.rosioru@oss.nxp.com>
References: <1616113377-24703-1-git-send-email-dragos.rosioru@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM6P195CA0053.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::30) To VI1PR04MB6301.eurprd04.prod.outlook.com
 (2603:10a6:803:f1::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1664-206.ea.freescale.net (83.217.231.2) by AM6P195CA0053.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 00:23:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9864f546-325c-4647-6a12-08d8ea6d3cb4
X-MS-TrafficTypeDiagnostic: VI1PR04MB4942:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB494209AD5277E58075C8CCDFDF689@VI1PR04MB4942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c59x2wJC0lq+DY7Hh/uzBwYKki0frsj2nXz2vQ3VBp9lM568BX4yqsQqsrsWIRX/RD39wat80/IEcWKk7FZgSRu55b6U1kUws2Ge6FNNnZw7zPUL1+2NgExOPZyUzU7FGY4Oc1yTRkGRR0nLx2XCRv8UoZqwK4c4aXO5wOOB+5iMc7ozPKypSAzAsXS527S8iG66gRxvJXAQVOAWqJCnZMgZbqLVNt9V4CfyH61/dpfBw4TtVz+FXZ/ycthnFANG8pnwOrmuVXhSbpDcxeDnj3MnTs9Jn/tt++qds3nFo3bNCa4e37rAlWFSJnWNRdt2zAXw1QHBDNhRnxiUYw70P/i2DbclSod2BpNuBwbazMEhy+yGISIDqa1a7z8+Pu/H+n5bH6YSph2Wh96ECzKsaaw2okjWukzzEInu+8cPjGJrkqlQx44RJzEYB32QV1qPF3JhrCa8eRzKgA8ywlw/GEJ7O4eZUlmXlMTbf7GzVh+AB/QkSYipBCpVSlIcrouZv2PKHdYDvIOUDF8fYaqJinqjxjQaL9bjF7kvpHpG+Wmmfv0wVB2NJUtPSxHSUB2gjftBQ8CG4i8SZbOMI/uREud4ze7X7aSUanzvdQZdAsRGhrTZYuWPbfGLi2yWnKjs8aauKtePTmS6bLjhJ3QNwlAAE81NjrLKJQ6Q9aMJgvk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6301.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(66946007)(6666004)(26005)(52116002)(5660300002)(956004)(83380400001)(66476007)(66556008)(186003)(38100700001)(4326008)(86362001)(54906003)(7416002)(8936002)(316002)(6486002)(6506007)(6512007)(8676002)(478600001)(110136005)(2906002)(2616005)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?I/dwundWHbp0F23U1N7qAV9+UCkbFMUJ1JPHXBrOhyY0SZzNazN32+yxJpjY?=
 =?us-ascii?Q?WiYKlgjn1bRXVS+TYami9bimCmUikwqNh63NDNyeNx69/gQcGoYwggfjK67B?=
 =?us-ascii?Q?EFzo6XJsqopve4bEPRYWr5PEjWag/5wgXRIwVwmcvd0OeJAYxCmkvsfaFifm?=
 =?us-ascii?Q?7uh8PZppRik3IJ6duWu+vu/i/h7GcjN3elDdfetsHQ13DmZOjzeTSIB5cjhY?=
 =?us-ascii?Q?dLJRZgMHhU1ymnLbUxOWxiCSVKRzpX9zPlV2AaJbcCHPL0NyAXuEwV/a9Q44?=
 =?us-ascii?Q?ttce/DpM3We24s5L4vQXKQXdxuugmGS1T9KIKgcEtbzBkFTw7e8kPWOTWJ3A?=
 =?us-ascii?Q?SXQupBIQt+MTsL/KWwQAPxdxED8IXoaXWoGgvWUQOLSMpbKwgkutVKocKhNt?=
 =?us-ascii?Q?x72aKyuMziadaE+I1NXILgCPuHuhxTJSkoenpTKYA30ZK18Bt+63CAIEpDx8?=
 =?us-ascii?Q?wE2I0D+NJmpIx++xEDFhJBb5HVge91VGQYNiz6nh3TczY8UFveY87z1rlhH1?=
 =?us-ascii?Q?D4NiC58M4UutM++yUZnqFVsO6FhSZNcELr+49dkq0LBf3UF3Q2T/l8ysFrMq?=
 =?us-ascii?Q?1U/q9iVgMeGHvmh58FY6tbnhfdlhrXiBi+pEwAiKqqQ6zkMOs1YjxanZoAy4?=
 =?us-ascii?Q?Jg3yOyBA+klCSXbf6bymAbduBT+yDdAWb3wAeii9Wg4uxhb/iz1djDRRjpQl?=
 =?us-ascii?Q?hHHTU5hgaNuvQZvJSF3/iykiib9X+j/rIRWMSFH69kVfjXaUUYdN9TvEP+p0?=
 =?us-ascii?Q?d2CkPPhrpHkXKEYHdWZQ0YXyFrT+Ssc5A7j3VlMGoWDsLtfQm/uJtR4VsUMw?=
 =?us-ascii?Q?AIl8OaxQyZOMNgD+WbUdwqyClSV36DdGWCquuxWgptypcqimSeJYheg0dgOf?=
 =?us-ascii?Q?qNr8tJdbN1qQuxcwsJfNKZSyC8+XS5FMPavpqimAeYdCHzRru4msZ8IL9iJs?=
 =?us-ascii?Q?28+WKuqiN204bcpAAcdgR1oEtJ9FZh8Flj+2JT1aiQ+8OTv2HXs5ukjFCuSC?=
 =?us-ascii?Q?edILZQiIM0ZZwdl/kHQgyNOSIQJrrLipc12ON7I3In6LK1rHW02Fw8T+PSIt?=
 =?us-ascii?Q?cS/bGT2QJBEbiFB24P1kjBHM9Bix5S2/z5sHCFSDDED+q0Dzz2MVYvT/WtTM?=
 =?us-ascii?Q?EzeuUr5aefPe4mXL9RqqzhNOE/ZI1DGWLt/VRZHtxk+cdDn9nhv+DXfsYSUy?=
 =?us-ascii?Q?p+Z9lKD9vCdF3u/KzU52DEf/G/2fD0DcfJbRx7NB9SfP+eoXfllRw8x+H6tY?=
 =?us-ascii?Q?Mq2at8HbS6AnmYjEp/3RWQQYQmhR5WG8CycXUH7XCJc3JR+N6ckp/d19oAI7?=
 =?us-ascii?Q?5tr+wEgmDkN9W0jzR3op8zni?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9864f546-325c-4647-6a12-08d8ea6d3cb4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6301.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 00:23:36.5235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIPI12Gu71/WgmxzLWTUhNlRouF9/LMVvH7YogscPRrBHVNRMwmiBl4sBGkuUA+KYrSOouSyY5rNnXfXuBRgXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4942
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Dragos Rosioru <dragos.rosioru@nxp.com>

Added suspend/resume operations for PM support in the DCP driver.
After a suspend/resume cycle DCP would still be in a low-power mode
and have its clocks gated, thus requiring state to be saved beforehand:
- Control register value(DCP_CTRL)
- Channel control register value(DCP_CHANNELCTRL)

Signed-off-by: Dragos Rosioru <dragos.rosioru@nxp.com>
---
 drivers/crypto/mxs-dcp.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d6a7784..6748a4a 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -23,6 +23,10 @@
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 
+#ifdef CONFIG_PM_SLEEP
+#include <linux/freezer.h>
+#endif
+
 #define DCP_MAX_CHANS	4
 #define DCP_BUF_SZ	PAGE_SIZE
 #define DCP_SHA_PAY_SZ  64
@@ -124,7 +128,10 @@ struct dcp_export_state {
  * design of Linux Crypto API.
  */
 static struct dcp *global_sdcp;
-
+#ifdef CONFIG_PM_SLEEP
+static uint32_t ctrl_bak;
+static int dcp_vmi_irq_bak, dcp_irq_bak;
+#endif
 /* DCP register layout. */
 #define MXS_DCP_CTRL				0x00
 #define MXS_DCP_CTRL_GATHER_RESIDUAL_WRITES	(1 << 23)
@@ -398,9 +405,15 @@ static int dcp_chan_thread_aes(void *data)
 
 	int ret;
 
+#ifdef CONFIG_PM_SLEEP
+	set_freezable();
+#endif
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
+#ifdef CONFIG_PM_SLEEP
+		try_to_freeze();
+#endif
 		spin_lock(&sdcp->lock[chan]);
 		backlog = crypto_get_backlog(&sdcp->queue[chan]);
 		arq = crypto_dequeue_request(&sdcp->queue[chan]);
@@ -438,6 +451,10 @@ static int mxs_dcp_block_fallback(struct skcipher_request *req, int enc)
 	skcipher_request_set_crypt(&rctx->fallback_req, req->src, req->dst,
 				   req->cryptlen, req->iv);
 
+#ifdef CONFIG_PM_SLEEP
+	set_freezable();
+	try_to_freeze();
+#endif
 	if (enc)
 		ret = crypto_skcipher_encrypt(&rctx->fallback_req);
 	else
@@ -686,9 +703,15 @@ static int dcp_chan_thread_sha(void *data)
 	struct crypto_async_request *arq;
 	int ret;
 
+#ifdef CONFIG_PM_SLEEP
+	set_freezable();
+#endif
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
+#ifdef CONFIG_PM_SLEEP
+		try_to_freeze();
+#endif
 		spin_lock(&sdcp->lock[chan]);
 		backlog = crypto_get_backlog(&sdcp->queue[chan]);
 		arq = crypto_dequeue_request(&sdcp->queue[chan]);
@@ -961,6 +984,49 @@ static irqreturn_t mxs_dcp_irq(int irq, void *context)
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int mxs_dcp_resume(struct device *dev)
+{
+	struct dcp *sdcp = global_sdcp;
+	int ret;
+
+	/* Restart the DCP block */
+	ret = stmp_reset_block(sdcp->base);
+	if (ret) {
+		dev_err(dev, "Failed reset\n");
+		clk_disable_unprepare(sdcp->dcp_clk);
+		return ret;
+	}
+
+	/* Restore control register */
+	writel(ctrl_bak, sdcp->base + MXS_DCP_CTRL);
+	/* Enable all DCP DMA channels */
+	writel(MXS_DCP_CHANNELCTRL_ENABLE_CHANNEL_MASK,
+	       sdcp->base + MXS_DCP_CHANNELCTRL);
+
+	/* Re-enable DCP interrupts */
+	enable_irq(dcp_irq_bak);
+	enable_irq(dcp_vmi_irq_bak);
+
+	return 0;
+}
+
+static int mxs_dcp_suspend(struct device *dev)
+{
+	struct dcp *sdcp = global_sdcp;
+
+	/* Backup control register */
+	ctrl_bak = readl(sdcp->base + MXS_DCP_CTRL);
+	/* Temporarily disable DCP interrupts */
+	disable_irq(dcp_irq_bak);
+	disable_irq(dcp_vmi_irq_bak);
+
+	return 0;
+}
+
+SIMPLE_DEV_PM_OPS(mxs_dcp_pm_ops, mxs_dcp_suspend, mxs_dcp_resume);
+#endif
+
 static int mxs_dcp_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -980,7 +1046,10 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	dcp_irq = platform_get_irq(pdev, 1);
 	if (dcp_irq < 0)
 		return dcp_irq;
-
+#ifdef CONFIG_PM_SLEEP
+	dcp_vmi_irq_bak = dcp_vmi_irq;
+	dcp_irq_bak = dcp_irq;
+#endif
 	sdcp = devm_kzalloc(dev, sizeof(*sdcp), GFP_KERNEL);
 	if (!sdcp)
 		return -ENOMEM;
@@ -1172,6 +1241,9 @@ static struct platform_driver mxs_dcp_driver = {
 	.driver	= {
 		.name		= "mxs-dcp",
 		.of_match_table	= mxs_dcp_dt_ids,
+#ifdef CONFIG_PM_SLEEP
+		.pm = &mxs_dcp_pm_ops
+#endif
 	},
 };
 
-- 
2.7.4

