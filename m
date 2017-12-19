From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: Fix race around ctx->rcvused by making it atomic_t
Date: Tue, 19 Dec 2017 13:18:34 +0100
Message-ID: <6790987.QUO9dHqT75@tauon.chronox.de>
References: <20171218161045.0000161c@huawei.com> <3581602.Ey9azVmcPc@tauon.chronox.de> <20171219112642.0000160e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        davem@davemloft.net, herbert@gondor.apana.org.au
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44420 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935917AbdLSMSh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 07:18:37 -0500
In-Reply-To: <20171219112642.0000160e@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 19. Dezember 2017, 12:26:42 CET schrieb Jonathan Cameron:

Hi Jonathan,

> > > +	atomic_set(&ctx->rcvused, 0);
> > 
> > I think ATOMIC_INIT(0) is more suitable here.
> 
> It's ugly to use it to assign a dynamic element like this.
> 
> ctx->rcvused = (atomic_t)ATOMIC_INIT(0);

You are right, it is dynamic and not static assignment. Please disregard my 
comment.

Ciao
Stephan
