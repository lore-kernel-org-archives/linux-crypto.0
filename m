Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33638C43466
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE8DC2085B
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ZHnRPHyv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgIUHc2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:32:28 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:1967
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726494AbgIUHc1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDxlA3bGtyX20TZJHIMPEleg2+QX9yvTURnZzLNQ/7rV4knVpw3tWR4FaC6s6UQFDMC2wXZUVx1FHrPm2Pccu0GsLVUy6VoEmUv0KonzIYyEaJvY+ATgIeXGbIeBEF2sv1PaxpdXqyGbk3w8WnMO6k8+JjhLea7uW8JjNEvrn40Xz3/XxdMcUJbmEVFu1yJkTNiJMCY93Qu33XNJqLht/PixUGKRD1/1iQRx6qI2FFc0vqeDInLqq760HFN8oTdviKaELhd5v4v11cytPqYVL+SiVnsTDxHTZByEIg10tm/UHuEJ80X5RXxCt3sV72FeJ0KmkX4O+0T9WOGaYeh0pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LWoJjE7KR8se+lGH34LpXw5ZDyhB7zoKdBtz5Up8mo=;
 b=dUKaaJ+6VJwmFcF4QBhSLJNou+OO2uzWR+lsn/aQYeNgvSQdyOS4GRtOiRbz3XVyYWSYS/RmxpOwj39N8lBwY5HE2vLbJYz3eY3n9x6kk7lep3DLxrtEsDoP6KOqf8zct5FfX/E2kr5dfMuL7KB6cy1TH7nvtpzTLdIHa1OUHxX2q7sSYnzMd5n6HQf2A+g3acfK6h6KeuwS+DO7Ci5A2eXq4J8pDGL9xGNFXI4R7ujVdo12071KXeVzzxbgCodI5+Gkb2tp1jc59T6IAYv5HwW/gSvBWAPQCQr8Atin52hSgRGwUXtvzdNAK2vRLQ65XRllyuGukHVrkjqHoaZfLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LWoJjE7KR8se+lGH34LpXw5ZDyhB7zoKdBtz5Up8mo=;
 b=ZHnRPHyv0U0xfIyriIZIP7+ZueJe+vIg2wd2AKcxNIp7iohKUKdiVsaKgdHvw0TUv6t/3TZFJob4AkqaI7VmAFC/q5uuhK65l/2ktSRcbif9t+08VnKZNdcMajZcATYUnCNz5dZnrMdRa80bf3CweXwo3jq4dNMZtUGBlxxiG1I=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB5437.eurprd04.prod.outlook.com (2603:10a6:803:d8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.17; Mon, 21 Sep
 2020 07:32:23 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:23 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/12] crypto: caam/jr - add fallback for XTS with more than 8B IV
Date:   Mon, 21 Sep 2020 10:31:54 +0300
Message-Id: <20200921073205.24742-2-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:22 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 59d21a5c-dfe2-4872-e91a-08d85e007ad4
X-MS-TrafficTypeDiagnostic: VI1PR04MB5437:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5437BF52DB6FD1D173711D11B43A0@VI1PR04MB5437.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0k2WmIEV+d/xsAvxf6B8qAErhcLDvbtdyBRpKgq5WQN34g2/WKmvdo4qzn5lk+IHIGIv40eET8c4FKoCsIORgHiFdk1jN4GjkYdMsLEx/i3tFsE878X4WRnraDjqmDIPkzok5XRM3jTe1j0QydZU8QnA77gGjxjjNYQTlld5po6GrrhWstSrbhJq1fDyDZCnU2yIVcqTuVOp275wMwQxqVoWQ6UAOwo0xo2nU3qy1PVsWJSvyEc879EXXYkFt5U/2ZAPAwJyok5Ql21jbDxRcPuabj31KXZ1f34AOJXOq+0bJjbmxkdQ7rDv/QCmM1Ln65gcjEXU/Epbqm+WfyZCQttqM2XMRIzOmn9hAqu4XLTQGfXh0f/Y5HvZPl1jut/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(5660300002)(316002)(110136005)(52116002)(956004)(2616005)(8676002)(6486002)(478600001)(66476007)(66946007)(16526019)(4326008)(66556008)(2906002)(26005)(86362001)(186003)(6666004)(83380400001)(6512007)(8936002)(44832011)(1076003)(6506007)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oRt8hBHOg9eSNvS/OiCce1sgb4DXTOM1T5K4kZ3Z6heKMZl1uaB7LBl4Advo9jZBaL+e34cvK/Y0PTPv///CjtjTuNFzHicjIGeUxacvxJmd90Lf31G1X24XgYWpD+MzNd/cupcvbeYwTBPeuRFTpp+qU6xA0xexMi3/CN7v7IiQXFJfhf9DfBLP5ZiFIwa8V/WV+J85FNDhF+WerRePAsnEulNwh3pKo/rwB+OSzrjpOYStJvWQSzRjMuuZ2mrFUpUema45OTGOIIDl4CW1UC7M7JR2Kdk3AsU7aOHkwlg+dp/GWFRVsxuInTc7MfZcXQOKB5gMLKC83wgVF8f1ePwycC7UUKbcuD5h2Rh/ryuuoQ/u4Z4j6ISheBp82Kwd96HZSem84k37FdAYGuBWz1bgIJqEC9q5iPn51uVVMAYUXfQAw/AqhYZpGD3fNjiqwSSEuNlQ05QnVyxsq+GRzvgLrIhoZLzWyjE0x2Q/D906X6fSVM3tbkn5iMOe+k2b+6BCDQKI03fV5SASwEe9fKQmtfL8AbCa7IlTeNDhz3DDB0M1L8IBJ/i7pGM/HQ8fmbzifPge3A0VqlDNjPtnuCPzD2MtBNRdn5B6kSetJCgLvnWYPdgwIV1LczpvquIODckg3onI6Db1R2JdHCDcEA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d21a5c-dfe2-4872-e91a-08d85e007ad4
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:22.8818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Od7VzryUWzM/gxX9N5l2HrMKS+gI3qcP8d0P1hWs9ZdIA7gWOP5H189fRuo3E0yemG55s0ynpgtySmDuZDAZEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5437
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
 drivers/crypto/caam/Kconfig   |  1 +
 drivers/crypto/caam/caamalg.c | 70 +++++++++++++++++++++++++++++++----
 2 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index bc35aa0ec07a..dfeaad8dfe81 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -101,6 +101,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 	select CRYPTO_AUTHENC
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
+	select CRYPTO_XTS
 	help
 	  Selecting this will offload crypto for users of the
 	  scatterlist crypto API (such as the linux native IPSec
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 91feda5b63f6..e85e740a5fbc 100644
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
@@ -1755,6 +1763,17 @@ static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)
 	return ret;
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
 static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 {
 	struct skcipher_edesc *edesc;
@@ -1768,6 +1787,21 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
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
+				 crypto_skcipher_decrypt(&rctx->fallback_req);
+	}
+
 	/* allocate extended descriptor */
 	edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
@@ -1905,6 +1939,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -3344,13 +3379,30 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 	struct caam_skcipher_alg *caam_alg =
 		container_of(alg, typeof(*caam_alg), skcipher);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
+	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
 
 	ctx->enginectx.op.do_one_request = skcipher_do_one_req;
 
-	return caam_init_common(crypto_skcipher_ctx(tfm), &caam_alg->caam,
-				false);
+	if (alg_aai == OP_ALG_AAI_XTS) {
+		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
+		struct crypto_skcipher *fallback;
+
+		fallback = crypto_alloc_skcipher(tfm_name, 0,
+						 CRYPTO_ALG_NEED_FALLBACK);
+		if (IS_ERR(fallback)) {
+			dev_err(ctx->jrdev, "Failed to allocate %s fallback: %ld\n",
+				tfm_name, PTR_ERR(fallback));
+			return PTR_ERR(fallback);
+		}
+
+		ctx->fallback = fallback;
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx) +
+					    crypto_skcipher_reqsize(fallback));
+	} else {
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
+	}
+
+	return caam_init_common(ctx, &caam_alg->caam, false);
 }
 
 static int caam_aead_init(struct crypto_aead *tfm)
@@ -3378,7 +3430,11 @@ static void caam_exit_common(struct caam_ctx *ctx)
 
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
@@ -3412,8 +3468,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
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

