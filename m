Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DC9C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Feb 2022 10:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiBLKId (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Feb 2022 05:08:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiBLKIc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Feb 2022 05:08:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8825326110
        for <linux-crypto@vger.kernel.org>; Sat, 12 Feb 2022 02:08:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B497B80011
        for <linux-crypto@vger.kernel.org>; Sat, 12 Feb 2022 10:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E935FC340E7
        for <linux-crypto@vger.kernel.org>; Sat, 12 Feb 2022 10:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644660506;
        bh=uwvHwvTce5f8VcNRgtGyM1W8Vj+7as84ydlj6IEdMl0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oqgq/yLjHleytQn0/V0dZY+n4hjrm57I1h5BBgQQD+aOB/o6bav41hItoAAE+FERM
         LokVy4VVmPx9JLCkKXDdyaJRBe8+rjQONu05Ho5q/8UHeslPW7UpvyNjJnKcJf1L7c
         pSeA4uIh1QD3DXkiH5mIzZv68ooJHVnbVMWtX49QB35GDLjYAR9s/LmGwXvWkqjjon
         NJMkJdFVCFnUjwFGEf7CyL1uZNFKY1M09yLAMEv9Zul0dOaaOr4aEcpHjv7ZYASuWJ
         3BpArrU4LlS+XOqBtBv7DBSzrP8N/AfpwxOPNKBVn/jjduKlyEnYRUdXbXmAdsAF3m
         CedzW7kZLefxw==
Received: by mail-wr1-f44.google.com with SMTP id s10so5472705wrb.1
        for <linux-crypto@vger.kernel.org>; Sat, 12 Feb 2022 02:08:26 -0800 (PST)
X-Gm-Message-State: AOAM530EFYqprRPduNO4Bxehny7eZSFqZ4rtTVn+xltW/IPVMmr4smsh
        SFIeFNbFivj69nBIlmvvA9Mp5NLA5OEUf9dEYr8=
X-Google-Smtp-Source: ABdhPJy2+OZC0dyTdP42zPfwkEYRBuIJFzF90SoJPF1ZYsqaQIQI4+frOMGHcHSpWdkAMAhRcGTc3fdgeHm8243G2lo=
X-Received: by 2002:a05:6000:1b88:: with SMTP id r8mr4540819wru.447.1644660505301;
 Sat, 12 Feb 2022 02:08:25 -0800 (PST)
MIME-Version: 1.0
References: <20220210232812.798387-1-nhuck@google.com> <20220210232812.798387-6-nhuck@google.com>
 <CAMj1kXEJRBcLBsO6HVQJNmGkxmY+aXY+BnyApn6s_MCtXo0eng@mail.gmail.com> <CAJkfWY7bet2V-w7NwMxqAsiwUqF5q7-FmFsgKJaMOBYSuY9M2g@mail.gmail.com>
In-Reply-To: <CAJkfWY7bet2V-w7NwMxqAsiwUqF5q7-FmFsgKJaMOBYSuY9M2g@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 12 Feb 2022 11:08:14 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHtkxNkdpX46EmT94+ZkFyEkgXzZHOhpzb+DUu15r=7gQ@mail.gmail.com>
Message-ID: <CAMj1kXHtkxNkdpX46EmT94+ZkFyEkgXzZHOhpzb+DUu15r=7gQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/7] crypto: arm64/aes-xctr: Add accelerated
 implementation of XCTR
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 11 Feb 2022 at 21:30, Nathan Huckleberry <nhuck@google.com> wrote:
>
> On Fri, Feb 11, 2022 at 5:48 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Fri, 11 Feb 2022 at 00:28, Nathan Huckleberry <nhuck@google.com> wrote:
> > >
> > > Add hardware accelerated version of XCTR for ARM64 CPUs with ARMv8
> > > Crypto Extension support.  This XCTR implementation is based on the CTR
> > > implementation in aes-modes.S.
> > >
> > > More information on XCTR can be found in
> > > the HCTR2 paper: Length-preserving encryption with HCTR2:
> > > https://eprint.iacr.org/2021/1441.pdf
> > >
> > > Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> > > ---
> > >
> > > Changes since v1:
> > >  * Added STRIDE back to aes-glue.c
> > >
> >
> > NAK. Feel free to respond to my comments/questions against v1 if you
> > want to discuss this.
>
>  Oops, I misunderstood the tail block behavior of the CTR implementation and
>  thought it wouldn't work with XCTR mode.  I have XCTR mirroring the tail
>  behavior of CTR now. I'll submit it with the v3.

Yes, here's my version for reference:
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=hctr2&id=5bb01649223080b7cde5740f441eb5e758ec357f
