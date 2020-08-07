Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438F4C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14CBD22D0B
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="M7j75P4g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHGQVw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:21:52 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:4231
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgHGQVu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:21:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlD7IQi0IhjTokZcdrfy89S4QeBpdwN80jIXAP6Fi1H9Em3bB/V5QwHnYLRq+Yq5dgikVCCYiffvaNLlyTijxB4OwsVq0T3CBg2YdqqTK+ZCm2PNRkvnr34NXm5nDNw11Mienu4a2fw0YJaisj7Sz249hvW20DgC96RScbkoHmiVCuTDGaELVmymdeHdcSU+GLiT/nOIGe/oDSQjI6IhaW1XRXz9CtmJukLZz6Gk1aH4Rt108wmCeNvUOJM1M0/Z7aDMLBI2wXJID2tDsI7EftU2GudxZf8UCg7t4SIOoaXrhdzCFKpv47A6kGiYFoHa4wEmJZ9V7pwJu946yOXoNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/u++3Wb9TRY1KnAMaCmSPDyHn+bY++/LQen+EDNIYA=;
 b=Gi+ShSrb88dCJDCrNWgOrN13a0Z7qK9qXJDPQYX1HKN7/xnR8tWfP6D3ELO9Z3pz//8sv60w+KiETBPQ+kH4hOBOxlyXSY8ynddSXNlKus9u9O9rxgksFn/iWUyrna89nfRLR8Rm0To5NrcnwY5tKyUcV/fl2pGWLso7qhGCXVJ2L3TOc90V5WlBbldSoe1tK7dPhIMsHZ5HdH3ls7Hhe8Golec7Q3lh7jnMYKCaC3CkNs6+0dSFwc3QKfswpM7hr3QKPwwb5ZNuS6eUF+Qv2f9Jb09SUP7gvmRiQZM+7HMgLFDs7yPl6ehcgussyc0dhueKXsnm1PT67TGZovdN7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/u++3Wb9TRY1KnAMaCmSPDyHn+bY++/LQen+EDNIYA=;
 b=M7j75P4gBWLvcLPAzmVOLTqtgQggGV/BkO+e17VAFL6FvOvTL+USw9I9BFufNCBTypoui9zTKqc1QZHAwvsXPa7VSuqmTxZ8HngbCGsnrHmeOVOLae2/gZRm8pMSh7TR50CEP9Wg+HP3ES0yPk/EBf6jCdnBLwQHvY/LTAHbfCA=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:21:44 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:21:44 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 03/22] crypto: arm64/aes - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:19:51 +0300
Message-Id: <20200807162010.18979-4-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:21:43 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 83d861c4-7269-47f5-3654-08d83aedf977
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73592BEB33AAE4726B810092B4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZwVRe6Vp60/RcZhOWUSU/C42BEFpyZs3tLpHMmMwX4MB+GpEVmPnnUcdwP2MBZGriMWLaGe0EPJxWagpHs9YranNO0aSVbO0xIavRNo8hrF+RpkhzIn0GnA7dIeA8fgBOgOgeexL1ouTtF3ak8AsERvCuRDQnQhLGENxd1oOfHc4Jbnijp5n829qTjf8Rmjej/PsAuDwUMShc6t7LqWznSnc1LRkrUapzywY89AdP+sUp7WKBIAXlxxo4wruJZ/Bp0+dUuWT8oolXTllSEOdxyBi9NDeiN0BVHe2VyGH5Ggd0Os91TQkzLHRIl9XttSATLAl1bHeuO5DFWtHLUl1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ORK9xEdDWq4NJJFv9Tcb9rAX4xH1P68efhSx6pcBNEyoCdXah21OvzfpxSeDihTs4j+oQQRCK5hqsmKTYxiN4y/dnaxXA+IqopSXEQQtUW11hBLtKwlVSSwyfxwMlGSXQtpT6MkYpdYYHj7L5giCISMrTDkQ6x2jU/M2MZcocHeH8TCODPWRPg0Yy70GzkifPYUYdLOg80zxnpW4ewZDUVdBkkhLKYpl+AfiPdtiCXQJqlusYY4OcIXFGp8l0LfNb56EurpmsDME0LdBg06z8+mC0H5KeejUKiZXky99KX20NEdE4/3P2/xGhkTZgk5jmT/S6/8lRDz1UXj2sKKZPrPbFUvWFB0Imr4dV8F+korpcnZ6A/nAxV74bvCAK3DF5B+/X/l3O//PRqTMVtmBu7fGZ86bBGuJxX3/1QlH5+cc7jQ4CQEAvPSpZ6CqMMMxYFh0y3ZCE/QQlnJwrMjW2s54ukN9nFDhvy4t1HRShcyunwrxcpTlaRULXeb6DVzEtUWKPnzc7SA73AW2kBciEqDWL+U8Cq2t+j7WhPXlJjJW2JWte1YS1cITGKK56HkjM9P6E53ebQN/5ebpCt6tbR01nAFCvhcdYs7nF1c4c6qgPMoKOj68Nx4u8dYVO07Y98ukjtBN5Sdk99cKuqgcHw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83d861c4-7269-47f5-3654-08d83aedf977
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:21:44.1823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+v86ksYwg4bFY2635IOQvq4aaEdWZj5hajWWGyS5u5po8rmLreRQGVzcin2DeN/dECpKx0ANOOgiG9BiZ393Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 arch/arm64/crypto/aes-glue.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 395bbf64b2ab..44c9644c74b1 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -515,6 +515,9 @@ static int __maybe_unused xts_encrypt(struct skcipher_request *req)
 	struct scatterlist *src, *dst;
 	struct skcipher_walk walk;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
 
@@ -587,6 +590,9 @@ static int __maybe_unused xts_decrypt(struct skcipher_request *req)
 	struct scatterlist *src, *dst;
 	struct skcipher_walk walk;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
 
-- 
2.17.1

