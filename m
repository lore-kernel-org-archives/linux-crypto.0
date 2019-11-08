Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10A4FA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99150222C6
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215796;
	bh=e5RENLWDRI1PmhtIZ58pJR4idFmiKspyVH7WGbl6U/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Uzll+GESlKcdjV1oWJgMxjTH00WlvpBmuTeYlwvA9lCnPCTvjn+CI/WazXNIrC9of
	 MajjXGImwtOT8QEnNCVvAH9bsfyYtH6u4Wfmnh+fAv4b4aCtO2C3SO0C0XMuLfak8Y
	 wcswlks3IGPBy81qtAmYoh4bFWLXZOU4sQjRuFMA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732254AbfKHMXQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfKHMXP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:15 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A064D222C4;
        Fri,  8 Nov 2019 12:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215795;
        bh=e5RENLWDRI1PmhtIZ58pJR4idFmiKspyVH7WGbl6U/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAN8wQa/7FsiyOCCDcm9tSp+MNk0dni2usA6zQFsO+Y/itsSMsZU1GiOKyL9DiKmT
         rcm5HFgaj7O6ccvv12TVMuoPEnYJWd0svEIoqsi5PZvUxH2rsvCE0OsFLoSHCdBIvh
         RddjrUNWKwSgrqzhSTqa0GofikDmEBgzaA49Zmk8=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 05/34] crypto: arm64/chacha - depend on generic chacha library instead of crypto driver
Date:   Fri,  8 Nov 2019 13:22:11 +0100
Message-Id: <20191108122240.28479-6-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Depend on the generic ChaCha library routines instead of pulling in the
generic ChaCha skcipher driver, which is more than we need, and makes
managing the dependencies between the generic library, generic driver,
accelerated library and driver more complicated.

While at it, drop the logic to prefer the scalar code on short inputs.
Turning the NEON on and off is cheap these days, and one major use case
for ChaCha20 is ChaCha20-Poly1305, which is guaranteed to hit the scalar
path upon every invocation  (when doing the Poly1305 nonce generation)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/Kconfig            |  2 +-
 arch/arm64/crypto/chacha-neon-glue.c | 40 +++++++++++---------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 286e3514d34c..22c6642ae464 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -103,7 +103,7 @@ config CRYPTO_CHACHA20_NEON
 	tristate "ChaCha20, XChaCha20, and XChaCha12 stream ciphers using NEON instructions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
-	select CRYPTO_CHACHA20
+	select CRYPTO_LIB_CHACHA_GENERIC
 
 config CRYPTO_NHPOLY1305_NEON
 	tristate "NHPoly1305 hash function using NEON instructions (for Adiantum)"
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index d4cc61bfe79d..cae2cb92eca8 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -68,7 +68,7 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	crypto_chacha_init(state, ctx, iv);
+	chacha_init_generic(state, ctx->key, iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
@@ -76,10 +76,16 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = rounddown(nbytes, walk.stride);
 
-		kernel_neon_begin();
-		chacha_doneon(state, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes, ctx->nrounds);
-		kernel_neon_end();
+		if (!crypto_simd_usable()) {
+			chacha_crypt_generic(state, walk.dst.virt.addr,
+					     walk.src.virt.addr, nbytes,
+					     ctx->nrounds);
+		} else {
+			kernel_neon_begin();
+			chacha_doneon(state, walk.dst.virt.addr,
+				      walk.src.virt.addr, nbytes, ctx->nrounds);
+			kernel_neon_end();
+		}
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
@@ -91,9 +97,6 @@ static int chacha_neon(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
-		return crypto_chacha_crypt(req);
-
 	return chacha_neon_stream_xor(req, ctx, req->iv);
 }
 
@@ -105,14 +108,15 @@ static int xchacha_neon(struct skcipher_request *req)
 	u32 state[16];
 	u8 real_iv[16];
 
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
-		return crypto_xchacha_crypt(req);
+	chacha_init_generic(state, ctx->key, req->iv);
 
-	crypto_chacha_init(state, ctx, req->iv);
-
-	kernel_neon_begin();
-	hchacha_block_neon(state, subctx.key, ctx->nrounds);
-	kernel_neon_end();
+	if (crypto_simd_usable()) {
+		kernel_neon_begin();
+		hchacha_block_neon(state, subctx.key, ctx->nrounds);
+		kernel_neon_end();
+	} else {
+		hchacha_block_generic(state, subctx.key, ctx->nrounds);
+	}
 	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
@@ -134,7 +138,7 @@ static struct skcipher_alg algs[] = {
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 5 * CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= chacha_neon,
 		.decrypt		= chacha_neon,
 	}, {
@@ -150,7 +154,7 @@ static struct skcipher_alg algs[] = {
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 5 * CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= xchacha_neon,
 		.decrypt		= xchacha_neon,
 	}, {
@@ -166,7 +170,7 @@ static struct skcipher_alg algs[] = {
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 5 * CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha12_setkey,
+		.setkey			= chacha12_setkey,
 		.encrypt		= xchacha_neon,
 		.decrypt		= xchacha_neon,
 	}
-- 
2.20.1

