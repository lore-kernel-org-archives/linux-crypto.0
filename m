Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D04C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Dec 2021 23:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242492AbhLGXQc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Dec 2021 18:16:32 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56512 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242476AbhLGXQb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Dec 2021 18:16:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1C40CE1C1D
        for <linux-crypto@vger.kernel.org>; Tue,  7 Dec 2021 23:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DEFC341CA
        for <linux-crypto@vger.kernel.org>; Tue,  7 Dec 2021 23:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638918778;
        bh=C521PAlYmWz2ULzHtQhgz+JpcsC7Ym03fIlDA/4zVSE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bCUNLgIQYYEeiEZoiF2lFZ11KP9jHVWnDJk8KQTP0wINPNxV4gTPwG2rzMzb1KIW/
         LJ07f6wA1ssQCL8FlKWw2apucQFlfBSKJoPQx1PNJlDha4vgLvKtVzDTdx3vL7Hst0
         AgzuooagsbYH25pOGVcW8uksZQkj+3um/c5I2J3EzKtAZ8Mhs1xo8k0tsuQq3S1AyP
         xKKv8/6kDdDSrZgOeRpyxRrUdzk2atCWyXmI1qomoPEd8qqsZVz7sPyXjbc/MSEi3R
         6SwXMXIx79w5ARVlWZbnACVr+xhDl2BywEDbjOsiqzwhusMPfj9sumwuS+15OsKDtC
         RSEEK+DbDv7Tg==
Received: by mail-oi1-f170.google.com with SMTP id t23so1477462oiw.3
        for <linux-crypto@vger.kernel.org>; Tue, 07 Dec 2021 15:12:57 -0800 (PST)
X-Gm-Message-State: AOAM531nGREWZ7pCJx2vD0LCdTUNCwKjocz7gwyLw1DVWV0KiYHIjFhl
        DMZr/qhxpjZEQhN5XAGxe9TzczH9aUS7hC5Smxc=
X-Google-Smtp-Source: ABdhPJwLZCxyGckpSD7xFY/KBBIcet1OgLBL8+pQaSAuYpKBSL5EvJvOdAGaJSC4S1xTJLdP8KNcDflojebbUvqz5YM=
X-Received: by 2002:a05:6808:12:: with SMTP id u18mr8160076oic.174.1638918777241;
 Tue, 07 Dec 2021 15:12:57 -0800 (PST)
MIME-Version: 1.0
References: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 8 Dec 2021 00:12:45 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEZVFRbkVaDHm1fNkXmfnDwyYQ_r8kzFFrz7zw+m2dZ6A@mail.gmail.com>
Message-ID: <CAMj1kXEZVFRbkVaDHm1fNkXmfnDwyYQ_r8kzFFrz7zw+m2dZ6A@mail.gmail.com>
Subject: Re: x86 AES crypto alignment
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 7 Dec 2021 at 20:33, Jakub Kicinski <kuba@kernel.org> wrote:
>
> Hi!
>
> The x86 AES crypto (gcm(aes)) requires 16B alignment which is hard to
> achieve in networking. Is there any reason for this? On any moderately
> recent Intel platform aligned and unaligned vmovdq should have the same
> performance (reportedly).
>
> I'll hack it up and do some testing, but I thought it's worth asking
> first..

Most likely that whoever contributed the code originally cared more
about squeezing the last drop of performance out of it (on the
microarchitecture of the era) than about general usefulness in real
world scenarios.

So yes, please go ahead and remove this restriction: please use the
builtin randomized tests (CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y) which
should generate calls with misaligned plain/ciphertexts, IVs etc with
sufficient coverage.
