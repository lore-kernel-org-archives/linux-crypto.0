Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD8FC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8A6920786
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="VqFWwVlK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgHFRGt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730047AbgHFRGU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 13:06:20 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB5EC0D941E;
        Thu,  6 Aug 2020 08:43:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJX7945/rW07qjfTYtG6MGB19xI/RC7MJ+im8670in2pW9HSXt63CKt7cz2wp6+RI6H/nRAvxQe38DRzApv9301jW3XsXCWL+kgD43+YdURObUtp+eA5JG3b4YCUfbIvfKEHM2twvNBC5bFx88HhkCrZgNtl42hUOsZthOsg+O0axAWxDNid1MjL3p/Mpn6pnu7x1tloNrpGSzFm01u3zJMcbbcyDajCkTpKnEi4DD6OwQGTO+wMmzb5K61rUpYqLqOx8di9rSjSz+wM+a0p9lnGeFY5ii/fl2iQrsj/wuE0eG+K1qWeMmAZhnMt6vkbGcEAbj685A8opuDC1WDn4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgZtPL4Ibx4wosYkqrEpR4/2iTIOpPK1UPEReGFUPoc=;
 b=IhZJBYR+/K8LAZ1+v3JCFQWyrPoL3lcOPhtbiKq8RR03l70DTf+ncepDzwmF9c1517bUKRmJ6xN28HuhWxbgHD/H3e63orIu8Zx41umgc3H8c+zAQoiASovNykiqbYYXBrGS2Gg0NnpsI3xo52TNSbquAMq5OUZJ+1vBtyE91wAYK2dWr5dW9BmXlLJbwgDWmutF9yAuvbuLjWovRZG0lTJHe1YiYM3QTvVCV5HBT566PxJf1lp79b4NLP2I7IPPAjaYR9PSQAGRYfF02flwldLrkGYq3q/iELHeK/m1lKW4aACXuZOZCaz7xwu1utN9pRBJ7Uo5xGvX30vXPH8WMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgZtPL4Ibx4wosYkqrEpR4/2iTIOpPK1UPEReGFUPoc=;
 b=VqFWwVlKdhUfwoeK4Q+TzK/GK50yqKh7fkhNY3BHlVwi4iH21fAXLeDLztXXNLlEJRoTwDnrZCiY0/zgjxS3hk07a1Qp3kRYcSU2UFjTxwcX+4fRB6KXMZBf6r/9khfc1ExLH2CoIYN2aOFKMULZZ84KJhtTie4e6V+Rl4xhcVo=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3440.eurprd04.prod.outlook.com (2603:10a6:803:6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 11:41:58 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:41:58 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] crypto: caam/qi - add support for XTS with 16B IV
Date:   Thu,  6 Aug 2020 14:41:26 +0300
Message-Id: <20200806114127.8650-9-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 11:41:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aabd6133-543f-4cbf-a8a7-08d839fdb8e0
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3440:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3440F6EEC33A516F5851E824B4480@VI1PR0402MB3440.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jJbLgAPtOJyQDjgMJCZLMA2uU6S7XV/PnE0FAXH74m+3pJ1If9go0BQp467tagY49ZAsYQ9zjlLmBucLi0TPS4zLJqcdxNlB7UMjTZz5VlT2fADJ2I6peyugCPa85TF5PX02h+mNlDDnvMAJNi7UR5CRDkKXyZLguRSBOEkVnM0KOZrEHgNVg3NROqlp3imKmWA0hKoZvys3p9gZHa4KBBAbwOZify/qfb3pthq5i5hlYjzY5t8eak45TfCRIDftTy7shQ+NMnIbHZwoiTW0W0qllVD++AJWkSGrU60497DMOh/yPwURMiNBSwkrGsaHM3elWO5cwgvrTKTEfsttAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(110136005)(316002)(6666004)(6512007)(478600001)(956004)(2616005)(6486002)(4326008)(1076003)(44832011)(52116002)(6506007)(86362001)(186003)(26005)(16526019)(66556008)(66476007)(2906002)(66946007)(83380400001)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ENaLEt3MU1ccF/ZeZzV7mtPiW/Dz7JDMLQ1V6gYOb8KP7NHV6bwK4SG1kMZNAaxskQKi3jhwZ6p3nHqKL9mVQbpDQRC8DDeQ8ATdeoG/3x6rJKvL9UpKecTDPzZrIQmq8YCxSWW2t/KMEFIZZUhZzucG8Xxpdk7eU3DPYI06iezo1Iy8HYUA/tOs0uDt9y0iitOQjlM+gDxqXpNByG+dpKuk4RUoNIZTbe/1UWPuhQywFFRBQWXPG+UqkNKypH0e5k49ygV7du2YYG11mVwJEkT2jRBfiUyQaZbfi5++0QWe78IuzoN7qVzDYUI7NdScJrik9MKg5k+/fiafR9NDwC2FP5R1vyGoaftIM0VpiEgpOO5mmnzc+BqqwbQbxEnYCI4rs/wiTTBbM2w8MoQqTMwOWl+5vln/HIlvX+d8ucB9oT3pgJYyBxY2UEVvZdoPCgmfpDya8Y+jcXXTUAKMwFMperaeXePm6p2ow3zehVwVld6FY1jIPlkYoGAkuGJdLBJlxNJFIgHGl/lJgorEe98C9//i8eQgbjxV9l/z2IA6eyH83rKQ/2jW/w5l9C2UYo1Zzihw06qeMTcATForW9KuUwum4xKgmLyduwNOmW2/QvETOHarQpybc6yw7A0Lg0Ixa0TULzMUw3GT4fSmIQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aabd6133-543f-4cbf-a8a7-08d839fdb8e0
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 11:41:56.5364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5NlDTvfxPpGzfebwLbuT9N0j/e3MsFOr+Yyr2HAjX/jXeyFyMrvp9JTHE1FvFzC+oVWBZcrRZUbKLmLGPNbunA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3440
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Newer CAAM versions (Era 9+) support 16B IVs. Since for these devices
the HW limitation is no longer present newer version should process the
requests containing 16B IVs directly in hardware without using a fallback.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 1d775a55fcf5..df58a899e97d 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -732,6 +732,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	int ret = 0;
 	int err;
 
@@ -741,9 +742,12 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 		return err;
 	}
 
-	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
-	if (err)
-		return err;
+	if (ctrlpriv->era <= 8 || (keylen != 2 * AES_KEYSIZE_128 &&
+				   keylen != 2 * AES_KEYSIZE_256)) {
+		err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+		if (err)
+			return err;
+	}
 
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
@@ -1405,12 +1409,13 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jrdev->parent);
 	int ret;
 
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((ctrlpriv->era <= 8 && xts_skcipher_ivsize(req)) ||
 			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
 			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
-- 
2.17.1

