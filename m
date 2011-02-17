From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: sha1 - Add test vector to test partial block processing
Date: Fri, 18 Feb 2011 07:52:26 +1100
Message-ID: <20110217205226.GA21423@gondor.apana.org.au>
References: <20110207092817.GA16881@gondor.apana.org.au> <1297082827.11137.15.camel@bender> <20110217032557.GA12955@gondor.apana.org.au> <1297955462.3547.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:49332 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab1BQUwc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Feb 2011 15:52:32 -0500
Content-Disposition: inline
In-Reply-To: <1297955462.3547.14.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 17, 2011 at 04:11:02PM +0100, Jan Glauber wrote:
> Hi Herbert,
> 
> good idea. I ended up with using openssl to create a test vector for
> that special case but a published test vector is of course better.
> 
> With your sha patch applied sha1_s390 survives the tcrypt test.

Could you check if sha1_s390 fails the test without the patch?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
