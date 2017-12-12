From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: AF_ALG: skb limits
Date: Tue, 12 Dec 2017 13:59:21 +0000
Message-ID: <20171212135921.00002630@huawei.com>
References: <001a1141f050d78763055f85c42e@google.com>
        <5543369.6UIL7PonCy@positron.chronox.de>
        <20171208113906.000050aa@huawei.com>
        <3071479.2PrSHYvzOR@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3071479.2PrSHYvzOR@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 8 Dec 2017 13:43:20 +0100
Stephan Mueller <smueller@chronox.de> wrote:

> Am Freitag, 8. Dezember 2017, 12:39:06 CET schrieb Jonathan Cameron:
> 
> Hi Jonathan,
> 
> > 
> > As a heads up, the other nasties we've found so far are around hitting
> > limits on the various socket buffers.  When you run into those you can end
> > up with parts of the data to be encrypted going through without it being
> > obvious.
> >   
> 
> The entire code uses sock_alloc to prevent user space to chew up kernel 
> memory. I am aware that if you have a too low skb buffer limit, parts of the 
> cipher operation will not succeed as a malloc will fail.
> 
> But that is returned with an error to user space. 
I 'think' there are some cases where you don't get an error to userspace - or
at least not directly.

In af_alg_get_rsgl, we have an af_alg_readable(sk) call which simply breaks out
of the loop - leaving us with len set to potentially part of the required length
- without setting a appropriate return value.

I can't immediately see how this one is reported to userspace.

At least, with my driver, the first we see is an error returned by the processing
engine.  That ultimately gets reported to userspace the aio path.

I'm chasing a particularly evil bug in my driver at the moment that is locking
up the CPU and IOMMUs - if I ever figure that one out I'll run some fuzzing
around these limits and see if we can find other cases.

Jonathan

> If you observe such an 
> error, the entire message you wanted to read with recvmsg must be considered 
> tainted (i.e. you do not know which part of the message has been encrypted or 
> not). Thus, the recvmsg must be invoked again on the same buffer sent to the 
> kernel if you want to ensure you encrypted the data.
> 
> Could you please help me understand where that functionality fails?
> 
> PS: If you want to give more memory to your sockets, you have to tweak /proc/
> sys/net/core/optmem_max.
> 
> Ciao
> Stephan
