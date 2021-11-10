Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15588C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 17:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E828B61247
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 17:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhKJRc4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 12:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhKJRc4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 12:32:56 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F05C061766
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 09:30:08 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id f3so7686431lfu.12
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 09:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k62P9OFKi7tZqOtk4kBzcgOA3yFmavp9RFu5P0iMC0g=;
        b=ljxJneVdEcWQ3qyU1mPxpDQlUwwN8+KNbwvfNpwpuRkApjgLJxOKjjW48ozjxduyk2
         0dDyEfPebZH4w1FESanp5t9gnvTDOczY8fqIlI5+nl/rxqWSZcF4Na+asDo6Qet0sFZ6
         1oWiDAMSMEefSXvc1kOaOojDK13HmRJ33IgYQUvnlFbKjZ4/1VJlM9cZ2T8fvaRjMp7J
         PW+ccuSHzksl0bB/SF5CD1zX5V8xo6camlxe6oUpF70m/inV3eZPZ0FhKtMTHaEvZCq5
         bNNwUMxUPC44MCWw3SiWm5WIV8ioSFUhcZ/3CmEbxdCUiHgdVtSTOHaY1XcVXil0yUYh
         EdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k62P9OFKi7tZqOtk4kBzcgOA3yFmavp9RFu5P0iMC0g=;
        b=MNO0EwJ0qiz9Q/GD1iTdYP3Ev6IvEYsRdX/+h/HkfPCa5AlwoEQCl4kqfh1TkkfgL4
         n2gtr081ZZUKuU69mzJpW1WIiOKXHVL5BznsGfYr/fVTdIYIXWQc+97+M8um+ZGkPceX
         UYhZK6RbkuQ8+OM/sHdRmpNkuIJJpnYLjvVlgRJYB5SX4MDoOBdWnkK21N7bWSpuMS0l
         ZYev8+k05WrLPmW3SgckvzOOWUCshXZgEOYCChFDYdKL01OckKdclns+rGQjqdVxJXJc
         usUK40ftI0vtDP6vx5GYYqhVL2zmHgMOMX/VEvrggR8ayS8N9v0BPkD75JAbK0RliRGM
         70xg==
X-Gm-Message-State: AOAM530F9cni0awT5N30Zcyukj/aaWE1s9BWT+dxKZZViTKBpfe3b2Uc
        8fUnMWq291v4TtdU/IMYCNV9KraiVGMkelsFE2WsRQ==
X-Google-Smtp-Source: ABdhPJw2bxIy8Du772N/Ij9qar0UNe2w1m5oda+QNyfinfOMVNeyPkdm0Q5Sgwf4E99E7hLDHhk9QDbDtomvdcxfc+E=
X-Received: by 2002:a05:6512:3e12:: with SMTP id i18mr718737lfv.456.1636565406166;
 Wed, 10 Nov 2021 09:30:06 -0800 (PST)
MIME-Version: 1.0
References: <20211102142331.3753798-1-pgonda@google.com> <20211102142331.3753798-2-pgonda@google.com>
 <YYqhT+Enba5xa4cO@google.com> <CAMkAt6oVySH-1g+EXKvxQ9vmBV8rwTLq=qfe2+VZC+c6vATL7w@mail.gmail.com>
 <45af7051-aab0-2b19-2904-64eceec93df5@amd.com>
In-Reply-To: <45af7051-aab0-2b19-2904-64eceec93df5@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 10 Nov 2021 10:29:54 -0700
Message-ID: <CAMkAt6pivYG=nV_EhP9Uj2gB8kBQB4dAnTcSeGd9249KuWzsyg@mail.gmail.com>
Subject: Re: [PATCH V3 1/4] crypto: ccp - Fix SEV_INIT error logging on init
To:     Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 9, 2021 at 12:25 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 11/9/21 10:46 AM, Peter Gonda wrote:
> > On Tue, Nov 9, 2021 at 9:27 AM Sean Christopherson <seanjc@google.com> wrote:
> >> On Tue, Nov 02, 2021, Peter Gonda wrote:
>
> ...
>
> >>
> >>          SEV: failed to INIT error 0, rc -16
> >>
> >> which a bit head scratching without looking at the code.  AFAICT, the PSP return
> >> codes aren't intrinsically hex, so printing error as a signed demical and thus
> >>
> >>          SEV: failed to INIT error -1, rc -16
> >>
> >> would be less confusing.
> >>
> >> And IMO requiring the caller to initialize error is will be neverending game of
> >> whack-a-mole.  E.g. sev_ioctl() fails to set "error" in the userspace structure,
> >> and literally every function exposed via include/linux/psp-sev.h has this same
> >> issue.  Case in point, the retry path fails to re-initialize "error" and will
> >> display stale information if the second sev_platform_init() fails without reaching
> >> the PSP.
> >
> > OK I can update __sev_platform_init_locked() to set error to -1. That
> > seems pretty reasonable. Tom, is that OK with you?
>
> Yup, I'm ok with using -1.
>
> >
>
> ...
>
> >
> > These comments seem fine to me. But I'll refrain from updating
> > anything here since this seems out-of-scope of this series. Happy to
> > discuss further and work on that if Tom is interested in those
> > refactors too.
>
> That's one of those things we've wanted to get around to improving but
> just haven't had the time. So, yes, if you wish to refactor the 'error'
> related area, that would be great.

OK so when I actually sat down to work on this. I realized this is
bigger than I thought. If we want to have error == -1 for all return
from psp-sev.h functions where the PSP isn't called yet there are a
lot of changes. For example if CONFIG_CRYPTO_DEV_SP_PSP is not defined
all these stubs need to be to set `*errror == -`, basically all these
functions need to be updated.

So to keep this series more targeted. I think I'll drop the error
here. And just have this patch print the rc value. If what I said
above seems reasonable I'll do those error refactors. Are people
envisioning something else for the error fixups?

>
> Thanks,
> Tom
>
> >
