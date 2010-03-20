From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Sat, 20 Mar 2010 20:29:59 +0800
Message-ID: <20100320122959.GA1930@gondor.apana.org.au>
References: <20100320010849.GA30654@gondor.apana.org.au> <20100320042103.GB5127@jenkins> <20100320042434.GA32294@gondor.apana.org.au> <20100319.222325.260105122.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: brandon@ifup.org, linux-crypto@vger.kernel.org,
	rusty@rustcorp.com.au
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47534 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751965Ab0CTMaK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Mar 2010 08:30:10 -0400
Content-Disposition: inline
In-Reply-To: <20100319.222325.260105122.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 19, 2010 at 10:23:25PM -0700, David Miller wrote:
>
> I hear what you're saying Herbert, but thinking about this a bit I
> really think we should make this situation work instead of fail.

I think the initial report perhaps painted this in a slight
different fashion than what it really is.  The code that was
looping in module.c is not trying to load libcrc32c, but rather
it is trying to get a reference on the already-loaded libcrc32c
module.

AFAICS the only way to make it "work" would be to reload the
module in question when we can't get a reference on it.  But
that would entail recursively loading a module during the process
of loading another module.

Rusty can chime in on whether this is doable.

I think I have a good guess as to why this problem is occuring
for Brandon.  It is probably the result of two near-simultaneous
modprobes, one issued against libcrc32c and one against bnx2x.

The libcrc32c module is partially loaded to the point of invoking
its init function, which then tries to modprobe crc32c.

However, before this starts the modprobe on bnx2x is already in
progression.  When bnx2x's loading tries to acquire a reference
on libcrc32c which it depends on, we hit the dead-lock.

So if Suse were doing some kind of parallel booting where multiple
modules may be loaded together then this could occur.

The easiest solution again would be for modprobe(8) to block the
loading of bnx2x because the module that it depends on libcrc32c
hasn't yet finished loading.

I'm open to a kernel solution too if anyone has suggestions.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
