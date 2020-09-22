Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C282C4727C
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 204A72388B
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="T1y1iGMR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgIVQEk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:04:40 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:27291
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726798AbgIVQEj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:04:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mORe9buQNx4gseftsbTrWGDCtYZc5mpH0c3Jf5nSYG5LozOpfUusu9qKUHiwDvDgz0CIkvNiI4MEDegovb/5jKXFDAFb1FuWL6k3hK3ri1z162qUIUI2DH90ZkR4huyH2LwzofwOmEJxd0Pvnk05/AQRW363DWE7V0cL/UkWWu+ve959KC825tj/dSfrYgSOl0pTFORZcy0zc1mVbOgaS1G9PJyTkI9jM1zPqra6CaSt3UUUBMh+T74phYWtnuTUwqcJfLnxzSMSVqukXGxagE3PXuZlYx0MxJrWnsyUjrekBXNz1/l1gSjzPBWFZTvR0y1IGNIf3bLkMSdQdCim6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWLZWk0K6M4aVXUtQJTPqEDFY0xc5S9p9K5I7edK7Ig=;
 b=klqowlr4KeACyjfHt8vG6NszMOee1+weBDXDNHQHlfMuoPCTzn+7zKCR6kFYQIl9MQTh4Bz5MzEuC5dXENZIiS/BVQ6Nb3wUljjJlx4Vf5HJZA+iqJ508kKKMtEEhl6af7m2szyXr1LyJg9PhGMJwTXbGfzzllV/IsFtk/S2DblnRmJhqplTJEoSNg2RAz17sZwtM8nJ9lfRuTlSznjymB0t8ixvkcLjRKZKKiPv7objXLa6Yl39Nk6GxeF3BZ/ibUstz5VQLNK7R2vCGECak8NblnVcRjM/aa5PwvgiyGHFZFPGQr3nKI4NaO/VuI80FnEEBO8N7c38gLXSQJAZvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWLZWk0K6M4aVXUtQJTPqEDFY0xc5S9p9K5I7edK7Ig=;
 b=T1y1iGMR+eNfJsOHqNwv+zgPY1BYMtAHrnWLf1rgBuTJAwiWZvQMFm7h1HuCCHfySlTQBctnNYtgZPNkakS1rFUjYfkt1GCWIgpsi+bVklLMtX9QyKXEddO6cZJsSfcFNgEePKkfNFPtzSjD7RGJ3rfe8C5ETHG2yv3f61A9Fh0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 22 Sep
 2020 16:04:08 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 16:04:08 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/10] crypto: caam/qi2 - add support for XTS with 16B IV
Date:   Tue, 22 Sep 2020 19:03:28 +0300
Message-Id: <20200922160328.28926-11-andrei.botila@oss.nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 746c4d53-6cb5-40bd-1c40-08d85f11234c
X-MS-TrafficTypeDiagnostic: VI1PR04MB7072:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB707291F87DDF0A06053F280BB43B0@VI1PR04MB7072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l8tVSVndNgtIS4D6AnqDCz3ykNPnTeC2ozAuM812Q95tqxdMz3Kn1DWMSNwXsGaYJMnzhF3dLq/hbQGy0+y5tK6pgOmtvSOxILESso8ZYBuP7SBuogU3V9njfNxNjbPVaeHDKJxo08RNTOnIrxxmNBgCSOWZ0066SwGuH4Yt63pYv+Vjb5onhRnMyWTUoaw+r9R13Lr0kgEmNbBeRjxnjpPGVqs8dtiad/BRn0AYJk2Lpw/mf+o9dTfPQhSpcuIX8BsZMlelbms0v0O13fZptvwJjkZQ6SxUuZVveZISHRbHuV6hxJ4eq4kfBwSjZUnqoKI0EEl+vNWVji9QhMyrTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(1076003)(4326008)(2616005)(6512007)(83380400001)(186003)(16526019)(2906002)(956004)(5660300002)(66556008)(66476007)(8936002)(316002)(6506007)(44832011)(66946007)(52116002)(6486002)(478600001)(110136005)(8676002)(26005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: b5BlRy7KtTA4UO3RNM4+/YwubGAw5EY48agELoyS4XM6bXATPjoWjZWtw6/GbFpNaCkwpZiVuYxTpVut2Wovg2cOu7DgVKvRaPBbTq9Utrd6ynrmp5BDWl6FnUU9A99wQibUXnsI8jLxU3i0oDBKUCOvTt6OH9sx+PyVNL20ATVqFyYsuja5b1JCgi6hfuf0txKkukkGtUMpxlajZQvexRBwD+vQ7aIzKVVuUApPtJzWTHYpa4Pxpb98wWJX/6zL46XqORbfYpnpYE3b5NDO95qbK7cSCMsZ6/oliIiKHXkpLAsno5IpkfsLaqSBfzBrfSfWRBvPv6skUcik+3R68If0eWBfg4KyFcb6bu1bixo83gDclQGb4K5M9OE2nqZsixnIqNZLn2mXGzJOEJGpOg5uqq4rbYwpaA3sdAYGycm0fFjBM6+9viexkazvp5f6CH910UBCLnXSKsQ3IAva8xuJTHRndXdk7BNk2wq8vq1UJLYI4UC9Th3zHgBZdmtHa9xAUvPJaCUt2W5QpjEY2Cn8BxQ2ut7bZbYfN/4aF27vlIkLe9pRBWhJ3hH8LpR4dzBTeIW7zGU+6F19I+rmhs0thy3FzhPsE0L5UxTRMJY2eAee+CWczo5TCg/lk7/hOGsemVbhOLKwuHVhFo1N/g==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 746c4d53-6cb5-40bd-1c40-08d85f11234c
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 16:04:08.5917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mvWLsVCth++q8/QcQ6NaDY3FDz3bYVT4BVVgDRVHXZj5F0Klu9djecYvCuOqMNFYdlRJ4nhLX2uBv22z8gLOFQ==
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
 drivers/crypto/caam/caamalg_qi2.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 4cbd7e834888..98c1ff1744bb 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1058,6 +1058,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *dev = ctx->dev;
+	struct dpaa2_caam_priv *priv = dev_get_drvdata(dev);
 	struct caam_flc *flc;
 	u32 *desc;
 	int err;
@@ -1071,9 +1072,11 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	if (keylen != 2 * AES_KEYSIZE_128 && keylen != 2 * AES_KEYSIZE_256)
 		ctx->xts_key_fallback = true;
 
-	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
-	if (err)
-		return err;
+	if (priv->sec_attr.era <= 8 || ctx->xts_key_fallback) {
+		err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+		if (err)
+			return err;
+	}
 
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
@@ -1470,6 +1473,7 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct caam_request *caam_req = skcipher_request_ctx(req);
+	struct dpaa2_caam_priv *priv = dev_get_drvdata(ctx->dev);
 	int ret;
 
 	/*
@@ -1480,7 +1484,7 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((priv->sec_attr.era <= 8 && xts_skcipher_ivsize(req)) ||
 			      ctx->xts_key_fallback)) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
@@ -1519,6 +1523,7 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct caam_request *caam_req = skcipher_request_ctx(req);
+	struct dpaa2_caam_priv *priv = dev_get_drvdata(ctx->dev);
 	int ret;
 
 	/*
@@ -1529,7 +1534,7 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((priv->sec_attr.era <= 8 && xts_skcipher_ivsize(req)) ||
 			      ctx->xts_key_fallback)) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
-- 
2.17.1

