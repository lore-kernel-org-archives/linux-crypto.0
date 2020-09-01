Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC9AC433E6
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 19:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A59E9208CA
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 19:12:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nOKfv7dX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730686AbgIATM2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 15:12:28 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:38505 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbgIATM1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 15:12:27 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id a87c4a03
        for <linux-crypto@vger.kernel.org>;
        Tue, 1 Sep 2020 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Re5z3+odbFyFVMOhKl86dMAnmiE=; b=nOKfv7
        dXgamd1Gn6PcAeNmeADuNqr4ZnyvJdPvzEwPTHPhqhYjAKBGxbV212JhktiCA4hu
        PPZvweECcGN/VDKiPoIrrfCii82keMfQL9MjXTFIqnaFkR4fqUcvPnwGpQHRrZzk
        O4v0BCcmmNemJTJCRuu+pgFZj8xFXpbTxG2PTKFEIvDa51uwyYJZEP464hBQJCcA
        jwVQWazlSaTwGXeckTbIAuxWzHCqXsPDp4WDDEV1r35Swols5/7xzI8Qpqjg5+yi
        vIAx3uqStFqB36URKqlYqSKETMsBcT7rcLreXFSGFg5PLGVXKwEYe2yGoMpTc3G6
        A7LJjjzWaxN93rIg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 294ce59e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Tue, 1 Sep 2020 18:44:23 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id h11so2337899ilj.11
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2020 12:12:24 -0700 (PDT)
X-Gm-Message-State: AOAM531zBLOIrhODQ6iycxOJh6GXIvWR77L7cmX+JJ/6lQZGQ9iFnz39
        oDZqWsPNUYgb4dR6ftkZlCwP5JeSTspi0H0Xge4=
X-Google-Smtp-Source: ABdhPJw2fH45cv457aIJn43O1cFqzdDuZIiV8BIftyhFSKd8QDGviaNWT3TRvX1nQ2BGbLE5TokQA1lUayljx+UvIpc=
X-Received: by 2002:a92:c9c5:: with SMTP id k5mr470934ilq.231.1598987543708;
 Tue, 01 Sep 2020 12:12:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200827173058.94519-1-ubizjak@gmail.com> <CAMj1kXHChRSxAgMNPpHoT-Z2CFoVQOgtmpK6tCboe1G06xuF_w@mail.gmail.com>
 <CAHmME9p3f2ofwQtc2OZ-uuM_JggJtf93nXWVkuUdqYqxB6baYg@mail.gmail.com>
In-Reply-To: <CAHmME9p3f2ofwQtc2OZ-uuM_JggJtf93nXWVkuUdqYqxB6baYg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 1 Sep 2020 21:12:12 +0200
X-Gmail-Original-Message-ID: <CAHmME9oemtY5PG9WjbOOtd_xxbMRPb1t5mPoo2rR-y3umYKd5Q@mail.gmail.com>
Message-ID: <CAHmME9oemtY5PG9WjbOOtd_xxbMRPb1t5mPoo2rR-y3umYKd5Q@mail.gmail.com>
Subject: Re: [PATCH] crypto/x86: Use XORL r32,32 in curve25519-x86_64.c
To:     Uros Bizjak <ubizjak@gmail.com>,
        Karthik Bhargavan <karthikeyan.bhargavan@inria.fr>,
        Chris.Hawblitzel@microsoft.com,
        Jonathan Protzenko <protz@microsoft.com>,
        Aymeric Fromherz <fromherz@cmu.edu>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 1, 2020 at 8:13 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> operands are the same. Also, have you seen any measurable differences
> when benching this? I can stick it into kbench9000 to see if you
> haven't looked yet.

On a Skylake server (Xeon Gold 5120), I'm unable to see any measurable
difference with this, at all, no matter how much I median or mean or
reduce noise by disabling interrupts.

One thing that sticks out is that all the replacements of r8-r15 by
their %r8d-r15d counterparts still have the REX prefix, as is
necessary to access those registers. The only ones worth changing,
then, are the legacy registers, and on a whole, this amounts to only
48 bytes of difference.
