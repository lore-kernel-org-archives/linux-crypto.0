From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/5] camellia: cleanup
Date: Tue, 6 Nov 2007 22:21:04 +0800
Message-ID: <20071106142104.GC24423@gondor.apana.org.au>
References: <200710251243.58701.vda.linux@googlemail.com> <200710251246.35917.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3272 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751441AbXKFOVL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 09:21:11 -0500
Content-Disposition: inline
In-Reply-To: <200710251246.35917.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 25, 2007 at 12:46:35PM +0100, Denys Vlasenko wrote:
> On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> > Hi Hervert,
> > 
> > Please review and maybe propagate upstream following patches.
> > 
> > camellia3.diff
> >     Optimize GETU32 to use 4-byte memcpy (modern gcc will convert
> >     such memcpy to single move instruction on i386).
> >     Original GETU32 did four byte fetches, and shifted/XORed those.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Patch applied.

> +# define GETU32(v, pt) \
> +    do { \
> +	/* latest breed of gcc is clever enough to use move */ \
> +	memcpy(&(v), (pt), 4); \
> +	(v) = be32_to_cpu(v); \
> +    } while(0)

You can get rid of this memcpy too since camellia declares an
alignmask of 3 which means that the key is 32-bit aligned.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
