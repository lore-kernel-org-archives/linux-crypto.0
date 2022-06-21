Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F379C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jun 2022 14:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351419AbiFUOgF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jun 2022 10:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350998AbiFUOgF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jun 2022 10:36:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D80D1C93F
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jun 2022 07:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655822163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RSGBimivEze+n4dtbXJkxFNriZUPEE36wmWbROM+6Dg=;
        b=PLb890JRcxA+RVyJgUqt1QhuE3rMT8K4AQYCLKGjTtYForAEhXbFiyHajOgpJT2cYTICeE
        z6qfPyAAcbc0ZQxkcQoiTKO7fcLP+msN2pEAP3NNm5I+yg1MOTtseaBo84j0XcCKky9yfC
        V5xtv2k09xvot5DA428bmfEMpEQwuk0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-swQmb_NsNy2Lws_q4-KoVw-1; Tue, 21 Jun 2022 10:36:00 -0400
X-MC-Unique: swQmb_NsNy2Lws_q4-KoVw-1
Received: by mail-ej1-f71.google.com with SMTP id gr1-20020a170906e2c100b006fefea3ec0aso4915295ejb.14
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jun 2022 07:36:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RSGBimivEze+n4dtbXJkxFNriZUPEE36wmWbROM+6Dg=;
        b=iUL4mQgMGKX54t02qvKvTaXCpYOEagfoiwfGYTPF3NSjEf2+zcXqrzhg2SP0R5Mh89
         babnK+Ea7dp83QDMt86lWkENXMx4wj9CoJwvK+hfFIYiqoG4KWt09n+LYGpQJDiis8Vu
         lah7+RoPlVzSKmXf00X4EtyJOyBVubTVXeiwXYUMziybMKyTfmWz43wjleM9mRGZKW8U
         mwNOXIvuXoN+yIoKmuiRlvnQ72AtohLU/karU4YRtdJNosLTQvn8REgAbh9YWQ6FsDhH
         vrw6zl4leUN8Tz+VhDwPn82unUWQUym9l0ikVuYyPz6CMW2L4JSHuKkYWrRH4YfxesP2
         cA8Q==
X-Gm-Message-State: AJIora++P2LIc59jbTORDWA4mGhgj0Qegb4iaFOPwSAhuOFqI3Aqn7Jg
        7BP7NAGsyVbv7jraUz0Iwn4eFMEGlIBL2wqorGY473WZSL7W7J+YmAdOKjU8IMwvqInzDhes6KO
        y5fscMmksuyNrX8tgXY7TWS2f+xRInTjmv6hoG/r4
X-Received: by 2002:a05:6402:2694:b0:42d:e05d:3984 with SMTP id w20-20020a056402269400b0042de05d3984mr35354886edd.419.1655822159528;
        Tue, 21 Jun 2022 07:35:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uccH1oXNG8W/n8lbN+i3vqJggxl37Nh59lCOkVkXH4xWIJYiQHe8SQW9WE7sOdkib7dRLLvyzpRWt0vZP3Vfk=
X-Received: by 2002:a05:6402:2694:b0:42d:e05d:3984 with SMTP id
 w20-20020a056402269400b0042de05d3984mr35354874edd.419.1655822159382; Tue, 21
 Jun 2022 07:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220620131618.952133-1-vdronov@redhat.com> <23bc9020-4519-65ba-725e-e7efd226c192@infradead.org>
In-Reply-To: <23bc9020-4519-65ba-725e-e7efd226c192@infradead.org>
From:   Vlad Dronov <vdronov@redhat.com>
Date:   Tue, 21 Jun 2022 16:35:47 +0200
Message-ID: <CAMusb+SaCeFe9maPZEE3JuaF1Q18=zj_Ljb0+HeNABKQwAa+mg@mail.gmail.com>
Subject: Re: [PATCH] crypto: fips - make proc files report fips module name
 and version
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simo Sorce <simo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Mon, Jun 20, 2022 at 11:40 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Hi--
>
> On 6/20/22 06:16, Vladis Dronov wrote:
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index 1d44893a997b..082ff03d9f6c 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -33,6 +33,27 @@ config CRYPTO_FIPS
> >         certification.  You should say no unless you know what
> >         this is.
> >
> > +config CRYPTO_FIPS_NAME
> > +     string "FIPS Module Name"
> > +     default "Linux Kernel Cryptographic API"
> > +     depends on (CRYPTO_FIPS)
>
> No parentheses.
>
> > +     help
> > +       This option sets the FIPS Module name reported by the Crypto API via
> > +       the /proc/sys/crypto/fips_name file.
> > +
> > +config CRYPTO_FIPS_CUSTOM_VERSION
> > +     bool "Use Custom FIPS Module Version"
> > +     depends on (CRYPTO_FIPS)
>
> Ditto.
>
> > +     default n
> > +
> > +config CRYPTO_FIPS_VERSION
> > +     string "FIPS Module Version"
> > +     default "(none)"
> > +     depends on (CRYPTO_FIPS_CUSTOM_VERSION)
>
> Ditto.
>
> > +     help
> > +       This option provides the ability to override the FIPS Module Version.
> > +       By default the KERNELRELEASE value is used.
>
> --
> ~Randy

Oh dang, indeed. Thanks, Randy.

Let me post v2 to this same thread to reduce separate threads.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

