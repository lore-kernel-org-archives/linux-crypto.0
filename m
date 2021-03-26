Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FE4C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 09:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB67761A4E
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 09:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCZJAT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 05:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230047AbhCZJAD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 05:00:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A8C561A2D;
        Fri, 26 Mar 2021 09:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616749202;
        bh=BytiXbj/TI2Y6bLD7dAIqISbumXs7KF7S0Okv0JEllM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=p2wMHTXvzFV9/EtswLeqg8pxJ6Mny2YBygtxAqOcEq2ByvbS3Qf2yp0gJMRRiw219
         a9QZRpaQycP9kh2/wjQKkP4DKkhxZ6TzUc7W7hzfXf+ZOz+QDtOxoOQasBjcbY6b/5
         r+ySatz3QDruwEqzdDCwzEn/0zBGR1kJ0inYJzWfWxas5rvZxcS2jIKrjGofe6hrkN
         kn5/VggtuJ8yFigDZZyyemRnh+5jGLUpPBEGZAW+qjpeahu54kapeC3FHrXP0iZBuA
         JsKrzYWy131+bnA9R2WDiBkRqIFBGgoGjomkaUzXZ0FnmQQP9dwvDI4wZdo1P6fa3u
         Pmvfjtb1v366Q==
Received: by mail-oi1-f172.google.com with SMTP id a8so5003620oic.11;
        Fri, 26 Mar 2021 02:00:02 -0700 (PDT)
X-Gm-Message-State: AOAM531KYK+cLlgd6fArSL3+52pGfnwRauyj6wSwR2QJ5aE1MkTzTCnF
        KvFCnco4Re0g1oMrUD0IL9nUipoPec/q5E5KnDw=
X-Google-Smtp-Source: ABdhPJzp8IuSQW4rapWXFk89ZskcCKI+yA1E0c6s7WalEpEJqlbjK/8KjS41VOmC0D2PZJlLf2ZXpPwaC61OOGGpnUE=
X-Received: by 2002:aca:7c4:: with SMTP id 187mr8490773oih.47.1616749201697;
 Fri, 26 Mar 2021 02:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210326022128.71727-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20210326022128.71727-1-tianjia.zhang@linux.alibaba.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 26 Mar 2021 09:59:50 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEqQLhg_JHiZZG0Vzf7ijVHARpta_9yFqyONtVJYj_4fQ@mail.gmail.com>
Message-ID: <CAMj1kXEqQLhg_JHiZZG0Vzf7ijVHARpta_9yFqyONtVJYj_4fQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: sm3 - use the more precise type u32 instead of
 unsigned int
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@google.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 26 Mar 2021 at 03:22, Tianjia Zhang
<tianjia.zhang@linux.alibaba.com> wrote:
>
> In the process of calculating the hash, use the more accurate type
> 'u32' instead of the original 'unsigned int' to avoid ambiguity.
>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

I don't see the point of this patch. u32 and unsigned int are always
the same type, regardless of architecture.


> ---
>  crypto/sm3_generic.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/crypto/sm3_generic.c b/crypto/sm3_generic.c
> index 193c4584bd00..562e96f92f64 100644
> --- a/crypto/sm3_generic.c
> +++ b/crypto/sm3_generic.c
> @@ -36,17 +36,17 @@ static inline u32 p1(u32 x)
>         return x ^ rol32(x, 15) ^ rol32(x, 23);
>  }
>
> -static inline u32 ff(unsigned int n, u32 a, u32 b, u32 c)
> +static inline u32 ff(u32 n, u32 a, u32 b, u32 c)
>  {
>         return (n < 16) ? (a ^ b ^ c) : ((a & b) | (a & c) | (b & c));
>  }
>
> -static inline u32 gg(unsigned int n, u32 e, u32 f, u32 g)
> +static inline u32 gg(u32 n, u32 e, u32 f, u32 g)
>  {
>         return (n < 16) ? (e ^ f ^ g) : ((e & f) | ((~e) & g));
>  }
>
> -static inline u32 t(unsigned int n)
> +static inline u32 t(u32 n)
>  {
>         return (n < 16) ? SM3_T1 : SM3_T2;
>  }
> @@ -54,7 +54,7 @@ static inline u32 t(unsigned int n)
>  static void sm3_expand(u32 *t, u32 *w, u32 *wt)
>  {
>         int i;
> -       unsigned int tmp;
> +       u32 tmp;
>
>         /* load the input */
>         for (i = 0; i <= 15; i++)
> @@ -123,8 +123,8 @@ static void sm3_compress(u32 *w, u32 *wt, u32 *m)
>
>  static void sm3_transform(struct sm3_state *sst, u8 const *src)
>  {
> -       unsigned int w[68];
> -       unsigned int wt[64];
> +       u32 w[68];
> +       u32 wt[64];
>
>         sm3_expand((u32 *)src, w, wt);
>         sm3_compress(w, wt, sst->state);
> --
> 2.19.1.3.ge56e4f7
>
