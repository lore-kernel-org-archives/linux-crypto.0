From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] lib/mpi: call cond_resched() from mpi_powm() loop
Date: Tue, 7 Nov 2017 14:03:52 -0800
Message-ID: <20171107220352.GB83529@gmail.com>
References: <20171107061951.861-1-ebiggers3@gmail.com>
 <alpine.OSX.2.21.1711070921100.18896@afarcy-mobl1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:49762 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752718AbdKGWD4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 17:03:56 -0500
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.21.1711070921100.18896@afarcy-mobl1.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 07, 2017 at 10:38:30AM -0800, Mat Martineau wrote:
> 
> Eric,
> 
> On Mon, 6 Nov 2017, Eric Biggers wrote:
> 
> >From: Eric Biggers <ebiggers@google.com>
> >
> >On a non-preemptible kernel, if KEYCTL_DH_COMPUTE is called with the
> >largest permitted inputs (16384 bits), the kernel spends 10+ seconds
> >doing modular exponentiation in mpi_powm() without rescheduling.  If all
> >threads do it, it locks up the system.  Moreover, it can cause
> >rcu_sched-stall warnings.
> >
> >Notwithstanding the insanity of doing this calculation in kernel mode
> >rather than in userspace, fix it by calling cond_resched() as each bit
> >from the exponent is processed.  It's still noninterruptible, but at
> >least it's preemptible now.
> 
> cond_resched() is in the outer loop and gets called every
> BITS_PER_LONG bits. That seems to be often enough for the system
> that was taking 10+ seconds, and might be ok for slower processors.
> 
> Was your intent to call cond_resched() for every bit as you
> described in the commit message?
> 

You're right, the cond_resched() is actually once per "limb", not once per bit.

With the largest permitted inputs (16384 bits), each limb of the exponent takes
about 38 milliseconds on an x86_64 CPU.  Therefore on some other CPUs it will
probably take 100+ milliseconds, which is much too long.  So I guess it should
do cond_resched() for each bit.  I'll send a revised patch...

Eric
