Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FE8C433E1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F4522CAE
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:21:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="JBaT4iyD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgHGQVs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:21:48 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:4231
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726061AbgHGQVr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:21:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZ/+U4NERONCkXK9RK/0KqUrVkVnwiO1IqQ7YF3/PrBQYwv0X6HgWdsgsJbzsAuIw4Zy1leGrlv5QFMt0ECvQnM3+ybPUrKW7nZd+YqQ10bLQi9cOykVYtSx6UIH0B+Bds3ADX08kkER7LnwQ4Rv6QweWefCurB2fPVmQn/VXi6E93L3uR+5IlYNyu6/WArCZbFP8uKcYMNUX5ercpU04TtXeGf3yvl7vvM9cC3WRDS5AHCPaxoRbvdyH5fwDiyg4Xd6/z8Ij8r8Hj8jz20OSR7mrdgRzhiWMmujW8184akz30C3qOBjaQbUgc9xFSRor4XWNzNK0ZnAqhrKYlDfvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dd3Ke1as6Dgc0TV2ZZ2wSOzEVXomlirb7ZpVikEDU6Y=;
 b=NZgwDFksJxSbbJRN5Xv8c4QOfQb+LqUOdYE4/H+6F5EjuXzosMf6nACdp7TSl+ug0QC0D/8TSvc1AzfnanBMoYI24ppd8Ou+RvJKsK16ZkPoHqAmnJ/Kv4hj5ptRPr60EyGyTwkQSXAlxd3QYAC0k8FRGBztFVj5s9yU61ucr98B5INnqfS6Ux07/ge7VFM41eyY75rG18HUCTj9OKV8Rc0tnNbOnUglGv4Ol3MyKcL0yI48BDFW5bwO4lRGPBGaNDECB4f840mVjYK3A1VDdWV5ftAmO04955T/GC615m5XKv4qJFBpCTaWzBioe4U+pJJyMj/hckKDlBwFNl08Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dd3Ke1as6Dgc0TV2ZZ2wSOzEVXomlirb7ZpVikEDU6Y=;
 b=JBaT4iyDUPDu/X2RWpxEaLcGZFKarPKYIr/VNcVLBFSepnI+vj0AKW/G0zJgN9gxY5YgJGS0qRRwbZ3nOq53fl7ILnYBU/NyNCOhPFWTvjvMXKz7IYSf31VNwvGGi68IMAKu19f64IN36LafosqAWVXLoqhqzVSFcHPcwerwiW8=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:21:42 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:21:42 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 02/22] crypto: arm/aes-neonbs - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:19:50 +0300
Message-Id: <20200807162010.18979-3-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:21:40 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5dd710cf-d7d7-4c85-3de8-08d83aedf820
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73598DD62E7EBB78EFA693ACB4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LthyH42flG5qJ2te0vBSvbqOdj5vv1e0aYWom89W4VYfNdlYnqoZmxiiXlyYn+OB4qTaabN7KFnWYMCNl2I6Q4rcCrzrNJ2wV00r+KrO5HYYh9jsX3PG2w+9R7BXG7mfxlnirwC/EDBX9B9zS4a2EWoQbpYpdc1aRJFZP2zmZDGYXBiM77ZjBSN0SohIy3cmHH9R5r5TcaI3NX0iJhjH3v9e/fC9nuK1Aw6ZDyFoUasosWp46+xFWkJQGkw3KIitFGykfh//4B8S+qSfVeltR39x+buEXT6QDfv3fGt11ve++bTHcjrcubXzRePt0BC7H+gOUwQz3kXmJzOQHbwmVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(4744005)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ek4GkQ7NK8668FS8QpANP5YrUkApWizuPpJfTr3rmNujGJcKeotCzvN9qffuU08GCqFGH5ZOkU13UnYPhuwau4zPrk80RfPh6IwWywzyJGTjmG+9h6rUxHD6xZCIkbUWyKPyIwnnArPthKmttRgnwQP/NQc7dPjgiNFCtxOdxMkBccE3BCJc3b6vrE6PdhFw5045Ws+QviIfLtApvfIXnmq6HhMUVL1xYUy2B4Pq0BclBAuY8yS8JXRGqwU9NrgirBHm4NJSuekLF9sfJmKOHf3DOQfTTM/bWEhyJ+L+/eqQ+kyVcIQPJH1welBzu5vNvQPXU+fiPZLw+iESCYqUuZuJ3xWjGpa2EaUawRNbsO0ajl0E1APP8MiWPyqa8VGrXke7yps50HV1StJvsEgHBuxR3rv70wCG20q6HuqtO9iJ0k6CY9CwuhoqcjwjfJoY3FwO1iUwSyfm+LJicWKe8COdh3WVJIg2tWS7593arD06AkaC5RhzBZgovy4OMTOQaQJwjhmMNW4qDQCC0SiVnjViVz85Q2Jl+/H3llwjsSQ+JM9EpoRkxXPCLGTP/RulxRACYhKjL56QDW9QdCPpSWVTIFiFpRdlXX0+5/mS7hBcobJhe/ifva6rKFpwUgnpK9OzWapTR/Jp9dU00YZ9BQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd710cf-d7d7-4c85-3de8-08d83aedf820
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:21:41.9466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2SCpwSsM6gFv54KWxIaAPht6fKO3rygBtSxt2oX8N+H/N3w1QfiLpq+KX91aRX4r+gmXi0iVerTNb804t+lOcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 arch/arm/crypto/aes-neonbs-glue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index e6fd32919c81..98ca6e6cca90 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -339,6 +339,9 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 	struct skcipher_walk walk;
 	int err;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
 
-- 
2.17.1

