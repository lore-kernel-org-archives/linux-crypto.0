Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73A9C64E7D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAB1B206F9
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="mpEPL8j7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbgKYVOr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 16:14:47 -0500
Received: from mail-eopbgr130044.outbound.protection.outlook.com ([40.107.13.44]:31734
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbgKYVOq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 16:14:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TO9LbiqeTnhpUmzUKoXwecOspHR/B8z8Ll7WSVOFXIP8SUFdJTCNuoofHcIj+Z0Z9d28eu5sCH4Z9fKnaEoExcrxx59XM5nshFp/lFkOtmyC0B98homztqc9j3mr0W1qOqdGlJ1TqpW0S0f+B8kUhO5iqDUspRNlPeBegnbQcSZQmRqehJZtSxJHVNn64dfIW6mOf6n+E8vtFmhm/t7pb47aOA0GAboXd533BnJlSdl+NIpvC4rJmzDqEABKyfol0jRA84/BQu/Duh4Hj6fB3WVMpuShe1CwptJ/6txATQohIhHPrliLTXACLmcG2jATu2XYLBrluyXVK0XgwuGrJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoXCUSAbOcQtUb6iu9lsGGwGNm04q75pyhMxu+EfSPQ=;
 b=KML7+zO+UqKpWETtn38kG73t+6+jSMBSraqVyrOBBbU6SgNezSs9EHUM65Wwa2yp8byB1lLfROUOPP774fRvGuWxK2ylPCzCEZjH57lKsWBKWVvmH4WwM+8jnyznH0Jp9t9QnXHgNEMevPAz2tTEPYD7b+uYCPJYCGWuoa4DpQKv97GGwic7zRHzQO9Fh11jaDyYcGfDQCNpRI0C4+x08VLauM5J2g9FxZc8CWv/ziX9DP0ZkbomH0VjzbbaFKD73JJbKTMIXiOjic7EtCWdATjPsdVYnEsYkHSeuthfk6YevNrbg3Gg8eYlICUPMX8HQYSMaXfGvOW7alsoR0/KDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoXCUSAbOcQtUb6iu9lsGGwGNm04q75pyhMxu+EfSPQ=;
 b=mpEPL8j7W1g8AS9xDJgSOS3btxnqJS8Zz00jy1WT3w/Rp0syMG+gzPhM4ZZ71E/0APhxBKO3j0z2Dwgxd933JABjvd1O+x612yO8CdD9viR/3NBYbB+KHO2O9P9SYoflSMlMewCFPQqzVaTK7Y8vJtTtvWjpNTcMlWsKGzx0zXs=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB6941.eurprd04.prod.outlook.com
 (2603:10a6:803:12e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Wed, 25 Nov
 2020 21:14:42 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3589.025; Wed, 25 Nov 2020
 21:14:42 +0000
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
Subject: [RFC PATCH 4/4] crypto: caam - avoid allocating memory at crypto request runtime for aead
Date:   Wed, 25 Nov 2020 23:13:11 +0200
Message-Id: <20201125211311.2179-5-iuliana.prodan@oss.nxp.com>
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
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Wed, 25 Nov 2020 21:14:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7d89a639-e455-4cf5-01ad-08d891872004
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69414743DCD563BB2A116E4BCDFA0@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dMzXqXK6Jvsk7avWIPwG+b5mk+AJSRh3/kFk6VqKbiqRHG/ejxghOLTvqtXQ2kWgm1W/ZEK65nTlIvP2r/uBGl8YqmKVNJDtMdfhkJc8154RQm9R3/fnOROt0pbiwVQHSXx6Z4KIZbImsk5VT5g61LgnEfEbTYv01biJrR2gp0ig4CIKWnCf9WeOa6PC0WJPzS+tgnRLYwtbTE6tuT/yM8TB8+lwy28HBm0wFqnc3iAlOj0cgJvOgbYFMg1jjvmaifpJg3kJyC550kjq/9wbtKwDFGBknHcEZIVMhzrhwhX26RwzG8qH8z1/hLNTSXPC8qCWso/YwB6kwLwb0wAeVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(316002)(86362001)(5660300002)(66476007)(66556008)(186003)(52116002)(6512007)(66946007)(26005)(110136005)(54906003)(2906002)(8676002)(6486002)(16526019)(4326008)(83380400001)(8936002)(478600001)(1076003)(6506007)(956004)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PlOJ4+2qZ1kPsj4UK4P0MYf9C5Vws4/HbPtEpKbgJREXLFwHMvQc6iOSiYkq?=
 =?us-ascii?Q?q9zGLW1ccOgNA5elLLIB6e8v0nKS+ocFEDkSiz5mrIoWwCrmjMQgX9DRI4sZ?=
 =?us-ascii?Q?NhlQp+6GHMA8Pi02se33X58A8QcR9DuhoVDCpbiBba3WclSh1AyRvECxW1XW?=
 =?us-ascii?Q?/4iC+kyKlnPUubFJpbr0Zk2m7rnQb0mDU/W3p3wfSeuvIkEwiy0T50iEJOa+?=
 =?us-ascii?Q?ZmjTihTDLNE8/IA0a0/q540podI3CO7fGI8FtaXN1c56Jh4qrGFmoty3FGfA?=
 =?us-ascii?Q?aAZmb9tfttwEHOFJanmC7U3/gQ1tjaCJzOKq+vBL1xECKtxVzkAyO/m2iLw+?=
 =?us-ascii?Q?OVSP3J/g1rnafvsvwz8mJ6r4d9BpZ4hnTs0U7sbAGqnPKQGa33STLAGqurJE?=
 =?us-ascii?Q?vKf9LG27dT8HmL3mu1hrbCpDCfHgTk/pnpkmyY0TJ7QDs76Cj5tQflww7oOo?=
 =?us-ascii?Q?boa5h+lzpsLhnYRaW5Y2MOjYaYwKD9R1TTi12YsUvfxZPATAxHgIemPL9to+?=
 =?us-ascii?Q?fLHTsgOhiqh3IbrhULxW2546qsDcFiAvJ2n6vmEZ3iROHrVAmh/cllFfDnhC?=
 =?us-ascii?Q?HekkMejpLFNpmyXSPSLnxVvbm+JfAmxkKyuBu2lOyCt0VG2VrCYQfnEd4keA?=
 =?us-ascii?Q?wuHEmflZFyKvchh3ZqjNb82RK+yB14TzAvrrHhVz/ynrylqr6+rcprUXpQ/S?=
 =?us-ascii?Q?AnyQkh6/cYxJ43BWhIrkd8CoMd+qjA/gRe/AyzFBZ0TL79FZJu37qpD9B9ms?=
 =?us-ascii?Q?q1nMOQeLAXWZFpsITbm9xsxrVYifdpo2ZVjvLb7LooXo7d8mksaTLEeB3VL/?=
 =?us-ascii?Q?apjVOvGdMN/kGTu3YPOrJuRcj9vqNNzuNt97VS7ekzpaueTey5m/qWP7fvMP?=
 =?us-ascii?Q?m8iqdAVerU5ID9x6e1vrp4Neenq/8cHVPm0Rz3PVZpCfGNzsOfVOBeHS/HI1?=
 =?us-ascii?Q?uCsAy1pV1fQiNYx7hLme+pejgz3HJlmP6Swl+/ijnY8=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d89a639-e455-4cf5-01ad-08d891872004
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2020 21:14:41.8580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iCUbruIuBjeQ55QBzqLWD13FePKU6kCm++xaYsANxbG0rihsmqdqSH/Dmp6B1gYHXex3xiwnFkmKVF1ZVNuEiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
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
 drivers/crypto/caam/caamalg.c | 59 +++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 6ace8545faec..7038394c41c0 100644
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
@@ -1538,7 +1557,8 @@ static int aead_do_one_req(struct crypto_engine *engine, void *areq)
 
 	if (ret != -EINPROGRESS) {
 		aead_unmap(ctx->jrdev, rctx->edesc, req);
-		kfree(rctx->edesc);
+		if (rctx->edesc->free)
+			kfree(rctx->edesc);
 	} else {
 		ret = 0;
 	}
@@ -3463,6 +3483,20 @@ static int caam_aead_init(struct crypto_aead *tfm)
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
+
+	/* Need GFP_DMA for extra request size */
+	crypto_aead_set_flags(tfm, CRYPTO_TFM_REQ_DMA);
 
 	crypto_aead_set_reqsize(tfm, sizeof(struct caam_aead_req_ctx));
 
@@ -3533,8 +3567,7 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
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

