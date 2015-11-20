From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add asynchronous compression support
Date: Fri, 20 Nov 2015 14:19:45 +0800
Message-ID: <20151120061945.GA15262@gondor.apana.org.au>
References: <1445008260-39367-1-git-send-email-weigang.li@intel.com>
 <20151016151354.GA16648@gondor.apana.org.au>
 <929511EA6367314D8E32364A24D45FA61301F63F@shsmsx102.ccr.corp.intel.com>
 <20151119094246.GB27655@gondor.apana.org.au>
 <003101d12359$5c1f9450$145ebcf0$@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "'Li, Weigang'" <weigang.li@intel.com>,
	linux-crypto@vger.kernel.org,
	"'Struk, Tadeusz'" <tadeusz.struk@intel.com>,
	'Sergey Senozhatsky' <sergey.senozhatsky.work@gmail.com>,
	minchan@kernel.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38179 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbbKTGTw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Nov 2015 01:19:52 -0500
Content-Disposition: inline
In-Reply-To: <003101d12359$5c1f9450$145ebcf0$@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 20, 2015 at 03:04:47PM +0900, Joonsoo Kim wrote:
>
> Linearization would be enough to use sg-list but it has a problem.
> Linearization needs sleepable function such as vmap() and it makes
> sync (de)compression in atomic context impossible. Currently, zram
> did sync (de)compression in atomic context. It uses map_vm_area() which
> isn't sleepable function to linearize two separate pages. This is possible
> because zram already knows that maximum number of spread pages is just two
> and have allocated vm area in advance. But, if we implement linearization
> in general API, we can't be sure of request input size so we need
> sleepable function, vmap().
> 
> And, this sleep could degrade performance.

Obviously you would only perform linearisation where it's needed.
And if you are in an atomic context, then clearly linearisation
can only be attempted using kmalloc/alloc_pages with GFP_ATOMIC.

I don't understand your concern with zram because either zram is
already feeding us linear buffers in which case linearisation is
never needed.  Or it can only be used with algorithms that support
SG lists or partial updates, which we can easily mark using a flag.

> Intermediate buffer size could vary greatly so it would be allocated and
> Freed whenever requested. This could affect performance.

That's for the crypto user to figure out.  Either they should
supply a completely linear buffer if they want to be able to
support every algorithm in an efficient manner, or they will
either have to eat the cost of linearisation or only use algorithms
that can deal with SG lists efficiently.

We have the same problem with network drivers and it's dealt with
in exactly the same way.  An skb can be an SG list and will be
linearised when necessary.

> I think that supporting unified API has more loss than gain.

I disagree.  I have seen no valid reason so far for adding two
compression interfaces.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
