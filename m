Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3ED4C76191
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 07:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA2002173B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 07:28:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DIY9XY4h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfGRH2R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 03:28:17 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:35425 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfGRH2R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 03:28:17 -0400
Received: by mail-wr1-f54.google.com with SMTP id y4so27482118wrm.2
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2019 00:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zllCHY/cRVRmhrsSL2iE9WJ0AIohaFe+eHpEOu+sQFU=;
        b=DIY9XY4hX0T14cuJ8OXQjvqwvkd8HuXVjCn8+rlK9CzCPUk7Z2b9cQCkW050Iw+bU3
         vzsaPfEoTSeO6wjM8un9rUwFoJQg6XOcDGUMF6e2S7S0OHJVV5qVVl6IrSZbp+PM/qWF
         K5ZQGoj8N1RHbS4JLMDLW3PCncnpUjzLBMTlO0VSNquypJAHwbRAnWdedaIrbkrEp/Fn
         +shvmAqjwoOYk8T81uHzdFlQ9YHyTodFR+bomNzRarWRE99eoj2xS5rNnM+DicYvBy+F
         u+cEWVtXyuCSFvcNE3PSdP/+ahNIQpZiWjkIjH4126nhKXJi20AxH03Rk6qz4HepOBvI
         J84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zllCHY/cRVRmhrsSL2iE9WJ0AIohaFe+eHpEOu+sQFU=;
        b=UurnyJAscadE6eoevtk+FcEXJqEYTsK1Dp7Na0Rl3htxRrTxqO2jq7s+ItLqQhJhod
         Jp9PkBN0xYCfZtv3REWjybPTAhVbdM0zH4y2Gs42I9nd+S1hs9Ro/UwAXCtFElu9GpYk
         WGg9nxB3nzf2c+hcaPUXe18SeWlv4AhxZqNXnkvrmSkvzSIHIm/m3Lhp+bKIRKvHr2hV
         MDAl6gj+0QbjXeZsRHeWiP36Cx++T9v0Je83MxuKOf35rCOTRmo/SoK1mvUwtt/vjo/R
         DZptbL0CqI5LQcsD9ffpoI0H/ElKx9QSLvCgPsr2DaAqMlWZVUTCy46ItKboAhFne9Dj
         DgZQ==
X-Gm-Message-State: APjAAAUwrfawunVU8k5xQ6Nnqt1E7AzFWV46EDm4xc1SI8xjkU3Clwak
        5Zxc720ACh+zaKwQX6kHTQZLE9hBryWbpiMH8qHLMQ==
X-Google-Smtp-Source: APXvYqz2KeADeEBZzbaWHI9EeYR4xSsmdE03VIrqg0AqBBcAwB+aC1wb3gUSXW1Tue7fJA098aG2FYk0jpQIXxnujZ8=
X-Received: by 2002:adf:e8c2:: with SMTP id k2mr33687652wrn.198.1563434894890;
 Thu, 18 Jul 2019 00:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190716221639.GA44406@gmail.com> <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com> <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au> <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
In-Reply-To: <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 18 Jul 2019 09:28:03 +0200
Message-ID: <CAKv+Gu_CVBKUkb19yPPHJp3HcnAgxRn834yfKHcuUD5A69786g@mail.gmail.com>
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

On Thu, 18 Jul 2019 at 09:22, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jul 18, 2019 at 09:15:39AM +0200, Ard Biesheuvel wrote:
> >
> > Not just the generic implementation: there are numerous synchronous
> > and asynchronous implementations of xts(aes) in the kernel that would
> > have to be fixed, while there are no in-kernel users that actually
> > rely on CTS. Also, in the cbc case, we support CTS by wrapping it into
> > another template, i.e., cts(cbc(aes)).
> >
> > So retroactively redefining what xts(...) means seems like a bad idea
> > to me. If we want to support XTS ciphertext stealing for the benefit
> > of userland, let's do so via the existing cts template, and add
> > support for wrapping XTS to it.
>
> XTS without stealing should be renamed as XEX.  Sure you can then
> wrap it inside cts to form xts but the end result needs to be called
> xts.
>

If we were adding XTS to the kernel today, then I would agree with
you. But xts() has an established meaning now, and I don't think it
makes sense to update all implementations for a theoretical use case,
given that no portable userland code can rely on the correct semantics
today, since CAAM is the only one that implements them correctly.

In any case, I won't have time to fix the ARM or arm64 implementations
(or review the changes if someone else steps up) until the end of
September.
