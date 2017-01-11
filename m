From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 3/7] crypto: arm64/aes-blk - expose AES-CTR as synchronous cipher as well
Date: Wed, 11 Jan 2017 16:41:51 +0000
Message-ID: <1484152915-26517-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1484152915-26517-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38605 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762168AbdAKQmK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Jan 2017 11:42:10 -0500
Received: by mail-wm0-f44.google.com with SMTP id r144so34214762wme.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jan 2017 08:42:09 -0800 (PST)
In-Reply-To: <1484152915-26517-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In addition to wrapping the AES-CTR cipher into the async SIMD wrapper,
which exposes it as an async skcipher that defers processing to process
context, expose our AES-CTR implementation directly as a synchronous cipher
as well, but with a lower priority.

This makes the AES-CTR transform usable in places where synchronous
transforms are required, such as the MAC802.11 encryption code, which
executes in sotfirq context, where SIMD processing is allowed on arm64.
Users of the async transform will keep the existing behavior.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c | 25 ++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 4e3f8adb1793..5164aaf82c6a 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -327,6 +327,23 @@ static struct skcipher_alg aes_algs[] = { {
 	.decrypt	= ctr_encrypt,
 }, {
 	.base = {
+		.cra_name		= "ctr(aes)",
+		.cra_driver_name	= "ctr-aes-" MODE,
+		.cra_priority		= PRIO - 1,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+		.cra_alignmask		= 7,
+		.cra_module		= THIS_MODULE,
+	},
+	.min_keysize	= AES_MIN_KEY_SIZE,
+	.max_keysize	= AES_MAX_KEY_SIZE,
+	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
+	.setkey		= skcipher_aes_setkey,
+	.encrypt	= ctr_encrypt,
+	.decrypt	= ctr_encrypt,
+}, {
+	.base = {
 		.cra_name		= "__xts(aes)",
 		.cra_driver_name	= "__xts-aes-" MODE,
 		.cra_priority		= PRIO,
@@ -350,8 +367,9 @@ static void aes_exit(void)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(aes_simd_algs) && aes_simd_algs[i]; i++)
-		simd_skcipher_free(aes_simd_algs[i]);
+	for (i = 0; i < ARRAY_SIZE(aes_simd_algs); i++)
+		if (aes_simd_algs[i])
+			simd_skcipher_free(aes_simd_algs[i]);
 
 	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
@@ -370,6 +388,9 @@ static int __init aes_init(void)
 		return err;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
+		if (!(aes_algs[i].base.cra_flags & CRYPTO_ALG_INTERNAL))
+			continue;
+
 		algname = aes_algs[i].base.cra_name + 2;
 		drvname = aes_algs[i].base.cra_driver_name + 2;
 		basename = aes_algs[i].base.cra_driver_name;
-- 
2.7.4
