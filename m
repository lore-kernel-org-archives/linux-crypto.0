Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB038C63799
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jul 2021 06:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 930F7610F7
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jul 2021 06:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhGVFvU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jul 2021 01:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhGVFvS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jul 2021 01:51:18 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BE2C0613CF
        for <linux-crypto@vger.kernel.org>; Wed, 21 Jul 2021 23:31:52 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id i5so6883150lfe.2
        for <linux-crypto@vger.kernel.org>; Wed, 21 Jul 2021 23:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CYkqe4g3VLBX8Hb5LmueO3C4AbVGUfd62D9jkXzQh10=;
        b=mU/g1ltZPaGC8L3S24o+kCRancRgTxYtCXBsV2f759apd/DxxumZVbmGBi4VgZZ0Xm
         ZAlExAwX63zwUgqwWo/2I9L0Rsq3PPO+xrrQbTpNbBUSbVdSEAi6HRP1Ilz/+39omogt
         94uarhbtVjF0zRLc29bKdj72vCI5qYaoEiVgFW4pCpNLAduzpZoIED5F4okKq37ZpHGx
         zmyZuyoziTl3SVfODmss6VMTDi7IyXZz2L6mSLtMTawBcqYVo07WFopVgMThm+tEUTnE
         GkgnBfYgJlJdqdj7J0yv+83/xeygDILfhHLbd6BfPqQo8hne57nTJp57sUgwuiMW++8k
         O5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CYkqe4g3VLBX8Hb5LmueO3C4AbVGUfd62D9jkXzQh10=;
        b=R7L1zHad+6FbYDbgpFEnsqGJJ8m/aGEp0BIY/W9GlCkBhMg3TTpIymEexshM27TZqU
         Ws2TvHW02dAeDXb8Lys8IOyTf/TpXjmp3DAEE2Lj7UaXAevI7zCrYcV2KLlfh1p3CMs6
         qhulcdzp+wIYXVhElEnAfsoUtWp0KCZY2iyMr+myw3sMzLHFUA86QP8a6U5eUtOzjpRw
         YQl6ty6ZtNZzvzwPcTIBdEBp30dQQrhh+y4tIqCYH6lxtD7W4hrEfT7VoNpAy2riuwu7
         B+ucvcOrWokRh9zz6dLuFjeve/B68LAype2ML9PdRjMZuAhwc6L1RacBE58ZlpWPIPY+
         q6Jg==
X-Gm-Message-State: AOAM531SBWgM2nmpdQtZTOlLEr8NqT8ozGepXL5/4eIw0QMDi/FpCcYE
        m9QhzhFfoAaoNNDtm3bw41855Mq5nUJlgQLuhlkAeQ==
X-Google-Smtp-Source: ABdhPJw7K0q3fw+k/PMYcM9dTkSADGg9BbZSydjrjfGRXUG8kRxrNL2OPsAA1EKRSD6SFd7GgLJ2JALBc22ZPQzXJSw=
X-Received: by 2002:a05:6512:511:: with SMTP id o17mr28933803lfb.396.1626935511146;
 Wed, 21 Jul 2021 23:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.9fc9298fd9d63553491871d043a18affc2dbc8a8.1626885907.git-series.a.fatoum@pengutronix.de>
 <7b771da7b09a01c8b4da2ed21f05251ea797b2e8.1626885907.git-series.a.fatoum@pengutronix.de>
In-Reply-To: <7b771da7b09a01c8b4da2ed21f05251ea797b2e8.1626885907.git-series.a.fatoum@pengutronix.de>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 22 Jul 2021 12:01:40 +0530
Message-ID: <CAFA6WYOskwZNe5Wb5PTtnSHQBonSXZ48eEex0w9jQ+JW4vG=+w@mail.gmail.com>
Subject: Re: [PATCH 2/4] KEYS: trusted: allow trust sources to use kernel RNG
 for key material
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        kernel <kernel@pengutronix.de>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Agarwal <udit.agarwal@nxp.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jan Luebbe <j.luebbe@pengutronix.de>,
        David Gstir <david@sigma-star.at>,
        Richard Weinberger <richard@nod.at>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:SECURITY SUBSYSTEM" 
        <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 21 Jul 2021 at 22:19, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>
> The two existing trusted key sources don't make use of the kernel RNG,
> but instead let the hardware that does the sealing/unsealing also
> generate the random key material. While a previous change offers users
> the choice to use the kernel RNG instead for both, new trust sources
> may want to unconditionally use the kernel RNG for generating key
> material, like it's done elsewhere in the kernel.
>
> This is especially prudent for hardware that has proven-in-production
> HWRNG drivers implemented, as otherwise code would have to be duplicated
> only to arrive at a possibly worse result.
>
> Make this possible by turning struct trusted_key_ops::get_random
> into an optional member. If a driver leaves it NULL, kernel RNG
> will be used instead.
>
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
> To: James Bottomley <jejb@linux.ibm.com>
> To: Jarkko Sakkinen <jarkko@kernel.org>
> To: Mimi Zohar <zohar@linux.ibm.com>
> To: David Howells <dhowells@redhat.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: "Horia Geant=C4=83" <horia.geanta@nxp.com>
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Udit Agarwal <udit.agarwal@nxp.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Jan Luebbe <j.luebbe@pengutronix.de>
> Cc: David Gstir <david@sigma-star.at>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Franck LENORMAND <franck.lenormand@nxp.com>
> Cc: Sumit Garg <sumit.garg@linaro.org>
> Cc: keyrings@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-integrity@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> ---
>  include/keys/trusted-type.h               | 2 +-
>  security/keys/trusted-keys/trusted_core.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
> index d89fa2579ac0..4eb64548a74f 100644
> --- a/include/keys/trusted-type.h
> +++ b/include/keys/trusted-type.h
> @@ -64,7 +64,7 @@ struct trusted_key_ops {
>         /* Unseal a key. */
>         int (*unseal)(struct trusted_key_payload *p, char *datablob);
>
> -       /* Get a randomized key. */
> +       /* Optional: Get a randomized key. */
>         int (*get_random)(unsigned char *key, size_t key_len);
>
>         /* Exit key interface. */
> diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/tr=
usted-keys/trusted_core.c
> index 569af9af8df0..d2b7626cde8b 100644
> --- a/security/keys/trusted-keys/trusted_core.c
> +++ b/security/keys/trusted-keys/trusted_core.c
> @@ -334,7 +334,7 @@ static int __init init_trusted(void)
>                         continue;
>
>                 get_random =3D trusted_key_sources[i].ops->get_random;
> -               if (trusted_kernel_rng)
> +               if (trusted_kernel_rng || !get_random)
>                         get_random =3D kernel_get_random;
>

For ease of understanding, I would prefer to write it as:

                  get_random =3D trusted_key_sources[i].ops->get_random ?:
                                         kernel_get_random;
                  if (trusted_kernel_rng)
                        get_random =3D kernel_get_random;

With that:

Acked-by: Sumit Garg <sumit.garg@linaro.org>

-Sumit

>                 static_call_update(trusted_key_init,
> --
> git-series 0.9.1
