From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2]: salsa20_i586: Corrected order of source and destination buffers.
Date: Mon, 10 Dec 2007 16:09:37 +0800
Message-ID: <20071210080937.GA1058@gondor.apana.org.au>
References: <fd3e431c0712080731w4ead1910gf16a256bc7e58ea9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3367 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750941AbXLJIJl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 03:09:41 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712080731w4ead1910gf16a256bc7e58ea9@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 08, 2007 at 11:31:30PM +0800, Tan Swee Heng wrote:
> 
> Some thoughts:
> I detected this when testing against the large test vector. For small
> test vectors, the blkcipher_walk code uses source and destination
> buffers that are equal. Only near the page boundary, does
> blkcipher_walk uses different buffers. (At least this is true on my
> system from what I've observed.) Since many of the tcrypt test vectors
> are small, therefore src == dst frequently when blkcipher_walk-ing. It
> seems to imply that most of the *_segment() code in the block cipher
> modes are seldom tested. Perhaps this is something that a new tcrypt
> framework should address.

We could change tcrypt to run every test twice, once as in-place
and once as not-in-place.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
