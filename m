Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393A0C4727C
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC739208A9
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="WXQwkRIx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgIVQEp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:04:45 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:40665
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726686AbgIVQEi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:04:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvIdZZJ09jqJ4FkSCQ41F81UFnRbz8bgcfIPgE31K9uZ9nr/56qI3eFd4psrs3GPckv3j6q3mTHuSJh3M4X1mAWkFHVReSa5xZ7FEQhdHEhas9JsZsrlPCIUEPum9+Qu2jLaIlfC4vV1NHQDuayw+FA/lH6cTyYlbx5v3SOaHzIP5Vv+8zk0IZ2g2lkYQf5aesI2LnmoBtzLI4Q/SOqwhPf3zvPvUzycoN+X3+LUEYcnQblVcjzLAL8NqOJUZQD4l5xSveHTirl1AerTezvHUHSYOFW9hJjOrbO9YFYF3AxMjBviXmLJgkag0ekQHEkyTSk2Ws6JntfhQRGRM1OXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdmwAi6lysV7Yyany96bcPU+bY7oIv/8W/poR+1o11U=;
 b=LviCofloKfvwBd+vsRsI0GPAe9f+p8Hq/CrjF46a5SWEDwukUDKNCnUrGEyTo4Mk4+zGpCZ+fb1m2SvmafkHzhnpWFzob9NYH2hlK6bhbTIdkhRvvpj2BQGvWaGI6v/ergU7Rq76Tn6Ih1353q0XY+fRifRQPupADD48/KMm/K6NwMnT36DSJ870G5FF7XWbFJ7JKJCEP8EY/hGNLoGrnufqF+2zk3xvyAb28YFvRg2XmkdQkeblx2k0LPQM2TOwu+519yaEabebzOrDr2shiuT4G1tuNf/sMVa5AgtKtWnD78U0x/zZrLP1dJm+3kpIqwgICnMD8Rgc0WXgqG6OYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdmwAi6lysV7Yyany96bcPU+bY7oIv/8W/poR+1o11U=;
 b=WXQwkRIxsVUeADx/rYoMmSMb5YjZSkzTlKJIY3k9txDusuwK96PFTIZZ8mgIuSONeKaCPfqbmd4Cy/RNiUO/cMhe9CYPAqCxJKOSvGk2XuNeXNnw4xEWWwJan2KH8DhP7nyvnBGtJaKO4b57TC6Y92qrB1ddbinvfs3nj41Cup4=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 22 Sep
 2020 16:04:07 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 16:04:07 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/10] crypto: caam/qi - add support for XTS with 16B IV
Date:   Tue, 22 Sep 2020 19:03:27 +0300
Message-Id: <20200922160328.28926-10-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
References: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0022.eurprd03.prod.outlook.com
 (2603:10a6:205:2::35) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0302CA0022.eurprd03.prod.outlook.com (2603:10a6:205:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Tue, 22 Sep 2020 16:04:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b14814fc-2879-4d94-0ca5-08d85f1122c8
X-MS-TrafficTypeDiagnostic: VI1PR04MB7072:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB70726455F81CE8C9D30D8262B43B0@VI1PR04MB7072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aKGVkwk0VrBcJ75Tf8NsSqekfEXqFmZRGS1xNUTkMgsvX4dpwDVta8Vc8WFh9XG4CeV4OZQRu2G7Fvpf3P+X5KKJvZoyOSFvj8je+jM4s5DDapapapik3u3CSfbAg+XctMRY3C/nyWC8vdteCb2Pznj1kOBAih6+OKl4k5YBqBl12M0iHQ/Wqcvcf1bDZQ6ba7XkopD7cS4PyibvX4GFYOwoXftO4INpaRBQvHfqT3ZjziMBoHIcXGs/TN5vHV0GoqCbNf1uKztpGcxefuClaNX73kPMKtfsOlJEk4gp0wRK4JRdYrSINwsnMTNpPQNL/uwb7sHuMyUi5X92WQNMXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(1076003)(4326008)(2616005)(6512007)(83380400001)(186003)(16526019)(2906002)(956004)(5660300002)(66556008)(66476007)(8936002)(316002)(6506007)(44832011)(66946007)(52116002)(6486002)(478600001)(110136005)(8676002)(26005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: w+oHvRNQuuf4V2m3bPNODJMmW5AxCCIg2nK3TM2IjexVoCkzcpbyT41hgyVbNZ4Q9uGwENCsCUv4RJb8H1Pzd6BQzf8vLxmDZxRA7UT9fw0hf0bgLhFEHPzrxyTnrBlpX7H/n11JtHkXv2YERp08Zb1OvS94YUEHwRqdiKQRmIbaRX7CGx9mSZ41raFLxtdALPJPArOe/Jkfbztjh0h/o/IDKeXaRhGjsr2NLW7aiLNap4ZzHmM8rQKzn1FV4X1dbrQe1Oq+FhdXqhduFGT+zezPbv4SunnzCUCHf0WhYzedhDc2H0FVrDofqQgvX/q55HBmbBFLbw6hg94qjXqFbxYZjsnFExxovlEKPZbP1Cd1J0+bJwhd739cXLSUIb7Cseio6zRflcp6cbQXhY8mtBIXXpwFzjF/k/wrO/HG5iShawWBJjJvAC6sXhDmhRblXCeWmBCMOvECqCKVTNLxvz95v5VBxxwIUnGKHFOFcoGjTOydbfiKUXhajIP6qPU0VP+1AAm1a28jy4tu3N9uaao5W2aoq9WGDTTZmZ/OpmFXKKRD4OLfFQxu7BBRzTlO6t8uFT6n1f1tpQi4hY2OVNx2Wc+GTFGAo8w5Swn3+rQBaaHUuyD7OgBJ4uOseiJF4HHC2EyJFpVsgrChZMNLxA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14814fc-2879-4d94-0ca5-08d85f1122c8
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 16:04:07.7452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9qMkB6CMQRnW9YxSzPZDD3U9gNQhi2dvZljKhticdNsthiPrRa8AZPY0/fQNmi4j7JPU0aOAN2LDMWrSJ3IuBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Newer CAAM versions (Era 9+) support 16B IVs. Since for these devices
the HW limitation is no longer present newer version should process the
requests containing 16B IVs directly in hardware without using a fallback.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index efcc7cb050fc..66f60d78bdc8 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -733,6 +733,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	int ret = 0;
 	int err;
 
@@ -745,9 +746,11 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	if (keylen != 2 * AES_KEYSIZE_128 && keylen != 2 * AES_KEYSIZE_256)
 		ctx->xts_key_fallback = true;
 
-	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
-	if (err)
-		return err;
+	if (ctrlpriv->era <= 8 || ctx->xts_key_fallback) {
+		err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+		if (err)
+			return err;
+	}
 
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
@@ -1403,6 +1406,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jrdev->parent);
 	int ret;
 
 	/*
@@ -1413,7 +1417,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((ctrlpriv->era <= 8 && xts_skcipher_ivsize(req)) ||
 			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
-- 
2.17.1

