Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2ECCC64E8A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8154D2075A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="TjaYhhab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbgKYVOf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 16:14:35 -0500
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:26503
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbgKYVOf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 16:14:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrqP1ETYXk66aHnZRjshwGUe/JPEPuATfoCV1cJN8kJM9O2XkAU1C9vpiMTbwYgTKBW4ZTEopoOuK9NubQ9UYImDfDwDW7JBALRiSVytRoM9upKszgDKgvj49rS7sez36fuU7R/VlKK6/ujIzvdAYaFyZJWLcIFgd0KonxVxT/LTFC1e94kJPSf0CGdOkOVdk75Il3bHh2UqtSCPrIgHv8aQezTVZpv5Ng1nyL+mKvPJ8HGwWjN4ogfgi05qGf7UxMi7KxDbaOnosGUBepeiHID9GrM1ucpiEDt1YQOSB3VVT3vjcUG22GJW+hoFBpKRrQ/ck2DcOBsKKf2b9rnyeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1eQ0LfSRlr+5IDc2dbiuY18ENgTzVzN+0XcO4TW+kY=;
 b=HHgeSL8heBiNfLfmobYpBTYDtBAZwptk1lWBz6N3IZ9w6dewUZ998BUJFy6AoFVdVY7WhOg1JwYQ7JX+YMrm/ldXJ5cpm7OaTVgry3x+mwtsNH0zt3+jLMU99ogEMVJbhVYltep1+/BmGuTFF2wNMulODjwhcL8Z/JATxtLNxVfcgdrA7C+ZffgUX9vJP/aQFKinoeWrZeWt176Xfr5Nqou38IrwT0WhbyUSoPnzgw2CJtvZ1Y+C4Qwmq8DkcogQvalUUmw5tGEEtt6Fu//fAF9wqsdmqdYxyNjlRJpUJCzdUo7D3ji0lzzIuncd81daBedo1BNUpsPueiF7/m3uMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1eQ0LfSRlr+5IDc2dbiuY18ENgTzVzN+0XcO4TW+kY=;
 b=TjaYhhab/oMpGSVQoU3NGRT2QshUdUfP+iBnSrInirgGe/DwItXFSSUBsY+I4zebF/+k4iCENgLq6yZQqs5wLBjillKk8OasYDb6IeP+a2TQ7X2hQa4oksbols9plphxVM1exSCJrGvrfIlTpBUe1YogeotLAjADSv6FACaE7kk=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB6941.eurprd04.prod.outlook.com
 (2603:10a6:803:12e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Wed, 25 Nov
 2020 21:14:30 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3589.025; Wed, 25 Nov 2020
 21:14:30 +0000
From:   "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [RFC PATCH 3/4] crypto: caam - avoid allocating memory at crypto request runtime for skcipher
Date:   Wed, 25 Nov 2020 23:13:10 +0200
Message-Id: <20201125211311.2179-4-iuliana.prodan@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::34) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Wed, 25 Nov 2020 21:14:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e0238c19-e1d7-4b73-7760-08d891871968
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6941DA4C4320083C7F1E3033CDFA0@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hm7hDVGkx5k34YswKl8thWdCTdsQLgrLcluKZuvMPaJBzifQHbZ4/e8QJyfQ/etPheY6Y1Eb6Jj/+II90Mou2vbRbVuGSHw+Pd8LUM2/1k5A9vjiSeYN6KhpCOpkOGox5OaV6t1txlj2DfwketRFlShsJfMyU2C3UghFGIPMpqO6HngfjQPYFqjaOkGBNLlbFN0xJJMauNFzlGPYkzsa7wDPJJM6KE39ZMUS0cBiMvRW2ndGRYnj2XvzK3FGsZqUIb3CDAkcA2ecRPsiJ0wI5qWHvOfFApiG90xf+NR40as80drwUkk6mATalUByj7V2QCy6oOMybNsSCQ8mxXYUHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(316002)(86362001)(5660300002)(66476007)(66556008)(186003)(52116002)(6512007)(66946007)(26005)(110136005)(54906003)(2906002)(8676002)(6486002)(16526019)(4326008)(83380400001)(8936002)(478600001)(1076003)(6506007)(956004)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?euSp0S87deslV5bulGaAj2QAi41nD946/flcvit4DccTcuS6r+bXQgK/3cMG?=
 =?us-ascii?Q?eolu/84KIBm2ykVa8xfr4iLM2AV6nF+PVJnKEPbsBy1xY/Rv2SjdzKayeuwd?=
 =?us-ascii?Q?wbbEVeX877aOxnywDn/Zmjr4CcsDkLqSIw4plJ+BmMzJECgW5FKoqvfpzXDG?=
 =?us-ascii?Q?nBtkAaxlD4Xdf+BA0pygV/plqHtyOOT+OomIwBUFd0PhSetBvhaRfqmgHQ5A?=
 =?us-ascii?Q?cz5k6zCArCMmIdEb4nIBgeK+RP5IHf+qfd08YDA2Sr/z5Zrpim5X+dsZdZb7?=
 =?us-ascii?Q?EhIzhplmIcF+hdNt64A7lxw0YmgPrRWr8EkTnrUBws9lwEmkT9cUhbGZ5HCU?=
 =?us-ascii?Q?JXK4oldOiOPCRERJYuLrB+EMO5ZwjC/eGQEu4B37c0+zQKYeWDv8ase/Ouoq?=
 =?us-ascii?Q?J5/pMWZyIuQu37Z23blyM5+ZHSQxk0WNNrRyI7mvJaMHmHPF9ddonmrm8pFK?=
 =?us-ascii?Q?3nCDA4sFTPp7fUNKsIYwWWqTiGRkki2suPo21KXjPn1KEZa+qZ4Q7yp0BEtD?=
 =?us-ascii?Q?1ib+V+DjdKWcIo/WG4dPD7X/EAOq/0RRguwDP1MT225fassqgCxxB/uEeThL?=
 =?us-ascii?Q?mxh6bg7W4YQPSM8DDmho/h+JwgU0s1EsNpTuWqF6F1ZSvc+m1Ka3QfFfW7r8?=
 =?us-ascii?Q?z7+GofaYsktvK3fQi04jZGMtK3wqOy8gQC+0ZJxUqx2utO7Bth456xNHVlP1?=
 =?us-ascii?Q?54lF8t/8NZzSgq61lJbqPREbonZD2y3owRcu0Qg0xdyzVoN1rQ76ldOVd+dF?=
 =?us-ascii?Q?Q6ZqU3JWf6PxY5Y4jIQxagpMRd6ZeW+1yE+q6kqUcDBhhjeVCnRE1Rcgo9kw?=
 =?us-ascii?Q?WdYhr/N4lTAW82BZopyawNHSgpK1dRa88NhzYMvue9Q/Cd/DkGIySPUsbqW8?=
 =?us-ascii?Q?kgpGIIN2fvTsLXdbUXifYH8T3KxH/6BgCWxOAoAIvBQEOtR+rlG+f+MMfD+V?=
 =?us-ascii?Q?160UkXMFobM3K13l1HW4T0LDXUW9nH4iygW1rbcfML0=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0238c19-e1d7-4b73-7760-08d891871968
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2020 21:14:30.7963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yUQc9/6BWLPZveBdaEUHA8NmBRVF2QncMyL98gOZvDzL9Z2rdmm9ipV7icXv1wazeaqTreJx6vNikG+ZCnq6eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

Remove CRYPTO_ALG_ALLOCATES_MEMORY flag and allocate the memory
needed by the driver, to fulfil a request, within the crypto
request object.
The extra size needed for base extended descriptor and hw
descriptor commands, link tables, IV is computed in frontend
driver (caamalg) initialization and saved in reqsize field
that indicates how much memory could be needed per request.

CRYPTO_ALG_ALLOCATES_MEMORY flag is limited only to
dm-crypt use-cases, which seems to be 4 entries maximum.
Therefore in reqsize we allocate memory for maximum 4 entries
for src and 1 for IV, and the same for dst, both aligned.
If the driver needs more than the 4 entries maximum, the memory
is dynamically allocated, at runtime.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 71 +++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 8697ae53b063..6ace8545faec 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -905,6 +905,7 @@ struct aead_edesc {
  * @iv_dma: dma address of iv for checking continuity and link table
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @bklog: stored to determine if the request needs backlog
+ * @free: stored to determine if skcipher_edesc needs to be freed
  * @sec4_sg_dma: bus physical mapped address of h/w link table
  * @sec4_sg: pointer to h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
@@ -918,6 +919,7 @@ struct skcipher_edesc {
 	dma_addr_t iv_dma;
 	int sec4_sg_bytes;
 	bool bklog;
+	bool free;
 	dma_addr_t sec4_sg_dma;
 	struct sec4_sg_entry *sec4_sg;
 	u32 hw_desc[];
@@ -1037,7 +1039,8 @@ static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -1604,7 +1607,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	dma_addr_t iv_dma = 0;
 	u8 *iv;
 	int ivsize = crypto_skcipher_ivsize(skcipher);
-	int dst_sg_idx, sec4_sg_ents, sec4_sg_bytes;
+	int dst_sg_idx, sec4_sg_ents, sec4_sg_bytes, edesc_size = 0;
 
 	src_nents = sg_nents_for_len(req->src, req->cryptlen);
 	if (unlikely(src_nents < 0)) {
@@ -1675,16 +1678,30 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 
 	sec4_sg_bytes = sec4_sg_ents * sizeof(struct sec4_sg_entry);
 
-	/*
-	 * allocate space for base edesc and hw desc commands, link tables, IV
-	 */
-	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes + ivsize,
-			GFP_DMA | flags);
-	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
-		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
-		return ERR_PTR(-ENOMEM);
+	 /* Check if there's enough space for edesc saved in req */
+	edesc_size = sizeof(*edesc) + desc_bytes + sec4_sg_bytes + ivsize;
+	if (edesc_size > (crypto_skcipher_reqsize(skcipher) -
+			  sizeof(struct caam_skcipher_req_ctx))) {
+		/*
+		 * allocate space for base edesc and hw desc commands,
+		 * link tables, IV
+		 */
+		edesc = kzalloc(edesc_size, GFP_DMA | flags);
+		if (!edesc) {
+			caam_unmap(jrdev, req->src, req->dst, src_nents,
+				   dst_nents, 0, 0, 0, 0);
+			return ERR_PTR(-ENOMEM);
+		}
+		edesc->free = true;
+	} else {
+		/*
+		 * get address for base edesc and hw desc commands,
+		 * link tables, IV
+		 */
+		edesc = (struct skcipher_edesc *)((u8 *)rctx +
+			sizeof(struct caam_skcipher_req_ctx));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
 	}
 
 	edesc->src_nents = src_nents;
@@ -1764,11 +1781,11 @@ static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)
 
 	if (ret != -EINPROGRESS) {
 		skcipher_unmap(ctx->jrdev, rctx->edesc, req);
-		kfree(rctx->edesc);
+		if (rctx->edesc->free)
+			kfree(rctx->edesc);
 	} else {
 		ret = 0;
 	}
-
 	return ret;
 }
 
@@ -3393,10 +3410,25 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 		container_of(alg, typeof(*caam_alg), skcipher);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
 	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
-	int ret = 0;
+	int ret = 0, extra_reqsize = 0;
 
 	ctx->enginectx.op.do_one_request = skcipher_do_one_req;
 
+	/*
+	 * Compute extra space needed for base edesc and
+	 * hw desc commands, link tables, IV
+	 */
+	extra_reqsize = sizeof(struct skcipher_edesc) +
+			DESC_JOB_IO_LEN * CAAM_CMD_SZ + /* hw desc commands */
+			/* link tables for src and dst:
+			 * 4 entries max + 1 for IV, aligned = 8
+			 */
+			(16 * sizeof(struct sec4_sg_entry)) +
+			AES_BLOCK_SIZE; /* ivsize */
+
+	/* Need GFP_DMA for extra request size */
+	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_DMA);
+
 	if (alg_aai == OP_ALG_AAI_XTS) {
 		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
 		struct crypto_skcipher *fallback;
@@ -3411,9 +3443,11 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 
 		ctx->fallback = fallback;
 		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx) +
-					    crypto_skcipher_reqsize(fallback));
+					    crypto_skcipher_reqsize(fallback) +
+					    extra_reqsize);
 	} else {
-		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx) +
+					    extra_reqsize);
 	}
 
 	ret = caam_init_common(ctx, &caam_alg->caam, false);
@@ -3486,8 +3520,7 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY);
+	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;
-- 
2.17.1

