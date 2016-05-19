From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IV generation in cryptographic driver in AEAD
Date: Thu, 19 May 2016 10:43:21 +0800
Message-ID: <20160519024321.GA23582@gondor.apana.org.au>
References: <CADREXsrd+XNv_K=T1QxETUV8Xmp4AmAeyP34Av-PtRf1g3hYnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cata.vasile@nxp.com, linux-crypto@vger.kernel.org
To: Denis B <begun.denis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52520 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbcESCn1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 22:43:27 -0400
Content-Disposition: inline
In-Reply-To: <CADREXsrd+XNv_K=T1QxETUV8Xmp4AmAeyP34Av-PtRf1g3hYnQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Denis B <begun.denis@gmail.com> wrote:
> Forgive my dumbness, but in:
> 
>      .cra_type = &crypto_aead_type,
>      .cra_u = {
>            .aead = {
>                .setkey = pp_crypto_aead_setkey,
>                .setauthsize = pp_crypto_aead_setauthsize,
>                .decrypt = pp_crypto_aead_dec,
>                .encrypt = pp_crypto_aead_enc,
>                .givencrypt = pp_crypto_aead_genivencrypt,
>                .givdecrypt = pp_crypto_aead_genivdecrypt,
>                .ivsize = AES_BLOCK_SIZE,
>                .maxauthsize = SHA256_DIGEST_SIZE,
>            },
>      },
> 
> Just delete the givencrypt and givdecrypt lines (or set to NULL)?

You also need to set your cra_type to nivaead.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
