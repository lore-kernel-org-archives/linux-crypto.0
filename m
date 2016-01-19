From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: af_alg - add async support to algif_aead
Date: Tue, 19 Jan 2016 07:18:32 -0800
Message-ID: <569E53C8.9090803@intel.com>
References: <20160115192112.3065.45755.stgit@tstruk-mobl1>
 <1641011.7xuR0fALWB@myon.chronox.de> <569D034F.5090905@gmail.com>
 <20160119003428.GA5571@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tstruk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26921 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbcASPWT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 10:22:19 -0500
In-Reply-To: <20160119003428.GA5571@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/18/2016 04:34 PM, Herbert Xu wrote:
>> My understanding is that the sock_kmalloc is mainly used for allocations
>> > of the user provided  data, because it keeps tracks of how much memory
>> > is allocated by a socket, and makes sure that is will not exceed the
>> > sysctl_optmem_max limit. Usually the internal structures, with fixed
>> > size are allocated simply with kmalloc. I don't think that using
>> > sock_kmalloc will give us any benefit here.
> If there is only ever one of them per-socket then kmalloc is fine,
> otherwise you should use sock_kmalloc.

There is one per request. There can be a few of them at a given time.
We have the same thing in skcipher and we use kmalloc there. 

> 
>> I agree that they are very similar, but I found it much easier to debug
>> > when they are separate functions. I would prefer to keep them separate.
>> > They are also separate in algif_skcipher. It makes it also easier to
>> > read and understand.
> I too would prefer a common function.  However we can do this
> later if we wish.
>  

lets do this later then.

> 
>> > The inflight ctr is incremented only if an asynchronous request has been
>> > successfully en-queued for processing. If a user forges to call recvmsg
>> > then the function that increments it won't be even called.
>> > >From the other hand we don't want to give the option to interrupt the
>> > wait, because in a case, when we do have request being processed by some
>> > hardware, and the user kills the process, causing the socket to be
>> > freed, then we will get an Oops in the callback.
> This should be replaced with a sock_hold.

Ok, I will try sock_hold.
Thanks,

-- 
TS
