Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01583C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 16:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B421121973
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600101034;
	bh=pTHUzLOL7yQ7KHlU8FqTM4q2ulJSImgxhsRDEBT9D90=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=maBts9B7JreHFg3mNW+ZI+RZOgbHqr6Qc0o4qS35ahjUAtY+vOmAZYyjyYkMmNBZR
	 VPPJ9QaWKMf5+kJbVuhQ3q1GiAUPIVV1BqZ3IgwUzcDTvrTDjoPLLweI3e2ihWfm2n
	 xQwTlj7Ad9OxQn8Lx7DZ4JorqGIq2nvKuVxIkDMg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgINQaX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 12:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgINQ2m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 12:28:42 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 629272193E;
        Mon, 14 Sep 2020 16:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600100921;
        bh=pTHUzLOL7yQ7KHlU8FqTM4q2ulJSImgxhsRDEBT9D90=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=f1t3LpmAmG8KQ8INfWDUlJFKMspPvrkvB1M/OkMqaKVY4vrQmok6pRJ4mcKtAT5/g
         EL6uhQHkGeY1AqSRqAqNU8PRWBM/El557sajYAPtZc+W9AtpmB8skCoC3y0deKABbe
         N9k7gj4aAYKr0WB8B29ZpGDfXbP0/OBThVnMZDFg=
Received: by mail-oi1-f171.google.com with SMTP id i17so465270oig.10;
        Mon, 14 Sep 2020 09:28:41 -0700 (PDT)
X-Gm-Message-State: AOAM533NWLdeiRRl2N/AhoEmQBOfE1kNN2Hxx6WonbLJN7LW0kyc85rJ
        qh6yl0s4e+jPYRtFwzmqOTI8ZUVx7pS+rFEWVKg=
X-Google-Smtp-Source: ABdhPJz2QJsVSEa5+w0C22n+i5dshGbeO3RZt/ANYubXMffn3SaQ7xSBbkBid2vHXu1jwZ27PZfLMyxFiGm0m5vbmwE=
X-Received: by 2002:a05:6808:8e5:: with SMTP id d5mr128143oic.33.1600100920731;
 Mon, 14 Sep 2020 09:28:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com> <20200821034651.GA25442@gondor.apana.org.au>
 <c360d691-8253-bd99-af92-83d9f8e86a2d@nxp.com> <20200908221019.GA23497@gondor.apana.org.au>
 <67159207-1082-48be-d085-971a84b525e0@nxp.com>
In-Reply-To: <67159207-1082-48be-d085-971a84b525e0@nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 14 Sep 2020 19:28:29 +0300
X-Gmail-Original-Message-ID: <CAMj1kXGg7bSh57kwE57mKRocNRPZCeXifwjF53-3Jb6LYsfZTg@mail.gmail.com>
Message-ID: <CAMj1kXGg7bSh57kwE57mKRocNRPZCeXifwjF53-3Jb6LYsfZTg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/9] crypto: caam/jr - add fallback for XTS with
 more than 8B IV
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 14 Sep 2020 at 19:24, Horia Geant=C4=83 <horia.geanta@nxp.com> wrot=
e:
>
> On 9/9/2020 1:10 AM, Herbert Xu wrote:
> > On Tue, Sep 08, 2020 at 01:35:04PM +0300, Horia Geant=C4=83 wrote:
> >>
> >>> Just go with the get_unaligned unconditionally.
> >>
> >> Won't this lead to sub-optimal code for ARMv7
> >> in case the IV is aligned?
> >
> > If this should be optimised in ARMv7 then that should be done
> > in get_unaligned itself and not open-coded.
> >
> I am not sure what's wrong with avoiding using the unaligned accessors
> in case data is aligned.
>
> Documentation/core-api/unaligned-memory-access.rst clearly states:
> These macros work for memory accesses of any length (not just 32 bits as
> in the examples above). Be aware that when compared to standard access of
> aligned memory, using these macros to access unaligned memory can be cost=
ly in
> terms of performance.
>
> So IMO it makes sense to use get_unaligned() only when needed.
> There are several cases of users doing this, e.g. siphash.
>

For ARMv7 code, using the unaligned accessors unconditionally is fine,
and it will not affect performance.

In general, when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is defined,
you can use the unaligned accessors. If it is not, it helps to have
different code paths.

This is a bit murky, and through the years, the interpretation of
unaligned-memory-access.rst has shifted a bit, but in this case, it
makes no sense to make the distinction.
