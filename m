Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 512B4ECE58D
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1732C21925
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="chfNPiGS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503383AbfJQTKB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40057 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503380AbfJQTKB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id o28so3588222wro.7
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kBsvQ4QE4Tnb09O5m1TxxnPOhiOJnQBAzVS2bI762N8=;
        b=chfNPiGSpFIFngzzxfqL5HYNZYyAXpElwT4LOCTOLWacWmbxGdJL+ZGwYbDE6zBc8x
         bYtFXBlc3ejYxRuXEfGI68EKpoO5+8NTgmg4lCQKWKVJDmn6QwM6gvlnLel+Tf4DrSG6
         lLBMYcYwsgHwUBOvHGJCdHOMohBHGWXH0dVRKhbFlVAEfyLpLVRJR8XBR0LUEJtVO6uO
         RN144Bsgg7OoYuYS49zJz+0EXIDy5PZ7vRBQvDQFkwmyssvNYTW5+z4z9GnlqtAP+Hdd
         KBhpt+trhPPiD6oUW4mUPEiQgON57Euj+Ot3Wopbr0HJBNoAumlk0Gz5U/0rKIysxl7V
         K5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kBsvQ4QE4Tnb09O5m1TxxnPOhiOJnQBAzVS2bI762N8=;
        b=AuKRzevS0H4I6wgBcSsgR53tThoPoNJGcKwonw8ug/skn5O8sCZRs/OfnfevnWuctD
         ceHf6MGa0/4Tq5kGFpARhjUuwEk3/85/lznbqk6AnL1cvelto9WJMCN7sTbUNKJYsjCB
         qI2FJiDOk68OzUZi31go2UMjNmnVnL6wHXpvMA2JP0W0tcDWeTpIarPT+oXc4ua31m+T
         M3QpJdFvQoynnw7Ezx9qj5MER8LG2Vg7MnSmZHhxb+cHHgP5Ynb7Hlu7N6Toi0PnlUA0
         vn60pXIfcIt0zGPEQRIdd/U94vuY8fqHvN5UbP3YWYxAYrJcTWHsbtMNTvkr37JLhGc8
         CkCA==
X-Gm-Message-State: APjAAAVSSKtf3HGFix4RWTxOWFyYJAropg6WCEOzdm18LVe476UYlX1F
        JAtHKmcVKDcfVi4dl5RdB+v2GjJ5SOQUXOo6
X-Google-Smtp-Source: APXvYqyLjphlmQSIh5IbYGIf4+MBUZSV441mKVm403DP6/SLv5GAymUZoaCSZxNSw1ZwtjxWNchesQ==
X-Received: by 2002:a5d:6b0a:: with SMTP id v10mr4128158wrw.32.1571339398045;
        Thu, 17 Oct 2019 12:09:58 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.09.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:09:57 -0700 (PDT)
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
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 05/35] crypto: arm64/chacha - depend on generic chacha library instead of crypto driver
Date:   Thu, 17 Oct 2019 21:09:02 +0200
Message-Id: <20191017190932.1947-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig            |  2 +-
 arch/arm64/crypto/chacha-neon-glue.c | 52 +++++++++++++-------
 2 files changed, 35 insertions(+), 19 deletions(-)

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
index d4cc61bfe79d..36189514a616 100644
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
@@ -120,6 +124,18 @@ static int xchacha_neon(struct skcipher_request *req)
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
@@ -134,7 +150,7 @@ static struct skcipher_alg algs[] = {
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 5 * CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= chacha_neon,
 		.decrypt		= chacha_neon,
 	}, {
@@ -150,7 +166,7 @@ static struct skcipher_alg algs[] = {
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 5 * CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= xchacha_neon,
 		.decrypt		= xchacha_neon,
 	}, {
@@ -166,7 +182,7 @@ static struct skcipher_alg algs[] = {
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

