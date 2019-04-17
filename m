Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA018C282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 20:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5880217FA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 20:51:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CWivGgZr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfDQUvP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 16:51:15 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43064 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfDQUvP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 16:51:15 -0400
Received: by mail-io1-f67.google.com with SMTP id x3so173294iol.10
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 13:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wVr9mWvM9Xbfo0DNB4zW6QZHY5FKW51H76B3cpwbt7k=;
        b=CWivGgZr2uw3rY314wfuQYh6ORo2i/tjMqfO/CXdTFG7F3I3khlnq6L05nCFu2h6xU
         KWYuV8JoEqI04tfRE+PqA2Ms+1c+Xs8TwIu9H26tXOQdt/NpE6+7B5L4AdLLNLpZ43ET
         1Hw5/fGpTDj3VwJmH+6znaqpXi97pWVHJzUJEqZq7eFR8rzOVaLcmZrzcG/Bw/fxppd1
         JMgPszS2fgImyjm1HAcxWgQZ0uncuNjo+wHrxkmNKhP0kMh445Zu5ppyDiMBwnLepS2j
         QMuulnI5T3m9bcWDlB0Ib3aJhFxGjraAkB4VPuo2CubSDCvVaJ6tJ3Os5tcw1E+rBeEE
         G7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wVr9mWvM9Xbfo0DNB4zW6QZHY5FKW51H76B3cpwbt7k=;
        b=c2N1NNlWMEr28jpBiL7GvFMo1Gib7L/AIMlOpR7CylcJilfZVZ4jG/HhFUIHoZE3Ud
         V0Vylb9FcmwydUrQtlMkddU4aEE/frHFPJ3/zCkq5PvxQ5Uo+NcPNwUSucQP9J0ZL6j9
         m07yFKCl1bVEpk15Epdsr2sRx+WPTLWjqBvfsMLzApwsGKD5j2uFpEWqLC81GISgH6Vh
         7VOUNmi/PKJXIFmgrCL/uBgBpuD2HbQ+lWyyellnvAPvWIeo4IesM0MryqXGVtPtUjYs
         qH4tfxs832+uWw5h+ZsnZYc0GioGNdk/hu+6pDlhVy/NgxySPtVmPCvp7LAVbvAB2UTg
         uOOg==
X-Gm-Message-State: APjAAAU9zNLL/f8WgUMt/7nfDFq6QqIwzPlV7mmWc5mCI35saFZS4qIG
        W7++CuOmA+9L6GE9Tr8kdNm3DgJi1b4Y6ma+GHlxkPFxvUQ6pg==
X-Google-Smtp-Source: APXvYqzu3PegM2bwOER1JatlZDRsFN1yAnhJSV+NXqUjgd0WvMDW4kKTlFgkT+bm5zmsUvKBY/6zqBbAWCBgczJ3S1s=
X-Received: by 2002:a5e:9b17:: with SMTP id j23mr7678291iok.60.1555534274152;
 Wed, 17 Apr 2019 13:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8000sDAX89=cre2uZ07vJC86FVjcoKagyk_Qqyrkbytw@mail.gmail.com> <AM6PR09MB3523E3B73CFCC6087C6981F1D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523E3B73CFCC6087C6981F1D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 17 Apr 2019 13:51:03 -0700
Message-ID: <CAKv+Gu-KFswn=y19YmwhmUfEG9N5T3isRyvzLsvXOM=5Z5vYtw@mail.gmail.com>
Subject: Re: Question regarding crypto scatterlists / testmgr
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 17 Apr 2019 at 13:49, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > > I'm trying to fix the inside-secure driver to pass all testmgr
> > > tests and I have one final issue remaining with the AEAD ciphers.
> > > As it was not clear at all what the exact problem was, I spent
> > > some time reverse engineering testmgr and I got the distinct
> > > impression that it is using scatter particles that cross page
> > > boundaries. On purpose, even.
> > >
> > > While the inside-secure driver is built on the premise that
> > > scatter particles are continuous in device space. As I can't
> > > think of any reason why you would want to scatter/gather other
> > > than to handle virtual-to-physical address translation ...
> > > In any case, this should affect all other other operations as
> > > well, but maybe those just got "lucky" by getting particles
> > > that were still contiguous in device space, despite the page
> > > crossing (to *really* verify this, you would have to fully
> > > randomize your page allocation!)
> > >
> > > Anyway, assuming that I *should* be able to handle particles
> > > that are *not* contiguous in device space, then there should
> > > probably already exist some function in the kernel API that
> > > converts a scatterlist with non-contiguous particles into a
> > > scatterlist with contiguous particles, taking into account the
> > > presence of an IOMMU? Considering pretty much every device
> > > driver would need to do that?
> > > Does anyone know which function(s) to use for that?
> > >
> >
> > Hello Pascal,
> >
> > Scatterlists are made up of struct page/offset tuples, and so they
> > should map transparently onto physical ranges.
> >
> > It looks like the AEAD skcipher walk API lacks a *_async() variant
> > setting the SKCIPHER_WALK_PHYS bit, like we have for the ordinary
> > block ciphers. Plumbing that into crypto/skcipher.c should be rather
> > straight-forward.
> >
> > --
> > Ard.
> Ard,
>
>
> Am I reading this correctly as "your driver should indeed expect
> those particles to be contiguous, but there is some problem in some
> other location in the API causing this to not always be the case"?
>

Indeed.

> I took a quick peek at skcipher.c, which is a design unfamiliar to
> me, but the first thing that strikes me is that there is an
> "skcipher_walk_async", that indeed sets this SKCIPHER_WALK_PHYS bit,
> but no matching "skcipher_walk_aead_async" function that I would sort
> of expect doing a similar thing for AEAD ciphers ...
>

That is precisely my point.
