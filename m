Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33927C2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 08:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFE3D223AC
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 08:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603699240;
	bh=t8KqnohVc9KETZwMDwuv/xhlsN9Qpwoi50jSZCkMFN0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=h1A/eIEwTx67fb3Qoi+O184dgT4LOsquNnd9Wl6dS74r/EnUaZykcPAkVEB/HRnlg
	 8juUyLPPl1mhuoRszeYfkDH0uLcY1ZUKGAY6buE4irgwa7bPXV0cnLH8Wi6S5+FjRe
	 a6LiMxyC/n7EdqymBl1hMm1Ym8Sew1c1l3IcdMyU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771107AbgJZIAj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 04:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771106AbgJZIAj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 04:00:39 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFEEE223AE;
        Mon, 26 Oct 2020 08:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603699239;
        bh=t8KqnohVc9KETZwMDwuv/xhlsN9Qpwoi50jSZCkMFN0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lmqZ4308gJshUYy5YYWOvPdo1y1JHt1eEuFj4V7dZgBobFeTSmJqpsd0rqsa+Gova
         VbKHgl9hKOU4QtiuRXTady9236RnBhg1/roU8354BHHoG31GzMir8p2OyrxWAhij8V
         Hsv4LU4KxYvb8aYoeUf+Jc4GRAjdoZ+K6lZ/LifQ=
Received: by mail-ot1-f48.google.com with SMTP id n15so7199027otl.8;
        Mon, 26 Oct 2020 01:00:38 -0700 (PDT)
X-Gm-Message-State: AOAM530g0G1+pKIdicNy3mbZzd3lFSwov4z4jv9B5X8w2LN5Ciw2ZPXR
        Oa0xdo8aVEgY9b9AiGVaT+Y9HcEo6du7NK/L76k=
X-Google-Smtp-Source: ABdhPJwgLfzxuLKVqsUwp9Mo0fbWMnfM4O1W5iH5XoajtMM68HH8tsCqRn5cjynazZGiV4FHR1I8PvcaURgGSLrsVC4=
X-Received: by 2002:a9d:2daa:: with SMTP id g39mr13835036otb.77.1603699238188;
 Mon, 26 Oct 2020 01:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201025143119.1054168-1-nivedita@alum.mit.edu> <20201025143119.1054168-5-nivedita@alum.mit.edu>
In-Reply-To: <20201025143119.1054168-5-nivedita@alum.mit.edu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 26 Oct 2020 09:00:27 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF5yqtkOqOJmYHYbZr_uwMkef4VNdG_Y5PrKDdG3v_bRg@mail.gmail.com>
Message-ID: <CAMj1kXF5yqtkOqOJmYHYbZr_uwMkef4VNdG_Y5PrKDdG3v_bRg@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] crypto: lib/sha256 - Clear W[] in sha256_update()
 instead of sha256_transform()
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 25 Oct 2020 at 15:31, Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> The temporary W[] array is currently zeroed out once every call to
> sha256_transform(), i.e. once every 64 bytes of input data. Moving it to
> sha256_update() instead so that it is cleared only once per update can
> save about 2-3% of the total time taken to compute the digest, with a
> reasonable memset() implementation, and considerably more (~20%) with a
> bad one (eg the x86 purgatory currently uses a memset() coded in C).
>
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  lib/crypto/sha256.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index 099cd11f83c1..c6bfeacc5b81 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -43,10 +43,9 @@ static inline void BLEND_OP(int I, u32 *W)
>         W[I] = s1(W[I-2]) + W[I-7] + s0(W[I-15]) + W[I-16];
>  }
>
> -static void sha256_transform(u32 *state, const u8 *input)
> +static void sha256_transform(u32 *state, const u8 *input, u32 *W)
>  {
>         u32 a, b, c, d, e, f, g, h, t1, t2;
> -       u32 W[64];
>         int i;
>
>         /* load the input */
> @@ -200,15 +199,13 @@ static void sha256_transform(u32 *state, const u8 *input)
>
>         state[0] += a; state[1] += b; state[2] += c; state[3] += d;
>         state[4] += e; state[5] += f; state[6] += g; state[7] += h;
> -
> -       /* clear any sensitive info... */
> -       memzero_explicit(W, 64 * sizeof(u32));
>  }
>
>  void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
>  {
>         unsigned int partial, done;
>         const u8 *src;
> +       u32 W[64];
>
>         partial = sctx->count & 0x3f;
>         sctx->count += len;
> @@ -223,11 +220,13 @@ void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
>                 }
>
>                 do {
> -                       sha256_transform(sctx->state, src);
> +                       sha256_transform(sctx->state, src, W);
>                         done += 64;
>                         src = data + done;
>                 } while (done + 63 < len);
>
> +               memzero_explicit(W, sizeof(W));
> +
>                 partial = 0;
>         }
>         memcpy(sctx->buf + partial, src, len - done);
> --
> 2.26.2
>
