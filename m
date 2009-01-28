From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Force panic on continuous CPRNG test failure
	when in FIPS mode
Date: Wed, 28 Jan 2009 23:17:41 +1100
Message-ID: <20090128121741.GA17496@gondor.apana.org.au>
References: <20090123155817.GA29548@hmsreliant.think-freely.org> <20090128041828.GB13157@gondor.apana.org.au> <20090128121511.GA6361@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44049 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751217AbZA1MRo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Jan 2009 07:17:44 -0500
Content-Disposition: inline
In-Reply-To: <20090128121511.GA6361@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 28, 2009 at 07:15:11AM -0500, Neil Horman wrote:
> On Wed, Jan 28, 2009 at 03:18:28PM +1100, Herbert Xu wrote:
> > 
> > I'm OK with this change but I'd like it to look like:
> > 
> > 	if (fips_enabled) {
> > 		panic(...)
> > 	}
> > 
> > 	blah blah blah
> > 
> > This way the FIPS crap doesn't get in the way of everyday use.
> > 
> > Thanks,
> 
> 
> Sure, new patch, extra commentary removed.  Also brought the panic/printk text
> into agreement.

Hmm no I wasn't referring to the comment, but rather that you
should just move the stuff in the else branch into the main code
path since the panic makes the else redundant.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
