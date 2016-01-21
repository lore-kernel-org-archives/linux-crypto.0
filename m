From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: af_alg - add async support to algif_aead
Date: Thu, 21 Jan 2016 13:00:21 +0800
Message-ID: <20160121050021.GA4826@gondor.apana.org.au>
References: <20160115192112.3065.45755.stgit@tstruk-mobl1>
 <1641011.7xuR0fALWB@myon.chronox.de>
 <569D034F.5090905@gmail.com>
 <20160119003428.GA5571@gondor.apana.org.au>
 <569FEB90.5020203@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tstruk@gmail.com>,
	Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50992 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbcAUFAd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Jan 2016 00:00:33 -0500
Content-Disposition: inline
In-Reply-To: <569FEB90.5020203@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 20, 2016 at 12:18:24PM -0800, Tadeusz Struk wrote:
>
> I tried sock_kmalloc and it will not work. The sysctl_optmem_max by
> default is 20480 bytes. The aead ctx by itself takes more than half of
> it (11832 bytes). A single async request takes 11408 bytes.
> It means we need to use kmalloc or no async request could be allocated.
> I would opt to go with this version and I'll convert both algif_aead
> and algif_skcipher to use sock_hold later.

Then we have to make it smaller.  The whole point of this is to
stop the user from allocating too much kernel memory, and if you
are allocating too much memory to start with...

So instead of allocating RSGL_MAX_ENTRIES you should turn it into
a linked list like algif_skcipher and then allocate it on demand
using sock_kmalloc.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
