Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AB7C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 08:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7C0F2083D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 08:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfFXINN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 04:13:13 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38840 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfFXINN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 04:13:13 -0400
Received: by mail-ot1-f67.google.com with SMTP id d17so12645589oth.5
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 01:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tgtglqVI+yhp3Ca/jYEFLBUnBPDfmJrS3TB1QtUe6wk=;
        b=dmUCfCRYpb5XNA/gmk4buXOxV/JuFqRDAcpX+K5WIdsJ7tc171/LitLWNtXYrxdaae
         DHMyj9xu8Za2FD755Vhp2sdHfKG3UdgqnRpJoMKtwheV9vswVhSzF2wGl7cRVoTmJrkI
         /vqC8ALj8ai6l0sRJS8BHyzea7mvQYXz2kq3F3cvuRz0Naz212rlFSL6zw5BsbIqZRCR
         VNmcX6m3UcNGMEj6ez9tiymvIdgDSSUfyppa7zmQwEaim+pDsOKBrCLqxvvLh+AgXMpw
         J1kaDRgtb2vuy9d1s32ujl6KcihM25XQhWsGMo9nxOieEfJD3r1E5tfoQpaE5QbVWM7j
         BFYQ==
X-Gm-Message-State: APjAAAVvWPueX2I/h26qC/ZM5sbe4EeZjdHPCGirpa07cPHfSzjxTNMY
        mvk3eu+2tcS8VOBHTFNPK0v3LauQrH2HlRt9oTXuSA==
X-Google-Smtp-Source: APXvYqyjjtHL7kuAGvGg1Taus+PBf+IeqW8IdvXqNYnVch4/4XwsLD4daZcwXJaUEgGgnfnMoQvjq7+bXd0qLS7+4Z4=
X-Received: by 2002:a9d:73cd:: with SMTP id m13mr7847700otk.43.1561363993191;
 Mon, 24 Jun 2019 01:13:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org> <20190624073818.29296-4-ard.biesheuvel@linaro.org>
In-Reply-To: <20190624073818.29296-4-ard.biesheuvel@linaro.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 24 Jun 2019 10:13:02 +0200
Message-ID: <CAFqZXNvC=0pDgo9fAujiun2u79SPettvcTKQVhd=Yzq-NT_q-Q@mail.gmail.com>
Subject: Re: [PATCH 3/6] crypto: aegis - avoid prerotated AES tables
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 24, 2019 at 9:38 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> The generic AES code provides four sets of lookup tables, where each
> set consists of four tables containing the same 32-bit values, but
> rotated by 0, 8, 16 and 24 bits, respectively. This makes sense for
> CISC architectures such as x86 which support memory operands, but
> for other architectures, the rotates are quite cheap, and using all
> four tables needlessly thrashes the D-cache, and actually hurts rather
> than helps performance.
>
> Since x86 already has its own implementation of AEGIS based on AES-NI
> instructions, let's tweak the generic implementation towards other
> architectures, and avoid the prerotated tables, and perform the
> rotations inline. On ARM Cortex-A53, this results in a ~8% speedup.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

I'm not an expert on low-level performance, but the rationale sounds reasonable.

Acked-by: Ondrej Mosnacek <omosnace@redhat.com>

> ---
>  crypto/aegis.h | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/crypto/aegis.h b/crypto/aegis.h
> index 41a3090cda8e..3308066ddde0 100644
> --- a/crypto/aegis.h
> +++ b/crypto/aegis.h
> @@ -10,6 +10,7 @@
>  #define _CRYPTO_AEGIS_H
>
>  #include <crypto/aes.h>
> +#include <linux/bitops.h>
>  #include <linux/types.h>
>
>  #define AEGIS_BLOCK_SIZE 16
> @@ -53,16 +54,13 @@ static void crypto_aegis_aesenc(union aegis_block *dst,
>                                 const union aegis_block *key)
>  {
>         const u8  *s  = src->bytes;
> -       const u32 *t0 = crypto_ft_tab[0];
> -       const u32 *t1 = crypto_ft_tab[1];
> -       const u32 *t2 = crypto_ft_tab[2];
> -       const u32 *t3 = crypto_ft_tab[3];
> +       const u32 *t = crypto_ft_tab[0];
>         u32 d0, d1, d2, d3;
>
> -       d0 = t0[s[ 0]] ^ t1[s[ 5]] ^ t2[s[10]] ^ t3[s[15]];
> -       d1 = t0[s[ 4]] ^ t1[s[ 9]] ^ t2[s[14]] ^ t3[s[ 3]];
> -       d2 = t0[s[ 8]] ^ t1[s[13]] ^ t2[s[ 2]] ^ t3[s[ 7]];
> -       d3 = t0[s[12]] ^ t1[s[ 1]] ^ t2[s[ 6]] ^ t3[s[11]];
> +       d0 = t[s[ 0]] ^ rol32(t[s[ 5]], 8) ^ rol32(t[s[10]], 16) ^ rol32(t[s[15]], 24);
> +       d1 = t[s[ 4]] ^ rol32(t[s[ 9]], 8) ^ rol32(t[s[14]], 16) ^ rol32(t[s[ 3]], 24);
> +       d2 = t[s[ 8]] ^ rol32(t[s[13]], 8) ^ rol32(t[s[ 2]], 16) ^ rol32(t[s[ 7]], 24);
> +       d3 = t[s[12]] ^ rol32(t[s[ 1]], 8) ^ rol32(t[s[ 6]], 16) ^ rol32(t[s[11]], 24);
>
>         dst->words32[0] = cpu_to_le32(d0) ^ key->words32[0];
>         dst->words32[1] = cpu_to_le32(d1) ^ key->words32[1];
> --
> 2.20.1
>


-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
