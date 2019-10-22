Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9B8CA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B0C7218AE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732163AbfJVPOn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 11:14:43 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:48207 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731217AbfJVPOm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 11:14:42 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mgefy-1howQO1DYq-00h5Gs; Tue, 22 Oct 2019 17:14:24 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] crypto: inside-secure - Reduce stack usage
Date:   Tue, 22 Oct 2019 17:14:13 +0200
Message-Id: <20191022151421.2070738-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:pqcp+K0sEi/P5yFUWgxVVEcF23D/yPVAcJF8awdcfDaTOwqQWoT
 2hMql8OAX8C1UJagJ92f3cEMvaA88tFMOpKF7/PNlBb6rgHLhBqrXC+Ty4tdK910Bh6IO24
 yv7TswO4T11bJo5BWYhboBfTkiRRcDIbuZ60jWc/2WrL+EfMgBQRR7VMDXkK/xr/xyavD+S
 HR8c+XJcvaclst8HfNrXA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vm0p90nu1Aw=:mBHfVJmjuC6ufwmQ85cSXl
 pbUSEqMbCU8ZRdHQEceAK1WBieArZ3UzZS1wxNAPJB2XJmJftp47PkuL8Qr0KezNIKDu2oeQ4
 gI4S2D1xJphSinZTEgR6Y+V4G7BHogwwE4hCFoadAag4MRj1gQ1PSH11CpkMl2zvZtE1nFz0B
 8WbaRuflYrLG3aQhioDf0XHwTxpnrcLP4689sPS1jVUX1wQ01heUU4ChPP5unGuXoI8HwypSQ
 fSpEEvJ7TVXfh0VErIHqn0sX/EK8ZikN5nbrOqt0l8a9qzp6PL1dIRIu+l7z7P3NX8IGDgxag
 g3sCtPAJl+3cgJd5IxlyIFKwCiR9n5wz2Ir8Rexrq9M+/1meCTi1OKUKNxDIVwVWJyfcOBgra
 p5OzjyqRI4nNSFit3sqCWzcTejri22MU/8pUAPLW15vmv5adh3bYqC0NIvsxb7ziPfh1Q2vBz
 rlI9Pa6Dk/uMEeozDIBPa3J36pOPuh6UD7lpBPWFIC4xpV4MD2LLcHTBxnW8khgAWdLvd430f
 k7v2fFcvEbWDFvjrdrpw4Qxfsoz5OXz9569dcJljkHUq8ayBnPumJXbyXNZWVW/qmBXgR9fkt
 tAKpc4ZCWYKMTmm9rvFEIfQ/vPzSLTs1pt9w7B99+5CMQjj2JIbEo8hr/4af52xom9akTCTnJ
 sHlIp3xQNDFQdPMeCHOt+8GZVuOkoKI+jPBH4nT4c0eBSv28rHF52uvwIk+Gsk9y7xBKjBYHP
 dlGUTk8F/Jepko7SU4SvO5ndDVPU+moB5kHM3tLsJTm8WLy85ayyH6DeKDQGi2pjBxUikZfLJ
 VmZe+0557bzD5/0mQH9EEcjQbauXJIit5nDOjSqy7SSZURWQXYv7yxJHNNxFiBQ1MQ4824J1J
 nJSo7tH+M2QtWNtp9CNQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

safexcel_aead_setkey() contains three large stack variables, totalling
slightly more than the 1024 byte warning limit:

drivers/crypto/inside-secure/safexcel_cipher.c:303:12: error: stack frame size of 1032 bytes in function 'safexcel_aead_setkey' [-Werror,-Wframe-larger-than=]

The function already contains a couple of dynamic allocations, so it is
likely not performance critical and it can only be called in a context
that allows sleeping, so the easiest workaround is to add change it
to use dynamic allocations. Combining istate and ostate into a single
variable simplifies the allocation at the cost of making it slightly
less readable.

Alternatively, it should be possible to shrink these allocations
as the extra buffers appear to be largely unnecessary, but doing
this would be a much more invasive change.

Fixes: 0e17e3621a28 ("crypto: inside-secure - add support for authenc(hmac(sha*),rfc3686(ctr(aes))) suites")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: rebase against crypto/master
---
 .../crypto/inside-secure/safexcel_cipher.c    | 55 ++++++++++++-------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 407ebcd8d71f..1aade2fd6f1e 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -354,10 +354,10 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_ahash_export_state istate, ostate;
+	struct safexcel_ahash_export_state *state;
 	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct crypto_aes_ctx *aes;
 	struct crypto_authenc_keys keys;
-	struct crypto_aes_ctx aes;
 	int err = -EINVAL;
 
 	if (unlikely(crypto_authenc_extractkeys(&keys, key, len)))
@@ -387,7 +387,14 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 			goto badkey_expflags;
 		break;
 	case SAFEXCEL_AES:
-		err = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
+		aes = kzalloc(sizeof(*aes), GFP_KERNEL);
+		if (!aes) {
+			err = -ENOMEM;
+			goto badkey;
+		}
+
+		err = aes_expandkey(aes, keys.enckey, keys.enckeylen);
+		kfree(aes);
 		if (unlikely(err))
 			goto badkey;
 		break;
@@ -404,61 +411,71 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	    memcmp(ctx->key, keys.enckey, keys.enckeylen))
 		ctx->base.needs_inv = true;
 
+	state = kzalloc(sizeof(struct safexcel_ahash_export_state) * 2, GFP_KERNEL);
+	if (!state) {
+		err = -ENOMEM;
+		goto badkey;
+	}
+
 	/* Auth key */
 	switch (ctx->hash_alg) {
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA1:
 		if (safexcel_hmac_setkey("safexcel-sha1", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+					 keys.authkeylen, &state[0], &state[1]))
+			goto badkey_free;
 		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA224:
 		if (safexcel_hmac_setkey("safexcel-sha224", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+					 keys.authkeylen, &state[0], &state[1]))
+			goto badkey_free;
 		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA256:
 		if (safexcel_hmac_setkey("safexcel-sha256", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+					 keys.authkeylen, &state[0], &state[1]))
+			goto badkey_free;
 		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA384:
 		if (safexcel_hmac_setkey("safexcel-sha384", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+					 keys.authkeylen, &state[0], &state[1]))
+			goto badkey_free;
 		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA512:
 		if (safexcel_hmac_setkey("safexcel-sha512", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
-			goto badkey;
+					 keys.authkeylen, &state[0], &state[1]))
+			goto badkey_free;
 		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SM3:
 		if (safexcel_hmac_setkey("safexcel-sm3", keys.authkey,
-					 keys.authkeylen, &istate, &ostate))
+					 keys.authkeylen, &state[0], &state[1]))
 			goto badkey;
 		break;
 	default:
 		dev_err(priv->dev, "aead: unsupported hash algorithm\n");
-		goto badkey;
+		goto badkey_free;
 	}
 
 	crypto_aead_set_flags(ctfm, crypto_aead_get_flags(ctfm) &
 				    CRYPTO_TFM_RES_MASK);
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma &&
-	    (memcmp(ctx->ipad, istate.state, ctx->state_sz) ||
-	     memcmp(ctx->opad, ostate.state, ctx->state_sz)))
+	    (memcmp(ctx->ipad, &state[0].state, ctx->state_sz) ||
+	     memcmp(ctx->opad, &state[1].state, ctx->state_sz)))
 		ctx->base.needs_inv = true;
 
 	/* Now copy the keys into the context */
 	memcpy(ctx->key, keys.enckey, keys.enckeylen);
 	ctx->key_len = keys.enckeylen;
 
-	memcpy(ctx->ipad, &istate.state, ctx->state_sz);
-	memcpy(ctx->opad, &ostate.state, ctx->state_sz);
+	memcpy(ctx->ipad, &state[0].state, ctx->state_sz);
+	memcpy(ctx->opad, &state[1].state, ctx->state_sz);
 
 	memzero_explicit(&keys, sizeof(keys));
+	kfree(state);
+
 	return 0;
 
+badkey_free:
+	kfree(state);
 badkey:
 	crypto_aead_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 badkey_expflags:
-- 
2.20.0

