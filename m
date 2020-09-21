Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AB3C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE612085B
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Yk1HTGVH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgIUHcq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:32:46 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:47332
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbgIUHcn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVA8Fyw+3cGUzed30m58YacWu1VOJJ0XKtVQBWiMfkS9AfDiR7xvktf2jT1B/+dJL+NNUzHRclYAvMEs+r/BTB1nobIsvJiwnPVgcjSL2+vzacbHhczH910VN2eYde3GFuzf/WQIpFfbXvCem/XMUZYuvsPnszA3cuxCe/o8941wJw7nyfv5e2u+5HwumjaBYUdWXk0FqEXIBA4SekcHzKf802w745Av46ZEZ/7mTRLp6Sbgl0aBmPKH8due7Yx2g3LSRs1PDM01IA+B9GEj0c+6f+9B+A7+r3QoBg1Lqt2KHEj7hhJYMr3sc8dKeJ1h7x7Yrqzfrdd1DSyL6TcqKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2b6WWpYv4ssuMgFXXPxqvnYTskjp6z9dh1mqdebDG4=;
 b=Dq7FKWGLtyHLDM5Qnuo5sD7s3a1mcArQjhOMdM00uMJi9H5gyuIFZlAaIX++nWh/uiupHdPxJ9yidoKw1TDzuxBgMX7qxN4uOcTMa8/0bUA9c135IstrL5OO6tzaJjcI/h5eSDHnHSV7tS1HEANR0VvfgmjnE9LiNIeJAKVHxGGla4wyXsrYjc7jEsOok0Gz8wMSe2dzljJMcMPqkjF7NnD/MmKRVCU6b/0oZsNmBpBt/ec+EApFb7r7X+GAwwqHRIon0FV7MsP8ZmcmJtUmgGM64XpfVYtO22s/Mlqcr3+083bigwYHDIdbsbqeCFVC4SicqgDNF76/Li/0/fPZJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2b6WWpYv4ssuMgFXXPxqvnYTskjp6z9dh1mqdebDG4=;
 b=Yk1HTGVHRqpYBcQU3Uk6ZvI5eDQvS6nHU5++76Ph0BAiIBXXR/zoKEZkSIKUW0RKJNccEtEsoCpTEUjGLLBzMXCb+FQdhDbiITEm9n7zJ07qIPi8wuyQhFUrySOBmXa61gZXa8FQQJ7BPCgtVEVPvSMVAVkW1L8TDHvARXXR6Zs=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:29 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:29 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/12] crypto: caam/jr - add xts check for block length equal to zero
Date:   Mon, 21 Sep 2020 10:32:00 +0300
Message-Id: <20200921073205.24742-8-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:28 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f927381f-84e6-496b-664c-08d85e007ea1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB39038FA1B302AEAC319BDB23B43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aKFNz7JAaKgci7GC00qSC6NutsJUV62Jt6Pl+HiJ//ERBXw+wZYFI7tC6ct0D0siSDQEy8CQfVXm6Mqucx0yXmg2kEQnqTaRpdN28IUHC6yJ4pENKLVu+4KFdzqZxIpL17tUyvLnz6jHPQhFMIyJJ2GsS0oYEVNO06+uj39gRauufo4R7g1Q5L2T4Q4Ti6WD6mD6t/7YXzmXvvtb0spfDjToTiKVQG3HtpVknu7QkXnWIEJX4sJWUnNHkZ7MZMqe9O3FCFk+tErKaYiQY7qKUH/0e9v6nwqN2YNDiFuUKTdGYF3tEX7ErR+tT6nC/EjVeLHm/ax3E+tUeCIWoW+UIBeqAFcovrhNDPhlll6rFsVV3L2aEnrdHeORd28IFxYY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +l1FCSx6rHjFvNNVP+HBDVcUAcjNak0scpHlyMiX3RQYp+SBr53jFqJSwkyDZd8rf7WsGsh3qwJLWmXZZtGplm0IlmKWxZuwtHqr/euof3/1/X5CWQ8HcndSmt1cRgds6dP6cujbkV5FQgxpzqfD0HWFCvo/T2C+dhDobleWAkVLmdGp3fl325Ilm1t6mpYBdOFuXmGxXpM5eTELeNoDWFcESnx6rEfyfBMiHANKUNddvGQRfe3ZkNKzv2otfXkemDTuX0/HAytXjIwrKArw/wvi62mMbI1H+mKMxzONksMTufsTBRvJqO0TbQSo9ATWbY2+eCRBw0XXADv5JS3cptaBeLuIHLw3Vl+Mx09UfK7ZzE+mJDCrW3fvcSMYVGpH7NZv5nf/NVkgDBdQKalZxMGcbI1ERVZQytWvs58XWzOT2izoq/RvzDgzkVz0GX/vF2S8fSqEUTaNVs5jFM1TNfmMJFqSO8iOW317YZQGutEc0T/Pna/o9rBmnweFMqz7JjiOuKDKKHvx/dl4FSSUgu8v3uNcvDY5w3+gB8bZ1gfLm0zsi1Mj41Mu7e8a4uzzZb5C3jEG+GzX4aNyx3lmj5U6mZndM/x26O11dC4IEeP2vwnarxi2mVg70ZhDQfix+T1QCBBKSnqg1mbh3tc0KQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f927381f-84e6-496b-664c-08d85e007ea1
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:29.2871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BWK/RIq/v6VSzuerEeHcCJrhUlOJj0f8Ev6u0Tr18KuQawMv+tvJJGPm0YHBTLNygeuS+nJHDjewFzXbq9nqZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

XTS should not return succes when dealing with block length equal to zero.
This is different than the rest of the skcipher algorithms.

Fixes: 31bb2f0da1b50 ("crypto: caam - check zero-length input")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ba70db61a76d..b5f8823e4300 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1790,7 +1790,12 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	u32 *desc;
 	int ret = 0;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
-- 
2.17.1

