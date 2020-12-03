Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF46C64E8A
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62204221EB
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgLCBh6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 20:37:58 -0500
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:28405
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729428AbgLCBh6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 20:37:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6ONQv8/Vo05TS/KjMsHAe+Wq4MRQijAxm2LvSOzYS4ghYUZMWGwYOESZ0+uFkWMapHijQSBxd2y0uPMq7Nfbmt9wm8I3k8hOlnvvqc48XOcFZApbyYh3BwmCsWIY5kjwTFrQhv+J64koMpsRjipdc8dd2wTSy7BM2/E0wMs21DWwEqDp0Mgb633sON/+95uG73lKqiSF3uGqfd/BlWhZ3d9bXZKmZYd55ymhigatPblx90ayuaSvn26RPWncOhA2wdzSsmO3ZwsGNl5p3tqHcYbf7t6c/ovVqSgFJYNPx16bMjtVZaB83QNz0hHZLd/UN1qTMyD7Hw4Yqd1/7U4Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCmdyOtMke2Gb58MdPCYf/SHTSbMjxxLkJNtBXBslQ8=;
 b=moEY9MPG0Zn4ZqqPZS5vkZen2IgaUGouFpUjA8rtSeGEwt388xhf5UfYELfbiDdu1MnhGbSQb6jviUniAzC8DxOjudUk2uyBphf+cI3bUWWIC78OJE92leWJGWtlmeS6IfLZmEpcNm4CL2z7/p1RH2gSypNdL6fHzMlDD3efPZxRU1TEpxZ0diSlvq3KZMXDHoFJ6KxLWIRTP7wgA2PYWB5mPUQFT1BDZvxEw+2LgZum1s7BfPQn85cwglRkf1bQVrxu5OwkKWDx3dc0QC5FlL1vPG33nF+XqoL3K3zC5DfscqQkfsO1HWPmKWybLmeWLelSM1Qq3aK1chSNltr5RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCmdyOtMke2Gb58MdPCYf/SHTSbMjxxLkJNtBXBslQ8=;
 b=RXsZHjWOjZQO66U1qdZL7DawO1FOFAd8tFrI0Rx2RiGhCgKm4pkiowyGWCzlk1oYa/ukHRzRU4uJrZtXL6gK0/fM/fs6sStJJpjTxhfwc4cX8qke2/SIZWSAjtvLG9XoVNM4Zn9PbtUqv24aOiRbMqVLH50Db+KaMlYtVSxa3Mg=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB4687.eurprd04.prod.outlook.com
 (2603:10a6:803:72::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 3 Dec
 2020 01:37:04 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3632.018; Thu, 3 Dec 2020
 01:37:04 +0000
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
Subject: [PATCH 5/5] crypto: caam/qi2 - avoid allocating memory at crypto request runtime
Date:   Thu,  3 Dec 2020 03:35:24 +0200
Message-Id: <20201203013524.30495-6-iuliana.prodan@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
References: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36)
 To VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Thu, 3 Dec 2020 01:37:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5172171-360b-4348-4da7-08d8972befe1
X-MS-TrafficTypeDiagnostic: VI1PR04MB4687:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB46875BD1C9CBFA20B1332F53CDF20@VI1PR04MB4687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /p0KfKxA3+CCHe9KBhSdp1UVXE0ewtGW2OiT4GgSHtoYhmJVw2VcPZMoYHhcP8t0mPtaDfKgpzIY4lrv07ZAcmR7v7fTe4nWUo1QcUVdaSDF0EDMejPvZFaFVPLTLFQwNz9jQAvsDuhreo3idx426QTSoVQmeBl7e5pqJ8pwc2ai5m1dUuiiLXbOjaXK6EQfzPhiV1jDA9qDLm8gVi/UxbMqZENeuOGuaTy1UXyiMVAe5EEPMjkob1swImo8hgvuyE5zlNsysP6f4+ByR07iLdTopcr8WE82kcYeautDOkWnZm6M8ylnrEswrLKVuqKbEy5moVXWzsPa6+qmVJrBxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(8936002)(5660300002)(4326008)(66946007)(30864003)(66556008)(66476007)(478600001)(52116002)(6486002)(54906003)(6506007)(316002)(2906002)(110136005)(26005)(1076003)(6666004)(6512007)(186003)(956004)(2616005)(16526019)(86362001)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h+EMUteOS9eNPY3q/YwvFQavJJ/cqzC44Rdb0QVfUsov4KyGEcsdSALfh5rE?=
 =?us-ascii?Q?O9VPdMs89AoTeC0wI85iga+E5FNERtKihSx/9MgBqZnRoit8M6hpm72ezP1E?=
 =?us-ascii?Q?BFsrj8fBHMocQlrJPwCDR0S3QIWDzkyZgNJR+4FmDG197pl9WhgQu7LFNLaF?=
 =?us-ascii?Q?LtTjkUSAT1Zt/X2HA2aLxzpFnS1zk2552JpkOM8rNJZkKh8ywcLu+xG3vbS3?=
 =?us-ascii?Q?IgGUcDqxqjfpyhVcSloldMRUMHCSOUpy3ApyyrEQpVI9NfXG1WOEqOtXbxcV?=
 =?us-ascii?Q?Kbcyt6qsqFflDqtb3eZx83yfXv97Nds0x1vJcfuz1FJXA2UB9c4i7aEVRzkR?=
 =?us-ascii?Q?pOiaAuaU4AjUdHUQJG91TCVnL3/qE1Ebig2IJw1bOXiEH2tSwT5h7dhcdUyL?=
 =?us-ascii?Q?9r5lvMltO2ypo5fKa5ulKOQ3PuEUeeeb/NfbcX7sZN+RsEmHnjb0us4qXRZW?=
 =?us-ascii?Q?AVMeIrToySww9DEHELSq4Eji9pCCDITdK1nmq2EWlIzz5JL3Ljp6Uj+a5Hif?=
 =?us-ascii?Q?WGPbTSvapFe/crWdZLZ557k6rzFMG0KfiodfA94eBYboKbqUxpz1F3QigmwU?=
 =?us-ascii?Q?MxTLRkmAnEx85RWaGRltuM90xI628lTrkc5ox+l77vTeBPxr2pn6QXqKAq5L?=
 =?us-ascii?Q?pyW/SobGKKW2/sXaN1UVjqrXlTCtMsv0yZvLlx61VAl6WP2DByrYcnFCK7y9?=
 =?us-ascii?Q?aDT+zckCJnnhGw9hbG081XIL/VRqR0TYNutG9KSOydIb09NwUHTdg7GAqHUQ?=
 =?us-ascii?Q?O1cqFqd70+/NcAU0V1i5JcwEkwPJJYZL6pdmMM+aKi/E1aIpsECh8/5hjNyI?=
 =?us-ascii?Q?nUYkpLQYfuiuWrDzE3gdvGaRZChPeOctlWspYffdOn35Ps9GZxKm1dd1oblM?=
 =?us-ascii?Q?rvas0HdfIIV2L5tUNk+sNym2KIWlqdU7lgW16inDsBIO8WW3xUTehtOX7puA?=
 =?us-ascii?Q?fpJqBMsuiGKUZU5ECDpncc8YL/95pFCnAPeAG1zgmtxUdh6/MOPLM78SHFe9?=
 =?us-ascii?Q?kMKg?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5172171-360b-4348-4da7-08d8972befe1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 01:37:04.0111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZLJnE15c/mRqj9Jd/qpZF6lsMgReaN0tX53j8xN7ION/o4TjAItg5wV3w0hI8+anxY++bUdZGsynOD7CsEBtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4687
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

Remove CRYPTO_ALG_ALLOCATES_MEMORY flag and allocate the memory
needed by the driver, to fulfil a request, within the crypto
request object.
The extra size needed for base extended descriptor, hw
descriptor commands and link tables is computed in frontend
driver (caamalg_qi2) initialization and saved in reqsize field
that indicates how much memory could be needed per request.

CRYPTO_ALG_ALLOCATES_MEMORY flag is limited only to
dm-crypt use-cases, which seems to be 4 entries maximum.
Therefore in reqsize we allocate memory for maximum 4 entries
for src and 4 for dst, aligned.
If the driver needs more than the 4 entries maximum, the memory
is dynamically allocated, at runtime.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 415 ++++++++++++++++++++----------
 drivers/crypto/caam/caamalg_qi2.h |   6 +
 2 files changed, 288 insertions(+), 133 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a780e627838a..88bbed7dc65b 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -362,17 +362,10 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	dma_addr_t qm_sg_dma, iv_dma = 0;
 	int ivsize = 0;
 	unsigned int authsize = ctx->authsize;
-	int qm_sg_index = 0, qm_sg_nents = 0, qm_sg_bytes;
+	int qm_sg_index = 0, qm_sg_nents = 0, qm_sg_bytes, edesc_size = 0;
 	int in_len, out_len;
 	struct dpaa2_sg_entry *sg_table;
 
-	/* allocate space for base edesc, link tables and IV */
-	edesc = qi_cache_zalloc(GFP_DMA | flags);
-	if (unlikely(!edesc)) {
-		dev_err(dev, "could not allocate extended descriptor\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
 	if (unlikely(req->dst != req->src)) {
 		src_len = req->assoclen + req->cryptlen;
 		dst_len = src_len + (encrypt ? authsize : (-authsize));
@@ -381,7 +374,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		if (unlikely(src_nents < 0)) {
 			dev_err(dev, "Insufficient bytes (%d) in src S/G\n",
 				src_len);
-			qi_cache_free(edesc);
 			return ERR_PTR(src_nents);
 		}
 
@@ -389,7 +381,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		if (unlikely(dst_nents < 0)) {
 			dev_err(dev, "Insufficient bytes (%d) in dst S/G\n",
 				dst_len);
-			qi_cache_free(edesc);
 			return ERR_PTR(dst_nents);
 		}
 
@@ -398,7 +389,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 						      DMA_TO_DEVICE);
 			if (unlikely(!mapped_src_nents)) {
 				dev_err(dev, "unable to map source\n");
-				qi_cache_free(edesc);
 				return ERR_PTR(-ENOMEM);
 			}
 		} else {
@@ -412,7 +402,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 				dev_err(dev, "unable to map destination\n");
 				dma_unmap_sg(dev, req->src, src_nents,
 					     DMA_TO_DEVICE);
-				qi_cache_free(edesc);
 				return ERR_PTR(-ENOMEM);
 			}
 		} else {
@@ -426,7 +415,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		if (unlikely(src_nents < 0)) {
 			dev_err(dev, "Insufficient bytes (%d) in src S/G\n",
 				src_len);
-			qi_cache_free(edesc);
 			return ERR_PTR(src_nents);
 		}
 
@@ -434,7 +422,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 					      DMA_BIDIRECTIONAL);
 		if (unlikely(!mapped_src_nents)) {
 			dev_err(dev, "unable to map source\n");
-			qi_cache_free(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
 	}
@@ -466,14 +453,30 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	sg_table = &edesc->sgt[0];
 	qm_sg_bytes = qm_sg_nents * sizeof(*sg_table);
-	if (unlikely(offsetof(struct aead_edesc, sgt) + qm_sg_bytes + ivsize >
-		     CAAM_QI_MEMCACHE_SIZE)) {
+
+	 /* Check if there's enough space for edesc saved in req */
+	edesc_size = offsetof(struct aead_edesc, sgt) + qm_sg_bytes + ivsize;
+	if (unlikely(edesc_size > CAAM_QI_MEMCACHE_SIZE)) {
 		dev_err(dev, "No space for %d S/G entries and/or %dB IV\n",
 			qm_sg_nents, ivsize);
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents, 0,
 			   0, DMA_NONE, 0, 0);
-		qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
+	} else if (edesc_size > (crypto_aead_reqsize(aead) -
+				 sizeof(struct caam_request))) {
+		/* allocate space for base edesc, link tables and IV */
+		edesc = qi_cache_zalloc(GFP_DMA | flags);
+		if (unlikely(!edesc)) {
+			dev_err(dev, "could not allocate extended descriptor\n");
+			return ERR_PTR(-ENOMEM);
+		}
+		edesc->free = true;
+	} else {
+		/* get address for base edesc, link tables and IV */
+		edesc = (struct aead_edesc *)((u8 *)req_ctx +
+			 sizeof(struct caam_request));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
 	}
 
 	if (ivsize) {
@@ -487,7 +490,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			dev_err(dev, "unable to map IV\n");
 			caam_unmap(dev, req->src, req->dst, src_nents,
 				   dst_nents, 0, 0, DMA_NONE, 0, 0);
-			qi_cache_free(edesc);
+			if (edesc->free)
+				qi_cache_free(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
 	}
@@ -511,7 +515,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dev_err(dev, "unable to map assoclen\n");
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, DMA_TO_DEVICE, 0, 0);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -533,7 +538,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dma_unmap_single(dev, edesc->assoclen_dma, 4, DMA_TO_DEVICE);
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, DMA_TO_DEVICE, 0, 0);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1118,7 +1124,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 	dma_addr_t iv_dma;
 	u8 *iv;
 	int ivsize = crypto_skcipher_ivsize(skcipher);
-	int dst_sg_idx, qm_sg_ents, qm_sg_bytes;
+	int dst_sg_idx, qm_sg_ents, qm_sg_bytes, edesc_size = 0;
 	struct dpaa2_sg_entry *sg_table;
 
 	src_nents = sg_nents_for_len(req->src, req->cryptlen);
@@ -1176,22 +1182,32 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 		qm_sg_ents = 1 + pad_sg_nents(qm_sg_ents);
 
 	qm_sg_bytes = qm_sg_ents * sizeof(struct dpaa2_sg_entry);
-	if (unlikely(offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes +
-		     ivsize > CAAM_QI_MEMCACHE_SIZE)) {
+
+	/* Check if there's enough space for edesc saved in req */
+	edesc_size = offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes + ivsize;
+	if (unlikely(edesc_size > CAAM_QI_MEMCACHE_SIZE)) {
 		dev_err(dev, "No space for %d S/G entries and/or %dB IV\n",
 			qm_sg_ents, ivsize);
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents, 0,
 			   0, DMA_NONE, 0, 0);
 		return ERR_PTR(-ENOMEM);
-	}
-
-	/* allocate space for base edesc, link tables and IV */
-	edesc = qi_cache_zalloc(GFP_DMA | flags);
-	if (unlikely(!edesc)) {
-		dev_err(dev, "could not allocate extended descriptor\n");
-		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents, 0,
-			   0, DMA_NONE, 0, 0);
-		return ERR_PTR(-ENOMEM);
+	} else if (edesc_size > (crypto_skcipher_reqsize(skcipher) -
+				 sizeof(struct caam_request))) {
+		/* allocate space for base edesc, link tables and IV */
+		edesc = qi_cache_zalloc(GFP_DMA | flags);
+		if (unlikely(!edesc)) {
+			dev_err(dev, "could not allocate extended descriptor\n");
+			caam_unmap(dev, req->src, req->dst, src_nents,
+				   dst_nents, 0, 0, DMA_NONE, 0, 0);
+			return ERR_PTR(-ENOMEM);
+		}
+		edesc->free = true;
+	} else {
+		/* get address for base edesc, link tables and IV */
+		edesc = (struct skcipher_edesc *)((u8 *)req_ctx +
+			 sizeof(struct caam_request));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
 	}
 
 	/* Make sure IV is located in a DMAable area */
@@ -1204,7 +1220,8 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 		dev_err(dev, "unable to map IV\n");
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents, 0,
 			   0, DMA_NONE, 0, 0);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1228,7 +1245,8 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 		dev_err(dev, "unable to map S/G table\n");
 		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, DMA_BIDIRECTIONAL, 0, 0);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1292,7 +1310,8 @@ static void aead_encrypt_done(void *cbk_ctx, u32 status)
 		ecode = caam_qi2_strstatus(ctx->dev, status);
 
 	aead_unmap(ctx->dev, edesc, req);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	aead_request_complete(req, ecode);
 }
 
@@ -1313,7 +1332,8 @@ static void aead_decrypt_done(void *cbk_ctx, u32 status)
 		ecode = caam_qi2_strstatus(ctx->dev, status);
 
 	aead_unmap(ctx->dev, edesc, req);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	aead_request_complete(req, ecode);
 }
 
@@ -1339,7 +1359,8 @@ static int aead_encrypt(struct aead_request *req)
 	if (ret != -EINPROGRESS &&
 	    !(ret == -EBUSY && req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 		aead_unmap(ctx->dev, edesc, req);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 	}
 
 	return ret;
@@ -1367,7 +1388,8 @@ static int aead_decrypt(struct aead_request *req)
 	if (ret != -EINPROGRESS &&
 	    !(ret == -EBUSY && req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 		aead_unmap(ctx->dev, edesc, req);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 	}
 
 	return ret;
@@ -1417,7 +1439,8 @@ static void skcipher_encrypt_done(void *cbk_ctx, u32 status)
 		memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes,
 		       ivsize);
 
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	skcipher_request_complete(req, ecode);
 }
 
@@ -1455,7 +1478,8 @@ static void skcipher_decrypt_done(void *cbk_ctx, u32 status)
 		memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes,
 		       ivsize);
 
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	skcipher_request_complete(req, ecode);
 }
 
@@ -1511,7 +1535,8 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	if (ret != -EINPROGRESS &&
 	    !(ret == -EBUSY && req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 		skcipher_unmap(ctx->dev, edesc, req);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 	}
 
 	return ret;
@@ -1561,7 +1586,8 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (ret != -EINPROGRESS &&
 	    !(ret == -EBUSY && req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 		skcipher_unmap(ctx->dev, edesc, req);
-		qi_cache_free(edesc);
+		if (edesc->free)
+			qi_cache_free(edesc);
 	}
 
 	return ret;
@@ -1602,7 +1628,15 @@ static int caam_cra_init_skcipher(struct crypto_skcipher *tfm)
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
+			(16 * sizeof(struct dpaa2_sg_entry)) +
+			AES_BLOCK_SIZE; /* ivsize */
 
 	if (alg_aai == OP_ALG_AAI_XTS) {
 		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
@@ -1619,9 +1653,11 @@ static int caam_cra_init_skcipher(struct crypto_skcipher *tfm)
 
 		ctx->fallback = fallback;
 		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request) +
-					    crypto_skcipher_reqsize(fallback));
+					    crypto_skcipher_reqsize(fallback) +
+					    extra_reqsize);
 	} else {
-		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request));
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_request) +
+					    extra_reqsize);
 	}
 
 	ret = caam_cra_init(ctx, &caam_alg->caam, false);
@@ -1636,8 +1672,17 @@ static int caam_cra_init_aead(struct crypto_aead *tfm)
 	struct aead_alg *alg = crypto_aead_alg(tfm);
 	struct caam_aead_alg *caam_alg = container_of(alg, typeof(*caam_alg),
 						      aead);
+	int extra_reqsize = 0;
+
+	/* Compute extra space needed for base edesc, link tables and IV */
+	extra_reqsize = sizeof(struct aead_edesc) +
+			/* link tables for src and dst:
+			 * 4 entries max + 1 for IV, aligned = 8
+			 */
+			(16 * sizeof(struct dpaa2_sg_entry)) +
+			AES_BLOCK_SIZE; /* ivsize */
 
-	crypto_aead_set_reqsize(tfm, sizeof(struct caam_request));
+	crypto_aead_set_reqsize(tfm, sizeof(struct caam_request) + extra_reqsize);
 	return caam_cra_init(crypto_aead_ctx(tfm), &caam_alg->caam,
 			     !caam_alg->caam.nodkp);
 }
@@ -3006,8 +3051,7 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY);
+	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init_skcipher;
 	alg->exit = caam_cra_exit;
@@ -3020,8 +3064,7 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init_aead;
 	alg->exit = caam_cra_exit_aead;
@@ -3400,7 +3443,8 @@ static void ahash_done(void *cbk_ctx, u32 status)
 
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
 	memcpy(req->result, state->caam_ctx, digestsize);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 
 	print_hex_dump_debug("ctx@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
@@ -3425,7 +3469,8 @@ static void ahash_done_bi(void *cbk_ctx, u32 status)
 		ecode = caam_qi2_strstatus(ctx->dev, status);
 
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_BIDIRECTIONAL);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 
 	scatterwalk_map_and_copy(state->buf, req->src,
 				 req->nbytes - state->next_buflen,
@@ -3465,7 +3510,8 @@ static void ahash_done_ctx_src(void *cbk_ctx, u32 status)
 
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_BIDIRECTIONAL);
 	memcpy(req->result, state->caam_ctx, digestsize);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 
 	print_hex_dump_debug("ctx@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
@@ -3490,7 +3536,8 @@ static void ahash_done_ctx_dst(void *cbk_ctx, u32 status)
 		ecode = caam_qi2_strstatus(ctx->dev, status);
 
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 
 	scatterwalk_map_and_copy(state->buf, req->src,
 				 req->nbytes - state->next_buflen,
@@ -3528,7 +3575,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 	int in_len = *buflen + req->nbytes, to_hash;
 	int src_nents, mapped_nents, qm_sg_bytes, qm_sg_src_index;
 	struct ahash_edesc *edesc;
-	int ret = 0;
+	int ret = 0, edesc_size = 0;
 
 	*next_buflen = in_len & (crypto_tfm_alg_blocksize(&ahash->base) - 1);
 	to_hash = in_len - *next_buflen;
@@ -3554,18 +3601,31 @@ static int ahash_update_ctx(struct ahash_request *req)
 			mapped_nents = 0;
 		}
 
-		/* allocate space for base edesc and link tables */
-		edesc = qi_cache_zalloc(GFP_DMA | flags);
-		if (!edesc) {
-			dma_unmap_sg(ctx->dev, req->src, src_nents,
-				     DMA_TO_DEVICE);
-			return -ENOMEM;
-		}
-
-		edesc->src_nents = src_nents;
 		qm_sg_src_index = 1 + (*buflen ? 1 : 0);
 		qm_sg_bytes = pad_sg_nents(qm_sg_src_index + mapped_nents) *
 			      sizeof(*sg_table);
+
+		 /* Check if there's enough space for edesc saved in req */
+		edesc_size = sizeof(*edesc) +  qm_sg_bytes;
+		if (edesc_size > (crypto_ahash_reqsize(ahash) -
+				  sizeof(struct caam_hash_state))) {
+			/* allocate space for base edesc and link tables */
+			edesc = qi_cache_zalloc(GFP_DMA | flags);
+			if (!edesc) {
+				dma_unmap_sg(ctx->dev, req->src, src_nents,
+					     DMA_TO_DEVICE);
+				return -ENOMEM;
+			}
+			edesc->free = true;
+		} else {
+			/* get address for base edesc and link tables */
+			edesc = (struct ahash_edesc *)((u8 *)state +
+				 sizeof(struct caam_hash_state));
+			/* clear memory */
+			memset(edesc, 0, sizeof(*edesc));
+		}
+
+		edesc->src_nents = src_nents;
 		sg_table = &edesc->sgt[0];
 
 		ret = ctx_map_to_qm_sg(ctx->dev, state, ctx->ctx_len, sg_table,
@@ -3627,7 +3687,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 	return ret;
 unmap_ctx:
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_BIDIRECTIONAL);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	return ret;
 }
 
@@ -3642,18 +3703,31 @@ static int ahash_final_ctx(struct ahash_request *req)
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		      GFP_KERNEL : GFP_ATOMIC;
 	int buflen = state->buflen;
-	int qm_sg_bytes;
+	int qm_sg_bytes, edesc_size = 0;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	struct dpaa2_sg_entry *sg_table;
 	int ret;
 
-	/* allocate space for base edesc and link tables */
-	edesc = qi_cache_zalloc(GFP_DMA | flags);
-	if (!edesc)
-		return -ENOMEM;
-
 	qm_sg_bytes = pad_sg_nents(1 + (buflen ? 1 : 0)) * sizeof(*sg_table);
+
+	/* Check if there's enough space for edesc saved in req */
+	edesc_size = sizeof(*edesc) +  qm_sg_bytes;
+	if (edesc_size > (crypto_ahash_reqsize(ahash) -
+			  sizeof(struct caam_hash_state))) {
+		/* allocate space for base edesc and link tables */
+		edesc = qi_cache_zalloc(GFP_DMA | flags);
+		if (!edesc)
+			return -ENOMEM;
+		edesc->free = true;
+	} else {
+		/* get address for base edesc and link tables */
+		edesc = (struct ahash_edesc *)((u8 *)state +
+			 sizeof(struct caam_hash_state));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
+	}
+
 	sg_table = &edesc->sgt[0];
 
 	ret = ctx_map_to_qm_sg(ctx->dev, state, ctx->ctx_len, sg_table,
@@ -3698,7 +3772,8 @@ static int ahash_final_ctx(struct ahash_request *req)
 
 unmap_ctx:
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_BIDIRECTIONAL);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	return ret;
 }
 
@@ -3713,7 +3788,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		      GFP_KERNEL : GFP_ATOMIC;
 	int buflen = state->buflen;
-	int qm_sg_bytes, qm_sg_src_index;
+	int qm_sg_bytes, qm_sg_src_index, edesc_size = 0;
 	int src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
@@ -3737,17 +3812,31 @@ static int ahash_finup_ctx(struct ahash_request *req)
 		mapped_nents = 0;
 	}
 
-	/* allocate space for base edesc and link tables */
-	edesc = qi_cache_zalloc(GFP_DMA | flags);
-	if (!edesc) {
-		dma_unmap_sg(ctx->dev, req->src, src_nents, DMA_TO_DEVICE);
-		return -ENOMEM;
-	}
-
-	edesc->src_nents = src_nents;
 	qm_sg_src_index = 1 + (buflen ? 1 : 0);
 	qm_sg_bytes = pad_sg_nents(qm_sg_src_index + mapped_nents) *
 		      sizeof(*sg_table);
+
+	 /* Check if there's enough space for edesc saved in req */
+	edesc_size = sizeof(*edesc) +  qm_sg_bytes;
+	if (edesc_size > (crypto_ahash_reqsize(ahash) -
+			  sizeof(struct caam_hash_state))) {
+		/* allocate space for base edesc and link tables */
+		edesc = qi_cache_zalloc(GFP_DMA | flags);
+		if (!edesc) {
+			dma_unmap_sg(ctx->dev, req->src, src_nents,
+				     DMA_TO_DEVICE);
+			return -ENOMEM;
+		}
+		edesc->free = true;
+	} else {
+		/* get address for base edesc and link tables */
+		edesc = (struct ahash_edesc *)((u8 *)state +
+			 sizeof(struct caam_hash_state));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
+	}
+
+	edesc->src_nents = src_nents;
 	sg_table = &edesc->sgt[0];
 
 	ret = ctx_map_to_qm_sg(ctx->dev, state, ctx->ctx_len, sg_table,
@@ -3792,7 +3881,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 unmap_ctx:
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_BIDIRECTIONAL);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	return ret;
 }
 
@@ -3807,8 +3897,9 @@ static int ahash_digest(struct ahash_request *req)
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		      GFP_KERNEL : GFP_ATOMIC;
 	int digestsize = crypto_ahash_digestsize(ahash);
-	int src_nents, mapped_nents;
+	int src_nents, mapped_nents, qm_sg_bytes, edesc_size = 0;
 	struct ahash_edesc *edesc;
+	struct dpaa2_sg_entry *sg_table;
 	int ret = -ENOMEM;
 
 	state->buf_dma = 0;
@@ -3830,21 +3921,33 @@ static int ahash_digest(struct ahash_request *req)
 		mapped_nents = 0;
 	}
 
-	/* allocate space for base edesc and link tables */
-	edesc = qi_cache_zalloc(GFP_DMA | flags);
-	if (!edesc) {
-		dma_unmap_sg(ctx->dev, req->src, src_nents, DMA_TO_DEVICE);
-		return ret;
+	qm_sg_bytes = pad_sg_nents(mapped_nents) * sizeof(*sg_table);
+
+	/* Check if there's enough space for edesc saved in req */
+	edesc_size = sizeof(*edesc) +  qm_sg_bytes;
+	if (edesc_size > (crypto_ahash_reqsize(ahash) -
+			  sizeof(struct caam_hash_state))) {
+		/* allocate space for base edesc and link tables */
+		edesc = qi_cache_zalloc(GFP_DMA | flags);
+		if (!edesc) {
+			dma_unmap_sg(ctx->dev, req->src, src_nents,
+				     DMA_TO_DEVICE);
+			return ret;
+		}
+		edesc->free = true;
+	} else {
+		/* get address for base edesc and link tables */
+		edesc = (struct ahash_edesc *)((u8 *)state +
+			 sizeof(struct caam_hash_state));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
 	}
 
 	edesc->src_nents = src_nents;
 	memset(&req_ctx->fd_flt, 0, sizeof(req_ctx->fd_flt));
 
 	if (mapped_nents > 1) {
-		int qm_sg_bytes;
-		struct dpaa2_sg_entry *sg_table = &edesc->sgt[0];
-
-		qm_sg_bytes = pad_sg_nents(mapped_nents) * sizeof(*sg_table);
+		sg_table = &edesc->sgt[0];
 		sg_to_qm_sg_last(req->src, req->nbytes, sg_table, 0);
 		edesc->qm_sg_dma = dma_map_single(ctx->dev, sg_table,
 						  qm_sg_bytes, DMA_TO_DEVICE);
@@ -3887,7 +3990,8 @@ static int ahash_digest(struct ahash_request *req)
 
 unmap:
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	return ret;
 }
 
@@ -3899,18 +4003,17 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	struct caam_request *req_ctx = &state->caam_req;
 	struct dpaa2_fl_entry *in_fle = &req_ctx->fd_flt[1];
 	struct dpaa2_fl_entry *out_fle = &req_ctx->fd_flt[0];
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		      GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = state->buf;
 	int buflen = state->buflen;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int ret = -ENOMEM;
 
-	/* allocate space for base edesc and link tables */
-	edesc = qi_cache_zalloc(GFP_DMA | flags);
-	if (!edesc)
-		return ret;
+	/* get address for base edesc and link tables */
+	edesc = (struct ahash_edesc *)((u8 *)state +
+		 sizeof(struct caam_hash_state));
+	/* clear memory */
+	memset(edesc, 0, sizeof(*edesc));
 
 	if (buflen) {
 		state->buf_dma = dma_map_single(ctx->dev, buf, buflen,
@@ -3960,7 +4063,6 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 
 unmap:
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
-	qi_cache_free(edesc);
 	return ret;
 }
 
@@ -3978,7 +4080,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	int *buflen = &state->buflen;
 	int *next_buflen = &state->next_buflen;
 	int in_len = *buflen + req->nbytes, to_hash;
-	int qm_sg_bytes, src_nents, mapped_nents;
+	int qm_sg_bytes, src_nents, mapped_nents, edesc_size = 0;
 	struct ahash_edesc *edesc;
 	int ret = 0;
 
@@ -4006,17 +4108,30 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			mapped_nents = 0;
 		}
 
-		/* allocate space for base edesc and link tables */
-		edesc = qi_cache_zalloc(GFP_DMA | flags);
-		if (!edesc) {
-			dma_unmap_sg(ctx->dev, req->src, src_nents,
-				     DMA_TO_DEVICE);
-			return -ENOMEM;
+		qm_sg_bytes = pad_sg_nents(1 + mapped_nents) *
+			      sizeof(*sg_table);
+
+		/* Check if there's enough space for edesc saved in req */
+		edesc_size = sizeof(*edesc) +  qm_sg_bytes;
+		if (edesc_size > (crypto_ahash_reqsize(ahash) -
+				  sizeof(struct caam_hash_state))) {
+			/* allocate space for base edesc and link tables */
+			edesc = qi_cache_zalloc(GFP_DMA | flags);
+			if (!edesc) {
+				dma_unmap_sg(ctx->dev, req->src, src_nents,
+					     DMA_TO_DEVICE);
+				return -ENOMEM;
+			}
+			edesc->free = true;
+		} else {
+			/* get address for base edesc and link tables */
+			edesc = (struct ahash_edesc *)((u8 *)state +
+				 sizeof(struct caam_hash_state));
+			/* clear memory */
+			memset(edesc, 0, sizeof(*edesc));
 		}
 
 		edesc->src_nents = src_nents;
-		qm_sg_bytes = pad_sg_nents(1 + mapped_nents) *
-			      sizeof(*sg_table);
 		sg_table = &edesc->sgt[0];
 
 		ret = buf_map_to_qm_sg(ctx->dev, sg_table, state);
@@ -4081,7 +4196,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	return ret;
 unmap_ctx:
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_TO_DEVICE);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	return ret;
 }
 
@@ -4096,7 +4212,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		      GFP_KERNEL : GFP_ATOMIC;
 	int buflen = state->buflen;
-	int qm_sg_bytes, src_nents, mapped_nents;
+	int qm_sg_bytes, src_nents, mapped_nents, edesc_size = 0;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	struct dpaa2_sg_entry *sg_table;
@@ -4119,15 +4235,29 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 		mapped_nents = 0;
 	}
 
-	/* allocate space for base edesc and link tables */
-	edesc = qi_cache_zalloc(GFP_DMA | flags);
-	if (!edesc) {
-		dma_unmap_sg(ctx->dev, req->src, src_nents, DMA_TO_DEVICE);
-		return ret;
+	qm_sg_bytes = pad_sg_nents(2 + mapped_nents) * sizeof(*sg_table);
+
+	/* Check if there's enough space for edesc saved in req */
+	edesc_size = sizeof(*edesc) +  qm_sg_bytes;
+	if (edesc_size > (crypto_ahash_reqsize(ahash) -
+			  sizeof(struct caam_hash_state))) {
+		/* allocate space for base edesc and link tables */
+		edesc = qi_cache_zalloc(GFP_DMA | flags);
+		if (!edesc) {
+			dma_unmap_sg(ctx->dev, req->src, src_nents,
+				     DMA_TO_DEVICE);
+			return ret;
+		}
+		edesc->free = true;
+	} else {
+		/* get address for base edesc and link tables */
+		edesc = (struct ahash_edesc *)((u8 *)state +
+			 sizeof(struct caam_hash_state));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
 	}
 
 	edesc->src_nents = src_nents;
-	qm_sg_bytes = pad_sg_nents(2 + mapped_nents) * sizeof(*sg_table);
 	sg_table = &edesc->sgt[0];
 
 	ret = buf_map_to_qm_sg(ctx->dev, sg_table, state);
@@ -4177,7 +4307,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	return ret;
 unmap:
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_FROM_DEVICE);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	return ret;
 }
 
@@ -4195,7 +4326,7 @@ static int ahash_update_first(struct ahash_request *req)
 	int *buflen = &state->buflen;
 	int *next_buflen = &state->next_buflen;
 	int to_hash;
-	int src_nents, mapped_nents;
+	int src_nents, mapped_nents, qm_sg_bytes, edesc_size = 0;
 	struct ahash_edesc *edesc;
 	int ret = 0;
 
@@ -4224,12 +4355,26 @@ static int ahash_update_first(struct ahash_request *req)
 			mapped_nents = 0;
 		}
 
-		/* allocate space for base edesc and link tables */
-		edesc = qi_cache_zalloc(GFP_DMA | flags);
-		if (!edesc) {
-			dma_unmap_sg(ctx->dev, req->src, src_nents,
-				     DMA_TO_DEVICE);
-			return -ENOMEM;
+		qm_sg_bytes = pad_sg_nents(mapped_nents) * sizeof(*sg_table);
+
+		/* Check if there's enough space for edesc saved in req */
+		edesc_size = sizeof(*edesc) +  qm_sg_bytes;
+		if (edesc_size > (crypto_ahash_reqsize(ahash) -
+				  sizeof(struct caam_hash_state))) {
+			/* allocate space for base edesc and link tables */
+			edesc = qi_cache_zalloc(GFP_DMA | flags);
+			if (!edesc) {
+				dma_unmap_sg(ctx->dev, req->src, src_nents,
+					     DMA_TO_DEVICE);
+				return -ENOMEM;
+			}
+			edesc->free = true;
+		} else {
+			/* get address for base edesc and link tables */
+			edesc = (struct ahash_edesc *)((u8 *)state +
+				 sizeof(struct caam_hash_state));
+			/* clear memory */
+			memset(edesc, 0, sizeof(*edesc));
 		}
 
 		edesc->src_nents = src_nents;
@@ -4240,11 +4385,7 @@ static int ahash_update_first(struct ahash_request *req)
 		dpaa2_fl_set_len(in_fle, to_hash);
 
 		if (mapped_nents > 1) {
-			int qm_sg_bytes;
-
 			sg_to_qm_sg_last(req->src, src_len, sg_table, 0);
-			qm_sg_bytes = pad_sg_nents(mapped_nents) *
-				      sizeof(*sg_table);
 			edesc->qm_sg_dma = dma_map_single(ctx->dev, sg_table,
 							  qm_sg_bytes,
 							  DMA_TO_DEVICE);
@@ -4306,7 +4447,8 @@ static int ahash_update_first(struct ahash_request *req)
 	return ret;
 unmap_ctx:
 	ahash_unmap_ctx(ctx->dev, edesc, req, DMA_TO_DEVICE);
-	qi_cache_free(edesc);
+	if (edesc->free)
+		qi_cache_free(edesc);
 	return ret;
 }
 
@@ -4553,7 +4695,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 					 HASH_MSG_LEN + 64,
 					 HASH_MSG_LEN + SHA512_DIGEST_SIZE };
 	dma_addr_t dma_addr;
-	int i;
+	int i, extra_reqsize = 0;
 
 	ctx->dev = caam_hash->dev;
 
@@ -4591,8 +4733,15 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 				   OP_ALG_ALGSEL_SUBMASK) >>
 				  OP_ALG_ALGSEL_SHIFT];
 
+	/* Compute extra space needed for base edesc and link tables */
+	extra_reqsize = sizeof(struct ahash_edesc) +
+			/* link tables for src:
+			 * 4 entries max + max 2 for remaining buf, aligned = 8
+			 */
+			(8 * sizeof(struct dpaa2_sg_entry));
+
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct caam_hash_state));
+				 sizeof(struct caam_hash_state) + extra_reqsize);
 
 	/*
 	 * For keyed hash algorithms shared descriptors
@@ -4647,7 +4796,7 @@ static struct caam_hash_alg *caam_hash_alloc(struct device *dev,
 	alg->cra_priority = CAAM_CRA_PRIORITY;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
+	alg->cra_flags = CRYPTO_ALG_ASYNC;
 
 	t_alg->alg_type = template->alg_type;
 	t_alg->dev = dev;
diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamalg_qi2.h
index d35253407ade..3e7367784b39 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -102,6 +102,7 @@ struct dpaa2_caam_priv_per_cpu {
  * @dst_nents: number of segments in output scatterlist
  * @iv_dma: dma address of iv for checking continuity and link table
  * @qm_sg_bytes: length of dma mapped h/w link table
+ * @free: stored to determine if aead_edesc needs to be freed
  * @qm_sg_dma: bus physical mapped address of h/w link table
  * @assoclen: associated data length, in CAAM endianness
  * @assoclen_dma: bus physical mapped address of req->assoclen
@@ -112,6 +113,7 @@ struct aead_edesc {
 	int dst_nents;
 	dma_addr_t iv_dma;
 	int qm_sg_bytes;
+	bool free;
 	dma_addr_t qm_sg_dma;
 	unsigned int assoclen;
 	dma_addr_t assoclen_dma;
@@ -124,6 +126,7 @@ struct aead_edesc {
  * @dst_nents: number of segments in output scatterlist
  * @iv_dma: dma address of iv for checking continuity and link table
  * @qm_sg_bytes: length of dma mapped qm_sg space
+ * @free: stored to determine if skcipher_edesc needs to be freed
  * @qm_sg_dma: I/O virtual address of h/w link table
  * @sgt: the h/w link table, followed by IV
  */
@@ -132,6 +135,7 @@ struct skcipher_edesc {
 	int dst_nents;
 	dma_addr_t iv_dma;
 	int qm_sg_bytes;
+	bool free;
 	dma_addr_t qm_sg_dma;
 	struct dpaa2_sg_entry sgt[];
 };
@@ -141,12 +145,14 @@ struct skcipher_edesc {
  * @qm_sg_dma: I/O virtual address of h/w link table
  * @src_nents: number of segments in input scatterlist
  * @qm_sg_bytes: length of dma mapped qm_sg space
+ * @free: stored to determine if ahash_edesc needs to be freed
  * @sgt: pointer to h/w link table
  */
 struct ahash_edesc {
 	dma_addr_t qm_sg_dma;
 	int src_nents;
 	int qm_sg_bytes;
+	bool free;
 	struct dpaa2_sg_entry sgt[];
 };
 
-- 
2.17.1

