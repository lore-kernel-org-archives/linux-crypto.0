Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA1DC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 06:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4601B6321B
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 06:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhKQGFJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233538AbhKQGEz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Nov 2021 01:04:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5709A613A3;
        Wed, 17 Nov 2021 06:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637128917;
        bh=gfX116bxT6Kmb5OIElWbXiP6Js2wUjVHW/NaDgV7ROo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c3PR1BTSPOR5c8cxKgOsV1Mzxw5nXrdOVSzYdUmpdTvNFV/ksYmWD/TA/kBVzhG7u
         eD4xa/KWzYDc/SMhIHOCZACMjD8J9lHwczlEEZjyLkEn19v0cAHu1p5IdXpZxqmMVl
         0aH696CfBclS8HgkuKyNmoLU/x/hmclAr2j7Cbao=
Date:   Wed, 17 Nov 2021 07:01:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/8] Replace memset() with memzero_explicit()
Message-ID: <YZSaybga3KV/fimg@kroah.com>
References: <CACXcFm=kwziZ5Etdevu0uq_t5qy0NbGY753WfLvnwkMqtU9Tvg@mail.gmail.com>
 <YZObImtJITs1ZfUc@kroah.com>
 <CACXcFm=bPdoLqYHEUpeZEQEULVGW6ej4ESHX+vMdeGfvjc51tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFm=bPdoLqYHEUpeZEQEULVGW6ej4ESHX+vMdeGfvjc51tg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 17, 2021 at 11:08:45AM +0800, Sandy Harris wrote:
> On Tue, Nov 16, 2021 at 7:51 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> 
> > Have you looked at the output of the compiler to see if this really is
> > needed or not?
> 
> No. To do that right you'd need to look at (at least) gcc & clang,
> multiple architectures (cross-compiled & native) & various levels
> of optimisation. I just looked at the C code.

You should at least look, right?

> > And what exactly are you zeroing out that could be read afterward
> > somehow?
> 
> Whatever it is, the person who wrote the code thought it was
> worth zeroing out with memset(). The only question is whether
> it is safer to use memzero_explicit().
> 
> Granted in many cases this will not matter unless the kernel
> is compiled at some optimisation level that does cross-function
> analysis so it might be "smart" enough to optimise out the
> memset(). Also granted it does not matter unless an attacker
> can look inside the running kernel & if  he or she has that
> level of privilege, then you have much else to worry about.

As Ard said, there should not be any such "optimization" as this is not
something that any non-broken compiler should do.

> Still, it seemed safer to me to use memzero_explicit() in
> these cases.

I do not see why these cases are any different than any other call to
memset() is, because this data is not on the stack so nothing should be
removed by the compiler, right?

thanks,

greg k-h
