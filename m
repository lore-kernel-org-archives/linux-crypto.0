Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89125C48BD4
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 15:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D981208CB
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 15:58:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oTFznPTC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732243AbfFYP6D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 11:58:03 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44076 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731329AbfFYP6D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 11:58:03 -0400
Received: by mail-io1-f68.google.com with SMTP id s7so4313627iob.11
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jun 2019 08:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YYQoWVt07XUXYbrRIfkzrkTbmrk7mu3+m7asWezfQXc=;
        b=oTFznPTCRv1k+OyALIZmfqSuWNM3R9VZRf9ztG6yGAwORoF2svrL7zIpk/KtmOoIQL
         mBGKzOYmxpte1Bf1BFvBfokLuk1ef5wQeR82/wdX18DTDwqk3cP/Wcyxm3NPbDx3xcPH
         ZmFB0aQvy7D6hhbbrmmmz6WIeWEP7RNDugsDl8Qf+YzFi1vviNiKQMgy1j9DPyGRx5ZD
         j+uE+M9K9HD+XTa3a+sumh4kM4ob/sc3Gq+mfb0aNkZ5FdF9DTHYo1v5Z99E+0WMuRPz
         g0JBFRNrkFnyOVatUrpkHiO/c2DwVtl8vBpnhdYgwCOszk0UQXBtVhwHuc5ImnqczLYR
         nxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YYQoWVt07XUXYbrRIfkzrkTbmrk7mu3+m7asWezfQXc=;
        b=jODwRnucY7XAOx7r82sicTQkXCMbtlsMjYvop9g6g3ksH9RfP5GWIMNZHMsNwV9rvl
         mlUX78rRR/4MIeaeN/GHUYDXOZck/a6EA8vfeYcL2nYVy0rAkH5+H05Ji142GTcagTvo
         vLSsTmemb1zoyfWlx20a2B0S0ptrJc6AuDJBOcppoyHLtHBD5gbihpEpxFtyORdZx7/L
         tL+Uko9KogC+EVxn4Nv5c4neSoIBEYDiMfWL9QmWcBhaiOgWYjzxL1QMHXdm51pPDKtM
         Wdskh+uPlqHw1akEpNJ0l9MXuV/Nv7m8YTA1JTQ/87GJNCDmVVxBE7JUmE1e1KCJ27F8
         V0fg==
X-Gm-Message-State: APjAAAW13d/HRowIAUB0c8RNVJl5u5eSncNto3O6yykcJqAAjziXBJu7
        thyCTXiQb5xjuqKc8hu56N1LbpEzsUa/CkQaTskG+zH0nS8=
X-Google-Smtp-Source: APXvYqx58RXzLfCOdTQMJRKi/EReIbCxVu5p5F8I7ithvPgeE8SUUk1tIZmfDOrYKEsQJnjTXQ425RKe3CWIMcpwl50=
X-Received: by 2002:a02:3308:: with SMTP id c8mr67286988jae.103.1561478282365;
 Tue, 25 Jun 2019 08:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org> <CAMuHMdUbnHBQoTHVd9YyU_8yn6VHdcC1-8q3GqKftMrvRV_qag@mail.gmail.com>
In-Reply-To: <CAMuHMdUbnHBQoTHVd9YyU_8yn6VHdcC1-8q3GqKftMrvRV_qag@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 25 Jun 2019 17:57:51 +0200
Message-ID: <CAKv+Gu-b5YdBypEdt247bu1bpFZoDaxW1R9Xjb62+mx6WpDO8A@mail.gmail.com>
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 25 Jun 2019 at 17:27, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Ard,
>
> On Tue, Jun 25, 2019 at 4:53 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> > MORUS was not selected as a winner in the CAESAR competition, which
> > is not surprising since it is considered to be cryptographically
> > broken. (Note that this is not an implementation defect, but a flaw
> > in the underlying algorithm). Since it is unlikely to be in use
> > currently, let's remove it before we're stuck with it.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Thanks for your patch!
>
> >  arch/m68k/configs/amiga_defconfig     |    2 -
> >  arch/m68k/configs/apollo_defconfig    |    2 -
> >  arch/m68k/configs/atari_defconfig     |    2 -
> >  arch/m68k/configs/bvme6000_defconfig  |    2 -
> >  arch/m68k/configs/hp300_defconfig     |    2 -
> >  arch/m68k/configs/mac_defconfig       |    2 -
> >  arch/m68k/configs/multi_defconfig     |    2 -
> >  arch/m68k/configs/mvme147_defconfig   |    2 -
> >  arch/m68k/configs/mvme16x_defconfig   |    2 -
> >  arch/m68k/configs/q40_defconfig       |    2 -
> >  arch/m68k/configs/sun3_defconfig      |    2 -
> >  arch/m68k/configs/sun3x_defconfig     |    2 -
>
> For the m68k defconfig changes:
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> (but they would be updated "automatically" during the next defconfig refresh
>  anyway)
>

Thanks Geert.

Would you prefer to leave this hunk out instead?
