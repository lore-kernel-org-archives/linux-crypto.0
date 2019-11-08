Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D152FA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10BD322473
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215818;
	bh=2a+PT+frzlqqB6N654vMHLV8wTuhXDw8QFGaYOxD5ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=H/m0+rL3b2ms0dfAPGvdObE1+xRe87MLR1Aia6Ay7klXDr40uwSFMlhUHKwEZgyMR
	 5i+GBAf8wFPIEPv6jdYLLPZQ4RsinyRihQyrhZ3/n5uaIO1eSji3HjJ/asC1oLbMyu
	 h82C7V6Dfx84dxxW5zTIH4kp03QhY+w9YXqMPPeI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732314AbfKHMXh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfKHMXh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:37 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7635222466;
        Fri,  8 Nov 2019 12:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215815;
        bh=2a+PT+frzlqqB6N654vMHLV8wTuhXDw8QFGaYOxD5ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjyIgiTAERRN0J1gJiAhtRapd547BF/reBqPrh0qnYgaRbN+OhlYI42HVMTICnHxu
         ZHlGdsP8ksP7bPC2TtqBiSzaothuCa+p5Fy9aaFm+WW8BpZJ1NAaSgbLxpzygwufqk
         kR3r0k1jRhyHs74/a2Y41y62w9LyvuzOYN35EnZw=
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
Subject: [PATCH v5 12/34] crypto: chacha - unexport chacha_generic routines
Date:   Fri,  8 Nov 2019 13:22:18 +0100
Message-Id: <20191108122240.28479-13-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that all users of generic ChaCha code have moved to the core library,
there is no longer a need for the generic ChaCha skcpiher driver to
export parts of it implementation for reuse by other drivers. So drop
the exports, and make the symbols static.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/chacha_generic.c          | 26 ++++++--------------
 include/crypto/internal/chacha.h | 10 --------
 2 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index ebae6d9d9b32..c1b147318393 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -21,7 +21,7 @@ static int chacha_stream_xor(struct skcipher_request *req,
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	crypto_chacha_init(state, ctx, iv);
+	chacha_init_generic(state, ctx->key, iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
@@ -37,36 +37,27 @@ static int chacha_stream_xor(struct skcipher_request *req,
 	return err;
 }
 
-void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv)
-{
-	chacha_init_generic(state, ctx->key, iv);
-}
-EXPORT_SYMBOL_GPL(crypto_chacha_init);
-
-int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize)
+static int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				  unsigned int keysize)
 {
 	return chacha_setkey(tfm, key, keysize, 20);
 }
-EXPORT_SYMBOL_GPL(crypto_chacha20_setkey);
 
-int crypto_chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize)
+static int crypto_chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				 unsigned int keysize)
 {
 	return chacha_setkey(tfm, key, keysize, 12);
 }
-EXPORT_SYMBOL_GPL(crypto_chacha12_setkey);
 
-int crypto_chacha_crypt(struct skcipher_request *req)
+static int crypto_chacha_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return chacha_stream_xor(req, ctx, req->iv);
 }
-EXPORT_SYMBOL_GPL(crypto_chacha_crypt);
 
-int crypto_xchacha_crypt(struct skcipher_request *req)
+static int crypto_xchacha_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -75,7 +66,7 @@ int crypto_xchacha_crypt(struct skcipher_request *req)
 	u8 real_iv[16];
 
 	/* Compute the subkey given the original key and first 128 nonce bits */
-	crypto_chacha_init(state, ctx, req->iv);
+	chacha_init_generic(state, ctx->key, req->iv);
 	hchacha_block_generic(state, subctx.key, ctx->nrounds);
 	subctx.nrounds = ctx->nrounds;
 
@@ -86,7 +77,6 @@ int crypto_xchacha_crypt(struct skcipher_request *req)
 	/* Generate the stream and XOR it with the data */
 	return chacha_stream_xor(req, &subctx, real_iv);
 }
-EXPORT_SYMBOL_GPL(crypto_xchacha_crypt);
 
 static struct skcipher_alg algs[] = {
 	{
diff --git a/include/crypto/internal/chacha.h b/include/crypto/internal/chacha.h
index c0e40b245431..aa5d4a16aac5 100644
--- a/include/crypto/internal/chacha.h
+++ b/include/crypto/internal/chacha.h
@@ -12,8 +12,6 @@ struct chacha_ctx {
 	int nrounds;
 };
 
-void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv);
-
 static inline int chacha_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				unsigned int keysize, int nrounds)
 {
@@ -42,12 +40,4 @@ static int inline chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return chacha_setkey(tfm, key, keysize, 12);
 }
 
-int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize);
-int crypto_chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize);
-
-int crypto_chacha_crypt(struct skcipher_request *req);
-int crypto_xchacha_crypt(struct skcipher_request *req);
-
 #endif /* _CRYPTO_CHACHA_H */
-- 
2.20.1

