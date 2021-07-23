Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71ECC4320A
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 19:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B896060F47
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 19:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhGWSvJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jul 2021 14:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbhGWSvJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jul 2021 14:51:09 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C900C061757
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jul 2021 12:31:41 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id f11so3873841ioj.3
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jul 2021 12:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O4duAkdP8nGjwQz3gP8+9f75sObkeoEVncrqoagaAf8=;
        b=Qt8EzUllMk+BQxwjEg3h2dLhND6WXelcF1KCJ/OESaIZQAXOBaluspkozlZW4JU2R+
         Znk6RH2WGkvMVtpnF6jQsDJNRstUK2sj7oCQyqLlSAZGRo+RcEouepg9OhlYyiS/p4yQ
         s9ltX/w4poTJ8k5MZwNSxVDzds6mULz9zIVop40Cl/D4JyEaTpsTD49WyrV2fPgZYlhG
         XcFHEPNTXItFCgL5d2CgCSWzRH/nvr1uyeVYf5CLU3ivAePMLLTfgV+8gexujzqlY15+
         aQvrAO63kiibVX+tnhTalXzk/+TvDNI9CpZMk4mheAcD9/zMdCubD3WiP9JyDYFvu1mI
         jzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O4duAkdP8nGjwQz3gP8+9f75sObkeoEVncrqoagaAf8=;
        b=f6paUUjgf9NGQKFnYM3JsYlk1yARXtE9D7QsyUwuBU9LpwgnxAFh3opL9Wz7EmWjbd
         r7+FinHerC2gsm04QOcJIap/r25d5kj03dVhbozc9rH5RBwfHNFMhhtywFD/k4a3qELV
         mlbt6AIvhxJXFfx2aHRBGMDlqz0hldVW6wbQjQIRM0+C393NIwMhOQgGsyF9V8DdDLDy
         QFt7N4xNPEJ8wUfO4lxU921HXdyqpf5QIRrTQhL4WtjL4xhf6U3MLYlHKde2xDll5dZR
         7nusr3G67gUmw1PeFUQA35JxVHJG7X0SD0bTzDQZGOk1+wKQCho/vClTCG8Fn7SqlpL6
         ri5w==
X-Gm-Message-State: AOAM532ubz/ElTqMQqK9MGQbPq/LLBmuQxm0OY27jIhxT7PA/W/Gf4Fj
        MMqJbohEqSImRY5jJcxtutsy2P0VydXQ2FXxWyv1aQ==
X-Google-Smtp-Source: ABdhPJzQnB2OGYyKJRiAlpkY+h5/eC/6eYxynuNX9zjXWewneFpScPqGwjaHuFnLWDGRX/KG8nxcoAVFaz+fzETIVUI=
X-Received: by 2002:a5d:9599:: with SMTP id a25mr5155045ioo.86.1627068700385;
 Fri, 23 Jul 2021 12:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210715213138.1363079-1-dlatypov@google.com> <20210715213138.1363079-2-dlatypov@google.com>
 <20210723064328.GA7986@gondor.apana.org.au>
In-Reply-To: <20210723064328.GA7986@gondor.apana.org.au>
From:   Daniel Latypov <dlatypov@google.com>
Date:   Fri, 23 Jul 2021 12:31:28 -0700
Message-ID: <CAGS_qxqOD+Bcvy7xti7_eg8+H1cJcfp94BtnRhuzijDcaGF_uA@mail.gmail.com>
Subject: Re: [RFC v1 1/2] crypto: tcrypt: minimal conversion to run under KUnit
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        brendanhiggins@google.com, davidgow@google.com,
        linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 22, 2021 at 11:43 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jul 15, 2021 at 02:31:37PM -0700, Daniel Latypov wrote:
> >> == Questions ==
> > * does this seem like it would make running the test easier?
>
> I don't mind.  tcrypt these days isn't used so much for correctness
> testing.  It's mostly being used for speed testing.  A secondary
> use is to instantiate templates.

Thanks, that makes a lot of sense.
In that case, how useful would `kunit.py run` be? I.e. Do people
mostly want to see numbers on bare metal?

The default mode of `kunit.py run` is to use ARCH=um.
I assume (for at least most of the library-type crypto code) it should
have the same performance characteristics, but that might not be the
case. I can try and get some numbers on that.

There's an option to make `kunit.py run` use ARCH=86_64, but it'll be
in a QEMU VM, so again there's some performance overhead.

If either option seems useful, then perhaps a minimal patch like this
would be beneficial.
I can make it even smaller and less intrusive by restoring the "ret +=
..." code and having a single `KUNIT_EXPECT_EQ_MSG(test, ret, 0, "at
least one test case failed")` at the very end.

It does not sound like patch #2 or any future attempts to try and make
use of KUnit features is necessarily worth it, if correctness testing
isn't really the goal of tcrypt.c anymore.

>
> > * does `tvmem` actually need page-aligned buffers?
>
> I think it may be needed for those split-SG test cases where
> we deliberately create a buffer that straddles a page boundary.
>
> > * I have no clue how FIPS intersects with all of this.
>
> It doesn't really matter because in FIPS mode when a correctness
> test fails the kernel panics.
>
> >   * would it be fine to leave the test code built-in for FIPS instead of
> >   returning -EAGAIN?
>
> The returning -EAGAIN is irrelevant in FIPS mode.  It's more of
> an aid in normal mode when you use tcrypt for speed testing.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
