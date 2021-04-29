Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94C3C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 14:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75FEA61445
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 14:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbhD2ODU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Apr 2021 10:03:20 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:7361
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238948AbhD2ODS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Apr 2021 10:03:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXcSr7ZR14UEAogD7g2cAxmTVsHuO0ewHzhgFLLj9gnnGzKFOJ9m5lo3VrWtMPYL5D9A7o2yJil/JMXxsuvnP6ze3jmUGUjONBWkUQPQs8hosZsXViJ3lj33sJ13n//Qv8iYvQSU8m9WMKkl7l3pxNVDjqLI/ldVfv6885BjSaxBFv2gEpd68KwSqGCpf5gYdKXEWSIf6LLMnTg2vg7o8xN6+v6HzjrVzPjWmlO6NSITQYQwZu+03rknt5eMlfjbgJgwX11rJebStJb5QtLYryrm9x7jKaJyByldTnXaDttQ+K/g+54os/eTAWafS7dfQs4mOXbUyLu7/VoBfzl7Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eow9SJEOpYXenpeP2qKJNxF9qUWyaoyiFaLEv306eWg=;
 b=n24vFH4HomCAix5HsPkwu2Mv5OgqUzSHGwrq7oqdTM8XsnhPbqRczSdC5OU4eLlpCWudVmzt5hsTGAnLyCsKWq1cBJRLRbwI4Qv8/A9PDI9RL9tJy2h0MdEiYWjBrCpIkZkZi+3hPci6Z6jEfvyfoop7aE7deu14z2Jh4Hclr7UWSLTVpAgSMonvYPRtn9UWTmIJNoWgyP70kaTJuBx1xqYqJzcI59aDeGYpb04w0zUw6TTIhgI85Tw5OCLf3aMQ1RRK2TssGqrv2G6KYjpf8WswrwaWA8583fJUuk+KhmXcLu6uoMiF383FAiLUUL3I8J5KOt60AB5xm0TEFZTvvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eow9SJEOpYXenpeP2qKJNxF9qUWyaoyiFaLEv306eWg=;
 b=Hjfd1ZJjcsGjWK2xlrKVJvt3+RjmVI45plWtxbAsQA1mcF3qAa60dWF2PtFWZ18GYpsc2nL+x0Uc7GMBgTaPEj4vvdv5aNEwg9zWchKSuqK8hzgHbi/DAoMXD0N5bd+urGpN3w0ZwnBMHbItz0GWF8u9W4UcSIIqpXOoD0oi8Ys=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com (2603:10a6:20b:b9::10)
 by AM6PR04MB5239.eurprd04.prod.outlook.com (2603:10a6:20b:7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 29 Apr
 2021 14:02:28 +0000
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18]) by AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18%4]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 14:02:28 +0000
From:   "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
To:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        dominique.martinet@atmark-techno.com
Cc:     linux-imx@nxp.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v1 1/2] caam: imx8m: fix the built-in caam driver cannot match soc_id
Date:   Thu, 29 Apr 2021 22:02:49 +0800
Message-Id: <20210429140250.2321-1-alice.guo@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: AM0PR02CA0206.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::13) To AM6PR04MB6053.eurprd04.prod.outlook.com
 (2603:10a6:20b:b9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nxf55104-OptiPlex-7060.ap.freescale.net (119.31.174.71) by AM0PR02CA0206.eurprd02.prod.outlook.com (2603:10a6:20b:28f::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Thu, 29 Apr 2021 14:02:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86fd1d8d-94a7-4c0a-dcaf-08d90b176c56
X-MS-TrafficTypeDiagnostic: AM6PR04MB5239:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB523915CEBCB15B8A411890F7A35F9@AM6PR04MB5239.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T2NESI4Qpt4gaGTPg2fsEBJLZIe194gUSrVuJ51cH7PLRX8vmNqkJdmkwxPoJG5PETCcBCM5AcuBBHK3iGmo+mmR9M/JXnvnF8Ti+/W3uMOQkHTznIi/pfnghzxSk2ALEAzDCbQ0w9IwJfXJGEIBhmcq1PCrmYBGlFD/2+cUqG2TRvpv1cUKro3CoDo1iFk2syFA3LmV3X4RZV0cw/QAlC3mCQnEhY9BpL9MIK83tV559YsPFPYy9mehP9DEBO/ySOFpe3cCOdxSOV19Ddayo4vTceKKvJ6LjddNw3c7m+4k5DOI5fPoT627rLNmoqBBz1kIR9GfMPtqbbdZ8sGwW3E4XmT3WorXECG4PW1ilwNJgMFSGxSGQ2NOwXb4SXtJwG47DA06v/eiokI09Vt8zOHbrd6cTTNyBCQdYc5k1Uo6ZtUK/ugoAJC/e7te4Yx/BiGHnPHGfmqAFl1FxqrclGtumte7MhhDA9ioE5QYc8F5BGJDb2AcD2EiIbNeSCqerBOm9zI8WW54sJ0BmUnT3j7W/4ejBU8MD7l9+efOQbF6X++1EAeFAUElAboCI+MGDJxjzO4JqmjoUkWJYOxd02zmTlurEwwGKYyQdu+58ds+zpGDoZKJVNXqxpYYtn0YqIoIKQLzDip35ny+qw2U7tlS9Xwflid5AcCw7IWgiss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(7416002)(16526019)(6506007)(38100700002)(52116002)(478600001)(6486002)(38350700002)(6666004)(66946007)(26005)(66476007)(66556008)(5660300002)(956004)(8676002)(316002)(2616005)(86362001)(8936002)(6512007)(186003)(1076003)(2906002)(4326008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KxOtQeXHJKgjIk9pZFZnaPYsGDjUexHdrc6N8tON51EvDfx2TwIaaYvn15d0?=
 =?us-ascii?Q?6HbnPDsXto2ut8kIT0KXH7hy6J3X/dhoz+me2/bDQckZ+SqFa6wiXc7klRvp?=
 =?us-ascii?Q?aHsM9Nl/ZAu4tUtUCiszrOvWpr8DzmlG8T4B+0d8y/CLbgf/EsY20HPtV12Y?=
 =?us-ascii?Q?Gfij64YehHXh3SPESyH+JnTXYsZtbCjkHelcTVFAOkhc6bz7fZzOQ8jWQ1dJ?=
 =?us-ascii?Q?/pH4F79z069J5cca1hqA4qNhUX5hAuvx/RNYvb+FyRF0BFgohmL5UJgTT0mI?=
 =?us-ascii?Q?MvIc49PRacJPYwOumzTxmO0v+LyWdzTzQ14dkWbtDUMAdptgMEE4RasEV9gQ?=
 =?us-ascii?Q?0vfE1+YzQ9KVxZArn6rek1uW7pHYSVuLSx/AyV5oTodK9wryPdp9KFf0J6bu?=
 =?us-ascii?Q?Z/crGmMoOd3VABCDxJLT6nG5+iGxhCr6JLpVTFbPvH7Wzhj+6TwSduDAJqlN?=
 =?us-ascii?Q?3NuL3l2AoZBdctCSavJRNCDnvrQDQ7oW0lyAUpxr1vKAeulmKh8ulRt3kbyj?=
 =?us-ascii?Q?DuoHdd4MSHrQT1btM7Tjfwxb3zAhMXqFrZ98BfrLLjjSJ6V2lv1x954WOpie?=
 =?us-ascii?Q?xAfXkF2h7tT3RdOD0Cj2uoYEnZ7o7pYOFm+odwY0y9QZmNkCxqeFYURBgLsb?=
 =?us-ascii?Q?acjUC0o7NnBFPZ9ZY9jeEgwYLkZBmlxqmCMSrcXMe5Jd6gjFRRkIaJac5aDy?=
 =?us-ascii?Q?+sfKXpAv2aXAauuCKIES/2ZLICljbbBXYeY0N7x2KmFs+Nxig/TM0qQLd05s?=
 =?us-ascii?Q?uy0d46LAX86HTMPNWfh/E9mNiu2Uqnm8juORfz1wdrzKPUUpo9WvIscAxHYt?=
 =?us-ascii?Q?FjLIvVhtfxjy5/i8V35Vltry3nBGdlzPUgSxT1OYwWg9dSJ8EmOsvbt2jdFn?=
 =?us-ascii?Q?lrHHKZgt9t8zxp797h/kPrubgHNTsmO0eTTU4JJq+3dCMmb2m4FX5lGyWifA?=
 =?us-ascii?Q?wS8InSlghk3SCQWm7mK76UQpOO3QCm6yutZCsjVYivVWD2vZ/TLzOIz5IuDk?=
 =?us-ascii?Q?sFgcHPhvEzX7kUF5yZ+0XdSH9DgVsPmJoKv+Kngy+pqhpGIVsn/nkJhQ8vCb?=
 =?us-ascii?Q?iDxfh28l/+cCqttpz6unsYggub7buzwotknDks0g4RRg5S0h48h0gVUW9T0b?=
 =?us-ascii?Q?iuy6vPgippJC4TCn5G85koJFhV8btGR7pCWBlkU1mTd0donrZxDfxNFwRgQP?=
 =?us-ascii?Q?+cMB9AgnigLVbJMC8o4fsQ0sWmq8KviVOS8e6dLWq4eQ5jCXYlhnQ7g0cuU4?=
 =?us-ascii?Q?SmNZgSZPYgpu9WFy81/ERlvarTbljyuoFxMpK9QYU0nkFnKwJ6IGZzdFCgA6?=
 =?us-ascii?Q?oQuDUz/X3cNmbHNoDDtkFcqg?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86fd1d8d-94a7-4c0a-dcaf-08d90b176c56
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 14:02:28.4278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAkYh2dB8VdxuZyPAIN6V1ypRnotm+SeVQRHIPtxATA1MsWVoFhF0USscbQlXHIrMwyczEgmq1RRoihbJTGw9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5239
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Alice Guo <alice.guo@nxp.com>

drivers/soc/imx/soc-imx8m.c is probed later than the caam driver so that
return -EPROBE_DEFER is needed after calling soc_device_match() in
drivers/crypto/caam/ctrl.c. For i.MX8M, soc_device_match returning NULL
can be considered that the SoC device has not been probed yet, so it
returns -EPROBE_DEFER directly.

Fixes: 7d981405d0fd ("soc: imx8m: change to use platform driver")
Signed-off-by: Alice Guo <alice.guo@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb0..9bba3b93cf35 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -79,6 +79,14 @@ static void build_deinstantiation_desc(u32 *desc, int handle)
 	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
 }

+static const struct of_device_id imx8m_machine_match[] = {
+	{ .compatible = "fsl,imx8mm", },
+	{ .compatible = "fsl,imx8mn", },
+	{ .compatible = "fsl,imx8mp", },
+	{ .compatible = "fsl,imx8mq", },
+	{ }
+};
+
 /*
  * run_descriptor_deco0 - runs a descriptor on DECO0, under direct control of
  *			  the software (no JR/QI used).
@@ -635,6 +643,8 @@ static int caam_probe(struct platform_device *pdev)
 	nprop = pdev->dev.of_node;

 	imx_soc_match = soc_device_match(caam_imx_soc_table);
+	if (!imx_soc_match && of_match_node(imx8m_machine_match, of_root))
+		return -EPROBE_DEFER;
 	caam_imx = (bool)imx_soc_match;

 	if (imx_soc_match) {
--
2.17.1

