Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA593C6369E
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D5120B80
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbgLCBgz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 20:36:55 -0500
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:52705
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727066AbgLCBgz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 20:36:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lENbWR+/wjstw5btBMUazvoUN6MY5ekduMS0BO5bhUuUoJZxOGNanflGlZz6Mf21mw/83f7V65kq30NNVaaznpbJqz/c+udLcEbuWORSXOaHhzGYEMukpzuKN029nmyQpDr39hy31wcbk6TfP9oDpymPX3/M95ayiVO+kbZSaCilGXK2SO+/c7SOolFHTCLtCaIUrhi/mjwv81VmaahmFQdgproSqHHML/q7aMRw9HufuexESDYTFPKnoxCEQUQhVjzhZV4aF9ZzjFjvoAOiW3XGbPe0V5ZFDo7uHgOiOv44+7AYHKm531IJVEY2Y7ByMkNvsw0CcTUTR+KcvDxAUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2pnXHHaYiNPxaXhj7kzUh4Xx93WVGMeJ4QpoKI0NMI=;
 b=JjhQdfVlA6urQQ2jN7neTSv3EvhwWq2vc+jduITzK7ZgPpCIqfc6o6oWNzRC/eXO2Murn6vaYSuc502a+l2RwmT+D0oi1hswyzygRHwbByRGVbrwus3jPmaJA+aJn9DknbbCABCP2PpyB8n9TsEfaniPOeuhFzPtt4bKyzECCNglzoH7cO0KeoywsGknDQeijCOwsI024Koa+GXlGs/xj/xHpA709obWa4uBbEd0fiNiBaVd3EJDgvq2/0mqwWw/DKqxx2TLzNQVW5nr5Fndvn3XUfJx7WzDB9VT5gChedOSj7AyKfJ/6ACiu/b3yw1XiI+kTlIUHlDfWJWXcibcdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2pnXHHaYiNPxaXhj7kzUh4Xx93WVGMeJ4QpoKI0NMI=;
 b=MoHXa2UpEnXjKjxec0qSN90PoC7R/K4wYkTjXmDxD9T/WSVA6Ul8vflag7ncIftHLROe1quyvqptu2VK8Nnhk8xUltXai/X/UVMo9Htgfyx0hzgJwcpkG2Fu2ewR7sy2frilYdjL0oMXijyEjD3Dh3l+54DoRx+6cEx2EvtgdQk=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB4687.eurprd04.prod.outlook.com
 (2603:10a6:803:72::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 3 Dec
 2020 01:36:04 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3632.018; Thu, 3 Dec 2020
 01:36:04 +0000
From:   "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 1/5] crypto: caam/jr - avoid allocating memory at crypto request runtime for skcipher
Date:   Thu,  3 Dec 2020 03:35:20 +0200
Message-Id: <20201203013524.30495-2-iuliana.prodan@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
References: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36)
 To VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Thu, 3 Dec 2020 01:36:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 151c87f0-930f-4d1b-ca54-08d8972bcc5d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4687:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB46871D0C9A7524622354CBE8CDF20@VI1PR04MB4687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9CBTubQm8dl6XmmCEFbXpgYBseobPTqfWtWAxRJ0JB/Qulb3Pq2dHroweqTrK6fXizS1oRnRj9R9aM7TcrFrzSQIxBJ76zOv+LQvr4Hi2K5sSToGxi9mlyY6f3eCDaSd06D6auFPC9WjhIxIA7DMiIaws98L8YC80VLXE1e0J4FZmlzB3RhJs+TfAET5Owi5ioiYl5IZpitFuf0dR3GvecXtq9mj7H5ZCQSs3UWDJyyi1RnW7GQ3ron7fNf7613RUVxypuusLN9m0oxnovNtB3Q+iTIjRWOLB6nJkyIK1+hamU18IW8fWpnbZCv5Vo6du1d4uZVVL1pct3TRzzdEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(8936002)(5660300002)(4326008)(66946007)(66556008)(66476007)(478600001)(52116002)(6486002)(54906003)(6506007)(316002)(2906002)(110136005)(26005)(1076003)(6666004)(6512007)(186003)(956004)(2616005)(16526019)(86362001)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mpkvaCAEFsn3YX5W1iReCEyKzcXytx3jIX8Q4xpmiZ8vQHJKDA5RzO8UGcIP?=
 =?us-ascii?Q?avYPyx/MqYPAWcjhxuB/0amkliSlB6MFiqn2FMGPE3pg9qHq1zaz7mpQWIQe?=
 =?us-ascii?Q?c4zfxlDSW4soUOlubAwXDRDJydFUPTziWYWPf9wxh/8LzmoBqPneQXl3ksbq?=
 =?us-ascii?Q?eYFJgxZdfyC6UdhMB04GW1KEl21pGV4AA43HIORC5GZ2W30g5wt8XYQEUKhk?=
 =?us-ascii?Q?BLL1dBk0oH+86mr9oRMCKwESFaGH1qJE8yP4V3vHQW5QHU7Hyyy9spdku7Vq?=
 =?us-ascii?Q?WRrYLcpPxF3COeGkEtEHBY6PA0VNeVblMtrvk2KeqFRyCdvnifiwxemBwXae?=
 =?us-ascii?Q?tfSZsroP2/8skbPrxLo4XpTbtiOlwV2gR8tdsYzSvC3LeFXGdieTIlJG21Ks?=
 =?us-ascii?Q?Ws3FMMnKL9nqFGYH7nGvBTVdjoL+65EE9ugbZLbGBHhHf4Ybcr59k5Zsa5Ld?=
 =?us-ascii?Q?pjQ9AZAZUWsknBPRtYKMzg/hvbPFGiGSkjS5ymKtFDjHNaNqW8qEcrMc9X03?=
 =?us-ascii?Q?dEYvSI6wrZSiZ0ZldObZDHs2GkzJd+rb3xJc7NpPZBSg2V1L5vCe8k21OYcX?=
 =?us-ascii?Q?4G07qBwBl7b2Gosh3Gh11DrDyTmR6axBjzRwc1cPnm6ENNehsbNC/lk8LRJl?=
 =?us-ascii?Q?3FettcMa5GjrhlOEGYvK5F2JPNFqlwSVj5c0QRdj/iigfKFMXno39HX7w8wc?=
 =?us-ascii?Q?+vxDxzXpKJLg2oVoh1QFGE+5fGwyavZFH5P2WWqUQGOP1gkfSIAY88D7ZMDb?=
 =?us-ascii?Q?j128UL2vvUs5s2FGXhXFae/Qq0JFdNlFXeiORe2KJpUMuTYiXyqm9rS9qD9I?=
 =?us-ascii?Q?TalrL2cqUbExXklbUGfQSvEb6C9Kk6VGEv/nFbtSmpA3vVT7sODfT1gPVd1X?=
 =?us-ascii?Q?DvIllEdZWmWqMcy4mlZaeWuwObA03PYhHf9H5yONlSUxpvybVEA+wHhDj41T?=
 =?us-ascii?Q?yzV9+dRcOuesGgW+fGq8HJ/r8BmZkV+zurww3J+ZDjkah/CDk7Hkk1JBXc5a?=
 =?us-ascii?Q?GLIp?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 151c87f0-930f-4d1b-ca54-08d8972bcc5d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 01:36:04.3820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bInxhPVWEcYyyL82IqDWqbrXe/vmdoirtRc5/+1YIRj8Vq/957C12ZboNeXy/pybPVXllJVZ16f2PHE0hnkU/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4687
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
 drivers/crypto/caam/caamalg.c | 77 +++++++++++++++++++++++++----------
 1 file changed, 55 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 8697ae53b063..ef49781a2545 100644
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
@@ -1706,7 +1723,8 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 			dev_err(jrdev, "unable to map IV\n");
 			caam_unmap(jrdev, req->src, req->dst, src_nents,
 				   dst_nents, 0, 0, 0, 0);
-			kfree(edesc);
+			if (edesc->free)
+				kfree(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
 
@@ -1736,7 +1754,8 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 			dev_err(jrdev, "unable to map S/G table\n");
 			caam_unmap(jrdev, req->src, req->dst, src_nents,
 				   dst_nents, iv_dma, ivsize, 0, 0);
-			kfree(edesc);
+			if (edesc->free)
+				kfree(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
 	}
@@ -1764,11 +1783,11 @@ static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)
 
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
 
@@ -1841,7 +1860,8 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 
 	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
 		skcipher_unmap(jrdev, edesc, req);
-		kfree(edesc);
+		if (edesc->free)
+			kfree(edesc);
 	}
 
 	return ret;
@@ -3393,10 +3413,22 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
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

