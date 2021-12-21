Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30226C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Dec 2021 07:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbhLUHAJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Dec 2021 02:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbhLUHAJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Dec 2021 02:00:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0292DC061574
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 23:00:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A02A461341
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2021 07:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAA4C36AE7
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2021 07:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640070008;
        bh=kj17JJ9wv8oL1dBIq7jyZL/tCpYz8oacsS8nMvIuQw4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=a8zX2c0B93JTEIPb+3Fy3JH+TtVNn406MPXpEiJnVsi6qvusWDp5MTgNc6zl0NgOl
         PoiONXw1Hny+IUHwH7mJyAvFVZDEckvZ09fTNkko8QlVybIVJGXZMhl0vi0HHl2++6
         ZZ0f1H95xvr29GJmbpGwHfIrHW6nUq1sXsGAEObYOF5z0ZNrTNfMAM17ABli/x7v/Y
         enTMFYFRy6lC3qIs8A1Vr+UaerppyNlGxyj5pTspboBiDWEBUhiq8gPpXt7Q7/h3ZW
         8etR6UPdk9Rikiwn71zwXFUOgK4nsvr/rmpqVijl6iGt6QYa7OGsIcw2QEDO7cKZoI
         +8klv59ywbmWg==
Received: by mail-wm1-f43.google.com with SMTP id i12so8385288wmq.4
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 23:00:07 -0800 (PST)
X-Gm-Message-State: AOAM530SYZejvluPYPpbpUs6y4F2rBjFV80vQrmlHbuG02xy2I98GCuu
        wHcAJXjhhZ/XHD/rnes84BuHfss8ShWLtNiZRJk=
X-Google-Smtp-Source: ABdhPJyPx4DTmIUUPCt5drfFTYHjUzmTwwi5x91c7CN2CqdRelr/cWgTFYbLWPG4Zb+lAGTdHikiRrTWBLe6tgbRks4=
X-Received: by 2002:a1c:1f93:: with SMTP id f141mr1356501wmf.56.1640070006365;
 Mon, 20 Dec 2021 23:00:06 -0800 (PST)
MIME-Version: 1.0
References: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211208044037.GA11399@gondor.apana.org.au> <20211207212907.6e91821b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211220150343.4e12a4d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211220161125.78bc4d66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20211220165251.400813dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211220165251.400813dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 21 Dec 2021 07:59:54 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG+FGBHr=+vUwVz-u5n7oHpRxikLsOogVW0bOvNow3jHQ@mail.gmail.com>
Message-ID: <CAMj1kXG+FGBHr=+vUwVz-u5n7oHpRxikLsOogVW0bOvNow3jHQ@mail.gmail.com>
Subject: Re: x86 AES crypto alignment
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 21 Dec 2021 at 01:52, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 20 Dec 2021 16:11:25 -0800 Jakub Kicinski wrote:
> > On Mon, 20 Dec 2021 15:03:43 -0800 Jakub Kicinski wrote:
> > > Hm, I'm benchmarking things now and it appears to be a regression
> > > introduced somewhere around 5.11 / 5.12. I don't see the memcpy
> > > eating 20% of performance on 5.10. Bisection time.
> >
> > 83c83e658863 ("crypto: aesni - refactor scatterlist processing")
> >
> > is what introduced the regression.
>
> Something like this?
>
> ---->8-----------
>
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Mon, 20 Dec 2021 16:29:26 -0800
> Subject: [PATCH] x86/aesni: don't require alignment
>
> Looks like we take care of the meta-data (key, iv etc.) alignment
> anyway and data can safely be unaligned. In fact we were feeding
> unaligned data into crypto routines up until commit 83c83e658863
> ("crypto: aesni - refactor scatterlist processing") switched to
> use the full skcipher API.
>
> This fixes 21% performance regression in kTLS.
>
> Tested by booting with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> (and running thru various kTLS packets).
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

but it needs a Fixes tag.

Could you check whether this means that gcm_context_data in
gcmaes_crypt_by_sg() does not have to be aligned either? It would be
nice if we could drop that horrible hack as well.


> ---
>  arch/x86/crypto/aesni-intel_glue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index e09f4672dd38..41901ba9d3a2 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -1107,7 +1107,7 @@ static struct aead_alg aesni_aeads[] = { {
>                 .cra_flags              = CRYPTO_ALG_INTERNAL,
>                 .cra_blocksize          = 1,
>                 .cra_ctxsize            = sizeof(struct aesni_rfc4106_gcm_ctx),
> -               .cra_alignmask          = AESNI_ALIGN - 1,
> +               .cra_alignmask          = 0,
>                 .cra_module             = THIS_MODULE,
>         },
>  }, {
> @@ -1124,7 +1124,7 @@ static struct aead_alg aesni_aeads[] = { {
>                 .cra_flags              = CRYPTO_ALG_INTERNAL,
>                 .cra_blocksize          = 1,
>                 .cra_ctxsize            = sizeof(struct generic_gcmaes_ctx),
> -               .cra_alignmask          = AESNI_ALIGN - 1,
> +               .cra_alignmask          = 0,
>                 .cra_module             = THIS_MODULE,
>         },
>  } };
> --
> 2.31.1
>
