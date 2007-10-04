From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Revised CTR mode implementation
Date: Thu, 4 Oct 2007 14:35:12 +0800
Message-ID: <20071004063512.GA22945@gondor.apana.org.au>
References: <200710020547.l925l9in011560@faith.austin.ibm.com> <20071003102149.GA8203@gondor.apana.org.au> <20071003102845.GA8364@gondor.apana.org.au> <1191444238.2477.114.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tgraf@suug.sh
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4827 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751050AbXJDGfp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 02:35:45 -0400
Content-Disposition: inline
In-Reply-To: <1191444238.2477.114.camel@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 03, 2007 at 03:43:58PM -0500, Joy Latten wrote:
> On Wed, 2007-10-03 at 18:28 +0800, Herbert Xu wrote:
> > On Wed, Oct 03, 2007 at 06:21:49PM +0800, Herbert Xu wrote:
> > 
> > > static void __ctr_inc_byte(u8 *a, int size)
> > > {
> > > 	__be8 *b = (__be8 *)(a + size);
> > > 	u8 c;
> > > 
> > > 	do {
> > > 		c = be8_to_cpu(*--b) + 1;
> > > 		*b = cpu_to_be8(c);
> > > 		if (c)
> > > 			break;
> > > 	} while (--size);
> > 
> > This should be a for loop and we can make it inline too.
>
> Besides being used in ctr_inc_quad(), isn't __ctr_inc_byte() also
> allowing for counters that might be less than an integer or 4 bytes? 

Yeah I suppose since we're selecting between ctr_inc_32 and
ctr_inc_quad anyway we might as well keep ctr_inc_byte.

Of course the other optino is to throw away ctr_inc_32 and
just call ctr_inc_quad always.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
