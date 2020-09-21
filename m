Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EB6C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 358842158C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:33:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="BNHcE6Wu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgIUHdW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:33:22 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:47332
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726460AbgIUHdR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:33:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXDgv5V2HGdYQTN4g/L2p/924wlsTv6fW/p82xHqJjLNPB7AsXPG+dJlJceFWjWfFOVbN9z7+fzpjAggeEfssBFOleOdm06rW1peqGA3nSGMDFMlsB0PRAPJVXpxcOs1Rz8x8Qij0oS/AeJBvlB0GJwRE51Uj2mtE2TQL4AJMb8f0bsBRfHVVY4setv373Fta9uPOB+IL8SbnbUwyGjxno154LtR178tK+vbQkM61uYjNfmGK0TsQ4xzanxOgtkxVDVcGtBZGFVOmlyJAowt+sB6da137kQSps5JQK4Ohltrd25k5G2w6Ttv+qhzCCXIVJN/pntxZ5UVM1ahSMwPhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uJn+7atheAN3FmUwxsWABt/krXzGRnCWJpN9rweB8U=;
 b=N/+4XvgXDPL/mEY8cKLiWurzGzDVBd4uymkGtW1y1p7gH4ncj9XBuSLJ1D50kaIA4zAMYFh2F20Po0PF43oLc/SbmpEA4VefV8FaU/rW7mvPIRyLd9zlNMll9EPPY5ZAoLfxUIesmsJ/7I9TPxeIg3ZcukGYclSV0QFrvn2Ovcp/eP7i3gx3jQgrg048imtMjQ2K50Rg05Cv4ueJYg9lOvZkKLT0N/pNvR5k01Dac6aFOuwIGdBGxWH0Zv9XrKNZq8WH4G9lBFXBl3eO8IKuLcjw4GQsUkHs0aj3ZHH/Ygo1Uvx3zJ/JfCtDYf33mbxdPd52LsNsqT1ETVHQuQAz7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uJn+7atheAN3FmUwxsWABt/krXzGRnCWJpN9rweB8U=;
 b=BNHcE6WuzFGM15C5Y4a8T9bropjwcIFxz4LNlmJLPYVT00c14VY9j1z7SjYj8CapQpY3cmkb6aidwKjq2C7K/XbTN/E3p8XsAn5UPxRWV/XMQTuQ3DxZds5xs5wi+ehJW+YSDNb+Kfw3+ctx3BY+nFhk5HDUBoUW8RUdHxeyqzU=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:34 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:34 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/12] crypto: caam/qi2 - add support for XTS with 16B IV
Date:   Mon, 21 Sep 2020 10:32:05 +0300
Message-Id: <20200921073205.24742-13-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:33 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a86a993a-0b05-433b-afe2-08d85e008176
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB390380E1C79810EDEFDD91FBB43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4Lx6rnw/VVTSr52mveGrStr110bI3+CSz9Ignt7ggvsKZ02XIandw3eQNJXqnqvqQyfBRIdjxIxBJIZ4xqa+XacbfORLxPpSuP5506Nnw/pmovcra3vbJX1lnLXa3BS1T94p6vjdVGqT7umrCHaTaYSJxKEKpfsd+X5Q2eyA8osSNrp2ytSv689g6rgamiEjr3/k1B+DtPHTDRzTrmF8Rklxw5mCSWIScF67Vb5FAfLg4q9TFMKc5ePLPsi2xZal/0H6LZ7vr6q+TMcYoRY4R5ab6Rvbw/1LDQM5UZjHCm6pqWZsnWQdQaW6Wg6FS/rPJmhRuyFv25t3Wbw/BwSAVvdV8fFWs5NBfZqr+4wdOG0ARXQNooX1Er0B2bdPd+6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HKWYHRtfC5Sj4HeYKSdl3R+AIJFmvJG5cCMalcwaJ9476cBZVS6QhLEWykqdmqcU/BsGhLbTzRLdYn/mB3Cy5YVcj4L4uT/gJqg1YRqkswF/ldjDvVhHbwHZIYKxDDBIivaRdpKV3Z5uOLey6H9GfBV+bJ4yL4Ox7bIli9hJKS/Ry2U7UlL2fJybQSzV/R85+Ps621csVzjtXHNE85JhOgL1IOphrZOhFN3kD+UvfPEndzs5aryGyqY3x9L7Y6I2eQWy9PgxkGFg6LwQY6eFJBsqxwCoeQl7qmwLqWGlTLixfnRkGSmwxPzIPvgiLAM+yHz+liiMC6JBn4LQiFx+MdUnKoxCUJzGZ8Egu0ozX+XuZC49eWI9x0xVojKJkMLGh+0E394c2r18ePACnx0+1k4XDwyWIAS02Jih6Huh0CgjxQTInwhn4nLQjiemi24PgSfwqIoDJSVEQ2seD+vc2hgVu58soSyXBEpOzfyft+daJUFP4GnM2Wq4O5f5PY2b+bpkcfelyVHR6fQ/+UJiWuhNwG+p0xlGHpCK4IMNc5AR9h0tHVeH4Hqrgs1ZfEBDtmvEakWAL9Fkgw2k6b043b+hLg+Q8fQ/f+ajh450AxmzqU7+ud47Wp7unH32Bqa/2bZbAblow73el0B8zjZG2g==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a86a993a-0b05-433b-afe2-08d85e008176
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:34.0064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UikW/jpiYXJWuzf0UhyZRQUYjoHrIk3bd0JmuuKoq1V87VUVqIIs6CxjpFwo1AU0g1O1xonBINZEmzKLhzn16A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
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
index 592f4a0344ff..a0aef64ea2a9 100644
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
@@ -1473,6 +1476,7 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct caam_request *caam_req = skcipher_request_ctx(req);
+	struct dpaa2_caam_priv *priv = dev_get_drvdata(ctx->dev);
 	int ret;
 
 	/*
@@ -1483,7 +1487,7 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((priv->sec_attr.era <= 8 && xts_skcipher_ivsize(req)) ||
 			      ctx->xts_key_fallback)) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
@@ -1522,6 +1526,7 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct caam_request *caam_req = skcipher_request_ctx(req);
+	struct dpaa2_caam_priv *priv = dev_get_drvdata(ctx->dev);
 	int ret;
 
 	/*
@@ -1532,7 +1537,7 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((priv->sec_attr.era <= 8 && xts_skcipher_ivsize(req)) ||
 			      ctx->xts_key_fallback)) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
-- 
2.17.1

