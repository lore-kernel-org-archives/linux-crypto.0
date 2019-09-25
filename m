Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2641C432C2
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 21:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9172B21D7F
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569445315;
	bh=idu5KI/Snizuu/FJ6EXt4an5/Lb4SEnzgEmXIgjonIk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=dcRPguKsJ51RE2x4vWgqzkByvFxlEKU/rRoDYa2ML5QarI75vYeNPlCznBxSusnhQ
	 sqJJE3LzUl9En79vAee/4R8c7aMWoUTLJ4c4Owm+scY8FG0rL92UFHOVBgktAgzLhO
	 mrEeCIwbtDGW2puAznypa49x9PSa+rhU5/shyVKE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388187AbfIYVBy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:01:54 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42972 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfIYVBy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 17:01:54 -0400
Received: by mail-lj1-f194.google.com with SMTP id y23so7152979lje.9
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 14:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y4WwKMmfBss6jCT8sswdSW8XG9WNLoHbSfuw/zcQnv4=;
        b=XSKk1k0mpU0UMH+Zcok2JKeL1jHtU9jXhTOXZTQLNoPC/tSNq4KHOihGeNblVsloZw
         Tjqp4BgW8O21/Z9FlMga7c8GZcxgjFqu+MgvyTCRXh18WIAGOjsbAeQjSInnJzj0uqdh
         C1lWhBJiJ/IwD3KYacmToe044cXx+wZjlPIXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y4WwKMmfBss6jCT8sswdSW8XG9WNLoHbSfuw/zcQnv4=;
        b=O1wGuxOukZA4PNZoBJNSzxLx0bm/HWttCByoCpoot4Uw4tqM+auSrXc/0Ot8g10A1V
         247t0WAOPj+wdY5W4FixyqqCcwa7ChOuEoo5eVEAUl591KEELUbounRV+bCU3YHerJvq
         qlodzttwiMGz7bodNSFxELxFH4HtFhbA0nhgrY61Ta/10yPmcCHEoJ/4qHzsiUdQ8LwH
         AuiWAsR3zPDl6ZCh+S7esURi2qvJhKFhPvSXpVVvnqpW8KHtv6czmZYyrdiSe3BCV199
         2gI1RrCA+6pxHijcE61IUbAKgFWhg9KQwx4MNm2qC4f3JldWJvfz2lTvfeM++13EDcO3
         mYNA==
X-Gm-Message-State: APjAAAXln8B7j8Yf+Vwl+gCfS87CX9puQeeXkIz8YXkJ+cl80gJNfx78
        lYWIGCR7GzdvbFDlSvC08SpQwWiWFBc=
X-Google-Smtp-Source: APXvYqzwJtzsA0p3SlVJHqQnMtbplKXJsA2SLyzfvG1hJIdcDh+VhMBrDGdE2rhMutC+YwWXv08KPg==
X-Received: by 2002:a2e:4243:: with SMTP id p64mr176807lja.213.1569445311221;
        Wed, 25 Sep 2019 14:01:51 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id c15sm56133ljf.1.2019.09.25.14.01.49
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 14:01:50 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id e17so7143381ljf.13
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 14:01:49 -0700 (PDT)
X-Received: by 2002:a2e:9854:: with SMTP id e20mr218041ljj.72.1569445309746;
 Wed, 25 Sep 2019 14:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org> <20190925161255.1871-12-ard.biesheuvel@linaro.org>
In-Reply-To: <20190925161255.1871-12-ard.biesheuvel@linaro.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 25 Sep 2019 14:01:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi8+MHz8xGtx_mUZPBsRT6qkptGW7a_pOrK=SnTRAiecA@mail.gmail.com>
Message-ID: <CAHk-=wi8+MHz8xGtx_mUZPBsRT6qkptGW7a_pOrK=SnTRAiecA@mail.gmail.com>
Subject: Re: [RFC PATCH 11/18] int128: move __uint128_t compiler test to Kconfig
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 25, 2019 at 9:14 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
>  config ARCH_SUPPORTS_INT128
>         bool
> +       depends on !$(cc-option,-D__SIZEOF_INT128__=0)

Hmm. Does this actually work?

If that "depends on" now ends up being 'n', afaik the people who
_enable_ it just do a

       select ARCH_SUPPORTS_INT128

and now you'll end up with the Kconfig erroring out with

   WARNING: unmet direct dependencies detected for ARCH_SUPPORTS_INT128

and then you end up with CONFIG_ARCH_SUPPORTS_INT128 anyway, instead
of the behavior you _want_ to get, which is to not get that CONFIG
defined at all.

So I heartily agree with your intent, but I don't think that model
works. I think you need to change the cases that currently do

       select ARCH_SUPPORTS_INT128

to instead have that cc-option test.

And take all the above with a pinch of salt. Maybe what you are doing
works, and I am just missing some piece of the puzzle. But I _think_
it's broken, and you didn't test with a compiler that doesn't support
that thing properly.

             Linus
