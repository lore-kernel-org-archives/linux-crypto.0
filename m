Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB04C2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 09:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0057C613DB
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 09:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhFQJWW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 05:22:22 -0400
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:22180
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231398AbhFQJWV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 05:22:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6SNmU/W6dyBmHEZEQwSghCCi5TIJhjXTJ0vDVUflrX1wBbMI/Ny4eF8Bt5JKJDm9XURys/JHIQrATorRFkCpM9UjXH8wyNgZc66n8SLFr9lt2R75iLYqY0MW5x7tf0HDfXEfVaJzhk4VfdJ9PlII6a8O6WzXFgg/MNnLHWqjIFcVTcsjaZT+GTQqVCdzWReL+hvMtdGzvL+VT8xfafoavw8fsnzYQAF+o9P0NgeQld2yo6MvD9rNB7kaFNxXIDzWzUPPtdDHSUSfg1MzXfsa9R8YDZ/8YhttjxgmBOE8InboouseW0WsSE9wmdiyC6qkKJiq7wtylAE+dsNi2KPag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akgVAqoUyXpYCzj7FDEekxywENfU6srRYjH89yPZ1/c=;
 b=PUxV8wyvnM0qG1axpYBY2JkmQ0FbBetLMwrNOAmrs38I49T7wdhNl9AbUbNw2FIZ5EV62JtW0Du4GdqXGHMv6mN3ZhsCGlUNMgiWUxyQcZJsiIP1k/Qc34Tp1rJ/f9AmAAFTr11lK/p2y9J0VslwoprkuckLwAmoSecq1PSOIz71gwUpgGEdl3B1QpwLj8laouNiCK5ZeAfVbDPriFtPkyHZDRlHRE99Z80E7NuS9kfZ2mMXkdOWiDQyb5W54hYFvRePuLTuWcF/hIHJ21wGkwb+0Dha7Zi0Qhfx2nnJqlAW30jWDPTUKBuxSkw/2d3u6ATc0FvU/YPbAnsIO/3KFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akgVAqoUyXpYCzj7FDEekxywENfU6srRYjH89yPZ1/c=;
 b=jJV2QjfJXBxE1B/bK6N9mHUrz/Jp6IljLXBOvFN+aOkt0I7+1yuue1KeB4x0ktAt10J/fyKvc+kQTMM5MgfbP+dEhPZeCb70jvE8haDw/ucQV1kK+tUNaSGMscDOHiMe2eT4Lo7FZXvFUnKgwVDsEP2OOzMJR1DoNryNxlBAj/Y=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Thu, 17 Jun
 2021 09:20:11 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4dde:d71f:1082:6351]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4dde:d71f:1082:6351%3]) with mapi id 15.20.4242.019; Thu, 17 Jun 2021
 09:20:11 +0000
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update caam crypto driver maintainers list
Date:   Thu, 17 Jun 2021 12:19:26 +0300
Message-Id: <20210617091926.23517-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM3PR05CA0153.eurprd05.prod.outlook.com
 (2603:10a6:207:3::31) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15138.swis.ro-buh01.nxp.com (83.217.231.2) by AM3PR05CA0153.eurprd05.prod.outlook.com (2603:10a6:207:3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 09:20:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84676460-9b55-4944-2c21-08d931711b9e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3405:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34057CE8AA5557CEADB3AD62980E9@VI1PR0402MB3405.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F5jMA0GPxtk9Pyho10DVGEQ5YimF0qWOHLllNI1iZZUBRt4rYCYTeTHWqsO0LknIWc5q95CS4SkZ+IEiFeWFnwTJc6MIAdpUTDoFof0/e1PLoLAMzPWrLAlIUQfFqqsPDUSa2dOIM4NTh3qSyWBbFd1/13dNn6rURszlwd3CKVrnkz7gczqnmLCj97C+BIj/AvlwvLzUxusGZbfZ+heVeHTqnQoQeC0gd2d//CfP/HebbyVajV+V1gHkzD0JvKpDejx5CiIMoTme8fMOjcUv84Z+7bo87vW42YOg8VTaizEi4aEZgynAXBmxlgRO3a88fQ4F/G0PyoTos4TPxhs4GYkasGSDEhBJV558pkxXcS/aps/A33tSSEdisRr09h8d7FWI36jYY3LQBbIsA9LjyLQ5+fGG/TOYws6p9GYLZaJuUkr5GdNGCetbFgIxoUBrdXqAE1xpW9CbQJyZShlL7LQmDvqvIqD0kVk+V87ahRkl3mjPhE9gSNjevQ4RSK9rEELO7uWo4rK+B58kb4q1hqbC7l+YGeRcrhkMzEqMTNiXsUumGKQyjGyIgVVzF7k2PvUC0eYpnXqaNngxRvLMcAYuY7GEJIhxLO80mC8GhME5gmrJ2LSLjzd01ifwENq0MBoDoeE1ZxTCKxzZ8EPm6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39840400004)(376002)(346002)(396003)(136003)(8676002)(8936002)(38100700002)(38350700002)(4326008)(4744005)(52116002)(7696005)(1076003)(478600001)(5660300002)(36756003)(83380400001)(2906002)(2616005)(316002)(956004)(54906003)(6666004)(86362001)(66476007)(66946007)(66556008)(186003)(6486002)(16526019)(26005)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUxNeWc2aXNTZjQ0Tm96OHRJQjdLemoyVUdQY1d6d1daajV0UXlEUFBEOXBx?=
 =?utf-8?B?WVZvWUhya3Y1SzJxWGdYV0R4VEh5ZkY3bHE2M3UvZU9SYkN1WVh3QnowL3pm?=
 =?utf-8?B?YzkwTzJHWXA0bDkwY0xIbjZRUE9lYmNGdHhKaUVqK2R2cVVuc2tUYlI0SS9l?=
 =?utf-8?B?YUVMV3ZkcVEwQUN3VHN3dE9GMjhiMUNRT3dWaTVXYmJvUlJDY3FWeG9QbnBV?=
 =?utf-8?B?d2hwbm9pTitXRGV4NDBHMy93bnpRL1grTHMrdVRDdm1YbTA1dFEvMWFWU1pB?=
 =?utf-8?B?MGQ2Tm5tZnBOYmQ3c3pCdVpPSC9EZzlITjJMODNXWWRSRTZsbzhqVm4xcE1S?=
 =?utf-8?B?djhPSmdKQmFzWjk5eWh4MkwyVmJKeURDRFVxV1RVUHNYU1ZiNkRHRHZ3c3pM?=
 =?utf-8?B?QkFDOElFRjJYVlpQUkh0dlVCalhLRm04WHkxRGNRMmtEZWRpU3RQS1l6OVRB?=
 =?utf-8?B?dnV6Z1NuakY4Wkg3blNSbERYSTRIY2pBclNmRDBvRUJtV21vbk1RejBWTHJh?=
 =?utf-8?B?bzhSL1U2aVRqalJMWkZINi94Mm92Qy9qa2hjUlY5MlR2SmozcFZ4ZFVYTVdn?=
 =?utf-8?B?SWdyaEo5RHJUNjl3eDRUZHlBa244eUdvZDBtYlNBWnZ3UlM5ZTdmTVdTL1d0?=
 =?utf-8?B?dmRwUFg0UWZrN0NQWUkrcUJMSEh0b2RUZUkyMk92cVErT0k3MDFUNE50blNY?=
 =?utf-8?B?TCt1clFOZUh5NE1jMG1ocTRLcVRFYURVUVpKTitxRVdLNk5xUzBCMnAvT1pu?=
 =?utf-8?B?ZFI3akNST1JpcytKOTQ2ZWJvRlNNbnZ2c0pETGRYRVp4S2NIL0hUVkNpLzRm?=
 =?utf-8?B?Y1J3OFpUdnVkaTlpcHVhM2QzMzBXbUlEU0FwWlJlczRlejV4bUlOa2JiYTRs?=
 =?utf-8?B?clRuM3Y2Y2Z0M1gwNngwbGhTdUhvTFZ5V09hK0xOelVIdTFVcHFjb01nc3hF?=
 =?utf-8?B?VktqYXk4MEJzRXlkUGowSi9UYmU5VXRCRzB0SEFFblRjVi81cms5TXQvMmxL?=
 =?utf-8?B?QXZ1NkltL2ZwVDVVSmpBeXdNVjh4aWFrOXpCQmR1WWNQMmlWeU40QlJQRVp3?=
 =?utf-8?B?clZYOHJMRERLeldoTmVUOUI5OHQ2V29aMkZ0WFEwWFIvVFg3WlZvcnlvM2RG?=
 =?utf-8?B?QVNYNlJYbUxzT3czM2J6SmI5UWRneU5SemVoN3hlZmgrVCs3QnVMWGFndWNj?=
 =?utf-8?B?S3p2L05NQ1hQTkQ2Q2tjaE9lQUFrRCtRUDRobHFVZHRtTE5LTEFaS3g2UjVl?=
 =?utf-8?B?WDhUWVhOdW15MmQzbkxaQVlpRXhocHpORmtLbG1vUHg1K3ZwaGlWTHQzVTla?=
 =?utf-8?B?THFpeWprU29RUzZVclgvR2VkMS91djN3MnhwTmt6Y0JwdmpiSmJjaFRvamNO?=
 =?utf-8?B?ZnNtaHpGUkNvdWxaQ1N6MWFDUmNEYTFUUnBBT0pEVG1BMzhDY1I0bThMZHd3?=
 =?utf-8?B?cWY2YUYyWEo4ekc1cHlzRUNLZnJjQmpyaUdpajVrV0pCekFtSFBzelBIZUJr?=
 =?utf-8?B?cFJreUgzclEyVzJsMnA3bFdYQzdZNStoSG4xcWJSWXkzQnBxSmNPaUxITE9T?=
 =?utf-8?B?ME5EaW9oeFpXcFpsRDA2YXZCZHIxTG4vNlZ6T3NaR1M3T3g3Q0xoTCs1SGR6?=
 =?utf-8?B?c0tsSVZkL3QyT1laYWY3WDFqbkh0VnZHMHZtT05IZkJwaGp2eWxsYUhaVWoz?=
 =?utf-8?B?ZldYRURXL0d3RjBVV01MeXpDOHVJNk9mZXd6OXFXcHl3WDM5d3RLczd1VVJO?=
 =?utf-8?Q?aTfN6ew3QesTGOi7SlkSt2B3S720RjILMFnTQiC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84676460-9b55-4944-2c21-08d931711b9e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 09:20:11.6001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zt15hbqOy16Lmlqpbsy7bKAC65OJ1NVisGrFunrRKci00wEujILMes4nc2g1S/ppXG3jONGUq9MeIm+AwdXq7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3405
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Aymen steps down as caam maintainer, being replaced by Pankaj.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 388924c2d23a..690e54bf7e23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7159,7 +7159,7 @@ F:	include/video/
 
 FREESCALE CAAM (Cryptographic Acceleration and Assurance Module) DRIVER
 M:	Horia Geantă <horia.geanta@nxp.com>
-M:	Aymen Sghaier <aymen.sghaier@nxp.com>
+M:	Pankaj Gupta <pankaj.gupta@nxp.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/crypto/fsl-sec4.txt
-- 
2.17.1

