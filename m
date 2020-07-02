Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB86C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C0FB20899
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593674866;
	bh=ylACgRHG6doq0HnMWJNZGnE39YzQme+8QBD07b9AdJs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=VUN1ImR8rPzy6wMh//rkJZuHycnwu27ogEWBf69IOxFK8LTMFDk1FY52FuvNIBl7g
	 6Rn+U1qyNVh6K094fXNzvShjBXhCYS331bBHvUej6HnJlMnNORPl/5CfdQMJYYAVjm
	 unodxJb6kpWxbfpckEHDquzzOx5vPjKLplNnF/40=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGBH1q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 03:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgGBH1p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 03:27:45 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D299A20899
        for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2020 07:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593674864;
        bh=ylACgRHG6doq0HnMWJNZGnE39YzQme+8QBD07b9AdJs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PsY7FuEd8SWLWa1QvftAW9JHj8D7L6zmUTLlJzLn2ORpZDvfNIm/vWz1kdIWPMhjd
         fWkHA8UPytvS2o0Yl9V8Kw+bnUxzuItzp+CNtki8jSuq+5PmU0lnnt0RuwXvLBwIbq
         2AIh+h6N9aWihXEcD3ah021i48iOzrWi1qZUEJo8=
Received: by mail-oi1-f170.google.com with SMTP id r8so22873088oij.5
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2020 00:27:44 -0700 (PDT)
X-Gm-Message-State: AOAM533qXjsTl0CKC5J8tZH8YNufJqeza42hYvyp4lNqlJxUxQ/Zidxq
        H1Igrs23v/L6D3lVm6bNSjAyzb9JicVrYthR/UA=
X-Google-Smtp-Source: ABdhPJzkmnm7Sl0jXJRQBC2HLiPpsICvRk5GSGPF7DsSCqioOA/zzJCZOB4CCl757M13amvGNt2pC+8MoUTaxO2Fapk=
X-Received: by 2002:aca:f257:: with SMTP id q84mr9189988oih.174.1593674864200;
 Thu, 02 Jul 2020 00:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200702043648.GA21823@gondor.apana.org.au>
In-Reply-To: <20200702043648.GA21823@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 2 Jul 2020 09:27:33 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFKkCSf06d4eKRZvdPzxCsVsYhOjRk221XpmLxvrrdKMw@mail.gmail.com>
Message-ID: <CAMj1kXFKkCSf06d4eKRZvdPzxCsVsYhOjRk221XpmLxvrrdKMw@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2 Jul 2020 at 06:36, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> The arc4 algorithm requires storing state in the request context
> in order to allow more than one encrypt/decrypt operation.  As this
> driver does not seem to do that, it means that using it for more
> than one operation is broken.
>
> Fixes: eaed71a44ad9 ("crypto: caam - add ecb(*) support")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

All internal users of ecb(arc4) use sync skciphers, so this should
only affect user space.

I do wonder if the others are doing any better - n2 and bcm iproc also
appear to keep the state in the TFM object, while I'd expect the
setkey() to be a simple memcpy(), and the initial state derivation to
be part of the encrypt flow, right?

Maybe we should add a test for this to tcrypt, i.e., do setkey() once
and do two encryptions of the same input, and check whether we get
back the original data.


> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> index b2f9882bc010f..797bff9b93182 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -810,12 +810,6 @@ static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
>         return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
>  }
>
> -static int arc4_skcipher_setkey(struct crypto_skcipher *skcipher,
> -                               const u8 *key, unsigned int keylen)
> -{
> -       return skcipher_setkey(skcipher, key, keylen, 0);
> -}
> -
>  static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
>                                const u8 *key, unsigned int keylen)
>  {
> @@ -1967,21 +1961,6 @@ static struct caam_skcipher_alg driver_algs[] = {
>                 },
>                 .caam.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_ECB,
>         },
> -       {
> -               .skcipher = {
> -                       .base = {
> -                               .cra_name = "ecb(arc4)",
> -                               .cra_driver_name = "ecb-arc4-caam",
> -                               .cra_blocksize = ARC4_BLOCK_SIZE,
> -                       },
> -                       .setkey = arc4_skcipher_setkey,
> -                       .encrypt = skcipher_encrypt,
> -                       .decrypt = skcipher_decrypt,
> -                       .min_keysize = ARC4_MIN_KEY_SIZE,
> -                       .max_keysize = ARC4_MAX_KEY_SIZE,
> -               },
> -               .caam.class1_alg_type = OP_ALG_ALGSEL_ARC4 | OP_ALG_AAI_ECB,
> -       },
>  };
>
>  static struct caam_aead_alg driver_aeads[] = {
> @@ -3457,7 +3436,6 @@ int caam_algapi_init(struct device *ctrldev)
>         struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
>         int i = 0, err = 0;
>         u32 aes_vid, aes_inst, des_inst, md_vid, md_inst, ccha_inst, ptha_inst;
> -       u32 arc4_inst;
>         unsigned int md_limit = SHA512_DIGEST_SIZE;
>         bool registered = false, gcm_support;
>
> @@ -3477,8 +3455,6 @@ int caam_algapi_init(struct device *ctrldev)
>                            CHA_ID_LS_DES_SHIFT;
>                 aes_inst = cha_inst & CHA_ID_LS_AES_MASK;
>                 md_inst = (cha_inst & CHA_ID_LS_MD_MASK) >> CHA_ID_LS_MD_SHIFT;
> -               arc4_inst = (cha_inst & CHA_ID_LS_ARC4_MASK) >>
> -                           CHA_ID_LS_ARC4_SHIFT;
>                 ccha_inst = 0;
>                 ptha_inst = 0;
>
> @@ -3499,7 +3475,6 @@ int caam_algapi_init(struct device *ctrldev)
>                 md_inst = mdha & CHA_VER_NUM_MASK;
>                 ccha_inst = rd_reg32(&priv->ctrl->vreg.ccha) & CHA_VER_NUM_MASK;
>                 ptha_inst = rd_reg32(&priv->ctrl->vreg.ptha) & CHA_VER_NUM_MASK;
> -               arc4_inst = rd_reg32(&priv->ctrl->vreg.afha) & CHA_VER_NUM_MASK;
>
>                 gcm_support = aesa & CHA_VER_MISC_AES_GCM;
>         }
> @@ -3522,10 +3497,6 @@ int caam_algapi_init(struct device *ctrldev)
>                 if (!aes_inst && (alg_sel == OP_ALG_ALGSEL_AES))
>                                 continue;
>
> -               /* Skip ARC4 algorithms if not supported by device */
> -               if (!arc4_inst && alg_sel == OP_ALG_ALGSEL_ARC4)
> -                       continue;
> -
>                 /*
>                  * Check support for AES modes not available
>                  * on LP devices.
> diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
> index 60e2a54c19f11..c3c22a8de4c00 100644
> --- a/drivers/crypto/caam/compat.h
> +++ b/drivers/crypto/caam/compat.h
> @@ -43,7 +43,6 @@
>  #include <crypto/akcipher.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/skcipher.h>
> -#include <crypto/arc4.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/rsa.h>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
