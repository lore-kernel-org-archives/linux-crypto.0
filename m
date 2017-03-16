From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/2] crypto: skcipher AF_ALG - overhaul memory
 management
Date: Thu, 16 Mar 2017 17:52:48 +0800
Message-ID: <20170316095248.GA11996@gondor.apana.org.au>
References: <2523592.mde6d2a8Lg@positron.chronox.de>
 <13069331.7r3bo5pPcW@positron.chronox.de>
 <20170316090823.GA11924@gondor.apana.org.au>
 <1797510.JnIj36BbdJ@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45505 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751141AbdCPJw6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 05:52:58 -0400
Content-Disposition: inline
In-Reply-To: <1797510.JnIj36BbdJ@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 16, 2017 at 10:23:49AM +0100, Stephan Müller wrote:
> Am Donnerstag, 16. März 2017, 10:08:23 CET schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Thu, Mar 16, 2017 at 09:55:17AM +0100, Stephan Müller wrote:
> > > With this approach I thought that the while loop could be a thing of the
> > > past, considering that this is also the approach taken in
> > > skcipher_recvmsg_async that is present in the current upstream code base.
> > 
> > The reason there is a limit is so that user-space doesn't pin down
> > unlimited amounts of memory.  How is this addressed under your
> > scheme?
> 
> sock_kmalloc limits the number of SG tables that we can manage. On my system, 
> sock_kmalloc has 20480 bytes at its disposal as the limiting factor.
> 
> As this concept for limiting the impact of user space on kernel memory is used 
> in the current upstream skcipher_recvmsg_async, I simply re-used that 
> approach:
> 
>         while (iov_iter_count(&msg->msg_iter)) {
>                 struct skcipher_async_rsgl *rsgl;
> ...
>                         rsgl = kmalloc(sizeof(*rsgl), GFP_KERNEL);
> ...
> 
> Note I use sock_kmalloc instead of the currently existing kmalloc to ensure 
> such limitation.

First of all you're only limiting the amount of memory occupied
by the SG list which is not the same thing as the memory pinned
down by the actual recvmsg.

More importantly, with the current code, a very large recvmsg
would still work by doing it piecemeal.  With your patch, won't
it fail because sock_kmalloc could fail to allocate memory for
the whole thing?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
