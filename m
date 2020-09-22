Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C243CC4363D
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5180C239D2
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="WhCuf2RM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgIVQES (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:04:18 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:27291
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbgIVQEN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:04:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ka9XYvmS1VMXqwj5HPdPWnj1aN28o6L3fDqw17TEvd97h4kZaCYJ3IUZvu/vW3LBZbAkhJnlOrIUKWCVfzllIYppnvpCzV/0rjG83iQ1t9tMWjcgmR8RKV5DK/0un6eahVYdOGsEQGDQ2oYA67x9qydu0oI+GA1/XDMaoCv51XrD+UEwglr9YqAm3MFC5JaFVTvFujlz9gX5+64bEEMjqwdAixeV/Jmnkh9otzW01zhr3PLfwmiYOJTYNnq78aGW0qQLgWF7x8qWkPmmpbqvs8GcirrVVWRoEQh5GTT71LDXwNYFGx2Q2fFZTIl/XOA7DZFWHXQh42BGO8SErTDUCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXK0bSpQqLoHFBHft+CgrvaAZ7h4F+Z/VY2JAP6l6fk=;
 b=g4jCaGJORgX88ArDdAwo+mfb/oY1YG7qUEA9kDuT+clXI7kY5YKud8b50JRSOBHlfZYja2rlrDQpMfQ1pY90t2Xx93hpVTcFLCmdEaXeRaNIBhRs/5uwZtyAr1GVBiJGJEnJJAFNnl9tVL4cQ1ChQkOt6m4CIYn4aN/pF0oSFrFbtEUnKoXmRFOdOtKOMHuw9g8gtLCHxOVInjBwXGsN5P9cJOMOjaYbr3ESlEgHgQ/C+WEFAtoKQEyAym84iAYU9ZAh1+fjA3Gu+FW6GiqLrlf7pyyO4PO47khR4zYelapqzX0paGJlGWMMGg9ktaTk/8pzdikxNwguqO1P4igcVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXK0bSpQqLoHFBHft+CgrvaAZ7h4F+Z/VY2JAP6l6fk=;
 b=WhCuf2RMi9Nm+GinvImNKSqmHV9Lud2A6Y/TiJd9JZeVeHy2+khwtlhOlA+0r0bkDhnPxafl2I3u4t650DyYsrH//C/AzRItMU85s/cw8YPNiptuE9gg9psssi6XHvFV0Du8qRCyPFvK4Vme8EIqJmSPqY9i/bfTKkjcmX6go0I=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 22 Sep
 2020 16:04:02 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 16:04:02 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/10] crypto: caam/qi2 - add fallback for XTS with more than 8B IV
Date:   Tue, 22 Sep 2020 19:03:21 +0300
Message-Id: <20200922160328.28926-4-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
References: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0022.eurprd03.prod.outlook.com
 (2603:10a6:205:2::35) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0302CA0022.eurprd03.prod.outlook.com (2603:10a6:205:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Tue, 22 Sep 2020 16:04:01 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b5ca993-aa4a-4966-02db-08d85f111f68
X-MS-TrafficTypeDiagnostic: VI1PR04MB7072:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB707201FC43BAE80D9F6792E7B43B0@VI1PR04MB7072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GsPLfOoIKUGHC6qf03NUzBQ3lHodq1HqF0agR3RxEyGIHh5L4kldAbP0i/1EuYq6CJmXGfP1OErrOhMY1OCoH74tl/Y8ZKFW9KIGSjB4JRlkXG6C9PworHkzyy4jf7rgtC4uSZf9zo45gqzm0tdV80qbhfV2/Bb4P0N2ZaU6+grrvfHcpwkAylRotEiDIK0NVS1dj6az/XTRWPkmGgTJKPRHQUzNOYhnHbLPur9kHtFVsU3s1/YDsQnU7NTDQ83cc4+nNaAPUtnKlakAtYzs0Ll3eBZcg/HwNAI37+YppKOO0u44R6SWA1VDshiYzaYLwubV51yvB2oV2IoPIDbUYf9bUUEk2/N4vw/+c50vRmj/PXK0XNxPmZdVEBG+f6ui
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(1076003)(4326008)(2616005)(6512007)(83380400001)(186003)(16526019)(2906002)(956004)(5660300002)(66556008)(66476007)(8936002)(316002)(6506007)(44832011)(66946007)(52116002)(6486002)(478600001)(110136005)(8676002)(26005)(86362001)(6666004)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: z/d8W+qk/05AtuPh5BM0n2a1FAJT2l1//vIlbz5w2EfJH+Gv+sMiWhPrpjftJp8s1mteUda224r6ZWI9e4Bouplrt3l206/DKVTyJUUf54aIOP4Gl8Uq6mB9/RKjTxiJZB0gJDWVbchmCD9Zc1r+3WeeG81r6pPXEVWgq4SXSwgCbSolNdqR1r30W/bawQAsvbjTqtwKMULEM5ytuSSUW0MRWWQYL+VNe1/VQ1jaWzyYz9cDKJcfXC3kuc17oV81+IX86WUnT3EwaKoWHV3dzLNXpyXkiK9pc0cDwBh4fEe0kzIMrgMIBCzNJS0tQIuJ5jE/dxx2dQ1noA5+xAywfExBxur96aCHXxKd2JaQocDRIj10juar8mtO1DLtexnsjdcVnekfY48BYr0iJsd1Se3gJT+4Wi9dkCS8qkecwC9MYkyz82IAdrXaIy/S3mT/tWp+0xUFdelhT5NQ0glM5gCfD/1RA22Hm5G1FkGlfu8te14I6t85DOGVWYkRygF0nnpLiukharpygVRYl0P238eSBKGJkXrXwOQS3l/T1b7a02xP8TI1o0ZvN90xem/LosGmU4oJU9rQP05VR2smYgzFQ7DZG27Obez49zkENqSrDIpYOJaIV5DZQ7/pzoWCsyWYaAsq/tW4CgQqk0KfFg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b5ca993-aa4a-4966-02db-08d85f111f68
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 16:04:02.0697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjzeLuWbw8H+UjOZfXUHYt3SWKgk0sIzATjceuhx+dvbrJqeDUOhcXE5cmgnpHcE74iHGsiGt7qVf0HK69Z6zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

A hardware limitation exists for CAAM until Era 9 which restricts
the accelerator to IVs with only 8 bytes. When CAAM has a lower era
a fallback is necessary to process 16 bytes IV.

Fixes: 226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/Kconfig       |  1 +
 drivers/crypto/caam/caamalg_qi2.c | 80 +++++++++++++++++++++++++++++--
 drivers/crypto/caam/caamalg_qi2.h |  2 +
 3 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 8169e6cd04e6..84ea7cba5ee5 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -167,6 +167,7 @@ config CRYPTO_DEV_FSL_DPAA2_CAAM
 	select CRYPTO_AEAD
 	select CRYPTO_HASH
 	select CRYPTO_DES
+	select CRYPTO_XTS
 	help
 	  CAAM driver for QorIQ Data Path Acceleration Architecture 2.
 	  It handles DPSECI DPAA2 objects that sit on the Management Complex
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 076c6b04bea9..c36d11820db3 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -19,6 +19,7 @@
 #include <linux/fsl/mc.h>
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
+#include <asm/unaligned.h>
 
 #define CAAM_CRA_PRIORITY	2000
 
@@ -80,6 +81,7 @@ struct caam_ctx {
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
+	struct crypto_skcipher *fallback;
 };
 
 static void *dpaa2_caam_iova_to_virt(struct dpaa2_caam_priv *priv,
@@ -1056,12 +1058,17 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	struct device *dev = ctx->dev;
 	struct caam_flc *flc;
 	u32 *desc;
+	int err;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
 		dev_dbg(dev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
+	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	if (err)
+		return err;
+
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
@@ -1443,6 +1450,14 @@ static void skcipher_decrypt_done(void *cbk_ctx, u32 status)
 	skcipher_request_complete(req, ecode);
 }
 
+static inline bool xts_skcipher_ivsize(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+
+	return !!get_unaligned((u64 *)(req->iv + (ivsize / 2)));
+}
+
 static int skcipher_encrypt(struct skcipher_request *req)
 {
 	struct skcipher_edesc *edesc;
@@ -1454,6 +1469,18 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
+	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
+		skcipher_request_set_callback(&caam_req->fallback_req,
+					      req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(&caam_req->fallback_req, req->src,
+					   req->dst, req->cryptlen, req->iv);
+
+		return crypto_skcipher_encrypt(&caam_req->fallback_req);
+	}
+
 	/* allocate extended descriptor */
 	edesc = skcipher_edesc_alloc(req);
 	if (IS_ERR(edesc))
@@ -1484,6 +1511,19 @@ static int skcipher_decrypt(struct skcipher_request *req)
 
 	if (!req->cryptlen)
 		return 0;
+
+	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
+		skcipher_request_set_callback(&caam_req->fallback_req,
+					      req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(&caam_req->fallback_req, req->src,
+					   req->dst, req->cryptlen, req->iv);
+
+		return crypto_skcipher_decrypt(&caam_req->fallback_req);
+	}
+
 	/* allocate extended descriptor */
 	edesc = skcipher_edesc_alloc(req);
 	if (IS_ERR(edesc))
@@ -1537,9 +1577,34 @@ static int caam_cra_init_skcipher(struct crypto_skcipher *tfm)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct caam_skcipher_alg *caam_alg =
 		container_of(alg, typeof(*caam_alg), skcipher);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
+	int ret = 0;
+
+	if (alg_aai == OP_ALG_AAI_XTS) {
+		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
+		struct crypto_skcipher *fallback;
+
+		fallback = crypto_alloc_skcipher(tfm_name, 0,
+						 CRYPTO_ALG_NEED_FALLBACK);
+		if (IS_ERR(fallback)) {
+			dev_err(ctx->dev, "Failed to allocate %s fallback: %ld\n",
+				tfm_name, PTR_ERR(fallback));
+			return PTR_ERR(fallback);
+		}
+
+		ctx->fallback = fallback;
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request) +
+					    crypto_skcipher_reqsize(fallback));
+	} else {
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request));
+	}
 
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request));
-	return caam_cra_init(crypto_skcipher_ctx(tfm), &caam_alg->caam, false);
+	ret = caam_cra_init(ctx, &caam_alg->caam, false);
+	if (ret && ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+
+	return ret;
 }
 
 static int caam_cra_init_aead(struct crypto_aead *tfm)
@@ -1562,7 +1627,11 @@ static void caam_exit_common(struct caam_ctx *ctx)
 
 static void caam_cra_exit(struct crypto_skcipher *tfm)
 {
-	caam_exit_common(crypto_skcipher_ctx(tfm));
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+	caam_exit_common(ctx);
 }
 
 static void caam_cra_exit_aead(struct crypto_aead *tfm)
@@ -1665,6 +1734,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam-qi2",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -2912,8 +2982,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init_skcipher;
 	alg->exit = caam_cra_exit;
diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamalg_qi2.h
index f29cb7bd7dd3..d35253407ade 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -13,6 +13,7 @@
 #include <linux/netdevice.h>
 #include "dpseci.h"
 #include "desc_constr.h"
+#include <crypto/skcipher.h>
 
 #define DPAA2_CAAM_STORE_SIZE	16
 /* NAPI weight *must* be a multiple of the store size. */
@@ -186,6 +187,7 @@ struct caam_request {
 	void (*cbk)(void *ctx, u32 err);
 	void *ctx;
 	void *edesc;
+	struct skcipher_request fallback_req;
 };
 
 /**
-- 
2.17.1

