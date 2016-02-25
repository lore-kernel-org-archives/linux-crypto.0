From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Is a crypto_ahash_init required before invoking
 crypto_ahash_import?
Date: Thu, 25 Feb 2016 22:11:34 +0000
Message-ID: <20160225221134.GA27728@gondor.apana.org.au>
References: <56CF788F.5050209@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43082 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbcBYWLj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2016 17:11:39 -0500
Content-Disposition: inline
In-Reply-To: <56CF788F.5050209@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 25, 2016 at 03:56:31PM -0600, Tom Lendacky wrote:
>
> I can fix this in the driver by doing a memset to zero of the request
> context area during the import. But I guess I'm also wondering if there
> is an expectation/requirement that crypto_ahash_init() be called before
> doing an import?  If there is the I can add that to the testmgr code
> instead.

No init means wiping out the hash state so that a new hash can be
computed.  Import means importing the hash state so that computation
can be continued from that point onwards.

So they're independent of each other and you must be able to handle
an import without an init and vice versa.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
