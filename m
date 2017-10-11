From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: Fostering linux community collaboration on hardware
 accelerators
Date: Wed, 11 Oct 2017 17:49:57 +0100
Message-ID: <20171011174957.00000f8c@huawei.com>
References: <20171009112425.00003966@huawei.com>
        <CACXcFmk3RDaKo0uasnXBeQvgq8aaX88vExv+GOqMAdZTL7=iXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        John Gilmore <gnu@toad.com>, <linuxarm@huawei.com>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:8006 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751691AbdJKQwJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2017 12:52:09 -0400
In-Reply-To: <CACXcFmk3RDaKo0uasnXBeQvgq8aaX88vExv+GOqMAdZTL7=iXQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 11 Oct 2017 11:51:49 -0400
Sandy Harris <sandyinchina@gmail.com> wrote:

> I shortened the cc list radically. If the discussion continues, it may
> be a good idea to add people back. I added John Gilmore since I cite
> one of his posts below.

Fair enough - I have cc'd back in our internal list for now.
I cynically take the view that people in this community are very
good at ignoring emails they aren't interested in :)

> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> 
> > On behalf of Huawei, I am looking into options to foster a wider community
> > around the various ongoing projects related to Accelerator support within
> > Linux.  The particular area of interest to Huawei is that of harnessing
> > accelerators from userspace, but in a collaborative way with the kernel
> > still able to make efficient use of them, where appropriate.
> >
> > We are keen to foster a wider community than one just focused on
> > our own current technology.  
> 
> Good stuff, but there are problems. e.g. see the thread starting
> with my message here:
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg27274.html

An interesting email - we have heard (and observed) the same
working with the optimized ARM algorithm implementations. In particular
the point about 'when a given implementation is quickest' is important.
This isn't even obvious for the various ARM options available in mainline.

There is almost always more overhead (for now ;) in using a crypto
accelerators than doing it on the CPU which puts an obvious issue
in place for small data packets.

It's not easy - however not all crypto needs to come out of the kernel
again and with care you can avoid duplicating the overheads. e.g. 
* Kernel TLS moves the crypto down into the kernel so data goes in 
  once (which has to happen anyway to get it to the network card).
* Storage encryption - again data is going across the kernel boundary anyway.

> 
> My perspective is that of a crypto guy working on general-purpose
> CPUs, anything from 32-bit ARM up. There are certainly problems for
> devices with massive loads like a high-end router or with more limited
> CPUs that I will not even pretend to address.

Agreed - the application area is certainly not general. This stuff
consumes a lot of silicon - you really have to need it to make it worth
the expense.
 
> For me, far & away the biggest issue is having a good source of random
> numbers; more-or-less all crypto depends on that. The Linux random(4)
> RNG gets close, but there are cases where it may not be well
> initialized soon enough on some systems. If a system provides a
> hardware RNG, I will certainly use it to feed random(4). I do not care
> nearly as much about anything else that might be in a hardware crypto
> accelerator.

Absolutely - that needs to be part of a complete solution.

> 
> Separate accelerator devices require management, separating accesses
> by different kernel threads or by user processes if they are allowed
> to play, keeping them from seeing each other's keys, perhaps saving &
> restoring state sometimes. 

This can be assisted a lot by hardware context management (this look similar
to what you see on high end network cards with things that look like
queue steering etc).  Note, what we are trying to avoid is everything
going full userspace driver stack as has happened for some of those sorts of
systems (e.g. Solarflare's offering)

This hardware is appearing in crypto accelerators - until it is there
I agree this is a really nasty problem - be it perhaps not an unsolvable
one.  There are intermediate levels where the hardware can handle a small
number of contexts but to be truely useful you need to be able to use lots
and have the throughput to support them all with reasonable latency.

> Things that can be built into the CPU --
> RNG instruction or register, AES instructions, Intel's instruction for
> 128-bit finite field multiplication which accelerates AES-GCM,
> probably some I have not heard of -- require less management and are
> usable by  any process, assuming either compiler support or some
> assembler code. As a software guy, I'd far rather the hardware
> designers gave me those than anything that needs a driver.

I absolutely agree. If you can get away with doing crypto
on a CPU (under constraints of power usage and other needs for the cpu)
then do it that way. 

The targets for this stuff are where crypto has become a bottleneck
not cases where a good software implementation is quick enough.

Our initial focus in my team at Huawei, has been crypto partly because we
have a reasonably capable engine to play with - it is just one of
many options moving forward.

Jonathan
