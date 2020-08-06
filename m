Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC58C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F732311B
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="EZ1tU9v+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgHFQjI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:39:08 -0400
Received: from mail-eopbgr20066.outbound.protection.outlook.com ([40.107.2.66]:11170
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbgHFQhB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:37:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdQXJkqZV3aC95HSrMF7CWRNmm9yFa1V/5YSY4Lkf8AzpMaDyXQcXB+/nkfphKK6ZOHSKmPjIRSO7g+PQRLiBudKCCx/ga+Ui+ieRoSBaLltJL3qX4BnZ8YzU/+YpjA+TcmfEjvOQcCyCrKpfr3z+mTBQIbRY7yqPahZaqNbG/0l2tRqbnUMlHMa1+wpTCTgEP0X46xTarNEYduETOSyof4XJ83HwYkfPKxVjTe50Ea3e6bthiMKHBjbVA2m4p5Vk1sXsHWL+qtF6b9xC5f459ny5zD/e6dcfqjH1/KGSGWvpys0k3K7tZ/8yoy4Tg27ydWZ8EbxRkV5I5Fcc2tzag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDRzb6gtsB5DKKZ1Z/MpbHsUH5Rk8IEXaG8qesk44IQ=;
 b=CJkI7tDzsTXBdTdrUCoOqLs+GmnfGYzVRcpeES3Bbq/zWygD/yNv/M14MHGC55uAZDYu4JM7ZBcaWtkN35RoZqQWOkhqniFvM1YfSFaN5e6oX8un8ce3YeT6IcINdOxYDSW/BLRj/E4A1Hd/yD4f5ujFJTEif2QXrbsarlQ3ocIvvmebgvdcxr/9PFIM2ZG3QaUbUnR3dyQ/O7M2jvZeQCRnzvxpo3UW2nl/ll9XEs7LvQL23Dz6atUoo1nkldwxCY86qQM8UY+bB7bb8mSPMFCHhA8T2owO+RUDwb5HfukPqiF270j0id3E2rMpnoPOK+fWj2OuweWdvl6tLElikw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDRzb6gtsB5DKKZ1Z/MpbHsUH5Rk8IEXaG8qesk44IQ=;
 b=EZ1tU9v+GSDXEPhn8CjndWeWnQUhp7dUyu2NnAdUT38NoUDhFXjrmAK98jA/ww9DGa41fEvzl9tOBf3hKAtIH+X15c3Ux/K2+BLzVbwBA3uB27MAELRz3lUIkBrX8IHDOIxDOzxEWnIOE9Owl/LRxg66xAQNvEz6iRno2gtSguw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB4992.eurprd04.prod.outlook.com (2603:10a6:803:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 6 Aug
 2020 16:36:12 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 16:36:12 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 2/9] crypto: caam/qi - add fallback for XTS with more than 8B IV
Date:   Thu,  6 Aug 2020 19:35:44 +0300
Message-Id: <20200806163551.14395-3-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Thu, 6 Aug 2020 16:36:11 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 02b2b428-e56b-451d-b569-08d83a26d49d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4992:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4992F891A93C2A04ED884207B4480@VI1PR04MB4992.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WEAdijcsUtzWHBC5C2ooah05TMXOsaWuIZF6vo7gyyLpbX2fo7g8fAlWQjep/bSDELl4zfOQAl0KUvMRK3A/FmQEwFs63lB/CPvjzg2wUXHudKlWgt93SmGS4POVvaDrDQBJm/0T6YfRhTJPUYJ3LVrXMpF6pCY0XW0bpGewfdBaZ62MUnF3JpfuY3QT9fiAx9UYPwdrcS/kohIjrPsw9Qvx9za1o3kMIsY7K7GYBbxSND0jpPLvTH+lyi51f+BZolDiYSzQ8WaLX6j6jtQrD++yYXlx7Prz9Af7l/BGImsm57AswMYcZzZeyu+3QGctSqMtFzNTg/NvtIQmn2hvIMJ/DXQJhUZgzN4NVoBYZJbPaPE7a8Y+/fdI9pAVkC2O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(66476007)(86362001)(26005)(6512007)(16526019)(186003)(66556008)(66946007)(1076003)(110136005)(8936002)(316002)(8676002)(478600001)(2906002)(6506007)(4326008)(44832011)(2616005)(956004)(83380400001)(6486002)(6666004)(52116002)(5660300002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZVtY05+0CaDuiwhYQ77+kgfGsgr0122qzlcNLSmKk66HMn0nAGg4tZDUDrGpepQEdZscT8iffwlhGWiXNQPWGEef9c7NtCZ+wsRaxOJjjg6vPGwwnuWSfeeptgsW22KQkZY7tJOqYQ9s7BmspU3Oqt5kPqfFQeVQkUaUiOCu4940DXEmLYBf9e28wJYL4fNwS8761Xpng0rdueyxvLJ7mDxZGM0eh8svmd7TKF0P6N4nS+tTLtFegCjgmCak0pVHLWail8etIUOYeEflvb/gY8CHEJjpR4bpgEj39/EkLPZkh781wiKGN2KO27Mc+zinBa0PHKfkdq5TX4v8KlyVQq9w4E0FoODSeOh+nFRoSNEVgub2HJ+F+PJv1vow2UpM/sNtA23htFaNWHQeiQrMCrvedRUCqXo9dwBS2YipFQDB3Bjwasn/Q2dnIvsMicfUcZQ5mJ2GVMuJIk26b0dFM8TvBQ2UV67SqEmJYPmDjQjbv7TN4FzYPefRMH4o2sGGZ46KqliVN8oMle4oT07i9bLtj1CU5VSX9yYhY3z/cj8gHfY41Lo67wXrufH/0+N7hxe0fjPPQP8gEe16u++NqxuI7nt0YX9SsIyT05mjkV74XJa5HMZ9bvj4cBC3hEhpjVguQH/nsvvAEUwnZMTDBg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b2b428-e56b-451d-b569-08d83a26d49d
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 16:36:12.5067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +nDKoCJcK4NeRcI4pSUR4DJ0RGkvfQXNGaJdFoJzI/Dz6egEsIccTiJWmKcEjiPxtoidrBthqJCp5Nr8Yw4gQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4992
Sender: linux-crypto-owner@vger.kernel.org
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
 drivers/crypto/caam/caamalg_qi.c | 73 +++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index bb1c0106a95c..05cb50561381 100644
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
@@ -1373,6 +1384,20 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	return edesc;
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
@@ -1383,6 +1408,21 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
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
 	if (unlikely(caam_congested))
 		return -EAGAIN;
 
@@ -1507,6 +1547,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam-qi",
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
 			.setkey = xts_skcipher_setkey,
@@ -2440,9 +2481,27 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct caam_skcipher_alg *caam_alg =
 		container_of(alg, typeof(*caam_alg), skcipher);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
+	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
+
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
+		crypto_skcipher_set_reqsize(tfm, sizeof(struct skcipher_request) +
+					    crypto_skcipher_reqsize(fallback));
+	}
 
-	return caam_init_common(crypto_skcipher_ctx(tfm), &caam_alg->caam,
-				false);
+	return caam_init_common(ctx, &caam_alg->caam, false);
 }
 
 static int caam_aead_init(struct crypto_aead *tfm)
@@ -2468,7 +2527,11 @@ static void caam_exit_common(struct caam_ctx *ctx)
 
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
@@ -2502,8 +2565,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
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

