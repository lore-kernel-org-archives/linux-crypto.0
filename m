From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Sun, 30 Sep 2007 14:42:39 +0200
Message-ID: <20070930124239.GB24811@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55136 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbXI3Mmm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Sep 2007 08:42:42 -0400
Content-Disposition: inline
In-Reply-To: <20070820120605.GA13163@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-08-20 20:06:05 [+0800]:

>On Mon, Aug 20, 2007 at 12:16:18PM +0200, Andi Kleen wrote:
>> I don't think modprobe knows anything about these priorities.
>
>Right, in that case we'd only load one of them, usually
>the generic one since its name is what we're trying to
>load.
>
>> But that would require teaching the module loading user space
>> about all this first, right?
>
>That would be the best.  However, it's not hard to do a
>simple probing in the kernel until modprobe(8) gets this
>feature.
>
>I'll code something up.

Herbert, I tried to implement a MODULE_PRIO() macro which would be used
by the module loader and I noticed that it may not be required.
If there are two modules providing the same alias and we modprobe that
alias than modprobe will load both of them. It may be a waste of memory
if we load the generic algorithm and the assembly optimized one.
However, it would be good for some hardware drivers which need the
generic implementation for some "corner cases". 
What do you thing?

Sebastian
