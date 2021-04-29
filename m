Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9610C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 14:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D63D6143A
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 14:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbhD2OD1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Apr 2021 10:03:27 -0400
Received: from mail-db8eur05on2072.outbound.protection.outlook.com ([40.107.20.72]:47585
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239774AbhD2OD0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Apr 2021 10:03:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErEDRM/XRFnB9jhPJYYxspQy4rGUHn18bbvAeTKKo0RnbQ05bI7vYBUc4GUvltyWVKSJUFHd0nCSD6pOfWkT5p8MToc836oyEoP4beLwKFOZcrEmCn0hL7DZCZb4f1cs0KsLmXmrTQMzNJmDwt/P6gKsZii0NI69REQfIpYuWWTwG5aDqbbNvjwmBOD4GOW7PX0aAkkDcDPToSIXXG1UUJZv/Kf756fsArvAuGd8Yld2iSinO9TlkETh7+WbWCGZSd2ZWJJO8WxbczvZnW9FVZGgjYloh9fOqBQuRbDsmzdetg35pU8PlnuGiclr0XqVWz/shrLRlccYhcE3aY1tvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NociAcxzZTIRlikSkYG1+v+NaUEttJWz1llfGA3p1E=;
 b=h0eEzVPtGSRvVDLGkZPHacpiIcgtu69fC6WFEGAHY21J4oFH+cjUusRCTzvoOJI4IH0+r3dmniQqDYjwOVMN8MUO5sfoFuYoWTQoYfBNJNrUGmpECMBgXSFZAv7mlXudcc83S14eA/fJFQtfYmM8rPY6FBpoGIVFVDwa8i/MLx/QmD+sDG9fKJ7GAxqnOYynITWHmwLETRSOYaJ7viL7o5+cq0CmOM3fsVbW3c0WGPqPmQlICiq+quystZrX7B6/fx7628YVv1D+o8Lh66TYQvL9AiIhkPXeP8Fwx9LnzcH3RPMj/pWCVlGiAC5lkkP+zyHXeKjMugW2Rrg65CMWug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NociAcxzZTIRlikSkYG1+v+NaUEttJWz1llfGA3p1E=;
 b=cXEf7Y/h9gFQNdK/J+f/yOloO1DJnFac+yXERYt/TERGldOFoJkpW4p8OAduzJV/BPDEIDJUEW1eXnTXyxiaGLKtPAKriObh5/V2N3Gipze3OuGsK9UPRTT4wjVQoB4IJBnd90b00/TE37wte8sTIj1EbR3HCfcNy6Yy+vnoDJE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com (2603:10a6:20b:b9::10)
 by AM6PR04MB5239.eurprd04.prod.outlook.com (2603:10a6:20b:7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 29 Apr
 2021 14:02:37 +0000
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18]) by AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18%4]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 14:02:37 +0000
From:   "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
To:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        dominique.martinet@atmark-techno.com
Cc:     linux-imx@nxp.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v1 2/2] caam: imx8m: change to use of_match_node in run_descriptor_deco0
Date:   Thu, 29 Apr 2021 22:02:50 +0800
Message-Id: <20210429140250.2321-2-alice.guo@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210429140250.2321-1-alice.guo@oss.nxp.com>
References: <20210429140250.2321-1-alice.guo@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: AM0PR02CA0206.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::13) To AM6PR04MB6053.eurprd04.prod.outlook.com
 (2603:10a6:20b:b9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nxf55104-OptiPlex-7060.ap.freescale.net (119.31.174.71) by AM0PR02CA0206.eurprd02.prod.outlook.com (2603:10a6:20b:28f::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Thu, 29 Apr 2021 14:02:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9759063d-13c3-4d3d-a09c-08d90b17718c
X-MS-TrafficTypeDiagnostic: AM6PR04MB5239:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB52395F38AC185CDD3BE77AE7A35F9@AM6PR04MB5239.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GYK3VTd1K/cPjDNL9Qcw6axUYw9V9CPQIiEQebR04fxSpzWA8cZqbv4bfFBeb0aUeRagFL2nZbJ+AeAYkNtevYSSoXuzs6qAzNps1fNwD6KLUgDxV7oMSklh4PU5pI2RNLHdLJmDpMvCgmmEnA7YNNw4DllLAMAqG+90CoE+qK5JgRFkzdcVLhTTrmbTy8n71sMKLvsPDVS5Pdcdy7pQLcSVJpbGkXtJ/Bj4pidCnpSqDnGCSoG5A5U8NTdp8UndiXm+SCnD/HCHmqds7v0sViXN5Rrd7ZZmepy5zFHt26hYOQ/70iweFRBlmL2CRSFOz14V/SZMAV203kS0Hq18nRmxFw3Ibyf7htQRSZEFHOhNKzHX51nh+/125g9qxXH8Y7AoNC/tBVq0/0uj8BU/nMbmkvLuMzS0JYvsl38bcuf0FUqXmVj3ny2rMtEcwXZVzR03Zze77gymghlXZ98/ot8spU6EOao/WOsq9jJd+rEC1TXb6DXjESmEuXgW3t7cTUfyuXZ6PymMKHM5+1WFwsmFZ8t/1gVWnqEf4PxHaNQXhRYO3gIWHxf1J38KPqqvhS+h5Lg0W32NhB1JJE2NxZnFn7R2BrtuJus6FqEdFdRu/tSgb9XRDD/TLYCbuepEZ+kh8Qqui79nMn57wolnQIPx5blFoQrrAc0R3IGaABw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(7416002)(16526019)(6506007)(38100700002)(52116002)(478600001)(6486002)(38350700002)(6666004)(83380400001)(66946007)(26005)(66476007)(66556008)(5660300002)(956004)(8676002)(316002)(2616005)(86362001)(8936002)(6512007)(186003)(1076003)(2906002)(4326008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S4D0P2wruVCCw6hhRC7ewemjR1XFSIMGmoy5LQh/98ldKPL+YIlr3lEWh9Uj?=
 =?us-ascii?Q?WyDezqDZ5KhLH3ZGJhaXJeebKkNQFEE+Sr2RHuWwN71utW10RNyPTmq0en0x?=
 =?us-ascii?Q?v76FHqJIY1qpYNdiSCRtvd7WBLqTKvb92JYUjUnRdo91SISLP9XJuzx3FBfk?=
 =?us-ascii?Q?dslN/8tHz3Gpc2O2JYZB6tpWBohAdFtEqubZw67vGs0Qw5ncwFc9tgE2VxZa?=
 =?us-ascii?Q?hsRXFkHi/94/Xdd/pR8ruCyx4kLbQMO0EWntA8N70ZeUL44Q8IYLcO2ehuo4?=
 =?us-ascii?Q?mdiDIjTFDdbNubMJsJCB5HCClY20g4ou4wSLd+WYHBNbJ8t9duUcEhgPknEq?=
 =?us-ascii?Q?kqJ7onRRp45+YJLFyeKN1XJ9dN93gjoppxGBw+ja9dksKOccXQlZCdso5TD+?=
 =?us-ascii?Q?jPmckjmNlUiSDVC4UxuUP6/b2z22WK592XbffsTUw33zjy7dlM4+qpznSvBU?=
 =?us-ascii?Q?BU5c5VrirGl3TVz/GPWzx33aejC8/wXgXmWpu5smGWyeY2N9LMqkLlxzJqxA?=
 =?us-ascii?Q?+8AhZZYg/6TZjWw49ENVyiyXWkW1pXG3mTgnADVFaI+vehq/Sf7h9b6AL78a?=
 =?us-ascii?Q?jAKWsUc/3svo2wJNU7Xv7A7fl0mDJgHIOtOxxKUlzaEkcgXDgr3ozfNZZMAG?=
 =?us-ascii?Q?1TvA4u45T4fMZChU2GZtbA01MZU2q21p9OTKLqL3PHxAOkzbCOYsoKhf/Ibt?=
 =?us-ascii?Q?O3fADiOTwl4hs497Et+m6tRMpEW6amV0khwIwM0B1x7czmAJsdwGnBV71qSO?=
 =?us-ascii?Q?qttldsiFY/ZcaEL52Ipt2Y+Hzc4ei8jtMnohOKLk8TNfhtjwMnjIeP72D8FR?=
 =?us-ascii?Q?860M1jSTUb5Zg312Ztz9F13CHgF3+b2o1AmwoVadRlGjVCRN5Y9RRA0t2c0N?=
 =?us-ascii?Q?yCT14lPkEh0ofs3NNvgXeBOHAh4v+fjdA84kJ93e0wgt7J6FSpgIH1wFNnpS?=
 =?us-ascii?Q?YWK8TR758PL3NKde9g4akR5PUsPSOoiy97xrSoJdr1/EWKDvWcGGy4qJUXRG?=
 =?us-ascii?Q?yu4hJsktwZg7OUczDAktPPPTM/kJocpxULpV3eH9vnQwv8QdbKbPMuJOywXo?=
 =?us-ascii?Q?oz53yB2rMCvrbp8ic2bJEV60/pXoxHuLeO863KDPUw/nIShaiJueq1e14PYm?=
 =?us-ascii?Q?hMzV1gFkAdhj6avo1joRjJMAP9wPLF9g2uD2jsG+dHR2xmXjSJ0JbgU7haZW?=
 =?us-ascii?Q?P0ewzx9waaFmwguBVj7whnQyVIV/CM9YSGeWNqI4SIw+DMYAPZdO0Hb/o7ZC?=
 =?us-ascii?Q?G3w7tW+fjChi24o6qXbkeTUoki2mwTpqK8bQN988E2ZPKJqU8lb6FAjbh8g5?=
 =?us-ascii?Q?FbPNurSvxsmJbrqX8alarnhb?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9759063d-13c3-4d3d-a09c-08d90b17718c
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 14:02:37.1637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OFtNsvcdAdXfi4A77+y1OIqj/u504wjCf0ARGLajJbHzbFvcG5Rx775Eb79xYeEyDG0DyOXEpCgW1cDyY0edkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5239
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Alice Guo <alice.guo@nxp.com>

Patch "fix the built-in caam driver cannot match soc_id" provides
imx8m_machine_match to match i.MX8M{Q,M,N,P}, so change to use to
of_match_node which can simplify the code.

Signed-off-by: Alice Guo <alice.guo@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 9bba3b93cf35..7e6a525e0c11 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -113,10 +113,7 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 	     * Apparently on i.MX8M{Q,M,N,P} it doesn't matter if virt_en == 1
 	     * and the following steps should be performed regardless
 	     */
-	    of_machine_is_compatible("fsl,imx8mq") ||
-	    of_machine_is_compatible("fsl,imx8mm") ||
-	    of_machine_is_compatible("fsl,imx8mn") ||
-	    of_machine_is_compatible("fsl,imx8mp")) {
+	    of_match_node(imx8m_machine_match, of_root)) {
 		clrsetbits_32(&ctrl->deco_rsr, 0, DECORSR_JR0);

 		while (!(rd_reg32(&ctrl->deco_rsr) & DECORSR_VALID) &&
--
2.17.1

