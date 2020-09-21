Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF34FC43466
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D9002151B
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="DSh6BFSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgIUHcy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:32:54 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:32604
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbgIUHcs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfG1rTWBd1jRSlucL3RecvqjcnKwqli0Xzxk8IZXD49tafVTVIiqHM1vZPjuaTFVN2YglPmldbS8TJaXoC0axRIOA8lmWR8Qm4FtNQrG30ncSxfKGb/VXe88ujnuHj5PTX3q9WVem5LxbeyrEckM0M0SAhH/k0EZzJaMhRSgvT01k766cbvsaOjRhfBSBInftyVnxnVXNrzSVtr3HnxqysMAcB++UlPxYt7xPcGEsX663//+SoN/QbrZiGJ19TylTqaOSSu60MbVVFd5u3JYn5u5UzVHsc2heC0HsZYCV0o+Xii0t4K7/oX3Xfa6ErgTrKZLcjJgM1RT5B/y8jffNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1W0wlGIAKPY1eLPCgsy2SGYu82fsrZCpkvEMHZ50ds=;
 b=IAPSCEv/TuVjwygiIRusMh1kfvmlM6TRT1AmjypgFwRUWEAiM2TF0mA3LnUdvBH2nb2/pGbF+Olobsm7vwU7990EZQvV3hWXPOtuk8ew8kSnsdBV373bYbWk7Tf9s+ajIC2XdzCUrlAkcBokuNvkElv4HS9y5X6aCwov09raOMLWKpjMjU70N3vDjwxgwWFfytIvnYPFOUbnZfCZIqQ9cnrNm2azk8cSRaAj/1q1HpMEp/nIDcSMWDqejLtF/CaDHERB0S4x+61CUsjTgEln4PKW8Glznzbt/fHpSlodUlgBPxTrAmRpns9OCWY6vqUb96XdIhCHzFVSTHCWgKpWHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1W0wlGIAKPY1eLPCgsy2SGYu82fsrZCpkvEMHZ50ds=;
 b=DSh6BFSotjfARjFFLRhjo/wZBt2DNrDfZHDGBwRkDog31bRr8fcyma1a7Iv/LpWxIhe7MTTpSAQzZZXwPDRbRfnt7pmREMM5lWpExhad45k4JzlcOk6zLvn01kLUYYPaKHgDtjGif8GzFBactE2RXfb9/RVHzLgsVEFabT+ErjY=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:30 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:30 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/12] crypto: caam/qi - add xts check for block length equal to zero
Date:   Mon, 21 Sep 2020 10:32:01 +0300
Message-Id: <20200921073205.24742-9-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:29 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 67a84e1b-4838-45ba-04e5-08d85e007f35
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB390355019F324B673000F86DB43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YzhTH0PzmsCAcvOe7C50QB4DjSgHw+WXaNoeiAvdnLOecEx1oCTNn0DakTgcqvSBt1XiH9ntO1d2n6yhF/hqX5jilL2elo6WyZDF9ofZBPTHhfjS8noO+hJGzEjkciNczRw2lNoJaoTpfY7ABERTxFitxXCbHyQmFMB7pzUwPFqczYIN54XS5ijc+66TIdPV5iJDksU+vIT0Pot6+lxm+daj+kRjMIvQhWxl/rhcELw8uxA7FUYVzmKIaHgTzwm0NJeurmB57yCnwvTZkFdH7eSVmSvbmrbM8VZDfl2Wc8lWu3Mbn8JF+OYXnFkeajuYSF+EB2Y36inoOyxn5w3Upr8yBSAGqnSxAX2tieDg2SWSC1c/T/IL7IaJu4oUgDh9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lhHGsOOPqE8zIP8AjeL0/mo0vDKDmdW9qfzzXr8AklA5ss9FkoqvEIu/Hh7ZZ7OF4hkky9zn3WHIKutL/K6s5PFMZpEeeEnCiWoa9KUot9XlKb20GsrUUTCSwWfuCsVPyWJZScDPJYuCN508ZlLQrVd0+hPrOKcYU/p2wu4VDOnRIkZqAdJkDuDPcwes2ic0uAmuJZ2Gn8HrrefuVu8FSBF5xVSPeNgDuk7L7HGLCxEbJXK9CSTeFfqPQmpOhEtbAWm+3dD4gaHWVQ1IFyNlJAcY/BAUTwa1Lf9ddZcxU31j7RfhCu0dYFXRk7di+6BvnTETbwK86/NyYGlmA3nHklnFoJLe2Fe5hOrDyYzy/Y9eHVtPG208dsbCV0ZebQ2+zwlPm3NoyqDBriUTTIhH+Ptkp/0QYrY7Q8u7se22V1i8QJfhc2ztObuP+Ydzl0txWnrp6lMceUjuBuMTU+8Bvh2vU2FPuy51d7w6gRYimGQQKf/Oi9dfrpgMc9Tbjj0YfVUHrN4TTXiBrorDVY7ZmUyVczltkVQZS9shLjb1aeV9YtOr4qyiof3ySEOMTKcwch4tkNTYYRR0r7o2Zfn1MFf42GMsOCb+dZPBLlv3CG4aKVsnwvdKo9vCRrRiUBRQMCVBXdwvqHHytbLhvBEH7A==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a84e1b-4838-45ba-04e5-08d85e007f35
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:30.3085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zIC5AilGblhLUtRzJkUwMsQTmY6lL0xjQw2gG8eBXaU40zNZZdQVZku6ON7aINdhk1xDWRxOrkwsohHBLjUOdQ==
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
 drivers/crypto/caam/caamalg_qi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index ac89d1dc361f..a897eea59790 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1408,7 +1408,12 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	int ret;
 
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

