From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: af_alg - add async support to algif_aead
Date: Wed, 20 Jan 2016 12:18:24 -0800
Message-ID: <569FEB90.5020203@intel.com>
References: <20160115192112.3065.45755.stgit@tstruk-mobl1>
 <1641011.7xuR0fALWB@myon.chronox.de> <569D034F.5090905@gmail.com>
 <20160119003428.GA5571@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tstruk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46425 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbcATUWL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jan 2016 15:22:11 -0500
In-Reply-To: <20160119003428.GA5571@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 01/18/2016 04:34 PM, Herbert Xu wrote:
>> My understanding is that the sock_kmalloc is mainly used for allocations
>> > of the user provided  data, because it keeps tracks of how much memory
>> > is allocated by a socket, and makes sure that is will not exceed the
>> > sysctl_optmem_max limit. Usually the internal structures, with fixed
>> > size are allocated simply with kmalloc. I don't think that using
>> > sock_kmalloc will give us any benefit here.
> If there is only ever one of them per-socket then kmalloc is fine,
> otherwise you should use sock_kmalloc.
> 

I tried sock_kmalloc and it will not work. The sysctl_optmem_max by
default is 20480 bytes. The aead ctx by itself takes more than half of
it (11832 bytes). A single async request takes 11408 bytes.
It means we need to use kmalloc or no async request could be allocated.
I would opt to go with this version and I'll convert both algif_aead
and algif_skcipher to use sock_hold later.
Thanks,

-- 
TS
