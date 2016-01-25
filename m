From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: ccp - Add hash state import and export support
Date: Mon, 25 Jan 2016 15:20:44 +0800
Message-ID: <20160125072044.GB5609@gondor.apana.org.au>
References: <20160112171738.23496.44254.stgit@tlendack-t1.amdoffice.net>
 <56A26568.3000806@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49115 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbcAYHUt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 02:20:49 -0500
Content-Disposition: inline
In-Reply-To: <56A26568.3000806@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 22, 2016 at 11:22:48AM -0600, Tom Lendacky wrote:
> On 01/12/2016 11:17 AM, Tom Lendacky wrote:
> > Commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
> > added a check to prevent ahash algorithms from successfully registering
> > if the import and export functions were not implemented. This prevents
> > an oops in the hash_accept function of algif_hash. This commit causes
> > the ccp-crypto module SHA support and AES CMAC support from successfully
> > registering and causing the ccp-crypto module load to fail because the
> > ahash import and export functions are not implemented.
> > 
> > Update the CCP Crypto API support to provide import and export support
> > for ahash algorithms.
> > 
> > Cc: <stable@vger.kernel.org> # 3.14.x-
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Herbert, is it possible this patch can be part of Crypto Fixes for 4.5?

While your patch is probably OK the rctx structure just contains
too much crap for me to feel safe about pushing this in at this
point in time.  So I'd like to have it cook for another cycle.

The reason I'm overly cautious is because import/export is directly
exposed to user-space so if we get this wrong then we may open
up a root hole.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
