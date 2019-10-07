Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8A4ECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A96952133F
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JOJX2qCX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbfJGQq1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52976 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbfJGQq1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id r19so218856wmh.2
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/xYmnzDkc9yQ0OtCwCnJ3CTcS5Xt6sT/idWBbaIdRPk=;
        b=JOJX2qCXfKKeWvdVooGf6Pv4NIb59sUmNDOxdyUlLTAt0N8IL07uvSQ5ZQT5sHx8iG
         5580j7sxP/DExSIbnCRj7FexlKlBb60NCvTdtwqXIxH84ZTg6HPQCg1/tXc0NKdQfxUd
         ho+PZAc2QdEcbSTckAXUghSz728ejFODUgZ5BgMA/tDZlLpQQvqMq9LOGtQpty/3uB0y
         g6F6hTMIDltUxYmQt4Qf/nH/hQbNW9ORTRVFgWyPndqFyZLAbFELW81NCdf9SNgApbfD
         EeaJAqnVzkaK2BAhPmkNd3sIuXyN+Q6YH7oFicAUCBpKUb2OqoRICstHwL+zkx/FUT8v
         2L8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/xYmnzDkc9yQ0OtCwCnJ3CTcS5Xt6sT/idWBbaIdRPk=;
        b=lFdWPg55Q+fPYtU9dDmDTstkFoZw8kwYYk3UIXJW9uBlyQ5c6plmRIM6EzQys9eAyM
         IjYJcHRLvlBbRfapWFusLU6gqXqMC26QpN2gZgJ8zPc4gCyuwvuxWyoXHG0o5Jj4IzOh
         VVcIYgOOBwjbTY4hmB7Jhr4GlL/2HSISeYvEadsIzZcGmdUTEg3dqKb+Qsp8zFAkoRZT
         ewdEb7nfS3vlw/b0kwiHiZA/j28aLe26KPCGcw+DKfSmDbHFdJmhh79yH4ZL9Y132nTX
         gXIN/sFyflrLhxAqN39U+/c/4CnAaB0CkISSccTk6VPKIjHW0k4Ind4sorEHAY0w+bHp
         0pbg==
X-Gm-Message-State: APjAAAVIanhhFI7+okJLjZBUQDGts2cLguPof3UD4pxpxaTy3wEZC/PO
        CE7JVzZUuZTWXRFwzrAw0BLYxnIdNwOoPA==
X-Google-Smtp-Source: APXvYqxxbUc6W/LRzfhn8cGNZTSsP3SG7UaUNdgGJuVtqY1UgNCYtvUge5MiYOTQDQUN4/VculM2gA==
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr190520wma.16.1570466784595;
        Mon, 07 Oct 2019 09:46:24 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:23 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH v3 04/29] crypto: arm64/chacha - depend on generic chacha library instead of crypto driver
Date:   Mon,  7 Oct 2019 18:45:45 +0200
Message-Id: <20191007164610.6881-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig            |  2 +-
 arch/arm64/crypto/chacha-neon-glue.c | 54 +++++++++++++-------
 2 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 4922c4451e7c..fdf52d5f18f9 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -103,7 +103,7 @@ config CRYPTO_CHACHA20_NEON
 	tristate "ChaCha20, XChaCha20, and XChaCha12 stream ciphers using NEON instructions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_CHACHA20
+	select CRYPTO_LIB_CHACHA_GENERIC
 
 config CRYPTO_NHPOLY1305_NEON
 	tristate "NHPoly1305 hash function using NEON instructions (for Adiantum)"
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index d4cc61bfe79d..6450bb9f55f4 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -64,22 +64,30 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
 {
 	struct skcipher_walk walk;
 	u32 state[16];
+	bool do_neon;
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	crypto_chacha_init(state, ctx, iv);
+	chacha_init_generic(state, ctx->key, iv);
 
+	do_neon = (req->cryptlen > CHACHA_BLOCK_SIZE) && crypto_simd_usable();
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
 			nbytes = rounddown(nbytes, walk.stride);
 
-		kernel_neon_begin();
-		chacha_doneon(state, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes, ctx->nrounds);
-		kernel_neon_end();
+		if (!do_neon) {
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
 
@@ -91,9 +99,6 @@ static int chacha_neon(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
-		return crypto_chacha_crypt(req);
-
 	return chacha_neon_stream_xor(req, ctx, req->iv);
 }
 
@@ -105,14 +110,15 @@ static int xchacha_neon(struct skcipher_request *req)
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
+	if (req->cryptlen > CHACHA_BLOCK_SIZE && crypto_simd_usable()) {
+		kernel_neon_begin();
+		hchacha_block_neon(state, subctx.key, ctx->nrounds);
+		kernel_neon_end();
+	} else {
+		hchacha_block_generic(state, subctx.key, ctx->nrounds);
+	}
 	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
@@ -120,6 +126,18 @@ static int xchacha_neon(struct skcipher_request *req)
 	return chacha_neon_stream_xor(req, &subctx, real_iv);
 }
 
+static int chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+		    unsigned int keysize)
+{
+	return chacha_setkey(tfm, key, keysize, 20);
+}
+
+static int chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
+		    unsigned int keysize)
+{
+	return chacha_setkey(tfm, key, keysize, 12);
+}
+
 static struct skcipher_alg algs[] = {
 	{
 		.base.cra_name		= "chacha20",
@@ -134,7 +152,7 @@ static struct skcipher_alg algs[] = {
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 5 * CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= chacha_neon,
 		.decrypt		= chacha_neon,
 	}, {
@@ -150,7 +168,7 @@ static struct skcipher_alg algs[] = {
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 5 * CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= xchacha_neon,
 		.decrypt		= xchacha_neon,
 	}, {
@@ -166,7 +184,7 @@ static struct skcipher_alg algs[] = {
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

