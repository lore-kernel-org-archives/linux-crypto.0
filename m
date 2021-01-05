Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D393CC433E9
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E3922CBE
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbhAEQuN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 11:50:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728637AbhAEQuN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 11:50:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E0B522D03;
        Tue,  5 Jan 2021 16:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609865343;
        bh=8FMH1cS81rBaYvbi5av1Um004QKITsAeeOkQmbr8LJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUqWKKJH1KrYftWbSVinPDPx6lWoVYIGmWiVIBWBNZ9maB5f31IDEro8/emJoZyry
         3V8oplcglsX5mrHsdEmvow4rQSOFPKKAX/hWZvTbQcPoqr8sghx3VM0Mz4FGcblK1L
         U/tfRn8cPMiWKelbblxjUEX9jfoGKKM5qPNFFIhSP+WK7XQvYGjTWdqju5mH9o8Zc1
         Wi18AmHqUklYN+z9/yfae3F6H2CGa9q+0F6IxGo+LevoF1zXW5I8QXzBdcQ/aqTQOJ
         aaJC8NcySoox1DsySVAQcFVhhvCOEIQVTGxzOoEeTURyLYd1NrkGYS90HQGKCBYpNg
         t+lgxkQPbLORQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 08/21] crypto: x86/cast5 - drop CTR mode implementation
Date:   Tue,  5 Jan 2021 17:47:56 +0100
Message-Id: <20210105164809.8594-9-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105164809.8594-1-ardb@kernel.org>
References: <20210105164809.8594-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CAST5 in CTR mode is never used by the kernel directly, and is highly
unlikely to be relied upon by dm-crypt or algif_skcipher. So let's drop
the accelerated CTR mode implementation, and instead, rely on the CTR
template and the bare cipher.

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/cast5_avx_glue.c | 103 --------------------
 crypto/Kconfig                   |   1 +
 2 files changed, 1 insertion(+), 103 deletions(-)

diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
index 384ccb00f9e1..e0d1c7903b29 100644
--- a/arch/x86/crypto/cast5_avx_glue.c
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -23,8 +23,6 @@ asmlinkage void cast5_ecb_dec_16way(struct cast5_ctx *ctx, u8 *dst,
 				    const u8 *src);
 asmlinkage void cast5_cbc_dec_16way(struct cast5_ctx *ctx, u8 *dst,
 				    const u8 *src);
-asmlinkage void cast5_ctr_16way(struct cast5_ctx *ctx, u8 *dst, const u8 *src,
-				__be64 *iv);
 
 static int cast5_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
 				 unsigned int keylen)
@@ -214,92 +212,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static void ctr_crypt_final(struct skcipher_walk *walk, struct cast5_ctx *ctx)
-{
-	u8 *ctrblk = walk->iv;
-	u8 keystream[CAST5_BLOCK_SIZE];
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-
-	__cast5_encrypt(ctx, keystream, ctrblk);
-	crypto_xor_cpy(dst, keystream, src, nbytes);
-
-	crypto_inc(ctrblk, CAST5_BLOCK_SIZE);
-}
-
-static unsigned int __ctr_crypt(struct skcipher_walk *walk,
-				struct cast5_ctx *ctx)
-{
-	const unsigned int bsize = CAST5_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u64 *src = (u64 *)walk->src.virt.addr;
-	u64 *dst = (u64 *)walk->dst.virt.addr;
-
-	/* Process multi-block batch */
-	if (nbytes >= bsize * CAST5_PARALLEL_BLOCKS) {
-		do {
-			cast5_ctr_16way(ctx, (u8 *)dst, (u8 *)src,
-					(__be64 *)walk->iv);
-
-			src += CAST5_PARALLEL_BLOCKS;
-			dst += CAST5_PARALLEL_BLOCKS;
-			nbytes -= bsize * CAST5_PARALLEL_BLOCKS;
-		} while (nbytes >= bsize * CAST5_PARALLEL_BLOCKS);
-
-		if (nbytes < bsize)
-			goto done;
-	}
-
-	/* Handle leftovers */
-	do {
-		u64 ctrblk;
-
-		if (dst != src)
-			*dst = *src;
-
-		ctrblk = *(u64 *)walk->iv;
-		be64_add_cpu((__be64 *)walk->iv, 1);
-
-		__cast5_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
-		*dst ^= ctrblk;
-
-		src += 1;
-		dst += 1;
-		nbytes -= bsize;
-	} while (nbytes >= bsize);
-
-done:
-	return nbytes;
-}
-
-static int ctr_crypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct cast5_ctx *ctx = crypto_skcipher_ctx(tfm);
-	bool fpu_enabled = false;
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes) >= CAST5_BLOCK_SIZE) {
-		fpu_enabled = cast5_fpu_begin(fpu_enabled, &walk, nbytes);
-		nbytes = __ctr_crypt(&walk, ctx);
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	cast5_fpu_end(fpu_enabled);
-
-	if (walk.nbytes) {
-		ctr_crypt_final(&walk, ctx);
-		err = skcipher_walk_done(&walk, 0);
-	}
-
-	return err;
-}
-
 static struct skcipher_alg cast5_algs[] = {
 	{
 		.base.cra_name		= "__ecb(cast5)",
@@ -328,21 +240,6 @@ static struct skcipher_alg cast5_algs[] = {
 		.setkey			= cast5_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "__ctr(cast5)",
-		.base.cra_driver_name	= "__ctr-cast5-avx",
-		.base.cra_priority	= 200,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct cast5_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= CAST5_MIN_KEY_SIZE,
-		.max_keysize		= CAST5_MAX_KEY_SIZE,
-		.ivsize			= CAST5_BLOCK_SIZE,
-		.chunksize		= CAST5_BLOCK_SIZE,
-		.setkey			= cast5_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	}
 };
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index dd48c3bab3f5..fed73fff5a65 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1372,6 +1372,7 @@ config CRYPTO_CAST5_AVX_X86_64
 	select CRYPTO_CAST5
 	select CRYPTO_CAST_COMMON
 	select CRYPTO_SIMD
+	imply CRYPTO_CTR
 	help
 	  The CAST5 encryption algorithm (synonymous with CAST-128) is
 	  described in RFC2144.
-- 
2.17.1

