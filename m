From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: v4.6-rc1 regression bisected, Problem loading in-kernel X.509
 certificate (-2)
Date: Tue, 3 May 2016 15:12:06 +0800
Message-ID: <20160503071206.GB16446@gondor.apana.org.au>
References: <20160430083248.GA20775@cucamonga.audible.transient.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60336 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbcECHMJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 03:12:09 -0400
Content-Disposition: inline
In-Reply-To: <20160430083248.GA20775@cucamonga.audible.transient.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 30, 2016 at 08:32:48AM +0000, Jamie Heilman wrote:
> I usually build my kernels to require module signatures and use
> automatic signing.  As of v4.6-rc1 I'm getting this on boot:
> 
> Problem loading in-kernel X.509 certificate (-2)
> 
> I bisected that to commit d43de6c780a84def056afaf4fb3e66bdaa1efc00
> (akcipher: Move the RSA DER encoding check to the crypto layer)
> 
> For some reason after this commit my system keyring always ends up
> empty.  I use the deb-pkg make target.  My kernel config can
> be found at
> http://audible.transient.net/~jamie/k/modsign.config-4.6.0-rc5-guest
> 
> Let me know if you need anything else.

David, any ideas on this problem? If we can't get a quick fix
on this then we'll have to revert.

Jamie, does reverting this patch by itself resolve the problem?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
