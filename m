Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D9FC433E1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 661A220786
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:08:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ejZMFpcY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgHFRIX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbgHFRGb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 13:06:31 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0DCC0D941A;
        Thu,  6 Aug 2020 08:43:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ody5IIUsvP1JQjQT2v+5+Q9UVmzFMcRhe68HD5EucDSr8GrZKC7uAuGdGVcoBN/yug+1Y65xGx2iT9ETvn4bNKbr9khJOHFkYCwGzlLfV80WDGUyfOrbgJX0xRwjSR2GjXu8kgIJy341CXvTFtmJLhefeUuVem+N+kYusX5WplrbeN1xOTopCElccMuqMKw5XuDbcVK+7fr61pq+IvJAdJqp6yMzvNoMncVUF8pehbuFwbdqApI8uJsvXbFIljtSVWwzeCgOBSTgTjgqfYBXWn469bXp7CFXQPiMEm2OosRBn+hyXVkNsbJcbVbcs/WunHG2dQNKj/4dvaDrqyXY9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG2G62cTP09RqCfsYGO6Dz0qWH/f02540G3LYJKbnCY=;
 b=VRCr0OvXZPY9rBdTJTELbcEO7mQGAizQPxtnlO1QttN8lfp9OqVmbj5oJzpdiIAbG0uHG9qDsa7RI9Ecbf20kr0bkVyXIOjZlGub1IJQgP4T24Fgu+mB2jHx/kWKi/dEWGzHfQ7lUsiJnrBo1OVF+ZpQvGW7g2NgxKqMTI2Y2GJ1f/YthsN5Ia35kJIGcNU2vaDpM+JeMZs7m0o7l4kYuzEZuqscKdQMpf3aiPRW7tJauzutXuBQxoWRXhwbtSjc1HOhQStn/Pylv7XnqGz3M2x2NBRPg+Y6XS8+UdB7SPFJxVQE+P+WRgR4OB0Ob1tI3ybapnz4Ywc8xr9EuHjteg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG2G62cTP09RqCfsYGO6Dz0qWH/f02540G3LYJKbnCY=;
 b=ejZMFpcY3NYhd8A1PYvOsJ5HtwMfyfRk6aWHa7gNV8ufbENwnok1+7j2oZLZd0DlG2LQGvCDQAqpvOszWeCo4/OrMKWBGSVQ3np1eX7k1ywdXVk//okZnMe56SS9Kz7pn1WcwoeJr4W8jTi29eHWVFB4ZRn+GiCVQIHQN/aTJGo=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3440.eurprd04.prod.outlook.com (2603:10a6:803:6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 11:41:52 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:41:52 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] crypto: caam/qi2 - add fallback for XTS with more than 8B IV
Date:   Thu,  6 Aug 2020 14:41:21 +0300
Message-Id: <20200806114127.8650-4-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 11:41:51 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 85085e00-6cd1-4c0c-a0f9-08d839fdb670
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3440:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34404AC1E8E7A4EC60EB1D7AB4480@VI1PR0402MB3440.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S3yAXEsBQMDeo3TOPXrkmZuTPI528/THA+tnkZWxb0YBSoMFrmxOS83G+EUXyT7LK1RFBRBfCtPXRk2JG4rl0fr5ORtcbHO84LADcT7GWY/Jk4FiQalIeXJM0RgGxz0ZhB9ofX4nFJL8sh2ZdLWC75I+8Il4jxyIlbQsCh2NND0c2SyvsnXyb+pN/jkJBp4iUo/USijMexVeJjxaqy2KkoUufZMBMQvJl24WlH9UsehB8z46OVUNuGaQnwpjzgqa9TADcwTzLClchXRHMNwYKxX9R2PDd4yu9ebajhvxuERwxRTX/rq4wsK3C6wvsMWjztvuak+aAgzqWTpELQD49dS99vLXeX1Cbm/NyVzbC4koYJoAI8B0rqhJ7S1wfUWe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(110136005)(316002)(6666004)(6512007)(478600001)(956004)(2616005)(6486002)(4326008)(1076003)(44832011)(52116002)(6506007)(86362001)(186003)(26005)(16526019)(66556008)(66476007)(2906002)(66946007)(83380400001)(8676002)(5660300002)(8936002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2o5FALxxi50DcCReNdw1BcWFpRAm4zAE1H1LZgVUAQB3V98oUTp+Se47Vf7F4J/W6bJ1/9PcTiCAQDOeRWkOCbiybCNoNJ0PR8W3foGMo0bp1Y7HnX07yCM/bsCMhnM7e386c2szXZ7+FReGw1nMVQm3mYRD/5PnzX0xfXMnvZ4dZplisE2YZ4Oi+JBVpepDtQZGUE8A6I9m7na0lOKQy4CbMJuYqFB2tp0RHTG4+1C8C2+W5rQxMlLhq1dQBqJddOUx81XAQPXa+rPK0mBsfCX1n6dm+XCPBylQaII9Wt2OOPAEmGNKciTlndilRadwXjvbS0fPqLhJ1MVKemp/9BDA4xHt55YKmexhfK3+Bxde66x4iFQsWbDTnOPOF/0jzMVDQApLwysdoyiWmo3Ia1V6Ba5LVPf7nhoy3xGLV7437rlDbTK1UtOwNNBb+RZsw5oZ++zdW8w4jkRqOZj80e+I2nBS1cC7y/ovl3ARIUL04hfx+qzcMaXe0Og6wstXgLcFL2psC5B85N9FpRftFe/spNjDyvq4UHMxp7wVKUNrGMEW/sVpJ6p593YOQxleu4nmWjG0O4zpY6hYvjjmAYPra7CG5GsAItQUcfNQ48oN+Z4sDb9VsSuJNpeKB6JuLsPKzCLBVbTVd7t7cWnLow==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85085e00-6cd1-4c0c-a0f9-08d839fdb670
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 11:41:52.4578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGjIqgD9wnvL97MXPjOhHu58Q+/2Rpnk8OgniV8xZK+Bd3CqaaeSUdORpIbB/UvZ2rAAv8mpxzEVQsOT8IS5jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3440
Sender: linux-crypto-owner@vger.kernel.org
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
 drivers/crypto/caam/caamalg_qi2.c | 79 +++++++++++++++++++++++++++++--
 drivers/crypto/caam/caamalg_qi2.h |  2 +
 2 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 66ae1d581168..a0b13bf6b528 100644
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
@@ -1443,6 +1450,20 @@ static void skcipher_decrypt_done(void *cbk_ctx, u32 status)
 	skcipher_request_complete(req, ecode);
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
 static int skcipher_encrypt(struct skcipher_request *req)
 {
 	struct skcipher_edesc *edesc;
@@ -1454,6 +1475,18 @@ static int skcipher_encrypt(struct skcipher_request *req)
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
@@ -1484,6 +1517,19 @@ static int skcipher_decrypt(struct skcipher_request *req)
 
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
@@ -1537,9 +1583,29 @@ static int caam_cra_init_skcipher(struct crypto_skcipher *tfm)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct caam_skcipher_alg *caam_alg =
 		container_of(alg, typeof(*caam_alg), skcipher);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request));
-	return caam_cra_init(crypto_skcipher_ctx(tfm), &caam_alg->caam, false);
+
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
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request) +
+					    crypto_skcipher_reqsize(fallback));
+	}
+
+	return caam_cra_init(ctx, &caam_alg->caam, false);
 }
 
 static int caam_cra_init_aead(struct crypto_aead *tfm)
@@ -1562,7 +1628,11 @@ static void caam_exit_common(struct caam_ctx *ctx)
 
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
@@ -1665,6 +1735,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam-qi2",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -2912,8 +2983,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
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

