Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5352C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 19:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9906220820
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 19:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T5u3brS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfHLTiB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 15:38:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42835 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfHLTiB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 15:38:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id t132so49994013pgb.9
        for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2019 12:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WR1xNMurBLLA6YfMYoKDYGfmPGWBmM4BYdMt2Nd0Jy4=;
        b=T5u3brS8PDizcepwvlE+y29UANfuDWnRqgZwWb1XLHJPSfsHuW8VepYHOnbgyqnwcX
         KxNd/FS7ZwS6bQn+N3FMgL1SdrqGgVAOTQ8a6SgK6j0KW25NRiGbua+tqvdOXavCRaxy
         ysQ4nF+nqUkAz7bKPwK5civoSaMqRom5soxPONTpJzza+DKERaNMJy8fDBjQsIoywRvz
         ccjSmoFKVV2nqU44IQReP/kA8F4QYiDvVj1c7zw6PgtMWcre+leLK58uoKN7Ukxm5WD6
         zXKsgqkfs4P4077QRTA9AlTMNPVlpwJPL4p/4tYUiJ5UBLGw0jzTE4U1oAqTxXG+wTHq
         rx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WR1xNMurBLLA6YfMYoKDYGfmPGWBmM4BYdMt2Nd0Jy4=;
        b=LIj3C0wB3fA+BPESzZRQmZ8dcq1irZmA587Z74vQ+hs1XCsnTLvHi8fTyi007TqEYh
         CUy4DWseD2ZPrpyzGL5O+LVSotzL6Do/uOHK01BwvVv+Nv/UbmhGRfKtN4V7JI5ZU0HA
         cLLgbxEdtSzVWjF0UqnuIsvnQNXJghvZLYXSvZWt9T//Hm0PkqjGbNlVoyDDVkv+MtWl
         Si+a3rFsd6Vp6bIIePUGQllOEJPbRWfNP644kq+BY0SyZrt+eh3vsEgiiVH11PKwzrOy
         9Eal9ubFgIu0CRdlaCbLwib8tu0cDfLgEw8NxBGhR0GAjoVBW9gt/5ORvh65m1wigjdf
         o1Yg==
X-Gm-Message-State: APjAAAWxF8oczBMIdmsNT95nxDV8slEXnLh9MhyBUjowkJbqrS3P4uwc
        oXfadEzkdGHTvJoqX0EOmtmeyURHC3kj9u62g+9gcg==
X-Google-Smtp-Source: APXvYqymx0WwYkoqYrEt9Rm0iUVkV7VpPVoYSGOIzq24JC7wLNajuws27Vy+jaADp5jIo8WQBMm41EoWnfnf2OJgMj0=
X-Received: by 2002:aa7:8085:: with SMTP id v5mr19988296pff.165.1565638679763;
 Mon, 12 Aug 2019 12:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190812193256.55103-1-natechancellor@gmail.com>
In-Reply-To: <20190812193256.55103-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 12 Aug 2019 12:37:48 -0700
Message-ID: <CAKwvOdkScTZpiCnb_HBcnMLssBZ-WT7g+ir5R+uMWWZE_QA2Vw@mail.gmail.com>
Subject: Re: [PATCH v2] lib/mpi: Eliminate unused umul_ppmm definitions for MIPS
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-mips@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 12, 2019 at 12:36 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang errors out when building this macro:
>
> lib/mpi/generic_mpih-mul1.c:37:24: error: invalid use of a cast in a
> inline asm context requiring an l-value: remove the cast or build with
> -fheinous-gnu-extensions
>                 umul_ppmm(prod_high, prod_low, s1_ptr[j], s2_limb);
>                 ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> lib/mpi/longlong.h:652:20: note: expanded from macro 'umul_ppmm'
>         : "=l" ((USItype)(w0)), \
>                 ~~~~~~~~~~^~~
> lib/mpi/generic_mpih-mul1.c:37:3: error: invalid output constraint '=h'
> in asm
>                 umul_ppmm(prod_high, prod_low, s1_ptr[j], s2_limb);
>                 ^
> lib/mpi/longlong.h:653:7: note: expanded from macro 'umul_ppmm'
>              "=h" ((USItype)(w1)) \
>              ^
> 2 errors generated.
>
> The C version that is used for GCC 4.4 and up works well with clang;
> however, it is not currently being used because Clang masks itself
> as GCC 4.2.1 for compatibility reasons. As Nick points out, we require
> GCC 4.6 and newer in the kernel so we can eliminate all of the
> versioning checks and just use the C version of umul_ppmm for all
> supported compilers.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/605
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

LGTM thanks Nathan.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>
> This supersedes the following two patches:
>
> https://lore.kernel.org/lkml/20190812033120.43013-4-natechancellor@gmail.com/
>
> https://lore.kernel.org/lkml/20190812033120.43013-5-natechancellor@gmail.com/
>
> I labelled this as a v2 so those don't get applied.
>
>  lib/mpi/longlong.h | 36 +-----------------------------------
>  1 file changed, 1 insertion(+), 35 deletions(-)
>
> diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
> index 3bb6260d8f42..2dceaca27489 100644
> --- a/lib/mpi/longlong.h
> +++ b/lib/mpi/longlong.h
> @@ -639,30 +639,12 @@ do { \
>         **************  MIPS  *****************
>         ***************************************/
>  #if defined(__mips__) && W_TYPE_SIZE == 32
> -#if (__GNUC__ >= 5) || (__GNUC__ >= 4 && __GNUC_MINOR__ >= 4)
>  #define umul_ppmm(w1, w0, u, v)                        \
>  do {                                           \
>         UDItype __ll = (UDItype)(u) * (v);      \
>         w1 = __ll >> 32;                        \
>         w0 = __ll;                              \
>  } while (0)
> -#elif __GNUC__ > 2 || __GNUC_MINOR__ >= 7
> -#define umul_ppmm(w1, w0, u, v) \
> -       __asm__ ("multu %2,%3" \
> -       : "=l" ((USItype)(w0)), \
> -            "=h" ((USItype)(w1)) \
> -       : "d" ((USItype)(u)), \
> -            "d" ((USItype)(v)))
> -#else
> -#define umul_ppmm(w1, w0, u, v) \
> -       __asm__ ("multu %2,%3\n" \
> -          "mflo %0\n" \
> -          "mfhi %1" \
> -       : "=d" ((USItype)(w0)), \
> -            "=d" ((USItype)(w1)) \
> -       : "d" ((USItype)(u)), \
> -            "d" ((USItype)(v)))
> -#endif
>  #define UMUL_TIME 10
>  #define UDIV_TIME 100
>  #endif /* __mips__ */
> @@ -687,7 +669,7 @@ do {                                                                        \
>                  : "d" ((UDItype)(u)),                                  \
>                    "d" ((UDItype)(v)));                                 \
>  } while (0)
> -#elif (__GNUC__ >= 5) || (__GNUC__ >= 4 && __GNUC_MINOR__ >= 4)
> +#else
>  #define umul_ppmm(w1, w0, u, v) \
>  do {                                                                   \
>         typedef unsigned int __ll_UTItype __attribute__((mode(TI)));    \
> @@ -695,22 +677,6 @@ do {                                                                       \
>         w1 = __ll >> 64;                                                \
>         w0 = __ll;                                                      \
>  } while (0)
> -#elif __GNUC__ > 2 || __GNUC_MINOR__ >= 7
> -#define umul_ppmm(w1, w0, u, v) \
> -       __asm__ ("dmultu %2,%3" \
> -       : "=l" ((UDItype)(w0)), \
> -            "=h" ((UDItype)(w1)) \
> -       : "d" ((UDItype)(u)), \
> -            "d" ((UDItype)(v)))
> -#else
> -#define umul_ppmm(w1, w0, u, v) \
> -       __asm__ ("dmultu %2,%3\n" \
> -          "mflo %0\n" \
> -          "mfhi %1" \
> -       : "=d" ((UDItype)(w0)), \
> -            "=d" ((UDItype)(w1)) \
> -       : "d" ((UDItype)(u)), \
> -            "d" ((UDItype)(v)))
>  #endif
>  #define UMUL_TIME 20
>  #define UDIV_TIME 140
> --
> 2.23.0.rc2
>


-- 
Thanks,
~Nick Desaulniers
