Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D47CA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 16:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 452EE2084B
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 16:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388740AbfJVQRg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 12:17:36 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:36489 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbfJVQRf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 12:17:35 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MO9vD-1igY3r0lq5-00OaRo; Tue, 22 Oct 2019 18:17:34 +0200
Received: by mail-qt1-f182.google.com with SMTP id u22so27548891qtq.13;
        Tue, 22 Oct 2019 09:17:33 -0700 (PDT)
X-Gm-Message-State: APjAAAVVsDH9Dx0DMUddF7SQc69kO/vvo27iR978Rcab1Xi25EOUH3S5
        RbOdo7Lse1xU3vXLljxWYoZopYC8aOAHMEnT3w4=
X-Google-Smtp-Source: APXvYqzOVveCcqi6IzsUb1jWOUTf6iMi0+WDBOpmGm2qZQuClTYIYUCOIg/E6ED39g/gNb+nD+rxAapci4yU+CYXkiI=
X-Received: by 2002:ac8:18eb:: with SMTP id o40mr4277193qtk.304.1571761052972;
 Tue, 22 Oct 2019 09:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <20191022142914.1803322-1-arnd@arndb.de> <MN2PR20MB29732A5C1B14AE24DD7531A3CA680@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29732A5C1B14AE24DD7531A3CA680@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 22 Oct 2019 18:17:16 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1-d7PmYB6v9y2DFD+kOB9ebDsixhFNcuxVJ2+rrBwjqA@mail.gmail.com>
Message-ID: <CAK8P3a1-d7PmYB6v9y2DFD+kOB9ebDsixhFNcuxVJ2+rrBwjqA@mail.gmail.com>
Subject: Re: [PATCH] crypto: inside-secure - select CONFIG_CRYPTO_SM3
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:8p6IsfGbVz0hGZQIFrLX7uaVKL5DNWbfLFWQX0A851z+dPKH9n/
 B4Sq0SRyMN/0AtuEAzUbLolWkEsMQyI+XJVHEIgNy1TPQvdFLQCeIyLu+XaIjhK+p+SnNGH
 llFaf4K6pEfdJ8Epuf5wXDjYupX5zeoWId6ALD6N8gYT/CXUBEq+90Yx2BDC3I3+3SYF92S
 uF2ORlRRgjLnnDJaF7eKw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:L5rxhNVuXIc=:xKEVhUbPuqVibDmdfqMLZD
 qsaYeDH5Kzq9GKBWpRyEsm7d3cz+iipopPkGfWaRfrFocpiHMhs51l4L5CBFxwpMWJjSUR1Qd
 KpsEhHRuBVh9FAFTv2M3Vlpp3Lryi8W1psOdTeCciIwEpGBzWSY2XGUxcHrIHJs0BOjuL5Nr7
 SkOc0d3ivJoNbVMqQVXQKAPPLUH93SdFa0dglJIIh7afikzelgRXzI0wwihDir9JApBHTW05l
 AOLs18Z7Asrz8HVSCPpfcAwRxJlauOYG1SXYUfYEdp4mrQZB+UNq7pTFh5RCf3TInnqsU8IhX
 qViH4GWirZQoFTbiDfTW9/InpASrOvtICmtHMcJQxjhkpIbXNieEeDfAvo72eEc2XPyBqHTuA
 Cs3sKx/EJY0LcOHXlvzJk5aZrzk8ofF8SJDxrjtUzEIIRd7z6HXPv1zefDIgbPGWW2BMgtbQt
 vLOR2+YtnLc51YDxGLISl82vFbqYxLzZYns1pvwqnOnuleSIfPt0FEyOBaXRElTFnTqiovRFV
 anE9blKeSSxVFoVHPSxAQRnLZr6WrLIGdUhxgkTGVSvCfJDfrQEiurkbmj8ORMGRxJ43vy1Ys
 fJyzHQtjvaO098HIqAK1Kb8gzySpaMt4ehFKlTjKyL3UqbR5xSQshP33WR2pdC49XZfXH5inC
 vDUPaw+ojrTJzyQonuVM83vXhw98MSkf0puoL531j8l/f/tzA1JUrPGTY0lA3chzt3sojJT+q
 Givy/G/Z0DaeCPTsHux6YTGIzAHZ93UoqBl2qdgnk3KOr6Rf/WtKR+vBnljFzkqeKF9l0H7hs
 ZKFaqKC0KcGKlTaBaoNdNVZJ85PxOxpR5MuWVgxjvZxkLD+oyZ9m+vo/Ad8nMXu5EFBbiy0Nm
 MfHI9Ypp02HDG8dXOffg==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 22, 2019 at 5:42 PM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:

> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> > index 357e230769c8..1ca8d9a15f2a 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -753,6 +753,7 @@ config CRYPTO_DEV_SAFEXCEL
> >       select CRYPTO_SHA512
> >       select CRYPTO_CHACHA20POLY1305
> >       select CRYPTO_SHA3
> > +     select CRYPTO_SM3
> >
> Was this problem observed with the latest state of the Cryptodev GIT?
> Because I already attempted to fix this issue with commit 99a59da3723b9725
> Can you please double check if you still get the compile error with that
> commit included?
> (I can't tell from this mail which version of the sources you are using)

I was testing on linux-5.4-rc3 plus some of my own patches, so your fix
was not included.

With your patch applied, mine is no longer needed.

        Arnd
