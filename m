From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate	CRC32c algorithm by new crypto API.
Date: Tue, 5 Aug 2008 22:04:36 +0800
Message-ID: <20080805140436.GA23405@gondor.apana.org.au>
References: <1217866496.29139.75.camel@think.oraclecorp.com> <E1KQ3Be-0003T3-00@gondolin.me.apana.org.au> <20080804100605.4f0921f4@infradead.org> <20080804171017.GA13725@gondor.apana.org.au> <20080804171316.GA13819@gondor.apana.org.au> <48983521.9070203@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arjan van de Ven <arjan@infradead.org>,
	Chris Mason <chris.mason@oracle.com>, dwmw2@infradead.org,
	austin_zhang@linux.intel.com, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Helge Hafting <helge.hafting@aitel.hist.no>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48415 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752689AbYHEOE6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Aug 2008 10:04:58 -0400
Content-Disposition: inline
In-Reply-To: <48983521.9070203@aitel.hist.no>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 05, 2008 at 01:10:25PM +0200, Helge Hafting wrote:
>
> How about making crc32c an inline function then?
> On processors that have this feature, this compiles to that single
> instruction, plus whatever setup it needs. Nice and efficient.
> On other processors, either inline the algorithm or inline
> a call to an out of line function, depending on how bulky this is.

Please read the thread carefully.  Being a single instruction
is nothing special.  The same thing applies for other algorithms
too, e.g., AES is also just a single instruction with the VIA
PadLock (and Intel in future).

The crypto API has handled this just fine.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
