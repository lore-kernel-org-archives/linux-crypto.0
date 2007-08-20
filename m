From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 20:06:05 +0800
Message-ID: <20070820120605.GA13163@gondor.apana.org.au>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3334 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbXHTMGJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 08:06:09 -0400
Content-Disposition: inline
In-Reply-To: <20070820101618.GE16680@bingen.suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 20, 2007 at 12:16:18PM +0200, Andi Kleen wrote:
> 
> The usual use case is: Somebody -- either admin or some command 
> implicitely -- executes modprobe aes because some text file
> specifies the aes cipher. At least on my system that loads
> the C version when both are enabled. modprobe will not load
> multiple modules in this case.
> 
> I don't think modprobe knows anything about these priorities.

Right, in that case we'd only load one of them, usually
the generic one since its name is what we're trying to
load.

> But that would require teaching the module loading user space
> about all this first, right?

That would be the best.  However, it's not hard to do a
simple probing in the kernel until modprobe(8) gets this
feature.

I'll code something up.

> Also if one implementation is always better than the other
> then I see little reason to ever have both.

Well it's not that useful for an assembly implementation
that works on all instances of a given architecture.

However, one of the things we need to handle are drivers
that only work on a subset of an architecture, such as
padlock-aes.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
