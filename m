Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA64C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 10:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67E4A22BF5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 10:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598524930;
	bh=/ljKbVAPrePzEKLZQ+JKLYkGll/DYvgpO1ZR1rzsmIg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lcn6lkJKa3/Ju9dg8furqBLTvYE9f7s7xxOTCuvZPbGKWQuzEjFyNZXo3F3P2OGVR
	 f8++VWIU5SgKk7LmULCOOtcZnGW7QVs5nhsUHfOe0gjycpPYXHyCApoUzv0pWT0ZLq
	 oyeLcaRwbjg1Ips4dovt5K3WckSIxdYH3nTzKJ34=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgH0KmH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 06:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728222AbgH0KmG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 06:42:06 -0400
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B18622CAF;
        Thu, 27 Aug 2020 10:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598524925;
        bh=/ljKbVAPrePzEKLZQ+JKLYkGll/DYvgpO1ZR1rzsmIg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Pc0aVeHXA3IgL6z4uE6duJ7msAs1AW62fy0AbKNBLNUyByNWIThBHFFfJTWk4ja+z
         ThDRU+lUVGiX/5bIfJwNhqH7k/cL0KU3Mh63KE3IObdVgosIhGJXq/iIG2FYd/FVel
         CoZbw+3ALswo3uQT2r4COySsAT7I8AyWIvqHr1Ys=
Received: by mail-oo1-f42.google.com with SMTP id g1so1112493oop.11;
        Thu, 27 Aug 2020 03:42:05 -0700 (PDT)
X-Gm-Message-State: AOAM531Sgp79Q1beyXTFkDmdqFkLdfG6cqBgndtvEzTex9JwZNgtvn12
        UxDN4ZleBlI2JD4BfujAHtqwbIA+rwtbuJwXfZs=
X-Google-Smtp-Source: ABdhPJxGmEMhtRMvZgrZT6FuVBi6VqqwBOFMjYTZD9Z4EjlIaOKCVnzjYNkJJ+9IyUHCjHcdYxdIT34tEh7gdK8xdqo=
X-Received: by 2002:a4a:d816:: with SMTP id f22mr7865816oov.45.1598524924576;
 Thu, 27 Aug 2020 03:42:04 -0700 (PDT)
MIME-Version: 1.0
References: <202008271145.xE8qIAjp%lkp@intel.com> <20200827080558.GA3024@gondor.apana.org.au>
 <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com>
 <CAK8P3a3tjv78arTj75eKk5zYUhrGkPYRDLiqv3WJJC=U+Jia0Q@mail.gmail.com>
 <CAMj1kXHhmAdHjK5avXOySw43khzft1g8p48jX7aTeTC0FvS7tQ@mail.gmail.com> <CAK8P3a1nOL+BbvGAM3-aiH-mfzmFYgfFL2dWJKd8=Rw-WosP=w@mail.gmail.com>
In-Reply-To: <CAK8P3a1nOL+BbvGAM3-aiH-mfzmFYgfFL2dWJKd8=Rw-WosP=w@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 27 Aug 2020 12:41:53 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGpX+g_t4aAz5yGs-c+PG+NLnu1j9_QLJ6teWTjJ1FkMQ@mail.gmail.com>
Message-ID: <CAMj1kXGpX+g_t4aAz5yGs-c+PG+NLnu1j9_QLJ6teWTjJ1FkMQ@mail.gmail.com>
Subject: Re: lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes
 is larger than 1024 bytes
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Aug 2020 at 11:20, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Aug 27, 2020 at 10:42 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > In that case, I suppose we should simply disable instrumentation for
> > chacha_permute()? It is a straight-forward arithmetic transformation
> > on a u32[16] array, where ubsan has limited value afaict.
>
> I guess that always works as a last resort, but shouldn't we first try
> to figure out why ubsan even makes a difference and whether the
> object code without ubsan looks like a reasonable representation
> of the source form?
>
> Since it really is a fairly simple transformation, I would have
> expected the compiler to not emit any ubsan checks. If gcc
> only gets confused about the fixed offsets possibly overflowing
> the fixed-length array, maybe it helps to give it a little extra
> information like (untested):
>
> --- a/lib/crypto/chacha.c
> +++ b/lib/crypto/chacha.c
> @@ -13,7 +13,7 @@
>  #include <asm/unaligned.h>
>  #include <crypto/chacha.h>
>
> -static void chacha_permute(u32 *x, int nrounds)
> +static void chacha_permute(u32 x[16], int nrounds)
>  {
>         int i;
>

That does not help, unfortunately.

What does seem to work is

struct chacha_state { u32 x[16]; };

struct chacha_state chacha_permute(struct chacha_state st, int nrounds)
{
  struct chacha_state ret = st;
  u32 *x = ret.x;

  ...

  return st;
}

(and updating the caller accordingly, obviously)
