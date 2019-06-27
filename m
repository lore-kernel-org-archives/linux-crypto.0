Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E2EC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 09:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A7972082F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 09:12:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A3zC7ykh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfF0JMV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 05:12:21 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39021 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfF0JMV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 05:12:21 -0400
Received: by mail-io1-f66.google.com with SMTP id r185so3145824iod.6
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 02:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WmFfrT2NyPaYcrjqaPhcshuIjVDv1YVjeOurIM/wREA=;
        b=A3zC7ykhO84hwGqL4TgAdHwNdPjgu4F2njLapFXmAXpd0DbuqMwunMV70tN/+ZeB+2
         AU5uy7/DEy+bVq0hCwc4qR3XV6aRvDbMPkwCnBrCV1cLzsTiMejo0ne4SnBGOaPQMaeI
         I/noN8gla4e7isKGi4ISyfKIzmku8L440DdegigZrZ6le8mVhy+bu+ovhF0ygTJdMEBv
         p8E/4LaHW5gVXRuSn646Rg+vIlYTO/gwkHHb8QhI0D9zE5mvqtsWtNaueiLAZY4Lg939
         dq7G5IurCDravmUDOx01/FUOhzJZz+2XMFG1wC29Lxo72ikc0cnpQ4sXWt7OLdJUMQyb
         Y7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WmFfrT2NyPaYcrjqaPhcshuIjVDv1YVjeOurIM/wREA=;
        b=nuE9WVcZmsOB+UhgO8djFpMJ/Xvv7hE74tymvkpwk46bBdwGuGaM9gosJx0nDxEIcB
         KHokU8m124MrgYf0SScHBNdRg8d8kHdfpO/nJvSsPYGSXZm2CNvadIE7sm79xOijFnJB
         1kOeEGmr8Nlk5NGyntlEYKFqp8GjMIQWR+fNtmYdfuPnhHwtrzeXCoMy+/OfLdHpqa7X
         7OIMvPPfxEdZ4VoebJm2P+rCTZ8Q6ugP3DIg2cPsLPoY8n1vpHFYmwoZe/9cFAt7a4HN
         Knk8ldE+1SJgzziI1CraWASFnwhoNdZ/G5HoighTjWCHiF7aSxo3utwhFW+VgfqRu5Ca
         vM8w==
X-Gm-Message-State: APjAAAV1Pcey7AZdQyCs8+ApLej3Xr9g7UAfS8ZDOUWkbIga7ca6gqbP
        zKQvo0n0OECjYSNpxU4M0SkWchDB0Ej0SubPfgxMdQ==
X-Google-Smtp-Source: APXvYqw9mnjkRznCcyuEJO9kfkgpp221GLQECtACrRmQ9LKJiWKB5d3mwo0exXiC2NjifBARJh9JyKrgiiCUCjff+NY=
X-Received: by 2002:a02:6597:: with SMTP id u145mr3433096jab.26.1561626740848;
 Thu, 27 Jun 2019 02:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
 <20190622003112.31033-28-ard.biesheuvel@linaro.org> <VI1PR0402MB3485E399D27D2D86674DBE6198FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485E399D27D2D86674DBE6198FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 27 Jun 2019 11:12:08 +0200
Message-ID: <CAKv+Gu_YWFO0+rzNJv=FrdR2rrLEK7d1vHzAOBgCHUeOFu7oZw@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - fix dependency on CRYPTO_DES
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@google.com" <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Jun 2019 at 11:10, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> (changed subject to make patchwork happy
> was: [RFC PATCH 27/30] crypto: des - split off DES library from generic D=
ES cipher driver)
>
> On 6/22/2019 3:32 AM, Ard Biesheuvel wrote:
> > diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
> > index 3720ddabb507..4a358391b6cb 100644
> > --- a/drivers/crypto/caam/Kconfig
> > +++ b/drivers/crypto/caam/Kconfig
> > @@ -98,7 +98,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
> >       select CRYPTO_AEAD
> >       select CRYPTO_AUTHENC
> >       select CRYPTO_BLKCIPHER
> > -     select CRYPTO_DES
> > +     select CRYPTO_LIB_DES
> >       help
> >         Selecting this will offload crypto for users of the
> >         scatterlist crypto API (such as the linux native IPSec
>
> There are two other config symbols that should select CRYPTO_LIB_DES:
> CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI
> CRYPTO_DEV_FSL_DPAA2_CAAM
>
> True, this is not stricty related to refactoring in this patch set,
> but actually a fix of
> commit 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")
>

The 3des key checks are static inline functions defined in des.h, so
there is no need to depend on the library or on the generic driver
AFAICT

> I am adding a fix inline.
> Herbert, I think it would be better to apply it separately.
>
> -- >8 --
> Fix caam/qi and caam/qi2 dependency on CRYPTO_DES, introduced by
> commit strengthening 3DES key checks.
>
> Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
> index 3720ddabb507..524b961360d2 100644
> --- a/drivers/crypto/caam/Kconfig
> +++ b/drivers/crypto/caam/Kconfig
> @@ -111,6 +111,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI
>         select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
>         select CRYPTO_AUTHENC
>         select CRYPTO_BLKCIPHER
> +       select CRYPTO_DES
>         help
>           Selecting this will use CAAM Queue Interface (QI) for sending
>           & receiving crypto jobs to/from CAAM. This gives better perform=
ance
> @@ -158,6 +159,7 @@ config CRYPTO_DEV_FSL_DPAA2_CAAM
>         select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC
>         select CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC
>         select CRYPTO_BLKCIPHER
> +       select CRYPTO_DES
>         select CRYPTO_AUTHENC
>         select CRYPTO_AEAD
>         select CRYPTO_HASH
> --
> 2.17.1
