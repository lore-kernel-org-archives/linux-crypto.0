Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F09CC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jan 2022 13:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241774AbiALN7B (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jan 2022 08:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbiALN67 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jan 2022 08:58:59 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C99EC06173F
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jan 2022 05:58:59 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id d3so8313189lfv.13
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jan 2022 05:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7eKjcI/Bd+RPtk5A9fLQFKYNhKKvA3UhUmBNdgii34o=;
        b=YQS683RDUAcDkViHVLraarkF9Bn4e65ELek4jc9vsCuDsVbWEvPnlVEAePssAIGXRA
         SW9AEHzPdzstpY4lHqhv3HLa1V3Fm4ytyPb82eHv8th5tgygvuF/aU/d0kSg1IazUdn1
         z4y/MCBsECb5UVVPZcasqWbtiNdld5JJTLi2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7eKjcI/Bd+RPtk5A9fLQFKYNhKKvA3UhUmBNdgii34o=;
        b=fxTYMwG5oKGrVG39thvnhCqJDsjI05swfsz7ZHjMSEVLcQUnpAoZlyyNCQIAasSSi2
         Ll+WxFOmaYPomgvAt48uhgiGr76eq1XhGN32LTw6U67vW9xr43UCZVEjMFqF7Uf3udNn
         PcDa06PupGKCPRUnu1iR3dKE45xxrUAVb+Z8J/d3RE4hhuCly6ODw/HNk30rtR7q8+Qq
         kbr5i0aSXEvpQgBgz8PrlHZYnSfN7atVcGGao4yM2uCJjOEosYe3Hr7yHiLzBEQ/WRIb
         W8CvTp22uptBohE5ShMXGkEloEclcZ139c+guEDDtFl9uuegtbcvfpZpcui42wgAs53+
         PqpQ==
X-Gm-Message-State: AOAM533i/osOQBM4KO0H4+wKelcb0q3Dkg+tMaIIOlCumdZ4QgSq6/Zs
        Wb+BMfIp6NSvOpyXIfKBzH4zbz9+eMyvHu2k+m2JdZMw5ynGUw==
X-Google-Smtp-Source: ABdhPJzPYmMCW1KoL34T5ouPqhnjkHuqlVB7qHUPxjPR1hSYzd6dCPBMTZSeoCwShQqJSZwkaeEZJgQ00W1n/1268Ug=
X-Received: by 2002:a05:6512:3f8:: with SMTP id n24mr7095067lfq.650.1641995937442;
 Wed, 12 Jan 2022 05:58:57 -0800 (PST)
MIME-Version: 1.0
References: <20220111195309.634965-1-jforbes@fedoraproject.org>
 <CAHmME9pi1Y7urg1VQeCi7L6MxHRUk5g4wc6VKDywo4yPh9h_6w@mail.gmail.com>
 <CAMj1kXH24ubv7yAqmbnzqe22cGh1L0-N8J6fiCT2NgU2HmeBJw@mail.gmail.com>
 <CAHmME9qXg3_HdnDwN-LOBJQhxz4acYCjgQhXRovQ6-9TWwHwWQ@mail.gmail.com> <CAMj1kXFybcnneHwpvKYNnK0F3t48kqDpV-RKLgR1A+w4QbUxTg@mail.gmail.com>
In-Reply-To: <CAMj1kXFybcnneHwpvKYNnK0F3t48kqDpV-RKLgR1A+w4QbUxTg@mail.gmail.com>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 12 Jan 2022 07:58:46 -0600
Message-ID: <CAFxkdAoC_Ap7YWqE5PLXczfk9YivuWPk5K303DuTuj9B8keERg@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: add prompts back to crypto libraries
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 11, 2022 at 4:41 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 11 Jan 2022 at 23:27, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Tue, Jan 11, 2022 at 11:25 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > On Tue, 11 Jan 2022 at 23:12, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > >
> > > > Hi Justin,
> > > >
> > > > These are library variables, which means they really have no sense in
> > > > being user selectable. Internal things to the kernel depend on them,
> > > > or they don't. They're always only dependencies.
> > > >
> > >
> > > But what does any of this have to do with blake2s? These are unrelated
> > > changes that are not even described in the commit log of the original
> > > patch, so let's just revert them now. If changes are needed here, we
> > > can discuss them on the linux-crypto mailing list after the merge
> > > window.
> >
> > The lib crypto stuff moved outside of `if CRYPTO`, so if you add those
> > titles back, the root menu is going to be filled with things. I'm
> > working on some patches now moving lib/crypto/ things into lib
> > strictly, so the dependency is one way. I can try adding back the
> > labels there if you want.
> >
>
> Ah, right. In that case, can we fold in something like the below?
>
> diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> index a3e41b7a8054..179041b60294 100644
> --- a/lib/crypto/Kconfig
> +++ b/lib/crypto/Kconfig
> @@ -1,5 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>
> +menu "Crypto library routines"
> +
>  config CRYPTO_LIB_AES
>         tristate
>
> @@ -120,3 +122,5 @@ config CRYPTO_LIB_SHA256
>
>  config CRYPTO_LIB_SM4
>         tristate
> +
> +endmenu

That works, I will send a V2 with the menu.

Justin
