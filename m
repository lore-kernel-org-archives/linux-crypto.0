Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB3CC433E9
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 07:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F7764FEE
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 07:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhCJHVq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Mar 2021 02:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhCJHV3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Mar 2021 02:21:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6092F64FF3
        for <linux-crypto@vger.kernel.org>; Wed, 10 Mar 2021 07:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615360889;
        bh=hf638u3u5uNZc0I8YEsS5wEYE7TWYXDQkyw2gliKSH4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QKvl9CRcD6nqWhVXE+UI7aCUTdc9OT5qJpIAzXdl5Dety1lCYC82roJFuUKZYUii0
         mGSM/FjPdOteQzX2gYUT0YKdyEuw65JJ5SmmbmP3EfxcwrSZylTewsuIuqi4tl53BC
         +4a/ejxG/USaZkmI7AQTE6evwuGyhHhHT6dq7UI3ZNkrezPQngTZzufwO+4NRePTeD
         enTza9G3V6kQdxqflE2DhgiS7I370sMsHjLRxulp1sxQ3b7vzVxU3YFVCrV2qKAtIj
         BBrL3pFXtV68iM1ok83F4q3rUUFYEtrLOPHUlIMoIjuK1P+Vo/8uQPuQrOr8fVsywm
         4KmLoAjXr5ztw==
Received: by mail-oi1-f178.google.com with SMTP id v192so10483991oia.5
        for <linux-crypto@vger.kernel.org>; Tue, 09 Mar 2021 23:21:29 -0800 (PST)
X-Gm-Message-State: AOAM533CgPyd8oaePKOR3IDN6bz9kewjNqeGi+fRR1OlS5nTXXSoL47O
        dKnxV6hHIvzFmmlQ1AZtSpAYdkfiPATVlQvIi5A=
X-Google-Smtp-Source: ABdhPJxbsvA4j34Ur22Q/qEel0dNwopjvKxLEI3zmzBmyboOlWeMzAfwXwxPHFJUezucx0YPnz2Lu90l6SWcTo7obOk=
X-Received: by 2002:aca:ab86:: with SMTP id u128mr1507472oie.47.1615360888645;
 Tue, 09 Mar 2021 23:21:28 -0800 (PST)
MIME-Version: 1.0
References: <20210307165424.165188-1-ardb@kernel.org> <20210307165424.165188-2-ardb@kernel.org>
 <YEhwlpKroXxo1hsT@sol.localdomain>
In-Reply-To: <YEhwlpKroXxo1hsT@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 10 Mar 2021 08:21:17 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHT=z2883cissNA1DeFOdgCjsfLbS_3fz1WqaNQm=Lx0w@mail.gmail.com>
Message-ID: <CAMj1kXHT=z2883cissNA1DeFOdgCjsfLbS_3fz1WqaNQm=Lx0w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: arm/aes-scalar - switch to common
 rev_32/mov_l macros
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 10 Mar 2021 at 08:09, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Mar 07, 2021 at 05:54:23PM +0100, Ard Biesheuvel wrote:
> > The scalar AES implementation has some locally defined macros which
> > reimplement things that are now available in macros defined in
> > assembler.h. So let's switch to those.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > Reviewed-by: Nicolas Pitre <nico@fluxnic.net>
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
>
> Although likewise, shouldn't the commit title say "rev_l" instead of "rev_32"?
>

Yeah, forgot to update that. I'll respin with that fixed.

Thanks,
Ard.
