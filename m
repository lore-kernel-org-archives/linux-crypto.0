Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EF6C4727D
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 824722399A
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="l7lUgBCw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgIVQEc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:04:32 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:40665
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726686AbgIVQEU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:04:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9LFYUhHzLHfS5RHimcYxbW9Fkt1UvC9R//H2944MMyP4lnbArIgx5gtnO0lEfDSNv3io84PoZ5uNP64kHRz+NywSY7gTxd6nEZle3f4oEzTCp9raec+CdTP/wGiDLmCvvmK62R6jZedwleHio8gFXZDPQDReCEfkPUSwOCEynQrsqm8L7WY+ehXAFVdVNpS0HgElHm6EpPcSGIIDvOugcW6ztmt7XHKYAmkkicgmHLImQCgeMExPK9MMi3rDmeRe/G7zmJfxQXHnwO0/WqCwv2kOEw4yH+7HuKi2+R/3k2zIRN09czLlhC7SUh5yjyGd5rky7UaIDHFQdwSWP7oWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laPo1FlHkzXyhfDF4v0FpI8og+Wt4VtXWIaKVkWosQY=;
 b=SW0pYgjeAy0ODc80KfqfKkLyjyIvHydRv58CXrEjZ14EboSvZ6rnz8pKrvPZu/5SlqG0euVAP4Nd9yM9HFC3Tw+QUUW42y4ZjQKbgPBahXKhy204aGYZnhYVKwS6DIIEaUx4Mje4ubQ1RAH8+Mh2MSRBs7d9On/m2bmJWdzAA1H9eZybFlVaNZ/1J+sg3FJHMEz9o003whdrmyPLGQrXl4UkkyjJ1S4br5Jq3ygipk6bEEjix5wnRun+U49HswDfK+eXB8g+bilduRNIA8zkTDQst2O3tFVn3R6OAuKrjmgAz+EYkBdJTIy6mv98WGGf0uzXMDz16MZ+lph+b3A5jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laPo1FlHkzXyhfDF4v0FpI8og+Wt4VtXWIaKVkWosQY=;
 b=l7lUgBCwCsVEHGjeUVOOHXjWzffTl/WzjxD7EVULfIRfraavEkndvEW1GOCGDehy+NGN/pq5nBGBqrIFmMcyyWUti1hVIe8CsbXXdHmpZl0+bOo2nAazRcT+CIry2B3S1QPXwD2nBsegqTvs16UP99LpBetFKG1n+KzXGud2PRQ=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 22 Sep
 2020 16:04:05 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 16:04:05 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/10] crypto: caam/qi2 - add support for more XTS key lengths
Date:   Tue, 22 Sep 2020 19:03:24 +0300
Message-Id: <20200922160328.28926-7-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
References: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0022.eurprd03.prod.outlook.com
 (2603:10a6:205:2::35) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0302CA0022.eurprd03.prod.outlook.com (2603:10a6:205:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Tue, 22 Sep 2020 16:04:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 18061e8d-16ba-47cf-25c9-08d85f11211c
X-MS-TrafficTypeDiagnostic: VI1PR04MB7072:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB70720C581C11A2376DFA675EB43B0@VI1PR04MB7072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IMpgX0wf0ZvZWV9gyK4jOjVFFhkVr+MFdYb95XcPn6qOz7vOF/JdZ94plve/NzCYOsrMgkMBQpGujkignzi0omnLXETVV+kwCUmPqQJtxhxU6Gm5QAfHpT8jOVGvzWdfvTVON/xHEuz3HsuswqVNFD9Snj9xQ7fv2tPNpF3e7kgUh6nrk0uBeOuNe3lBU3oR1H3OnXT08zSO7dgJn3ZnCb085jgk5U6t6o4Pu95V08fZGVgrPAEHUf3wdICUj5Z6TS4ju/8p8+C4hORUY6nMZU1atkCDz8fnrs6OyPVaO/a9wJZZZXJHrpNZf+S1zPPTL9b0PCy47hRKj7kuw1GhoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(1076003)(4326008)(2616005)(6512007)(83380400001)(186003)(16526019)(2906002)(956004)(5660300002)(66556008)(66476007)(8936002)(316002)(6506007)(44832011)(66946007)(52116002)(6486002)(478600001)(110136005)(8676002)(26005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 16aplXrL+yut3eDN9IyeTv6Az+DjIzoz1kM+I2ZN5ETrE+Y4xtqAbVElK/QT7+me+u1JmJP4M/fW8PNFGpxCzqFOm0ahfc2QUL52HJudyi725LYJArXw0N+3qUd1bRYKOzCO/tz9pTIPdmAFwhe5B73vbBw7zH952Hopec81y5sTg+3s6FP1IUSN2eGZdMT9fRDYkzpzfeU3/QVScPyccOcWaZZnPfVTydcqY0DdTydbTfJkOFPg8tC3uh+3d0uhWD1ZFAGd4INDwX3RkAK5Cl0N+V0FUf2Yd3v1QFRVu1sylTznJ5LNcNW57Nn6tfvcXWhqn5pdpwT9ScvIc0oNMv0+xe/GJEl0isyI2iiGacBWZvEFyM4L4jKHLxJHdjAgs2NhYQDStSLAaI/4/Hb+vmgTqHWcGPjQGAHAShV97Jc0iq7azNfmlgWCH1GxDzIlVt3Kc1vs8P0rl+vgZv/ptIE0/xLFkrfd5dFd6+MNzzi3duFf+akGyt0lGaXI9BmHeDAoy6mYf4IJGz9Z0Tgs2WGtUrhQVucokIQTewKn/1GlQfgPPdPw7glaQJhYpgnKlzOrkfGqs7emSk3RYAZ7e2fYlRhXfU8b5uaPA9JVAs7Sz0EG6plNZwS2UyV1RPXPdjlwY5YQcjSlEjKg1Nv31A==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18061e8d-16ba-47cf-25c9-08d85f11211c
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 16:04:04.9989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cK7HL8NDBpFiic1AQRHneVrih8HTtGmnNU4iIlGte6cxcUp94KgPpkbz8SPNqZSyaNRS+PJgbsoTSuy8oU5O5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
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
 drivers/crypto/caam/caamalg_qi2.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index c36d11820db3..255b818c82b2 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -19,6 +19,7 @@
 #include <linux/fsl/mc.h>
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 #define CAAM_CRA_PRIORITY	2000
@@ -81,6 +82,7 @@ struct caam_ctx {
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
+	bool xts_key_fallback;
 	struct crypto_skcipher *fallback;
 };
 
@@ -1060,11 +1062,15 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(dev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
+	if (keylen != 2 * AES_KEYSIZE_128 && keylen != 2 * AES_KEYSIZE_256)
+		ctx->xts_key_fallback = true;
+
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	if (err)
 		return err;
@@ -1469,7 +1475,8 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
 					      req->base.flags,
@@ -1512,7 +1519,8 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
 					      req->base.flags,
-- 
2.17.1

