Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9848C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 16:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75853218A2
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 16:21:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yXeM6mBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbfCVQVW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 12:21:22 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37104 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfCVQVW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 12:21:22 -0400
Received: by mail-io1-f65.google.com with SMTP id x7so2180901ioh.4
        for <linux-crypto@vger.kernel.org>; Fri, 22 Mar 2019 09:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FinR+IjhZDJgPonC4fG9bQ8oToE745baJij2yjHIuSw=;
        b=yXeM6mBWjCkKz0G3Jx7TkTFp6qEugUDgoTTzWcZqjmmQo1guYtvaNro3m8PQ5yIyV6
         j8GRm3pcaDDCTlo+j1rMgWFzm7D36KGzN+8UkRhvRHwnDyVgSCgO+ar33pCFtlWg9FZz
         N+uL2cVTBLgpFhI43ozMWZX+wA9xS1NzY/7kWC3HaBc2UDCIoPQZKq8uwTcipJ7+yqEh
         08mTJ8v5+2uSRzDgF3p2P0rydcmFtRuW5khFfHuhScc1QMKEas+NcBaxzAlhnrryGt/3
         eaQjuJR+qHOXDq5jZUc0pNfTukYC9YumD4eAkENBwNJayqZT8ynPYWUF4RcqVroniE+U
         JkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FinR+IjhZDJgPonC4fG9bQ8oToE745baJij2yjHIuSw=;
        b=QJvPVJC38e5ReAbQA7ARhYD+zIIQXhwc/yfJojHkuacKqt8CN/dBns0dcjl9xaP4oT
         WkqX/Fw7u6iqU7/9r9K0DzE00glh3QYhwEqJWPTEV/9pA1Wqa3kGhZK6pML+hJHXD2qr
         XykLyka2jlYr/DkwFpisauxjxZcG6hbDHMeVW/UyDdSmZbifcKQ2XHo6k0qjn1QZJhG+
         OPhcqE8Mog1JZYCRoiyBb1ggGrLwXlN6bPq9n9q89r5JrtR4lWpTmbdeDzhebdCDoG6S
         4hVnm637qO6064Yg5zrYb7ry2fSMbcj9L1ZCYfUqTqwLrtF2Xi5Y+4Hn/Znkl5g1FZSy
         J/Mg==
X-Gm-Message-State: APjAAAXOk3K+DXmtTEEKphq/h3YCKHNw2W8Y41WwTOF82UedF92taHFd
        T/Sqd+WLhX7Ho/qWVdVr/Nh9hzzJvSpUrgOSqK9XAaeesNkAEw==
X-Google-Smtp-Source: APXvYqyYvUNkkH7/kVxFEBmTPdnSzEM26yKlFgHZNF9RUgA357LvIA2jIyluI9ZY/Z8xlnqX1yMfavwoKVA7Vxf1Fk0=
X-Received: by 2002:a5d:8b41:: with SMTP id c1mr7546985iot.173.1553271681269;
 Fri, 22 Mar 2019 09:21:21 -0700 (PDT)
MIME-Version: 1.0
References: <5ef0cab4dee128058a43f43c723c13924662e80d.camel@perches.com>
 <20190322124331.s5iu4ontsakv7he5@gondor.apana.org.au> <CAKv+Gu_SBkhV8SVXpOBDoPRBJYhFdmF3jJdZ5OPm3SrPBTSarQ@mail.gmail.com>
 <f8cb10b3dcce0703a652f2f544161abd41bc67f3.camel@perches.com>
In-Reply-To: <f8cb10b3dcce0703a652f2f544161abd41bc67f3.camel@perches.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 22 Mar 2019 17:21:10 +0100
Message-ID: <CAKv+Gu8nds6WgE5UWj8iy=fr7AOmCsaQsrE4Dcj0oiNOXkkt6g@mail.gmail.com>
Subject: Re: [possible PATCH] crypto: sahara - Use #ifdef DEBUG not IS_ENABLED(DEBUG)
To:     Joe Perches <joe@perches.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 22 Mar 2019 at 16:07, Joe Perches <joe@perches.com> wrote:
>
> On Fri, 2019-03-22 at 15:29 +0100, Ard Biesheuvel wrote:
> > On Fri, 22 Mar 2019 at 13:43, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > On Thu, Mar 07, 2019 at 04:15:55PM -0800, Joe Perches wrote:
> > > > Normal use of IS_ENABLED is with a CONFIG_<SYMBOL> and
> > > > there is no -DDEBUG in the Makefile here.
> > > >
> > > > Replace the IS_ENABLED(DEBUG) with #ifdef DEBUG/#endif
> > > > blocks.
> > > >
> > > > Miscellanea:
> > > >
> > > > o Move the sahara_state array into the function that uses it.
> > > >
> > > > Signed-off-by: Joe Perches <joe@perches.com>
> > > > ---
> > > >  drivers/crypto/sahara.c | 20 +++++++++-----------
> > > >  1 file changed, 9 insertions(+), 11 deletions(-)
> > >
> > > Even if this is correct this is way too ugly.  The original code
> > > at least compiled everything regardless of macros.  Your new code
> > > won't detect compile errors in debugging code unless debugging is
> > > enabled.
> > >
> >
> > What's wrong with IS_ENABLED(DEBUG) anyway? It may not be 'normal use'
> > but it works fine.
>
> drivers/crypto/sahara.c is the only user in the kernel tree.
> So only it's abnormal use.  I rather like the concept actually.
>
> IS_ENABLED is almost exclusively used with CONFIG_<FOO> symbols
> and it could be useful to require it to be used with CONFIG_<FOO>
> symbols and use some other similar mechanism for DEBUG use.
>
> Maybe just adding a global #define in kernel.h like
>
> #define IS_DEBUG_ENABLED        IS_ENABLED(DEBUG)
>

__is_defined(DEBUG) seems to be the most appropriate here. I don't
feel strongly about whether we or not should wrap it in another macro.



> to isolate this in one place might be better.
>
> A good thing about using IS_ENABLED or the suggested IS_DEBUG_ENABLED
> would be that least gcc 5+ seems to automatically elide the uses of any
> unreferenced static const char * arrays like the sahara_state uses here.
>

Yes, that is kind of the point. If you use #ifdef, the compiler will
complain about unused static variables in this case.

> (I don't have gcc4 anymore so I couldn't check that version)
>
> So using 'if (IS_DEBUG_ENABLED)' could simplify some existing code like
> the many uses of
>
> #ifdef DEBUG
>         ...
> #endif
>
> or equivalent
>
>

My vote would be to use __is_defined(DEBUG) in place, but if others
prefer wrapping it in a macro, that is also fine with me.
