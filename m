From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: authenc - move saved IV in front of the
	ablkcipher request
Date: Wed, 3 Mar 2010 22:41:41 +0800
Message-ID: <20100303144141.GA14231@gondor.apana.org.au>
References: <20100223062109.GD29013@secunet.com> <20100223062237.GE29013@secunet.com> <20100302141049.GB3808@gondor.apana.org.au> <20100303065840.GE20508@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54380 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754296Ab0CCOlo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Mar 2010 09:41:44 -0500
Content-Disposition: inline
In-Reply-To: <20100303065840.GE20508@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 03, 2010 at 07:58:40AM +0100, Steffen Klassert wrote:
> On Tue, Mar 02, 2010 at 10:10:49PM +0800, Herbert Xu wrote:
> > 
> > Hmm, I just noticed that both before and after the patch we're
> > only including the hash request size for the encrypt case, and
> > not the givencrypt case.  Is there a reason for this?
> > 
> 
> Hm, for the moment I don't see what's missing. The ahash request
> size should be the same for both cases. Do you have a hint?

Oh I misinterpreted what the max was trying to do.  I'll apply
you patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
