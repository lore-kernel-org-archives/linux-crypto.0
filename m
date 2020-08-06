Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C19C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7FA023125
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="PEqDAAwr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgHFQif (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:38:35 -0400
Received: from mail-am6eur05on2053.outbound.protection.outlook.com ([40.107.22.53]:9601
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729036AbgHFQhB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:37:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8/obt20CWh5g1ecCxs/S69a/b50G0jwdGtmhkKE/pOjUdSzLnBEKTPsV6uGR+WjgkVaUJDTKUILXWbcNuPVqb5NRF62ez18NxdQ1TqofdZXAU50PJFc39YUJFwFc/5Rr89oMVQNmKQYMRO9WwfItTfc03GKxuhrdVb4j7qU1wJjGLRLsClsmlIxxH2Cu4dKzFr7eOU61CkwjnLK8rkWnMAcy8+Hd85mNt4M51ewkUSXBEXRLgxc0kwJJc6OgITW8OLPnIVopxCPxRTVssTVUvrIe/6dX/q7jkN7RcwHUi7qeaCEZLyYLK9ViDSDwA2jYPclFvSboeM1TSuyoxX2OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUOaFR+51/hMGHZ1OqrVUqDtVfGLQpzNtoWYvUv9n6w=;
 b=LpQzAtWQdO3zoAlFKRUA6kZzMeW3wZFKPXNKH1PB4kvIhcgMJ6OpmuMGDXccwfT5u84CWEm9Ct6xPD3mj4q66fP2LMJyJWK1lBoXgdlSXxUhNR1gVDsu3H0s8Qwfhd3KxpezV67nAlamIlcgs4qiFLm4N3fcQWl67y0AjBZFexN/xsvMPKBYAiVz2kQOBhXiaFWbV/HofitKqFOwK1g6AG6AQI1SO1VK0/+a8/bO5lOht0TbkC4Gs6/wbz5dfgm6SGaQUJJvTmKkSWoSn1j5aq7b/yDEP8W+jfaj7HzorIsrc8+A1UWtz1HvXS1gh3Li2yoU4XQD+MC0uoIxMt/GJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUOaFR+51/hMGHZ1OqrVUqDtVfGLQpzNtoWYvUv9n6w=;
 b=PEqDAAwr7b0HXuI47FTStIxNvFpRrnyvPUq1uVmx9ntF7O+HhHI8siCMTFCQSt2CTvCsj5DWzigF5R3eVBfSmpXypNn/qhj1eVO5a/3yskbELLGGu2C5IogBt/lmApijzEMI9BL68ls0r2JtJmh30NVw8rGR3YFCinleLksf+jw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB4992.eurprd04.prod.outlook.com (2603:10a6:803:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 6 Aug
 2020 16:36:10 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 16:36:10 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 1/9] crypto: caam/jr - add fallback for XTS with more than 8B IV
Date:   Thu,  6 Aug 2020 19:35:43 +0300
Message-Id: <20200806163551.14395-2-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Thu, 6 Aug 2020 16:36:09 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba56a126-2b9d-4643-c115-08d83a26d381
X-MS-TrafficTypeDiagnostic: VI1PR04MB4992:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4992AE95E6CED5A33C96FCCCB4480@VI1PR04MB4992.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEn9/B5WclBZ7EN8nhd5jhsq/lCLspOTEj7Jzo/Q/nDQbKN69P9y7JEG5U+Ov+2pYcb8DpmMlu2mbf/dOPzrVa2KUXxceZ2rIfYKECMdEW+WDPBD103NEqZtJNWms06IJi2n/8zFofCW9lpegSeGRX4PCrt8W2aZwHBbwtjP2SzpJ9Oq28bZIZZCuT2l9MuYGdIiG+FKA438BB1kBm2CaMCIfyZx7CZgKJwiaEU6wGfEfravA8Zx0jn0a6o/M3rRoBaoxPmobvLDFa8P96kzvnNYGYClwrRvDzg7q0Ri2CYMem+W+r4DJvYl979dZ5nWDvlYHhsNdo3kFRorxXSqJo23s8YfqdOkL1mtxtjqcNUowM/Dxu+JxaypCLw+73j9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(66476007)(86362001)(26005)(6512007)(16526019)(186003)(66556008)(66946007)(1076003)(110136005)(8936002)(316002)(8676002)(478600001)(2906002)(6506007)(4326008)(44832011)(2616005)(956004)(83380400001)(6486002)(6666004)(52116002)(5660300002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YKY3eCy5mEwT8lfHc+Cli9irCmYElX1TBmtUm95BWSjRd5AgyqFOFBWATmb/F0EObJCYpV+3FVRM/UlqpCYXfVYBksfVMltQjethe+DacbFPjvh7IgFCNFL3QS8qf7Qitbt+rScnKTJb46/vMSMCGnCV29r2bxx3D+/Q5IvGQcbzAs8Yug5/jEbVbyUT7ooEpmOfJU10rAJxwWvGSc94bnLKhJHDNJf8CKeMbhywZEG7PkPd1G26jWM2RXjtA4+6YjP9JKeL73A0z1/m+EQRX2ENAGpF4CVoYl1T+MK+WFwLzBDcepCTmWT2nn6VS+XPDZ2LcjrR2etRjdjkvrq0y7Q89Eqtof9YnrNUD5RNr+wolxu42DeBkYB6tudBQXsRmdff904Eu1j9d4biCW1c1MXMiM2IMxrW/WuFpviNdAmXGEXPFkzGHfxBvGS3DWXIs4L38XpZdQ9gvXgLnKNrOUjIh81o/tjSSzqS4lUkZTtwu6DwS1vXIzwgvbHq2QUMyfZ8CEEc6DN3drpZEDbFFrUl3e6j3MxE7wXxPzotUaqTymBH9iExntLVn73dkDzqCS64NSn9i7pQB+Dvlv77lZ6Wv68HDpBHHFsxsZzVWNHrnSPD1SCOneTX0zTj+J7/Q26i+G/eI67rpAiPvS9HBg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba56a126-2b9d-4643-c115-08d83a26d381
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 16:36:10.5898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkRbcUCloYrCLw5VuU85iIxYGdOXViBt601MH/RoDI3ri1RKdFqNXVTO+52NDvyfBXMn9URZc/1sSJdrtiBkLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4992
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

