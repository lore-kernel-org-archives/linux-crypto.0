From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: AF_ALG: skb limits
Date: Sat, 13 Jan 2018 15:04:20 +0100
Message-ID: <2851496.QEPl29WkUh@positron.chronox.de>
References: <001a1141f050d78763055f85c42e@google.com> <3071479.2PrSHYvzOR@tauon.chronox.de> <20171212135921.00002630@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58254 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755122AbeAMOFR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Jan 2018 09:05:17 -0500
In-Reply-To: <20171212135921.00002630@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 12. Dezember 2017, 14:59:21 CET schrieb Jonathan Cameron:

Hi Jonathan,

> On Fri, 8 Dec 2017 13:43:20 +0100
> 
> Stephan Mueller <smueller@chronox.de> wrote:
> > Am Freitag, 8. Dezember 2017, 12:39:06 CET schrieb Jonathan Cameron:
> > 
> > Hi Jonathan,
> > 
> > > As a heads up, the other nasties we've found so far are around hitting
> > > limits on the various socket buffers.  When you run into those you can
> > > end
> > > up with parts of the data to be encrypted going through without it being
> > > obvious.
> > 
> > The entire code uses sock_alloc to prevent user space to chew up kernel
> > memory. I am aware that if you have a too low skb buffer limit, parts of
> > the cipher operation will not succeed as a malloc will fail.
> > 
> > But that is returned with an error to user space.
> 
> I 'think' there are some cases where you don't get an error to userspace -
> or at least not directly.
> 
> In af_alg_get_rsgl, we have an af_alg_readable(sk) call which simply breaks
> out of the loop - leaving us with len set to potentially part of the
> required length - without setting a appropriate return value.
> 
> I can't immediately see how this one is reported to userspace.

af_alg_get_rsgl is used to calculate and obtain the length of the buffers 
receiving the result (what is called RX buffers). That length is used for the 
cipher operation and finally reported to user space.

For example (TX is the buffer given to the kernel during sendmsg, RX during 
recvmsg) where the example disregards the alignment to block size:

sendmsg TX: 1000 bytes
recvmsg RX: 100 bytes given by user space, 100 bytes obtained by kernel
	=> recvmsg returns 100
recvmsg RX: 1000 bytes given by user space, 900 bytes obtained by kernel
	=> recvmsg returns 900

Note, the TX and RX buffer sizes may *not* be identical or even related. User 
space may send one large input block as TX, but "process" it with numerous 
small recvmsg calls. Each recvmsg call defines the cipher operation size. This 
is of particular importance for an AEAD cipher.
> 
> At least, with my driver, the first we see is an error returned by the
> processing engine. That ultimately gets reported to userspace the aio
> path.

So, you say that the error is returned. Isn't that what you want or expect?
> 
> I'm chasing a particularly evil bug in my driver at the moment that is
> locking up the CPU and IOMMUs - if I ever figure that one out I'll run some
> fuzzing around these limits and see if we can find other cases.

Ciao
Stephan
