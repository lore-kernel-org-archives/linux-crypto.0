Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5ECFC6369E
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EEDB20C56
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgLCBh0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 20:37:26 -0500
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:53706
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727064AbgLCBh0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 20:37:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZudrV7IzwFCyg0xZmooLdVf/RDmrDGE8cmic7ekMWJoKoJ7Ki9cDw7pyQsnHcXCLJXJgPffj2ccqXTeBaUk/yWqKEOlJAL6dPlFEySpI5LSWmfNlaQpv7kC7mn2NDjDn3YuolWudGLzO7jbbCSFjap226wROztqqv2V4cxC9wXSl0QPbwDwkVlfI6gOrBuLi5/3+Gl9G/aDlBIR1/cvyqvi//FPHw6YgM4ag12o1WEMXjBHXxmQInmqG6ENbE62YHLFUw/VydnZ+NIYPwet3tUJq1m47hwRXrePrcLwCBPhRJ0SqPg12pbSq4uEFA4dBHVl7+vcqAVR2VbqHmo97g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYbDpmiYRqYJJZakh225B2tAE0oig4gXKlJGQraX0k0=;
 b=PdilO1h/Y20cBYe5SQMlKxItkoX3P2Miv9ntmM0qqdzBw9Bb7+RJAnv5jE0M2GJm525w30/xx93w3Tyzy0CdNd+yhimvCQsoaGPKZHdG65nxetArB+7cySyDNRgSdFX2gPfd1Z7J+uv5eMiP37VndEmMH4OIGrRw/d4JuzYM9cYPdm/HpslaHt+oh0u62J7HLUqRYe4A22Jxo62HakT4RJ+GI3+saS1h99R8G016vSE+rzhCchV1BwP9qRuE9RFQZRNTeQoCrYBAQAn24uHPmlY4hS4OocilIK8tlAJZ/0ykxAZrcwc9j0Pw7MmeFNbxOy2a/lG/urPAEkyOhW5QqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYbDpmiYRqYJJZakh225B2tAE0oig4gXKlJGQraX0k0=;
 b=WrqC1R16EHRiEWtnNtu4SSFrPM/W4nWFd+UOCik8evgUBIDIsaDoApethp3vWpHoSd4iYvMT5bUVl3XoNMaN3VZphZh8dLUZcZfwpJ6NALGVXrL2BBM0FhTIQv6ZTFBsQcz+DqAa44C7ZnBVN9xP6sb8pyAZ5NviuQc2Mhxokz4=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB4430.eurprd04.prod.outlook.com
 (2603:10a6:803:65::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Thu, 3 Dec
 2020 01:36:29 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3632.018; Thu, 3 Dec 2020
 01:36:29 +0000
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
Subject: [PATCH 3/5] crypto: caam/jr - avoid allocating memory at crypto request runtime fost hash
Date:   Thu,  3 Dec 2020 03:35:22 +0200
Message-Id: <20201203013524.30495-4-iuliana.prodan@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
References: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36)
 To VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Thu, 3 Dec 2020 01:36:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3505ddb8-f317-427e-92d6-08d8972bdb0b
X-MS-TrafficTypeDiagnostic: VI1PR04MB4430:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4430082D01D6D69B0CDE0E74CDF20@VI1PR04MB4430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1d1aAaYoZoXIi6zAHqmawYUeEMov0A9H9xOG9OO/M0RNcxcT+QX5Vy24Qng8yHTUUMQl9M5rmrzaySSQIkES8CubvbRWy2gOKzTViWWv7aaPcG+YzVHeF/cfhbs5J18JHat+hB7ccXIsuE+7TeSb3vxsRrsM5LTvCJRI/B9YZv6Tc4CGhW98K0Sl0O7NbCjXALxWhAdjuWIZkb43VXbunc25ICdGtIGh+3ZcuAcvzQdfsJ+JzPstKM+hzqkrq0ENS2UG78zQP8Lw2esFpuhC6CTPytyHfpWV4geXJs5BNQcrpfcH4KoZic+xzEfuMmOGfQvgVzpHblkUYE94ZXEyFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(54906003)(1076003)(110136005)(2906002)(316002)(2616005)(83380400001)(8676002)(52116002)(6506007)(8936002)(5660300002)(66946007)(26005)(66476007)(956004)(16526019)(86362001)(186003)(6512007)(4326008)(478600001)(66556008)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CoXwSyONdgDn6bDBxIqKiomTRX/RoFWAHdPrQokYbqQ9pFLu4JGs4HZ01+4s?=
 =?us-ascii?Q?sJXY1NwVbC33EenxcZWjlQyWP1l5DB+DESy3UB4PVPuLhZPB3cnJqmtOlY0K?=
 =?us-ascii?Q?7onqhm71tbprfz0Y/rw8fS3HZVPLGGFG3+Lbi1ah571vxtXp+91SPi6carwL?=
 =?us-ascii?Q?77b3V7QlRBvgv8Co/fPD2RiSyERqH6kmPhb1O8OMikZt3w+qfLIgBB4zI5oj?=
 =?us-ascii?Q?MkOTrXaL5iT4rpgLNq04bNRgSCdx37gZN+qgI5lkSIPJLEZEhb/o+izLoD4I?=
 =?us-ascii?Q?Rm9x7e+Sm994H3g62aFegawFkT0t1XuuA7loq62qJZme1xAVhn2EmR6NtJrF?=
 =?us-ascii?Q?Z+7tFUA95xgU+6+TYAkvwssKCNBy+6Xb19hIjQ1yVwOROPbvD8h63eFkleYz?=
 =?us-ascii?Q?j2gNu6x/P8Vfn63dbZoHH7FbXuWiExKUL+CoKj5gGTRfc5LQ2c3fns8ci3fS?=
 =?us-ascii?Q?+uYhQSTdmiOX7tQJq9tIS/CvUQ8zSUxrCbFi/QjfRlktcGzUPL2lu29K+GM9?=
 =?us-ascii?Q?9Mjrzk3opHcpVXj5Kt086+HkZlt4+Bt7LAq9ONbemjv4/UM9v+OT+MypyA7n?=
 =?us-ascii?Q?gLzguN1phDai7bPdVHy9xvf+UF+EZZSYvQP5fJeDwoEf0f4us8Uvsl5opoZt?=
 =?us-ascii?Q?CK7dGOb3F2CSW3xMO+fQxNbMrJBcB4TPVarGOzB1A4dxhAm8NKwZIw7ngx4d?=
 =?us-ascii?Q?6GRvEi84n+szbln7dhcy02g8PJL36iEGS08ioqALz/T5IqUK/HjuFxrDyzAk?=
 =?us-ascii?Q?FCe/s2uVQkBKPYWGCLkaIu5FKcgsjIJV+pKuYZDLGkWSFEYeV3WFSRDzh31P?=
 =?us-ascii?Q?wWH6FKh6Pkq151rp1IiM7+0CKWml2TyDCQR9D2scpLjRxMrBGb+J6G4G4z8I?=
 =?us-ascii?Q?BUWLuG4eJgS+q/Dg2dhXYQLx14ZT3MHZXbq56HRN5bLCLglkjCVuLGa6P2XV?=
 =?us-ascii?Q?XX4E6UDn7xeyC6IcJpH7IvNagoPXRAF4h08q4DRDEFgPg0pfYP/krNpce6az?=
 =?us-ascii?Q?NG/x?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3505ddb8-f317-427e-92d6-08d8972bdb0b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 01:36:28.9100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n/lBB2EXoLIZYgkTB/0QF2Us6MgJvv1qZiwPIlO9/nHIRcYuaLqZJ7otUiIM/BF6onTXBLdMaZrEb9b0UvCUTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4430
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

Remove CRYPTO_ALG_ALLOCATES_MEMORY flag and allocate the memory
needed by the driver, to fulfil a request, within the crypto
request object.
The extra size needed for base extended descriptor and link tables
is computed in frontend driver (caamhash) initialization and saved
in reqsize field that indicates how much memory could be needed per
request.

CRYPTO_ALG_ALLOCATES_MEMORY flag is limited only to
dm-crypt use-cases, which seems to be 4 entries maximum.
Therefore in reqsize we allocate memory for maximum 4 entries
for src and 4, aligned.
If the driver needs more than the 4 entries maximum, the memory
is dynamically allocated, at runtime.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 77 +++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index e8a6d8bc43b5..4a6376691ad6 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -527,6 +527,7 @@ static int acmac_setkey(struct crypto_ahash *ahash, const u8 *key,
  * @src_nents: number of segments in input scatterlist
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @bklog: stored to determine if the request needs backlog
+ * @free: stored to determine if ahash_edesc needs to be freed
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
  * @sec4_sg: h/w link table
  */
@@ -535,6 +536,7 @@ struct ahash_edesc {
 	int src_nents;
 	int sec4_sg_bytes;
 	bool bklog;
+	bool free;
 	u32 hw_desc[DESC_JOB_IO_LEN_MAX / sizeof(u32)] ____cacheline_aligned;
 	struct sec4_sg_entry sec4_sg[];
 };
@@ -595,7 +597,8 @@ static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, dir);
 	memcpy(req->result, state->caam_ctx, digestsize);
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 
 	print_hex_dump_debug("ctx@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
@@ -644,7 +647,8 @@ static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 		ecode = caam_jr_strstatus(jrdev, err);
 
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, dir);
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 
 	scatterwalk_map_and_copy(state->buf, req->src,
 				 req->nbytes - state->next_buflen,
@@ -701,11 +705,25 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 		       GFP_KERNEL : GFP_ATOMIC;
 	struct ahash_edesc *edesc;
 	unsigned int sg_size = sg_num * sizeof(struct sec4_sg_entry);
-
-	edesc = kzalloc(sizeof(*edesc) + sg_size, GFP_DMA | flags);
-	if (!edesc) {
-		dev_err(ctx->jrdev, "could not allocate extended descriptor\n");
-		return NULL;
+	int edesc_size;
+
+	 /* Check if there's enough space for edesc saved in req */
+	edesc_size = sizeof(*edesc) + sg_size;
+	if (edesc_size > (crypto_ahash_reqsize(ahash) -
+			  sizeof(struct caam_hash_state))) {
+		/* allocate space for base edesc and link tables */
+		edesc = kzalloc(sizeof(*edesc) + sg_size, GFP_DMA | flags);
+		if (!edesc) {
+			dev_err(ctx->jrdev, "could not allocate extended descriptor\n");
+			return NULL;
+		}
+		edesc->free = true;
+	} else {
+		/* get address for base edesc and link tables */
+		edesc = (struct ahash_edesc *)((u8 *)state +
+			 sizeof(struct caam_hash_state));
+		/* clear memory */
+		memset(edesc, 0, sizeof(*edesc));
 	}
 
 	state->edesc = edesc;
@@ -767,7 +785,8 @@ static int ahash_do_one_req(struct crypto_engine *engine, void *areq)
 
 	if (ret != -EINPROGRESS) {
 		ahash_unmap(jrdev, state->edesc, req, 0);
-		kfree(state->edesc);
+		if (state->edesc->free)
+			kfree(state->edesc);
 	} else {
 		ret = 0;
 	}
@@ -802,7 +821,8 @@ static int ahash_enqueue_req(struct device *jrdev,
 
 	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
 		ahash_unmap_ctx(jrdev, edesc, req, dst_len, dir);
-		kfree(edesc);
+		if (edesc->free)
+			kfree(edesc);
 	}
 
 	return ret;
@@ -930,7 +950,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 	return ret;
 unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_BIDIRECTIONAL);
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 	return ret;
 }
 
@@ -991,7 +1012,8 @@ static int ahash_final_ctx(struct ahash_request *req)
 				 digestsize, DMA_BIDIRECTIONAL);
  unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_BIDIRECTIONAL);
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 	return ret;
 }
 
@@ -1065,7 +1087,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 				 digestsize, DMA_BIDIRECTIONAL);
  unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_BIDIRECTIONAL);
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 	return ret;
 }
 
@@ -1114,7 +1137,8 @@ static int ahash_digest(struct ahash_request *req)
 				  req->nbytes);
 	if (ret) {
 		ahash_unmap(jrdev, edesc, req, digestsize);
-		kfree(edesc);
+		if (edesc->free)
+			kfree(edesc);
 		return ret;
 	}
 
@@ -1123,7 +1147,8 @@ static int ahash_digest(struct ahash_request *req)
 	ret = map_seq_out_ptr_ctx(desc, jrdev, state, digestsize);
 	if (ret) {
 		ahash_unmap(jrdev, edesc, req, digestsize);
-		kfree(edesc);
+		if (edesc->free)
+			kfree(edesc);
 		return -ENOMEM;
 	}
 
@@ -1180,7 +1205,8 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 				 digestsize, DMA_FROM_DEVICE);
  unmap:
 	ahash_unmap(jrdev, edesc, req, digestsize);
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 	return -ENOMEM;
 }
 
@@ -1301,7 +1327,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	return ret;
  unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_TO_DEVICE);
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 	return ret;
 }
 
@@ -1376,7 +1403,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 				 digestsize, DMA_FROM_DEVICE);
  unmap:
 	ahash_unmap(jrdev, edesc, req, digestsize);
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 	return -ENOMEM;
 
 }
@@ -1484,7 +1512,8 @@ static int ahash_update_first(struct ahash_request *req)
 	return ret;
  unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_TO_DEVICE);
-	kfree(edesc);
+	if (edesc->free)
+		kfree(edesc);
 	return ret;
 }
 
@@ -1771,6 +1800,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 						      sh_desc_update);
 	dma_addr_t dma_addr;
 	struct caam_drv_private *priv;
+	int extra_reqsize = 0;
 
 	/*
 	 * Get a Job ring from Job Ring driver to ensure in-order
@@ -1851,8 +1881,15 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 
 	ctx->enginectx.op.do_one_request = ahash_do_one_req;
 
+	/* Compute extra space needed for base edesc and link tables */
+	extra_reqsize = sizeof(struct ahash_edesc) +
+			/* link tables for src:
+			 * 4 entries max + max 2 for remaining buf, aligned = 8
+			 */
+			(8 * sizeof(struct sec4_sg_entry));
+
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct caam_hash_state));
+				 sizeof(struct caam_hash_state) + extra_reqsize);
 
 	/*
 	 * For keyed hash algorithms shared descriptors
@@ -1927,7 +1964,7 @@ caam_hash_alloc(struct caam_hash_template *template,
 	alg->cra_priority = CAAM_CRA_PRIORITY;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
+	alg->cra_flags = CRYPTO_ALG_ASYNC;
 
 	t_alg->alg_type = template->alg_type;
 
-- 
2.17.1

