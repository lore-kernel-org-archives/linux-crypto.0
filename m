From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add optional continuous repetition test to
	entropy store based rngs
Date: Sat, 13 Jun 2009 00:26:45 +1000
Message-ID: <20090612142644.GA15644@gondor.apana.org.au>
References: <20090604195030.GA11300@hmsreliant.think-freely.org> <1244146450.22069.216.camel@calx> <20090605000456.GA10883@localhost.localdomain> <20090605003006.GA5236@gondor.apana.org.au> <20090605014816.GA15462@localhost.localdomain> <20090612142308.GA29341@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33481 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755100AbZFLO0x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Jun 2009 10:26:53 -0400
Content-Disposition: inline
In-Reply-To: <20090612142308.GA29341@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 12, 2009 at 10:23:08AM -0400, Neil Horman wrote:
>
> > Ok, that seems like a reasonable idea.  new patch below
> > Change Notes:
> > 
> > 1) Moved fips_enabled flag into its own header, included in all the appropriate
> > places
> > 
> > 2) removed flags field from entropy store, keying continuous test on the
> > non-null status of the last_data pointer
> > 
> > 
> > FIPS-140 requires that all random number generators implement continuous self
> > tests in which each extracted block of data is compared against the last block
> > for repetition.  The ansi_cprng implements such a test, but it would be nice if
> > the hw rng's did the same thing.  Obviously its not something thats always
> > needed, but it seems like it would be a nice feature to have on occasion. I've
> > written the below patch which allows individual entropy stores to be flagged as
> > desiring a continuous test to be run on them as is extracted.  By default this
> > option is off, but is enabled in the event that fips mode is selected during
> > bootup.
> > 
> > Neil
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> Ping, I don't see that this got picked up in the crypto tree.  Are there
> subsequent objections?

Matt, are you OK with me picking this up or do you want to pick it
up?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
