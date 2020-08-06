Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BFEC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B18B020786
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="gjrdsm2Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbgHFRIW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729610AbgHFRGe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 13:06:34 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42B0C0D941B;
        Thu,  6 Aug 2020 08:43:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COqCVjVaLaRxygQQU0cl/j85ZcQiT/+O4amCXDk+nUc90yIUCBMVu7kZ7yTLSNYxjVB9dw4aOwvWGUtZniAbEeIFKwcGGlDWOouDvOrIRgPd2TL5oakF5dUued2Gx0ZQlIvZDz3rSphu3kojbWW2/ngpjIb+GMj0GsmGUq7BdpnnKCA4AFfZPDc6ZgojTbNN18BFdtKEN7D1ABFSyCgqWzZBfRRwWPxktN8jx42+/R7IdtrXsTTvM04YUB7NZjfv2FG7fe1sYxIMhpvT6UozHfj2nKhqricjrPCQVnrTeAusJRn+eZQ4P7kXaMdMzNWp50++cxOlNyPVoO+1v+xzNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUOaFR+51/hMGHZ1OqrVUqDtVfGLQpzNtoWYvUv9n6w=;
 b=G00rQj5SdKLJQENNUgM3uSMoUsQRGyZ052+BXq9lDeefFYea0WHoRMCk+PML9TtneW/GxlSsAoD6/KoQg9/Na7ca3ZEIGcA03XZl1GcCbfv+mnlb8Zdphkom/FN/XqrlmPT1dc5Pm6FiYSiBEjqWSTkWviiwuo0h2ZQKpOZFt/0zfxliusUeb0WFDUpcw7oRB1yVVDoG5fmGwqxTpQJxW7R0jJSymwAI7b8JrrNb1m1Hh7cigqmg5UYuIfwRibLBurQWhSYFmGdaguckCYn2gFKPaj9nqjKknEcn4UFcHIyJ2ILHVfuFl0HUKFydApKK1bj5O3r/gO027NAfc38Eqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUOaFR+51/hMGHZ1OqrVUqDtVfGLQpzNtoWYvUv9n6w=;
 b=gjrdsm2ZPet2qX0EIqPzUH69K5ptFCyIfmBg+tZ+BSmw+vg7l4DIHuYgZpIxooaU913C6FG5Hajoe7/DKroGlVFu19PtSVk1r5QOLZvLIExlc3EfahOArHNmDUc/QSbB5FC6sR393xIk/tiLLEK91zzKv81XgoRoR0YeWU72wh0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3440.eurprd04.prod.outlook.com (2603:10a6:803:6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 11:41:50 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:41:50 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] crypto: caam/jr - add fallback for XTS with more than 8B IV
Date:   Thu,  6 Aug 2020 14:41:19 +0300
Message-Id: <20200806114127.8650-2-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 11:41:50 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a3c44d73-21cc-46d2-98a5-08d839fdb577
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3440:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3440C3FF6215828AF7FBAB89B4480@VI1PR0402MB3440.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5XQG7rfJNRK7SuLZjcrbro65L8hm+qoxQd7KicAEuJMWILnA13DbjNpiVijKu1ae+1ElxEAhwcA5eAwmCuMkQe/oJo6e5KUssQVtz7tFdFgnBLf7KWCRRQnJMNGLD4DTQlGgP0e8CeIbT4KnHZkA/5Qdz5nVvsOSi1b35GV1kVyoEjD2vdyzH5N+9eRqh6DpNkH7LKjIKGjTkyUOORENTgABc1nskRvSZCkKGiZN8prkWghAwCVHKBzC+JpWUmrT9p+UNSZUbNmvLIWH7H7+6iQaDRb0bHS8e7IA3O1F4P1Dks90t2i39NITCP0K6RtXvO1I5vUJI9XhVq8Hib/grCop4PEP1YpbEA1ycemdK24rSlHVapahEmjJKPGScyBI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(110136005)(316002)(6666004)(6512007)(478600001)(956004)(2616005)(6486002)(4326008)(1076003)(44832011)(52116002)(6506007)(86362001)(186003)(26005)(16526019)(66556008)(66476007)(2906002)(66946007)(83380400001)(8676002)(5660300002)(8936002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: inWQFGIeqPitX9KqITvYXTU4MTuVmC58FqJER65MT4HWdLbqA6Lk0/PqwyqaillBNvZlGymC+hH+QINJWJiOOCJ+V7ezexczbDgDiSdMCXAVEZW7xNpQSU8YvUnY16KZNPumw+ayU61U4fzkDEc3sZtwj/oG/7uEiaSUJx+ZJ3OoOQ/2lRsisrL+OPuIBBjY+W3T3xLkv8+OGgmFeUGbm1jGzBkt0QVuETKBSyALOPT5ZshYiMWMQMExgnl/ivl2ggFFvim9rRfCSviLPLowzSZ/I3H/Dq1Miu74/S5VDoSMGZTMPp7GhZjwYkrighdOiwwwXeDxv72zDF1cIEXMtuQ5Frhr/w9Yex7UDzi9nVvOJDzqf2fwrbx2S262VzOnnQBEeOEd/H65NVa7oUx3eGWaUyMjQtLoT9AOjLvsdFI+l7dG8YK0HrB4hpSj8CaiIQQwgIUy8YAdiMpfc2UZRldFmB23XqoNuZy69Ba+XFLYPTg90XVU05p3L13k474/TWQtZKhRKKGFxoZFzsjsdeSn0qu27IhJJ02D3i+w1wNpsuQw8pAUzRNzaNVe0B9GfNtScCviV0ZQhnCgKsEUZjVbfJRj6bkDF3Q4UAheH8o8eKOQLgytoYtxIKYcT5Y81G6AKw1ryX3zWwR/vu+sBA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c44d73-21cc-46d2-98a5-08d839fdb577
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 11:41:50.8387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OpZfIWz2+Wv4YdflcRdO5itm1IF5wG0lRcyN7cJC1O2ivTJOLt+L71RXyGbSceXUm2IvyrXafpbaFTaF2GzgxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3440
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

A hardware limitation exists for CAAM until Era 9 which restricts
the accelerator to IVs with only 8 bytes. When CAAM has a lower era
a fallback is necessary to process 16 bytes IV.

Fixes: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 68 ++++++++++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 91feda5b63f6..ebf4dc87ca2e 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -57,6 +57,7 @@
 #include "key_gen.h"
 #include "caamalg_desc.h"
 #include <crypto/engine.h>
+#include <asm/unaligned.h>
 
 /*
  * crypto alg
@@ -114,10 +115,12 @@ struct caam_ctx {
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
+	struct crypto_skcipher *fallback;
 };
 
 struct caam_skcipher_req_ctx {
 	struct skcipher_edesc *edesc;
+	struct skcipher_request fallback_req;
 };
 
 struct caam_aead_req_ctx {
@@ -830,12 +833,17 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	u32 *desc;
+	int err;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
 		dev_dbg(jrdev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
+	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	if (err)
+		return err;
+
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
@@ -1755,6 +1763,20 @@ static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)
 	return ret;
 }
 
+static bool xts_skcipher_ivsize(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+	u64 size = 0;
+
+	if (IS_ALIGNED((unsigned long)req->iv, __alignof__(u64)))
+		size = *(u64 *)(req->iv + (ivsize / 2));
+	else
+		size = get_unaligned((u64 *)(req->iv + (ivsize / 2)));
+
+	return !!size;
+}
+
 static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 {
 	struct skcipher_edesc *edesc;
@@ -1768,6 +1790,21 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
+	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
+
+		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
+		skcipher_request_set_callback(&rctx->fallback_req,
+					      req->base.flags,
+					      req->base.complete,
+					      req->base.data);
+		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
+					   req->dst, req->cryptlen, req->iv);
+
+		return encrypt ? crypto_skcipher_encrypt(&rctx->fallback_req) :
+				  crypto_skcipher_decrypt(&rctx->fallback_req);
+	}
+
 	/* allocate extended descriptor */
 	edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
@@ -1905,6 +1942,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -3344,12 +3382,30 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 	struct caam_skcipher_alg *caam_alg =
 		container_of(alg, typeof(*caam_alg), skcipher);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
 
 	ctx->enginectx.op.do_one_request = skcipher_do_one_req;
 
-	return caam_init_common(crypto_skcipher_ctx(tfm), &caam_alg->caam,
+	if (alg_aai == OP_ALG_AAI_XTS) {
+		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
+		struct crypto_skcipher *fallback;
+
+		fallback = crypto_alloc_skcipher(tfm_name, 0,
+						 CRYPTO_ALG_NEED_FALLBACK);
+		if (IS_ERR(fallback)) {
+			pr_err("Failed to allocate %s fallback: %ld\n",
+			       tfm_name, PTR_ERR(fallback));
+			return PTR_ERR(fallback);
+		}
+
+		ctx->fallback = fallback;
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx) +
+					    crypto_skcipher_reqsize(fallback));
+	}
+
+	return caam_init_common(ctx, &caam_alg->caam,
 				false);
 }
 
@@ -3378,7 +3434,11 @@ static void caam_exit_common(struct caam_ctx *ctx)
 
 static void caam_cra_exit(struct crypto_skcipher *tfm)
 {
-	caam_exit_common(crypto_skcipher_ctx(tfm));
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+	caam_exit_common(ctx);
 }
 
 static void caam_aead_exit(struct crypto_aead *tfm)
@@ -3412,8 +3472,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;
-- 
2.17.1

