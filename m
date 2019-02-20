Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979BDC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 11:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68770205F4
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 11:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oAtrlr2G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfBTLR0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:17:26 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:39584 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfBTLR0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 06:17:26 -0500
Received: by mail-ua1-f68.google.com with SMTP id s15so8058446uap.6
        for <linux-crypto@vger.kernel.org>; Wed, 20 Feb 2019 03:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=biHWDipVc/kAotl6ICScQ7XtqzbH1MkgjzSmP0ZZr2Y=;
        b=oAtrlr2GM9P0mmAE5Ho2g7TRzzJlZCNIgCuh3mv5+5ZCOWDOTWZkg2k1w5C/E2DE3K
         e9v1E6rGiX5kHh8+aOQiYgeFZH3auGD8Npls91qTdWEJSoSUyJjl4ipBuM+oCnBdSzyG
         SVWh3+ES78UBxzHbLIvbvN+AcZQyp4x0aY06uHqNcZr8mN/styMLny85ogrksrGsTpja
         94CUD8IEg2AAAHBMXGb+b0Cfa4TDaDrzWfgQgZ+2SphlP45wXRcs74gqxp+USpVassoX
         JnKqw5bPeB2ZZ/4UoFVFSMK8BSFfaBJucVlUKJAPVrGy1yXe6ewaXJSYX7EIg746zsRy
         nJzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=biHWDipVc/kAotl6ICScQ7XtqzbH1MkgjzSmP0ZZr2Y=;
        b=GfT9DiQUsC2nqF6zc7w0e29lBpBmHRjFnOAOiHIFXQypmdSsNqWEKZjddDaLXITWrX
         LSUuaKVyJG6IlE7S52TUo1W21hPE7G9wtJRBpDz7k82jHAbSqAgKI7q9bEFpYmwiqLrA
         hQe4rxKePl08iXiqcZWTBzctMBi7mRkcwn8cdHsYt2mX4M6+JYBLnm+VFD0WJ8VqzA1c
         iFhSTT6Nq6u/GWLIUjXB4a5tgv7dXb6+NoEOxxeD1XtDu/X7uUtlDSlR1F2snSoH4Nkk
         +QX10/xWwKhHOtOZz8yiZ6z04P8ibY9llCkMKjenQfXgsH9R33T9W7IptlzUu9QHHcgO
         VAyg==
X-Gm-Message-State: AHQUAubNUJKxsuly3feTHcaPy9zGqFYGIPr5rj0l1w4cYoSyhPkngUB+
        ZtjyuFkvG0Jd63UZ2ug6NNtBFh9PSqQB0dH7bDXqLA==
X-Google-Smtp-Source: AHgI3Ib52IP6BC2rj+Zunae2C8E9brp2sss+xaZQX/KZLAhLg6m7nJVmuprFeHNb+FN0TzKMnrwEGeK+jpujGNXaZB4=
X-Received: by 2002:ab0:b8:: with SMTP id 53mr9002590uaj.33.1550661445482;
 Wed, 20 Feb 2019 03:17:25 -0800 (PST)
MIME-Version: 1.0
References: <20190220093458.159208-1-weiyongjun1@huawei.com>
 <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
 <CAKv+Gu9yWEVvvoh8KOX1waZUrM1hy+P99Rxh3U2nPYE_sgyJzQ@mail.gmail.com> <8a3ff7ae-9257-82f1-70e2-91cc77aa7377@canonical.com>
In-Reply-To: <8a3ff7ae-9257-82f1-70e2-91cc77aa7377@canonical.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Wed, 20 Feb 2019 16:47:14 +0530
Message-ID: <CAFA6WYMU0GwYaOgyoCAKSUat0kHOGRnV6UWG0Co0EfHrpO4ryA@mail.gmail.com>
Subject: Re: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
To:     Colin Ian King <colin.king@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Feb 2019 at 16:19, Colin Ian King <colin.king@canonical.com> wrote:
>
> On 20/02/2019 10:37, Ard Biesheuvel wrote:
> > On Wed, 20 Feb 2019 at 11:34, Sumit Garg <sumit.garg@linaro.org> wrote:
> >>
> >> On Wed, 20 Feb 2019 at 14:51, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> >>>
> >>> Fixes the following sparse warning:
> >>>
> >>> drivers/char/hw_random/optee-rng.c:265:35: warning:
> >>>  symbol 'optee_rng_id_table' was not declared. Should it be static?
> >>>
> >>
> >> I haven't observed this warning during my normal Linux build using
> >> gcc. Is there any specific configuration you are using?
> >>
> >
> > This is a sparse warning, not GCC. You need to install it separately
> > and build with C=1 (iirc)
> >

TBH, I wasn't aware about this sparse tool. I did install sparse and
build with C=1 option. But I could only get following such
errors/warnings for drivers/char/hw_random/optee-rng.c:

./arch/arm64/include/asm/lse.h:18:37: warning: Unknown escape 'l'
./arch/arm64/include/asm/alternative.h:213:28: warning: Unknown escape 'o'
./include/linux/compiler.h:194:8: error: attribute '__gnu_inline__':
unknown attribute

But not the one mentioned in this patch.

> It's useful to may these symbols static just to reduce the scope and
> there is on-going work to fix these symbols up across the entire kernel
>

Agree with this patch to make optee_rng_id_table symbol static.
Actually I was curious to know the approach used to get these type of
warnings so that they could be fixed beforehand.

-Sumit
