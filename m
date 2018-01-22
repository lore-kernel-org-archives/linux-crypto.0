From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH] crypto: AF_ALG - inline IV support
Date: Mon, 22 Jan 2018 14:52:38 +0000
Message-ID: <20180122145238.00007c43@huawei.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
        <1972650.zFSS3VNpIS@tauon.chronox.de>
        <20180122141153.00000824@huawei.com>
        <1728521.yYMT8LsByJ@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <harsh@chelsio.com>, <linuxarm@huawei.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4670 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750848AbeAVOyH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jan 2018 09:54:07 -0500
In-Reply-To: <1728521.yYMT8LsByJ@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 22 Jan 2018 15:30:39 +0100
Stephan Mueller <smueller@chronox.de> wrote:

> Am Montag, 22. Januar 2018, 15:11:53 CET schrieb Jonathan Cameron:
> 
> Hi Jonathan,
Hi Stephan,
> 
> > On Mon, 15 Jan 2018 10:35:34 +0100
> > 
> > Stephan Mueller <smueller@chronox.de> wrote:  
> > > The kernel crypto API requires the caller to set an IV in the request
> > > data structure. That request data structure shall define one particular
> > > cipher operation. During the cipher operation, the IV is read by the
> > > cipher implementation and eventually the potentially updated IV (e.g.
> > > in case of CBC) is written back to the memory location the request data
> > > structure points to.
> > > 
> > > AF_ALG allows setting the IV with a sendmsg request, where the IV is
> > > stored in the AF_ALG context that is unique to one particular AF_ALG
> > > socket. Note the analogy: an AF_ALG socket is like a TFM where one
> > > recvmsg operation uses one request with the TFM from the socket.
> > > 
> > > AF_ALG these days supports AIO operations with multiple IOCBs. I.e.
> > > with one recvmsg call, multiple IOVECs can be specified. Each
> > > individual IOCB (derived from one IOVEC) implies that one request data
> > > structure is created with the data to be processed by the cipher
> > > implementation. The IV that was set with the sendmsg call is registered
> > > with the request data structure before the cipher operation.
> > > 
> > > In case of an AIO operation, the cipher operation invocation returns
> > > immediately, queuing the request to the hardware. While the AIO request
> > > is processed by the hardware, recvmsg processes the next IOVEC for
> > > which another request is created. Again, the IV buffer from the AF_ALG
> > > socket context is registered with the new request and the cipher
> > > operation is invoked.
> > > 
> > > You may now see that there is a potential race condition regarding the
> > > IV handling, because there is *no* separate IV buffer for the different
> > > requests. This is nicely demonstrated with libkcapi using the following
> > > command which creates an AIO request with two IOCBs each encrypting one
> > > AES block in CBC mode:
> > > 
> > > kcapi  -d 2 -x 9  -e -c "cbc(aes)" -k
> > > 8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i
> > > 7fbc02ebf5b93322329df9bfccb635af -p 48981da18e4bb9ef7e2e3162d16b1910
> > > 
> > > When the first AIO request finishes before the 2nd AIO request is
> > > processed, the returned value is:
> > > 
> > > 8b19050f66582cb7f7e4b6c873819b7108afa0eaa7de29bac7d903576b674c32
> > > 
> > > I.e. two blocks where the IV output from the first request is the IV input
> > > to the 2nd block.
> > > 
> > > In case the first AIO request is not completed before the 2nd request
> > > commences, the result is two identical AES blocks (i.e. both use the
> > > same IV):
> > > 
> > > 8b19050f66582cb7f7e4b6c873819b718b19050f66582cb7f7e4b6c873819b71
> > > 
> > > This inconsistent result may even lead to the conclusion that there can
> > > be a memory corruption in the IV buffer if both AIO requests write to
> > > the IV buffer at the same time.
> > > 
> > > The solution is to allow providing the IV data supplied as part of the
> > > plaintext/ciphertext. To do so, the AF_ALG interface treats the
> > > ALG_SET_OP flag usable with sendmsg as a bit-array allowing to set the
> > > cipher operation together with the flag whether the operation should
> > > enable support for inline IV handling.
> > > 
> > > If inline IV handling is enabled, the IV is expected to be the first
> > > part of the input plaintext/ciphertext. This IV is only used for one
> > > cipher operation and will not retained in the kernel for subsequent
> > > cipher operations.
> > > 
> > > The AEAD support required a slight re-arragning of the code, because
> > > obtaining the IV implies that ctx->used is updated. Thus, the ctx->used
> > > access in _aead_recvmsg must be moved below the IV gathering.
> > > 
> > > The AEAD code to find the first SG with data in the TX SGL is moved to a
> > > common function as it is required by the IV gathering function as well.
> > > 
> > > This patch does not change the existing interface where user space is
> > > allowed to provide an IV via sendmsg. It only extends the interface by
> > > giving the user the choice to provide the IV either via sendmsg (the
> > > current approach) or as part of the data (the additional approach).
> > > 
> > > Signed-off-by: Stephan Mueller <smueller@chronox.de>  
> > 
> > Firstly it works
> > Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>  
> 
> Thank you.
> > 
> > Now to be really useful for my particular hardware (which doesn't do
> > dependency tracking in its out of order queues) what I need to know is
> > whether I need to let previous queued up entries finish before I can run
> > this one or not.
> > 
> > Now there is an obvious 'hack' I can use, which is that the above only
> > matters is if the IV is still 'in flight'. Given it is still inflight the
> > memory is in use. Thus until it is finished it's address is clearly only
> > being used by 'this IV'.
> > 
> > Hence I can just compare against the address of the IV for the previous
> > packet. If it changed we know there is no need to wait for previous packets
> > to finish.  
> 
> That is dangerous, because the IV is in a malloced location. It is possible 
> that a new malloc will return the same address.

True, but this can only happen once a free has occurred which means the
IV is done with from the previous point of view and we no longer need to
track the dependency.

So it doesn't tell us if the two messages use the same IV or not, but in the
case where it is wrong (and indeed I typically get the same address a lot 
of times when running little else on the machine) it doesn't matter because
the element is already finished and so there is nothing to queue behind.

> 
> What about simply applying the cipher operation as "one shot". I.e. one 
> invocation of a cipher operation is isolated from the next. Thus, queue one 
> request defined with one request data structure and handle each request 
> independent from the next.

I do queue one request from one structure, but if chaining is going on
(the first one should save the chained IV for the second one) I have to wait
for the update to happen before I can put the second one on the queue.

This is done by having a front end software queue when in chaining modes.
The conditions for entry into the hardware queue are:

(hardware queue empty AND software feeder queue empty) OR
(no dependency AND software feeder queue empty) 

The completion hander will then move a message from software to hardware
queues if there is one waiting.

It is this dependency tracking that indirectly takes the time as I can only
have one invocation in the hardware queues at a time - hence each interrupt
is for only one invocation.  Given I have a number of hardware engines
behind the queue I really want to get as many in flight as possible.
To do this I need to know they are independent at ingress.

I need to get the driver through our internal processes, but hopefully can
post an RFC sometime later this week.

Jonathan
> > 
> > I'll still have to be a little careful to avoid DoS issues if we flip from
> > one mode to the other but I can do that by ensuring my software queue is
> > empty before pushing to the hardware queue.
> > 
> > Anyhow using the address does seem a little fragile, any suggestions for a
> > better way?
> > 
> > On the plus side, with 8k iovs I'm getting around a 50% performance boost by
> > not having to serialize the entry into the hardware queues. From a few back
> > of the envelope calculations the key thing is that I can coalesce
> > interrupts.
> > 
> > For very small iovs the overhead of setting them us is enough to mean we
> > rarely end up with many in the queue at a time so the benefits aren't
> > seen.
> > 
> > On that note I have a hacked up libkcapi speed test that adds a parameter to
> > control this.  I'll send you a pull request later so you can take a look. I
> > have only done the skcipher case though and I am sure it could be done in a
> > neater fashion!  
> 
> Thank you.
> 
> Ciao
> Stephan
> 
> 
