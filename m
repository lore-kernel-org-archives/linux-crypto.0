From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: AF_ALG AIO - lock context IV
Date: Thu, 1 Feb 2018 11:35:07 +0200
Message-ID: <CAOtvUMd=T8WkeMRhcF6PzDerzBsszBOCp9x=DpCjQMtLxgTPvg@mail.gmail.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <2165621.DHQGk8sIp3@positron.chronox.de>
 <51c57076-4a01-308c-583b-8c34afc3b2e4@chelsio.com> <11410454.xUfCo2NHDh@positron.chronox.de>
 <20180130155140.000038b5@huawei.com> <20180131122956.000061a3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:41234 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbeBAJfJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 04:35:09 -0500
Received: by mail-ua0-f196.google.com with SMTP id f5so11387839ual.8
        for <linux-crypto@vger.kernel.org>; Thu, 01 Feb 2018 01:35:08 -0800 (PST)
In-Reply-To: <20180131122956.000061a3@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Wed, Jan 31, 2018 at 2:29 PM, Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
> On Tue, 30 Jan 2018 15:51:40 +0000
> Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
>
>> On Tue, 30 Jan 2018 09:27:04 +0100
>> Stephan M=C3=BCller <smueller@chronox.de> wrote:
>
> A few clarifications from me after discussions with Stephan this morning.
>
>>
>> > Hi Harsh,
>> >
>> > may I as you to try the attached patch on your Chelsio driver? Please =
invoke
>> > the following command from libkcapi:
>> >
>> > kcapi  -d 2 -x 9  -e -c "cbc(aes)" -k
>> > 8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i
>> > 7fbc02ebf5b93322329df9bfccb635af -p 48981da18e4bb9ef7e2e3162d16b1910
>> >
>> > The result should now be a fully block-chained result.
>> >
>> > Note, the patch goes on top of the inline IV patch.
>> >
>> > Thanks
>> >
>> > ---8<---
>> >
>> > In case of AIO where multiple IOCBs are sent to the kernel and inline =
IV
>> > is not used, the ctx->iv is used for each IOCB. The ctx->iv is read fo=
r
>> > the crypto operation and written back after the crypto operation. Thus=
,
>> > processing of multiple IOCBs must be serialized.
>> >
>> > As the AF_ALG interface is used by user space, a mutex provides the
>> > serialization which puts the caller to sleep in case a previous IOCB
>> > processing is not yet finished.
>> >
>> > If multiple IOCBs arrive that all are blocked, the mutex' FIFO operati=
on
>> > of processing arriving requests ensures that the blocked IOCBs are
>> > unblocked in the right order.
>> >
>> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
>
> Firstly, as far as I can tell (not tested it yet) the patch does the
> job and is about the best we can easily do in the AF_ALG code.
>
> I'd suggest that this (or v2 anyway) is stable material as well
> (which, as Stephan observed, will require reordering of the two patches).
>
>>
>> As a reference point, holding outside the kernel (in at least
>> the case of our hardware with 8K CBC) drops us down to around 30%
>> of performance with separate IVs.  Putting a queue in kernel
>> (and hence allowing most setup of descriptors / DMA etc) gets us
>> up to 50% of raw non chained performance.
>>
>> So whilst this will work in principle I suspect anyone who
>> cares about the cost will be looking at adding their own
>> software queuing and dependency handling in driver.  How
>> much that matters will depend on just how quick the hardware
>> is vs overheads.
>>

<snip>

>
> The differences are better shown with pictures...
> To compare the two approaches. If we break up the data flow the
> alternatives are
>
> 1) Mutex causes queuing in AF ALG code
>
> The key thing is the [Build / Map HW Descs] for small packets,
> up to perhaps 32K, is a significant task we can't avoid.
> At 8k it looks like it takes perhaps 20-30% of the time
> (though I only have end to end performance numbers so far)
>
>
> [REQUEST 1 from userspace]
>            |                  [REQUEST 2 from userspace]
>     [AF_ALG/SOCKET]                       |
>            |                       [AF_ALG/SOCKET]
>     NOTHING BLOCKING (lock mut)           |
>            |                        Queued on Mutex
>  [BUILD / MAP HW DESCS]                   |
>            |                              |
>    [Place in HW Queue]                    |
>            |                              |
>        [Process]                          |
>            |                              |
>       [Interrupt]                         |
>            |                              |
>  [Respond and update IV]     Nothing Blocking (lock mut)
>            |                    [BUILD / MAP HW DESCS] * AFTER SERIALIZAT=
ION *
>  Don't care beyond here.                  |
>                                   [Place in HW Queue]
>                                           |
>                                       [Process]
>                                           |
>                                      [Interrupt]
>                                           |
>                                 [Respond and update IV]
>                                           |
>                                 Don't care beyond here.
>
>
> 2) The queuing approach I did in the driver moves that serialization
> to after the BUILD / MAP HW DESCs stage.
>
> [REQUEST 1 from userspace]
>            |                  [REQUEST 2 from userspace]
>     [AF_ALG/SOCKET]                       |
>            |                       [AF_ALG/SOCKET]
>  [BUILD / MAP HW DESCS]                   |
>            |                     [BUILD / MAP HW DESCS] * BEFORE SERIALIZ=
ATION *
>  NOTHING BLOCKING                         |
>            |                   IV in flight (enqueue sw queue)
>    [Place in HW Queue]                    |
>            |                              |
>        [Process]                          |
>            |                              |
>       [Interrupt]                         |
>            |                              |
>  [Respond and update IV]     Nothing Blocking (dequeue sw queue)
>            |                      [Place in HW Queue]
>  Don't care beyond here.                  |
>                                       [Process]
>                                           |
>                                      [Interrupt]
>                                           |
>                                 [Respond and update IV]
>                                           |
>                                 Don't care beyond here.
>
>>
>> This maintains chaining when needed and gets a good chunk of the lost
>> performance back.  I believe (though yet to verify) the remaining lost
>> performance is mostly down to the fact we can't coalesce interrupts if
>> chaining.
>>
>> Note the driver is deliberately a touch 'simplistic' so there may be oth=
er
>> optimization opportunities to get some of the lost performance back or
>> it may be fundamental due to the fact the raw processing can't be in
>> parallel.
>>
>
> Quoting a private email from Stephan (at Stephan's suggestion)
>
>> What I however could fathom is that we introduce a flag where a driver
>> implements its own queuing mechanism. In this case, the mutex handling w=
ould
>> be disregarded.
>
> Which works well for the sort of optimization I did and for hardware that
> can do iv dependency tracking itself. If hardware dependency tracking was
> avilable, you would be able to queue up requests with a chained IV
> without taking any special precautions at all. The hardware would
> handle the IV update dependencies.
>
> So in conclusion, Stephan's approach should work and give us a nice
> small patch suitable for stable inclusion.
>
> However, if people know that their setup overhead can be put in parallel
> with previous requests (even when the IV is not yet updated) then they wi=
ll
> probably want to do something inside their own driver and set the flag
> that Stephan is proposing adding to bypass the mutex approach.
>

The patches from Stephan looks good to me, but I think we can do better
for the long term approach you are discussing.

Consider that the issue we are dealing with is in no way unique to the AF_A=
LG
use case, it just happens to expose it.

The grander issue is, I believe, that we are missing an API for chained cry=
pto
operations. One that allows submitting multiple concurrent but
dependent requests
to tfm providers.

Trying to second guess whether or not there is a dependency between calls f=
rom
the address of the IV is not a clean solution. Why don't we make it explici=
t?

For example, a flag that can be set on a tfm that states that the subsequen=
t
series of requests are interdependent. If you need a different stream,
simply allocated anotehr
tfm object.

This will let each driver do it's best, be it a simple mutex, software
queuing or hardware
dependency tracking as the case m may be.

Than of course, AF_ALG code (or any other user for that matter) will
not need to handle
interdependence, just set the right flag.

Do you think this makes sense?

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
