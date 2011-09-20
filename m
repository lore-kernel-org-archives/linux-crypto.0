From: Sven Schnelle <svens@stackframe.org>
Subject: Re: Kernel OOPS with Freescale talitos driver on ppc
Date: Tue, 20 Sep 2011 09:40:39 +0200
Message-ID: <87zkhz3bm0.fsf@begreifnix.stackframe.org>
References: <877h544vh6.fsf@begreifnix.stackframe.org>
	<20110919162001.e296597e.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: <linux-crypto@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.duncanthrax.net ([89.31.1.170]:33173 "EHLO
	smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab1ITHko (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Sep 2011 03:40:44 -0400
In-Reply-To: <20110919162001.e296597e.kim.phillips@freescale.com> (Kim Phillips's message of "Mon\, 19 Sep 2011 16\:20\:01 -0500")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kim Phillips <kim.phillips@freescale.com> writes:

> On Mon, 19 Sep 2011 13:33:57 +0200
> Sven Schnelle <svens@stackframe.org> wrote:
>
>> Hi Kim,
>> 
>> i'm seeing the following oops on ppc (Freescale P1020):
>> 
>> talitos ffe30000.crypto: cur_desc: (channel 1) 00000000
>> Unable to handle kernel paging request for data at address 0x00000000
>
> You should have seen the "couldn't locate current descriptor" error
> message right before it crashed.

Yes, that message is printed before the oops output. Sorry for cutting
that off in the dmesg output.

>> I've fixed that with the attached patch, however, i have no idea why the
>> SEC engine doesn't return a descriptor pointer in CDPR. As i understand
>> the documentation, it should put the 'currently processed' descriptor
>> there. Can someone shed some light on this?
>
> I believe the CDPR may be overwritten by the time the core gets to
> it if there is another descriptor queued in the channel's fetch
> FIFO.

Hmm, i don't see that there are any other descriptor queued. But i can
add debug later.

> You may be able to glean more information about what happened
> by looking at the ISR execution units done/error bits in isr_lo, the
> descriptor buffer (displayed at the end of report_eu_error), or the
> EU ISRs themselves (see below).

The AESU unit says "data size error", probably because the input data to
aead_decrypt() isn't a multiple of the block size. I'm currently fixing
this in the code. However, i'm not sure if the crypto api or the HW
driver should pad the data to blocksize in such cases.

> fwiw, I just booted a vanilla 3.1-rc6 kernel on a p1020 with your
> config and CONFIG_CRYPTO_MANAGER_DISABLE_TESTS not set, and the
> selftests passed.  IPSec isn't enabled in your config.  Are you
> implementing a new algorithm?  If not, how to reproduce?

It is a custom layer 2 tunneling protocol, which doesn't use IPSec.
That's the reson we don't have that option enabled.

Thanks,

Sven
