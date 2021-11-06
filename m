Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36713C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Nov 2021 03:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B9C760FC1
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Nov 2021 03:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbhKFDuI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Nov 2021 23:50:08 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56588 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhKFDuI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Nov 2021 23:50:08 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mjCfu-00064V-F8; Sat, 06 Nov 2021 11:47:26 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mjCft-0004rm-8J; Sat, 06 Nov 2021 11:47:25 +0800
Date:   Sat, 6 Nov 2021 11:47:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20211106034725.GA18680@gondor.apana.org.au>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026163319.GA2785420@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 26, 2021 at 09:33:19AM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Fri, Sep 17, 2021 at 08:26:19AM +0800, Herbert Xu wrote:
> > When complex algorithms that depend on other algorithms are built
> > into the kernel, the order of registration must be done such that
> > the underlying algorithms are ready before the ones on top are
> > registered.  As otherwise they would fail during the self-test
> > which is required during registration.
> > 
> > In the past we have used subsystem initialisation ordering to
> > guarantee this.  The number of such precedence levels are limited
> > and they may cause ripple effects in other subsystems.
> > 
> > This patch solves this problem by delaying all self-tests during
> > boot-up for built-in algorithms.  They will be tested either when
> > something else in the kernel requests for them, or when we have
> > finished registering all built-in algorithms, whichever comes
> > earlier.
> > 
> > Reported-by: Vladis Dronov <vdronov@redhat.com>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > 
> 
> I can not explain it, but this patch causes a crash with one of my boot
> tests (riscv32 with riscv32 virt machine and e1000 network adapter):
> 
> [    9.948557] e1000 0000:00:01.0: enabling device (0000 -> 0003)

Does this still occur with the latest patch I sent yesterday?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
