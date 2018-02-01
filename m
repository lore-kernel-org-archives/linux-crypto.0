From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG AIO - lock context IV
Date: Thu, 01 Feb 2018 10:46:35 +0100
Message-ID: <1794487.2xX5c1mbjk@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <20180131122956.000061a3@huawei.com> <CAOtvUMd=T8WkeMRhcF6PzDerzBsszBOCp9x=DpCjQMtLxgTPvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59094 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751520AbeBAJqj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 04:46:39 -0500
In-Reply-To: <CAOtvUMd=T8WkeMRhcF6PzDerzBsszBOCp9x=DpCjQMtLxgTPvg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 1. Februar 2018, 10:35:07 CET schrieb Gilad Ben-Yossef:

Hi Gilad,

> Hi,
> 
> On Wed, Jan 31, 2018 at 2:29 PM, Jonathan Cameron
> 
> <Jonathan.Cameron@huawei.com> wrote:
> > On Tue, 30 Jan 2018 15:51:40 +0000
> > 
> > Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> >> On Tue, 30 Jan 2018 09:27:04 +0100
> > 
> >> Stephan Müller <smueller@chronox.de> wrote:
> > A few clarifications from me after discussions with Stephan this morning.
> > 
> >> > Hi Harsh,
> >> > 
> >> > may I as you to try the attached patch on your Chelsio driver? Please
> >> > invoke the following command from libkcapi:
> >> > 
> >> > kcapi  -d 2 -x 9  -e -c "cbc(aes)" -k
> >> > 8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i
> >> > 7fbc02ebf5b93322329df9bfccb635af -p 48981da18e4bb9ef7e2e3162d16b1910
> >> > 
> >> > The result should now be a fully block-chained result.
> >> > 
> >> > Note, the patch goes on top of the inline IV patch.
> >> > 
> >> > Thanks
> >> > 
> >> > ---8<---
> >> > 
> >> > In case of AIO where multiple IOCBs are sent to the kernel and inline
> >> > IV
> >> > is not used, the ctx->iv is used for each IOCB. The ctx->iv is read for
> >> > the crypto operation and written back after the crypto operation. Thus,
> >> > processing of multiple IOCBs must be serialized.
> >> > 
> >> > As the AF_ALG interface is used by user space, a mutex provides the
> >> > serialization which puts the caller to sleep in case a previous IOCB
> >> > processing is not yet finished.
> >> > 
> >> > If multiple IOCBs arrive that all are blocked, the mutex' FIFO
> >> > operation
> >> > of processing arriving requests ensures that the blocked IOCBs are
> >> > unblocked in the right order.
> >> > 
> >> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > 
> > Firstly, as far as I can tell (not tested it yet) the patch does the
> > job and is about the best we can easily do in the AF_ALG code.
> > 
> > I'd suggest that this (or v2 anyway) is stable material as well
> > (which, as Stephan observed, will require reordering of the two patches).
> > 
> >> As a reference point, holding outside the kernel (in at least
> >> the case of our hardware with 8K CBC) drops us down to around 30%
> >> of performance with separate IVs.  Putting a queue in kernel
> >> (and hence allowing most setup of descriptors / DMA etc) gets us
> >> up to 50% of raw non chained performance.
> >> 
> >> So whilst this will work in principle I suspect anyone who
> >> cares about the cost will be looking at adding their own
> >> software queuing and dependency handling in driver.  How
> >> much that matters will depend on just how quick the hardware
> >> is vs overheads.
> 
> <snip>
> 
> > The differences are better shown with pictures...
> > To compare the two approaches. If we break up the data flow the
> > alternatives are
> > 
> > 1) Mutex causes queuing in AF ALG code
> > 
> > The key thing is the [Build / Map HW Descs] for small packets,
> > up to perhaps 32K, is a significant task we can't avoid.
> > At 8k it looks like it takes perhaps 20-30% of the time
> > (though I only have end to end performance numbers so far)
> > 
> > 
> > [REQUEST 1 from userspace]
> > 
> >            |                  [REQUEST 2 from userspace]
> >     
> >     [AF_ALG/SOCKET]                       |
> >     
> >            |                       [AF_ALG/SOCKET]
> >     
> >     NOTHING BLOCKING (lock mut)           |
> >     
> >            |                        Queued on Mutex
> >  
> >  [BUILD / MAP HW DESCS]                   |
> >  
> >    [Place in HW Queue]                    |
> >    
> >        [Process]                          |
> >       
> >       [Interrupt]                         |
> >  
> >  [Respond and update IV]     Nothing Blocking (lock mut)
> >  
> >            |                    [BUILD / MAP HW DESCS] * AFTER
> >            |                    SERIALIZATION *
> >  
> >  Don't care beyond here.                  |
> >  
> >                                   [Place in HW Queue]
> >                                   
> >                                       [Process]
> >                                      
> >                                      [Interrupt]
> >                                 
> >                                 [Respond and update IV]
> >                                 
> >                                 Don't care beyond here.
> > 
> > 2) The queuing approach I did in the driver moves that serialization
> > to after the BUILD / MAP HW DESCs stage.
> > 
> > [REQUEST 1 from userspace]
> > 
> >            |                  [REQUEST 2 from userspace]
> >     
> >     [AF_ALG/SOCKET]                       |
> >     
> >            |                       [AF_ALG/SOCKET]
> >  
> >  [BUILD / MAP HW DESCS]                   |
> >  
> >            |                     [BUILD / MAP HW DESCS] * BEFORE
> >            |                     SERIALIZATION *
> >  
> >  NOTHING BLOCKING                         |
> >  
> >            |                   IV in flight (enqueue sw queue)
> >    
> >    [Place in HW Queue]                    |
> >    
> >        [Process]                          |
> >       
> >       [Interrupt]                         |
> >  
> >  [Respond and update IV]     Nothing Blocking (dequeue sw queue)
> >  
> >            |                      [Place in HW Queue]
> >  
> >  Don't care beyond here.                  |
> >  
> >                                       [Process]
> >                                      
> >                                      [Interrupt]
> >                                 
> >                                 [Respond and update IV]
> >                                 
> >                                 Don't care beyond here.
> >> 
> >> This maintains chaining when needed and gets a good chunk of the lost
> >> performance back.  I believe (though yet to verify) the remaining lost
> >> performance is mostly down to the fact we can't coalesce interrupts if
> >> chaining.
> >> 
> >> Note the driver is deliberately a touch 'simplistic' so there may be
> >> other
> >> optimization opportunities to get some of the lost performance back or
> >> it may be fundamental due to the fact the raw processing can't be in
> >> parallel.
> > 
> > Quoting a private email from Stephan (at Stephan's suggestion)
> > 
> >> What I however could fathom is that we introduce a flag where a driver
> >> implements its own queuing mechanism. In this case, the mutex handling
> >> would be disregarded.
> > 
> > Which works well for the sort of optimization I did and for hardware that
> > can do iv dependency tracking itself. If hardware dependency tracking was
> > avilable, you would be able to queue up requests with a chained IV
> > without taking any special precautions at all. The hardware would
> > handle the IV update dependencies.
> > 
> > So in conclusion, Stephan's approach should work and give us a nice
> > small patch suitable for stable inclusion.
> > 
> > However, if people know that their setup overhead can be put in parallel
> > with previous requests (even when the IV is not yet updated) then they
> > will
> > probably want to do something inside their own driver and set the flag
> > that Stephan is proposing adding to bypass the mutex approach.
> 
> The patches from Stephan looks good to me, but I think we can do better
> for the long term approach you are discussing.
> 
> Consider that the issue we are dealing with is in no way unique to the
> AF_ALG use case, it just happens to expose it.
> 
> The grander issue is, I believe, that we are missing an API for chained
> crypto operations. One that allows submitting multiple concurrent but
> dependent requests
> to tfm providers.
> 
> Trying to second guess whether or not there is a dependency between calls
> from the address of the IV is not a clean solution. Why don't we make it
> explicit?
> 
> For example, a flag that can be set on a tfm that states that the subsequent
> series of requests are interdependent. If you need a different stream,
> simply allocated anotehr
> tfm object.

But this is already implemented, is it not considering the discussed patches? 
Again, here are the use cases I see for AIO:

- multiple IOCBs which are totally separate and have no interdependencies: the 
inline IV approach

- multiple IOCBs which are interdependent: the current API with the patches 
that we are discussing here (note, a new patch set is coming after the merge 
window)

- if you have several independent invocations of multiple interdependent 
IOCBs: call accept() again on the TFM-FD to get another operations FD. This is 
followed either option one or two above. Note, this is the idea behind the 
kcapi_handle_reinit() call just added to libkcapi. So, you have multiple 
operation-FDs on which you do either interdependent operation or inline IV 
handling.
> 
> This will let each driver do it's best, be it a simple mutex, software
> queuing or hardware
> dependency tracking as the case m may be.

Again, I am wondering that with the discussed patch set we have this 
functionality already.
> 
> Than of course, AF_ALG code (or any other user for that matter) will
> not need to handle
> interdependence, just set the right flag.

The issue is that some drivers simply do not handle this interdependency at 
all -- see the bug report from Harsh.

Thus, the current patch set (again which will be updated after the merge 
window) contains:

1. adding a mutex to AF_ALG to ensure serialization of interdependent calls 
(option 2 from above) irrespective whether the driver implements support for 
it or not.

2. add the inline IV handling (to serve option 1)

3. add a flag that can be set by the crypto implementation. If this flag is 
set, then the mutex of AF_ALG is *not* set assuming that the crypto driver 
handles the serialization.

Note, option 3 from above is implemented in the proper usage of the AF_ALG 
interface.
> 
> Do you think this makes sense?
> 
> Thanks,
> Gilad



Ciao
Stephan
