From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: af_alg - add async support to algif_aead
Date: Tue, 19 Jan 2016 08:34:28 +0800
Message-ID: <20160119003428.GA5571@gondor.apana.org.au>
References: <20160115192112.3065.45755.stgit@tstruk-mobl1>
 <1641011.7xuR0fALWB@myon.chronox.de>
 <569D034F.5090905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tstruk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50362 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbcASAei (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 19:34:38 -0500
Content-Disposition: inline
In-Reply-To: <569D034F.5090905@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 18, 2016 at 07:22:55AM -0800, Tadeusz Struk wrote:
>
> My understanding is that the sock_kmalloc is mainly used for allocations
> of the user provided  data, because it keeps tracks of how much memory
> is allocated by a socket, and makes sure that is will not exceed the
> sysctl_optmem_max limit. Usually the internal structures, with fixed
> size are allocated simply with kmalloc. I don't think that using
> sock_kmalloc will give us any benefit here.

If there is only ever one of them per-socket then kmalloc is fine,
otherwise you should use sock_kmalloc.

> > The code in the aead_recvmsg_sync and _async is very very similar with the 
> > exception of the areq handling.
> > 
> > What I am wondering, is it possible to consolidate both into one, considering 
> > that the real difference according to my understanding is the 
> > af_alg_wait_for_completion usage (in _sync) vs. the use of a self-written 
> > callback (_async)?
> 
> I agree that they are very similar, but I found it much easier to debug
> when they are separate functions. I would prefer to keep them separate.
> They are also separate in algif_skcipher. It makes it also easier to
> read and understand.

I too would prefer a common function.  However we can do this
later if we wish.
 
> The inflight ctr is incremented only if an asynchronous request has been
> successfully en-queued for processing. If a user forges to call recvmsg
> then the function that increments it won't be even called.
> >From the other hand we don't want to give the option to interrupt the
> wait, because in a case, when we do have request being processed by some
> hardware, and the user kills the process, causing the socket to be
> freed, then we will get an Oops in the callback.

This should be replaced with a sock_hold.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
