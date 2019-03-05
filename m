Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE55C43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 19:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A56420842
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 19:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551815516;
	bh=mi62H2Z9HgxxB2LjGwmgEcpoR5XIi5Q8qy64Uok/YtE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=eIs2uoSpugXnj+v4lI1XkiRm2J4Wz6SzNtifpfxKrekrTsYddoqEtJLCcMzqUKPnE
	 zg0olsk3nRTCRw/se2kUN8RAyGwwkGgKlVrEgdw2YmaxN+RaH/nr2lqnLSMwXUbulX
	 0GmLg5XtqS0FFQKGWuYlgrtPwt+hQlPud455ZtYs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfCETv4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 14:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbfCETvz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 14:51:55 -0500
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDBC220842;
        Tue,  5 Mar 2019 19:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551815515;
        bh=mi62H2Z9HgxxB2LjGwmgEcpoR5XIi5Q8qy64Uok/YtE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cRJaB6PPlcsgJLZD/Ii3ZGe6kWFd5M0c1+W24H9A5Pj4/bOmvWBXtFLkqF1Ce1bxp
         +gyjHhOdMT3BHsudYwBMKnEEnTZfytNHPcD/FLpKeRbISRXzB1d6yENHX/TvaQUewv
         uoOzvnw7LcCCTxrwYUd6rKTcUHBGX09TIW1J8DFw=
Received: by mail-lj1-f178.google.com with SMTP id t13so8700489lji.2;
        Tue, 05 Mar 2019 11:51:54 -0800 (PST)
X-Gm-Message-State: APjAAAWfwamYjQGfMC6mI9n6jJsvCe1esMfZ86j3681bMQUNuuAYu+GI
        LbriRU25Zt5EP9Sxo65hDLVDqAJZumLP6vVR+kI=
X-Google-Smtp-Source: APXvYqwbUsJECs7eq99cRCGq8Uz3fbesn+FEjdkI5SVawzY9xKTcdX4azeewLoRMa3pFG4Kej+A1v2rlAoBHkamPTRA=
X-Received: by 2002:a2e:93cf:: with SMTP id p15mr203624ljh.184.1551815513130;
 Tue, 05 Mar 2019 11:51:53 -0800 (PST)
MIME-Version: 1.0
References: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
 <CGME20190222122204eucas1p1ee66c9d937bdf328588ececb1f005526@eucas1p1.samsung.com>
 <20190222122144.19024-4-k.konieczny@partner.samsung.com> <20190305171303.GA29802@roeck-us.net>
In-Reply-To: <20190305171303.GA29802@roeck-us.net>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 5 Mar 2019 20:51:41 +0100
X-Gmail-Original-Message-ID: <CAJKOXPdqf6b6LSxyhFJwoP+Jk+KCDvTtN1yM-LSP3n3kVt_nLQ@mail.gmail.com>
Message-ID: <CAJKOXPdqf6b6LSxyhFJwoP+Jk+KCDvTtN1yM-LSP3n3kVt_nLQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] crypto: s5p: add AES support for Exynos5433
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 5 Mar 2019 at 18:13, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Fri, Feb 22, 2019 at 01:21:44PM +0100, Kamil Konieczny wrote:
> > Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
> >
> > Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> > Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> > ---
> >  drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 46 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> > index 0064be0e3941..3f45cc5cb94a 100644
> > --- a/drivers/crypto/s5p-sss.c
> > +++ b/drivers/crypto/s5p-sss.c
> > @@ -232,6 +232,7 @@
> >   * struct samsung_aes_variant - platform specific SSS driver data
> >   * @aes_offset: AES register offset from SSS module's base.
> >   * @hash_offset: HASH register offset from SSS module's base.
> > + * @clk_names: names of clocks needed to run SSS IP
> >   *
> >   * Specifies platform specific configuration of SSS module.
> >   * Note: A structure for driver specific platform data is used for future
> > @@ -240,6 +241,7 @@
> >  struct samsung_aes_variant {
> >       unsigned int                    aes_offset;
> >       unsigned int                    hash_offset;
> > +     const char                      *clk_names[];
>
> This array does not have a fixed size.

Yes, correct. Kamil already sent a fix:
https://patchwork.kernel.org/patch/10835389/

Best regards,
Krzysztof
