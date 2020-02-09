Return-Path: <SRS0=Lfag=35=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6382C35250
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Feb 2020 08:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B91C020656
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Feb 2020 08:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="gHSZGZ7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgBIIKJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Feb 2020 03:10:09 -0500
Received: from mail-vk1-f178.google.com ([209.85.221.178]:35210 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgBIIKJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Feb 2020 03:10:09 -0500
Received: by mail-vk1-f178.google.com with SMTP id o187so977040vka.2
        for <linux-crypto@vger.kernel.org>; Sun, 09 Feb 2020 00:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kcXc8Nc9KBoeoKUcsLWvAWNOC+kSckSzv0zdmuBDQ98=;
        b=gHSZGZ7IIDQ6jG5R85YM6323HzHa5ScUfzn4Amb0mIwvHEgmJqwmmUo2WnaFEsTr3p
         HaNGE+6qzONbm6kS+YKqueu0Woi1lwDVT+Nsp8+6gEhEwauKq6Z7QMmff8/6vhgiuFkE
         5G998Mx8yp07eTwC8DbSkl7h0L17zbi5xGy2QDJri1Uuk4x3/j8DASHTeXp0pie1Fss6
         vwHprHjFErWqxfF6GDumcFdiKYeKokEvKSriBFn1hx8Um8qmpryTitOUCk/KIadLyUL+
         hnVHvUN/g80zOQWc21/AbKmEab+AfJJtp1H9xwPJ5prkye3bQHc9bSKiW1W/aPGNziDh
         ZAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kcXc8Nc9KBoeoKUcsLWvAWNOC+kSckSzv0zdmuBDQ98=;
        b=qUkzRP5/WSrQDb0yZkCDwx+CXRA8bELP8UirI2ydTKi5QzU42lP6RIp/2fCAAYy2RP
         YB2sOtU+zBSswmqjIReeLQU4x4cxMsizOJaH1YLQ+ZU73Jcby9jPu08jrN5aKW2MT04t
         ZqxqHRKl9E+NTeXWoil231eqAioaoqTcev6vuXy1mXqDxOYZAP9jWz+KoIXhBGbB3UeP
         iodtEs4fPXpfnGXOL4ssMPVqXbiK+SGw21zdrDQ+ZFnm1tmGRALcneg3fC85ORDmv0nn
         xxRHtWwVKtkT2jvKpkj//77ZcU+cFbAc2mhnmsoxGfufPBxe4QO2tkV1DICCC0+NUcez
         kMXA==
X-Gm-Message-State: APjAAAVW9YGWnUDysqihlXG0hcvogfiBaDevngK+s6RgdgpVXV//7mfc
        LoLLZvwCHU12W1MFTVGPN1lMk+aiKz0luMR0GaG9RQ==
X-Google-Smtp-Source: APXvYqyFS4FHl4+WUSHevCab8dbGnOMljuHl6Ekgf3qUdWh6q7NvWD/TGmo8Qo3uO90VDzcjnOexHJaHxz8+reyL7fA=
X-Received: by 2002:a1f:7cc2:: with SMTP id x185mr3522854vkc.1.1581235807823;
 Sun, 09 Feb 2020 00:10:07 -0800 (PST)
MIME-Version: 1.0
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <CAOtvUMeVXTDvH5bxVFemYmD9rpZ=xX3MkypAGyZn5VROw6sgZg@mail.gmail.com>
 <20200207072709.GB8284@sol.localdomain> <70156395ce424f41949feb13fd9f978b@MN2PR20MB2973.namprd20.prod.outlook.com>
 <SN4PR0401MB366399E54E5B7EE0E54A7E0BC31C0@SN4PR0401MB3663.namprd04.prod.outlook.com>
In-Reply-To: <SN4PR0401MB366399E54E5B7EE0E54A7E0BC31C0@SN4PR0401MB3663.namprd04.prod.outlook.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 9 Feb 2020 10:09:53 +0200
Message-ID: <CAOtvUMeFZXwxxYT1hz=e09CaBrv1qBXvWcRCghA=wRGwZZ9S3g@mail.gmail.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 7, 2020 at 4:07 PM Van Leeuwen, Pascal
<pvanleeuwen@rambus.com> wrote:

> The "problem" Gilad was referring to is that the _explicit_ part of the  IV appears to be
> available  from both req->iv and from the AAD scatterbuffer. Which one should you use?
> API wise I would assume req->iv but from a (our) hardware perspective, it would
> be more efficient to extract it from the datastream. But is it allowed to assume
> there is a valid IV stored there? (which implies that it has to match req->iv,
> otherwise behaviour would deviate from implementations using that)
>


No, it isn't.

The problem that I was referring to was that part of our test suites
passes different values in req->iv and as part of the AAD,
in contrast to what we document as the API requirements in the include
file, my understanding of the relevant standard and
the single users of this API in the kernel and that the driver I'm
maintaining fails these tests,

I'm all fine with getting my hands dirty and fixing the driver, I'm
just suspect fixing a driver to pass a test that misuses the API
may not actually improve the quality of the driver.

Gilad
