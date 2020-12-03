Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233E7C71155
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C509C221EB
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgLCBhC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 20:37:02 -0500
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:53706
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727066AbgLCBhC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 20:37:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V50xsz7U/Yhaizz7NYWpjIQRNZdGSLLnPZOwlRZip6bHI413aTpUB+nxqOnvNVXJ+/rE3jYbgGGF9DDffezVH3XIhc3UDT59OqBdCgi/GIT4db3k2JulcE/GX9fWa3yXEg4INS3Stj8N3kAmlyCegHgBUkiLKydZwLsGVZ74thiFFw7PgB8gpGtSakqH+g3DGI0HcRTe19hmkrtjbSO+BU/qes2MlML8NIAeDzrUIbyH9tuKOMHf2kGiEiqWElmrifVErcclTyyRqCp2yfOziMJE9HxZgH/9Ouzjzwdh2oSk/cb8oVWKAB8JZBP6G6aaBiQhgc0gMQ4Xw17S+GsIrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=No+GMcOBJ1I+rMOeGFp5xXR3Z4TYSAxzZ8RoHDhB45M=;
 b=loilI++TCIZFU8f5dUIUELA+BTcELtl5Mvs7P+jOkys+DMUKhF66G05QjmfScnIZ9tQVVs1m2nA8sh8sJ/KqvvKCOSb5i8Odysd/6Nwa2bm5wvuM6nS+lmp1dAn27vAg7zIMePvbWu4f9T3kj75Nc1uMNBH9OByMUPgvDjbVA3nLQ6Nnn/t2YdFfnuvJCJ4gUM3+3SVv58dxoA4n7XAx31PiNMfiLGuYq7mL4eLvE/2c90ullo4rqavJ5OieRhOfC3LX2iUondpW7+EfsDVVXE7lFj9cgxD9go45lq5MP2ytpHjempSam0bAHQBLvtp4XS+wO3DaLAEjHAVnkXKclw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=No+GMcOBJ1I+rMOeGFp5xXR3Z4TYSAxzZ8RoHDhB45M=;
 b=M+y00/RHUuoMAnUaKHxqVfn2kKYZh/iF6QNCpHfktYRnpky6ytn41Cpa+eZA2b3oaQ9arT3Iqc4UtPLPHMZtvAvr64O4b4xnTjQelLcSmfP1HIohJObu5mJPZ7RX3z10FvonCTIn2ZvmMBEf2Zf4SN5Dsr7JJsWzfDcdAaS3XI0=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB4430.eurprd04.prod.outlook.com
 (2603:10a6:803:65::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Thu, 3 Dec
 2020 01:36:17 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3632.018; Thu, 3 Dec 2020
 01:36:17 +0000
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
Subject: [PATCH 2/5] crypto: caam/jr - avoid allocating memory at crypto request runtime for aead
Date:   Thu,  3 Dec 2020 03:35:21 +0200
Message-Id: <20201203013524.30495-3-iuliana.prodan@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
References: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36)
 To VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Thu, 3 Dec 2020 01:36:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 442b1395-5bbd-4e13-4d41-08d8972bd42e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4430:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4430E43E3F3C9C39046897BFCDF20@VI1PR04MB4430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UEXbpzSoToiPCK/SBnng/XY3QjzBzKZq2fY2qoWldMofhUywf4IdwQAKXcl3iL8XEt8rFGpJwN8mIHUh5tmW2PbMrXuwK1RsAjQ7vhZ/362T7EEtAkAd3E2cIpJJkvFL0/VlAVzuidKM2UyjkSd/iIt75peY20yrcsBqfkbB9gzb9NTySRGV4KpZ3QOZlvFzkq/fRSVabhKCfGO+s7haPwFJgaIAMjiuYQRyi2PDMlg1spwcwZX4hhA+9RqvH5UkG58fKM0RjY7+G2XABGBjDT783D07hVLEj22qMF5pE2vao8xZl0TBNQgeMt4Rw5o+DSeP6raHyJEcMW4mYO8VXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(54906003)(1076003)(110136005)(2906002)(316002)(2616005)(83380400001)(8676002)(52116002)(6506007)(8936002)(5660300002)(66946007)(26005)(66476007)(956004)(16526019)(86362001)(186003)(6512007)(4326008)(478600001)(66556008)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KpR21cr1e4aAcEdFs0u9KoHCSVgQ0idy52kFeoQCxrUW2CMyAayMcQhdVyvh?=
 =?us-ascii?Q?YFqu3NkerPGlzy1FUMiO5PmkoviwhsMB2K3wy9Q8REcPpaUw/bynYReV+SHI?=
 =?us-ascii?Q?+Wp9tU6E3nd4mugp/O9EIubwNxLuo/iGMJ56D1hMmnJ36TYjlCaSOPUNZxeJ?=
 =?us-ascii?Q?x54miJQRWsslxjP+zNSGkqWjf6p07GJ9GLgPBsdy4V1oguGysQPjgh/0MhoY?=
 =?us-ascii?Q?eH1uupKyuc7SmYjQrCx49Su1nBfnzFDG9GZaY5YtlrVh8gWaTf5nxY8ZzWgC?=
 =?us-ascii?Q?1gJYJlAS/6kbj6fihXVEtwtQc9KqldUVTyNqqWGlrA3KfMQoWBfwRqf+Dbwg?=
 =?us-ascii?Q?W12qztL7VQ+czJit3/MepyOcdIYbRxDY8JhT8ulL6uSZZx9sD8z2WrGhLCKW?=
 =?us-ascii?Q?PAwDecuN9fQGCtaBGjyQqlQmis74wYJsDjG1Wol3DLHcvrtnqFk48Mn+QnyI?=
 =?us-ascii?Q?aZ+gDp8GQX4/NFj2gYAbJ0T4JN3wFatYtLhJuB0pwdD9fzB1RZpFq4MmBsrQ?=
 =?us-ascii?Q?VndGs8ZBtRGKy2jFQMzJCc+fRqmHYvhkZ8wdtlCPWej/Zhysbkmy4K+6UJn+?=
 =?us-ascii?Q?2/Y0kNOb611gSX/Kxbl7uqJM9g2yDk6b1+4Myf0hq7gJ1kPnwwoWYG1ko/Qe?=
 =?us-ascii?Q?QKLUv1IiqEPPNh1oHuTCrvM/BGov6HdCXY/ycDjbeJpi77fEq6GGLB72jvAI?=
 =?us-ascii?Q?bAI++yDIAaCWnKcj2m3jc5l9hO7B1anNg1+LcnQY72LjZAvbaV1r6cPLJvBW?=
 =?us-ascii?Q?BzPeCh3NghWQ0z1ZNo+Vl0TBbcMDymv5xZtTVYdGK7smnWtF414c+mMs6KOr?=
 =?us-ascii?Q?sO1Za26lkV2IUVF3Zi5l3MNRPvQqda4748cXQjRlpgFCFNRcg8Q2Pb4dKYnu?=
 =?us-ascii?Q?VC9KSltxUUt8Le7RxbfAuHwL5et28unApiqoTgifHI74G7p2p/VnPn0kWHat?=
 =?us-ascii?Q?zeUaG+630aMs4DkIvrUk2PpOqRlkKaxwE1xT+iF37nhknuxRoILab8zNSAoX?=
 =?us-ascii?Q?0HTD?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 442b1395-5bbd-4e13-4d41-08d8972bd42e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 01:36:17.3896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oEMIa93ja35wyg7uj3wLEynpFxbBjdBfT1jAY2r09DQIWQXziUgt1IZll40szmQsW7bAU0wY+cFPIoIP6x4jxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4430
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

Remove CRYPTO_ALG_ALLOCATES_MEMORY flag and allocate the memory
needed by the driver, to fulfil a request, within the crypto
request object.
The extra size needed for base extended descriptor, hw
descriptor commands and link tables is computed in frontend
driver (caamalg) initialization and saved in reqsize field
that indicates how much memory could be needed per request.

CRYPTO_ALG_ALLOCATES_MEMORY flag is limited only to
dm-crypt use-cases, which seems to be 4 entries maximum.
Therefore in reqsize we allocate memory for maximum 4 entries
for src and 4 for dst, aligned.
If the driver needs more than the 4 entries maximum, the memory
is dynamically allocated, at runtime.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 64 ++++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ef49781a2545..058c808dbae9 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -880,6 +880,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
  * @mapped_dst_nents: number of segments in output h/w link table
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @bklog: stored to determine if the request needs backlog
+ * @free: stored to determine if aead_edesc needs to be freed
  * @sec4_sg_dma: bus physical mapped address of h/w link table
  * @sec4_sg: pointer to h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
@@ -891,6 +892,7 @@ struct aead_edesc {
 	int mapped_dst_nents;
 	int sec4_sg_bytes;
 	bool bklog;
+	bool free;
 	dma_addr_t sec4_sg_dma;
 	struct sec4_sg_entry *sec4_sg;
 	u32 hw_desc[];
@@ -987,8 +989,8 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 		ecode = caam_jr_strstatus(jrdev, err);
 
 	aead_unmap(jrdev, edesc, req);
-
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -1301,7 +1303,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
 	int src_len, dst_len = 0;
 	struct aead_edesc *edesc;
-	int sec4_sg_index, sec4_sg_len, sec4_sg_bytes;
+	int sec4_sg_index, sec4_sg_len, sec4_sg_bytes, edesc_size = 0;
 	unsigned int authsize = ctx->authsize;
 
 	if (unlikely(req->dst != req->src)) {
@@ -1381,13 +1383,30 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
 
-	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
-			GFP_DMA | flags);
-	if (!edesc) {
-		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, 0, 0);
-		return ERR_PTR(-ENOMEM);
+	 /* Check if there's enough space for edesc saved in req */
+	edesc_size = sizeof(*edesc) + desc_bytes + sec4_sg_bytes;
+	if (edesc_size > (crypto_aead_reqsize(aead) -
+			  sizeof(struct caam_aead_req_ctx))) {
+		/*
+		 * allocate space for base edesc and
+		 * hw desc commands, link tables
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
+		 * get address for base edesc and
+		 * hw desc commands, link tables
+		 */
+		edesc = (struct aead_edesc *)((u8 *)rctx +
+			sizeof(struct caam_aead_req_ctx));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
 	}
 
 	edesc->src_nents = src_nents;
@@ -1420,7 +1439,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
 		aead_unmap(jrdev, edesc, req);
-		kfree(edesc);
+		if (edesc->free)
+			kfree(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1450,7 +1470,8 @@ static int aead_enqueue_req(struct device *jrdev, struct aead_request *req)
 
 	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
 		aead_unmap(jrdev, edesc, req);
-		kfree(rctx->edesc);
+		if (rctx->edesc->free)
+			kfree(rctx->edesc);
 	}
 
 	return ret;
@@ -1538,7 +1559,8 @@ static int aead_do_one_req(struct crypto_engine *engine, void *areq)
 
 	if (ret != -EINPROGRESS) {
 		aead_unmap(ctx->jrdev, rctx->edesc, req);
-		kfree(rctx->edesc);
+		if (rctx->edesc->free)
+			kfree(rctx->edesc);
 	} else {
 		ret = 0;
 	}
@@ -3463,8 +3485,19 @@ static int caam_aead_init(struct crypto_aead *tfm)
 	struct caam_aead_alg *caam_alg =
 		 container_of(alg, struct caam_aead_alg, aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(tfm);
+	int extra_reqsize = 0;
+
+	/*
+	 * Compute extra space needed for base edesc and
+	 * hw desc commands, link tables, IV
+	 */
+	extra_reqsize = sizeof(struct aead_edesc) +
+			 /* max size for hw desc commands */
+			(AEAD_DESC_JOB_IO_LEN + CAAM_CMD_SZ * 6) +
+			/* link tables for src and dst, 4 entries max, aligned */
+			(8 * sizeof(struct sec4_sg_entry));
 
-	crypto_aead_set_reqsize(tfm, sizeof(struct caam_aead_req_ctx));
+	crypto_aead_set_reqsize(tfm, sizeof(struct caam_aead_req_ctx) + extra_reqsize);
 
 	ctx->enginectx.op.do_one_request = aead_do_one_req;
 
@@ -3533,8 +3566,7 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_aead_init;
 	alg->exit = caam_aead_exit;
-- 
2.17.1

