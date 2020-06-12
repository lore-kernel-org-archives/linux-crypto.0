Return-Path: <SRS0=ESNp=7Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D897DC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 18:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF32B207ED
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 18:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgFLSc6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jun 2020 14:32:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45578 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgFLSc5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jun 2020 14:32:57 -0400
Received: from mail-ua1-f69.google.com ([209.85.222.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <mauricio.oliveira@canonical.com>)
        id 1jjoU3-0006lg-PL
        for linux-crypto@vger.kernel.org; Fri, 12 Jun 2020 18:32:55 +0000
Received: by mail-ua1-f69.google.com with SMTP id i5so3842269uae.16
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2020 11:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AvjpgmaIry5taYFf387w++nuMAqy1oNRAi25dBuugD8=;
        b=Emrd5n3i/IiQmgP7qCUxitQNtJvSm/wMlTHTYWVBLut8W0TEMF6VjiShzqZILbyI6w
         79o2hXcGgTrB4OAEB6z7+fzdocvGjhmFUOnk8trXNc8XBrYu5AAAbSLYWD4eCEJ2vDh1
         gyu0pzmKLJYBVPdt7gy835SwwRV1BA5LJJmlmOm57GcbWhmT7c2e8Pmxw0w0iUvUqAVS
         l3Z1niu3Fc9cG7R3RVG6A84+x3S48AiBY/FQMkSYXOt9ZLh8zmiFiLazKJ6FrvLrgiuK
         PzqhWvaMVnYuOLItyE6wrq4TB8nV0yTxkyY47iekEpNCwkEzl/PLiUgnL5iVsU53SgbE
         uDvA==
X-Gm-Message-State: AOAM530cjCZNmM0v5OUyob5ExZ73TWw+3g54yP756Ouu6Vmv1eo7nOTt
        NMj7zRct6zK6t+zByXvdhwJ0q/jJ5iB84XcdHSeemgriPJiJwayxFWeGkTQI3fnpvppCJ7Glnfo
        7Ylg4E772cJJwBnoOOBl1GR0H31DHDK3DVAkJRY2E4PRmiDKG10xTuu5inQ==
X-Received: by 2002:a9f:3611:: with SMTP id r17mr10611853uad.108.1591986774836;
        Fri, 12 Jun 2020 11:32:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZKLy16+7Aan3fNEodC/ZXB4wPFR+SYFLmfMGceH2lMSaejEeRJLFsWacnV3/vBjTNpwbzJRRXWcGhK5zI5LE=
X-Received: by 2002:a9f:3611:: with SMTP id r17mr10611845uad.108.1591986774574;
 Fri, 12 Jun 2020 11:32:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200605161657.535043-1-mfo@canonical.com> <20200608064843.GA22167@gondor.apana.org.au>
 <CAO9xwp0KimEV-inWB8176Z+MyzXqO3tgNtbtYF9JnBtg07-PiA@mail.gmail.com>
 <20200610002123.GA6230@gondor.apana.org.au> <CAO9xwp2VryJi46+3UPhbQz3npCaZBziOTWEp+Kiqd90rMhkJXQ@mail.gmail.com>
In-Reply-To: <CAO9xwp2VryJi46+3UPhbQz3npCaZBziOTWEp+Kiqd90rMhkJXQ@mail.gmail.com>
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
Date:   Fri, 12 Jun 2020 15:32:43 -0300
Message-ID: <CAO9xwp1mXmS7VVau2xWcnRic1kGQO03ptjdoevAgzoCXWwuJ6A@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: af_alg - fix use-after-free in af_alg_accept()
 due to bh_lock_sock()
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Wed, Jun 10, 2020 at 11:28 AM Mauricio Faria de Oliveira
<mfo@canonical.com> wrote:
>
> On Tue, Jun 9, 2020 at 9:21 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Tue, Jun 09, 2020 at 12:17:32PM -0300, Mauricio Faria de Oliveira wrote:
> > >
> > > Per your knowledge/experience with the crypto subsystem, the changed code
> > > paths are not hot enough to suffer from such implications?
> >
> > I don't think replacing a spin-lock with a pair of atomic ops is
> > going to be too much of an issue.  We can always look at this again
> > if someone comes up with real numbers of course.
>
> Right; I meant the other places as well, where atomic ops were added
> (in addition to the existing spinlocks.)
>
> But indeed, real numbers would be great and tell whether or not
> there's performance differences.
>
> We're working on that -- Brian (bug reporter) has access to detailed
> metrics/stats from the workload, and kindly agreed to set up two
> identical instances to compare the numbers.  I'll keep you posted.
>

Just wanted to let you know that the performance is really close for
the two patches,
both on the CPU utilization profile and also on workload results
(#requests over time).

And the tests ran for two days, so it  looks stable.

Thanks!

> Thank you,
> Mauricio
>
>
>
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
>
>
> --
> Mauricio Faria de Oliveira



-- 
Mauricio Faria de Oliveira
