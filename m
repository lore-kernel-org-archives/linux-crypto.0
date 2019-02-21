Return-Path: <SRS0=2gc/=Q4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1442C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84A112148D
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:22:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OTInq6NB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbfBUFWl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:22:41 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:44046 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfBUFWl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 00:22:41 -0500
Received: by mail-vs1-f66.google.com with SMTP id r201so15429505vsc.11
        for <linux-crypto@vger.kernel.org>; Wed, 20 Feb 2019 21:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fC8A5zYkH3TERVnKgiinl6c9FreZ2ttCReo0oPlCnuY=;
        b=OTInq6NByYwlXrVzT5qKEK/M1bs6f3Zzqukl4aSMjS467DNw4sRyWVe+hpk53n75Nl
         hVv/h7M9V/4GaT5C6jZddfz0vhmp4RhXjR1xs2TD0Q6vKwr9TKwaVoHgc3dcmb8ehLTx
         WDdR860TJBF263IZwE6LsUU6t5mGZdsAsWcH7pGA1vQxp59q/T0u+GVkabpCz0y059bN
         24CmRLdG1zuKLq8CS9bVXVz0nwGemgqgbqguYYQj6cIczelL/3nMu0OSFEaD83lWuqel
         4EkdZkj6PLOeTgCO8ZMNGwzKqmHFa/gY3w13/UYkdYHVLHBIGTAPtSK96q5VLLHjmG8y
         jJpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fC8A5zYkH3TERVnKgiinl6c9FreZ2ttCReo0oPlCnuY=;
        b=G0D3tKb+dqPFh6MM2vkkDCQFyzmjaso+F0vyPX2KX3vMtuY0ZysCCm2mHWTbWyXe/6
         fZp+5zwc/VNue3bokpb5pw9MIHEZPFAb3kqhQtzdrcSYLNbTSQETwH/cA3HZpx337X84
         wSNkk/YgVyRHiZW1d2lP54Twb2voXuDXLDmiuxqW4rSMGaqFxg2z/K142Y7JJomwi7QS
         R6wcYUoH0LXO0tysbIBxvY3EkRK5r+gXygSL5y4UI2jF0s4e17CqJs0fapJ+mNpykjso
         cv36KGcE+ev4/OVjjbpVNd9x1JgEuUtOa/emTT3HS65ve4mVugLE4spOVBXsuiZrGf+k
         OrhA==
X-Gm-Message-State: AHQUAuaYmKxYTu/3/5+3IqZKuMjhWnJC9W6D+ih4j8K1/hqH+wON4luE
        +AimhRWc+R4U0q4Ydm9gSIZC5hgwmmFEJOwdMJulOw==
X-Google-Smtp-Source: AHgI3IYIBrHbSMp8NLDxyG4CWbqXddSnjjXbkEewC2rIepdUsMvWJ5g5WzQMwFy8RBDLNUIT9IJcxqEeW+e1NE8mIGs=
X-Received: by 2002:a67:ef90:: with SMTP id r16mr10184547vsp.141.1550726559485;
 Wed, 20 Feb 2019 21:22:39 -0800 (PST)
MIME-Version: 1.0
References: <20190220093458.159208-1-weiyongjun1@huawei.com>
 <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
 <CAKv+Gu9yWEVvvoh8KOX1waZUrM1hy+P99Rxh3U2nPYE_sgyJzQ@mail.gmail.com>
 <8a3ff7ae-9257-82f1-70e2-91cc77aa7377@canonical.com> <CAFA6WYMU0GwYaOgyoCAKSUat0kHOGRnV6UWG0Co0EfHrpO4ryA@mail.gmail.com>
 <CAK8P3a3FMa9tpw4rj+8Aue2EYxxKSD4nxdwRFrzac_87Kzio5g@mail.gmail.com>
 <CAFA6WYNCxGTqw6LKUPK-ceWD1NbAhJQmzrH5fwOVRP5f2Auz2Q@mail.gmail.com> <20190220163313.GA3454@kroah.com>
In-Reply-To: <20190220163313.GA3454@kroah.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 21 Feb 2019 10:52:27 +0530
Message-ID: <CAFA6WYPeX0azKYkE4WWVx8_forvn2ybJJiM8vz_4g5few8RMuw@mail.gmail.com>
Subject: Re: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Feb 2019 at 22:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Feb 20, 2019 at 09:55:50PM +0530, Sumit Garg wrote:
> > Hi Arnd,
> >
> > On Wed, 20 Feb 2019 at 21:04, Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > On Wed, Feb 20, 2019 at 12:17 PM Sumit Garg <sumit.garg@linaro.org> wrote:
> > > >
> > > > On Wed, 20 Feb 2019 at 16:19, Colin Ian King <colin.king@canonical.com> wrote:
> > > > >
> > > > > On 20/02/2019 10:37, Ard Biesheuvel wrote:
> > > > > > On Wed, 20 Feb 2019 at 11:34, Sumit Garg <sumit.garg@linaro.org> wrote:
> > > > > >>
> > > > > >> On Wed, 20 Feb 2019 at 14:51, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> > > > > >>>
> > > > > >>> Fixes the following sparse warning:
> > > > > >>>
> > > > > >>> drivers/char/hw_random/optee-rng.c:265:35: warning:
> > > > > >>>  symbol 'optee_rng_id_table' was not declared. Should it be static?
> > > > > >>>
> > > > > >>
> > > > > >> I haven't observed this warning during my normal Linux build using
> > > > > >> gcc. Is there any specific configuration you are using?
> > > > > >>
> > > > > >
> > > > > > This is a sparse warning, not GCC. You need to install it separately
> > > > > > and build with C=1 (iirc)
> > > > > >
> > > >
> > > > TBH, I wasn't aware about this sparse tool. I did install sparse and
> > > > build with C=1 option. But I could only get following such
> > > > errors/warnings for drivers/char/hw_random/optee-rng.c:
> > > >
> > > > ./arch/arm64/include/asm/lse.h:18:37: warning: Unknown escape 'l'
> > > > ./arch/arm64/include/asm/alternative.h:213:28: warning: Unknown escape 'o'
> > > > ./include/linux/compiler.h:194:8: error: attribute '__gnu_inline__':
> > > > unknown attribute
> > > >
> > > > But not the one mentioned in this patch.
> > >
> > > Not sure what went wrong, I see the same warning as the others.
> > > Maybe you have an outdated version of sparse that runs into unrelated
> > > issues?
> > >
> >
> > $ apt list sparse
> > Listing... Done
> > sparse/xenial,now 0.5.0-1build1 amd64 [installed]
>
> Ick, really obsolete, please use the sparse version on kernel.org for
> kernel stuff:
>         git://git.kernel.org/pub/scm/devel/sparse/sparse.git
>
> Loads of things have been fixed and resolved from 0.5.0 which is very
> old.
>

Thanks for this info. Now it works pretty well.

-Sumit

> thanks,
>
> greg k-h
