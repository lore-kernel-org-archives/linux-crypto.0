Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962FCC76191
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 07:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60F7520880
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 07:15:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yMWCjmgP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfGRHPy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 03:15:54 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:52177 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfGRHPy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 03:15:54 -0400
Received: by mail-wm1-f42.google.com with SMTP id 207so24447148wma.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2019 00:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IyU7RhLs3nexL5XSfrBFHZGbJqE/bFU1qysLbSwPyVo=;
        b=yMWCjmgPhjd+LDHLWy0TfNvmI5s6jQSyQ+ScEsq8JcS355xU1N2kHOoUB29Dl18W13
         kD69QetMlfdNdf7hrDns9OJkf6dHuA2uz0TCEFNKMsTTNB5w/cL+sdwVWAqfeNrLMM3U
         F++1McxJgSCI92IqJvfAqg/wSPOFHVLIGz1ugoyp6r5NRESd/tLRW0saZ6qg977spLjD
         cx0LcdoNrUUJw0KSjhCEGd0lyEErzRDZszGb28DmpcWzaJ9ltznhSSfK+AhN0aRb+ziX
         thgs5PMArqzIKuezFcmyLItpmpcBWSsioskwSQuHXP23o5iWrrBx1zbD5TuTeDmAVrmL
         6e7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IyU7RhLs3nexL5XSfrBFHZGbJqE/bFU1qysLbSwPyVo=;
        b=hKx+Waj1rkL+0unCfkOnsJGZ4kITLngMWiMCti6cbmqfD9/9riO2O3VHF+qxUDWC7a
         tgqDo9qCa5YIR3wvTHpWf6lWqoHvauRpC2hug89qIw7OM89FnywAsQKDMnmzpM5X7WSC
         qSg8eHUVp8v4+3DTnYQ7TwloZ1miEbHUtbcDffnbIiV5cYAf5ennNbvTXK0YWmJNiMTJ
         q6l7k+13qStgstwr0hVc2ePq4ndA9L84oUruMMH56kbbdqvi9cncVpm8OQym/a+GX4ia
         gUfPZdBRkLZKvyZGwbgAdcLWXLosZPhZ1BdbMO2HPuGTmfkuOo1un1i/qKg/lUg5HCU9
         4cFw==
X-Gm-Message-State: APjAAAUufKcIVVdHzF6MzPqLLrjZ6ZhPNGitbIGFIupfY4F/TYCIKqs4
        7baWbvLMKl4Nt9VTZcQ5eFtApe3cwkXSHQK3zzzVVA==
X-Google-Smtp-Source: APXvYqx0U4XKWFnfxvhfk4eFFQ7yQE5LtpnCH6zwJdvkYVmJ7Z+Jl6fTN7vccxs/8QWAGmCUgRsOc7JTTlkQ34GnwRQ=
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr37237828wmj.61.1563434151974;
 Thu, 18 Jul 2019 00:15:51 -0700 (PDT)
MIME-Version: 1.0
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190716221639.GA44406@gmail.com> <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com> <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
In-Reply-To: <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 18 Jul 2019 09:15:39 +0200
Message-ID: <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing support
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 18 Jul 2019 at 08:52, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Jul 17, 2019 at 08:08:27PM +0200, Ard Biesheuvel wrote:
> >
> > Since the kernel does not support CTS for XTS any way, and since no
> > AF_ALG users can portably rely on this, I agree with Eric that the
> > only sensible way to address this is to disable this functionality in
> > the driver.
>
> But the whole point of XTS is that it supports sizes that are
> not multiples of the block size.  So implementing it without
> supporting ciphertext stealing is just wrong.
>
> So let's fix the generic implementation rather than breaking
> the caam driver.
>

Not just the generic implementation: there are numerous synchronous
and asynchronous implementations of xts(aes) in the kernel that would
have to be fixed, while there are no in-kernel users that actually
rely on CTS. Also, in the cbc case, we support CTS by wrapping it into
another template, i.e., cts(cbc(aes)).

So retroactively redefining what xts(...) means seems like a bad idea
to me. If we want to support XTS ciphertext stealing for the benefit
of userland, let's do so via the existing cts template, and add
support for wrapping XTS to it.
