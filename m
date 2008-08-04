From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate	CRC32c	algorithm by new crypto API.
Date: Tue, 05 Aug 2008 00:45:34 +0800
Message-ID: <E1KQ3Be-0003T3-00@gondolin.me.apana.org.au>
References: <1217866496.29139.75.camel@think.oraclecorp.com>
Cc: herbert@gondor.apana.org.au, dwmw2@infradead.org,
	austin_zhang@linux.intel.com, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: chris.mason@oracle.com (Chris Mason)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50547 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753238AbYHDQpw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 12:45:52 -0400
In-Reply-To: <1217866496.29139.75.camel@think.oraclecorp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> wrote:
> 
> Great to hear, that solves my main concern then.  There is still the
> embedded argument against needing all of crypto api just for libcrc32c.

The existing users are iSCSI, SCTP, Infiniband, all of which are
clearly crucial in the embedded space :)

> It does make sense to me to have a libcrc32c that does the HW detection
> and uses HW assist when present, and just have the cypto api call that.

Well then you're going to have to do the check on every call.

Seriously, I'm happy to trim off any fat from the crypto API for the
embedded space.  For a start, if you only needed hashing then we
could do without the legacy cipher/compress support.  That shaves
off 800 bytes on i386.  There is also still some legacy code in
api.c itself.  Getting rid of them should get us to around 2K.

On the other hand, one of the advantages of doing it through the
crypto API is that this kind of selection is useful for quite a
few operations, e.g., xor or even memcpy.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
