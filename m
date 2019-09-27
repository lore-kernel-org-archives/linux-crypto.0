Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBBAC4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 02:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C32D208C3
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 02:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569552867;
	bh=Hfp8rbEBbqxlz+EO60K9a66tue06IjXtDmKDZirsvfg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=WKngPzc1euyTP24CDkdInxJ936JfftHpzSE7vhQtdamwtBDxIflyxNZyP8hOx3EoI
	 hsq5/FEIaK65RsP2vounp0tWrzHj48RNHUDXKuFWeCWhMzki3h4gh976JO1VDb3OQW
	 D9otMN9AwuFP7jmvniNxQkKaaZrNmdLnv5mNiHwU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfI0CyZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 22:54:25 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44092 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727631AbfI0CyZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 22:54:25 -0400
Received: by mail-lj1-f195.google.com with SMTP id m13so923785ljj.11
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 19:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=izprtTacDNeg/U0ozkxIJBmawaAbDPW9muDV/dWzvVY=;
        b=abf33mtRxt+TnpRpol1admztTaB2ANRYfIf06LL3Lr5koIfkLhJoEtK3jZumD3RuBH
         +P5INGOa46VPzThQlBpDZ+cAIYDeY46piId4HdvRTTg8h+eXIwNd0L7mRaO4GW+QPPeg
         PGX9Jug0rJHzno8LLPHlzUdGMzpETpO937XFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=izprtTacDNeg/U0ozkxIJBmawaAbDPW9muDV/dWzvVY=;
        b=c4YsrgOC8H1COcz9j8huk9ct3vteKP1yuaos213a5YaffC5+xqey5N+5Qb4nolOSxr
         p1i89TLqqDTe/C/Tas0EPUVeUUBUqnBFJtSr918MevgQvWEc1PnNctpGSm0/B2E6/s15
         aZ44baFcVJFRjKA9Q72MwVNQICYgMGAcvJWqDsGbeHKzFinkB3BzBQrgoy486Jxix673
         QpMhg9taVAqAy9eFJPXyytrNnUzBEK+jQP68vGcTFIFt1ZBtlbWU4JHWXhbFEmDRxZL2
         FvkDEZiYTSGbViupobUV4mH9vseMWMw7c0vNuwfO8j+y1QpRO0dSZk2+Nwfa9+Gno/zd
         5Bdw==
X-Gm-Message-State: APjAAAWGt4kwtlWmdxaVR5R4tGTTr34m2zw4xPuAEbWj0KSDi6SSkZK1
        XUgNglW/awMw3JEaYqCC8vYUGTfiCew=
X-Google-Smtp-Source: APXvYqyTknH6PxRVrRmvGYpHyIytPY2wf1kwA+yYsOFGPuofMVYeRdpDuSHruqGL5AY58i6wRIxiaw==
X-Received: by 2002:a2e:9708:: with SMTP id r8mr1120882lji.58.1569552861219;
        Thu, 26 Sep 2019 19:54:21 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id r19sm195001ljd.95.2019.09.26.19.54.20
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 19:54:20 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id m13so923736ljj.11
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 19:54:20 -0700 (PDT)
X-Received: by 2002:a2e:2c02:: with SMTP id s2mr1146724ljs.156.1569552859807;
 Thu, 26 Sep 2019 19:54:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
In-Reply-To: <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 26 Sep 2019 19:54:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=whqWh8ebZ7ryEv5tKKtO5VpOj2rWVy7wV+aHWGO7m9gAw@mail.gmail.com>
Message-ID: <CAHk-=whqWh8ebZ7ryEv5tKKtO5VpOj2rWVy7wV+aHWGO7m9gAw@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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

On Thu, Sep 26, 2019 at 6:30 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And once you have that cookie, and you see "ok, I didn't get the
> answer immediately" only THEN do you start filling in things like
> callback stuff, or maybe you set up a wait-queue and start waiting for
> it, or whatever".

Side note: almost nobody does this.

Almost every single async interface I've ever seen ends up being "only
designed for async".

And I think the reason is that everybody first does the simply
synchronous interfaces, and people start using those, and a lot of
people are perfectly happy with them. They are simple, and they work
fine for the huge majority of users.

And then somebody comes along and says "no, _we_ need to do this
asynchronously", and by definition that person does *not* care for the
synchronous case, since that interface already existed and was simpler
and already was mostly sufficient for the people who used it, and so
the async interface ends up being _only_ designed for the new async
workflow. Because that whole new world was written with just that case
is mind, and the synchronous case clearly didn't matter.

So then you end up with that kind of dichotomous situation, where you
have a strict black-and-white either-synchronous-or-async model.

And then some people - quite reasonably - just want the simplicity of
the synchronous code and it performs better for them because the
interfaces are simpler and better suited to their lack of extra work.

And other people feel they need the async code, because they can take
advantage of it.

And never the twain shall meet, because the async interface is
actively _bad_ for the people who have sync workloads and the sync
interface doesn't work for the async people.

Non-crypto example: [p]read() vs aio_read(). They do the same thing
(on a high level) apart from that sync/async issue. And there's no way
to get the best of both worlds.

Doing aio_read() on something that is already cached is actively much
worse than just doing a synchronous read() of cached data.

But aio_read() _can_ be much better if you know your workload doesn't
cache well and read() blocks too much for you.

There's no "read_potentially_async()" interface that just does the
synchronous read for any cached portion of the data, and then delays
just the IO parts and returns a "here, I gave you X bytes right now,
use this cookie to wait for the rest".

Maybe nobody would use it. But it really should be possibly to have
interfaces where a good synchronous implementation is _possible_
without the extra overhead, while also allowing async implementations.

                Linus
