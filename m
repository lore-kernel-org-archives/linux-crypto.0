Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA87C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 15:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378003AbhKZPX2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 10:23:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38446 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378018AbhKZPV2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 10:21:28 -0500
X-Greylist: delayed 2675 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 10:21:26 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C80CE62280;
        Fri, 26 Nov 2021 15:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E064C53FC1;
        Fri, 26 Nov 2021 15:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637939892;
        bh=KqLeMrkFcEUdBWWY9yYV30jYMt3Gtp2Y9CSAIt/EtuE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sjHwDtzSvrTgRRpHhwrx7gKq2r7mtdZYVYeWY8849BtrLMReLQ8P0J05Piagq7KOs
         o1+Sd4QdFwnX683gEr/SZI6f96x7ShEanwPo5Lb4p6m+RcH4oFH3GeC+zu4iYVnijE
         vPT0Wc+Bno3Als49CjwCU/Fh2sIpOlOagXu2MMtLaLvV9Yvqh0jB9p7y9SZJR6pFMy
         YLXWAZ2KrcZJDxegeOoV1vjYRQkQ0NCeJ7yluU4ZwlcQyiBT+ndE4jdFEBGEBeh+Vf
         rcV/T49sJCDQIYbbiJyNz9piESOsLSjAG3lX7MTD7OzgWOO2geo25nv9aLXwEZAPOH
         bpcGO6XfY8WJg==
Received: by mail-wm1-f54.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so7028205wme.4;
        Fri, 26 Nov 2021 07:18:12 -0800 (PST)
X-Gm-Message-State: AOAM530/4yzP+VALA8oC5BSU1+o0nscnRN2JucJxXWkw0ymfcS6fn3fb
        BlukxqWym51z0HZqK8y5n0XORlrTU6ZJ6g/L9BY=
X-Google-Smtp-Source: ABdhPJzIbjg+Owk4hwlM6I0zZ86kIhnx52S92JKWkcDH00LeUrnkgXZJiSde8mO2+m3DNJxz2fCgVwqDq+nvLCgrMxk=
X-Received: by 2002:a7b:c007:: with SMTP id c7mr16367114wmb.82.1637939890403;
 Fri, 26 Nov 2021 07:18:10 -0800 (PST)
MIME-Version: 1.0
References: <20211126143329.2689618-1-arnd@kernel.org> <CAHmME9rotnZRzqeD43FJmSX6-i2CwvUVpXHrFkLGt+qVVdxK7A@mail.gmail.com>
In-Reply-To: <CAHmME9rotnZRzqeD43FJmSX6-i2CwvUVpXHrFkLGt+qVVdxK7A@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 26 Nov 2021 16:17:54 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2KfmmGDbVHULWevB0hv71P2oi2ZCHEAqT=8dQfa0=cqQ@mail.gmail.com>
Message-ID: <CAK8P3a2KfmmGDbVHULWevB0hv71P2oi2ZCHEAqT=8dQfa0=cqQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: siphash - use _unaligned version by default
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 26, 2021 at 4:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Arnd,
>
> It looks like Ard's old patch never got picked up so you're dusting it
> off. It looks like you're doing two things here -- moving from an
> ifndef to a much nicer IS_ENABLED, and changing the logic a bit. In
> trying to understand the logic part, I changed this in my buffer:

I actually found the issue independently and came up with this patch
before Ard pointed me to his patch, I mainly took the description of the
problem from him, as his explanation was already well written.

> -#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> -       if (!IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
> +       if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
> +           !IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
>                 return __hsiphash_unaligned(data, len, key);
>         return ___hsiphash_aligned(data, len, key);
>
> into this:
>
> -       if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
> -           !IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
> +       if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
> +           !IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
>                 return __hsiphash_unaligned(data, len, key);
>         return ___hsiphash_aligned(data, len, key);
>
> This way I can actually think about what's happening here.
>
> So with the old one, we use the faster aligned version if *either* the
> CPU has efficient unaligned access OR the bytes are statically known
> to be aligned. This seems sensible.
>
> On the new one, we use the faster aligned version if *both* the bytes
> are statically known to be aligned (ok) AND the CPU doesn't actually
> support efficient unaligned accesses (?). This seems kind of weird.

Yes, this is intentional. The point is that __hsiphash_unaligned() is
the portable version that works with any alignment on any architecture,
while __hsiphash_aligned() is either identical, or may only be called
with aligned data. Passing an unaligned pointer into this function triggers
undefined behavior in C99, which is how it broke on armv7, but in fact
any compiler might optimize this function based on "knowing" that
the lower address bits are zero.

> It also means that CPUs with fast aligned accesses wind up calling the
> slower code path in some cases. Is your supposition that the compiler
> will always optimize the slow codepath to the fast one if the CPU it's
> compiling for supports that? Have you tested this on all platforms?

I have not tested this specific patch on all platforms, but I did
extensive testing of the get_unaligned()/put_unaligned() helpers
in my rewrite earlier this year[1], making sure that these are NOPs
on all the important architectures, and that they prevent the use
of trapping ldrd/ldm instructions on ARMv6/ARMv7.

> Would it make sense to instead just fix clang-13? Or even to just get
> rid of CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS for armv6 or undef
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS for armv6 just in this file or
> maybe less messy, split CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS into
> two ifdefs that more sense for our usage?

Clang is actually doing the right thing here, it may be considered a missed
optimization that gcc uses two loads instead of a combined ldm or ldrd ;-)

FWIW, the bug that we saw in the decompressor relying on data alignment on x86
earlier this year only happened on gcc.

      Arnd

[1] https://lkml.org/lkml/2021/5/7/775
