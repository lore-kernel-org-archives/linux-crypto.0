Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E57C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 16:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5938E64D79
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 16:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhBJQAU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Feb 2021 11:00:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232071AbhBJQAO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Feb 2021 11:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC59864D99
        for <linux-crypto@vger.kernel.org>; Wed, 10 Feb 2021 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612972774;
        bh=OheMS+Crw4DV6H79TF/EQ4bAVw8DHnMKZ8VK2n9Z+K0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gq3zydeHmg1YSrSXq3JmS4O1Yf/Eljpw1UeqShLA8DLl5UPgJMwiRtzXsMMrgZEaQ
         HYvS7JXCGmNYo8YzATIRrHm777c5P/yG2zyQY+F2C180sUI2J3y4Wxg7UOtxq0UgHg
         AQ1cwt4tXRRqgdnAPv0KAxLVVG9lD2obqLPyoS44mvgbuy6Ixjqq620GN/EQhe7mfE
         WtOtNRgSpFFbIDd8no15b6a4uocFJ8W5R3+tFJ/8OTKxIrfVEDgHU4O8QYuiFmMg09
         ISg+VwmUB6cTykNKTSlthrz3jpA5fJhYnb/iKpFlRDrpgWvcy8B1YtzSpwrWneJcl5
         BYyWoXhy9zaZw==
Received: by mail-oi1-f181.google.com with SMTP id 18so2515140oiz.7
        for <linux-crypto@vger.kernel.org>; Wed, 10 Feb 2021 07:59:33 -0800 (PST)
X-Gm-Message-State: AOAM530eAb3NbAQXC/gTDIy9jhtit7VgPVr+YfAAq1CM05nO5ZZ1i+iV
        vzjRjO8mI8OWpf+7Svuz3X8Csqj0CMycev/dSUg=
X-Google-Smtp-Source: ABdhPJz4WMkxFVIoivofDpIjsJ72koUc3UyqSVbtWCg2LGI2L5hmvjiDfO3+ZMExyQwTlRsQlUc7iiz5VLcTy8xB/CU=
X-Received: by 2002:aca:4bd1:: with SMTP id y200mr2616840oia.33.1612972773229;
 Wed, 10 Feb 2021 07:59:33 -0800 (PST)
MIME-Version: 1.0
References: <20210210071556.GA24991@gondor.apana.org.au>
In-Reply-To: <20210210071556.GA24991@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 10 Feb 2021 16:59:22 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF=HVGmQYjiDiYJTi3fgZWPakfgT3PujsaxyCi_j6Bv-Q@mail.gmail.com>
Message-ID: <CAMj1kXF=HVGmQYjiDiYJTi3fgZWPakfgT3PujsaxyCi_j6Bv-Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: serpent - Fix sparse byte order warnings
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 10 Feb 2021 at 08:16, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This patch fixes the byte order markings in serpent.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Tested-by: Ard Biesheuvel <ardb@kernel.org> # arm64 big-endian

>
> diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
> index 236c87547a17..45f98b750053 100644
> --- a/crypto/serpent_generic.c
> +++ b/crypto/serpent_generic.c
> @@ -272,6 +272,7 @@ int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
>         u32 *k = ctx->expkey;
>         u8  *k8 = (u8 *)k;
>         u32 r0, r1, r2, r3, r4;
> +       __le32 *lk;
>         int i;
>
>         /* Copy key, add padding */
> @@ -283,22 +284,32 @@ int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
>         while (i < SERPENT_MAX_KEY_SIZE)
>                 k8[i++] = 0;
>
> +       lk = (__le32 *)k;
> +       k[0] = le32_to_cpu(lk[0]);
> +       k[1] = le32_to_cpu(lk[1]);
> +       k[2] = le32_to_cpu(lk[2]);
> +       k[3] = le32_to_cpu(lk[3]);
> +       k[4] = le32_to_cpu(lk[4]);
> +       k[5] = le32_to_cpu(lk[5]);
> +       k[6] = le32_to_cpu(lk[6]);
> +       k[7] = le32_to_cpu(lk[7]);
> +
>         /* Expand key using polynomial */
>
> -       r0 = le32_to_cpu(k[3]);
> -       r1 = le32_to_cpu(k[4]);
> -       r2 = le32_to_cpu(k[5]);
> -       r3 = le32_to_cpu(k[6]);
> -       r4 = le32_to_cpu(k[7]);
> -
> -       keyiter(le32_to_cpu(k[0]), r0, r4, r2, 0, 0);
> -       keyiter(le32_to_cpu(k[1]), r1, r0, r3, 1, 1);
> -       keyiter(le32_to_cpu(k[2]), r2, r1, r4, 2, 2);
> -       keyiter(le32_to_cpu(k[3]), r3, r2, r0, 3, 3);
> -       keyiter(le32_to_cpu(k[4]), r4, r3, r1, 4, 4);
> -       keyiter(le32_to_cpu(k[5]), r0, r4, r2, 5, 5);
> -       keyiter(le32_to_cpu(k[6]), r1, r0, r3, 6, 6);
> -       keyiter(le32_to_cpu(k[7]), r2, r1, r4, 7, 7);
> +       r0 = k[3];
> +       r1 = k[4];
> +       r2 = k[5];
> +       r3 = k[6];
> +       r4 = k[7];
> +
> +       keyiter(k[0], r0, r4, r2, 0, 0);
> +       keyiter(k[1], r1, r0, r3, 1, 1);
> +       keyiter(k[2], r2, r1, r4, 2, 2);
> +       keyiter(k[3], r3, r2, r0, 3, 3);
> +       keyiter(k[4], r4, r3, r1, 4, 4);
> +       keyiter(k[5], r0, r4, r2, 5, 5);
> +       keyiter(k[6], r1, r0, r3, 6, 6);
> +       keyiter(k[7], r2, r1, r4, 7, 7);
>
>         keyiter(k[0], r3, r2, r0, 8, 8);
>         keyiter(k[1], r4, r3, r1, 9, 9);
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
