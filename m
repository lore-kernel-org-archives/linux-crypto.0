From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: AF_ALG: skb limits
Date: Mon, 15 Jan 2018 09:46:06 +0000
Message-ID: <20180115094606.000005e0@huawei.com>
References: <001a1141f050d78763055f85c42e@google.com>
        <3071479.2PrSHYvzOR@tauon.chronox.de>
        <20171212135921.00002630@huawei.com>
        <2851496.QEPl29WkUh@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4221 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932385AbeAOJqh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 04:46:37 -0500
In-Reply-To: <2851496.QEPl29WkUh@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 13 Jan 2018 15:04:20 +0100
Stephan Müller <smueller@chronox.de> wrote:

> Am Dienstag, 12. Dezember 2017, 14:59:21 CET schrieb Jonathan Cameron:
>
Hi Stephan,
 
> Hi Jonathan,
> 
> > On Fri, 8 Dec 2017 13:43:20 +0100
> > 
> > Stephan Mueller <smueller@chronox.de> wrote:  
> > > Am Freitag, 8. Dezember 2017, 12:39:06 CET schrieb Jonathan Cameron:
> > > 
> > > Hi Jonathan,
> > >   
> > > > As a heads up, the other nasties we've found so far are around hitting
> > > > limits on the various socket buffers.  When you run into those you can
> > > > end
> > > > up with parts of the data to be encrypted going through without it being
> > > > obvious.  
> > > 
> > > The entire code uses sock_alloc to prevent user space to chew up kernel
> > > memory. I am aware that if you have a too low skb buffer limit, parts of
> > > the cipher operation will not succeed as a malloc will fail.
> > > 
> > > But that is returned with an error to user space.  
> > 
> > I 'think' there are some cases where you don't get an error to userspace -
> > or at least not directly.
> > 
> > In af_alg_get_rsgl, we have an af_alg_readable(sk) call which simply breaks
> > out of the loop - leaving us with len set to potentially part of the
> > required length - without setting a appropriate return value.
> > 
> > I can't immediately see how this one is reported to userspace.  
> 
> af_alg_get_rsgl is used to calculate and obtain the length of the buffers 
> receiving the result (what is called RX buffers). That length is used for the 
> cipher operation and finally reported to user space.
> 
> For example (TX is the buffer given to the kernel during sendmsg, RX during 
> recvmsg) where the example disregards the alignment to block size:
> 
> sendmsg TX: 1000 bytes
> recvmsg RX: 100 bytes given by user space, 100 bytes obtained by kernel
> 	=> recvmsg returns 100  
> recvmsg RX: 1000 bytes given by user space, 900 bytes obtained by kernel
> 	=> recvmsg returns 900  
> 
> Note, the TX and RX buffer sizes may *not* be identical or even related. User 
> space may send one large input block as TX, but "process" it with numerous 
> small recvmsg calls. Each recvmsg call defines the cipher operation size. This 
> is of particular importance for an AEAD cipher.
Sure.
> > 
> > At least, with my driver, the first we see is an error returned by the
> > processing engine. That ultimately gets reported to userspace the aio
> > path.  
> 
> So, you say that the error is returned. Isn't that what you want or expect?

Given the issue is detected at sending to the device I would expect it to
be reported then not when we get corrupt data back from the device.  Note
this isn't the crypto core detecting it but the hardware picking up on a malformed
configuration.  There could easily be other hardware out there that would not
detect this at all and would simply, transparently, return the wrong value.

Now it's possible it would also be detected as a wrong length at the receive
end, but I'm not getting that far.  I would have expected the system to have
not queued it up for processing in the first place if not all the data is
there (because we have no space for the result).

Jonathan

> > 
> > I'm chasing a particularly evil bug in my driver at the moment that is
> > locking up the CPU and IOMMUs - if I ever figure that one out I'll run some
> > fuzzing around these limits and see if we can find other cases.  
> 
> Ciao
> Stephan
> 
> 
