Return-Path: <SRS0=zC9F=ED=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772A2C388F7
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Oct 2020 21:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281022475A
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Oct 2020 21:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgJ1V7c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:59:32 -0400
Received: from inva020.nxp.com ([92.121.34.13]:39076 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbgJ1V7b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Oct 2020 17:59:31 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B32D61A14E2;
        Wed, 28 Oct 2020 10:03:44 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A55851A14F4;
        Wed, 28 Oct 2020 10:03:44 +0100 (CET)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4D4C92030E;
        Wed, 28 Oct 2020 10:03:44 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Russell King <linux@armlinux.org.uk>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: arm/aes-neonbs - fix usage of cbc(aes) fallback
Date:   Wed, 28 Oct 2020 11:03:20 +0200
Message-Id: <20201028090320.4222-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Loading the module deadlocks since:
-local cbc(aes) implementation needs a fallback and
-crypto API tries to find one but the request_module() resolves back to
the same module

Fix this by changing the module alias for cbc(aes) and
using the NEED_FALLBACK flag when requesting for a fallback algorithm.

Fixes: 00b99ad2bac2 ("crypto: arm/aes-neonbs - Use generic cbc encryption path")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 arch/arm/crypto/aes-neonbs-glue.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index bda8bf17631e..f70af1d0514b 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -19,7 +19,7 @@ MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
 MODULE_ALIAS_CRYPTO("ecb(aes)");
-MODULE_ALIAS_CRYPTO("cbc(aes)");
+MODULE_ALIAS_CRYPTO("cbc(aes)-all");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
 MODULE_ALIAS_CRYPTO("xts(aes)");
 
@@ -191,7 +191,8 @@ static int cbc_init(struct crypto_skcipher *tfm)
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	unsigned int reqsize;
 
-	ctx->enc_tfm = crypto_alloc_skcipher("cbc(aes)", 0, CRYPTO_ALG_ASYNC);
+	ctx->enc_tfm = crypto_alloc_skcipher("cbc(aes)", 0, CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->enc_tfm))
 		return PTR_ERR(ctx->enc_tfm);
 
@@ -441,7 +442,8 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct aesbs_cbc_ctx),
 	.base.cra_module	= THIS_MODULE,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_flags		= CRYPTO_ALG_INTERNAL |
+				  CRYPTO_ALG_NEED_FALLBACK,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
 	.max_keysize		= AES_MAX_KEY_SIZE,
-- 
2.17.1

