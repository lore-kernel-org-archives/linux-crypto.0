From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IV generation in cryptographic driver in AEAD
Date: Fri, 20 May 2016 12:19:01 +0800
Message-ID: <20160520041901.GA2645@gondor.apana.org.au>
References: <CADREXsrrkx2-G1x81ss5sCS1p4TZxywdsqo4Tkzt7LX4syu+BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Denis B <begun.denis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53392 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbcETETE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 May 2016 00:19:04 -0400
Content-Disposition: inline
In-Reply-To: <CADREXsrrkx2-G1x81ss5sCS1p4TZxywdsqo4Tkzt7LX4syu+BA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Denis B <begun.denis@gmail.com> wrote:
> My algs struct now looks like this:
> 
> static struct crypto_alg pp_crypto_algs[] = {
>   {
>      .cra_name = "authenc(hmac(sha256),cbc(aes))",
>      .cra_driver_name = "pp_crypto_cbc_hmac_sha256",
>      .cra_priority = 1, /**TODO set to highest values after
> implementing encrypt decrypt functions */
>      .cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
>      .cra_blocksize = AES_BLOCK_SIZE,
>      .cra_ctxsize = sizeof(struct pp_crypto_aead_ctx),
>      .cra_type = &crypto_nivaead_type,
>      .cra_u = {
>            .aead = {
>                .setkey = pp_crypto_aead_setkey,
>                .setauthsize = pp_crypto_aead_setauthsize,
>                .decrypt = pp_crypto_aead_dec,
>                .encrypt = pp_crypto_aead_enc,
>                .givencrypt = NULL,
>                .givdecrypt = NULL,
>                .ivsize = AES_BLOCK_SIZE,
>                .maxauthsize = SHA256_DIGEST_SIZE,

You also need to set geniv to "eseqiv".

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
