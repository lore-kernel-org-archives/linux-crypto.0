Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DD1C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Dec 2021 07:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhLQHRl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Dec 2021 02:17:41 -0500
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:31872
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229503AbhLQHRk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Dec 2021 02:17:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBIScsRtYYhsIy8IcitDS8hy9IBTOT/14eb3PMoBJNErTxRTUup+P33mSCkWH6ULsXtZjSilIb6vNKOnk9aIAOmqYwxSQo8S+lcd5FNsb96JGdv0LVQgU8lhw3FVEqenLgx/GJzgC35YHIaNHw8Obv5zrvy2kgyl+xJZjenC9/plYk1DChxY2DqJPw1AjCgE1g/Ocfkr9mccghebb75kLbozBQCGlo3cCjuBWuWYhlkG70vARbCNGR7BlnkwW1ULRR9dBIJTSvFBPxf/h76FNN/UHCl1dgyWGBJarOj0hYzTxh44XXK5Oku8XfSSCGlHuUdYrHSCPy9oiRHNCj79bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OgFsU45y3lTFos9jJOf5I8XSSM7fC39dq/QweQzGsPA=;
 b=WFdEDdxD04e6+gTSPNiJVoP0HS5Pz5WJbM9uqp7hnZ7vCDrwsCxXTcGn2hEQKuUQH80amky95l/F5L0RIUTFdws7lXKTKtxCNb44DwTxdBJaoKa9ygNB2OsMOghSjXTkJebp494ysHeQ36P7MszC8R+lS/mapRG62bDLu1YtnC0MXuc4tq6ea7Vp1kUTsQO2Qlv9hGXyNEyQBH3saiz397pwt8ynjBbSMwdbOFNMqYQmYzr1U+uS7/+2lkbT49FK1zf7IQVNc4T/er/U1Jfwq9bKA8vLKIXWW9UXeqABzlx0VUyJYia8CqAxv64kX2Wi8HQ6q4XqUFqxM2KTnK6UoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgFsU45y3lTFos9jJOf5I8XSSM7fC39dq/QweQzGsPA=;
 b=nLd+BodzaQYXn8Q4pLjKWk80WYQzxjj2bczO0fymbShO056dYzXB/YPgjXBHQIiopXr1CVuuLbB1UDBRWP/HlRtm+xVdn6h1YR/Bj1hffZs2k+s9/pFVXUUjGXm1JHU8qBYTaFL4EibfZT/ASUSZf7xdShrGqlLPx8o1t79GKmY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8630.eurprd04.prod.outlook.com (2603:10a6:10:2dd::15)
 by DU2PR04MB8727.eurprd04.prod.outlook.com (2603:10a6:10:2de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 07:17:39 +0000
Received: from DU2PR04MB8630.eurprd04.prod.outlook.com
 ([fe80::1de2:3cb:32b4:803]) by DU2PR04MB8630.eurprd04.prod.outlook.com
 ([fe80::1de2:3cb:32b4:803%7]) with mapi id 15.20.4778.019; Fri, 17 Dec 2021
 07:17:39 +0000
From:   Pankaj Gupta <pankaj.gupta@nxp.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        horia.geanta@nxp.com, gaurav.jain@nxp.com,
        linux-crypto@vger.kernel.org,
        "\ dl-linux-imx linux-kernel @ vger . kernel . org" 
        <linux-imx@nxp.com>
Cc:     Pankaj Gupta <pankaj.gupta@nxp.com>
Subject: [PATCH] MAINTAINERS: update caam crypto driver maintainers list
Date:   Fri, 17 Dec 2021 13:42:33 +0530
Message-Id: <20211217081233.2206-1-pankaj.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGXP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::35)
 To DU2PR04MB8630.eurprd04.prod.outlook.com (2603:10a6:10:2dd::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 151f357c-f4cb-415d-c519-08d9c12d4e91
X-MS-TrafficTypeDiagnostic: DU2PR04MB8727:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8727DA35A9DAED080D5E156295789@DU2PR04MB8727.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cd2GZmG3Dl5B/HAI57vS4ZQowBymAjWtCqWb9SpFfDW7z2DbehdSBzFXa+BSeOC6X9Zf/rO7shzjq31qPrmcphsr2vxY2BoVnAxSbczNaZdc1Z+SWi9OIw/GNwNl8xh0VLAFbPFISckDO+NxaCoFlz1IBQgBfYS+hS/FojHNzem+xWMmwlQoxNVIjMflsSW+gPT/ZGMfmgerJ6FV5yDSwYkcvixefR0ZtREWQDmludoikaEn9U1Qbd9yZ/+DPBGJ8PLjT5ucw4qCg8wCqwuPfeinmW9XTTN2EvB2Ty774dkJopqJN2icFDfJxn9RpExrgvSoHMxeK+00zqee83eRzTpLqMa3Cz806gq7uKp+SpyPyGeGFVNr0F52lg8kt0TmB+ShxQxZJ6CaFXogiv4xP4/RDhePp7uX3YaDkiXitLQeODy6qT0cNZefzwXpMZvA+FZb3i0Fx1nHVsVMep/IQaqNraX7sGWhGBeKNkGNBMtj2Oji0iQBDgnXNocUL7MTrLVgjAqvdXinqKzZ4UAIEGzDwPHzEgODfmstyKJF7SWvemEyNsB+by1pP4krjC5c7vJ3NRVsHmoqVGLECl8XQ6OHI8hxWF7QP3gMNH/9mAgFi5TiEzAyFCQNoobDkoIXtwuo+6UuzS+UNH/PWJIdE/TU1nyexo/VZdnvyD/mb76qBvsBPbgj+KmPFvIQIuFgfVq3BX5+1sfFz80EmrukYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8630.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66476007)(86362001)(8936002)(4326008)(8676002)(6862004)(44832011)(186003)(2616005)(36756003)(52116002)(6666004)(38350700002)(6636002)(6486002)(66556008)(316002)(2906002)(6512007)(508600001)(66946007)(6506007)(26005)(38100700002)(37006003)(4744005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4vsEve78Wy52X5gVSObU8WkIilMGSl5welPTR6Y/wvbrdMhzE1Arweh8/1Qv?=
 =?us-ascii?Q?aXwe+U4bGZ0VAhCkn5e/DEVK4azfdiSn+hB+d63dp5t3zB+CG8gxjvyO+T09?=
 =?us-ascii?Q?Ep1ObgN7fCes7rWOphvEvhjmiyM0V3/QQ0VqdvHIDyWHUROqGXuVh4N9eaas?=
 =?us-ascii?Q?Cu0W8j+mBhsTa9Hur84Dsv1voUBrLApeaexGGZSy7yFdK3XObQvjF2SCC/3e?=
 =?us-ascii?Q?a5V7MwlyLJTKYpeMBYgvX6ZPKR521051WRmN6C6fGWu+7tnhkAfEBj+kPj8w?=
 =?us-ascii?Q?jHBDTeS0U2/yfXMQDar03/LCP+lbnV6L6dKgB8jL3+6bu/yU3CuZBCaaffv6?=
 =?us-ascii?Q?YrBnn6pShbgSSk5blv+/ScLr3kq7x8/1BptPfIQdHnZyggDhtIgxFqfpmRDy?=
 =?us-ascii?Q?QeHRhN2aK4VWl80QigxggVQfkCy+1SZUDG7dDws4d/EeNn4K6IRQvb8obikw?=
 =?us-ascii?Q?I3nB4SMQpe9i7OGfzzKANS2bvKIfQiez83yWj1gK6SMMISZtk4iQwQazs/KC?=
 =?us-ascii?Q?f4K1TFRKOiZWBT8EIpGMRQYdtf0Yc25aFJ6SLB2n9Zgjm+aYcE8rngEiGm4H?=
 =?us-ascii?Q?XdaopRvvWSUvsXoZuLXftSMFCzLdM6hh7PPKJt+stwLae89qmPmo33Gc7KzD?=
 =?us-ascii?Q?RlY6mIjwTM4pyUq5Ma12uy8pOBwarfJO2A9TJAB5LBN4ImceEalG7vM/+Xn/?=
 =?us-ascii?Q?Ze602NXrgitV0SWGArMDuRGXlS1btJ79fAeGrAxI7SfkVWmeZCE3r38B4WWM?=
 =?us-ascii?Q?ReIa0+5OP+wIh+v2QakmA8H/ZAlZRT+7FLCvwUmaMx2+4/9Awkzs8H9TQx3N?=
 =?us-ascii?Q?zh/tABd0VFYxYouKGyvm0cSbgW+FT7/VGsj3IMjamK29BHN2NgRKAZnitKbY?=
 =?us-ascii?Q?v7eHLyfP0x5lrUNjzilrLVBcGEHXPRSjn86rr1YZeEyLPwIOngwenLcdybKR?=
 =?us-ascii?Q?zIhq9ZugHA5N5XuMKEN7p6i7DlPmGnT+GIfmjIbMG8bolo+HPesBofa/zBNg?=
 =?us-ascii?Q?SM9TDUOoLVjsB4/wW5NEx7sDbBb11QkLAuWmL2tEvnYjdLMVoyC2AnSXlkAM?=
 =?us-ascii?Q?oTEQMoe/MRg9C0WJVkaBm4z1O7hWii0z6uG0zJD7R+atj30DP2CKQXStHGqu?=
 =?us-ascii?Q?RQKhogczR20EQjsRkftSnZazBoqph5vwQq2dJJezpy1Vbs5u7aMrDgdOXoUc?=
 =?us-ascii?Q?IXG1+NMiTmnIlkC5OhjBEj4RxVDjCwbV1WOLBaI2WvZvoCM/z1rt22PLqY2X?=
 =?us-ascii?Q?SBCqNcBPUAsk4eXh/Z98pgxyj0a2JcSkqBQ6d67FekohOETyZ8sB3Hy7cG9O?=
 =?us-ascii?Q?gnA/ND1u9elnvAoCBy8aJ1CgnOn7dGO+EqL8k1kQyukRqKqMu9Fc1kg6pKN2?=
 =?us-ascii?Q?HTwQGhVOqtBynYG+zqTUjzJ3CE3mqpqO7umdx+e6olwrAci3+Uw4hpgFrNR4?=
 =?us-ascii?Q?Q5crRMUSq2r7IpLpAapiTzevIkwX2dP8wperQ9vwqavxlf688eORxgefAycR?=
 =?us-ascii?Q?CRq7EuyarEvinJj/kv9RkJgirA1NjuxOpeFhDv+Ct8d8IV1Wi42cGUKWlu7n?=
 =?us-ascii?Q?7JQWMdGhdXL24E8HwAwjv/We5aavHEpgw/jtyCLROh7TFfkMcErpGsrnV3gh?=
 =?us-ascii?Q?6fIz+47AMSpK9HpY4VAMVQk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 151f357c-f4cb-415d-c519-08d9c12d4e91
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8630.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 07:17:38.8677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oTo9uduSMqg80FgMH01rKzPiJyTD1/BpCjBX2G34mTipTnD8uS+f0YgMtMKQQtXXb1D/DIlbxlJdJJvxe+F8og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8727
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adding Gaurav as caam maintainer.

Signed-off-by: Pankaj Gupta <pankaj.gupta@nxp.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a4a0c2baaf27..08a5c40e373e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7377,6 +7377,7 @@ F:	include/video/
 FREESCALE CAAM (Cryptographic Acceleration and Assurance Module) DRIVER
 M:	Horia Geantă <horia.geanta@nxp.com>
 M:	Pankaj Gupta <pankaj.gupta@nxp.com>
+M:	Gaurav Jain <gaurav.jain@nxp.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/crypto/fsl-sec4.txt
-- 
2.17.1

