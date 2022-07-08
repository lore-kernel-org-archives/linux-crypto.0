Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3ADDC43334
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jul 2022 12:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiGHMrJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jul 2022 08:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiGHMrI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jul 2022 08:47:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6ACBF326C2
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2022 05:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657284424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dE7am2qZLWCC7z65J2aM6/B2V9+Pl8ooChSgECZZn1k=;
        b=e2MlSa0QdfMt5uR5w1JXTOb2bK27cWArbCg2K0xACdL29ehYASNi0Kd9drsdhLYIeFLIsW
        b2fuFkxLDVX9eBF8e00CQzG+evpXMz5S/u/nEjcpp1XUoyYRoY74lCQY56JfuNR35VPkzR
        q6VSxZXv+IZZT9Q38quhEm/tHk21B24=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-5Xz8IW79NQay_k4-OfID6A-1; Fri, 08 Jul 2022 08:47:03 -0400
X-MC-Unique: 5Xz8IW79NQay_k4-OfID6A-1
Received: by mail-ed1-f69.google.com with SMTP id m10-20020a056402510a00b0043a93d807ffso4145429edd.12
        for <linux-crypto@vger.kernel.org>; Fri, 08 Jul 2022 05:47:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dE7am2qZLWCC7z65J2aM6/B2V9+Pl8ooChSgECZZn1k=;
        b=HbDMdz3hdmdhlV45sweftYgRk8J/KJoAlQsXWA8JqU2TMI/stKa+DPo82XybWZs+OO
         v3qbjntiRPUwpXrUzpcSdRLLNJzJ3Cx5ALBuxdCI7hzFZ6pRNZONwCRQ7kpkvCXVFWt0
         Ty1yhKA3QPZQtH5mbJ2dpdhPiUrFhr3LYlK7THxJatyjQviIr+1dYG0zI4jLqDzpx2Cv
         rnjpaQpK50HUhw4oM7SF5r/8Of5F2lMD8eoohsp+SdtTkTUAc7YJc2z5lkrCRyQ7KgzS
         CRzNUDlH+mBIC3FBu7F+byCJnYl6ZTtoZMOIyZWJdyWqCCsRuTZCKD96uUIET//SXGt6
         d8RA==
X-Gm-Message-State: AJIora+pm3J9GUMLOUIoHfCFW4hQuC5BGKs6fsnm0HSn1mUstzuXpgHg
        SNTtydIs92Eb4zGXWzi3UmMW763OYhE+RymKvXgKvDKGV2iaKnr7K1hdPhDfrUeHQ9qPG6G1WZj
        vtLB/e4PleF1XZWRiGMaIySwGa6UzPXdkEbPLbjUA
X-Received: by 2002:a05:6402:3551:b0:43a:a5c0:2fbc with SMTP id f17-20020a056402355100b0043aa5c02fbcmr4533860edd.288.1657284422067;
        Fri, 08 Jul 2022 05:47:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t0baia0qjnBRPMWggkVJVUHjsBDBJIk0iKohafPMy/4sJgj8fQu1EU9tbAdY4QzjAnUHsY+KoFz7Su7AFx8yk=
X-Received: by 2002:a05:6402:3551:b0:43a:a5c0:2fbc with SMTP id
 f17-20020a056402355100b0043aa5c02fbcmr4533846edd.288.1657284421915; Fri, 08
 Jul 2022 05:47:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220620131618.952133-1-vdronov@redhat.com> <20220627195144.976741-1-vdronov@redhat.com>
 <YsfappxjOaj99WEV@gondor.apana.org.au>
In-Reply-To: <YsfappxjOaj99WEV@gondor.apana.org.au>
From:   Vlad Dronov <vdronov@redhat.com>
Date:   Fri, 8 Jul 2022 14:46:51 +0200
Message-ID: <CAMusb+Q=Y8CSAnHDF3W56s=SvqNKYV=EYQ9+J=Me35mCA8ZYig@mail.gmail.com>
Subject: Re: [PATCH v3] crypto: fips - make proc files report fips module name
 and version
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Simo Sorce <simo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Herbert,

On Fri, Jul 8, 2022 at 10:27 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jun 27, 2022 at 09:51:44PM +0200, Vladis Dronov wrote:
> >
> > diff --git a/crypto/fips.c b/crypto/fips.c
> > index 7b1d8caee669..d820f83cb878 100644
> > --- a/crypto/fips.c
> > +++ b/crypto/fips.c
> > @@ -30,13 +30,37 @@ static int fips_enable(char *str)
> >
> >  __setup("fips=", fips_enable);
> >
> > +#define FIPS_MODULE_NAME CONFIG_CRYPTO_FIPS_NAME
> > +#ifdef CONFIG_CRYPTO_FIPS_CUSTOM_VERSION
> > +#define FIPS_MODULE_VERSION CONFIG_CRYPTO_FIPS_VERSION
> > +#else
> > +#define FIPS_MODULE_VERSION UTS_RELEASE
> > +#endif
> > +
> > +static char fips_name[] = FIPS_MODULE_NAME;
> > +static char fips_version[] = FIPS_MODULE_VERSION;
>
> This doesn't compile for me because you need to include
> generated/utsrelease.h.

Dang, it does not build now indeed. I'm not sure how my previous
build succeeded so I've assumed utsrelease.h is included in fips.c
via some other .h file.

I've posted v4 to this same thread below, it just adds the "#include
<generated/utsrelease.h>" line.

I'm sorry for the noise.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

