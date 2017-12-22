From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: Fix race around ctx->rcvused by making it atomic_t
Date: Fri, 22 Dec 2017 08:50:01 +0100
Message-ID: <11744235.QUrfmsyV1D@tauon.chronox.de>
References: <20171218161045.0000161c@huawei.com> <20171222074803.GD27149@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44318 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbdLVHuD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 02:50:03 -0500
In-Reply-To: <20171222074803.GD27149@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 22. Dezember 2017, 08:48:03 CET schrieb Herbert Xu:

Hi Herbert,

> On Tue, Dec 19, 2017 at 10:31:22AM +0000, Jonathan Cameron wrote:
> > This variable was increased and decreased without any protection.
> > Result was an occasional misscount and negative wrap around resulting
> > in false resource allocation failures.
> > 
> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
> 
> Actually I think it used to be fine because we held the socket
> lock in the async callback.  It only got broken when we removed
> the socket lock from the callback.

But we cannot hold the lock in the async callback since it may be called in 
interrupt context.

Ciao
Stephan
