From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH] crypto: AF_ALG AIO - lock context IV
Date: Wed, 31 Jan 2018 12:29:56 +0000
Message-ID: <20180131122956.000061a3@huawei.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
        <2165621.DHQGk8sIp3@positron.chronox.de>
        <51c57076-4a01-308c-583b-8c34afc3b2e4@chelsio.com>
        <11410454.xUfCo2NHDh@positron.chronox.de>
        <20180130155140.000038b5@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Harsh Jain <harsh@chelsio.com>, <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:5157 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752273AbeAaMa3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 07:30:29 -0500
In-Reply-To: <20180130155140.000038b5@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 30 Jan 2018 15:51:40 +0000
Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:

> On Tue, 30 Jan 2018 09:27:04 +0100
> Stephan Müller <smueller@chronox.de> wrote:

A few clarifications from me after discussions with Stephan this morning.

> 
> > Hi Harsh,
> > 
> > may I as you to try the attached patch on your Chelsio driver? Please invoke 
> > the following command from libkcapi:
> > 
> > kcapi  -d 2 -x 9  -e -c "cbc(aes)" -k 
> > 8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i 
> > 7fbc02ebf5b93322329df9bfccb635af -p 48981da18e4bb9ef7e2e3162d16b1910
> > 
> > The result should now be a fully block-chained result.
> > 
> > Note, the patch goes on top of the inline IV patch.
> > 
> > Thanks
> > 
> > ---8<---
> > 
> > In case of AIO where multiple IOCBs are sent to the kernel and inline IV
> > is not used, the ctx->iv is used for each IOCB. The ctx->iv is read for
> > the crypto operation and written back after the crypto operation. Thus,
> > processing of multiple IOCBs must be serialized.
> > 
> > As the AF_ALG interface is used by user space, a mutex provides the
> > serialization which puts the caller to sleep in case a previous IOCB
> > processing is not yet finished.
> > 
> > If multiple IOCBs arrive that all are blocked, the mutex' FIFO operation
> > of processing arriving requests ensures that the blocked IOCBs are
> > unblocked in the right order.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de> 

Firstly, as far as I can tell (not tested it yet) the patch does the
job and is about the best we can easily do in the AF_ALG code.

I'd suggest that this (or v2 anyway) is stable material as well
(which, as Stephan observed, will require reordering of the two patches).

> 
> As a reference point, holding outside the kernel (in at least
> the case of our hardware with 8K CBC) drops us down to around 30%
> of performance with separate IVs.  Putting a queue in kernel
> (and hence allowing most setup of descriptors / DMA etc) gets us
> up to 50% of raw non chained performance.
> 
> So whilst this will work in principle I suspect anyone who
> cares about the cost will be looking at adding their own
> software queuing and dependency handling in driver.  How
> much that matters will depend on just how quick the hardware
> is vs overheads.
> 
> Anyhow, just posted the driver as an RFC. There are a few corners
> that need resolving and the outcome of this thread effects whether
> we need to play games with IVs or not.
> 
> https://marc.info/?l=linux-crypto-vger&m=151732626428206&w=2
> grep for softqueue.
> 
> We have a number of processing units that will grab requests
> from the HW queues in parallel.  So 'lots' of requests
> from a given HW queue may be in flight at the same time (the problem
> case).
> 
> Logic is fairly simple.
> 1. Only create a softqueue if the encryption mode requires chaining.
>    Currently in this driver that is CBC and CTR modes only.
>    Otherwise put everything straight in the hardware monitored queues.
> 2. If we have an IV embedded within the request it will have a different
>    address to the one used previously (guaranteed if that one is still
>    in flight and it doesn't matter if it isn't).  If that occurs we
>    can safely add it to the hardware queue. To avoid DoS issues against
>    and earlier set of messages using the a chained IV we actually make
>    sure nothing is in the software queue (not needed for correctness)
> 3. If IV matches previous IV and there are existing elements in SW or HW
>    queues we need to hold it in the SW queue.
> 4. On receiving a response from the hardware and if the hardware queue
>    is empty, we can release an element from the software queue into the
>    hardware queue.

The differences are better shown with pictures...
To compare the two approaches. If we break up the data flow the
alternatives are

1) Mutex causes queuing in AF ALG code

The key thing is the [Build / Map HW Descs] for small packets,
up to perhaps 32K, is a significant task we can't avoid.
At 8k it looks like it takes perhaps 20-30% of the time
(though I only have end to end performance numbers so far)


[REQUEST 1 from userspace]   
           |                  [REQUEST 2 from userspace] 
    [AF_ALG/SOCKET]                       |
           |                       [AF_ALG/SOCKET]
    NOTHING BLOCKING (lock mut)           |
           |                        Queued on Mutex
 [BUILD / MAP HW DESCS]                   | 
           |                              |
   [Place in HW Queue]                    |
           |                              |
       [Process]                          |
           |                              |
      [Interrupt]                         | 
           |                              |
 [Respond and update IV]     Nothing Blocking (lock mut)        
           |                    [BUILD / MAP HW DESCS] * AFTER SERIALIZATION *     
 Don't care beyond here.                  |
                                  [Place in HW Queue]
                                          |
                                      [Process] 
                                          |
                                     [Interrupt]
                                          |
                                [Respond and update IV]
                                          |
                                Don't care beyond here.   


2) The queuing approach I did in the driver moves that serialization
to after the BUILD / MAP HW DESCs stage.

[REQUEST 1 from userspace]   
           |                  [REQUEST 2 from userspace] 
    [AF_ALG/SOCKET]                       |
           |                       [AF_ALG/SOCKET]
 [BUILD / MAP HW DESCS]                   |
           |                     [BUILD / MAP HW DESCS] * BEFORE SERIALIZATION *
 NOTHING BLOCKING                         | 
           |                   IV in flight (enqueue sw queue)
   [Place in HW Queue]                    |
           |                              |
       [Process]                          |
           |                              |
      [Interrupt]                         | 
           |                              |
 [Respond and update IV]     Nothing Blocking (dequeue sw queue)        
           |                      [Place in HW Queue]      
 Don't care beyond here.                  |
                                      [Process]
                                          |
                                     [Interrupt]
                                          |
                                [Respond and update IV]
                                          |
                                Don't care beyond here. 

> 
> This maintains chaining when needed and gets a good chunk of the lost
> performance back.  I believe (though yet to verify) the remaining lost
> performance is mostly down to the fact we can't coalesce interrupts if
> chaining.
> 
> Note the driver is deliberately a touch 'simplistic' so there may be other
> optimization opportunities to get some of the lost performance back or
> it may be fundamental due to the fact the raw processing can't be in
> parallel.
> 

Quoting a private email from Stephan (at Stephan's suggestion)

> What I however could fathom is that we introduce a flag where a driver 
> implements its own queuing mechanism. In this case, the mutex handling would 
> be disregarded.  

Which works well for the sort of optimization I did and for hardware that
can do iv dependency tracking itself. If hardware dependency tracking was
avilable, you would be able to queue up requests with a chained IV
without taking any special precautions at all. The hardware would
handle the IV update dependencies.

So in conclusion, Stephan's approach should work and give us a nice
small patch suitable for stable inclusion.

However, if people know that their setup overhead can be put in parallel
with previous requests (even when the IV is not yet updated) then they will
probably want to do something inside their own driver and set the flag
that Stephan is proposing adding to bypass the mutex approach.

Jonathan
> > ---
> >  crypto/af_alg.c         | 22 ++++++++++++++++++++++
> >  crypto/algif_aead.c     |  2 ++
> >  crypto/algif_skcipher.c |  2 ++
> >  include/crypto/if_alg.h |  3 +++
> >  4 files changed, 29 insertions(+)
> > 
> > diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> > index 87394dc90ac0..3007c9d899da 100644
> > --- a/crypto/af_alg.c
> > +++ b/crypto/af_alg.c
> > @@ -1059,6 +1059,8 @@ void af_alg_async_cb(struct crypto_async_request *_req, 
> > int err)
> >  	struct kiocb *iocb = areq->iocb;
> >  	unsigned int resultlen;
> >  
> > +	af_alg_put_iv(sk);
> > +
> >  	/* Buffer size written by crypto operation. */
> >  	resultlen = areq->outlen;
> >  
> > @@ -1227,6 +1229,11 @@ int af_alg_get_iv(struct sock *sk, struct 
> > af_alg_async_req *areq)
> >  
> >  	/* No inline IV or cipher has no IV, use ctx IV buffer. */
> >  	if (!ctx->iiv || !ctx->ivlen) {
> > +		int ret = mutex_lock_interruptible(&ctx->ivlock);
> > +
> > +		if (ret)
> > +			return ret;
> > +
> >  		areq->iv = ctx->iv;
> >  		areq->ivlen = 0;	// areq->iv will not be freed
> >  		return 0;
> > @@ -1252,6 +1259,21 @@ int af_alg_get_iv(struct sock *sk, struct 
> > af_alg_async_req *areq)
> >  }
> >  EXPORT_SYMBOL_GPL(af_alg_get_iv);
> >  
> > +/**
> > + * af_alg_put_iv - release lock on IV in case CTX IV is used
> > + *
> > + * @sk [in] AF_ALG socket
> > + */
> > +void af_alg_put_iv(struct sock *sk)
> > +{
> > +	struct alg_sock *ask = alg_sk(sk);
> > +	struct af_alg_ctx *ctx = ask->private;
> > +
> > +	if (!ctx->iiv || !ctx->ivlen)
> > +		mutex_unlock(&ctx->ivlock);
> > +}
> > +EXPORT_SYMBOL_GPL(af_alg_put_iv);
> > +
> >  static int __init af_alg_init(void)
> >  {
> >  	int err = proto_register(&alg_proto, 0);
> > diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> > index 7eb7cb132c09..165b2ca82e51 100644
> > --- a/crypto/algif_aead.c
> > +++ b/crypto/algif_aead.c
> > @@ -309,6 +309,7 @@ static int _aead_recvmsg(struct socket *sock, struct 
> > msghdr *msg,
> >  				&ctx->wait);
> >  	}
> >  
> > +	af_alg_put_iv(sk);
> >  
> >  free:
> >  	af_alg_free_resources(areq);
> > @@ -555,6 +556,7 @@ static int aead_accept_parent_nokey(void *private, struct 
> > sock *sk)
> >  		return -ENOMEM;
> >  	}
> >  	memset(ctx->iv, 0, ctx->ivlen);
> > +	mutex_init(&ctx->ivlock);
> >  
> >  	INIT_LIST_HEAD(&ctx->tsgl_list);
> >  	ctx->len = len;
> > diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> > index d40e1d6797d8..a759cec446b4 100644
> > --- a/crypto/algif_skcipher.c
> > +++ b/crypto/algif_skcipher.c
> > @@ -151,6 +151,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct 
> > msghdr *msg,
> >  						 &ctx->wait);
> >  	}
> > +	af_alg_put_iv(sk);
> >  
> >  free:
> >  	af_alg_free_resources(areq);
> > @@ -358,6 +359,7 @@ static int skcipher_accept_parent_nokey(void *private, 
> > struct sock *sk)
> >  	}
> >  	memset(ctx->iv, 0, ctx->ivlen);
> > +	mutex_init(&ctx->ivlock);
> >  
> >  	INIT_LIST_HEAD(&ctx->tsgl_list);
> >  	ctx->len = len;
> > diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> > index ebc651ceb54a..666be8ac683c 100644
> > --- a/include/crypto/if_alg.h
> > +++ b/include/crypto/if_alg.h
> > @@ -19,6 +19,7 @@
> >  #include <linux/scatterlist.h>
> >  #include <linux/types.h>
> >  #include <linux/atomic.h>
> > +#include <linux/mutex.h>
> >  #include <net/sock.h>
> >  
> >  #include <crypto/aead.h>
> > @@ -160,6 +161,7 @@ struct af_alg_ctx {
> >  
> >  	void *iv;
> >  	unsigned int ivlen;
> > +	struct mutex ivlock;
> >  	size_t aead_assoclen;
> >  
> >  	struct crypto_wait wait;
> > @@ -268,6 +270,7 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, 
> > int flags,
> >  		    struct af_alg_async_req *areq, size_t maxsize,
> >  		    size_t *outlen);
> >  int af_alg_get_iv(struct sock *sk, struct af_alg_async_req *areq);
> > +void af_alg_put_iv(struct sock *sk);
> >  struct scatterlist *af_alg_get_tsgl_sg(struct af_alg_ctx *ctx);
> >  
> >  #endif	/* _CRYPTO_IF_ALG_H */  
> 
