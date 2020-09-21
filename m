Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75763C43465
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23FF8214F1
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ZJx00N57"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgIUHcl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:32:41 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:47332
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbgIUHcg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kq+EOUysVdsOh9axZvrikGyAeIPcWJfN4+CY9tir6xGqQTKtfrm7I05JlWhxN8YZpqxHNqraLjYvrRZEjK37mMSwihTICmhaADR11ZoaYgDIg9z8G8JmpGuX6k/auBoppCyHQAV+h3LAhCTURap21W3yzz63Im5gRZeWb5aPq2Dzx8XZ5R1+1Owa0S3YBYBrnIHt4wVEo1ukZ6e7S8bJypO8FFyrNna+9AWPn65VTfUXwiMbwLmrmI9lVE8xJorhcgY0IS9rufzpz3ppJP6uZB26UPqVexVCtDxYOBsWa70W/h5ccpMlU/PhxARcsg6AZuFlCu0nfb/PcYWwU5Z4tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zl61BGFfdJndxx6p7qMFE/zAW9VmRM43BnNTjbArpz8=;
 b=gZ1fZ8io/ghsT4BjRxEKUMgGe0kYxrdvkN1PHYQoE1U6hMwnjVd0pms/iHxkUU3X30mW7QWi8DhrVMbRafz7z5r/fvNFI49Jt0wU27tHprSGDeqoXe3+AQSeglLJObEwhL06qlG3E2IespnJUqND+6tK6r2R3whkTjBN2tQUtR7+MjBWl/rP+XZ2ogNpRI9TJrkHfd+/xgN/h2kQgD00aHP/Wx6UWCF8JnaBZNrMFVn8bfN+Nw6U2oNcPp8nLoRJbRLmzx/aO3bItRWO6yXCHKOQnxfb6qGZMJ72UvkGiX4YnCM+01gmoNdWb7YGHHw8LlndK4CnkVuNCwgQrCCL7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zl61BGFfdJndxx6p7qMFE/zAW9VmRM43BnNTjbArpz8=;
 b=ZJx00N57jvHNcz3m7ZAh8rKiEp7fDtKJusobWas0iz2EhJEeTFbQTw/0Nx3z2+XiIneWm8bLNBtKmV16cKlnJPgrLRJJCi6j4gdu43xwjpUednGjuVKhT6QA9TBcnEkQA01bW2MctpscL3Dk5hD3fSyDIt20N/U2tiyNCviyKiI=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:27 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:27 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/12] crypto: caam/qi - add support for more XTS key lengths
Date:   Mon, 21 Sep 2020 10:31:58 +0300
Message-Id: <20200921073205.24742-6-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:25 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f7af105-e40a-4b80-cc73-08d85e007d17
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3903B977D3F297FF195380B1B43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jY1cRdg22M336s3rNZXvQBaeIskp6NIan0Qr6c+P2T2Dfs300j8ttFfdwBPIJv/U50ocJu2V04Qfm41/LIRMszUHNzFEwb75Uz1mdLwcOwLXf7WeziSkkVdE/AioJBFkdF4oEvU2N0fLgYETTLjGTCSVUzsQIdhfTocuG59mzAy2R4bSd7R/Ot1FyH964iHXap5B13BNW4Za0tbuiFzduQY9lbuF4Ss246IRXlOwWIVGvEgwWgy15IhETJT6A0WgcqqChwSSg5RLFnGNIqRhbWYx1IyJCF7TOYgjkTqqg9GwoOfJyfQAcpMKbs3VGB7Obab7J/aTgPII8EvvuEWEYFI7Kp3fyGvm6xCJjwhST+I4uqRl1riJdRFykevM0WcP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Y2UyT+baaWEpBAQzwx3xVTpeAcLN6sP+avm8LYVDF+a/uAuoSShUX8X115zHdqiqgiaqTnn54Cn6pO1FKqPuzZZe2BbZa+aF54A0FDTPz2OFMroeFG44bqrdKtkoMCgDOZk/My6MA0tQU2EvrmPAqApqa687fjCw1fl58AFTWe2KG1w0MDM9ENFqau+rcBhY2fe21dhx8+x0Dxyil0JPqf5ky9RgyrB2xSPeTy/2+Au8CjIljBP3TaXB2CP+5BjjVR2M94Z5RXZFX8VeKU1XZVlL7d2Vz9usygi7wSfKSWL5sajwN/aUc80w1s6nmFg6PxlP7JmagzCuZxYOxcxwqu0Hif6PShgqDgSYFM2os/jnjsmUAh7pJlQKSM5Kkem5aVBoM44C1LCBJFHm55dGbSm4Hb2bN9s2XzeipHS0kLbA1Y9RWgmqJKzTUrf6npOVqAvF3cdhRu1D4quU8BHnMpmWga1Gcd1MIg2ZMKpY7u+ozaJurFPpMbde9U8JRLjT/y0CY2wWCLDzEIY6pZniCEzdt0zY99mZ2RRMYpePye64+tywZlcsi4+WmFxurmvylaGl3zB/xotF5DXuch7e2tayms10h2b0kBn30OJ6XkmhOcBozEBV/4IXKGZmwbuKd//siSuhssrhqGMQKUm43g==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7af105-e40a-4b80-cc73-08d85e007d17
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:27.0204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGieC2d8oij33QOYDyBABf3PMdsEn5imCPs65chp7IwfbnIXqf55nh15XNPihmnTeMXTObre4BUOpaehp9/vFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

CAAM accelerator only supports XTS-AES-128 and XTS-AES-256 since
it adheres strictly to the standard. All the other key lengths
are accepted and processed through a fallback as long as they pass
the xts_verify_key() checks.

Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 2b5e694fdaf6..ac89d1dc361f 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -18,6 +18,7 @@
 #include "qi.h"
 #include "jr.h"
 #include "caamalg_desc.h"
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 /*
@@ -68,6 +69,7 @@ struct caam_ctx {
 	struct device *qidev;
 	spinlock_t lock;	/* Protects multiple init of driver context */
 	struct caam_drv_ctx *drv_ctx[NUM_OP];
+	bool xts_key_fallback;
 	struct crypto_skcipher *fallback;
 };
 
@@ -734,11 +736,15 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	int ret = 0;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(jrdev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
+	if (keylen != 2 * AES_KEYSIZE_128 && keylen != 2 * AES_KEYSIZE_256)
+		ctx->xts_key_fallback = true;
+
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	if (err)
 		return err;
@@ -1405,7 +1411,8 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-- 
2.17.1

