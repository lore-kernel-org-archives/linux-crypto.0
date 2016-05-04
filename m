From: tytso@thunk.org
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Wed, 4 May 2016 19:07:23 +0000
Message-ID: <20160504190723.GD3901@thunk.org>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-2-git-send-email-tytso@mit.edu>
 <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
 <20160504174901.GC3901@thunk.org>
 <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
 <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: noloader@gmail.com, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, jsd@av8n.com,
	linux-crypto@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46768 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbcEDTHn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 15:07:43 -0400
Content-Disposition: inline
In-Reply-To: <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 04, 2016 at 11:29:57AM -0700, H. Peter Anvin wrote:
> 
> We don't care about UB, we care about gcc, and to a lesser extent
> LLVM and ICC.  If bitops.h doesn't do the right thing, we need to
> fix bitops.h.

I'm going to suggest that we treat the ro[rl]{32,64}() question as
separable from the /dev/random case.  I've sanity checked gcc 5.3.1
and it does the right thing given the small number of constant
arguments given to rotl32() in lib/chacha20.c, and it doesn't hit the
UB case which Jeffrey was concerned about.  This is also code that was
previously in crypto/chacha20_generic.c, and so if there is a bug with
some obscure compiler not properly compiling it down to a rotate
instruction, (a) no one is paying me to make sure the kernel code
compiles well on ICC, and (b) it's not scalable to have each kernel
developer try to deal with the vagrancies of compilers.

So from my perspective, the only interesting results for me is (a)
using what had been used before with crypto/chacha20_generic.c, or (b)
reusing what is in bitops.h and letting it be someone else's problem
if some obscure compiler isn't happy with what is in bitops.h

If we are all agreed that what is in bitops.h is considered valid,
then we can start converting people over to using the version defined
in bitops.h, and if there is some compiler issue we need to work
around, at least we only need to put the workaround in a single header
file.

Cheers,
					- Ted
