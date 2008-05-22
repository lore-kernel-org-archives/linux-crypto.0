From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in cbc mode
Date: Thu, 22 May 2008 07:38:32 -0400
Message-ID: <20080522113832.GA12971@hmsendeavour.rdu.redhat.com>
References: <20080521200938.GA29631@hmsreliant.think-freely.org> <20080522000300.GC27138@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3738 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757985AbYEVLis (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 May 2008 07:38:48 -0400
Content-Disposition: inline
In-Reply-To: <20080522000300.GC27138@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 22, 2008 at 08:03:00AM +0800, Herbert Xu wrote:
> On Wed, May 21, 2008 at 04:09:38PM -0400, Neil Horman wrote:
> > Patch to add checking of DES3 test vectors using CBC mode.  FIPS-1402-2
> > compliance mandates that any supported mode of oepration must include a self
> > test.  This satisfies that requirement for cbc(des_ebe).  Tested successfully by
> > me
> 
> Sorry but this makes no sense.  The test vectors you're feeding
> into it are only one block long.  For a single block (and no IV)
> there is no difference between ECB and CBC.  So please add some
> real CBC test vectors for this.
> 
You're right, it doesn't make any sense.  I'm sorry, I'm not sure what I'm
thinking.  I'll repost when I generate some test vectors.  Patch rescinded.
Sorry for the noise.

Regards
Neil

> Thanks,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
