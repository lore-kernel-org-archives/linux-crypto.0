Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A13C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Feb 2022 03:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348737AbiBCDwD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Feb 2022 22:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbiBCDwD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Feb 2022 22:52:03 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E0AC061714
        for <linux-crypto@vger.kernel.org>; Wed,  2 Feb 2022 19:52:00 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id s13so4091893ejy.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Feb 2022 19:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m2NpCdffal2NM8QxGZm99H1Q344S1Vf+6X/vcLSmSRo=;
        b=lsdyl9TVvQljXdwmbJ5EJoiDktSzWrKtzUmF3wvx+4+BJvfuLZSKy6Ybspe1DWoxVN
         Tbk9Ghs/caJeSP3RT1PnZoz18HDRQzRm1YUjnOVpz4ZrFGOOTPabWysvtvdtkSSP0yHz
         LSrg8AXEZhxRssXfSMbMnA9wcrhW1Kx+RHoDsjeXmHT5viyWlfRw9jOUtjhL7zxj78lj
         Nncbvu+3iE0I0oQsMQHaPaWP6IEp9k62WKlJxYYesX86GltLDZBzpTe1MZt+cvx53BNt
         3HCz91+so8JlFD0qgfqo6OOWlvt8vwLUrYnjHxdVKshWrvyHglMqVHJjIQOKA8QzHvCP
         Z3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m2NpCdffal2NM8QxGZm99H1Q344S1Vf+6X/vcLSmSRo=;
        b=hzrpD+tJGzLyGYHx2aaJgxLzUM6RgzvbZSdXR0+9r/+TBN98JSry03PmdyD78Boarj
         ztUBRfsX2KrK7OLb1yNbR1O/C+kmobjizkunTI/tuIxLycDFORoccBfmxwoBRnzmD7Z8
         elNxUKl7rV2rFUSQkFIra7QP+TiWqvmPkEjBlaA7Q0kY7BF+4XoKto8pjcdzcQDrSLx3
         z2Vs1Op8pmLcEuzImvWVhuOAQNfGgE2yk5M7m5DpuZMTno6E404LzKcG9Ih60R7NxM6Q
         goOjj0334qYB0hqpkrT4qGu84KNGjRiG2WKfxmTfE55InOiTmZzvFWdKoRPYi7ksj3/y
         2/6g==
X-Gm-Message-State: AOAM531gPvK2erv6JhGRIIEpSQWA8kXBGE1XUuG5dA08k6RB0SVwPfht
        Fmjoto8I60h4OqSr+YDEIwzHjqOJ1d42uUsJD0aFlnlZASU=
X-Google-Smtp-Source: ABdhPJzKV6Rwt4RlkQABXiziWc5btJO7hMaZ0RY34dJ0aUvliJWvtD6Vi4FcZQ9CEQsoaCDtjwMdoM/GpC29rWg8mWQ=
X-Received: by 2002:a17:906:5d16:: with SMTP id g22mr27625566ejt.753.1643860297467;
 Wed, 02 Feb 2022 19:51:37 -0800 (PST)
MIME-Version: 1.0
References: <CACXcFmnPumpkfLLzzjqkBmxwtpMa0izNj3LOtf2ycTugAKAUwQ@mail.gmail.com>
 <CAHmME9pUW1o_QPfs45Q0JWucA5Qu1jhgMV7x2PycxosYV2wV7A@mail.gmail.com>
 <CACXcFmk049OXc16ynjHBa+OSEOMYB=nYE1MDM_oM=Maf8bfcEA@mail.gmail.com> <YflZw7B1F41KpJ0K@mit.edu>
In-Reply-To: <YflZw7B1F41KpJ0K@mit.edu>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 3 Feb 2022 11:51:25 +0800
Message-ID: <CACXcFmkAiqg--ibgMNUQ_JWaK9RuskH1sWgUya0ZpmHxAKPyPg@mail.gmail.com>
Subject: Re: [PATCH] random.c Remove locking in extract_buf()
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        m@ib.tc, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > Yes, but the right way to do that is to lock the chacha context
> > in the reseed function and call extract_buf() while that lock
> > is held. I'll send a patch for that soon.
>
> Extract_buf() is supposed to be able to reliably generate high quality
> randomness; that's why we use it for the chacha reseed.  If
> extract_buf() can return return the same value for two parallel calls
> to extract_buf(), that's a Bad Thing.

I agree completely.

> For example, suppose there were
> two chacha contexts reseeding using extract_buf(), and they were
> racing against each other on two different CPU's.  Having two of them
> reseed with the same value would be a cryptographic weakness.

This confuses me a bit. Are you saying two CPUs can have
different primary chacha contexts but reseed from the same
input pool? Why? Reading the code, I thought there'd be
only one primary crng & others would reseed from it.

> NACK to both patches.

OK, but as Mike wrote in the thread he started about his
proposed lockless driver:

" It is highly unusual that /dev/random is allowed to degrade the
" performance of all other subsystems - and even bring the
" system to a halt when it runs dry.  No other kernel feature
" is given this dispensation,

I don't think a completely lockless driver is at all a good
idea & I think he overstates the point a bit in the quoted
text. But I do think he has a point. Locking the input pool
while extract_buf() reads & hashes it seems wrong to me
because it can unnecessarily block other processes.

crng_reseed() already locks the crng context. My patch
(which I probably will not now write since it has already got
a NACK) would make it call extract_buf() while holding that
lock, which prevents any problem of duplicate outputs but
avoids locking the input pool during the hash.

If my proposed patch would be unacceptable, it seems
worth asking if there is a better way to eliminate the
unnecessary lock.
