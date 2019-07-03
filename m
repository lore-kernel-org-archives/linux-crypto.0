Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD898C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 18:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9995B2080C
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 18:22:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NYwMoQRq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGCSWH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 14:22:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54836 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCSWH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 14:22:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so161701wme.4
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jul 2019 11:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KAJLoXmtlUGTIhQz/R8IxrT9lql92ArMXqcy3RaeD8g=;
        b=NYwMoQRqTluy3SeUDuqwkuwDUyWGvCxbWa5fkmSy51KJ9k5YaPXQnEBMADn9Tw3cfa
         4qEJLOQjOn+nK3OdVulFa8UMbmM66kLUWTPiqYfyKjeOceoaBM6DRvhi68GXqpSAulve
         2e/EjzV0QOLTC7CP0XcZiPp0DuRGCJ1m/Yku3j0OwLwwP5rIPc21S/DpiYy4GavaG3/9
         7qc1AGnREJxpJLIg+0qEeRUJis3rSPmLOZoEFVXpMZvXjST0IookzPQC7hsLD1FcIkK7
         obiDc3P6wkNXofNQooqtfV9Uer1RwbfWO3VFSRN4jc5B3MntJqD0LkmMJhhRWSxp3dpq
         KJUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KAJLoXmtlUGTIhQz/R8IxrT9lql92ArMXqcy3RaeD8g=;
        b=WV7jl0QOn96QqlW7Db9A5qu1tVA4M8TqOpxp3RQoL1wN2JXqzPRnDnDNyCSCZL4fgC
         prXpTSGkIIro4lcij/pvT0tEZAWaYrHLxSddUPQhnN5z6hwtAHvYKLCADOkWwO/6O3Rz
         pIL+mrEUhiVJTCTv6Y5kUHimANbE/xEcO8DzyqKGSynATwcwvq0D6JYGFcWwQAJAAYLX
         dfHuaLhD4CyLvZteyTs+JlZI5e74pDaZXIYVh2fFwnhA4SHgyac/UwU1pP3u0yhfs8vB
         8vJ5gvXVi88GTe4oatsMyvjdVS0WfovLTZ4i2Wak1vibQZAMKQ3pBiXgg7MP2oo7kH6E
         FXZA==
X-Gm-Message-State: APjAAAWbZGJkoFI7Sop5eCAjbKjufZ8buFKiHT4drgUb04CqGN8DU6kn
        tEGiKpVCN7X9UymbE9Gm+OZwSx6cMOCsfm2Wmwl78w==
X-Google-Smtp-Source: APXvYqx5+pyNBabT/eHf40ztsZ9ljN/unxi8jbD5mXGGQuW8bkNxV1kJPRUMZ/Uly8cx60YDSkNYRm/Hp+VqAh3FRMo=
X-Received: by 2002:a1c:b706:: with SMTP id h6mr8573915wmf.119.1562178125589;
 Wed, 03 Jul 2019 11:22:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190624133042.7422-1-ard.biesheuvel@linaro.org> <20190703132532.n4zi66shnsq5ft5k@gondor.apana.org.au>
In-Reply-To: <20190703132532.n4zi66shnsq5ft5k@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 3 Jul 2019 20:21:50 +0200
Message-ID: <CAKv+Gu9jg6omSmBFFqQRFeQ-a0K+5PuqgJcjEpjGWVeWMR8eTg@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] crypto: aes/generic - use unaligned loads to
 eliminate 50% of lookup tables
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 3 Jul 2019 at 15:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > +config CRYPTO_AES_REDUCED_TABLES
> > +       bool "Use reduced AES table set"
> > +       depends on CRYPTO_AES && HAVE_EFFICIENT_UNALIGNED_ACCESS
> > +       default y
> > +       help
> > +         Use a set of AES lookup tables that is only half the size, but
> > +         uses unaligned accesses to fetch the data. Given that the D-cache
> > +         pressure of table based AES induces timing variances that can
> > +         sometimes be exploited to infer key bits when the plaintext is
> > +         known, this should typically be left enabled.
>
> I don't think this option should exist at all, and certainly
> not as a user-visible option.
>

OK, so perhaps we should just use  HAVE_EFFICIENT_UNALIGNED_ACCESS in
the code to make the distinction. But i'd like to gain an
understanding of how this affects performance on various
(micro)architectures first. I'll park this until after the summer,
since i won't have time to spend on this myself anyway, and hopefully,
some interested parties will have provided some data points by then.
