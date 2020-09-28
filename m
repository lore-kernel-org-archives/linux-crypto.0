Return-Path: <SRS0=0P/0=DF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB71C2D0A8
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Sep 2020 23:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E836B207D8
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Sep 2020 23:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Hh/PAUyr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgI1XsB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI1XsB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Sep 2020 19:48:01 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98334C0613D3
        for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2020 16:47:59 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id w25so1860556vsk.9
        for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2020 16:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzBJEc2rfX+SRBe+kzCS76t/grRjnOGOEK+9vtZKuhE=;
        b=Hh/PAUyrwAagfQLLcZ4fY28lldnXGopLLC7d7SduXmUiNSjuvkku3ih7Oxk04TqA7f
         /S+IvqMXIQWVqnZCPK3jfcSiNadQlW0uY/iL5vXGKU8zaKdEp49YXSn4REWcg/0/CSA1
         YDGI8w0aXG0uKYUXlolZnF0VpCZe3BU96yv+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzBJEc2rfX+SRBe+kzCS76t/grRjnOGOEK+9vtZKuhE=;
        b=iAEJo70o5JGgFK91lmEkJN6FYbmdumwF6SiZjd9Bhrkyn9DczesUkwm/tLgDYT7x7s
         52QBRlcIe/dn46QC3jjw2orfF+JCATh3HT6OkFhXdy+Mk8zI0Pv1POhrCGIEaRp0WGsE
         s9YYPS9+PS8YgeURlNUYH4f2DbIgKHxyWDN0glpGjHO4QbAf4FbQic2tRjSZY3fNnDha
         1yc22/T/wg2PZUpQF0evo4AEMT36eax1LKqf3FznSD2tF0vR6RhQfaUC4c7Ajzk/6IYt
         o8VqXRyi1achHQMTFVGVYJZPgQjy/HcBgUQOktymDymq57VLXuvblZ9u8LmXGuWdIy8+
         W4pg==
X-Gm-Message-State: AOAM530hnbTgQ6fVbZ9LrniVtBKba8uuhjH2MWa50xXrq2lgquYjo04N
        dJ4z5HZsFXM/dzIBRSc4Y4lWdbp9PQ/k7w==
X-Google-Smtp-Source: ABdhPJwNFyTprx5zs7HF1d4Ex7Svhb8iMpKY29RJPDCcYqdzdcQtEkW5mq3+G+iJTIJU7dG4lJlzQw==
X-Received: by 2002:a67:bd12:: with SMTP id y18mr1357719vsq.45.1601336878472;
        Mon, 28 Sep 2020 16:47:58 -0700 (PDT)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id j4sm280898uan.20.2020.09.28.16.47.57
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 16:47:57 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id z1so2807001uaa.6
        for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2020 16:47:57 -0700 (PDT)
X-Received: by 2002:ab0:2ea1:: with SMTP id y1mr2453341uay.104.1601336877206;
 Mon, 28 Sep 2020 16:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200926102651.31598-1-ardb@kernel.org> <20200926102651.31598-3-ardb@kernel.org>
In-Reply-To: <20200926102651.31598-3-ardb@kernel.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 28 Sep 2020 16:47:45 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WGnm2bSe-1yJ46yLHv43Grpse6DXC7CFaWMd_W9--EGw@mail.gmail.com>
Message-ID: <CAD=FV=WGnm2bSe-1yJ46yLHv43Grpse6DXC7CFaWMd_W9--EGw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: xor - use ktime for template benchmarking
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Sat, Sep 26, 2020 at 3:27 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Currently, we use the jiffies counter as a time source, by staring at
> it until a HZ period elapses, and then staring at it again and perform
> as many XOR operations as we can at the same time until another HZ
> period elapses, so that we can calculate the throughput. This takes
> longer than necessary, and depends on HZ, which is undesirable, since
> HZ is system dependent.
>
> Let's use the ktime interface instead, and use it to time a fixed
> number of XOR operations, which can be done much faster, and makes
> the time spent depend on the performance level of the system itself,
> which is much more reasonable. To ensure that we have the resolution
> we need even on systems with 32 kHz time sources, while not spending too
> much time in the benchmark on a slow CPU, let's switch to 3 attempts of
> 800 repetitions each: that way, we will only misidentify algorithms that
> perform within 10% of each other as the fastest if they are faster than
> 10 GB/s to begin with, which is not expected to occur on systems with
> such coarse clocks.
>
> On ThunderX2, I get the following results:
>
> Before:
>
>   [72625.956765] xor: measuring software checksum speed
>   [72625.993104]    8regs     : 10169.000 MB/sec
>   [72626.033099]    32regs    : 12050.000 MB/sec
>   [72626.073095]    arm64_neon: 11100.000 MB/sec
>   [72626.073097] xor: using function: 32regs (12050.000 MB/sec)
>
> After:
>
>   [72599.650216] xor: measuring software checksum speed
>   [72599.651188]    8regs           : 10491 MB/sec
>   [72599.652006]    32regs          : 12345 MB/sec
>   [72599.652871]    arm64_neon      : 11402 MB/sec
>   [72599.652873] xor: using function: 32regs (12345 MB/sec)

What are the chances of 12345 coming up?  ;-)

>
> Link: https://lore.kernel.org/linux-crypto/20200923182230.22715-3-ardb@kernel.org/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/xor.c | 38 +++++++++-----------
>  1 file changed, 16 insertions(+), 22 deletions(-)

This looks good to me.  Thanks for taking this on!

Reviewed-by: Douglas Anderson <dianders@chromium.org>
