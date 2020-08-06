Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6C6C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19DCD206B5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:25:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="NulZcUOO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgHFRZe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:25:34 -0400
Received: from mail-eopbgr20067.outbound.protection.outlook.com ([40.107.2.67]:45317
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729432AbgHFRZO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 13:25:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRhoyRc4VkaFutzkk4uMzbuNdZlBpB8oS2Q7ij6g+XejzqoeViGyyS+fTsRv66TEaZBIE3bK665AW6I74oe1v+/7BZPoKJYHK9aHCM1SAlhMqxEq2o5CLgzHOXRS5Xir6pXRrMH9qW4e1/iP8eM1XH+ug1uRhbDBiJtDTex3ie7F5rYJhSlc9qHwhA3z99HjtSJRu1uD4xNPD9NdrYppTZMsVrWUiGH/6o2sICYA/dTsNcktbXVxu6qGND1CP58s4H7CABlmQJZIvw4NEjZWeShjESi4S2oEXgF9wqsoL/eCYTzVTWXtXYG5Lh8JQJmuBRQf9bH1BB1nrTWZuEbXQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIjB9Rl+VRm7VK3Tw09Xzj/S0WiJewL5eXiGQEOxIWI=;
 b=IfjCj9fveCjm3p59+9CPZl7tq3GDpyfPZ7izDJ0Y0mtEvVCEcYUAEgTSzlYk7Vbj22cqNdUK/yqGJ/F1r/TyP44P6fjI4DQE2R1PMxGLgQ2dV9+lTVcpqelUCyXPDfYWsfmyVKLMi026wGQ+TCGiqVmEzkLEUTxSdqiA24+pZCvjQZdn6jm4YZlp1uiuFf4u1jRhbZahqIcBf1WUMNAsml6QlztNvz7kZ6N2HB2a1aI2D2jObux+OuT2QOgb1zyKq5c0I69PfLc+oa1g5j+fHsSZRUr8dHHuRE2lqWlakgjT4xeeiHM/Nn5QZhgysh/uaeyHelwsEm4aY+W+yFeDsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIjB9Rl+VRm7VK3Tw09Xzj/S0WiJewL5eXiGQEOxIWI=;
 b=NulZcUOOhsg00qlKaKs4qdwf5diCE9mkhzUBnffFi4GuW1lf0w1CbD6fZ3Ehm7h3GHF0ylQp+6OT1fHgJFQ9EsXd+nlU+5NiKMs1dRpZfIsz8v0RKI3fr15npCob11ijH7y283KcJjxFqYzhZpUIARYvuCmmNbTYlDsse0REy5A=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3440.eurprd04.prod.outlook.com (2603:10a6:803:6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 11:41:55 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:41:55 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] crypto: caam/qi2 - add support for more XTS key lengths
Date:   Thu,  6 Aug 2020 14:41:24 +0300
Message-Id: <20200806114127.8650-7-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 11:41:54 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 285cfcd2-7ca3-4e9b-dd20-08d839fdb7e6
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3440:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3440862AAC56F3A4ABC5DF6DB4480@VI1PR0402MB3440.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q9xIB5HLaudml6iDm5epuzXvfcLrWrfQXDwfY4OJ3XSeISZFh14KX0HIWXTCslZohn/QOXsOvTQ6f+UqbmyoKUmpIN/ZRGnOODc9ZoHw+7YQWJZEAKxu+dToTNIfbol8YKMdYTclxLgJ9Bd1r3797nQYB27f+uRqXXMWzVdduvCzjbjPmR6ElWHO3rrrUH/yeo6u+p0c5WlVeS4qct8qSRg9EQNKERf5ZbIIt7cbQZ5Vh5lXIhZx6rxI1tklmO76Gr6UFS4YR3DLiYBNPzA+APTQq2qfX0ymyWLkc7jaCFxAbflRTCMuD0SR9QAOzldivwIOb32aVlLCPZwz5RlDWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(110136005)(316002)(6666004)(6512007)(478600001)(956004)(2616005)(6486002)(4326008)(1076003)(44832011)(52116002)(6506007)(86362001)(186003)(26005)(16526019)(66556008)(66476007)(2906002)(66946007)(83380400001)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: s180gEXho9U09YfC2hPMJ97qoEz7DbHyrk6hzIfX509hj83P+iGIpfvmGAfUXYBChVQ2ULvJY0fvezGWJ/PepgjyxBBpsrYIZUNCT9rHDciTZpXCs+Oa59rENViGZEYcnhQMr6JguKof/dPIqoMm+bVGhbY0Lowc5iL7UbRb6iuMWCjy9qJKl3oTz7IM6mgOoyeJhZCaBIrWB/nYG2jg+iFxkJj/COgxcaT8AC5e1Uman97qD5iNtDuLKr9YlJFP7toowArAdvi2m75bj7vY22kafstOcFY2z6ku/MbBRzXCW8LozTAfXCSU9X6MdcOo5RSV3+/eL59UP2l0xgkKuHd++gI6J4t6CpgcbPCxj45NQvgBbVP7qgeA0cfbFIHIJaKIPcUGNS4jrWIfxJezARNkIgxhYsWqGNNs3s8HrcSfJvxqGiDoXFvhN17hKYQmKgEl1PSFc6YKI6YXpz4/QPeFbepsAuL15KB8dOZpCh1d18fBDU7N8xLObau00R7gg+B2Nheym1bpNYxCvPBPLR6lMAAOy+4s8BfuMLtwB/RIfARR6B6ZgBlak29TjiDGQyu9OiGfiV5/+zmAdBswj2GMdQ/DXCLONNfKbvqUaAmJc5bVvW686wFi134zDIn7cU68ufpbg2nLe0alDG5Xnw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285cfcd2-7ca3-4e9b-dd20-08d839fdb7e6
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 11:41:54.9153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kzezrx5XfaSK8+6jljV6gqRheIJi2v/dtWQs0rOsJi1j04YZTJe038M+vqlKfH7Ezaf+RZ7AKY63hYGyP6YJSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3440
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

CAAM accelerator only supports XTS-AES-128 and XTS-AES-256 since
it adheres strictly to the standard. All the other key lengths
are accepted and processed through a fallback as long as they pass
the xts_verify_key() checks.

Fixes: 226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a0b13bf6b528..f2f137f47972 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -19,6 +19,7 @@
 #include <linux/fsl/mc.h>
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 #define CAAM_CRA_PRIORITY	2000
@@ -1060,9 +1061,10 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(dev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
@@ -1475,7 +1477,9 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
+			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
 					      req->base.flags,
@@ -1518,7 +1522,9 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
+			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
 					      req->base.flags,
-- 
2.17.1

