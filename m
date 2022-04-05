Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B158C4167B
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiDFBHy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572977AbiDERjX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Apr 2022 13:39:23 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9E7B8202
        for <linux-crypto@vger.kernel.org>; Tue,  5 Apr 2022 10:37:24 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id by7so32842ljb.0
        for <linux-crypto@vger.kernel.org>; Tue, 05 Apr 2022 10:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FbbKQlV6u6KKQgV3kF0cSGptF4idzq+5FojEhxitZgw=;
        b=dZ4XXEaJnpTbQNQk046zF6zDvjCUN0Cv1mS/hPtBMnKZaaN5nR3MO1fx0X2r36ErIJ
         NFjVv+WN61WB6ydyCfBXQab73AARWTP69mMuJ4Z1v/ekYSBKIDAbOp4JYqco+Bai/m9M
         xlyXw37jjONTNQfZFUJHuN1SQRQoNMyJtm2ac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FbbKQlV6u6KKQgV3kF0cSGptF4idzq+5FojEhxitZgw=;
        b=ZKvRvgPA2pI9Bvi8tNyYUPMW9DPr8B3Nz/GNUEJ3Tc3Jh+FzUY3iETclCy1LjRkom4
         /7afm5wdH9sl7Vd1+4wsPdDWVYgDXJwbffXy8SNsu/NEQBQhgdoud1xaffyFnri38muS
         toVEFy/lIyYPjFAkAnc+odsGsGFo/beRjyFGFk5MYHJvBX8fRPCuY0T6jyKbKE+sB2qb
         Efqw4dI8OFGfZY9qV9ib7PoObPurSWqA7YgHlafecxZ8Xnez9HsvLxPxVYiiYEAaIpsM
         DpBNbEMHoJKmkdKuvN+J030DTrHB7qdEEOCiZrbin2eZE61L9Ykv3bU2Phxs7GKvdt5o
         htOw==
X-Gm-Message-State: AOAM531M2FQTBZTY0cU+Ix6jhgGDAH51gH0zRP5DCgK+DkHp3tm/Dra7
        RJiG30zxhmUPpF6xcU1u6XA4XubL5Mv+4/9D6pg=
X-Google-Smtp-Source: ABdhPJzgiHCwN65DD4UZ3r+ep6fEaQatkV1UHRsdtOszwoFAO1or1s0DpkXlbuL1bd6S/eFwsZlVYg==
X-Received: by 2002:a2e:585c:0:b0:24b:d07:51c1 with SMTP id x28-20020a2e585c000000b0024b0d0751c1mr2861667ljd.119.1649180242274;
        Tue, 05 Apr 2022 10:37:22 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id k19-20020a056512331300b0044a8470fe29sm1568375lfe.19.2022.04.05.10.37.21
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 10:37:21 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id t25so24517709lfg.7
        for <linux-crypto@vger.kernel.org>; Tue, 05 Apr 2022 10:37:21 -0700 (PDT)
X-Received: by 2002:a05:6512:3c93:b0:44b:4ba:c334 with SMTP id
 h19-20020a0565123c9300b0044b04bac334mr3435604lfv.27.1649180241247; Tue, 05
 Apr 2022 10:37:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220405140906.222350-1-Jason@zx2c4.com>
In-Reply-To: <20220405140906.222350-1-Jason@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Apr 2022 10:37:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjFSsa7ZTFOiDCpZbwQsCKdAo3KFetSpGCjusqjjcb2XA@mail.gmail.com>
Message-ID: <CAHk-=wjFSsa7ZTFOiDCpZbwQsCKdAo3KFetSpGCjusqjjcb2XA@mail.gmail.com>
Subject: Re: [PATCH] random: opportunistically initialize on /dev/urandom reads
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 5, 2022 at 7:10 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Practically speaking, this means that at least on x86, /dev/urandom
> becomes safe. Probably other architectures with working cycle counters
> will also become safe. And architectures with slow or broken cycle
> counters at least won't be affected at all by this change.

I think this is a good change, as it's a bit pointless to warn about
uninitialized random data if we can just initialize it.

I do wonder if it wouldn't be better to perhaps move this all into
wait_for_random_bytes(), though, and add an argument to that function
for "no delay".

Because I think we should at the same time also add a warning to
wait_for_random_bytes() for the "uhhhuh, it timed out".

Right now wait_for_random_bytes() returns an error that most people
then just ignore. Including drivers/net/wireguard/cookie.c.

So instead of returning an error that nobody can do much about, how
about we move the warning code into wait_for_random_bytes()?

And make that urandom_read() call the same wait_for_random_bytes()
that random_read() calls, just with GRND_NONBLOCK as an argument?

Not a big deal. Your patch is fine by me too.

                    Linus
