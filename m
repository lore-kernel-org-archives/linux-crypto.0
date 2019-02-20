Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45502C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 16:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1468E2146E
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 16:26:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uNaO8X1T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfBTQ0D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 11:26:03 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:46058 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfBTQ0D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 11:26:03 -0500
Received: by mail-vs1-f66.google.com with SMTP id u64so14269079vsc.12
        for <linux-crypto@vger.kernel.org>; Wed, 20 Feb 2019 08:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c9AoN5insXzyeIeBbNuDHtP8i03HHSDK4SLPHoTyWyY=;
        b=uNaO8X1TApJRISxYIdacq4Q/Vj8d+Cq/fxUrnExONOvKbuEAcenj2sCfB5kMGfVHJl
         6AXmPn8S/iDndWicqBBTtI1YMLMMPpGauVSHBFZdDuN6SdZ2Jkk889ea3Lk7tcTuPbIr
         563ZItkDlKsFHAoCpQkSKyxMJzKUMzRhf7da9gLRWxddlnA3lCDtRBW8x+JJKONRGK8w
         +GpZotBODp9aOngQ0WHQ1IUWotjienAhCw59sd6vD1A4+JYwT247cic5J2pERD8Ip8r0
         sL+gZ4RiYh4P9E1yfO8LGIKhT6nJ+UkSaKNoeDpZQrJfQms5dd1Tf1xksOMB00tcSjBI
         FmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c9AoN5insXzyeIeBbNuDHtP8i03HHSDK4SLPHoTyWyY=;
        b=ZvD3z6PC1uSxfMX2ky7Tp0GPS7t8xc327JME2u/GOJQpnYSXT8ftm7V95Wi2kKKfb9
         R84Ny6AqwMuhiisLQqrn6j8bALU5216ybsZ8/dprugwnj+zurejwZSLv6GWRx8JOLGMK
         vD9g8Uq70iywJLmfrLxQnfoG6qS7AFdz4vFzlS2HB+fpAfHYHmOBfJh3VuLvLVpmFh4M
         n4kvP9SYDDX+s03EXAmIw4soMKUZ5uxD4W8JS5/IFaCJTaqR0U5oQKbgFtnmfQiE4LV3
         dOnmTLWn6gslnRi0bT5NBjfMzAAOIsYNowbNnUeMWbmPJnXhqN8/T++ZslCEUGUQQoD/
         iN4A==
X-Gm-Message-State: AHQUAuZjbzobzD7fIqid6XzKIte4Ai35f2QvtTXw6h0EF60R27iknLRV
        iv3it5daosZ7QSliPi4IBlOdS45jAk62NQ0R6ajV1A==
X-Google-Smtp-Source: AHgI3IacyxEF4GyDRUcH8/CXwkTn9E9ZEvG1L4tOOAhXe2u5JdN5TBwAShj5+e+tqw46EUl7bZBCg1gzakKqIrkY0P0=
X-Received: by 2002:a67:8355:: with SMTP id f82mr17682536vsd.89.1550679961652;
 Wed, 20 Feb 2019 08:26:01 -0800 (PST)
MIME-Version: 1.0
References: <20190220093458.159208-1-weiyongjun1@huawei.com>
 <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
 <CAKv+Gu9yWEVvvoh8KOX1waZUrM1hy+P99Rxh3U2nPYE_sgyJzQ@mail.gmail.com>
 <8a3ff7ae-9257-82f1-70e2-91cc77aa7377@canonical.com> <CAFA6WYMU0GwYaOgyoCAKSUat0kHOGRnV6UWG0Co0EfHrpO4ryA@mail.gmail.com>
 <CAK8P3a3FMa9tpw4rj+8Aue2EYxxKSD4nxdwRFrzac_87Kzio5g@mail.gmail.com>
In-Reply-To: <CAK8P3a3FMa9tpw4rj+8Aue2EYxxKSD4nxdwRFrzac_87Kzio5g@mail.gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Wed, 20 Feb 2019 21:55:50 +0530
Message-ID: <CAFA6WYNCxGTqw6LKUPK-ceWD1NbAhJQmzrH5fwOVRP5f2Auz2Q@mail.gmail.com>
Subject: Re: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Colin Ian King <colin.king@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Arnd,

On Wed, 20 Feb 2019 at 21:04, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Feb 20, 2019 at 12:17 PM Sumit Garg <sumit.garg@linaro.org> wrote:
> >
> > On Wed, 20 Feb 2019 at 16:19, Colin Ian King <colin.king@canonical.com> wrote:
> > >
> > > On 20/02/2019 10:37, Ard Biesheuvel wrote:
> > > > On Wed, 20 Feb 2019 at 11:34, Sumit Garg <sumit.garg@linaro.org> wrote:
> > > >>
> > > >> On Wed, 20 Feb 2019 at 14:51, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> > > >>>
> > > >>> Fixes the following sparse warning:
> > > >>>
> > > >>> drivers/char/hw_random/optee-rng.c:265:35: warning:
> > > >>>  symbol 'optee_rng_id_table' was not declared. Should it be static?
> > > >>>
> > > >>
> > > >> I haven't observed this warning during my normal Linux build using
> > > >> gcc. Is there any specific configuration you are using?
> > > >>
> > > >
> > > > This is a sparse warning, not GCC. You need to install it separately
> > > > and build with C=1 (iirc)
> > > >
> >
> > TBH, I wasn't aware about this sparse tool. I did install sparse and
> > build with C=1 option. But I could only get following such
> > errors/warnings for drivers/char/hw_random/optee-rng.c:
> >
> > ./arch/arm64/include/asm/lse.h:18:37: warning: Unknown escape 'l'
> > ./arch/arm64/include/asm/alternative.h:213:28: warning: Unknown escape 'o'
> > ./include/linux/compiler.h:194:8: error: attribute '__gnu_inline__':
> > unknown attribute
> >
> > But not the one mentioned in this patch.
>
> Not sure what went wrong, I see the same warning as the others.
> Maybe you have an outdated version of sparse that runs into unrelated
> issues?
>

$ apt list sparse
Listing... Done
sparse/xenial,now 0.5.0-1build1 amd64 [installed]

> > > It's useful to may these symbols static just to reduce the scope and
> > > there is on-going work to fix these symbols up across the entire kernel
> > >
> >
> > Agree with this patch to make optee_rng_id_table symbol static.
> > Actually I was curious to know the approach used to get these type of
> > warnings so that they could be fixed beforehand.
>
> If you provide an 'Acked-by' or 'Reviewed-by' tag, I can apply this one
> on top of the other two fixes I already took.
>

Sure.

Reviewed-by: Sumit Garg <sumit.garg@linaro.org>


> I also recommend building with 'make W=1',

Thanks for your suggestion.

> which enables additional
> warnings and found this bug in your driver:
>
> drivers/char/hw_random/optee-rng.c: In function 'get_optee_rng_data':
> drivers/char/hw_random/optee-rng.c:94:11: error: comparison of
> unsigned expression < 0 is always false [-Werror=type-limits]
>   if ((ret < 0) || (inv_arg.ret != 0)) {
>            ^
> drivers/char/hw_random/optee-rng.c: In function 'get_optee_rng_info':
> drivers/char/hw_random/optee-rng.c:188:11: error: comparison of
> unsigned expression < 0 is always false [-Werror=type-limits]
>   if ((ret < 0) || (inv_arg.ret != 0)) {
>            ^
>
> Here, you probably need to make 'ret' an 'int', and you should drop
> the extraneous zero-initialization for a couple of variables like that one,
> so gcc is able to do its job of warning about uninitialized variable
>

There are already fixes sent in upstream for these. Maybe you could
pick those too.

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1935826.html
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1935849.html

One more reported by Dan Carpenter here:

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1936881.html

Thanks,
Sumit

>       Arnd
