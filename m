Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05236C43465
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D482085B
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="aCW8XUcK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgIUHce (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:32:34 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:47332
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726494AbgIUHcd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhKEpO9EKMQ+PfnioEmRv/C0scPHjMDJN56I6JfmBRK1BsmNdrQ1kYM9KuN6vryFoDP9jIN/w6vMbKUECKGXO6XxK7IKB/Gntv0L+9DaAG31OcQDxCDAFGpOsQK4cEtlyeDveMo/L7qZbOffrHERRik4sxnfL9q41YKeNK20faVUP+cKdX6mw0kj8j/NRt5VDUyUPjcLAEhnQzL4RKixRabFPsJAQQ1K/RHcybBgoI0dpgE16w52YgM1Du+NoTKuWnPWD0O1aNbcKEIOgU+7ylcXZhBcKHRpr7qULX2lm7EdQjyhK4SD0qBNQYZbM0MoNk1/G+2dpkcEt87K33E6Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xg58v4+wP3PLcvJ8/XF+CqOjuRC5AfA1/K8dmPFBTNk=;
 b=QI3YVMo0p3+Vad3D6i3FHrHQ/xYlfywN2pttU9wjqiBpVs9QVbF8kZB4lky1mIeCfYXwlCxNryp51ndqKHiP/0qxHjmq0tCAX3j7DT/HprypQOraSOBF22WRUFQtki9RAJWcQzHnhXIqc01GJjQ+l9W3j3/frNOgsTML+nm/JcyOoFxZj99q6KB8rnymM8GHi4QdwTFWnquOWJTKnUkfbzPwjV4l/Etz7Qb+YYAoqbaXwxzeohvdELPFBODmegxG6kwD7NOa+FAXveDrlPvV/AoQ6LFh+C6ArHIG9vnMGE8gdJyq2vjZM1D1wxChCDGj5s7hHzl8bBk/LiMGwO1q1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xg58v4+wP3PLcvJ8/XF+CqOjuRC5AfA1/K8dmPFBTNk=;
 b=aCW8XUcKmbIgQNjo3wCS+VzX/oJdWa+OiKUC0PP3rLSgW8gU7EpciGFyKSniw7D6R0u7s7fjZKYHtNeCc1Jxy9BMGGtGWBbRVpZR7bA0YWPJ0xHv/xkPvrEhBxeAOEGfC+FFba4t8q1+x5nN4hplZDoPRpNoN8oST7NOdlRp65A=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:24 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:24 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/12] crypto: caam/qi2 - add fallback for XTS with more than 8B IV
Date:   Mon, 21 Sep 2020 10:31:56 +0300
Message-Id: <20200921073205.24742-4-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:24 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 68356d17-1d13-4aeb-978f-08d85e007bf5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB390348A945E0FA677690F25EB43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nSpa+0Y2NpreLMYn9a1NvhbAIRtd9rus/Yi/wRVYvGqAZNWn02boNjXZ0SZHlkH93DoJl20/bOAXa8uqZZuEfei+SCqBepdcifnRZDlRil6Ifl48a6b5X+MkBJ+zhb5Ueq7YCThjVGqKpghnBPgVgzdtsVsifuPCWjR2x3ZN9dt1VR/X1XH46Vmvloqo7rz0iFOvCQbAevBGJkUTl0OxW07fUGP3+R5NmnlQ0xjeUpUjpNS0jKvSvTJ4NFWpwI7+/d8ueeavvEUo8MvfUtFFdg+NgNnUeZCXvbrdS1Gk3zBEqau8I+NzgO/gZZPlQnc78TBRhfr2AwVNN/2gkbh+R4x0b2ktSFya6Wcpkq51c4xpRehqrsZB/rPq2Kp8rRvSx3KNzdfdcRKrDxMQKGdgnj9AWk3s9t84zXTTJBHYvrc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fw1OYkczXw5F2AaqTcPTEYRaOCZCtpsLRRlTL6C8njOyLHuimwc2gFEYSx4VxAALCWZ3BfnTIKUiN955S9vAQcQec8npqN+pp3z1ubvXQzH9NWyVlLvYK9hrXPDaF2KTQgWWHJhSDEJ6XkU2Puxi2RBg9seJzEWR5Iv9zP+Te6inahxSYLIx5dtpsjLlNtKG/2NwwO14LMAZS1noQNFaek2pbZKrs4i437Fs4s5KDcXdy4n1USHilYVEemh7pKNnP+lT91IznZBdPf4NKKpaIKtzQU8b07rwmidHirar89+2ZlR7fzcOamOC57BSnTS0Y9YjgwvudDtC20srj5QWNPkHlbYNBt7AvCv268kMT5Xcq9iJdQyJgTNCN1cM3QqxGAHdT4uQL/qsV3AP+p8BYp0PH3Jfk6ZF8dXmGMvWhvOWrxS5T5srWC6uPo7Gy/9YOEzMYp9q7Pyelk6ku3hva3x7zaAgqhrakrIYDvTkoPcCo6QCpKaGfSvX0SfTs2Fa+GGnnW8c5m3CZoFk8u8scob2/t1M3t8diI0oa1vz6IRCwwg0os0xhjyPEcXkEA9ImSRqhag7qnSiwhr8W4RvgOogmpN9pvyXYcpSleErQ33UXOsREdpRHegfWDOlL79ElkNmBrIl4xxb5O/ZsQ3Osg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68356d17-1d13-4aeb-978f-08d85e007bf5
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:24.7637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gqwNJihkJ2xx5yc6Gb2VueZkWrBAB1Ke1C6/ApAndgumRdgBKWLffTYteSZC0WdSZ4baQZ/YxJEXQMdHJ41xLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
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
 drivers/crypto/caam/caamalg_qi2.c | 78 +++++++++++++++++++++++++++++--
 drivers/crypto/caam/caamalg_qi2.h |  2 +
 3 files changed, 76 insertions(+), 5 deletions(-)

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
index 66ae1d581168..2e37e6e63c8c 100644
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
@@ -1443,6 +1450,17 @@ static void skcipher_decrypt_done(void *cbk_ctx, u32 status)
 	skcipher_request_complete(req, ecode);
 }
 
+static bool xts_skcipher_ivsize(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+	u64 size = 0;
+
+	size = get_unaligned((u64 *)(req->iv + (ivsize / 2)));
+
+	return !!size;
+}
+
 static int skcipher_encrypt(struct skcipher_request *req)
 {
 	struct skcipher_edesc *edesc;
@@ -1454,6 +1472,18 @@ static int skcipher_encrypt(struct skcipher_request *req)
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
@@ -1484,6 +1514,19 @@ static int skcipher_decrypt(struct skcipher_request *req)
 
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
@@ -1537,9 +1580,29 @@ static int caam_cra_init_skcipher(struct crypto_skcipher *tfm)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct caam_skcipher_alg *caam_alg =
 		container_of(alg, typeof(*caam_alg), skcipher);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
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
 
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request));
-	return caam_cra_init(crypto_skcipher_ctx(tfm), &caam_alg->caam, false);
+		ctx->fallback = fallback;
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request) +
+					    crypto_skcipher_reqsize(fallback));
+	} else {
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request));
+	}
+
+	return caam_cra_init(ctx, &caam_alg->caam, false);
 }
 
 static int caam_cra_init_aead(struct crypto_aead *tfm)
@@ -1562,7 +1625,11 @@ static void caam_exit_common(struct caam_ctx *ctx)
 
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
@@ -1665,6 +1732,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam-qi2",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -2912,8 +2980,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
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

