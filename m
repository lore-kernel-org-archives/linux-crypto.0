Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCDAC64E7C
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F09A120B80
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgLCBhw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 20:37:52 -0500
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:53706
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727064AbgLCBhv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 20:37:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ifl/AYkqpKfj5rw8Fp2nT+5nkdFXlaFJC6wuqrBYYYjdxU5+nyPLR9oYOnA3Swce+mjhy7bPDiagQ12/KLosGW+NvecXM7rpubHV63vmkDgVPxiAC908RQ+ibpHz4XHxDEOFmgF7RGVRLvQ0B9yz4KYca+BSu+S3w+8h9rSJQKiRH32g0EgQeHCiRzortRAvOTS4zyLPg5bR1bWklVBrT8ITZb8duY4ryiHog/hXVXzySVg3NFr3abnXx0+6Dq6J7cX7fsXg5I2681eRlp9AqL7pYgxUJpBh0j97KJk/N1YcQ05qJEXLZgu1ARqfN9QDnz76DLhVWfvpRLQgByCFxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBSuvDfvTLyJm7/On1f++2Qjz4IVm9jJgG3XAC/sSf4=;
 b=d4YZjLXkYjltWMZ+0U/K8YdplobP211x1tvOyG55mvCkJJS2TlWDGeaAiAjllklOXs1pSOzzviHmKFVvSSMkXzkWg35FLD9gRlo0YzbmOHz4o4vKHOlmAbIvEiFpNeDjkS/J1MlvA2PdWAvbmEjtZGOfV7JqLfoNG13WnzSLszkUokp3YldSixQ8qkmOQXoeNhi5LEKNqLFHVajIWKqLSLw6VGwCYkOrcAGCXYpxONplJTbYKabiy7CKjDR+IpuZsTlFCFnNl22i5lPRfWvKkuDtQgphdyG03eB1ZhWY+FcfVv8pkYsPujQ/PxbFTYwXXvh29RSyF+pw2nijtu05bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBSuvDfvTLyJm7/On1f++2Qjz4IVm9jJgG3XAC/sSf4=;
 b=hRu4b9MAQWBtXKWO7fhCAGV8RTk8QqFDyCNfTCE7Usr4KSIXo4rIqaY8q6yg0mzTCsO5caFortZlWgTT2PP7nGC9TavRU5khG+ezjSA0p3fYmqkYI9kbW8n3RYKI04w+d8pUCLkAv841FqRyIQn3Mf6kgFRnQd7EISqOVkv+UMU=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB4430.eurprd04.prod.outlook.com
 (2603:10a6:803:65::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Thu, 3 Dec
 2020 01:36:45 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3632.018; Thu, 3 Dec 2020
 01:36:45 +0000
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
Subject: [PATCH 4/5] crypto: caam/qi - avoid allocating memory at crypto request runtime
Date:   Thu,  3 Dec 2020 03:35:23 +0200
Message-Id: <20201203013524.30495-5-iuliana.prodan@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
References: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36)
 To VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Thu, 3 Dec 2020 01:36:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2c66ce61-ee24-42cf-9c8f-08d8972be50b
X-MS-TrafficTypeDiagnostic: VI1PR04MB4430:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4430DCF9924FAEAF5FADA327CDF20@VI1PR04MB4430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+KUz86nTQygGjK92E0YjtUHqUug2DgirCrzUR4HEvTiqwqphzv/Na56Cxx0/kZrkZxq5n/jfd6fq/5cHcRZgWx+PinNcFFRqfbebz+H+vExkHtt5MII/P3ey75moDP2U7sL8/hBAmzLTGjLX/SRrU/LDjrVg+i15mNiugfHHq/Y6ZOdCJzdKtXdcgwoeRlRCxeED1ms4m2n1i7nsvqdx3BLQ3blNq1BSDGp3+gZSWbX24ZEFhWwWr8GUmPeMYbJBJLNcDu6z943NrKmJbiJXjsHhjJphXUXEr1rWqBqvi2Grbn8u8DjQxX3cnjHSqbJVgtsXNr/D+G/nd3th+Cc0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(54906003)(1076003)(110136005)(2906002)(316002)(2616005)(83380400001)(8676002)(52116002)(30864003)(6506007)(8936002)(5660300002)(66946007)(26005)(66476007)(956004)(16526019)(86362001)(186003)(6512007)(4326008)(478600001)(66556008)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8ld+jwTFnl47Y1ZtaW66F/JwdUW0b3uWj5+vGFMj2a5+4GqeWCbb6In51oep?=
 =?us-ascii?Q?8yAlgTokjYkQpD8HSmZatAvfYWrxVfs9zXDOhqzfSiONr7Jmb/CWJssatOog?=
 =?us-ascii?Q?hlwaNxuUvi5fhmVEurjj6dytRNRn9tJPDUXLUoZ+bmTzjIjxQu7woGcHaCIj?=
 =?us-ascii?Q?zTAbZZYaSHIaX4n7gZGE/y2F6baB5VTpVvOs0c1mgbwYDV7JYh2ALZyk/a1q?=
 =?us-ascii?Q?FgLaYLQHu96OlWpAOs2jIctNlEtb+7gvUPJR6dykby8muKX+U3iJaE+okWgu?=
 =?us-ascii?Q?/yhiMpNypKHENfuL4J+eMwtuE3F5MFi2WUmyo27WLRbea1nQZdXXC1NDwWs1?=
 =?us-ascii?Q?j5rkyfvoQajYZEin+n3ZFlRKCBuHxrHElLKzrKjKXvAjVDf29fnff/eo5MUq?=
 =?us-ascii?Q?MVMVdPpyX6vXTwCrgQ2vEglJF0ey6KWirFGCQhVLy0J2+ON/qEtBEHrQ/C9j?=
 =?us-ascii?Q?nCVB4NkmtBw8IdJ3POcgHVH9aj0Zv8irEdxbFkhrcPJVqveDBDZLPV27f+/m?=
 =?us-ascii?Q?mwMRIzacV97i+jL/eEtZqgFJhm5+rz2AxgJ7tNzyKo/pOx7EguBwJ2uFoJ2v?=
 =?us-ascii?Q?30rVvUoQyEYrD8lspLNQ0BYsRF/K7v8zP0GgO7dzYg3bGKu4ODbzNhPTSbYW?=
 =?us-ascii?Q?FkjS2lOzLPgEW9fE17kl2xZcEfsKCYeGWutYKo8mzdWDyw15xYQrjhT5NFSP?=
 =?us-ascii?Q?tzmOjHxW24FaiRXojgRI1LNN+M//OBcQ5yM4hR1BeSr4AbPOg9WzAUeUWp03?=
 =?us-ascii?Q?TG6xI6co7aINuL/hsrJmgybAOC10moAutoY90Rv+IRi8j0arCeYGyNMDTaY0?=
 =?us-ascii?Q?2j+VRXNFyr8WL1vnwjhJyRjQWFfZrXwxPHi2V05auYzwITzDQ6AZnWsnkWto?=
 =?us-ascii?Q?kK2PdDCnRFb34ZmvxfXJqov8ywdsDYy8GTRqZR73BK8Lu0Y8Ob5T9jVaR2SU?=
 =?us-ascii?Q?bo4a3AteCRw1WdCDnFY4Ujbiy0UPfNsH9RpwL1BW+ouPmlGgkXcS2Up9EM7J?=
 =?us-ascii?Q?sU2F?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c66ce61-ee24-42cf-9c8f-08d8972be50b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 01:36:45.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q8uPkfNtFHyEAj7gsd2r7XpX0rb+KwvoJwQCD4XW23MVlP8Z52M2U2SBc/UV2oL9z3NVKITeO3G8X26N4zLKmg==
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
driver (caamalg_qi) initialization and saved in reqsize field
that indicates how much memory could be needed per request.

CRYPTO_ALG_ALLOCATES_MEMORY flag is limited only to
dm-crypt use-cases, which seems to be 4 entries maximum.
Therefore in reqsize we allocate memory for maximum 4 entries
for src and 4 for dst, aligned.
If the driver needs more than the 4 entries maximum, the memory
is dynamically allocated, at runtime.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 134 +++++++++++++++++++++----------
 1 file changed, 90 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index a24ae966df4a..ea49697e2579 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -788,6 +788,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
  * @dst_nents: number of segments in output scatterlist
  * @iv_dma: dma address of iv for checking continuity and link table
  * @qm_sg_bytes: length of dma mapped h/w link table
+ * @free: stored to determine if aead_edesc needs to be freed
  * @qm_sg_dma: bus physical mapped address of h/w link table
  * @assoclen: associated data length, in CAAM endianness
  * @assoclen_dma: bus physical mapped address of req->assoclen
@@ -799,6 +800,7 @@ struct aead_edesc {
 	int dst_nents;
 	dma_addr_t iv_dma;
 	int qm_sg_bytes;
+	bool free;
 	dma_addr_t qm_sg_dma;
 	unsigned int assoclen;
 	dma_addr_t assoclen_dma;
@@ -812,6 +814,7 @@ struct aead_edesc {
  * @dst_nents: number of segments in output scatterlist
  * @iv_dma: dma address of iv for checking continuity and link table
  * @qm_sg_bytes: length of dma mapped h/w link table
+ * @free: stored to determine if skcipher_edesc needs to be freed
  * @qm_sg_dma: bus physical mapped address of h/w link table
  * @drv_req: driver-specific request structure
  * @sgt: the h/w link table, followed by IV
@@ -821,6 +824,7 @@ struct skcipher_edesc {
 	int dst_nents;
 	dma_addr_t iv_dma;
 	int qm_sg_bytes;
+	bool free;
 	dma_addr_t qm_sg_dma;
 	struct caam_drv_req drv_req;
 	struct qm_sg_entry sgt[];
@@ -927,7 +931,8 @@ static void aead_done(struct caam_drv_req *drv_req, u32 status)
 	aead_unmap(qidev, edesc, aead_req);
 
 	aead_request_complete(aead_req, ecode);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 }
 
 /*
@@ -949,7 +954,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	dma_addr_t qm_sg_dma, iv_dma = 0;
 	int ivsize = 0;
 	unsigned int authsize = ctx->authsize;
-	int qm_sg_index = 0, qm_sg_ents = 0, qm_sg_bytes;
+	int qm_sg_index = 0, qm_sg_ents = 0, qm_sg_bytes, edesc_size = 0;
 	int in_len, out_len;
 	struct qm_sg_entry *sg_table, *fd_sgt;
 	struct caam_drv_ctx *drv_ctx;
@@ -958,13 +963,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	if (IS_ERR_OR_NULL(drv_ctx))
 		return (struct aead_edesc *)drv_ctx;
 
-	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = qi_cache_alloc(GFP_DMA | flags);
-	if (unlikely(!edesc)) {
-		dev_err(qidev, "could not allocate extended descriptor\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
 	if (likely(req->src == req->dst)) {
 		src_len = req->assoclen + req->cryptlen +
 			  (encrypt ? authsize : 0);
@@ -973,7 +971,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		if (unlikely(src_nents < 0)) {
 			dev_err(qidev, "Insufficient bytes (%d) in src S/G\n",
 				src_len);
-			qi_cache_free(edesc);
 			return ERR_PTR(src_nents);
 		}
 
@@ -981,7 +978,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 					      DMA_BIDIRECTIONAL);
 		if (unlikely(!mapped_src_nents)) {
 			dev_err(qidev, "unable to map source\n");
-			qi_cache_free(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
 	} else {
@@ -992,7 +988,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		if (unlikely(src_nents < 0)) {
 			dev_err(qidev, "Insufficient bytes (%d) in src S/G\n",
 				src_len);
-			qi_cache_free(edesc);
 			return ERR_PTR(src_nents);
 		}
 
@@ -1000,7 +995,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		if (unlikely(dst_nents < 0)) {
 			dev_err(qidev, "Insufficient bytes (%d) in dst S/G\n",
 				dst_len);
-			qi_cache_free(edesc);
 			return ERR_PTR(dst_nents);
 		}
 
@@ -1009,7 +1003,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 						      src_nents, DMA_TO_DEVICE);
 			if (unlikely(!mapped_src_nents)) {
 				dev_err(qidev, "unable to map source\n");
-				qi_cache_free(edesc);
 				return ERR_PTR(-ENOMEM);
 			}
 		} else {
@@ -1024,7 +1017,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 				dev_err(qidev, "unable to map destination\n");
 				dma_unmap_sg(qidev, req->src, src_nents,
 					     DMA_TO_DEVICE);
-				qi_cache_free(edesc);
 				return ERR_PTR(-ENOMEM);
 			}
 		} else {
@@ -1058,14 +1050,30 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	sg_table = &edesc->sgt[0];
 	qm_sg_bytes = qm_sg_ents * sizeof(*sg_table);
-	if (unlikely(offsetof(struct aead_edesc, sgt) + qm_sg_bytes + ivsize >
-		     CAAM_QI_MEMCACHE_SIZE)) {
+
+	 /* Check if there's enough space for edesc saved in req */
+	edesc_size = offsetof(struct aead_edesc, sgt) + qm_sg_bytes + ivsize;
+	if (unlikely(edesc_size > CAAM_QI_MEMCACHE_SIZE)) {
 		dev_err(qidev, "No space for %d S/G entries and/or %dB IV\n",
 			qm_sg_ents, ivsize);
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
 			   0, DMA_NONE, 0, 0);
-		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
+	} else if (edesc_size > crypto_aead_reqsize(aead)) {
+		/* allocate space for base edesc, link tables and IV */
+		edesc = qi_cache_alloc(GFP_DMA | flags);
+		if (unlikely(!edesc)) {
+			dev_err(qidev, "could not allocate extended descriptor\n");
+			caam_unmap(qidev, req->src, req->dst, src_nents,
+				   dst_nents, 0, 0, DMA_NONE, 0, 0);
+			return ERR_PTR(-ENOMEM);
+		}
+		edesc->free = true;
+	} else {
+		/* get address for base edesc, link tables and IV */
+		edesc = (struct aead_edesc *)((u8 *)aead_request_ctx(req));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
 	}
 
 	if (ivsize) {
@@ -1079,7 +1087,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			dev_err(qidev, "unable to map IV\n");
 			caam_unmap(qidev, req->src, req->dst, src_nents,
 				   dst_nents, 0, 0, DMA_NONE, 0, 0);
-			qi_cache_free(edesc);
+			if (edesc->free)
+				qi_cache_free(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
 	}
@@ -1098,7 +1107,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dev_err(qidev, "unable to map assoclen\n");
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, DMA_TO_DEVICE, 0, 0);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1120,7 +1130,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dma_unmap_single(qidev, edesc->assoclen_dma, 4, DMA_TO_DEVICE);
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, DMA_TO_DEVICE, 0, 0);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1174,7 +1185,8 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 		ret = -EINPROGRESS;
 	} else {
 		aead_unmap(ctx->qidev, edesc, req);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 	}
 
 	return ret;
@@ -1237,7 +1249,8 @@ static void skcipher_done(struct caam_drv_req *drv_req, u32 status)
 		memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes,
 		       ivsize);
 
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	skcipher_request_complete(req, ecode);
 }
 
@@ -1254,7 +1267,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	dma_addr_t iv_dma;
 	u8 *iv;
 	int ivsize = crypto_skcipher_ivsize(skcipher);
-	int dst_sg_idx, qm_sg_ents, qm_sg_bytes;
+	int dst_sg_idx, qm_sg_ents, qm_sg_bytes, edesc_size = 0;
 	struct qm_sg_entry *sg_table, *fd_sgt;
 	struct caam_drv_ctx *drv_ctx;
 
@@ -1317,22 +1330,30 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 		qm_sg_ents = 1 + pad_sg_nents(qm_sg_ents);
 
 	qm_sg_bytes = qm_sg_ents * sizeof(struct qm_sg_entry);
-	if (unlikely(offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes +
-		     ivsize > CAAM_QI_MEMCACHE_SIZE)) {
+
+	/* Check if there's enough space for edesc saved in req */
+	edesc_size = offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes + ivsize;
+	if (unlikely(edesc_size > CAAM_QI_MEMCACHE_SIZE)) {
 		dev_err(qidev, "No space for %d S/G entries and/or %dB IV\n",
 			qm_sg_ents, ivsize);
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
 			   0, DMA_NONE, 0, 0);
 		return ERR_PTR(-ENOMEM);
-	}
-
-	/* allocate space for base edesc, link tables and IV */
-	edesc = qi_cache_alloc(GFP_DMA | flags);
-	if (unlikely(!edesc)) {
-		dev_err(qidev, "could not allocate extended descriptor\n");
-		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, DMA_NONE, 0, 0);
-		return ERR_PTR(-ENOMEM);
+	} else if (edesc_size > crypto_skcipher_reqsize(skcipher)) {
+		/* allocate space for base edesc, link tables and IV */
+		edesc = qi_cache_alloc(GFP_DMA | flags);
+		if (unlikely(!edesc)) {
+			dev_err(qidev, "could not allocate extended descriptor\n");
+			caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
+				   0, DMA_NONE, 0, 0);
+			return ERR_PTR(-ENOMEM);
+		}
+		edesc->free = true;
+	} else {
+		/* get address for base edesc, link tables and IV */
+		edesc = (struct skcipher_edesc *)((u8 *)skcipher_request_ctx(req));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
 	}
 
 	/* Make sure IV is located in a DMAable area */
@@ -1345,7 +1366,8 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 		dev_err(qidev, "unable to map IV\n");
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
 			   0, DMA_NONE, 0, 0);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1372,7 +1394,8 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 		dev_err(qidev, "unable to map S/G table\n");
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, DMA_BIDIRECTIONAL, 0, 0);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1446,7 +1469,8 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 		ret = -EINPROGRESS;
 	} else {
 		skcipher_unmap(ctx->qidev, edesc, req);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 	}
 
 	return ret;
@@ -2493,7 +2517,15 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 		container_of(alg, typeof(*caam_alg), skcipher);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
 	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
-	int ret = 0;
+	int ret = 0, extra_reqsize = 0;
+
+	/* Compute extra space needed for base edesc, link tables and IV */
+	extra_reqsize = sizeof(struct skcipher_edesc) +
+			/* link tables for src and dst:
+			 * 4 entries max + 1 for IV, aligned = 8
+			 */
+			(16 * sizeof(struct qm_sg_entry)) +
+			AES_BLOCK_SIZE; /* ivsize */
 
 	if (alg_aai == OP_ALG_AAI_XTS) {
 		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
@@ -2509,7 +2541,10 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 
 		ctx->fallback = fallback;
 		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx) +
-					    crypto_skcipher_reqsize(fallback));
+					    crypto_skcipher_reqsize(fallback) +
+					    extra_reqsize);
+	} else {
+		crypto_skcipher_set_reqsize(tfm, extra_reqsize);
 	}
 
 	ret = caam_init_common(ctx, &caam_alg->caam, false);
@@ -2525,6 +2560,19 @@ static int caam_aead_init(struct crypto_aead *tfm)
 	struct caam_aead_alg *caam_alg = container_of(alg, typeof(*caam_alg),
 						      aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(tfm);
+	int extra_reqsize = 0;
+
+	/* Compute extra space needed for base edesc, link tables and IV */
+	extra_reqsize = sizeof(struct aead_edesc) +
+			/* link tables for src and dst:
+			 * 4 entries max + 1 for IV, aligned = 8
+			 */
+			(16 * sizeof(struct qm_sg_entry)) +
+			AES_BLOCK_SIZE; /* ivsize */
+	/*
+	 * Set the size for the space needed for base edesc, link tables, IV
+	 */
+	crypto_aead_set_reqsize(tfm, extra_reqsize);
 
 	return caam_init_common(ctx, &caam_alg->caam, !caam_alg->caam.nodkp);
 }
@@ -2580,8 +2628,7 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-				CRYPTO_ALG_KERN_DRIVER_ONLY);
+	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;
@@ -2594,8 +2641,7 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
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

