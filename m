From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v5 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Thu, 16 Mar 2017 10:23:49 +0100
Message-ID: <1797510.JnIj36BbdJ@tauon.atsec.com>
References: <2523592.mde6d2a8Lg@positron.chronox.de> <13069331.7r3bo5pPcW@positron.chronox.de> <20170316090823.GA11924@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58080 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbdCPJXw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 05:23:52 -0400
In-Reply-To: <20170316090823.GA11924@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. März 2017, 10:08:23 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Mar 16, 2017 at 09:55:17AM +0100, Stephan Müller wrote:
> > With this approach I thought that the while loop could be a thing of the
> > past, considering that this is also the approach taken in
> > skcipher_recvmsg_async that is present in the current upstream code base.
> 
> The reason there is a limit is so that user-space doesn't pin down
> unlimited amounts of memory.  How is this addressed under your
> scheme?

sock_kmalloc limits the number of SG tables that we can manage. On my system, 
sock_kmalloc has 20480 bytes at its disposal as the limiting factor.

As this concept for limiting the impact of user space on kernel memory is used 
in the current upstream skcipher_recvmsg_async, I simply re-used that 
approach:

        while (iov_iter_count(&msg->msg_iter)) {
                struct skcipher_async_rsgl *rsgl;
...
                        rsgl = kmalloc(sizeof(*rsgl), GFP_KERNEL);
...

Note I use sock_kmalloc instead of the currently existing kmalloc to ensure 
such limitation.

Also, please note that this approach is identical to the currently used code 
in algif_aead:aead_recvmsg_sync. This implementation led be to belief that 
this my new code would be appropriate in this case, too.

Ciao
Stephan
