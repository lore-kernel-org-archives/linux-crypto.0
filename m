Return-Path: <SRS0=vipQ=TG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DF5C04AAC
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 06:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E3CE2082F
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 06:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbfEFGkq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 May 2019 02:40:46 -0400
Received: from [5.180.42.13] ([5.180.42.13]:57928 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbfEFGkp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 May 2019 02:40:45 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hNXHv-0005zN-RM; Mon, 06 May 2019 14:39:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hNXHs-0001r5-Fj; Mon, 06 May 2019 14:39:44 +0800
Date:   Mon, 6 May 2019 14:39:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [v2 PATCH] crypto: caam - fix DKP detection logic
Message-ID: <20190506063944.enwkbljhy42rcaqq@gondor.apana.org.au>
References: <20190503120548.5576-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190503120548.5576-1-horia.geanta@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 03, 2019 at 03:05:48PM +0300, Horia Geantă wrote:
> The detection whether DKP (Derived Key Protocol) is used relies on
> the setkey callback.
> Since "aead_setkey" was replaced in some cases with "des3_aead_setkey"
> (for 3DES weak key checking), the logic has to be updated - otherwise
> the DMA mapping direction is incorrect (leading to faults in case caam
> is behind an IOMMU).
> 
> Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
> 
> This issue was noticed when testing with previously submitted IOMMU support:
> https://patchwork.kernel.org/project/linux-crypto/list/?series=110277&state=*

Thanks for catching this Horia!

My preference would be to encode this logic separately rather than
relying on the setkey test.  How about this patch?

---8<---
The detection for DKP (Derived Key Protocol) relied on the value
of the setkey function.  This was broken by the recent change which
added des3_aead_setkey.

This patch fixes this by introducing a new flag for DKP and setting
that where needed.

Reported-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 3e23d4b2cce2..c0ece44f303b 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -89,6 +89,7 @@ struct caam_alg_entry {
 	int class2_alg_type;
 	bool rfc3686;
 	bool geniv;
+	bool nodkp;
 };
 
 struct caam_aead_alg {
@@ -2052,6 +2053,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.nodkp = true,
 		},
 	},
 	{
@@ -2070,6 +2072,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.nodkp = true,
 		},
 	},
 	/* Galois Counter Mode */
@@ -2089,6 +2092,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.nodkp = true,
 		},
 	},
 	/* single-pass ipsec_esp descriptor */
@@ -3334,6 +3338,7 @@ static struct caam_aead_alg driver_aeads[] = {
 					   OP_ALG_AAI_AEAD,
 			.class2_alg_type = OP_ALG_ALGSEL_POLY1305 |
 					   OP_ALG_AAI_AEAD,
+			.nodkp = true,
 		},
 	},
 	{
@@ -3356,6 +3361,7 @@ static struct caam_aead_alg driver_aeads[] = {
 					   OP_ALG_AAI_AEAD,
 			.class2_alg_type = OP_ALG_ALGSEL_POLY1305 |
 					   OP_ALG_AAI_AEAD,
+			.nodkp = true,
 		},
 	},
 };
@@ -3417,8 +3423,7 @@ static int caam_aead_init(struct crypto_aead *tfm)
 		 container_of(alg, struct caam_aead_alg, aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(tfm);
 
-	return caam_init_common(ctx, &caam_alg->caam,
-				alg->setkey == aead_setkey);
+	return caam_init_common(ctx, &caam_alg->caam, !caam_alg->caam.nodkp);
 }
 
 static void caam_exit_common(struct caam_ctx *ctx)
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 70af211d2d01..d290d6b41825 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -36,6 +36,7 @@ struct caam_alg_entry {
 	int class2_alg_type;
 	bool rfc3686;
 	bool geniv;
+	bool nodkp;
 };
 
 struct caam_aead_alg {
@@ -1523,6 +1524,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.nodkp = true,
 		},
 	},
 	{
@@ -1541,6 +1543,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.nodkp = true,
 		},
 	},
 	/* Galois Counter Mode */
@@ -1560,6 +1563,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.nodkp = true,
 		}
 	},
 	/* single-pass ipsec_esp descriptor */
@@ -2433,8 +2437,7 @@ static int caam_aead_init(struct crypto_aead *tfm)
 						      aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(tfm);
 
-	return caam_init_common(ctx, &caam_alg->caam,
-				alg->setkey == aead_setkey);
+	return caam_init_common(ctx, &caam_alg->caam, !caam_alg->caam.nodkp);
 }
 
 static void caam_exit_common(struct caam_ctx *ctx)
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 33a4df6b81de..2b2980a8a9b9 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -42,6 +42,7 @@ struct caam_alg_entry {
 	int class2_alg_type;
 	bool rfc3686;
 	bool geniv;
+	bool nodkp;
 };
 
 struct caam_aead_alg {
@@ -1480,7 +1481,7 @@ static int caam_cra_init_aead(struct crypto_aead *tfm)
 
 	crypto_aead_set_reqsize(tfm, sizeof(struct caam_request));
 	return caam_cra_init(crypto_aead_ctx(tfm), &caam_alg->caam,
-			     alg->setkey == aead_setkey);
+			     !caam_alg->caam.nodkp);
 }
 
 static void caam_exit_common(struct caam_ctx *ctx)
@@ -1641,6 +1642,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.nodkp = true,
 		},
 	},
 	{
@@ -1659,6 +1661,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.nodkp = true,
 		},
 	},
 	/* Galois Counter Mode */
@@ -1678,6 +1681,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.nodkp = true,
 		}
 	},
 	/* single-pass ipsec_esp descriptor */
@@ -2755,6 +2759,7 @@ static struct caam_aead_alg driver_aeads[] = {
 					   OP_ALG_AAI_AEAD,
 			.class2_alg_type = OP_ALG_ALGSEL_POLY1305 |
 					   OP_ALG_AAI_AEAD,
+			.nodkp = true,
 		},
 	},
 	{
@@ -2777,6 +2782,7 @@ static struct caam_aead_alg driver_aeads[] = {
 					   OP_ALG_AAI_AEAD,
 			.class2_alg_type = OP_ALG_ALGSEL_POLY1305 |
 					   OP_ALG_AAI_AEAD,
+			.nodkp = true,
 		},
 	},
 	{
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
