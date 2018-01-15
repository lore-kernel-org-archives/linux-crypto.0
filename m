From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [RFC] AF_ALG AIO and IV
Date: Mon, 15 Jan 2018 12:59:27 +0000
Message-ID: <20180115125927.00007520@huawei.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
        <20180115110503.000040fc@huawei.com>
        <2353138.AYbjlSPjUL@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <harsh@chelsio.com>,
        <linuxarm@huawei.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4224 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966047AbeAONAM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 08:00:12 -0500
In-Reply-To: <2353138.AYbjlSPjUL@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 15 Jan 2018 13:07:16 +0100
Stephan Mueller <smueller@chronox.de> wrote:

> Am Montag, 15. Januar 2018, 12:05:03 CET schrieb Jonathan Cameron:
> 
> Hi Jonathan,
> 
> > On Fri, 12 Jan 2018 14:21:15 +0100
> > 
> > Stephan Mueller <smueller@chronox.de> wrote:  
> > > Hi,
> > > 
> > > The kernel crypto API requires the caller to set an IV in the request data
> > > structure. That request data structure shall define one particular cipher
> > > operation. During the cipher operation, the IV is read by the cipher
> > > implementation and eventually the potentially updated IV (e.g. in case of
> > > CBC) is written back to the memory location the request data structure
> > > points to.  
> > Silly question, are we obliged to always write it back?  
> 
> Well, in general, yes. The AF_ALG interface should allow a "stream" mode of 
> operation:
> 
> socket
> accept
> setsockopt(setkey)
> sendmsg(IV, data)
> recvmsg(data)
> sendmsg(data)
> recvmsg(data)
> ..
> 
> For such synchronous operation, I guess it is clear that the IV needs to be 
> written back.
> 
> If you want to play with it, use the "stream" API of libkcapi and the 
> associated test cases.

Thanks for the pointer - will do.

> 
> > In CBC it is
> > obviously the same as the last n bytes of the encrypted message.  I guess
> > for ease of handling it makes sense to do so though.
> >   
> > > AF_ALG allows setting the IV with a sendmsg request, where the IV is
> > > stored in the AF_ALG context that is unique to one particular AF_ALG
> > > socket. Note the analogy: an AF_ALG socket is like a TFM where one
> > > recvmsg operation uses one request with the TFM from the socket.
> > > 
> > > AF_ALG these days supports AIO operations with multiple IOCBs. I.e. with
> > > one recvmsg call, multiple IOVECs can be specified. Each individual IOCB
> > > (derived from one IOVEC) implies that one request data structure is
> > > created with the data to be processed by the cipher implementation. The
> > > IV that was set with the sendmsg call is registered with the request data
> > > structure before the cipher operation.
> > > 
> > > In case of an AIO operation, the cipher operation invocation returns
> > > immediately, queuing the request to the hardware. While the AIO request is
> > > processed by the hardware, recvmsg processes the next IOVEC for which
> > > another request is created. Again, the IV buffer from the AF_ALG socket
> > > context is registered with the new request and the cipher operation is
> > > invoked.
> > > 
> > > You may now see that there is a potential race condition regarding the IV
> > > handling, because there is *no* separate IV buffer for the different
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
> > > commences, the result is two identical AES blocks (i.e. both use the same
> > > IV):
> > > 
> > > 8b19050f66582cb7f7e4b6c873819b718b19050f66582cb7f7e4b6c873819b71
> > > 
> > > This inconsistent result may even lead to the conclusion that there can be
> > > a memory corruption in the IV buffer if both AIO requests write to the IV
> > > buffer at the same time.
> > > 
> > > This needs to be solved somehow. I see the following options which I would
> > > like to have vetted by the community.  
> > 
> > Taking some 'entirely hypothetical' hardware with the following structure
> > for all my responses - it's about as flexible as I think we'll see in the
> > near future - though I'm sure someone has something more complex out there
> > :)
> > 
> > N hardware queues feeding M processing engines in a scheduler driven
> > fashion. Actually we might have P sets of these, but load balancing and
> > tracking and transferring contexts between these is a complexity I think we
> > can ignore. If you want to use more than one of these P you'll just have to
> > handle it yourself in userspace.  Note messages may be shorter than IOCBs
> > which raises another question I've been meaning to ask.  Are all crypto
> > algorithms obliged to run unlimited length IOCBs?  
> 
> There are instances where hardware may reject large data chunks. IIRC I have 
> seen some limits around 32k. But in this case, the driver must chunk up the 
> scatter-gather lists (SGLs) with the data and feed it to the hardware in the 
> chunk size necessary.
> 
> From the kernel crypto API point of view, the driver must support unlimited 
> sized IOCBs / SGLs.

Hmm. This can be somewhat of a pain to do but fair enough (though the limit
in question for us is a lot more than 32k and covers the vast majority of
real use cases)

> > 
> > If there are M messages in a particular queue and none elsewhere it is
> > capable of processing them all at once (and perhaps returning out of order
> > but we can fudge them back in order in the driver to avoid that additional
> > complexity from an interface point of view).
> > 
> > So I'm going to look at this from the hardware point of view - you have
> > well addressed software management above.
> > 
> > Three ways context management can be handled (in CBC this is basically just
> > the IV).
> > 
> > 1. Each 'work item' queued on a hardware queue has it's IV embedded with the
> > data.  This requires external synchronization if we are chaining across
> > multiple 'work items' - note the hardware may have restrictions that mean
> > it has to split large pieces of data up to encrypt them.  Not all hardware
> > may support per 'work item' IVs (I haven't done a survey to find out if
> > everyone does...)
> > 
> > 2. Each queue has a context assigned.  We get a new queue whenever we want
> > to have a different context.  Runs out eventually but our hypothetical
> > hardware may support a lot of queues.  Note this version could be 'faked'
> > by putting a cryptoengine queue on the front of the hardware queues.
> > 
> > 3. The hardware supports IV dependency tracking in it's queues.  That is,
> > it can check if the address pointing to the IV is in use by one of the
> > processing units which has not yet updated the IV ready for chaining with
> > the next message.  Note it might use a magic token rather than the IV
> > pointer.  For modes with out chaining (including counter modes) the IV
> > pointer will inherently always be different.
> > The hardware then simply schedules something else until it can safely
> > run that particular processing unit.  
> 
> The kernel crypto API has the following concept:
> 
> - a TFM holds the data that is stable for an entire cipher operation, such as 
> the key -- one cipher operation may consist of individual calls
> 
> - a request structure holds the volatile data, i.e. the data that is valid for 
> one particular call, such as the input plaintext or the IV
> 
> Thus, your hardware queue should expect one request and it must be capable of 
> handling that one request with the given data. If you want to split up the 
> request because you have sufficient hardware resources as you mentioned above, 
> your driver/hardware must process the request accordingly.
> 
> Coming back to the AF_ALG interface: in order to support the aforementioned 
> "stream" mode, the requests for each cipher call invoked by one recvmsg 
> syscall points to the same IV buffer.
> 
> In case of AIO with multiple IOCBs, user space conceptually calls:
> 
> sendmsg
> recvmsg
> recvmsg
> ..
> 
> where all recvmsg calls execute in parallel. As each recvmsg call has one 
> request associated with it, the question is what happens to a buffer that is 
> pointed to by multiple request structures in such parallel execution.
> 
> If your hardware is capable of serializing the recvmsg calls or tracking the 
> dependency, the current AF_ALG interface is fully sufficient.
> 
> But there may be hardware that cannot/will not track such dependencies. Yet, 
> it has multiple hardware queues. Such hardware can still handle parallel 
> requests when they are totally independent from each other. For such a case, 
> AF_ALG currently has no support, because it lacks the support for setting 
> multiple IVs for the multiple concurrent calls.

Agreed, something like your new support is needed - I just suspect we need
a level between one socket one iv chain and every IOCB with own IV and
right now the only way to hit that balance is to have a separate socket
for each IV chain.  Not exactly efficient use of resources though it will work.

>  
> > > 1. Require that the cipher implementations serialize any AIO requests that
> > > have dependencies. I.e. for CBC, requests need to be serialized by the
> > > driver. For, say, ECB or XTS no serialization is necessary.  
> > 
> > There is a certain requirement to do this anyway as we may have a streaming
> > type situation and we don't want to have to do the chaining in userspace.  
> 
> Absolutely. If you have proper hardware/driver support, that would be 
> beneficial. This would be supported with the current AF_ALG interface.
> 
> But I guess there are also folks out there who simply want to offer multiple 
> hardware queues to allow independent cipher operations to be invoked 
> concurrently without any dependency handling. This is currently not supported 
> with AF_ALG.

I'd argue the multiple hardware queues is supported fine in that it is easy to
have a driver supporting them via separate AF_ALG sockets.  This is what
we are currently doing.  It means that if two processes come along, they can
have their own queues that don't directly influence each other - one isn't
blocked behind another (though they are sharing the processing resources so
will run slower).  One process can of course also open multiple sockets though
with your new patch that becomes less important.

The tricky case is the hardware queues where you want to run multiple contexts
through a single AF_ALG socket with iv chaining not effectively done in userspace.

> > 
> > So we send first X MB block to HW but before it has come back we have more
> > data arrive that needs decrypting so we queue that behind it.  The IV
> > then needs to be updated automatically (or the code needs to do it on the
> > first work item coming back). If you don't have option 3 above, you
> > have to do this.  This is what I was planning to implement for our existing
> > hardware before you raised this question and I don't think we get around
> > it being necessary for performance in any case. Setting up IOMMUs etc is
> > costly so we want to be doing everything we can before the IV update is
> > ready.
> >   
> > > 2. Change AF_ALG to require a per-request IV. This could be implemented by
> > > moving the IV submission via CMSG from sendmsg to recvmsg. I.e. the
> > > recvmsg
> > > code path would obtain the IV.
> > > 
> > > I would tend to favor option 2 as this requires code change at only
> > > location. If option 2 is considered, I would recommend to still allow
> > > setting the IV via sendmsg CMSG (to keep the interface stable). If,
> > > however, the caller provides an IV via recvmsg, this takes precedence.  
> > 
> > We definitely want to keep option 1 (which runs on the existing interface
> > and does the magic in driver) for those who want it.  
> 
> Agreed.
> > 
> > So the only one left is the case 3 above where the hardware is capable
> > of doing the dependency tracking.
> > 
> > We can support that in two ways but one is rather heavyweight in terms of
> > resources.
> > 
> > 1) Whenever we want to allocate a new context we spin up a new socket and
> > effectively associate a single IV with that (and it's chained updates) much
> > like we do in the existing interface.  
> 
> I would not like that because it is too heavyweight. Moreover, considering the 
> kernel crypto API logic, a socket is the user space equivalent of a TFM. I.e. 
> for setting an IV, you do not need to re-instantiate a TFM.

Agreed, though as I mention above if you have multiple processes you probably
want to give them their own resources anyway (own socket and probably hardware
queue if you can spare one) so as to avoid denial of service from one to another.

> > 
> > 2) We allow a token based tracking of IVs.  So userspace code maintains
> > a counter and tags ever message and the initial IV setup with that counter.  
> 
> I think the option I offer with the patch, we have an even more lightweight 
> approach.

Except that I think you have to go all the way back to userspace - unless I
am missing the point - you can't have multiple elements of a stream queued up.
Performance will stink if you have a small number of contexts and can't keep
the processing engines busy.  At the moment option 1 here is the only way
to implement this.

> > 
> > As the socket typically belongs to a userspace process tag creation can
> > be in userspace and it can ensure it doesn't overlap tags (or it'll get
> > the wrong answer).
> > 
> > Kernel driver can then handle making sure any internal token / addresses
> > are correct.  I haven't looked at in depth but would imagine this one
> > would be rather more invasive to support.
> >   
> > > If there are other options, please allow us to learn about them.  
> > 
> > Glad we are addressing these usecases and that we have AIO support in
> > general.  Makes for a better discussion around whether in kernel support
> > for these interfaces is actually as effective as moving to userspace
> > drivers...  
> 
> :-)
> 
> I would like to have more code in user space than in kernel space...

Probably not all of it though, which is basically the alternative here.

Jonathan

> 
> 
> Ciao
> Stephan
> 
> 
