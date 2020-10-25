Return-Path: <SRS0=H1lS=EA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17DF7C4363A
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 23:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C223921D42
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 23:53:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pcAX1d+T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420714AbgJYXxy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Oct 2020 19:53:54 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46138 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1418308AbgJYXxx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Oct 2020 19:53:53 -0400
Received: by mail-qk1-f193.google.com with SMTP id a23so6895959qkg.13;
        Sun, 25 Oct 2020 16:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LBtOv6ii27P7UDwcOYJQCSjkPKpG8hoxT55RTEp71C0=;
        b=pcAX1d+Tz+7IByaAVNQmiVtKSSi9GAqWCZmJuTz1wHVZPnBR6VUgRJWn9MuIOc7n1c
         ma0276pXIw6OsFn/9Ozy2JcWfH9StjzEOUwX3wUqCD0O/rXbHHGkVntSNTJtQ4CrliZp
         9f9oUCatsGSGuMWnjBsFfA8M+CyZfZfUn5dB2NOTDuVssWhhpkbJb0cffixg03lMH8jp
         9Jehzx+RzzrkcQ6j1gC88ZRPQNXyD73KKY4f1RNEen7QEBIjWyyDNH5aapW/fxPRAPWB
         VFI467yMSCdsCSx0ARQhZ8T9FoZdQ2FKUa+n5R/kSKvAGX4EoC5YBUR2otLse55FaIWt
         ImWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LBtOv6ii27P7UDwcOYJQCSjkPKpG8hoxT55RTEp71C0=;
        b=cocOKW8YO+61OTltyTKq2RgGYJYRWMyZ6xtA1U81POWYmcbc0UHV4nhIAu4CwuQZyr
         IPNzgCxoJrbfxi2aDTnqdBfM0yxW8spSE4k9eR3YeDyT38qUYbZ8+Bjdge6Qr/WDMJpm
         jWm6+cNVdap5bKe42lns5T+l+2BdbWw+76MlTmQa+e4yKV8TkIZv0E6C4Nvh4EFlHS3R
         8wIdCSjTKYRkzFGqVlLr0INRdygX2yPvah7fnw9IJZDMMA6QY7gVic8ANEBWUdVgXJZz
         +XSLEzfxReOplEidBX/C7ePsGLrPzgHwL+ueQmo9jSxMPkykNUpDUbWBYSHoYdH5Drjd
         F6HQ==
X-Gm-Message-State: AOAM532iib7Doc76OXth3apOXcvvhw/vvuD02Oo2wgXroofYzkz4iUnO
        B3UtsVXdCsK/rc9abUI2polGQuUEAcX9aw==
X-Google-Smtp-Source: ABdhPJyJsxyvUZ/GbCglvNzYQrDMCbIrcQI1evltOiE4KvF53u16tBfd5xKkaIgPVKsmWy4r72MO8w==
X-Received: by 2002:a37:ad1a:: with SMTP id f26mr13396854qkm.1.1603670032187;
        Sun, 25 Oct 2020 16:53:52 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m38sm1454693qta.8.2020.10.25.16.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 16:53:51 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Sun, 25 Oct 2020 19:53:49 -0400
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Arvind Sankar' <nivedita@alum.mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v4 6/6] crypto: lib/sha256 - Unroll LOAD and BLEND loops
Message-ID: <20201025235349.GA1281192@rani.riverdale.lan>
References: <20201025143119.1054168-1-nivedita@alum.mit.edu>
 <20201025143119.1054168-7-nivedita@alum.mit.edu>
 <05150bdb3a4c4b2682ab9cb8fb2ed411@AcuMS.aculab.com>
 <20201025201820.GA1237388@rani.riverdale.lan>
 <5d8f86fcfe84441fa5c9877959069ff1@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5d8f86fcfe84441fa5c9877959069ff1@AcuMS.aculab.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 25, 2020 at 11:23:52PM +0000, David Laight wrote:
> From: Arvind Sankar
> > Sent: 25 October 2020 20:18
> > 
> > On Sun, Oct 25, 2020 at 06:51:18PM +0000, David Laight wrote:
> > > From: Arvind Sankar
> > > > Sent: 25 October 2020 14:31
> > > >
> > > > Unrolling the LOAD and BLEND loops improves performance by ~8% on x86_64
> > > > (tested on Broadwell Xeon) while not increasing code size too much.
> > >
> > > I can't believe unrolling the BLEND loop makes any difference.
> > 
> > It's actually the BLEND loop that accounts for almost all of the
> > difference. The LOAD loop doesn't matter much in general: even replacing
> > it with a plain memcpy() only increases performance by 3-4%. But
> > unrolling it is low cost in code size terms, and clang actually does it
> > without being asked.
> 
> (memcpy is wrong - misses the byte swaps).

I know it's wrong, the point is that it's impossible to gain very much
from optimizing the LOAD loop because it doesn't account for much of the
total time.

> 
> That's odd, the BLEND loop is about 20 instructions.
> I wouldn't expect unrolling to help - unless you manage
> to use 16 registers for the active W[] values.
> 

I am not sure about what's going on inside the hardware, but even with
a straightforward assembly version that just reads out of memory the way
the calculation is specified, unrolling the BLEND loop 8x speeds up the
performance by 7-8%.

The compiler is actually pretty bad here, just translating everything
into assembler with no attempt to optimize anything gets a 10-12%
speedup over the C version.
