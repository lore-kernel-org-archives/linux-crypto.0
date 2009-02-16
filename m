From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Export symbol ksize()
Date: Mon, 16 Feb 2009 09:21:10 +0800
Message-ID: <20090216012110.GA13575@gondor.apana.org.au>
References: <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI> <20090212104349.GA13859@gondor.apana.org.au> <1234435521.28812.165.camel@penberg-laptop> <20090212105034.GC13859@gondor.apana.org.au> <1234454104.28812.175.camel@penberg-laptop> <20090215133638.5ef517ac.akpm@linux-foundation.org> <1234734194.5669.176.camel@calx> <20090215135555.688ae1a3.akpm@linux-foundation.org> <1234741781.5669.204.camel@calx> <20090215170052.44ee8fd5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49731 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754560AbZBPBVh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Feb 2009 20:21:37 -0500
Content-Disposition: inline
In-Reply-To: <20090215170052.44ee8fd5.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 15, 2009 at 05:00:52PM -0800, Andrew Morton wrote:
>
> But kmem_cache_size() would tell you how much extra secret memory there
> is available after the object?
> 
> How that gets along with redzoning is a bit of a mystery though.
> 
> The whole concept is quite hacky and nasty, isn't it?.  Does
> networking/crypto actually show any gain from pulling this stunt?

I see no point in calling ksize on memory that's not kmalloced.
So no there is nothing to be gained from having kmem_cache_ksize.

However, for kmalloced memory we're wasting hundreds of bytes
for the standard 1500 byte allocation without ksize which means
that we're doing reallocations (and sometimes copying) when it
isn't necessary.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
