Return-Path: <SRS0=GKHD=M7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C29DECDE3D
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Oct 2018 14:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6B602064A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Oct 2018 14:13:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="UrgKOh2/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6B602064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbeJSWTV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Oct 2018 18:19:21 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44453 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbeJSWTU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Oct 2018 18:19:20 -0400
Received: by mail-io1-f67.google.com with SMTP id s6-v6so12488226ioa.11
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2018 07:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=l3f+Ww9h8FY+AielolXxFK472lMmil5XO+Su6/BhXBk=;
        b=UrgKOh2/U3khpvFoBF3DEVczuR9dj0q5qS6fqogVFF+3CrlDPb4hzVxVymm52Xbycc
         9jriIv3wYOIbkfqbkAC8QNylWDErmwBbV5mKN4G21lh+v2nzTRah+BD2BtN7FcDDHgTr
         Clq9/70bT93geux22j6e27l2vZnTtcfzklVEc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=l3f+Ww9h8FY+AielolXxFK472lMmil5XO+Su6/BhXBk=;
        b=PEJc81vMe698pbhP8/sza2zr87UNn2WK8+52siByh3JVu+yuEvjfr7t7+cFrtLes7e
         TYExUWaFdykcTSjHM2+cFZdFU+YWUBbmOMnP1tvfiorZadzll66bdZN7QzyU+PA5z8TC
         MyhwAM/7rNi+p1V8tpHIM62d9/3DW5BTVpr+RUc17Cij4jHij+iTaSylhW547O7BQMq4
         Z5/RnRwZuS9Tzhx/vQ//F/g8/xwbzHyMZallLdICRs9fFhc2vLfNOAOvfTIRvzXEqZvU
         vtAgPPyu47PSQ/0RxSP3p0nGPI5eGtn3VnytZ3JW6oYyJZHcGQ337ZoEwbnedBmLJMIO
         d8Zw==
X-Gm-Message-State: AGRZ1gJVa5jRN8Q43UdRITY8ycpGg9Z6+jpB49ZD/F+KVh3b501JvKrb
        D3uOiNC9i0PKgf1vjQPLv1nnqtOp8rCe6Kusf9fxfQ==
X-Google-Smtp-Source: AJdET5fdqu1Qe8tCxePlrVmMYYPiaFYJE/EIzNjBNuU0J4uuhz7E+OWaMtD9h6sHeMswrP5rRk33SXCXL0sC+AS8ZXc=
X-Received: by 2002:a6b:be83:: with SMTP id o125-v6mr2979329iof.173.1539958381127;
 Fri, 19 Oct 2018 07:13:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Fri, 19 Oct 2018 07:13:00
 -0700 (PDT)
In-Reply-To: <20181015175424.97147-2-ebiggers@kernel.org>
References: <20181015175424.97147-1-ebiggers@kernel.org> <20181015175424.97147-2-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 19 Oct 2018 22:13:00 +0800
Message-ID:
 <CAKv+Gu8bYc_Ex4HjSasbBksj=w1KubVHtvWR=Wq1-65FPw8XBw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 01/12] crypto: chacha20-generic - add HChaCha20
 library function
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kaiser <gkaiser@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Michael Halcrow <mhalcrow@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181019141300.MYtNEmOZF4nnaQs4EZ_By4FT6SBMeGkcHhk8IpTtvf4@z>

On 16 October 2018 at 01:54, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Refactor the unkeyed permutation part of chacha20_block() into its own
> function, then add hchacha20_block() which is the ChaCha equivalent of
> HSalsa20 and is an intermediate step towards XChaCha20 (see
> https://cr.yp.to/snuffle/xsalsa-20081128.pdf).  HChaCha20 skips the
> final addition of the initial state, and outputs only certain words of
> the state.  It should not be used for streaming directly.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  include/crypto/chacha20.h |  2 ++
>  lib/chacha20.c            | 50 ++++++++++++++++++++++++++++++++++-----
>  2 files changed, 46 insertions(+), 6 deletions(-)
>
> diff --git a/include/crypto/chacha20.h b/include/crypto/chacha20.h
> index f76302d99e2be..fbec4e6a87890 100644
> --- a/include/crypto/chacha20.h
> +++ b/include/crypto/chacha20.h
> @@ -19,6 +19,8 @@ struct chacha20_ctx {
>  };
>
>  void chacha20_block(u32 *state, u8 *stream);
> +void hchacha20_block(const u32 *in, u32 *out);
> +
>  void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv);
>  int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
>                            unsigned int keysize);
> diff --git a/lib/chacha20.c b/lib/chacha20.c
> index d907fec6a9ed1..6a484e16171d1 100644
> --- a/lib/chacha20.c
> +++ b/lib/chacha20.c
> @@ -1,5 +1,5 @@
>  /*
> - * ChaCha20 256-bit cipher algorithm, RFC7539
> + * The "hash function" used as the core of the ChaCha20 stream cipher (RFC7539)
>   *
>   * Copyright (C) 2015 Martin Willi
>   *
> @@ -16,14 +16,10 @@
>  #include <asm/unaligned.h>
>  #include <crypto/chacha20.h>
>
> -void chacha20_block(u32 *state, u8 *stream)
> +static void chacha20_permute(u32 *x)
>  {
> -       u32 x[16];
>         int i;
>
> -       for (i = 0; i < ARRAY_SIZE(x); i++)
> -               x[i] = state[i];
> -
>         for (i = 0; i < 20; i += 2) {
>                 x[0]  += x[4];    x[12] = rol32(x[12] ^ x[0],  16);
>                 x[1]  += x[5];    x[13] = rol32(x[13] ^ x[1],  16);
> @@ -65,6 +61,25 @@ void chacha20_block(u32 *state, u8 *stream)
>                 x[8]  += x[13];   x[7]  = rol32(x[7]  ^ x[8],   7);
>                 x[9]  += x[14];   x[4]  = rol32(x[4]  ^ x[9],   7);
>         }
> +}
> +
> +/**
> + * chacha20_block - generate one keystream block and increment block counter
> + * @state: input state matrix (16 32-bit words)
> + * @stream: output keystream block (64 bytes)
> + *
> + * This is the ChaCha20 core, a function from 64-byte strings to 64-byte
> + * strings.  The caller has already converted the endianness of the input.  This
> + * function also handles incrementing the block counter in the input matrix.
> + */
> +void chacha20_block(u32 *state, u8 *stream)
> +{
> +       u32 x[16];
> +       int i;
> +
> +       memcpy(x, state, 64);
> +
> +       chacha20_permute(x);
>
>         for (i = 0; i < ARRAY_SIZE(x); i++)
>                 put_unaligned_le32(x[i] + state[i], &stream[i * sizeof(u32)]);
> @@ -72,3 +87,26 @@ void chacha20_block(u32 *state, u8 *stream)
>         state[12]++;
>  }
>  EXPORT_SYMBOL(chacha20_block);
> +
> +/**
> + * hchacha20_block - abbreviated ChaCha20 core, for XChaCha20
> + * @in: input state matrix (16 32-bit words)
> + * @out: output (8 32-bit words)
> + *
> + * HChaCha20 is the ChaCha equivalent of HSalsa20 and is an intermediate step
> + * towards XChaCha20 (see https://cr.yp.to/snuffle/xsalsa-20081128.pdf).
> + * HChaCha20 skips the final addition of the initial state, and outputs only
> + * certain words of the state.  It should not be used for streaming directly.
> + */
> +void hchacha20_block(const u32 *in, u32 *out)
> +{
> +       u32 x[16];
> +
> +       memcpy(x, in, 64);
> +
> +       chacha20_permute(x);
> +
> +       memcpy(&out[0], &x[0], 16);
> +       memcpy(&out[4], &x[12], 16);
> +}
> +EXPORT_SYMBOL(hchacha20_block);
> --
> 2.19.1.331.ge82ca0e54c-goog
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
