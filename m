From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [RFC] AF_ALG AIO and IV
Date: Mon, 15 Jan 2018 11:05:03 +0000
Message-ID: <20180115110503.000040fc@huawei.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <harsh@chelsio.com>,
        <linuxarm@huawei.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4223 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751317AbeAOLFi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 06:05:38 -0500
In-Reply-To: <2118226.LQArbCsRu5@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 12 Jan 2018 14:21:15 +0100
Stephan Mueller <smueller@chronox.de> wrote:

> Hi,
> 
> The kernel crypto API requires the caller to set an IV in the request data 
> structure. That request data structure shall define one particular cipher 
> operation. During the cipher operation, the IV is read by the cipher 
> implementation and eventually the potentially updated IV (e.g. in case of CBC) 
> is written back to the memory location the request data structure points to.

Silly question, are we obliged to always write it back? In CBC it is obviously
the same as the last n bytes of the encrypted message.  I guess for ease of
handling it makes sense to do so though.

> 
> AF_ALG allows setting the IV with a sendmsg request, where the IV is stored in 
> the AF_ALG context that is unique to one particular AF_ALG socket. Note the 
> analogy: an AF_ALG socket is like a TFM where one recvmsg operation uses one 
> request with the TFM from the socket.
> 
> AF_ALG these days supports AIO operations with multiple IOCBs. I.e. with one 
> recvmsg call, multiple IOVECs can be specified. Each individual IOCB (derived 
> from one IOVEC) implies that one request data structure is created with the 
> data to be processed by the cipher implementation. The IV that was set with 
> the sendmsg call is registered with the request data structure before the 
> cipher operation.
> 
> In case of an AIO operation, the cipher operation invocation returns 
> immediately, queuing the request to the hardware. While the AIO request is 
> processed by the hardware, recvmsg processes the next IOVEC for which another 
> request is created. Again, the IV buffer from the AF_ALG socket context is 
> registered with the new request and the cipher operation is invoked.
> 
> You may now see that there is a potential race condition regarding the IV 
> handling, because there is *no* separate IV buffer for the different requests. 
> This is nicely demonstrated with libkcapi using the following command which 
> creates an AIO request with two IOCBs each encrypting one AES block in CBC 
> mode:
> 
> kcapi  -d 2 -x 9  -e -c "cbc(aes)" -k 
> 8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i 
> 7fbc02ebf5b93322329df9bfccb635af -p 48981da18e4bb9ef7e2e3162d16b1910
> 
> When the first AIO request finishes before the 2nd AIO request is processed, 
> the returned value is:
> 
> 8b19050f66582cb7f7e4b6c873819b7108afa0eaa7de29bac7d903576b674c32
> 
> I.e. two blocks where the IV output from the first request is the IV input to 
> the 2nd block.
> 
> In case the first AIO request is not completed before the 2nd request 
> commences, the result is two identical AES blocks (i.e. both use the same IV):
> 
> 8b19050f66582cb7f7e4b6c873819b718b19050f66582cb7f7e4b6c873819b71
> 
> This inconsistent result may even lead to the conclusion that there can be a 
> memory corruption in the IV buffer if both AIO requests write to the IV buffer 
> at the same time.
> 
> This needs to be solved somehow. I see the following options which I would 
> like to have vetted by the community.
>

Taking some 'entirely hypothetical' hardware with the following structure
for all my responses - it's about as flexible as I think we'll see in the
near future - though I'm sure someone has something more complex out there :)

N hardware queues feeding M processing engines in a scheduler driven fashion.
Actually we might have P sets of these, but load balancing and tracking and
transferring contexts between these is a complexity I think we can ignore.
If you want to use more than one of these P you'll just have to handle it
yourself in userspace.  Note messages may be shorter than IOCBs which
raises another question I've been meaning to ask.  Are all crypto algorithms
obliged to run unlimited length IOCBs?

If there are M messages in a particular queue and none elsewhere it is
capable of processing them all at once (and perhaps returning out of order but
we can fudge them back in order in the driver to avoid that additional
complexity from an interface point of view).

So I'm going to look at this from the hardware point of view - you have
well addressed software management above.

Three ways context management can be handled (in CBC this is basically just
the IV).

1. Each 'work item' queued on a hardware queue has it's IV embedded with the
data.  This requires external synchronization if we are chaining across
multiple 'work items' - note the hardware may have restrictions that mean
it has to split large pieces of data up to encrypt them.  Not all hardware
may support per 'work item' IVs (I haven't done a survey to find out if
everyone does...)

2. Each queue has a context assigned.  We get a new queue whenever we want
to have a different context.  Runs out eventually but our hypothetical
hardware may support a lot of queues.  Note this version could be 'faked'
by putting a cryptoengine queue on the front of the hardware queues.

3. The hardware supports IV dependency tracking in it's queues.  That is,
it can check if the address pointing to the IV is in use by one of the
processing units which has not yet updated the IV ready for chaining with
the next message.  Note it might use a magic token rather than the IV
pointer.  For modes with out chaining (including counter modes) the IV
pointer will inherently always be different.
The hardware then simply schedules something else until it can safely
run that particular processing unit.

> 1. Require that the cipher implementations serialize any AIO requests that 
> have dependencies. I.e. for CBC, requests need to be serialized by the driver. 
> For, say, ECB or XTS no serialization is necessary.

There is a certain requirement to do this anyway as we may have a streaming
type situation and we don't want to have to do the chaining in userspace.

So we send first X MB block to HW but before it has come back we have more
data arrive that needs decrypting so we queue that behind it.  The IV
then needs to be updated automatically (or the code needs to do it on the
first work item coming back). If you don't have option 3 above, you
have to do this.  This is what I was planning to implement for our existing
hardware before you raised this question and I don't think we get around
it being necessary for performance in any case. Setting up IOMMUs etc is
costly so we want to be doing everything we can before the IV update is
ready.

> 
> 2. Change AF_ALG to require a per-request IV. This could be implemented by 
> moving the IV submission via CMSG from sendmsg to recvmsg. I.e. the recvmsg 
> code path would obtain the IV.
> 
> I would tend to favor option 2 as this requires code change at only location. 
> If option 2 is considered, I would recommend to still allow setting the IV via 
> sendmsg CMSG (to keep the interface stable). If, however, the caller provides 
> an IV via recvmsg, this takes precedence.

We definitely want to keep option 1 (which runs on the existing interface and
does the magic in driver) for those who want it.

So the only one left is the case 3 above where the hardware is capable
of doing the dependency tracking.

We can support that in two ways but one is rather heavyweight in terms of
resources.

1) Whenever we want to allocate a new context we spin up a new socket and
effectively associate a single IV with that (and it's chained updates) much
like we do in the existing interface.

2) We allow a token based tracking of IVs.  So userspace code maintains
a counter and tags ever message and the initial IV setup with that counter.

As the socket typically belongs to a userspace process tag creation can
be in userspace and it can ensure it doesn't overlap tags (or it'll get
the wrong answer).

Kernel driver can then handle making sure any internal token / addresses
are correct.  I haven't looked at in depth but would imagine this one
would be rather more invasive to support.

> 
> If there are other options, please allow us to learn about them.
> 

Glad we are addressing these usecases and that we have AIO support in
general.  Makes for a better discussion around whether in kernel support
for these interfaces is actually as effective as moving to userspace
drivers...

Jonathan

> Ciao
> Stephan
> 
> 
