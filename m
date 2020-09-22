Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AADDC4363D
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0002F208A9
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="boehRoIW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIVQEN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:04:13 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:40665
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726340AbgIVQEK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:04:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTf6+dH1gyoA0YedhwGVBTSzxThWdUSKUy0CVworzo3rXRL4aGfML2ulOmbsw3CpFKHvRGr8cpWgrgnhkOpICTeqFDVMPZ0ygehjCCC7bt5WvAFW04kL8PEBW/TbT4OX8W1XdDDDLB8ix3P8kn9WmSqMaIZ56VIwK3xF6MZy7A3vNG7n7Hf1NJAzAj/RS1POvt73J2nTcW79FVqgTMzf0wSX/S0qM41aiqJzHFInAHaYTs4yZ3nnnpt4aIwdZ2mslNwtBUUnSG3kNZzh1NRW6hdRf3ES1nwJ5jEJBbap2DzG9ygIb+YxYW9P+fLyJiHjCSRmEWivaKgypOCNTq6LPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wy97s438+QbTs9uwgBiKwbYcaZpfz+N+hg2y6CinoiU=;
 b=VYEJTWMajdpv9FjN3Gfe+L4VW0sqfrNmbH0BId5yrLWSOSV8l8QoOz291jqG52crY4BLnB8ewKWb8Kmwojot4pA6u4vpb7qSe8ADPG3kzl/rxuaHcmQS8EPhNXg+CAtAWnnkvLEdz95PhdymX4cGOqWXphCZ5iZ+EW/NxS9OYLb3zexK/5zX7S11imxuw1wZ4ZBGtlWZB+HSEmk4dzkyeuig8lSLbRKrUK8bJ4o1X0neNp9zb3qYf0xHRkaP8nev8V50O6/gpwYjul5gzyt9O8cTIerMa8FGicsAVYRkpY1FS4y22Q9BULdE7kAMj12XgR21Bu7rVqMdCzcttFPD/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wy97s438+QbTs9uwgBiKwbYcaZpfz+N+hg2y6CinoiU=;
 b=boehRoIWB+4BpqGrcpmnUivIXnUWf2FBD4Y3RrhoWFb/w0MkIJ9xyjClFPTOCi5ZH92VnFEZkbsj1U2sPgmS3AHHm60AGvmTe7obkzEfxxAZ99ykZLNkmWD/oJUbQGzJHga8r7A5yA81e0e1jGKjqmWOPP78DQg6+Y68gJRHbfE=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 22 Sep
 2020 16:04:01 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 16:04:01 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/10] crypto: caam/qi - add fallback for XTS with more than 8B IV
Date:   Tue, 22 Sep 2020 19:03:20 +0300
Message-Id: <20200922160328.28926-3-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
References: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0022.eurprd03.prod.outlook.com
 (2603:10a6:205:2::35) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0302CA0022.eurprd03.prod.outlook.com (2603:10a6:205:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Tue, 22 Sep 2020 16:04:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b5a146f2-3e16-4c10-09c0-08d85f111eda
X-MS-TrafficTypeDiagnostic: VI1PR04MB7072:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB70722316C205E30BED75D8B6B43B0@VI1PR04MB7072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zPMlPEYRiRuX+X0Q12hl/H8g/ccLq59OynwydeP/fseQYTmccgi2nYv6SSAfks5zwIW4VG2VvdgFpuwvcS77wJu1DwCHjiKvOzbAjRyD68CzoS9eVT4QMBz27iNC5O4GMi0xxdPRuF/l8mS4vjy0suwZ01vmJhoSjZggNiOwV3mKXQdRSbIEJjoCqNqytNmRrvh53bIAn8Kj0ygXOpCQWIrzxtLXR+vkoGLkiVUK8KQrraAow3+J2GBPboTmQxJ4Ly3ofKrZWcPiefbruxNFJUgzHktMcNsQebuDcMWU+GtIcFl21jqyFiTD6mT6yjn02d0dRLy8mp7BxHBnyLdgogpYgq+hp09V//W8XaWtsPg7LnCfcmlF+/FfRxaCCW85
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(1076003)(4326008)(2616005)(6512007)(83380400001)(186003)(16526019)(2906002)(956004)(5660300002)(66556008)(66476007)(8936002)(316002)(6506007)(44832011)(66946007)(52116002)(6486002)(478600001)(110136005)(8676002)(26005)(86362001)(6666004)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yDLkyYJLzwNlmLNHrjkAZHDPAFpsxVdK9WJaPrl9b59G89Y3dPNJbjRgfB7Vsd30BSjNUoqWup/0x4AUBvB+SCmF+gHLPzuwMXF4hNVBHMMjOOv0Tw4g+PcZIoiNt0OtBCpM2i+YCY4afzsVz5md6BfiEMVQomAmOEHmiTLnb2VTU00jFIOfRL7s9ZrYslCMlGBRyBTOGCGw9UHN57uHH04sQOmQOqpIBmE+eRgJksKYie4f3HMnEQnvKxthNZgUCXUKSjDxfRBW9Pp29/PQN/3IAl/RfGqZMRkA1HD3fTw06sk+kLHA4ZByu3lq97EuNAvmJCmqhsm+jnfMNqY55xBDdco1Rit6HgiuU/5wiE7bYGQ7MDUCbYg+MQfTe3LOs4fHVvxealUtKsBsUJjf44KtQ3Ijxdv4XEr2e4g8JvPdkrSkGdhSKRK7YVfj+TlC1SIUwI1IsSW1U4Z/GIRkvro7p9BeieLS1lhyj9KGmNiYR4b8hk8Gnq/zPlMFd2aBpiUBmwAfnP3ibj3RptFOVeJX0cYT/N7eIaAMyt7qL1TtzsR4oADrP8IcBxhaKfezuFWoRsmtK1kByVHqLrdifE/EN7toF0+k4peGsvkXCk0Ny9nYI+Q8+498MQ9RudQgNf+UMiLxp/bgeTttuMsgqQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a146f2-3e16-4c10-09c0-08d85f111eda
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 16:04:01.2072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7FT12oLOluPZZM+2ClzSk4WINbNQYn+WVJOp1lJPl8oxJ1tG6Ydrk+DRcaavhCjGZasssFDqKo54kJhSC2wmyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

A hardware limitation exists for CAAM until Era 9 which restricts
the accelerator to IVs with only 8 bytes. When CAAM has a lower era
a fallback is necessary to process 16 bytes IV.

Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/Kconfig      |  1 +
 drivers/crypto/caam/caamalg_qi.c | 72 +++++++++++++++++++++++++++++---
 2 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index dfeaad8dfe81..8169e6cd04e6 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -115,6 +115,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI
 	select CRYPTO_AUTHENC
 	select CRYPTO_SKCIPHER
 	select CRYPTO_DES
+	select CRYPTO_XTS
 	help
 	  Selecting this will use CAAM Queue Interface (QI) for sending
 	  & receiving crypto jobs to/from CAAM. This gives better performance
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index bb1c0106a95c..ee801370c879 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -18,6 +18,7 @@
 #include "qi.h"
 #include "jr.h"
 #include "caamalg_desc.h"
+#include <asm/unaligned.h>
 
 /*
  * crypto alg
@@ -67,6 +68,11 @@ struct caam_ctx {
 	struct device *qidev;
 	spinlock_t lock;	/* Protects multiple init of driver context */
 	struct caam_drv_ctx *drv_ctx[NUM_OP];
+	struct crypto_skcipher *fallback;
+};
+
+struct caam_skcipher_req_ctx {
+	struct skcipher_request fallback_req;
 };
 
 static int aead_set_sh_desc(struct crypto_aead *aead)
@@ -726,12 +732,17 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	int ret = 0;
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
@@ -1373,6 +1384,14 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	return edesc;
 }
 
+static inline bool xts_skcipher_ivsize(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
+
+	return !!get_unaligned((u64 *)(req->iv + (ivsize / 2)));
+}
+
 static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 {
 	struct skcipher_edesc *edesc;
@@ -1383,6 +1402,21 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
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
 	if (unlikely(caam_congested))
 		return -EAGAIN;
 
@@ -1507,6 +1541,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam-qi",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -2440,9 +2475,32 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct caam_skcipher_alg *caam_alg =
 		container_of(alg, typeof(*caam_alg), skcipher);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
+	int ret = 0;
+
+	if (alg_aai == OP_ALG_AAI_XTS) {
+		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
+		struct crypto_skcipher *fallback;
 
-	return caam_init_common(crypto_skcipher_ctx(tfm), &caam_alg->caam,
-				false);
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
+	}
+
+	ret = caam_init_common(ctx, &caam_alg->caam, false);
+	if (ret && ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+
+	return ret;
 }
 
 static int caam_aead_init(struct crypto_aead *tfm)
@@ -2468,7 +2526,11 @@ static void caam_exit_common(struct caam_ctx *ctx)
 
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
@@ -2502,8 +2564,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;
-- 
2.17.1

