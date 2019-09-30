Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2A3C32792
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 12:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D35A21855
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 12:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfI3MPx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 08:15:53 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53721 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfI3MPw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 08:15:52 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N7iGi-1i20Qx123u-014jKc; Mon, 30 Sep 2019 14:15:33 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] crypto: inside-secure - Reduce stack usage
Date:   Mon, 30 Sep 2019 14:14:34 +0200
Message-Id: <20190930121520.1388317-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190930121520.1388317-1-arnd@arndb.de>
References: <20190930121520.1388317-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:SdTEVKCj+nL7s4r3XJVBnS3lE53zalNAnSIg2b+V4EJzRyGI+uR
 8DG9WpMpncURT5/MuofVLYgJuTp0ITlNsalANaBtGrU2NDqw2tgKFHHUMmFM+4VJ4QKGFx3
 iIrPKf7qsq98cmF0nFUWmjw9n4sN9/P+MCn3PiriSomIfmSmANKeS4ah43d9rjfVP2uJVLQ
 u93WyhY8XtyBWFOmihZnw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QgPJF9CNy6o=:Od3xmj3VUEr7X6xLeuQsao
 ZTakSPqN7OVbzd0jza57R8n2fup/HGDmTA8XGtTyfRuTG3jCBvO4evZ1uo5enbP1AAlWSs4Re
 pNBv1pS2sxkTqqWT6mkPAhUs0eUcSN5sZCcJUq5SqER6MYVVuflJ2/xVODpRfVesL6/rxMIBG
 X/cCycplvH5Ss59RVJFiVm1K+OISerhwusKVWhhScah3X2cfUgZciZZgI8TC/+AijLcLYrGwT
 yELKK2JMleMGcou2LxCULyDhT+0xP9dcLct/LZRRHIpOiuGOOIGpdz3jZByzjtwuBgpDO4FKD
 QDJ7mSJ7zyDGnXwtU1X376AVXtJqBWjegxRqE17lRFW1Dm+EnsDTCszeqeb3o96ENAujolXp6
 NHEROAQkrnGUL8GXtio+WiAIUz2IqCeLmu6FpY295BS2JXWtqSe/SVfxtjIr19VFNHr/yeXXx
 TzqNYMdoyxfHoy82U/V9gRmpbiDEkkEogNscqPigzbl2tSgyGfy8barralIjCPUvCFj/KZtHM
 UqWtQ+h40vT6ihqwIsIuuGLd5wE6QYX68DxxLFFvK2PUtmOnPy1iDIxdBt8amhmkr08MsKdWR
 DI/MavST/2PmdynuljmglMgeGTl8/EWrWfssZspzhAUF92b7F941eufeAVjKl/VPgTt0HERwQ
 Vd5DVgX+JIQckHCFyvM+SPRdPudKU9kEy4Tt9SvpsUgJoBVeEBWVACkTqlIF1/CTGQovdxzbJ
 racTcnTrKBdy58HVC4UxrlciYlgfMRskyvjQh7pC/0FMZNTyZVrHhgdq2yFvX6fDHw6J5q/TV
 KabUV/G+ajmJtFFSDKlwZ2cIWcCN3bnpI+sB4VD+uOBfDcsgYitlLlMAbdgEMF6B2VHbpEVos
 DBkvBoHjf9z6iTkJTtiw==
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
 .../crypto/inside-secure/safexcel_cipher.c    | 53 ++++++++++++-------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index ef51f8c2b473..51a4112aa9bc 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -305,10 +305,10 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
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
 
 	if (crypto_authenc_extractkeys(&keys, key, len) != 0)
@@ -334,7 +334,14 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
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
@@ -347,56 +354,66 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
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

