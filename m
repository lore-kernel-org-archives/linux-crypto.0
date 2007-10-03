From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Revised CTR mode implementation
Date: Wed, 3 Oct 2007 18:28:45 +0800
Message-ID: <20071003102845.GA8364@gondor.apana.org.au>
References: <200710020547.l925l9in011560@faith.austin.ibm.com> <20071003102149.GA8203@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tgraf@suug.sh
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4805 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753144AbXJCK2x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Oct 2007 06:28:53 -0400
Content-Disposition: inline
In-Reply-To: <20071003102149.GA8203@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 03, 2007 at 06:21:49PM +0800, Herbert Xu wrote:

> static void __ctr_inc_byte(u8 *a, int size)
> {
> 	__be8 *b = (__be8 *)(a + size);
> 	u8 c;
> 
> 	do {
> 		c = be8_to_cpu(*--b) + 1;
> 		*b = cpu_to_be8(c);
> 		if (c)
> 			break;
> 	} while (--size);

This should be a for loop and we can make it inline too.

static inline void __ctr_inc_byte(u8 *a, int size)
{
	__be8 *b = (__be8 *)(a + size);
	u8 c;

	for (; size; size--) {
		c = b8_to_cpu(*--b) + 1;
		*b = cpu_to_be8(c);
		if (c)
			break;
	}
}
 
> Let's also get rid of the xor selection and just use this xor
> function:
> 
> static void xor_quad(u8 *dst, const u8 *src, unsigned int bs)
> {
> 	u32 *a = (u32 *)dst;
> 	u32 *b = (u32 *)src;
> 
> 	for (; bs >= 4; bs -= 4)
> 		*a++ ^= *b++;
> 
> 	xor_byte((u8 *)a, (u8 *)b, bs);
> }

xor_byte should be constructed in a similar fashion.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
