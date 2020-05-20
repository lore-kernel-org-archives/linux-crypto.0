Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F94C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 12:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F26F3207D4
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 12:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589976019;
	bh=p2b++fqgB3j8t8wQVCowLSphUGbZ0n9M7PbJlfK7X/g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=u6nyDlfmBKWAcywv6Aq73Btet7U4lmj82nTS26wXeYRU/rlEThqXV3t1iGhe8C0Eq
	 ERL9Jev1VqjhVw140VsvLIhlUNVcdQGLoCgDN442IYgpMSQJ2lE1UvYi4Z/68rmDDA
	 19FSnIyizrxTktlkLvpgDn/dz+JG5/651EjGkcHo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgETMAQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 08:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgETMAP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 08:00:15 -0400
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD4F02088E;
        Wed, 20 May 2020 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589976015;
        bh=p2b++fqgB3j8t8wQVCowLSphUGbZ0n9M7PbJlfK7X/g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CW5CxvEsFMAQykySax7pzLLLsuOOb0yHjoog78dUyoDsiNZGpdB8q/hjeryKbCcTP
         wIa4BnzHQws04aAqGlgPIA8bdvGr19unsaZtfbi4gLUwlMH2JvsZcNiutZfHgBEWvk
         gebWAQM0XpcbGPvbaAEOxAJQZtXaojp57sWXGDvY=
Received: by mail-lj1-f172.google.com with SMTP id v16so3323685ljc.8;
        Wed, 20 May 2020 05:00:14 -0700 (PDT)
X-Gm-Message-State: AOAM532eYYX0uWOGVm2+oU5QjmU2qUG2wfhKSV4RaFm4Om1FVb9OJaDj
        g4sPXTOz1bX3mbmanQWvemVWQGxJUWgnKudqtT8=
X-Google-Smtp-Source: ABdhPJzqow3O8ENCEDm8pm97wOipgg7aCLHp2fW6FeVlcUNXw9PQ19agZuUv9OGshUKmBWlDt+HIDjaQRQTcXVnWHKU=
X-Received: by 2002:a2e:8e99:: with SMTP id z25mr2440347ljk.142.1589976012909;
 Wed, 20 May 2020 05:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <15745285.MnsZKaK4VV@tauon.chronox.de> <CGME20200520104448eucas1p122e9a8ed84d5276a1b796e10ef5e1964@eucas1p1.samsung.com>
 <dleftjh7wa3my6.fsf%l.stelmach@samsung.com> <2041475.ybOAuNAZB8@tauon.chronox.de>
In-Reply-To: <2041475.ybOAuNAZB8@tauon.chronox.de>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 20 May 2020 14:00:01 +0200
X-Gmail-Original-Message-ID: <CAJKOXPeBkZ3R2wT9-A8LWkFx0W9KY70VW7JNjwp0RMDRc7hkTg@mail.gmail.com>
Message-ID: <CAJKOXPeBkZ3R2wT9-A8LWkFx0W9KY70VW7JNjwp0RMDRc7hkTg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] hwrng: iproc-rng200 - Set the quality value
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Lukasz Stelmach <l.stelmach@samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Kukjin Kim <kgene@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Matthias Brugger <mbrugger@suse.com>,
        Stefan Wahren <wahrenst@gmx.net>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 May 2020 at 13:53, Stephan Mueller <smueller@chronox.de> wrote:
> > > That said, the illustrated example is typical for hardware RNGs. Yet
> > > it is never guaranteed to work that way. Thus, if you can point to
> > > architecture documentation of your specific hardware RNGs showing that
> > > the data read from the hardware is pure unconditioned noise data, then
> > > I have no objections to the patch.
> >
> > I can tell for sure that this is the case for exynos-trng[1].
>
> So you are saying that the output for the exynos-trng is straight from a ring
> oscillator without any post-processing of any kind?

Hi,

I think we will never be able to state this because the manual is
quite limited in sharing internals. What the driver does and probably
Lukasz wanted to say is that there is "post processing" block and
feature which can be disabled. The manual is saying the TRNG block
generates random data from thermal noise but not how much in a direct
way. There could be some simple post-processing or not (except the one
able to on/off). Also manual says this post processing block is there
to remove statistical weakness from the TRNG block. To me it does not
prove enough that raw data is really raw...

Best regards,
Krzysztof
