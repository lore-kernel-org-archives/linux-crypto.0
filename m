Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7BEC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA87520700
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GlgoNzJf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfBTKhX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:37:23 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:50849 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfBTKhW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 05:37:22 -0500
Received: by mail-it1-f196.google.com with SMTP id m137so14116889ita.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 Feb 2019 02:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TyZXR8X5Rn+nYEV2NRecMRmQeX8D0SJaM0WtbT314Ic=;
        b=GlgoNzJf/JPzUpUmlLfzTmG8WuRFiOJYzmx0vVs7En1QFxdxLgHG5Lz+nni0x3JZWL
         puAfP8/mVumt37zsJTrI1eYIPNPhEj8TI5eWZcA0qcsI5wXVTL14ZRz4/13JSrohIEGH
         V9pjFrWyDM3SGCxhz09JhQe7QC2j38PwCVmBXna5Ael8OJgWyMesAY4aowbh2E/qFheZ
         b5uNQ/RcNb3ZhszGrWv8qTS7MD9Zqm8Fqwlhm1r1KIk3Pg3/ncqpAr+P2M3PjlTYXxVZ
         s21vcGARKQzX4IcMWKUbrFdGwt9Bn0+NwBiRao5q9W65hP1w1RUXSXrjVEPSxMALT31/
         LHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TyZXR8X5Rn+nYEV2NRecMRmQeX8D0SJaM0WtbT314Ic=;
        b=M0g/j+S+ZRMBf+QVhzTlYe5lT7nZqKI0+NYXs9rfk45qzX/ulrx9URVVAk955lFfUD
         kPe9f/OAQXSEXELUWa/zognoiXiPv/DxQBtfGfZtP56PdfG0otwQOl6SL7hl2uXKajig
         NpMQfsqbxPIt9NT1kpPd0WXzZRava7HqjMAb7Nfrmf66VDO2aeLxQWBRhibjdO5CDs/K
         dYnWrg31lWsTX8ZpgALD/akl9VNWMXsTy1iWlV6PvxfUCT4j3xKbofdZAz0kr7R0kKL3
         9cFcJ44zBwydKDP+b2nhezToopO7a/jETkkt4HMQW7IRzHA3byZpBTHZ47C2+BfqJZEi
         u4Cg==
X-Gm-Message-State: AHQUAuYV55J5JbvWLduT6olT5rRY8+2TQSh7kFRJp+E3aYrI0Bf5+QUo
        xY0nd6HoKLofmrwAtwghSoYa9NVVYU838p4CL65axw==
X-Google-Smtp-Source: AHgI3IYyA+2o0gnQCR3Xw2fzn9sYWBuVyvDo6yIa76BFxgsgDvE7S+37Tt1MRhejuZLgIu9WeZnywKKNQwicK0nAJSs=
X-Received: by 2002:a5e:9704:: with SMTP id w4mr21305263ioj.60.1550659041606;
 Wed, 20 Feb 2019 02:37:21 -0800 (PST)
MIME-Version: 1.0
References: <20190220093458.159208-1-weiyongjun1@huawei.com> <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
In-Reply-To: <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 20 Feb 2019 11:37:10 +0100
Message-ID: <CAKv+Gu9yWEVvvoh8KOX1waZUrM1hy+P99Rxh3U2nPYE_sgyJzQ@mail.gmail.com>
Subject: Re: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
To:     Sumit Garg <sumit.garg@linaro.org>
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

On Wed, 20 Feb 2019 at 11:34, Sumit Garg <sumit.garg@linaro.org> wrote:
>
> On Wed, 20 Feb 2019 at 14:51, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> >
> > Fixes the following sparse warning:
> >
> > drivers/char/hw_random/optee-rng.c:265:35: warning:
> >  symbol 'optee_rng_id_table' was not declared. Should it be static?
> >
>
> I haven't observed this warning during my normal Linux build using
> gcc. Is there any specific configuration you are using?
>

This is a sparse warning, not GCC. You need to install it separately
and build with C=1 (iirc)


> > Fixes: 5fe8b1cc6a03 ("hwrng: add OP-TEE based rng driver")
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > ---
> >  drivers/char/hw_random/optee-rng.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> > index 2b9fc8ac5500..3a4dd6fc9ff4 100644
> > --- a/drivers/char/hw_random/optee-rng.c
> > +++ b/drivers/char/hw_random/optee-rng.c
> > @@ -262,7 +262,7 @@ static int optee_rng_remove(struct device *dev)
> >         return 0;
> >  }
> >
> > -const struct tee_client_device_id optee_rng_id_table[] = {
> > +static const struct tee_client_device_id optee_rng_id_table[] = {
> >         {UUID_INIT(0xab7a617c, 0xb8e7, 0x4d8f,
> >                    0x83, 0x01, 0xd0, 0x9b, 0x61, 0x03, 0x6b, 0x64)},
> >         {}
> >
> >
> >
