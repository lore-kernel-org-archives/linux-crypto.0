Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1913DC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 14:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A3972312B
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 14:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="UW2ZXsQZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgHFOYI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 10:24:08 -0400
Received: from mail-eopbgr00067.outbound.protection.outlook.com ([40.107.0.67]:20322
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726375AbgHFOUT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 10:20:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVRFihfmwv6puV6exPglWlB1H4ZIL1nriK+7hBArKvMVgNTauq0DURuBP2ZrwTpmlPQKEmlAQ/CjA4bAG2cR8SHrgHxSEhCulRXElrEk+lNTLy4cn0QaueapYWbjMWUww1pHzG8mtLmjmEmACM41nnlwMIs7ieDxXN6TML60ti17NemWU6eZGyz1xzPuUqplR30+hl6kKbQeVfIXBzkoF9FZewx4PNsmzlzQvcJL7v1KwOo5v/rg2+NsHcAZcdK7DuUYOgEOHZAowdpTZA+Eb5ezWZuPzSIfjHlylR+4OQdeHzPXWuZFM5qxZXrx0WjYw4E6YrpUsSmQ3onJv3EjNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDRzb6gtsB5DKKZ1Z/MpbHsUH5Rk8IEXaG8qesk44IQ=;
 b=WrsIYrQRyfw96MG4fKMWqMAYP8vPmW87zkXtsJ0t0a8Adlb+JM07jW3A5Z3+MmuZ8R1fpqQMZ5dy1oBa+yP32Bhpk81PweBIvUBqQEWAnuCnHPW0P3A7KR9dbPpCAW1fOotdLHoyiQUspfHCNzcCN2VUeA+ziqd6YDQXOaJjoMKMXuUEa3JRx3PahJfbpSXC1/S52lIh5XGgWPjsd8B5XeBzMpd6SI65nkyc0qZ1KWSw7Qe9/com/uPQlzXp9J/t3jgF2UyZLyKMxy5Cn7cIAVuWHfFgyW/qOsEjxvCYtHQN1WdomD2vXArV4WYev0Jt5Sfjd9wz0BwzVA3+H5GM3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDRzb6gtsB5DKKZ1Z/MpbHsUH5Rk8IEXaG8qesk44IQ=;
 b=UW2ZXsQZ5cBaa6xK8Pul5vKMckadpnF66xEpczNbBPP5UFXT4gZPl1FgPMIn4TY+X723PweHVF2bYt8HNI4VIgIByge+pzWHYtQX0UVLfI9YgVQDmw0iC7v2IxL/IFJUQjJvkOfy9gGJ3BpECmQ15ANJ98IUklJAEiJO8pjk7Hs=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3440.eurprd04.prod.outlook.com (2603:10a6:803:6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 11:41:51 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:41:51 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] crypto: caam/qi - add fallback for XTS with more than 8B IV
Date:   Thu,  6 Aug 2020 14:41:20 +0300
Message-Id: <20200806114127.8650-3-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 11:41:50 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b5a8478-f459-41e3-8fd7-08d839fdb5f5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3440:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB344047E791DC532BF8FA7262B4480@VI1PR0402MB3440.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1PpB3H/I+wBXdrlK4nUH2BPBE48/43QXld4nkzZ2crb9+iDugMOwvcpuiLrGHmuyzhKSvqxABGTfz5nmbWjLo8/WLylkVpPnGucHreoPGWszzR3J8ca0V8Pm8paL1ucSDmfZPiW+3dRrSPhSMDZReTx3JekLXHXHdyi768M0c3h6riecaB931beEwOe/EZk+lM7fqW/0CMAb+gvmZB2AZoD4h18kN4wAUvC/LtYLON0LkCnKRtBP0/DhiY6P1OiTnYas19LpShicZCZQJQunhRaDPJoAjKHf4Tf+hF1k8uttiRHQciF2AKPGVx2yGQshlR4rPr8ukdUbAGNZzFHC/KYyg7IOecp0HDD8rS6LZatb7UAmV/Xg8WDB2AMzGjqK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(110136005)(316002)(6666004)(6512007)(478600001)(956004)(2616005)(6486002)(4326008)(1076003)(44832011)(52116002)(6506007)(86362001)(186003)(26005)(16526019)(66556008)(66476007)(2906002)(66946007)(83380400001)(8676002)(5660300002)(8936002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qsTLQOXAvg7TD6gzjUZFI6qD9df5PckzgaUT5sarNHT+KOupB9wucm+s0sqU3MCEimK84c3dyAqHiZmkDzIYYr6LPChjB2oukgARE8ZW0VfwcMt7UBr5bpMMqkjlnp4MrCHHE7OJBrFkh+KHgujuH5mYdALe8SWjBlDdFZKfCy3qae2f0XZGX95pr8Z/apRcegbivtf/u2uorFOgKbSgEaGvaaFbSqkyU1gnjy0+PTHe26Qp4uX5shmmPMbOgNF9wJCPeNtYGBvO36DP+yEo5Lu9TqMIb3WDXWd2qAJSzu5/9VGn3Fs8T41wnuCuS5L9py9SmfmSXGhZgHUDdxd5CmMGqrhb4BRYxaX317J+9nyaq4v65IVaST64yIlHbtz/NHtOtjtSf6VLuF+j6jHCs4rumD/iJBJM0ZHgd7yBzGzll3UdsbXHzut6OelJuCJ4+roA66rwf9TSWFpFTh11upv9H/ZCGMefrwZyXeIvzC0B+WOjkUIoWMsUxaDDu1M22CEi4qs288eTHXUo4+kVBm9kkNXlpp0aGbrTnxon02AmL8Bfoyw8dncLXzwKdN3jptUZe7R5EkLwPfR8LFj3THmkyCYO8k5KCI/6hxjfUkD3ViaWujHnSEPBI49VxWugOEPH1NeITraFWxpq3sdmzA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5a8478-f459-41e3-8fd7-08d839fdb5f5
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 11:41:51.6422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D1fcihcdq98AgG2p81ebMK8n97TckmDy8FA0pQyrxItz3Z4xEcJaituTi8qoXt9N2tmxDOzcwtLRDZUI/LCm7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3440
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

