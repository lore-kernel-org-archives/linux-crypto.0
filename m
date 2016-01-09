From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: algif_hash bug?
Date: Sat, 9 Jan 2016 13:42:38 +0800
Message-ID: <20160109054238.GB11188@gondor.apana.org.au>
References: <56902232.2010309@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47049 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbcAIFml (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jan 2016 00:42:41 -0500
Content-Disposition: inline
In-Reply-To: <56902232.2010309@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 08, 2016 at 02:55:14PM -0600, Tom Lendacky wrote:
> 
> AF_ALG hash supports the accept() call to allow for partial hash states
> to be cloned. If an accept() is issued against a socket before ever
> doing a send(), crypto_ahash_init() will never have been called for the
> original socket.  The hash_accept function in algif_hash will call
> crypto_ahash_export() which will return an uninitialized request context
> and then use that for import into the new socket. A problem arises here
> because hash_accept sets the 'more' bit of the new context to 1
> (ctx2->more = 1). This will cause the first send() call for the new
> socket to skip calling crypto_ahash_init() which can result in an
> error or oops because the request context for the cloned socket was
> never initialized.
> 
> Is it assumed that the accept() call should only ever be made after
> having issued at least one send()? Should the ctx2->more value be the
> value from the original context so that crypto_ahash_init() is called
> when needed?

I thought we've already fixed this bug with

commit 4afa5f9617927453ac04b24b584f6c718dfb4f45
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Nov 1 17:11:19 2015 +0800

    crypto: algif_hash - Only export and import on sockets with data

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
