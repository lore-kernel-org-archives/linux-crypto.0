From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Mon, 20 Jun 2016 19:48:19 -0400
Message-ID: <20160620234819.GF9848@thunk.org>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <20160620051917.GA8719@gondor.apana.org.au>
 <20160620150147.GD9848@thunk.org>
 <2101992.L9gKN5cFdv@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2101992.L9gKN5cFdv@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 20, 2016 at 05:49:17PM +0200, Stephan Mueller wrote:
> 
> Is speed everything we should care about? What about:
> 
> - offloading of crypto operation from the CPU

In practice CPU offland is not helpful, and in fact, in most cases is
harmful, when one is only encrypting a tiny amount of data.  That's
because the cost of setup and teardown, not to mention key scheduling,
dominate.  This is less of the case in the case of the SIMD / AVX
optimizations --- but that's because these are CPU instructions, and
there really isn't any CPU offloading going on.

> - potentially additional security features a hardware cipher may provide like 
> cache coloring attack resistance?

Um.... have you even taken a *look* at how ChaCha20 is implemented?
*What* cache coloring attack is possible at all, period?

Hint: where are the lookup tables?  Where are the data-dependent
memory accesses in the ChaCha20 core?

						- Ted
